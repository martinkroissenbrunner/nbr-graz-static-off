<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Register'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link
                    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css"
                    rel="stylesheet"/>
                <link href="https://unpkg.com/tabulator-tables@6.2.5/dist/css/tabulator.min.css"
                    rel="stylesheet"/>
                <style>
                    .header-container {
                        display: flex;
                        justify-content: center;
                        position: relative;
                        align-items: center;
                    }
                    
                    .collapse-overlay {
                        position: absolute;
                        top: 175px;
                        left: 50%;
                        transform: translateX(-50%); /* Verschiebt das Element, sodass es mittig ist */
                        z-index: 100;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                        border: 1px solid black;
                        border-radius: 6px;
                        max-width: 400px; /* Maximale Breite */
                    }
                    
                    
                    /* CSS für Zellumbruch */
                    .wrap-cell {
                        white-space: normal !important;
                        word-wrap: break-word;
                    }
                    
                    /* CSS für den Ladebildschirm */
                    #loader {
                        position: fixed;
                        left: 50%;
                        top: 50%;
                        width: 50px;
                        height: 50px;
                        margin-left: -25px;
                        margin-top: -25px;
                        border: 4px solid rgba(0, 0, 0, .1);
                        border-radius: 50%;
                        border-top-color: #3498db;
                        animation: spin 1s infinite linear;
                        z-index: 1000;
                    }
                    @keyframes spin {
                    to { transform: rotate(360deg); }
                    }
                    #tabulator-table-wrapper {
                        display: none;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container my-4">
                        <div class="header-container">
                            <h1 class="text-center mb-0">Register</h1>
                            <button class="btn btn-collapse btn-lg" type="button"
                                data-bs-toggle="collapse" data-bs-target="#collapseExample"
                                aria-expanded="false" aria-controls="collapseExample">
                                <i class="bi bi-info-square-fill"/>
                            </button>

                        </div>
                        <div class="collapse collapse-overlay" id="collapseExample">
                            <div class="card">
                                <div class="card-header">Hinweise zur Verwendung des Registers</div>
                                <div class="card-body">
                                    <p>Da in den Büchern mehrere Briefe auf einer Seite vorkommen
                                        können, war es nicht ohne weiteres möglich, die Seitenzahlen
                                        in Briefnummern umzuwandeln. Eine solche Umwandlung hätte es
                                        ermöglicht, im Register auf die Briefnummern statt auf die
                                        Seitenzahlen zu verweisen, was dem digitalen Format der
                                        Edition besser entsprochen hätte.</p>
                                    <p>Die Links im Register verweisen nun auf die gelb hinterlegten
                                        Seitenzahlen in der Briefansicht (<sub><span
                                                class="badge bg-warning">n</span></sub>). Diese sind
                                        genau an jenen Stellen eingefügt, an denen die Seitenzahlen
                                        im Fließtext des Buches erscheinen. Durch Anklicken einer
                                        Seitenzahl im Register wird jener Brief angezeigt, der diese
                                        Seitenzahl enthält. Wenn der gesuchte Inhalt nicht im
                                        angezeigten Brief enthalten ist, kann dies daran liegen,
                                        dass im Buch auf dieser Seite mehrere Briefe abgedruckt
                                        sind. In diesem Fall sollte die Suche im nächsten Brief
                                        fortgesetzt werden. Die gesuchte Entität sollte bis zur
                                        nächsten Seitenzahl aufgefunden werden.</p>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div id="loader"/>
                    <div style="display: block; justify-content: center; margin: 0 2em;"
                        id="tabulator-table-wrapper">
                        <table class="table table-sm display" id="tabulator-table-register">
                            <thead>
                                <tr>
                                    <th>Begriff (1. Ebene)</th>
                                    <th>Begriff (2. Ebene)</th>
                                    <th>Verweis</th>
                                    <th>Seiten (1. Band)</th>
                                    <th>Seiten (2. Band)</th>
                                    <th>Seiten (3. Band)</th>
                                    <th>Seiten (4. Band)</th>
                                    <th>Seiten (5. Band)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="//tei:body/tei:list/tei:item"/>
                            </tbody>
                        </table>
                    </div>
                    <xsl:call-template name="html_tabulator_dl_buttons"/>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js_register"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:item[ancestor::tei:body]">
        <tr>
            <td>
                <xsl:value-of select="tei:term"/>
            </td>
            <td/>
            <td>
                <xsl:apply-templates select="tei:ref"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-1')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L1')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-2')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L2')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-3')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L3')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-4')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L4')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-5')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L5')]"/>
            </td>
        </tr>
        <xsl:apply-templates select="tei:list/tei:item"/>
    </xsl:template>

    <xsl:template match="tei:item[ancestor::tei:item]">
        <tr>
            <td/>
            <td>
                <xsl:value-of select="tei:term"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:ref"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-1')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L1')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-2')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L2')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-3')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L3')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-4')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L4')]"/>
            </td>
            <td>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'front-5')]"/>
                <xsl:apply-templates select="tei:rs[starts-with(@ref, 'L5')]"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:rs">
        <!-- Get the part before the .xml and after .xml (if any) -->
        <xsl:choose>
            <xsl:when test="contains(@ref, '#P')">
                <a
                    href="{concat(substring-before(@ref, '.xml'), '.html', substring-after(@ref, '.xml'))}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:when test="contains(@ref, '#FN')">
                <a
                    href="{concat(substring-before(@ref, '.xml'), '.html', substring-after(@ref, '.xml'), '_app')}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="following-sibling::tei:rs">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
