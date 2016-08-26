<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="arc xs"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://www.opengroup.org/xsd/archimate"
    version="2.0"
    >
    
    <!-- Copy everything over except overriding templates -->
    <xsl:template match="@*|node()" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Move xsi:type into type and replace CommunicationPath with Path -->
    <xsl:template match="arc:element/@xsi:type">
        <xsl:variable name="type" select="."/>
        <xsl:attribute name="type">
         <xsl:choose>
             <xsl:when test="$type='CommunicationPath'">Path</xsl:when>
             <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
         </xsl:choose>
        </xsl:attribute>
        
    </xsl:template>
    
    <!-- Move xsi:type into type and replace UsedByRelationship into ServingRelationship -->
    <xsl:template match="arc:relationship/@xsi:type">
        <xsl:variable name="type" select="."/>
        <xsl:attribute name="type">
            <xsl:value-of select="$type"/>
        </xsl:attribute>
    </xsl:template>
 
</xsl:stylesheet>