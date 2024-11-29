<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="tabulator_js_register">
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.5/dist/js/tabulator.min.js"/>
        <script src="tabulator-js/config.js"/>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
            var table = new Tabulator("#tabulator-table-register", {
            pagination: "local",  // Paginierung aktivieren
            paginationSize: 25,   // 25 Zeilen pro Seite anzeigen
            paginationCounter: "rows",  // Anzeige der Seitenanzahl im Footer
            langs: {
            "de-de": { // Deutsche Sprachdefinition
            "pagination": {
            "first": "Erste",
            "first_title": "Erste Seite",
            "last": "Letzte",
            "last_title": "Letzte Seite",
            "prev": "Vorige",
            "prev_title": "Vorige Seite",
            "next": "Nächste",
            "next_title": "Nächste Seite",
            "all": "Alle",
            "counter": {
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten",
            }
            },
            },
            },
            locale: "de-de",  // Sprache auf Deutsch setzen
            layout: "fitColumns",  // Spaltenbreite automatisch anpassen
            columns: [
            {title:"Begriff (1. Ebene)", field:"begriff_1_ebene", headerFilter:"input", headerFilterPlaceholder:"... suchen", cssClass:"wrap-cell"},
            {title:"Begriff (2. Ebene)", field:"begriff_2_ebene", cssClass:"wrap-cell"},
            {title:"Verweis", field:"verweis", cssClass:"wrap-cell"},
            {title:"Seiten (1. Band)", field:"seiten_1_band", formatter:"html", cssClass:"wrap-cell"},
            {title:"Seiten (2. Band)", field:"seiten_2_band", formatter:"html", cssClass:"wrap-cell"},
            {title:"Seiten (3. Band)", field:"seiten_3_band", formatter:"html", cssClass:"wrap-cell"},
            {title:"Seiten (4. Band)", field:"seiten_4_band", formatter:"html", cssClass:"wrap-cell"},
            {title:"Seiten (5. Band)", field:"seiten_5_band", formatter:"html", cssClass:"wrap-cell"},
            ],
            // Daten aus der bestehenden Tabelle extrahieren
            tableBuilt: function(){
            this.setDataFromHTML();
            }
            });
            
            // Button-Event-Listener hinzufügen
            document.getElementById("download-csv").addEventListener("click", function(){
            table.download("csv", "data.csv");
            });
            
            document.getElementById("download-json").addEventListener("click", function(){
            table.download("json", "data.json");
            });
            
            document.getElementById("download-html").addEventListener("click", function(){
            table.download("html", "data.html", {style:true});
            });
            
            // Verstecke den Loader nach einer Verzögerung
            setTimeout(function(){
            document.getElementById('loader').style.display = 'none';
            document.getElementById('tabulator-table-wrapper').style.display = 'block';
            }); // 2 Sekunden Timeout
            });
        </script>
    </xsl:template>

    <xsl:template match="/" name="tabulator_js_postwege">
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.5/dist/js/tabulator.min.js"/>
        <script src="tabulator-js/config.js"/>
        <script>
            var table = new Tabulator("#tabulator-table-postwege", {
            // Layout und allgemeine Einstellungen
            layout: "fitColumns",           // Layout: Spalten passen sich an
            responsiveLayout: true,         // Responsives Layout aktivieren
            movableColumns: true,           // Spalten verschiebbar machen
            locale: "de-de",                // Lokalisierung auf Deutsch
            pagination: "local",            // Lokale Paginierung
            paginationSize: 25,             // 25 Reihen pro Seite anzeigen
            paginationCounter: "rows",      // Zeilenanzahl im Footer anzeigen
            
            // Sortierung
            initialSort: [
            { column: "sendedatum", dir: "asc" } // Initiale Sortierung nach Sendedatum
            ],
            
            // Übersetzungen
            langs: {
            "de-de": {
            pagination: {
            first: "Erste",
            first_title: "Erste Seite",
            last: "Letzte",
            last_title: "Letzte Seite",
            prev: "Vorige",
            prev_title: "Vorige Seite",
            next: "Nächste",
            next_title: "Nächste Seite",
            all: "Alle",
            counter: {
            showing: "Zeige",
            of: "von",
            rows: "Reihen",
            pages: "Seiten"
            }
            }
            }
            },
            
            // Spaltenkonfiguration
            columns: [
            // Spalte: Bandnummer
            {
            title: "Bandnummer",
            field: "bandnummer",
            formatter: "html",
            width: "10%",
            headerFilter: "list",
            headerFilterPlaceholder: "... wählen",
            
            // Funktion, um Werte dynamisch für das Dropdown-Feld zu generieren
            headerFilterParams: {
            valuesLookup: function (cell) {
            let table = cell.getTable();
            let field = cell.getColumn().getField();
            let data = table.getData("active");
            
            // Eindeutige Werte sammeln und leere Option hinzufügen
            let uniqueValues = Array.from(new Set(data.map(row => row[field])));
            uniqueValues = uniqueValues.filter(v => v !== "").sort(); // Sortiere Werte, außer die leeren
            uniqueValues.unshift(""); // Leere Option an den Anfang
            
            // Erstelle Dropdown-Optionen mit Labels
            return uniqueValues.map(value => ({
            label: value === "" ? "... wählen" : value, // Label für die leere Option
            value: value
            }));
            }
            },
            },
            
            // Spalte: Briefnummer
            {
            title: "Briefnummer",
            field: "briefnummer",
            headerFilter: "input",
            headerFilterPlaceholder: "... eingeben",
            formatter: "html",
            width: "10%"
            },
            
            // Spalte: Titel
            {
            title: "Titel",
            field: "titel",
            headerFilter: "input",
            headerFilterPlaceholder: "... eingeben",
            formatter: "html",
            width: "40%"
            },
            
            // Spalte: Sender
            {
            title: "Sender",
            field: "sender",
            formatter: "html",
            width: "10%",
            headerFilter: "list",
            headerFilterPlaceholder: "... wählen",
            
            // Funktion, um Werte dynamisch für das Dropdown-Feld zu generieren
            headerFilterParams: {
            valuesLookup: function (cell) {
            let table = cell.getTable();
            let field = cell.getColumn().getField();
            let data = table.getData("active");
            
            // Eindeutige Werte sammeln und leere Option hinzufügen
            let uniqueValues = Array.from(new Set(data.map(row => row[field])));
            uniqueValues = uniqueValues.filter(v => v !== "").sort(); // Sortiere Werte, außer die leeren
            uniqueValues.unshift(""); // Leere Option an den Anfang
            
            // Erstelle Dropdown-Optionen mit Labels
            return uniqueValues.map(value => ({
            label: value === "" ? "... wählen" : value, // Label für die leere Option
            value: value
            }));
            }
            },
            
            // Funktion, um HTML-Tags aus den Werten zu entfernen
            accessor: function (value) {
            const div = document.createElement("div");
            div.innerHTML = value; // HTML-Inhalte entfernen
            return div.textContent || div.innerText || "";
            },
            
            // Filterfunktion: Prüft, ob der Wert mit dem Filter übereinstimmt
            headerFilterFunc: function (headerValue, rowValue) {
            const div = document.createElement("div");
            div.innerHTML = rowValue;
            const plainTextValue = div.textContent || div.innerText || "";
            return headerValue === "" || plainTextValue === headerValue; // Filterlogik
            },
            },
            
            // Spalte: Empfänger
            {
            title: "Empfänger",
            field: "empfänger",
            formatter: "html",
            width: "10%",
            headerFilter: "list",
            headerFilterPlaceholder: "... wählen",
            
            // Funktion, um Werte dynamisch für das Dropdown-Feld zu generieren
            headerFilterParams: {
            valuesLookup: function (cell) {
            let table = cell.getTable();
            let field = cell.getColumn().getField();
            let data = table.getData("active");
            
            // Eindeutige Werte sammeln und leere Option hinzufügen
            let uniqueValues = Array.from(new Set(data.map(row => row[field])));
            uniqueValues = uniqueValues.filter(v => v !== "").sort(); // Sortiere Werte, außer die leeren
            uniqueValues.unshift(""); // Leere Option an den Anfang
            
            // Erstelle Dropdown-Optionen mit Labels
            return uniqueValues.map(value => ({
            label: value === "" ? "... wählen" : value, // Label für die leere Option
            value: value
            }));
            }
            },
            
            // Funktion, um HTML-Tags aus den Werten zu entfernen
            accessor: function (value) {
            const div = document.createElement("div");
            div.innerHTML = value; // HTML-Inhalte entfernen
            return div.textContent || div.innerText || "";
            },
            
            // Filterfunktion: Prüft, ob der Wert mit dem Filter übereinstimmt
            headerFilterFunc: function (headerValue, rowValue) {
            const div = document.createElement("div");
            div.innerHTML = rowValue;
            const plainTextValue = div.textContent || div.innerText || "";
            return headerValue === "" || plainTextValue === headerValue; // Filterlogik
            },
            },
            
            // Spalte: Sendedatum
            {
            title: "Sendedatum",
            field: "sendedatum",
            headerFilter: "input",
            headerFilterPlaceholder: "... eingeben",
            formatter: "html",
            width: "10%"
            },
            
            // Spalte: Sendeort
            {
            title: "Sendeort",
            field: "sendeort",
            formatter: "html",
            width: "10%",
            headerFilter: "list",
            headerFilterPlaceholder: "... wählen",
            
            // Funktion, um Werte dynamisch für das Dropdown-Feld zu generieren
            headerFilterParams: {
            valuesLookup: function (cell) {
            let table = cell.getTable();
            let field = cell.getColumn().getField();
            let data = table.getData("active");
            
            // Eindeutige Werte sammeln und leere Option hinzufügen
            let uniqueValues = Array.from(new Set(data.map(row => row[field])));
            uniqueValues = uniqueValues.filter(v => v !== "").sort(); // Sortiere Werte, außer die leeren
            uniqueValues.unshift(""); // Leere Option an den Anfang
            
            // Erstelle Dropdown-Optionen mit Labels
            return uniqueValues.map(value => ({
            label: value === "" ? "... wählen" : value, // Label für die leere Option
            value: value
            }));
            }
            },
            
            // Funktion, um HTML-Tags aus den Werten zu entfernen
            accessor: function (value) {
            const div = document.createElement("div");
            div.innerHTML = value; // HTML-Inhalte entfernen
            return div.textContent || div.innerText || "";
            },
            
            // Filterfunktion: Prüft, ob der Wert mit dem Filter übereinstimmt
            headerFilterFunc: function (headerValue, rowValue) {
            const div = document.createElement("div");
            div.innerHTML = rowValue;
            const plainTextValue = div.textContent || div.innerText || "";
            return headerValue === "" || plainTextValue === headerValue; // Filterlogik
            },
            }
            ],
            // Sicherstellen, dass Filter aktualisiert werden
            dataFiltered: function(filters, rows) {
            this.redraw(); // Tabelle neu zeichnen, damit sich Filteroptionen aktualisieren
            }
            
            });
            document.getElementById("reset-filters").addEventListener("click", function () {
            table.clearHeaderFilter(); // Alle Filter löschen
            });
        </script>
    </xsl:template>

    <xsl:template match="/" name="html_tabulator_dl_buttons">
        <div style="margin-left: 2em;">
            <h4>Tabelle laden</h4>
            <div class="button-group my-2">
                <button type="button" class="btn btn-outline-secondary" id="download-csv"
                    title="Download CSV">
                    <span>CSV</span>
                </button>
                <span>&#160;</span>
                <button type="button" class="btn btn-outline-secondary" id="download-json"
                    title="Download JSON">
                    <span>JSON</span>
                </button>
                <span>&#160;</span>
                <button type="button" class="btn btn-outline-secondary" id="download-html"
                    title="Download HTML">
                    <span>HTML</span>
                </button>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="/" name="html_tabulator_dl_buttons_js">
        <script>
            //trigger download of data.csv file
            document.getElementById("download-csv").addEventListener("click", function(){
            table.download("csv", "data.csv");
            });
            
            //trigger download of data.json file
            document.getElementById("download-json").addEventListener("click", function(){
            table.download("json", "data.json");
            });
            
            //trigger download of data.html file
            document.getElementById("download-html").addEventListener("click", function(){
            table.download("html", "data.html", {style:true});
            });
        </script>
    </xsl:template>

</xsl:stylesheet>
