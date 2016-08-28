<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:arc="http://www.opengroup.org/xsd/archimate" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dc="http://purl.org/dc/elements/1.1/" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
	<!-- the folder in which the html pages are gererated -->
	<xsl:param name="folder"/>
	<!-- the configuration file -->
	<xsl:param name="configfile"/>

	<!-- the URI for the configuration file -->
	<xsl:variable name="configURI">
		<xsl:choose>
			<!-- convert into URI for config file on Windows -->
			<xsl:when test="contains($configfile,':')">
				<xsl:value-of select="concat('file:///', replace($configfile, '\\', '/'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$configfile"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- the configuration document -->
	<xsl:variable name="config" select="document($configURI)"/>
	
	<xsl:variable name="archimateVersion" select="$config/configuration/@archimateVersion"/>
	
	<!-- the URI for the output folder -->
	<xsl:variable name="folderURI">
		<xsl:choose>
			<xsl:when test="contains($folder,':')">
				<xsl:value-of select="concat('file:///', replace($folder, '\\', '/'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$folder"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Place holder include for customization xsl. This will be replaced by the preprocess.xsl -->
	<xsl:include href="../config/custom.xsl"/>

	<!-- the template that will generate a page for each element and view -->
	<xsl:template match="/arc:model">
		<xsl:for-each select="//arc:element | //arc:view">
			<xsl:result-document method="html"
				href="{$folderURI}/browsepage-{@identifier}.html">
				<html>
					<head><title><xsl:value-of select="arc:label"/></title>
						<meta charset="utf-8"/>
						<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
						<!-- JQUERY (use 1.x branch to be compatible with IE 6/7/8) / UI / LAYOUT -->
						<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"/>
						<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-layout/1.4.3/jquery.layout.min.js"/>
						<!-- BOOTSTRAP -->
						<!-- Latest compiled and minified CSS -->
						<link rel="stylesheet"
							href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
							media="all"
							integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
							crossorigin="anonymous"/>
						<!-- Latest compiled and minified JavaScript -->
						<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"/>
						<!-- D3PLUS -->
						<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"/>
						<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3plus/1.9.5/d3plus.min.js"/>
						<!-- REPORT SPECIFIC -->
						<link type="text/css" rel="stylesheet" href="http://www.archimateviewer.nl/1.0.0/libs/css/model.css"/>
						<script type="text/javascript" src="http://www.archimateviewer.nl/1.0.0/libs/js/browse.js"/>
						<!-- don't show href value in printing mode -->
						<style>
							@media print{
							    a[href]:after{
							        content: none;
							    }
							}
							<!-- put some specific css defined in the configuration file -->
                        	<xsl:value-of select="$config//css"/>
                    	</style>
					</head>
					<body>
						<div class="ui-layout-center">
							<xsl:apply-templates select="."/>
						</div>
					</body>
				</html>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

	<!-- template for creating a matrix view -->
	<xsl:template
		match="arc:view[arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'xfolder']/@identifier]]">
		<xsl:variable name="xfolder">
			<xsl:value-of
				select="arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'xfolder']/@identifier]/arc:value"
			/>
		</xsl:variable>
		<xsl:variable name="yfolder">
			<xsl:value-of
				select="arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'yfolder']/@identifier]/arc:value"
			/>
		</xsl:variable>
		<div id="panel" class="panel panel-default root-panel">
			<div id="panelheader" class="panel-heading root-panel-heading">
				<h4>
					<xsl:value-of select="arc:label"/>
					
				</h4>
				<xsl:text>&#160;</xsl:text>
				<a id="print" href="browsepage-{@identifier}.html?style=listed" target="_blank">
					<span class="glyphicon glyphicon-print"/>
				</a>
			</div>
			<div id="panelbody" class="panel-body root-panel-body">
				<div class="col-md-12">
					<table>
						<thead>
							<tr>
								<th/>
								<xsl:for-each
									select="/arc:model/arc:organization//arc:item[arc:label = $xfolder]//arc:item[@identifierref]">
									<xsl:variable name="columnid" select="@identifierref"/>
									<th class="rotate">
										<div>
											<span>
												<xsl:value-of
												select="//arc:element[@identifier = $columnid]/arc:label"
												/>
											</span>
										</div>
									</th>
								</xsl:for-each>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each
								select="/arc:model/arc:organization//arc:item[arc:label = $yfolder]//arc:item[@identifierref]">
								<xsl:variable name="rowid" select="@identifierref"/>
								<tr>
									<td style="border-bottom: 1px solid #ccc;">
										<xsl:value-of
											select="//arc:element[@identifier = $rowid]/arc:label"/>
									</td>
									<xsl:for-each
										select="/arc:model/arc:organization//arc:item[arc:label = $xfolder]//arc:item[@identifierref]">
										<xsl:variable name="columnid" select="@identifierref"/>
										<td class="text-center"
											style="border:1px solid #ccc; width:30px padding: 5px 10px;">
											<xsl:if
												test="//arc:relationship[@source = $rowid and @target = $columnid]">
												<i class="glyphicon glyphicon-ok"/>
											</xsl:if>
											<xsl:if
												test="//arc:relationship[@target = $rowid and @source = $columnid]">
												<i class="glyphicon glyphicon-ok"/>
											</xsl:if>
										</td>
									</xsl:for-each>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- template for creating a catalog view -->
	<xsl:template
		match="arc:view[arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'folder']/@identifier]]">
		<xsl:variable name="folder">
			<xsl:value-of
				select="arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'folder']/@identifier]/arc:value"
			/>
		</xsl:variable>
		<div id="panel" class="panel panel-default root-panel">
			<div id="panelheader" class="panel-heading root-panel-heading">
				<h4>
					<xsl:value-of select="arc:label"/>
					<xsl:text>&#160;</xsl:text>
					<a id="print" href="browsepage-{@identifier}.html?style=listed" target="_blank">
						<span class="glyphicon glyphicon-print"/>
					</a>
				</h4>
			</div>
			<div id="panelbody" class="panel-body root-panel-body">
				<xsl:variable name="properties"
					select="/arc:model/arc:propertydefs/arc:propertydef[@identifier = //arc:element[@identifier = /arc:model/arc:organization//arc:item[arc:label = $folder]//arc:item/@identifierref]//arc:property/@identifierref]"/>
				<xsl:for-each-group
					select="/arc:model/arc:organization//arc:item[arc:label = $folder]/arc:item"
					group-by="arc:label">
					<xsl:sort select="current-grouping-key()"/>
					<h4>
						<xsl:value-of select="current-grouping-key()"/>
					</h4>
					<table class="table table-condensed table-bordered">
						<xsl:call-template name="catalogHeader">
							<xsl:with-param name="properties" select="$properties"/>
						</xsl:call-template>
						<xsl:for-each select="current-group()//arc:item[@identifierref]">
							<xsl:sort
								select="//arc:element[@identifier = current()/@identifierref]/arc:label"/>
							<xsl:call-template name="catalogLine">
								<xsl:with-param name="properties" select="$properties"/>
							</xsl:call-template>
						</xsl:for-each>
					</table>
				</xsl:for-each-group>
				<xsl:if
					test="/arc:model/arc:organization//arc:item[arc:label = $folder]/arc:item[@identifierref]">
					<table class="table table-condensed table-bordered">
						<xsl:call-template name="catalogHeader">
							<xsl:with-param name="properties" select="$properties"/>
						</xsl:call-template>
						<xsl:for-each
							select="/arc:model/arc:organization//arc:item[arc:label = $folder]/arc:item[@identifierref]">
							<xsl:sort
								select="//arc:element[@identifier = current()/@identifierref]/arc:label"/>
							<xsl:call-template name="catalogLine">
								<xsl:with-param name="properties" select="$properties"/>
							</xsl:call-template>
						</xsl:for-each>
					</table>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="catalogHeader">
		<xsl:param name="properties"/>
		<tr>
			<th>Name</th>
			<th>Documentation</th>
			<xsl:for-each select="$properties">
				<th>
					<xsl:value-of select="@name"/>
				</th>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template name="catalogLine">
		<xsl:param name="properties"/>
		<xsl:variable name="element" select="//arc:element[@identifier = current()/@identifierref]"/>
		<xsl:if test="$element">
			<tr>
				<td class="text-left">
					<a href="browsepage-{$element/@identifier}.html">
						<xsl:value-of select="$element/arc:label"/>
					</a>
				</td>
				<td class="documentation">
					<xsl:value-of select="$element/arc:documentation"/>
				</td>
				<xsl:for-each select="$properties">
					<td>
						<xsl:choose>
							<xsl:when
								test="$element//arc:property[@identifierref = current()/@identifier and arc:value != '']">
								<xsl:value-of
									select="$element//arc:property[@identifierref = current()/@identifier]/arc:value"
								/>
							</xsl:when>
							<xsl:when
								test="$element//arc:property[@identifierref = current()/@identifier]">
								<i class="glyphicon glyphicon-ok"/>
							</xsl:when>
						</xsl:choose>
					</td>
				</xsl:for-each>
			</tr>
		</xsl:if>
	</xsl:template>


	<xsl:template
		match="arc:view[arc:properties/arc:property[@identifierref = //arc:propertydef[@name = 'Type']/@identifier]/arc:value = 'Artifact']">
		<xsl:message>Generating artifact <xsl:value-of select="arc:label"/></xsl:message>
		<div class="documentation">
			<xsl:copy>
				<xsl:apply-templates select="arc:documentation"/>
			</xsl:copy>
			<h1>bold text</h1>
		</div>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="div[@type = 'view']">
		<xsl:apply-templates select="//arc:view[@identifier = current()/@viewref]"/>
	</xsl:template>

	<!-- template for an element card -->
	<xsl:template match="arc:element">
		<xsl:variable name="type" select="@type"/>
		<xsl:variable name="id" select="@identifier"/>
		<xsl:variable name="element" select="current()"/>
		<xsl:variable name="properties">
			<properties>
				<xsl:for-each select="$element//arc:property">
					<property name="{//arc:propertydef[@identifier=current()/@identifierref]/@name}"
						value="{arc:value}"/>
				</xsl:for-each>
			</properties>
		</xsl:variable>
		<xsl:variable name="overrideElementStyle"
			select="$config//elementstyle[elementcondition[type = $element/@type or @type = 'any']/propertycondition[@name = $properties//property/@name and @value = $properties//property/@value]]"/>
		<xsl:variable name="class" select="$overrideElementStyle//cardHeaderClass"/>
		<div id="panel" class="panel panel-default root-panel {$class}">
			<div id="panelheader" class="panel-heading root-panel-heading">
				<h4>
					<xsl:call-template name="elementLabel">
						<xsl:with-param name="element" select="."/>
						<xsl:with-param name="context">element</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<a id="print" href="browsepage-{@identifier}.html?style=listed" target="_blank">
						<span class="glyphicon glyphicon-print"/>
					</a>
				</h4>
				<input id="link" style="position:relative" value="index.html?page={@identifier}"/>
			</div>
			<div id="panelbody" class="panel-body root-panel-body">
				<div class="col-md-12">
					<xsl:if test="arc:documentation">
						<p class="documentation well">
							<xsl:value-of select="arc:documentation"/>
						</p>
					</xsl:if>
					<ol class="breadcrumb">
						<xsl:for-each
							select="/arc:model/arc:organization//arc:item[@identifierref = $id]/ancestor::arc:item[arc:label]">
							<li>
								<xsl:value-of select="arc:label"/>
							</li>
						</xsl:for-each>
					</ol>
					<table class="table table-condensed small">
						<xsl:for-each select="arc:properties/arc:property">
							<xsl:variable name="propertyid" select="@identifierref"/>
							<tr>
								<td class="col-md-2">
									<xsl:value-of
										select="/arc:model/arc:propertydefs/arc:propertydef[@identifier = $propertyid]/@name"
									/>
								</td>
								<td class="col-md-10">
									<xsl:value-of select="./arc:value"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
					<!-- Insert custom html -->
					<xsl:call-template name="customElement"/>
					<!-- Create the relationships structure for both the report and browse parts -->
					<xsl:variable name="relationships">
						<xsl:call-template name="elementRelationships">
							<xsl:with-param name="element" select="."/>	
						</xsl:call-template>		
					</xsl:variable>
					<!-- Create the report part -->
					<xsl:call-template name="reportPart">
						<xsl:with-param name="relationships" select="$relationships"/>
					</xsl:call-template>
					<!-- Create the browse panel -->
					<xsl:call-template name="browsePart">
						<xsl:with-param name="relationships" select="$relationships"/>
					</xsl:call-template>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="browsePart">
		<xsl:param name="relationships"/>
		<div id="tabbed">
			<div role="tabpanel">
				<ul class="nav nav-tabs" role="tablist">
					<xsl:for-each select="$relationships//type">
						<li role="presentation">
							<xsl:if test="position() = 1">
								<xsl:attribute name="class">active</xsl:attribute>
							</xsl:if>
							<a href="#{position()}" aria-controls="{@name}" role="tab"
								data-toggle="tab">
								<xsl:value-of select="@name"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</div>
			<div class="tab-content">
				<xsl:for-each select="$relationships//type">
					<div role="tabpanel" class="tab-pane" id="{position()}">
						<xsl:if test="position() = 1">
							<xsl:attribute name="class">tab-pane active</xsl:attribute>
						</xsl:if>
						<table class="table table-hover table-condensed small">
							<xsl:for-each select="element">
								<tr class="{@overridingClass}">
									<td>
										<a href="browsepage-{@id}.html">
											<xsl:value-of select="@name"/>
										</a>
									</td>
									<td class="documentation">
										<xsl:value-of select="elementDocumentation"/>
									</td>
									<td class="documentation">
										<xsl:value-of select="documentation"/>
									</td>
								</tr>
							</xsl:for-each>
						</table>
					</div>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="reportPart">
		<xsl:param name="relationships"/>
		<div id="listed" style="display:none">
			<xsl:for-each select="$relationships//type">
				<h5>
					<xsl:value-of select="@name"/>
				</h5>
				<table class="table table-hover table-condensed small">
					<xsl:for-each select="element">
						<tr class="{@overridingClass}">
							<td>
								<a href="browsepage-{@id}.html">
									<xsl:value-of select="@name"/>
								</a>
							</td>
							<td class="documentation">
								<xsl:value-of select="elementDocumentation"/>
							</td>
							<td class="documentation">
								<xsl:value-of select="documentation"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--
		Create an xml structure for the relationships of the elements
		
		input: element id
		output:
			<relationships>
				<type @name>
					<element @id @name @overridingClass>
						<elementDocumentation/>
						<documentation/>
					</element>
				</type>
			</relationships>
	-->
	<xsl:template name="elementRelationships">
		<xsl:param name="element"/>
		<xsl:variable name="id" select="$element/@identifier"/>
		<relationships>
			<type name="Views">
				<xsl:for-each
					select="/arc:model/arc:views/arc:view//arc:node[@elementref = $id]/ancestor::arc:view">
					<element id="{@identifier}" name="{arc:label}"/>
				</xsl:for-each>
			</type>
			<xsl:for-each-group
				select="/arc:model/arc:relationships/arc:relationship[@source = $id or @target = $id]"
				group-by="//arc:element[(@identifier = current()/@target and current()/@source = $id) or (@identifier = current()/@source and current()/@target = $id)]/@type">
				<xsl:for-each-group select="current-group()" group-by="@type">
					<xsl:for-each-group select="current-group()"
						group-by="@source = $id">
						<type>
							<xsl:attribute name="name">
								<xsl:call-template name="relationshipTypeAlias">
									<xsl:with-param name="relationship"
										select="current()"/>
									<xsl:with-param name="direction">
										<xsl:choose>
											<xsl:when test="@source = $id">to</xsl:when>
											<xsl:otherwise>from</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:for-each select="current-group()">
								<xsl:variable name="elementRef">
									<xsl:choose>
										<xsl:when test="@source = $id">
											<xsl:value-of select="@target"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@source"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="referredElement"
									select="/arc:model/arc:elements/arc:element[@identifier = $elementRef]"/>
								<xsl:variable name="referredElementProperties">
									<properties>
										<xsl:for-each
											select="$referredElement//arc:property">
											<property
												name="{//arc:propertydef[@identifier=current()/@identifierref]/@name}"
												value="{arc:value}"/>
										</xsl:for-each>
									</properties>
								</xsl:variable>
								<xsl:variable name="elementLabel">
									<xsl:call-template name="elementLabel">
										<xsl:with-param name="element" select="$referredElement"/>
										<xsl:with-param name="context">relationship</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="overrideElementStyle"
									select="$config//elementstyle[elementcondition[type = $referredElement/@type or @type = 'any']/propertycondition[@name = $referredElementProperties//property/@name and @value = $referredElementProperties//property/@value]]"/>
								<element id="{$elementRef}"
									name="{$elementLabel}"
									overridingClass="{$overrideElementStyle//cardRelationClass}">
									<elementDocumentation>
										<xsl:value-of
											select="$referredElement/arc:documentation"/>
									</elementDocumentation>
									<documentation>
										<xsl:value-of select="arc:documentation"/>
									</documentation>
								</element>
							</xsl:for-each>
						</type>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</relationships>
	</xsl:template>
	
	<!-- 
		template for creating an alias for the element type 
		@type: 		type of the element
		@return: 	the alias name of the type of the element as it is defined in the configuration file. If no elementmapping is specified the alias is equal to the type.
	-->
	<xsl:template name="elementTypeAlias">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$config//elementmapping[@type = $type]">
				<xsl:value-of select="$config//elementmapping[@type = $type]/@alias"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$type"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- template for creating an alias for the relationship type -->
	<xsl:template name="relationshipTypeAlias">
		<xsl:param name="relationship"/>
		<xsl:param name="direction"/>
		<xsl:variable name="sourceElementType"
			select="//arc:element[@identifier = $relationship/@source]/@type"/>
		<xsl:variable name="targetElementType"
			select="//arc:element[@identifier = $relationship/@target]/@type"/>
		<xsl:choose>
			<xsl:when
				test="$config//relationshipmapping[@type = $relationship/@type and @direction = $direction and @sourceType = $sourceElementType and @targetType = $targetElementType]">
				<xsl:value-of
					select="$config//relationshipmapping[@type = $relationship/@type and @direction = $direction and @sourceType = $sourceElementType and @targetType = $targetElementType]/@alias"
				/>
			</xsl:when>
			<xsl:when
				test="$config//relationshipmapping[@type = $relationship/@type and @direction = $direction and @sourceType = 'any' and @targetType = 'any']">
				<xsl:value-of
					select="$config//relationshipmapping[@type = $relationship/@type and @direction = $direction and @sourceType = 'any' and @targetType = 'any']/@alias"/>
				<xsl:text>&#160;</xsl:text>
				<xsl:call-template name="elementTypeAlias">
					<xsl:with-param name="type">
						<xsl:choose>
							<xsl:when test="$direction = 'to'">
								<xsl:value-of select="$targetElementType"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$sourceElementType"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fn:substring-before($relationship/@type, 'Relationship')"/>
				<xsl:text>&#160;</xsl:text>
				<xsl:value-of select="$direction"/>
				<xsl:text>&#160;</xsl:text>
				<xsl:call-template name="elementTypeAlias">
					<xsl:with-param name="type">
						<xsl:choose>
							<xsl:when test="$direction = 'to'">
								<xsl:value-of select="$targetElementType"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$sourceElementType"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="arc:view[.//arc:node]">
		<xsl:variable name="id" select="@identifier"/>
		<xsl:variable name="avType" select=".//arc:property[@identifierref=//arc:propertydef[@name='av:type']/@identifier]/arc:value"/>
		<div id="panel" class="panel panel-default root-panel">
			<div id="panelheader" class="panel-heading root-panel-heading">
				<h4>
					<xsl:value-of select="arc:label"/>
					<xsl:text>&#160;</xsl:text>
					<xsl:value-of select="$avType"/>
					<xsl:text>&#160;</xsl:text>
					<a id="print" href="browsepage-{@identifier}.html?style=listed" target="_blank">
						<span class="glyphicon glyphicon-print"/>
					</a>
				</h4>
			</div>
			<div id="panelbody" class="panel-body root-panel-body">
				<p>
					<xsl:value-of select="arc:documentation"/>
				</p>
				
				<xsl:if test="$avType='storyboard'">
					<p>
						<xsl:variable name="allViewElements" select="//arc:element[@identifier=current()//arc:node/@elementref]"/>
						<!--xsl:variable name="allPlateauElements" select="//arc:element[@type='Plateau' and @identifier=//arc:relationship[@target=$allViewElements/@identifier]/@source]"/-->
						<xsl:variable name="allPlateauElements" select="//arc:element[@type='Plateau']"/>
						<xsl:for-each select="$allPlateauElements">
							<input class="storyboard-checkbox" type="checkbox" checked="checked" onchange="storyboardEvaluation()"><xsl:value-of select="arc:label"/></input>
						</xsl:for-each>
					</p>
				</xsl:if>
				<div class="col-md-12">
					<!-- calculate svg width and height based on the nodes in the view -->
					<xsl:variable name="maxheight">
						<xsl:for-each select="current()//arc:node">
							<xsl:sort data-type="number" order="descending" select="@y + @h"/>
							<xsl:if test="position() = 1">
								<xsl:value-of select="number(@y) + number(@h)"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="maxwidth">
						<xsl:for-each select="current()//arc:node">
							<xsl:sort data-type="number" order="descending" select="@x + @w"/>
							<xsl:if test="position() = 1">
								<xsl:value-of select="number(@x) + number(@w)"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<svg width="{$maxwidth+25}" height="{$maxheight+25}">
						<rect x="0" y="0" width="{$maxwidth+25}" height="{$maxheight+25}"
							style="stroke:black; fill:none"/>
						<!-- definition of the connection start and end shapes -->
						<defs>
							<marker id="markerCircleEnd" markerWidth="8" markerHeight="8" refX="8"
								refY="5" orient="auto">
								<circle cx="5" cy="5" r="3" style="stroke: none; fill:#000000;"/>
							</marker>
							<marker id="markerCircleStart" markerWidth="8" markerHeight="8" refX="2"
								refY="5" orient="auto">
								<circle cx="5" cy="5" r="3" style="stroke: none; fill:#000000;"/>
							</marker>
							<marker id="markerOpenDiamond" markerWidth="16" markerHeight="16"
								refX="2" refY="5" orient="auto">
								<path d="M10,1 L3,5 L10,9 L18,5 Z"
									style="fill: white; stroke:black; stroke-width:1"/>
							</marker>
							<marker id="markerClosedDiamond" markerWidth="16" markerHeight="16"
								refX="2" refY="5" orient="auto">
								<path d="M10,1 L3,5 L10,9 L18,5 Z"
									style="fill: black; stroke:black; stroke-width:1"/>
							</marker>
							<marker id="markerClosedBlockArrow" markerWidth="13" markerHeight="13"
								refX="10" refY="6" orient="auto">
								<path d="M0,0 L9,6 L0,12 Z"
									style="stroke:black; stroke-width:1; fill: black; "/>
							</marker>
							<marker id="markerOpenBlockArrow" markerWidth="13" markerHeight="13"
								refX="10" refY="6" orient="auto">
								<path d="M0,0 L9,6 L0,12 Z"
									style="stroke:black; stroke-width:1; stroke-dasharray:1,0; fill: white; "/>
							</marker>
							<marker id="markerOpenArrow" markerWidth="13" markerHeight="13"
								refX="10" refY="6" orient="auto">
								<path d="M2,2 L9,6 L2,10"
									style="fill: none; stroke: black; stroke-dasharray:1,0; stroke-width:1"/>
							</marker>
							<marker id="markerClosedArrow" markerWidth="13" markerHeight="13"
								refX="10" refY="6" orient="auto">
								<path d="M2,2 L9,6 L2,10 Z"
									style="fill: black; stroke: black; stroke-dasharray:1,0;stroke-width:1"/>
							</marker>
						</defs>
						<!-- create all the nodes -->
						<xsl:apply-templates select="arc:node"/>
						<!-- create all the connections -->
						<xsl:for-each select="arc:connection">
							<xsl:call-template name="svgconnection"/>
						</xsl:for-each>
					</svg>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="arc:node">
		<!-- view type -->
		<xsl:variable name="avType" select="ancestor::arc:view//arc:property[@identifierref=//arc:propertydef[@name='av:type']/@identifier]/arc:value"/>
		<!-- include here also views since we could have a reference to a view in some tools -->
		<xsl:variable name="element" select="//arc:*[@identifier = current()/@elementref]"/>
		<!-- select the properties of the node element or view -->
		<xsl:variable name="properties">
			<properties>
				<xsl:for-each select="$element//arc:property">
					<property name="{//arc:propertydef[@identifier=current()/@identifierref]/@name}"
						value="{arc:value}"/>
				</xsl:for-each>
			</properties>
		</xsl:variable>
		<!-- the style of the node (only fill color) can be overridden depending on
			- the element is the same type or 'any'
			- one of the properties has an exact match on the name and value
		-->
		<xsl:variable name="overrideNodeStyle">
			<xsl:choose>
				<xsl:when test="$config//nodestyle[elementcondition[@type = $element/@type]/propertycondition[@name = $properties//property/@name and @value = $properties//property/@value]]">
					<xsl:copy-of select="$config//nodestyle[elementcondition[@type = $element/@type]/propertycondition[@name = $properties//property/@name and @value = $properties//property/@value]]"/>
				</xsl:when>
				<xsl:when test="$config//nodestyle[elementcondition[@type = 'all']/propertycondition[@name = $properties//property/@name and @value = $properties//property/@value]]">
					<xsl:copy-of select="$config//nodestyle[elementcondition[@type = 'all']/propertycondition[@name = $properties//property/@name and @value = $properties//property/@value]]"/>
				</xsl:when>
				<xsl:when test="$config//nodestyle[elementcondition[@type = $element/@type]]">
					<xsl:copy-of select="$config//nodestyle[elementcondition[@type = $element/@type]]"/>
				</xsl:when>
				<xsl:when test="$config//nodestyle[elementcondition[@type = 'all']]">
					<xsl:copy-of select="$config//nodestyle[elementcondition[@type = 'all']]"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fillColor">
			<xsl:choose>
				<xsl:when test="$overrideNodeStyle//fillColor">
					<xsl:value-of select="$overrideNodeStyle//fillColor"/>
				</xsl:when>
				<xsl:when test="arc:style/arc:fillColor">
					<xsl:value-of
						select="concat('rgb(', arc:style/arc:fillColor/@r, ',', arc:style/arc:fillColor/@g, ',', arc:style/arc:fillColor/@b, ')')"
					/>
				</xsl:when>
				<!-- set default node color to white -->
				<xsl:otherwise>
					rgb(255,255,255)
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="strokeColor">
			<xsl:choose>
				<xsl:when test="arc:style/arc:strokeColor">
					<xsl:value-of select="concat('rgb(', arc:style/arc:lineColor/@r, ',', arc:style/arc:lineColor/@g, ',', arc:style/arc:lineColor/@b, ')')"/>
				</xsl:when>
				<!-- set default stroke color to black -->
				<xsl:otherwise>
					rgb(0,0,0)
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:variable name="svgStyle"
			select="concat('fill:', $fillColor, '; stroke-width:1;', 'stroke:', $strokeColor, ';')"/>
		
		<xsl:variable name="x1" select="@x"/>
		<xsl:variable name="y1" select="@y"/>
		<xsl:variable name="w" select="@w"/>
		<xsl:variable name="h" select="@h"/>
		<xsl:variable name="x2" select="$x1 + $w"/>
		<xsl:variable name="y2" select="$y1 + $h"/>
		
		<xsl:choose>
			<!-- draw an element or view node -->
			<xsl:when test="@elementref">
				<a xlink:href="browsepage-{@elementref}.html">
					<xsl:if test="$avType='storyboard'">
						<xsl:variable name="plateauElements" select="//arc:element[@type='Plateau' and @identifier=//arc:relationship[@target=$element/@identifier]/@source]"/>
						<property id="Plateau" value="{$plateauElements/@arc:label}"/> 
					</xsl:if>
					<!-- create the node shape -->
					<xsl:choose>
						<xsl:when
							test="
								$element/@type = 'BusinessProcess' or $element/@type = 'BusinessInteraction' or $element/@type = 'BusinessFunction' or
								$element/@type = 'BusinessService' or $element/@type = 'ApplicationService' or $element/@type = 'InfrastructureService' or
								$element/@type = 'BusinessFunction' or $element/@type = 'ApplicationFunction' or $element/@type = 'InfrastructureFunction' or
								$element/@type = 'BusinessEvent' or $element/@type = 'BusinessProcess'">
							<rect x="{$x1}" y="{$y1}" rx="10" ry="10" width="{$w}" height="{$h}"
								style="{$svgStyle}"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Value'">
							<!-- need to set width for text wrapping -->
							<ellipse cx="{$x1 + $w div 2}" cy="{$y1 + $h div 2}" width="{$w}"
								rx="{$w div 2}" ry="{$h div 2}" style="{$svgStyle}"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Product'">
							<rect x="{$x1}" y="{$y1}" width="{$w}" height="{$h}"
								style="{$svgStyle}"/>
							<!-- need to set width for text wrapping -->
							<path d="M{$x1},{$y1+6} h{$w div 2} v-6" width="{$w}"
								style="{$svgStyle}"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'DataObject' or $element/@type = 'BusinessObject'">
							<rect x="{$x1}" y="{$y1}" width="{$w}" height="{$h}"
								style="{$svgStyle}"/>
							<!-- need to set width for text wrapping -->
							<line x1="{$x1}" y1="{$y1+6}" x2="{$x2}" y2="{$y1+6}" width="{$w}"
								style="{$svgStyle}"/>
						</xsl:when>
						<xsl:otherwise>
							<rect x="{$x1}" y="{$y1}" width="{$w}" height="{$h}"
								style="{$svgStyle}"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- set the text -->
					<!--xsl:variable name="stereotype"><xsl:value-of select="//arc:specializedConceptDefinition[@identifier=$element/@specializationref]/arc:label"/></xsl:variable-->
					<text text-anchor="middle" x="{$x1 + 5}" y="{$y1 + 8}" width="{$w - 60}"
						font-size="12">
						<!--xsl:if test="$stereotype != ''">&lt;&lt;<xsl:value-of select="$stereotype"/>&gt;&gt;</xsl:if-->
						<xsl:call-template name="elementLabel">
							<xsl:with-param name="element" select="$element"/>
							<xsl:with-param name="context">node</xsl:with-param>
						</xsl:call-template>
					</text>
					<!-- set the node symbol -->
					<xsl:choose>
						<xsl:when test="$element/@type = 'SystemSoftware'">
							<circle cx="{$x2 - 10}" cy="{$y1 + 10}" r="5" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
							<circle cx="{$x2 - 12}" cy="{$y1 + 12}" r="5" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Node'">
							<path
								d="M{$x2 - 18},{$y1 + 8} L{$x2 - 15},{$y1 + 5} h10 v10 L{$x2 - 8},{$y1 + 18}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<line x1="{$x2+-5}" y1="{$y1+5}" x2="{$x2+-8}" y2="{$y1+8}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<rect x="{$x2+-18}" y="{$y1+8}" width="10" height="10"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Device'">
							<path
								d="M{$x2+-17},{$y1+18} L{$x2+-9},{$y1+11} L{$x2+-3},{$y1+18} L{$x2+-17},{$y1+18}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<rect x="{$x2+-15}" y="{$y1+5}" width="11" height="9"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'ApplicationComponent'">
							<rect x="{$x2+-15}" y="{$y1+5}" width="10" height="14"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<rect x="{$x2+-18}" y="{$y1+7}" width="6" height="3" fill="{$fillColor}"
								stroke="black" stroke-width="0.75"/>
							<rect x="{$x2+-18}" y="{$y1+13}" width="6" height="3"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessRole' or $element/@type = 'Stakeholder'">
							<circle cx="{$x2+-17}" cy="{$y1+10}" r="4" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
							<rect x="{$x2+-17}" y="{$y1+5}" width="6" height="10"
								fill="{$fillColor}" stroke="${fillColor}" stroke-width="0.75"/>
							<circle cx="{$x2+-10}" cy="{$y1+10}" r="4" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
							<line x1="{$x2+-17}" y1="{$y1+6}" x2="{$x2+-11}" y2="{$y1+6}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<line x1="{$x2+-17}" y1="{$y1+14}" x2="{$x2+-11}" y2="{$y1+14}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'BusinessActor'">
							<circle cx="{$x2+-9}" cy="{$y1+7}" r="3" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
							<line x1="{$x2+-9}" y1="{$y1+10}" x2="{$x2+-9}" y2="{$y1+16}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<line x1="{$x2+-13}" y1="{$y1+12}" x2="{$x2+-5}" y2="{$y1+12}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<line x1="{$x2+-9}" y1="{$y1+16}" x2="{$x2+-13}" y2="{$y1+21}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<line x1="{$x2+-9}" y1="{$y1+16}" x2="{$x2+-5}" y2="{$y1+21}"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'BusinessProcess'">
							<path
								d="M{$x2 - 18},{$y1+8} h9 v-3 L{$x2 - 5},{$y1+10} L{$x2 - 9},{$y1+15} v-3 h-9 Z"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Contract'">
							<rect x="{$x2 - 18}" y="{$y1+5}" width="12" height="10"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
							<path d="M{$x2 - 18},{$y1+8} h12" fill="{$fillColor}" stroke="black"
								stroke-width="0.75"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessInteraction' or $element/@type = 'ApplicationInteraction'">
							<path d="M{$x2 - 12} {$y1+6} A 5 5 0 0 0 {$x2 - 12} {$y1 + 16} Z"
								fill="{$fillColor}" stroke="black" stroke-width="1"/>
							<path d="M{$x2 - 9} {$y1+16} A 5 5 0 0 0 {$x2 - 9} {$y1 + 6} Z"
								fill="{$fillColor}" stroke="black" stroke-width="1"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessCollaboration' or $element/@type = 'ApplicationCollaboration'">
							<circle cx="{$x2 - 14}" cy="{$y1+11}" r="5" fill="none" stroke="black"
								stroke-width="1"/>
							<circle cx="{$x2 - 10}" cy="{$y1+11}" r="5" fill="none" stroke="black"
								stroke-width="1"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessInterface' or $element/@type = 'ApplicationInterface' or $element/@type = 'InfrastructureInterface'">
							<circle cx="{$x2 - 8}" cy="{$y1+10}" r="4" fill="{$fillColor}"
								stroke="black" stroke-width="1"/>
							<path d="M{$x2 - 13},{$y1+10} h-5" fill="none" stroke="black"
								stroke-width="1"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessFunction' or $element/@type = 'ApplicationFunction' or $element/@type = 'InfrastructureFunction'">
							<path d="M{$x2 - 8},{$y1+5} l5,5 v5 l-5,-5 l-5,5 v-5 Z" fill="none"
								stroke="black" stroke-width="1"/>
						</xsl:when>
						<xsl:when
							test="$element/@type = 'BusinessService' or $element/@type = 'ApplicationService' or $element/@type = 'InfrastructureService'">
							<rect x="{$x2 - 22}" y="{$y1+5}" rx="3" ry="3" width="13" height="7"
								fill="{$fillColor}" stroke="black" stroke-width="0.75"/>
						</xsl:when>
						<xsl:when test="$element/@type = 'Meaning'"> </xsl:when>
						<xsl:when test="$element/@type = 'Representation'"> </xsl:when>
						<xsl:when test="$element/@type = 'Location'"> </xsl:when>
						<xsl:when test="$element/@type = 'Artifact'"> </xsl:when>
						<xsl:when test="$element/@type = 'Driver'"> </xsl:when>
						<xsl:when test="$element/@type = 'Assessment'"> </xsl:when>
						<xsl:when test="$element/@type = 'Goal'"> </xsl:when>
						<xsl:when test="$element/@type = 'Principle'"> </xsl:when>
						<xsl:when test="$element/@type = 'Requirement'"> </xsl:when>
						<xsl:when test="$element/@type = 'Constraint'"> </xsl:when>
						<xsl:when test="$element/@type = 'CommunicationPath'"> </xsl:when>
						<xsl:when test="$element/@type = 'Network'"> </xsl:when>
					</xsl:choose>
				</a>
			</xsl:when>
			<!-- draw group box -->
			<xsl:when test="@type='group'">
				<xsl:variable name="colorratio">0.9</xsl:variable>
				<rect x="{$x1}" y="{$y1}" width="{$w div 2}" height="17"
					style="fill:rgb({fn:round(arc:style/arc:fillColor/@r * $colorratio)},{fn:round(arc:style/arc:fillColor/@g * $colorratio)},{fn:round(arc:style/arc:fillColor/@b * $colorratio)}); strokewidth:1; stroke:{$strokeColor}"/>
				<rect x="{$x1}" y="{$y1+17}" width="{$w}" height="{$h - 16}" style="{$svgStyle}"/>
				<text x="{$x1+5}" y="{$y1+2}" width="{$w}" font-size="12">
					<xsl:value-of select="arc:label"/>
				</text>
			</xsl:when>
			<xsl:otherwise>
				<rect x="{$x1}" y="{$y1}" width="{$w}" height="{$h}" style="{$svgStyle}"/>
				<text x="{$x1+5}" y="{$y1+2}" width="{$w}" font-size="12">
					<xsl:value-of select="arc:label"/>
				</text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="arc:node"/>

	</xsl:template>
	
	<!-- Create the customized label for an element -->
	<xsl:template name="elementLabel">
		<xsl:param name="element"/>
		<xsl:param name="context"/>
		<xsl:if test="$config/configuration/elementLabel[@includeGrouping='true' and @context=$context]">
			<xsl:variable name="elementGroupName">
				<xsl:call-template name="elementGroupName">
					<xsl:with-param name="element" select="$element"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$elementGroupName != ''">
				[<xsl:value-of select="$elementGroupName"/>]<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:value-of select="$element/arc:label"/>
		<xsl:if test="$config/configuration/elementLabel[@includeType='true' and @context=$context]">
			<xsl:text> </xsl:text>
			(<xsl:call-template name="elementTypeAlias">
				<xsl:with-param name="type" select="$element/@type"/>
			</xsl:call-template>)
		</xsl:if>
	</xsl:template>
	
	<!-- 
		Create the group name for the element.
	-->
	<xsl:template name="elementGroupName">
		<xsl:param name="element"></xsl:param>
		<xsl:variable name="groupName">
			<xsl:choose>
				<xsl:when test="$element/@type='SystemSoftware'">
					<xsl:value-of select="//arc:element[@identifier = //arc:relationship[@target=$element/@identifier and @type='AssignmentRelationship']/@source]/arc:label"/>
				</xsl:when>
				<xsl:when test="$element/@type='Device'">
					<xsl:value-of select="$element/arc:label"/>
				</xsl:when>
				<xsl:when test="$element/@type='Artifact'">
					<xsl:value-of select="//arc:element[@identifier = //arc:relationship[@target=$element/@identifier and @type='AssignmentRelationship']/@source]/arc:label"/>
				</xsl:when>
				<xsl:when test="$element/@type='InfrastructureService' and //arc:relationship[@target=$element/@identifier and @type='RealisationRelationship']">
					<xsl:value-of select="//arc:element[@identifier = //arc:relationship[@target=$element/@identifier and @type='RealisationRelationship']/@source]/arc:label"/>
				</xsl:when>
				<xsl:when test="$element/@type='InfrastructureService'">
					<xsl:call-template name="elementGroupName">
						<xsl:with-param name="element" select="//arc:element[@identifier = //arc:relationship[@source=$element/@identifier and @type='UsedByRelationship']/@target]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$element/@type='ApplicationFunction'">
					<xsl:value-of select="//arc:element[@identifier = //arc:relationship[@target=$element/@identifier and @type='AssignmentRelationship']/@source]/arc:label"/>
				</xsl:when>
				<xsl:when test="$element/@type='ApplicationService'">
					<xsl:call-template name="elementGroupName">
						<xsl:with-param name="element"  select="//arc:element[@identifier = //arc:relationship[@target=$element/@identifier and @type='RealisationRelationship']/@source]"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$groupName"/>
	</xsl:template>

	<xsl:template name="svgconnection">
		<xsl:variable name="relationshipid" select="@relationshipref"/>
		<xsl:variable name="relationship" select="//arc:relationship[@identifier = $relationshipid]"/>
		<xsl:variable name="strokeColor">
			<xsl:choose>
				<xsl:when test="arc:style/arc:strokeColor">
					<xsl:value-of select="concat('rgb(', arc:style/arc:lineColor/@r, ',', arc:style/arc:lineColor/@g, ',', arc:style/arc:lineColor/@b, ')')"/>
				</xsl:when>
				<!-- set default stroke color to black -->
				<xsl:otherwise>
					rgb(0,0,0)
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		<xsl:variable name="sourceid" select="@source"/>
		<xsl:variable name="targetid" select="@target"/>
		<xsl:variable name="sourcenode" select="..//arc:node[@identifier = $sourceid]"/>
		<xsl:variable name="targetnode" select="..//arc:node[@identifier = $targetid]"/>
		<xsl:variable name="sourcex" select="number($sourcenode/@x)"/>
		<xsl:variable name="sourcey" select="number($sourcenode/@y)"/>
		<xsl:variable name="sourcew" select="number($sourcenode/@w)"/>
		<xsl:variable name="sourceh" select="number($sourcenode/@h)"/>
		<xsl:variable name="targetx" select="number($targetnode/@x)"/>
		<xsl:variable name="targety" select="number($targetnode/@y)"/>
		<xsl:variable name="targetw" select="number($targetnode/@w)"/>
		<xsl:variable name="targeth" select="number($targetnode/@h)"/>

		<xsl:variable name="bendpoint">
			<xsl:for-each select="arc:bendpoint"> L<xsl:value-of select="@x"/>,<xsl:value-of
					select="@y"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- select the start shape of the connection -->
		<xsl:variable name="markerstart">
			<xsl:choose>
				<xsl:when test="$relationship/@type = 'AssignmentRelationship'">marker-start:
					url(#markerCircleStart);</xsl:when>
				<xsl:when test="$relationship/@type = 'AggregationRelationship'">marker-start:
					url(#markerOpenDiamond);</xsl:when>
				<xsl:when test="$relationship/@type = 'CompositionRelationship'">marker-start:
					url(#markerClosedDiamond);</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- select the end shape of the connection -->
		<xsl:variable name="markerend">
			<xsl:choose>
				<xsl:when test="$relationship/@type = 'UsedByRelationship'">marker-end:
					url(#markerOpenArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'AccessRelationship'">marker-end:
					url(#markerOpenArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'AssignmentRelationship'">
					<xsl:choose>
						<xsl:when test="$archimateVersion='3.0'">
							marker-end:url(#markerClosedArrow);
						</xsl:when>
						<xsl:otherwise>
							marker-end:url(#markerCircleEnd);
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$relationship/@type = 'RealisationRelationship'">marker-end:
					url(#markerOpenBlockArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'SpecialisationRelationship'">marker-end:
					url(#markerOpenBlockArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'TriggeringRelationship'">marker-end:
					url(#markerClosedArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'FlowRelationship'">marker-end:
					url(#markerClosedArrow);</xsl:when>
				<xsl:when test="$relationship/@type = 'InfluenceRelationship'">
					<xsl:choose>
						<xsl:when test="$archimateVersion='3.0'">
							marker-end:url(#markerOpenArrow);
						</xsl:when>
						<xsl:otherwise>
							marker-end:url(#markerClosedArrow);
						</xsl:otherwise>
					</xsl:choose></xsl:when>
				<!-- 3.0 support -->
				<xsl:when test="$relationship/@type = 'ServingRelationship'">marker-end:
					url(#markerOpenArrow);</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- select the line dash if necessary -->
		<xsl:variable name="dash">
			<xsl:choose>
				<xsl:when test="$relationship/@type = 'AccessRelationship'"
					>stroke-dasharray:3,3;</xsl:when>
				<xsl:when test="$relationship/@type = 'RealisationRelationship'"
					>stroke-dasharray:5,3;</xsl:when>
				<xsl:when test="$relationship/@type = 'FlowRelationship'"
					>stroke-dasharray:5,3;</xsl:when>
				<xsl:when test="$relationship/@type = 'InfluenceRelationship'"
					>stroke-dasharray:5,3;</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- the second point of the connection as a rectangle. If no bendpoints are defined this is the target node -->
		<xsl:variable name="next">
			<xsl:choose>
				<xsl:when test="arc:bendpoint">
					<rect x="{number(arc:bendpoint[1]/@x)}" y="{number(arc:bendpoint[1]/@y)}" w="0"
						h="0"/>
				</xsl:when>
				<xsl:otherwise>
					<rect x="{$targetx}" y="{$targety}" w="{$targetw}" h="{$targeth}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- the 2nd last point of the connection as a rectangle. If no bendpoints are defined this is the soure node -->
		<xsl:variable name="previous">
			<xsl:choose>
				<xsl:when test="arc:bendpoint">
					<rect x="{number(arc:bendpoint[position()=last()]/@x)}"
						y="{number(arc:bendpoint[position()=last()]/@y)}" w="0" h="0"/>
				</xsl:when>
				<xsl:otherwise>
					<rect x="{$sourcex}" y="{$sourcey}" w="{$sourcew}" h="{$sourceh}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- the x coordinate of the start point of the connection -->
		<xsl:variable name="startx">
			<xsl:choose>
				<xsl:when test="$sourcex + $sourcew &lt;= $next/rect/@x">
					<xsl:value-of select="$sourcex + $sourcew"/>
				</xsl:when>
				<xsl:when test="$sourcex &gt;= $next/rect/@x + $next/rect/@w">
					<xsl:value-of select="$sourcex"/>
				</xsl:when>
				<xsl:when
					test="$sourcex &gt;= $next/rect/@x and $sourcex + $sourcew &lt;= $next/rect/@x + $next/rect/@w">
					<xsl:value-of select="$sourcex + $sourcew div 2"/>
				</xsl:when>
				<xsl:when
					test="$sourcex &lt; $next/rect/@x and $sourcex + $sourcew &gt; $next/rect/@x + $next/rect/@w">
					<xsl:value-of select="$next/rect/@x + $next/rect/@w div 2"/>
				</xsl:when>
				<xsl:when
					test="$next/rect/@x &lt; $sourcex + $sourcew div 2 and $next/rect/@x + $next/rect/@w &gt; $sourcex + $sourcew div 2">
					<xsl:value-of select="$sourcex + $sourcew div 2"/>
				</xsl:when>
				<xsl:when
					test="$sourcex &lt; $next/rect/@x + $next/rect/@w div 2 and $sourcex + $sourcew &gt; $next/rect/@x + $next/rect/@w div 2">
					<xsl:value-of select="$next/rect/@x + $next/rect/@w div 2"/>
				</xsl:when>
				<xsl:when test="$sourcex &gt; $next/rect/@x">
					<xsl:value-of select="$next/rect/@x + $next/rect/@w - 10"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$next/rect/@x + 10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="starty">
			<xsl:choose>
				<xsl:when test="$sourcey + $sourceh &lt;= $next/rect/@y">
					<xsl:value-of select="$sourcey + $sourceh"/>
				</xsl:when>
				<xsl:when test="$sourcey &gt;= $next/rect/@y + $next/rect/@h">
					<xsl:value-of select="$sourcey"/>
				</xsl:when>
				<xsl:when
					test="$sourcey &gt;= $next/rect/@y and $sourcey + $sourceh &lt;= $next/rect/@y + $next/rect/@h">
					<xsl:value-of select="$sourcey + $sourceh div 2"/>
				</xsl:when>
				<xsl:when
					test="$sourcey &lt; $next/rect/@y and $sourcey + $sourceh &gt; $next/rect/@y + $next/rect/@h">
					<xsl:value-of select="$next/rect/@y + $next/rect/@h div 2"/>
				</xsl:when>
				<xsl:when
					test="$next/rect/@y &lt; $sourcey + $sourceh div 2 and $next/rect/@y + $next/rect/@h &gt; $sourcey + $sourceh div 2">
					<xsl:value-of select="$sourcey + $sourceh div 2"/>
				</xsl:when>
				<xsl:when
					test="$sourcey &lt; $next/rect/@y + $next/rect/@h div 2 and $sourcey + $sourceh &gt; $next/rect/@y + $next/rect/@h div 2">
					<xsl:value-of select="$next/rect/@y + $next/rect/@h div 2"/>
				</xsl:when>
				<xsl:when test="$sourcey &gt; $next/rect/@y">
					<xsl:value-of select="$next/rect/@y + $next/rect/@h - 10"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$next/rect/@y + 10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endx">
			<xsl:choose>
				<xsl:when test="$targetx + $targetw &lt;= $previous/rect/@x">
					<xsl:value-of select="$targetx + $targetw"/>
				</xsl:when>
				<xsl:when test="$targetx &gt;= $previous/rect/@x + $previous/rect/@w">
					<xsl:value-of select="$targetx"/>
				</xsl:when>
				<xsl:when
					test="$targetx &gt;= $previous/rect/@x and $targetx + $targetw &lt;= $previous/rect/@x + $previous/rect/@w">
					<xsl:value-of select="$targetx + $targetw div 2"/>
				</xsl:when>
				<xsl:when
					test="$targetx &lt; $previous/rect/@x and $targetx + $targetw &gt; $previous/rect/@x + $previous/rect/@w">
					<xsl:value-of select="$previous/rect/@x + $previous/rect/@w div 2"/>
				</xsl:when>
				<xsl:when
					test="$targetx &lt; $previous/rect/@x + $previous/rect/@w div 2 and $targetx + $targetw &gt; $previous/rect/@x + $previous/rect/@w div 2">
					<xsl:value-of select="$previous/rect/@x + $previous/rect/@w div 2"/>
				</xsl:when>
				<xsl:when
					test="$previous/rect/@x &lt; $targetx + $targetw div 2 and $previous/rect/@x + $previous/rect/@w &gt; $targetx + $targetw div 2">
					<xsl:value-of select="$targetx + $targetw div 2"/>
				</xsl:when>
				<xsl:when test="$targetx &gt; $previous/rect/@x">
					<xsl:value-of select="$targetx + 10"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$targetx + $targetw - 10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="endy">
			<xsl:choose>
				<xsl:when test="$targety + $targeth &lt;= $previous/rect/@y">
					<xsl:value-of select="$targety + $targeth"/>
				</xsl:when>
				<xsl:when test="$targety &gt;= $previous/rect/@y + $previous/rect/@h">
					<xsl:value-of select="$targety"/>
				</xsl:when>
				<xsl:when
					test="$targety &gt;= $previous/rect/@y and $targety + $targeth &lt;= $previous/rect/@y + $previous/rect/@h">
					<xsl:value-of select="$targety + $targeth div 2"/>
				</xsl:when>
				<xsl:when
					test="$targety &lt; $previous/rect/@y and $targety + $targeth &gt; $previous/rect/@y + $previous/rect/@h">
					<xsl:value-of select="$previous/rect/@y + $previous/rect/@h div 2"/>
				</xsl:when>
				<xsl:when
					test="$targety &lt; $previous/rect/@y + $previous/rect/@h div 2 and $targety + $targeth &gt; $previous/rect/@y + $previous/rect/@h div 2">
					<xsl:value-of select="$previous/rect/@y + $previous/rect/@h div 2"/>
				</xsl:when>
				<xsl:when
					test="$previous/rect/@y &lt; $targety + $targeth div 2 and $previous/rect/@y + $previous/rect/@h &gt; $targety + $targeth div 2">
					<xsl:value-of select="$targety + $targeth div 2"/>
				</xsl:when>
				<xsl:when test="$targety &gt; $previous/rect/@y">
					<xsl:value-of select="$targety + 10"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$targety + $targeth - 10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<path d="M{$startx},{$starty} {$bendpoint} L{$endx},{$endy}"
			style="stroke:{$strokeColor};stroke-width:1; fill:none; {$dash} {$markerstart} {$markerend}"/>

	</xsl:template>


</xsl:stylesheet>
