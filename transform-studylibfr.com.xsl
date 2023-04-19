<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" version="1.0">

    <xsl:output method="text"/>

    <xsl:template match="/">
        <xsl:apply-templates select="div" />
    </xsl:template>

</xsl:stylesheet>