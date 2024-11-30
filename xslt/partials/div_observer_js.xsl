<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/" name="div_observer">
        <script>
            document.addEventListener("scroll", () => {
            const sections = document.querySelectorAll(".con-text.border");
            const navLinks = document.querySelectorAll(".list-unstyled a");
            let maxVisibility = 0; // Maximum sichtbarer Bereich in Prozent
            let activeSection = null; // Das aktuell am meisten sichtbare `div`
            
            sections.forEach((section) => {
            const rect = section.getBoundingClientRect();
            const visibleHeight = Math.min(rect.bottom, window.innerHeight) - Math.max(rect.top, 0);
            const visibilityPercentage = (visibleHeight / rect.height) * 100;
            
            if (visibilityPercentage > maxVisibility) {
            maxVisibility = visibilityPercentage;
            activeSection = section;
            }
            });
            
            if (activeSection) {
            // Hole die ID der Überschrift innerhalb des am meisten sichtbaren Abschnitts
            const heading = activeSection.querySelector("h2[id], h3[id]");
            const id = heading ? heading.getAttribute("id") : null;
            
            // Entferne alte Hervorhebungen
            navLinks.forEach((link) => link.classList.remove("active-link"));
            
            // Füge die Hervorhebung hinzu
            if (id) {
            const correspondingLink = document.querySelector(`.list-unstyled a[href="#${id}"]`);
            if (correspondingLink) {
            correspondingLink.classList.add("active-link");
            }
            }
            }
            });
        </script>
    </xsl:template>
    
</xsl:stylesheet>
