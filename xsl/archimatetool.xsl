<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/*">
		<arc:model identifier="{@id}">
			<arc:name><xsl:value-of select="@name"/></arc:name>
			<arc:documentation>
				<xsl:value-of select="purpose"/>
			</arc:documentation>
			<arc:elements>
				<xsl:apply-templates select="//element[not(@source) and not(@xsi:type='archimate:ArchimateDiagramModel')]"/>
			</arc:elements>
			<arc:relationships>
				<xsl:apply-templates select="//element[@source]"/>
			</arc:relationships>
			<arc:organization>
				<xsl:apply-templates select="/*/folder"/>
			</arc:organization>
			<arc:propertydefs>
				<xsl:for-each select="distinct-values(//property/@key)">
					<arc:propertydef identifier="{.}" name="{.}" type="string"/>
     			</xsl:for-each>
			</arc:propertydefs>
			<arc:views>
				<xsl:apply-templates select="//element[@xsi:type='archimate:ArchimateDiagramModel']"/>
			</arc:views>
		</arc:model>
	</xsl:template>
	
		<!-- view -->
	<xsl:template match="element[@xsi:type='archimate:ArchimateDiagramModel']">
		<arc:view identifier="{@id}">
			<arc:label><xsl:value-of select="@name"/></arc:label>
			<arc:documentation><xsl:value-of select="documentation"/></arc:documentation>
			<xsl:call-template name="properties"/>
			<xsl:apply-templates select="child"/>
			<xsl:apply-templates select="child//sourceConnection"/>
		</arc:view>
	</xsl:template>
	
	<!-- relationship -->
	<xsl:template match="element[@source]">
		<arc:relationship identifier="{@id}" xsi:type="{fn:substring-after(@xsi:type,'archimate:')}" source="{@source}" target="{@target}">
			<arc:label><xsl:value-of select="@name"/></arc:label>
			<arc:documentation><xsl:value-of select="documentation"/></arc:documentation>
			<xsl:call-template name="properties"/>
		</arc:relationship>
	</xsl:template>
	
	<!-- element -->
	<xsl:template match="element">
		<arc:element identifier="{@id}" xsi:type="{fn:substring-after(@xsi:type,'archimate:')}">
			<arc:label><xsl:value-of select="@name"/></arc:label>
			<arc:documentation><xsl:value-of select="documentation"/></arc:documentation>
			<xsl:call-template name="properties"/>
		</arc:element>
	</xsl:template>
	

	
	<xsl:template match="folder">
		<arc:item>
			<arc:label><xsl:value-of select="@name"/></arc:label>
			<xsl:apply-templates select="folder"/>
			<xsl:for-each select="element">
				<arc:item identifierref="{@id}"/>
			</xsl:for-each>
		</arc:item>
	</xsl:template>
	

	
	<xsl:template match="child">
		<xsl:variable name="y">
			<xsl:choose>
				<xsl:when test="bounds/@y"><xsl:value-of select="bounds/@y"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="x">
			<xsl:choose>
				<xsl:when test="bounds/@x"><xsl:value-of select="bounds/@x"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<arc:node identifier="{@id}" x="{$x+sum(./ancestor::child/bounds/@x)}" y="{$y+sum(./ancestor::child/bounds/@y)}" w="{bounds/@width}" h="{bounds/@height}" >
			<xsl:choose>
				<xsl:when test="@archimateElement">
					<xsl:attribute name="elementref"><xsl:value-of select="@archimateElement"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">group</xsl:attribute>
					<arc:label><xsl:value-of select="@name"/></arc:label>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@fillColor">
					<arc:style>
						<xsl:variable name="color">
							<xsl:call-template name="hex-to-rgba">
								<xsl:with-param name="hex-val" select="@fillColor"/>
							</xsl:call-template>
						</xsl:variable>
						<arc:fillColor r="{$color/color/@r}" g="{$color/color/@g}" b="{$color/color/@b}" />
						<!-- TODO: calculate  relative line color -->
						<arc:lineColor r="92" g="92" b="92" />
					</arc:style>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="defaultColor"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="child"/>
		</arc:node>
	</xsl:template>
	
	<xsl:template match="sourceConnection">
		<arc:connection identifier="{@id}" relationshipref="{@relationship}" source="{@source}" target="{@target}" >
			<xsl:apply-templates select="bendpoint"/>
			<arc:style>
				<xsl:choose>
					<xsl:when test="@lineColor">
						<xsl:variable name="color">
							<xsl:call-template name="hex-to-rgba">
								<xsl:with-param name="hex-val" select="@lineColor"/>
							</xsl:call-template>
						</xsl:variable>
						<arc:lineColor r="{$color/color/@r}" g="{$color/color/@g}" b="{$color/color/@b}" />
					</xsl:when>
					<xsl:otherwise>
						<arc:lineColor r="0" g="0" b="0" />
					</xsl:otherwise>
				</xsl:choose>
			</arc:style>
		</arc:connection>
	</xsl:template>
	
	<xsl:template match="bendpoint">
		<xsl:variable name="sourceid" select="../@source"/>
		<xsl:variable name="source" select="//child[@id=$sourceid]"/>
		<arc:bendpoint x="{$source/bounds/@x+sum($source/ancestor::child/bounds/@x)+$source/bounds/@width div 2 + @startX}" 
					   y="{$source/bounds/@y+sum($source/ancestor::child/bounds/@y)+$source/bounds/@height div 2 + @startY}"/>
	</xsl:template>
	
	<xsl:template name="properties">
		<xsl:if test="property">
			<arc:properties>
				<xsl:apply-templates select="property"/>
			</arc:properties>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="property">
		<arc:property identifierref="{@key}">
			<arc:value><xsl:value-of select="@value"/></arc:value>
		</arc:property>
	</xsl:template>
	
	<xsl:template name="defaultColor">
		<xsl:variable name="type" select="//element[@id=current()/@archimateElement]/@xsi:type"/>
		<xsl:choose>
			<xsl:when test="$type='archimate:BusinessRole' or 
				$type='archimate:BusinessActor' or 
				$type='archimate:BusinessCollaboration' or 
				$type='archimate:Product' or
				$type='archimate:Location'  or 
				$type='archimate:BusinessInterface' or 
				$type='archimate:BusinessFunction' or
				$type='archimate:BusinessProcess'  or 
				$type='archimate:BusinessEvent' or 
				$type='archimate:BusinessInteraction' or
				$type='archimate:Contract' or 
				$type='archimate:BusinessService' or
				$type='archimate:Value' or 
				$type='archimate:Meaning' or
				$type='archimate:Representation' or
				$type='archimate:BusinessObject'">
				<arc:style>
					<arc:fillColor r="255" g="255" b="181" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:ApplicationComponent' or 
				$type='archimate:ApplicationCollaboration' or 
				$type='archimate:ApplicationInterface' or 
				$type='archimate:ApplicationService' or
				$type='archimate:ApplicationFunction' or
				$type='archimate:ApplicationInteraction' or
				$type='archimate:DataObject'">
				<arc:style>
					<arc:fillColor r="181" g="255" b="255" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:Device' or 
				$type='archimate:Node' or 
				$type='archimate:SystemSoftware' or 
				$type='archimate:CommunicationPath' or
				$type='archimate:Artifact' or
				$type='archimate:Network'  or
				$type='archimate:InfrastructureInterface' or
				$type='archimate:InfrastructureFunction' or
				$type='archimate:InfrastructureService'
				">
				<arc:style>
					<arc:fillColor r="201" g="231" b="183" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:Principle' or 
				$type='archimate:Goal' or 
				$type='archimate:Requirement' or 
				$type='archimate:Constraint' 
				">
				<arc:style>
					<arc:fillColor r="204" g="204" b="255" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:Gap' or 
				$type='archimate:Plateau'  
				">
				<arc:style>
					<arc:fillColor r="224" g="255" b="224" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:Workpackage' or 
				$type='archimate:Deliverable'
				">
				<arc:style>
					<arc:fillColor r="255" g="224" b="224" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:when test="$type='archimate:Stakeholder' or 
				$type='archimate:Driver' or 
				$type='archimate:Assessment' 
				">
				<arc:style>
					<arc:fillColor r="191" g="223" b="255" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:when>
			<xsl:otherwise>
				<arc:style>
					<arc:fillColor r="192" g="192" b="192" />
					<arc:lineColor r="92" g="92" b="92" />
				</arc:style>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- convert hexidecimal color code to rgb style -->
	<!-- http://www.getsymphony.com/download/xslt-utilities/view/111761/ -->
	<xsl:template name="hex-to-rgba">
		<xsl:param name="hex-val"/>
		<xsl:param name="opacity"/>

		<xsl:param name="hex" select="translate(translate($hex-val, '#', ''), 'abcdef', 'ABCDEF')"/>
		
		<xsl:variable name="r">
			<xsl:call-template name="hexpairs-to-dec">
				<xsl:with-param name="pair" select="1"/>
				<xsl:with-param name="hex" select="$hex"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="g">
			<xsl:call-template name="hexpairs-to-dec">
				<xsl:with-param name="pair" select="2"/>
				<xsl:with-param name="hex" select="$hex"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="b">
			<xsl:call-template name="hexpairs-to-dec">
				<xsl:with-param name="pair" select="3"/>
				<xsl:with-param name="hex" select="$hex"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($opacity) > 0">
				<color r="{$r}" g="{$g}" b="{$b}" a="$opacity"/>
			</xsl:when>
			<xsl:otherwise>
				<color r="{$r}" g="{$g}" b="{$b}"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
		
	<xsl:template name="hexpairs-to-dec">
		<xsl:param name="pair" select="1"/>
		<xsl:param name="hex"/>
		<xsl:variable name="hex-pair" select="substring($hex,$pair * 2 - 1,2)"/>
		<xsl:if test="$hex-pair">
			<xsl:variable name="hex" select="'0123456789ABCDEF'"/>
			<xsl:value-of select="(string-length(substring-before($hex, substring($hex-pair,1,1))))*16 + string-length(substring-before($hex,substring($hex-pair,2,1)))"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>