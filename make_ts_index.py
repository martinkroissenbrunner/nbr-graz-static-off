import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client, CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext, normalize_string
from tqdm import tqdm


files = glob.glob("./data/editions/*.xml")
tag_blacklist = ["{http://www.tei-c.org/ns/1.0}abbr"]

COLLECTION_NAME = "nbr-graz"


try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": COLLECTION_NAME,
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string", "sort": True},
        {"name": "rec_id", "type": "string", "sort": True},
        {"name": "title", "type": "string", "sort": True},
        {"name": "full_text", "type": "string", "sort": True},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
            "sort": True,
        },
        {
            "name": "sender",
            "type": "string[]",
            "optional": True,
            "facet": True,
            "sort": False,
        },
        {
            "name": "receiver",
            "type": "string[]",
            "optional": True,
            "facet": True,
            "sort": False,
        },
        {
            "name": "volume",
            "type": "string",
            "optional": True,
            "facet": True,
            "sort": False,
        },
    ],
}

client.collections.create(current_schema)
dates = set()
records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": COLLECTION_NAME,
    }
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        continue
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = (
        f"https://nuntiaturberichte.github.io/nbr-graz-static/{record['id']}.html"
    )
    record["rec_id"] = os.path.split(x)[-1].replace(".xml", "")
    try:
        year = doc.any_xpath(
            ".//tei:titleStmt/tei:title[@type='iso-date' and @when-iso]"
        )[0].attrib["when-iso"]
    except IndexError:
        year = ""
    if len(year) > 4:
        record["year"] = int(year[:4])
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = extract_fulltext(
        doc.any_xpath(".//tei:titleStmt/tei:title[@level='a']")[0]
    )

    record["volume"] = doc.any_xpath(".//tei:biblScope[@unit='volume']")[0].text
    record["sender"] = []
    cfts_record["persons"] = []
    for y in doc.any_xpath(".//tei:correspAction[@type='sent']//tei:persName"):
        record["sender"].append(normalize_string(y.text))
        cfts_record["persons"].append(normalize_string(y.text))

    record["receiver"] = []
    cfts_record["persons"] = []
    for y in doc.any_xpath(
        ".//tei:correspAction[@type='received']//tei:persName"
    ):  # noqa:
        record["receiver"].append(normalize_string(y.text))
        cfts_record["persons"].append(normalize_string(y.text))

    record["lecture"] = record["title"].split("(")[0].strip()
    cfts_record["title"] = record["title"]
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"done with indexing {COLLECTION_NAME}")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print(f"done with cfts-index {COLLECTION_NAME}")
