<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/" name="tooltipp_js_postwege">
        <script>
            document.addEventListener('DOMContentLoaded', function () {
            const button = document.getElementById('reset-filters');
            const tooltip = new bootstrap.Tooltip(button);
            
            // Tooltip ausblenden, wenn der Button geklickt wird und nicht mehr gehovert wird
            button.addEventListener('click', () => {
            tooltip.hide(); // Tooltip manuell ausblenden
            });
            
            // Tooltip erneut anzeigen, wenn die Maus erneut hovert
            button.addEventListener('mouseenter', () => {
            tooltip.show();
            });
            });
        </script>
        
    </xsl:template>
</xsl:stylesheet>
