<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/scroll_offset_js.xsl"/>
    <xsl:import href="./partials/div_observer_js.xsl"/>
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of
                select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <style>
                    /* Inhaltsverzeichnis */
                    .sticky {
                        position: -webkit-sticky; /* Safari */
                        position: sticky;
                        top: 120px; /* Abstand vom oberen Rand */
                    }
                    
                    .list-unstyled.border {
                        background-color: #f2f2f2;
                        border: 1px solid #ddd;
                        padding: 15px;
                        border-radius: 5px;
                    }
                    
                    .list-unstyled.border a {
                        display: block;
                        color: #333;
                        padding: 8px 12px;
                        text-decoration: none;
                        font-weight: 500;
                        transition: background-color 0.3s, color 0.3s;
                    }
                    
                    .list-unstyled.border a:hover {
                        background-color: #474747;
                        color: #EBEBEB;
                        border-radius: 5px;
                    }
                    
                    .list-unstyled.border a:active {
                        background-color: #858585;
                        color: #f2f2f2;
                    }
                    .list-unstyled.border .indent-2 {
                        font-size: 0.9em;
                    }
                    
                    .active-link {
                        border-left: 4px solid #474747;
                        border-bottom-left-radius: 5px;
                        border-top-left-radius: 5px;
                    }
                    /* Inhaltsverzeichnis-Ende */
                    
                    /* Fließtext */
                    .con-text.border {
                        border: 1px solid #ddd; /* Leichter grauer Rand */
                        padding: 15px;
                        border-radius: 5px;
                        margin-bottom: 15px;
                        background-color: #ffffff; /* Weiß */
                    }
                    
                    .con-text.border > .con-text.border {
                        border: 1px solid #ddd;
                        padding: 15px;
                        border-radius: 5px;
                        margin-bottom: 15px;
                        background-color: #f9f9f9;
                    }
                    
                    .indent-2 {
                        margin-left: 2em;
                    }
                    .indent-4 {
                        margin-left: 4em;
                    }
                    .indent-6 {
                        margin-left: 6em;
                    }
                    .indent-8 {
                        margin-left: 8em;
                    }
                    /* Fließtext-Ende */
                    
                    /* Tabelle */
                    table {
                        width: 100%;
                        border-collapse: collapse;
                    }
                    
                    table th,
                    table td {
                        padding: 10px;
                        border: 1px solid #dee2e6;
                        text-align: left;
                    }
                    
                    table th {
                        background-color: #CCCCCC;
                    }
                    
                    table tr:nth-child(even) {
                        background-color: #f2f2f2;
                    }
                    
                    table a {
                        color: #007bff;
                        text-decoration: none;
                    }
                    /* Tabelle-Ende */</style>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
                    rel="stylesheet"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="my-4" style="text-align:center">
                            <h1>
                                <xsl:value-of select="//tei:title[@level = 'a']"/>
                            </h1>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="sticky">
                                    <h4>Inhaltsverzeichnis</h4>
                                    <ul class="list-unstyled border" style="text-align: left;">
                                        <xsl:for-each select="//tei:head">
                                            <li>
                                                <xsl:choose>
                                                  <xsl:when test="@n = '1'">
                                                  <a>
                                                  <xsl:attribute name="href">#<xsl:value-of
                                                  select="@xml:id"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="normalize-space(text())"/>
                                                  </a>
                                                  </xsl:when>
                                                  <xsl:when test="@n = '2'">
                                                  <a class="indent-2">
                                                  <xsl:attribute name="href">#<xsl:value-of
                                                  select="@xml:id"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="normalize-space(text())"/>
                                                  </a>
                                                  </xsl:when>
                                                </xsl:choose>
                                            </li>
                                        </xsl:for-each>
                                        <li>
                                            <a href="#fnApp">Fußnotenapparat</a>
                                        </li>
                                    </ul>
                                </div>

                            </div>
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-12">
                                        <xsl:apply-templates select="//tei:body"/>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="con-text border">
                                            <h2 id="fnApp">Fußnotenapparat</h2>
                                            <ul class="list-unstyled">
                                                <xsl:for-each select="//tei:note">
                                                  <xsl:variable name="fnSign"
                                                  select="number(substring-after(@xml:id, '_'))"/>
                                                  <xsl:variable name="fnId" select="@xml:id"/>
                                                  <li id="{$fnId}_app">
                                                  <sup>
                                                  <span class="badge bg-primary">
                                                  <xsl:value-of select="number($fnSign)"/>
                                                  </span>
                                                  </sup>&#160;<xsl:value-of
                                                  select="normalize-space(.)"/><a
                                                  href="#{$fnId}_con">&#160;<i
                                                  class="bi bi-arrow-up"/></a>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="scroll_offset"/>
                <xsl:call-template name="div_observer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:div">
        <div class="con-text border">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="@n = '1'">
                <h2>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </h2>
            </xsl:when>
            <xsl:when test="@n = '2'">
                <h3>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </h3>
            </xsl:when>
            <xsl:when test="@n = '3'">
                <h4>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:pb">
        <sub>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:variable name="pageNr" select="substring-after(@xml:id, '_')"/>
            <xsl:variable name="romanNr" select="translate($pageNr, '0', '')"/>
            <span class="badge bg-warning">
                <xsl:value-of select="$romanNr"/>
            </span>
        </sub>
    </xsl:template>


    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:variable name="fnSign" select="substring-after(@xml:id, '_')"/>
        <xsl:variable name="fnId" select="@xml:id"/>
        <a class="footnote" href="#{$fnId}_app" id="{$fnId}_con">
            <sup>
                <span class="badge bg-primary">
                    <xsl:value-of select="number($fnSign)"/>
                </span>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:lb[position() > 1]">
        <br/>
    </xsl:template>

    <xsl:template match="tei:space[@unit = 'tab']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'">
                <span class="indent-2"/>
            </xsl:when>
            <xsl:when test="@quantity = '2'">
                <span class="indent-4"/>
            </xsl:when>
            <xsl:when test="@quantity = '3'">
                <span class="indent-6"/>
            </xsl:when>
            <xsl:when test="@quantity = '4'">
                <span class="indent-8"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="indent-1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:table[@type = 'with-head']">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:if test="@n = '0'">
                            <xsl:for-each select="tei:cell">
                                <th>
                                    <xsl:apply-templates/>
                                </th>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="@n != '0'">
                            <xsl:for-each select="tei:cell">
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </xsl:for-each>
                        </xsl:if>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="tei:table[@type = 'without-head']">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:for-each select="tei:cell">
                            <xsl:choose>
                                <xsl:when test="@cols">
                                    <td colspan="{@cols}">
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>



</xsl:stylesheet>
