<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fn="http://www.w3.org/2005/xpath-functions"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:arc="http://www.opengroup.org/xsd/archimate">

<xsl:param name="customxsl"/>

<xsl:template match="@*|node()" name="identity">
    <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="xsl:include">

<xsl:element name="xsl:include">
<xsl:choose>
<xsl:when test="$customxsl != ''">
            <xsl:attribute name="href">file:///<xsl:value-of select="replace($customxsl,'\\','/')"/></xsl:attribute>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="href">default.xsl</xsl:attribute>
</xsl:otherwise>
</xsl:choose>
    </xsl:element>

</xsl:template>
</xsl:stylesheet>