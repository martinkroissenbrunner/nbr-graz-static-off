<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Auflistung aller Briefe'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link href="https://unpkg.com/tabulator-tables@6.2.5/dist/css/tabulator.min.css"
                    rel="stylesheet"/>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="my-4" style="text-align:center">
                        <h1>Alle Briefe</h1>
                    </div>
                    <div style="display: block; justify-content: center; margin: 0 2em;"
                        id="tabulator-table-wrapper">
                        <table class="table table-sm display" id="tabulator-table-postwege">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Bandnummer</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Briefnummer</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Sender</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Empfänger</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Titel</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Sendedatum</th>
                                    <th scope="col" tabulator-headerFilter="input"
                                        tabulator-formatter="html">Sendeort</th>
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
                                            <a>
                                                <xsl:value-of
                                                  select="descendant::tei:monogr/tei:biblScope/@n"/>
                                            </a>
                                        </td>
                                        <td>
                                            <a>
                                                <xsl:value-of
                                                  select="descendant::tei:body/tei:head/@n"/>
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
                                            <a>
                                                <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                />
                                            </a>
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
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
