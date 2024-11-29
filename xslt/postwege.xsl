<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/tooltipp_js.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link href="https://unpkg.com/tabulator-tables@6.2.5/dist/css/tabulator.min.css"
                    rel="stylesheet"/>
                <link
                    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css"
                    rel="stylesheet"/>
                <style>
                    .header-container {
                        display: flex;
                        justify-content: center;
                        position: relative;
                        align-items: center;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container my-4">
                        <div class="header-container">
                            <h1 class="text-center mb-0">Alle Briefe</h1>
                            <button id="reset-filters" class="btn btn-lg" type="button"
                                data-bs-toggle="tooltip" data-bs-placement="top"
                                title="Filter zurücksetzen">
                                <i class="bi bi-x-square-fill"/>
                            </button>
                        </div>
                    </div>
                    <div style="display: block; justify-content: center; margin: 0 2em;"
                        id="tabulator-table-wrapper">
                        <table class="table table-sm display" id="tabulator-table-postwege">
                            <thead>
                                <tr>
                                    <th scope="col">Bandnummer</th>
                                    <th scope="col">Briefnummer</th>
                                    <th scope="col">Titel</th>
                                    <th scope="col">Sender</th>
                                    <th scope="col">Empfänger</th>
                                    <th scope="col">Sendedatum</th>
                                    <th scope="col">Sendeort</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection('../../GN/nbr-graz-data/editions/?select=*.xml')/tei:TEI">
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of
                                                select="descendant::tei:monogr/tei:biblScope/@n"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="descendant::tei:body/tei:head/@n"
                                            />
                                        </td>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:body/tei:head/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="substring-after(descendant::tei:correspDesc/tei:correspAction[@type = 'sent']/tei:persName[1]/@ref, '#')"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'sent']/tei:persName[1]"
                                                />
                                            </a>
                                        </td>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="substring-after(descendant::tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1]/@ref, '#')"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1]"
                                                />
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                            />
                                        </td>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="substring-after(descendant::tei:correspAction[@type = 'sent']/tei:placeName/@ref, '#')"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:correspAction[@type = 'sent']/tei:placeName"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>

                    <xsl:call-template name="html_tabulator_dl_buttons"/>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js_postwege"/>
                <xsl:call-template name="html_tabulator_dl_buttons_js"/>
                <xsl:call-template name="tooltipp_js_postwege"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
