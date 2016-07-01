<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
    xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	>
<xsl:param name="folder"/>

<xsl:template match="/">
	<xsl:for-each select="//arc:element | //arc:view">
		<xsl:result-document method="html" href="{$folder}/browsepage-{@identifier}.html">
			<html>
				<head>
				´	<title><xsl:value-of select="arc:label"/></title>
					<meta charset="utf-8"/>
					<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
					<!-- JQUERY (use 1.x branch to be compatible with IE 6/7/8) / UI / LAYOUT -->
					<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
					<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" integrity="sha256-xNjb53/rY+WmG+4L6tTl9m6PpqknWZvRt0rO1SRnJzw=" crossorigin="anonymous"></script>	<script type="text/javascript" src="lib/jquery-ui-layout/js/jquery.layout-1.4.4.js"></script>				
					<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-layout/1.4.3/jquery.layout.min.js"></script>
					<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-layout/1.4.3/layout-default.min.css"/>
					<!-- BOOTSTRAP -->
					<!-- Latest compiled and minified CSS -->
					<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/>
					<!-- Optional theme -->
					<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous"/>
					<!-- Latest compiled and minified JavaScript -->
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
					<!-- D3PLUS -->
					<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>
					<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3plus/1.9.5/d3plus.min.js"></script>
					<!-- REPORT SPECIFIC -->
					<link type="text/css" rel="stylesheet" href="css/model.css"/>
					<script type="text/javascript" src="js/browse.js"></script>
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
<xsl:template match="arc:view[arc:properties/arc:property[@identifierref=//arc:propertydef[@name='xfolder']/@identifier]]">
	<xsl:variable name="xfolder"><xsl:value-of select="arc:properties/arc:property[@identifierref=//arc:propertydef[@name='xfolder']/@identifier]/arc:value"/></xsl:variable>
	<xsl:variable name="yfolder"><xsl:value-of select="arc:properties/arc:property[@identifierref=//arc:propertydef[@name='yfolder']/@identifier]/arc:value"/></xsl:variable>
	<div class="panel panel-default root-panel">
		<div class="panel-heading root-panel-heading">
			<b><xsl:value-of select="arc:label"/></b><xsl:text> </xsl:text><a href="printpage-{@identifier}.html" target="_blank"><span class="glyphicon glyphicon-print"/></a>
		</div>
		<div class="panel-body root-panel-body">
			<div class="col-md-12">
				<table class="table table-condensed table-bordered">
					<tr>
						<td/>
						<xsl:for-each select="/arc:model/arc:organization//arc:item[arc:label=$xfolder]//arc:item[@identifierref]">
							<xsl:variable name="columnid" select="@identifierref"/>
							<td class="text-left"><xsl:value-of select="//arc:element[@identifier=$columnid]/arc:label"/></td>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="/arc:model/arc:organization//arc:item[arc:label=$yfolder]//arc:item[@identifierref]">
						<xsl:variable name="rowid" select="@identifierref"/>
						<tr>
							<td><xsl:value-of select="//arc:element[@identifier=$rowid]/arc:label"/></td>
							<xsl:for-each select="/arc:model/arc:organization//arc:item[arc:label=$xfolder]//arc:item[@identifierref]">
								<xsl:variable name="columnid" select="@identifierref"/>
								<td class="text-center"><xsl:if test="//arc:relationship[@source=$rowid and @target=$columnid]">X</xsl:if><xsl:if test="//arc:relationship[@target=$rowid and @source=$columnid]">X</xsl:if></td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</table>
			</div>
		</div>
	</div>
</xsl:template>

<!-- template for creating a catalog view -->
<xsl:template match="arc:view[arc:properties/arc:property[@identifierref=//arc:propertydef[@name='folder']/@identifier]]">
	<xsl:variable name="folder"><xsl:value-of select="arc:properties/arc:property[@identifierref=//arc:propertydef[@name='folder']/@identifier]/arc:value"/></xsl:variable>
	<div class="panel panel-default root-panel">
		<div class="panel-heading root-panel-heading">
			<b><xsl:value-of select="arc:label"/></b>
		</div>
		<div class="panel-body root-panel-body">
			<div class="col-md-12">
				<xsl:variable name="properties" select="/arc:model/arc:propertydefs/arc:propertydef[@identifier=//arc:element[@identifier=/arc:model/arc:organization//arc:item[arc:label=$folder]//arc:item/@identifierref]//arc:property/@identifierref]"/>
				<!--xsl:for-each-group select="/arc:model/arc:organization//arc:item[arc:label=$folder]" group-by="//arc:element[@identifier=current()/arc:item/@identifierred]/@xsi:type">
					<h4><xsl:value-of select="current-group()/@xsi:type"/></h4-->
					<table class="table table-condensed table-bordered">
						<tr>
							<th>Name</th>
							<th>Documentation</th>
							<xsl:for-each select="$properties">
								<th><xsl:value-of select="@name"/></th>
							</xsl:for-each>
						</tr>
						<xsl:for-each select="/arc:model/arc:organization//arc:item[arc:label=$folder]//arc:item[@identifierref]">
							<xsl:sort select="//arc:element[@identifier=current()/@identifierref]/arc:label"/>
							<xsl:variable name="element" select="//arc:element[@identifier=current()/@identifierref]"/>
							<tr>
								<td class="text-left"><a href="browsepage-{$element/@identifier}.html"><xsl:value-of select="$element/arc:label"/></a></td>
								<td class="documentation"><xsl:value-of select="$element/arc:documentation"/></td>
								<xsl:for-each select="$properties">
									<td>
										<xsl:choose>
											<xsl:when test="$element//arc:property[@identifierref=current()/@identifier and arc:value!='']">
												<xsl:value-of select="$element//arc:property[@identifierref=current()/@identifier]/arc:value"/>
											</xsl:when>
											<xsl:when test="$element//arc:property[@identifierref=current()/@identifier]">
												<i class="glyphicon glyphicon-ok"/>
											</xsl:when>
										</xsl:choose>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:for-each>
					</table>
				<!--/xsl:for-each-group-->
			
			</div>
		</div>
	</div>
</xsl:template>


<xsl:template match="arc:element">
	<xsl:variable name="type" select="@xsi:type"/>
	<xsl:variable name="id" select="@identifier"/>
	<div class="panel panel-default root-panel">
		<div class="panel-heading root-panel-heading">
			<h4><xsl:value-of select="@xsi:type"/>&#160;<xsl:value-of select="arc:label"/></h4>
		</div>
		<div class="panel-body root-panel-body">
			
			<div class="col-md-12">
				<xsl:if test="arc:documentation">
					<p class="documentation well"><xsl:value-of select="arc:documentation"/></p>
				</xsl:if>
				<ol class="breadcrumb">	
					<xsl:for-each select="/arc:model/arc:organization//arc:item[@identifierref=$id]/ancestor::arc:item[arc:label]">
						<li><xsl:value-of select="arc:label"/></li>
					</xsl:for-each>	
				</ol>
				<table class="table table-condensed small">
					<xsl:for-each select="arc:properties/arc:property">
						<xsl:variable name="propertyid" select="@identifierref"/>
						<tr>
							<td class="col-md-2"><xsl:value-of select="/arc:model/arc:propertydefs/arc:propertydef[@identifier=$propertyid]/@name"/></td>
							<td class="col-md-10"><xsl:value-of select="./arc:value"/></td>
						</tr>
					</xsl:for-each>
				</table>
				<h4>Shown in Views</h4>
				<table class="table table-hover table-condensed small">
					<!-- list of views in which the element appears -->
					<xsl:for-each select="/arc:model/arc:views/arc:view//arc:node[@elementref=$id]/ancestor::arc:view">
						<tr>
							<xsl:variable name="viewid" select="@identifier"/>
							<td class="col-md-10">
								<a href="browsepage-{$viewid}.html"><xsl:value-of select="arc:label"/></a>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				<!-- list of relationships of the element -->
				<xsl:for-each-group select="/arc:model/arc:relationships/arc:relationship[@source=$id]" group-by="//arc:element[@identifier=current()/@target]/@xsi:type">
					<h4><xsl:value-of select="//arc:element[@identifier=current()/@target]/@xsi:type"/></h4>
					<table class="table table-hover table-condensed small"> 
						<xsl:for-each select="current-group()">
							<xsl:sort select="@xsi:type"/>
							<tr>
								<xsl:variable name="targetid" select="@target"/>
								<td class="col-md-2">
									<xsl:value-of select="fn:substring-before(@xsi:type,'Relationship')"/>&#160;to
								</td>
								<td class="col-md-10">
									<a href="browsepage-{$targetid}.html"> 
										<xsl:value-of select="/arc:model/arc:elements/arc:element[@identifier=$targetid]/arc:label"/>
									</a>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:for-each-group>
				<xsl:for-each-group select="/arc:model/arc:relationships/arc:relationship[@target=$id]" group-by="//arc:element[@identifier=current()/@source]/@xsi:type">
					<h4><xsl:value-of select="//arc:element[@identifier=current()/@source]/@xsi:type"/></h4>
					<table class="table table-hover table-condensed small">
						<xsl:for-each select="current-group()">
							<xsl:sort select="@xsi:type"/>
							<tr>
								<xsl:variable name="sourceid" select="@source"/>
								<td class="col-md-2">
									<xsl:value-of select="fn:substring-before(@xsi:type,'Relationship')"/>&#160;from
								</td>
								<td class="col-md-10">
									<a href="browsepage-{$sourceid}.html">
										<xsl:value-of select="/arc:model/arc:elements/arc:element[@identifier=$sourceid]/arc:label"/>
									</a>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:for-each-group>
			</div>
		</div>
		<div class="col-md-6">
		</div>
	</div>
	
</xsl:template>


<xsl:template match="arc:view[.//arc:node]">
	  <xsl:variable name="id" select="@identifier"></xsl:variable>
	  <div class="panel panel-default root-panel">
		<div class="panel-heading root-panel-heading">
			<b><xsl:value-of select="arc:label"/></b>
		</div>
		<div class="panel-body root-panel-body">
		<p><xsl:value-of select="arc:documentation"/></p>
		<div class="col-md-12">
				<!-- calculate svg width and height based on the nodes in the view -->
				<xsl:variable name="maxheight">
					<xsl:for-each select="current()//arc:node">
						<xsl:sort data-type="number" order="descending" select="@y+@h" />
						<xsl:if test="position()=1"><xsl:value-of select="number(@y)+number(@h)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="maxwidth">
					<xsl:for-each select="current()//arc:node">
						<xsl:sort data-type="number" order="descending" select="@x+@w" />
						<xsl:if test="position()=1"><xsl:value-of select="number(@x)+number(@w)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<svg width="{$maxwidth+25}" height="{$maxheight+25}">
					<rect x="0" y="0" width="{$maxwidth+25}" height="{$maxheight+25}" style="stroke:black; fill:none"/>
					<!-- definition of the connection start and end shapes -->
					<defs>
						<marker id="markerCircleEnd" markerWidth="8" markerHeight="8" refX="8" refY="5" orient="auto">
							<circle cx="5" cy="5" r="3" style="stroke: none; fill:#000000;"/>
						</marker>
						<marker id="markerCircleStart" markerWidth="8" markerHeight="8" refX="2" refY="5" orient="auto">
							<circle cx="5" cy="5" r="3" style="stroke: none; fill:#000000;"/>
						</marker>
						<marker id="markerOpenDiamond" markerWidth="16" markerHeight="16" refX="2" refY="5" orient="auto">
							<path d="M8,2 L0,6 L8,10 L16,6 Z" style="fill: white; stroke:black; stroke-width:1" />
						</marker>
						<marker id="markerClosedDiamond" markerWidth="16" markerHeight="16" refX="2" refY="5" orient="auto">
							<path d="M8,2 L0,6 L8,10 L16,6 Z" style="fill: black; stroke:black; stroke-width:1" />
						</marker>
						<marker id="markerClosedBlockArrow" markerWidth="13" markerHeight="13" refX="10" refY="6" orient="auto">
							<path d="M2,2 L2,11 L10,6 Z" style="stroke:black; stroke-width:1; fill: black; " />
						</marker>
						<marker id="markerOpenBlockArrow" markerWidth="13" markerHeight="13" refX="10" refY="6" orient="auto">
							<path d="M2,2 L2,11 L10,6 Z" style="stroke:black; stroke-width:1; fill: white; " />
						</marker>
						<marker id="markerOpenArrow" markerWidth="13" markerHeight="13" refX="10" refY="6" orient="auto">
							<path d="M2,2 L10,6 L2,11" style="fill: none; stroke: black; stroke-width:1" />
						</marker>
					</defs>
					
					<xsl:apply-templates select="arc:node"/>
					<xsl:for-each select="arc:connection">
						 <xsl:call-template name="svgconnection"/>
					</xsl:for-each>
				</svg>
			</div>
		</div>
	</div>
</xsl:template>		

<xsl:template match="arc:node">
	<!-- include here also views since we could have a reference to a view in some tools -->
	<xsl:variable name="element" select="//arc:*[@identifier=current()/@elementref]"/>
	<xsl:variable name="statuspropid" select="//arc:propertydef[@name='Status']/@identifier"/>
	<xsl:variable name="fillColor">
		<xsl:choose>
			<xsl:when test="$element//arc:property[@identifierref=$statuspropid and arc:value='Future']">#5cb85c</xsl:when>
			<xsl:when test="$element//arc:property[@identifierref=$statuspropid and arc:value='Discontinued']">#d9534f</xsl:when>
			<xsl:when test="$element//arc:property[@identifierref=$statuspropid and arc:value='Upgrade']">#f0ad4e</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('rgb(', arc:style/arc:fillColor/@r, ',', arc:style/arc:fillColor/@g, ',', arc:style/arc:fillColor/@b, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="x1" select="@x"/>
	<xsl:variable name="y1" select="@y"/>
	<xsl:variable name="w" select="@w"/>
	<xsl:variable name="h" select="@h"/>
	<xsl:variable name="x2" select="$x1+$w"/>
	<xsl:variable name="y2" select="$y1+$h"/>
	<xsl:variable name="svg_stroke_r" select="arc:style/arc:lineColor/@r"/>
	<xsl:variable name="svg_stroke_g" select="arc:style/arc:lineColor/@g"/>
	<xsl:variable name="svg_stroke_b" select="arc:style/arc:lineColor/@b"/>
	<xsl:variable name="strokeColor" select="concat('rgb(', $svg_stroke_r, ',', $svg_stroke_g, ',', $svg_stroke_b, ')')"/>
	<xsl:variable name="svg_style" select="concat('fill:', $fillColor, '; stroke-width:1;', 'stroke:', $strokeColor, ';')"/>
	<xsl:choose>
		<xsl:when test="@elementref">	
			<a xlink:href="browsepage-{@elementref}.html">
				<rect x="{$x1}" y="{$y1}" width="{$w}" height="{$h}" style="{$svg_style}"></rect>
				<text text-anchor="middle" x="{$x1+5}" y="{$y1+5}" width="{$w+-60}" font-size="12"><xsl:value-of select="$element/arc:label"/></text>
				<xsl:choose>
					<xsl:when test="$element/@xsi:type='SystemSoftware'">
						<circle cx="{$x2+-10}" cy="{$y1+10}" r="5" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
						<circle cx="{$x2+-12}" cy="{$y1+12}" r="5" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Node'">
						<path d="M{$x2+-18},{$y1+8} L{$x2+-15},{$y1+5} L{$x2+-5},{$y1+5} L{$x2+-5},{$y1+15} L{$x2+-8},{$y1+18}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<line x1="{$x2+-5}" y1="{$y1+5}" x2="{$x2+-8}" y2="{$y1+8}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<rect x="{$x2+-18}" y="{$y1+8}" width="10" height="10" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Device'">
						<path d="M{$x2+-17},{$y1+18} L{$x2+-9},{$y1+11} L{$x2+-3},{$y1+18} L{$x2+-17},{$y1+18}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<rect x="{$x2+-15}" y="{$y1+5}" width="11" height="9" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='ApplicationComponent'">
						<rect x="{$x2+-15}" y="{$y1+5}" width="10" height="14" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<rect x="{$x2+-18}" y="{$y1+7}" width="6" height="3" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<rect x="{$x2+-18}" y="{$y1+13}" width="6" height="3" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Product'">
						<rect x="{$x2+-18}" y="{$y1+5}" width="12" height="10" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<rect x="{$x2+-18}" y="{$y1+5}" width="6" height="3" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessRole' or $element/@xsi:type='Stakeholder'">
						<circle cx="{$x2+-17}" cy="{$y1+10}" r="4" fill="{$fillColor}" stroke="black" stroke-width="1"/>
						<rect x="{$x2+-17}" y="{$y1+5}" width="6" height="10" fill="{$fillColor}" stroke="${fillColor}" stroke-width="0.75"/> 
						<circle cx="{$x2+-10}" cy="{$y1+10}" r="4" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
						<line x1="{$x2+-17}" y1="{$y1+6}" x2="{$x2+-11}" y2="{$y1+6}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<line x1="{$x2+-17}" y1="{$y1+14}" x2="{$x2+-11}" y2="{$y1+14}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessActor'">
						<circle cx="{$x2+-9}" cy="{$y1+7}" r="3" fill="{$fillColor}" stroke="black" stroke-width="1"/>
						<line x1="{$x2+-9}" y1="{$y1+10}" x2="{$x2+-9}" y2="{$y1+16}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<line x1="{$x2+-13}" y1="{$y1+12}" x2="{$x2+-5}" y2="{$y1+12}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<line x1="{$x2+-9}" y1="{$y1+16}" x2="{$x2+-13}" y2="{$y1+21}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<line x1="{$x2+-9}" y1="{$y1+16}" x2="{$x2+-5}" y2="{$y1+21}" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessProcess'">
						<path d="M{$x2 - 18},{$y1+8} h9 v-3 L{$x2 - 5},{$y1+10} L{$x2 - 9},{$y1+15} v-3 h-9 Z" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessObject' or $element/@xsi:type='DataObject' or $element/@xsi:type='Contract'">
						<rect x="{$x2 - 18}" y="{$y1+5}" width="12" height="10" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
						<path d="M{$x2 - 18},{$y1+8} h12" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessInteraction' or $element/@xsi:type='ApplicationInteraction'">
						<path d="M{$x2 - 12} {$y1+6} A 5 5 0 0 0 {$x2 - 12} {$y1 + 16} Z" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
						<path d="M{$x2 - 9} {$y1+16} A 5 5 0 0 0 {$x2 - 9} {$y1 + 6} Z" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessCollaboration' or $element/@xsi:type='ApplicationCollaboration'">
						<circle cx="{$x2 - 14}" cy="{$y1+11}" r="5" fill="none" stroke="black" stroke-width="1"/> 
						<circle cx="{$x2 - 10}" cy="{$y1+11}" r="5" fill="none" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessInterface' or $element/@xsi:type='ApplicationInterface' or $element/@xsi:type='InfrastructureInterface'">
						<circle cx="{$x2 - 8}" cy="{$y1+10}" r="5" fill="{$fillColor}" stroke="black" stroke-width="1"/> 
						<path d="M{$x2 - 13},{$y1+10} h-5" fill="none" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessFunction' or $element/@xsi:type='ApplicationFunction' or $element/@xsi:type='InfrastructureFunction'">
						<path d="M{$x2 - 8},{$y1+5} l5,5 v5 l-5,-5 l-5,5 v-5 Z" fill="none" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='BusinessService' or $element/@xsi:type='ApplicationService' or $element/@xsi:type='InfrastructureService'">
						<rect x="{$x2 - 18}" y="{$y1+5}" rx="3" ry="3" width="13" height="7" fill="{$fillColor}" stroke="black" stroke-width="0.75"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Value'">
						<ellipse cx="{$x2 - 13}" cy="{$y1+10}" rx="8" ry="4" fill="none" stroke="black" stroke-width="1"/> 
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Meaning'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Representation'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Location'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Artifact'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Driver'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Assessment'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Goal'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Principle'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Requirement'">
						
					</xsl:when>
					<xsl:when test="$element/@xsi:type='Constraint'">
						
					</xsl:when>
					
					<xsl:otherwise>
						<!-- TODO create shapes for other types -->	
					</xsl:otherwise>
				</xsl:choose>
				
			</a>
	</xsl:when>
	<!-- draw group box -->
	<xsl:otherwise>
		<xsl:variable name="colorratio">0.9</xsl:variable>
		<rect x="{$x1}" y="{$y1}" width="{$w div 2}" height="17" 
			style="fill:rgb({fn:round(arc:style/arc:fillColor/@r * $colorratio)},{fn:round(arc:style/arc:fillColor/@g * $colorratio)},{fn:round(arc:style/arc:fillColor/@b * $colorratio)}); strokewidth:1; stroke:{$strokeColor}" />
		<rect x="{$x1}" y="{$y1+17}" width="{$w}" height="{$h - 16}" style="{$svg_style}"/>
		<text x="{$x1+5}" y="{$y1+2}" width="{$w}" font-size="12"><xsl:value-of select="arc:label"/></text>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="arc:node"/>

</xsl:template>


<xsl:template name="svgconnection">
	<xsl:variable name="relationshipid" select="@relationshipref"/>
	<xsl:variable name="relationship" select="//arc:relationship[@identifier=$relationshipid]"/>
	<xsl:variable name="statuspropid" select="//arc:propertydef[@name='Status']/@identifier"/>
	<xsl:variable name="strokecolor">
		<xsl:choose>
			<xsl:when test="$relationship//arc:property[@identifierref=$statuspropid and arc:value='Future']">#5cb85c</xsl:when>
			<xsl:when test="$relationship//arc:property[@identifierref=$statuspropid and arc:value='Discontinued']">#d9534f</xsl:when>
			<xsl:when test="$relationship//arc:property[@identifierref=$statuspropid and arc:value='Upgrade']">#f0ad4e</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('rgb(', arc:style/arc:lineColor/@r, ',', arc:style/arc:lineColor/@g, ',', arc:style/arc:lineColor/@b, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sourceid" select="@source"></xsl:variable>
	<xsl:variable name="targetid" select="@target"></xsl:variable>
	<xsl:variable name="sourcenode" select="..//arc:node[@identifier=$sourceid]"></xsl:variable>
	<xsl:variable name="targetnode" select="..//arc:node[@identifier=$targetid]"></xsl:variable>
	<xsl:variable name="sourcex" select="number($sourcenode/@x)"></xsl:variable>
	<xsl:variable name="sourcey" select="number($sourcenode/@y)"></xsl:variable>
	<xsl:variable name="sourcew" select="number($sourcenode/@w)"></xsl:variable>
	<xsl:variable name="sourceh" select="number($sourcenode/@h)"></xsl:variable>
	<xsl:variable name="targetx" select="number($targetnode/@x)"></xsl:variable>
	<xsl:variable name="targety" select="number($targetnode/@y)"></xsl:variable>
	<xsl:variable name="targetw" select="number($targetnode/@w)"></xsl:variable>
	<xsl:variable name="targeth" select="number($targetnode/@h)"></xsl:variable>
	
	<!-- TODO include support for more bendpoints -->
	<xsl:variable name="bendpoint">
		<xsl:for-each select="arc:bendpoint">
			L<xsl:value-of select="@x"/>,<xsl:value-of select="@y"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="markerstart">
		<xsl:choose>
			<xsl:when test="$relationship/@xsi:type='AssignmentRelationship'">marker-start: url(#markerCircleStart);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='AggregationRelationship'">marker-start: url(#markerOpenDiamond);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='CompositionRelationship'">marker-start: url(#markerClosedDiamond);</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="markerend">
		<xsl:choose>
			<xsl:when test="$relationship/@xsi:type='UsedByRelationship'">marker-end: url(#markerOpenArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='AccessRelationship'">marker-end: url(#markerOpenArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='AssignmentRelationship'">marker-end: url(#markerCircleEnd);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='RealisationRelationship'">marker-end: url(#markerOpenBlockArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='SpecialisationRelationship'">marker-end: url(#markerOpenBlockArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='TriggeringRelationship'">marker-end: url(#markerClosedBlockArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='FlowRelationship'">marker-end: url(#markerClosedBlockArrow);</xsl:when>
			<xsl:when test="$relationship/@xsi:type='InfluenceRelationship'">marker-end: url(#markerClosedBlockArrow);</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="dash">
	        
		<xsl:choose>
			<xsl:when test="$relationship/@xsi:type='AccessRelationship'">stroke-dasharray:3,3;</xsl:when>
			<xsl:when test="$relationship/@xsi:type='RealisationRelationship'">stroke-dasharray:5,3;</xsl:when>
			<xsl:when test="$relationship/@xsi:type='FlowRelationship'">stroke-dasharray:5,3;</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="next">
		<xsl:choose>
			<xsl:when test="arc:bendpoint"><rect x="{number(arc:bendpoint[1]/@x)}" y="{number(arc:bendpoint[1]/@y)}" w="0" h="0"/></xsl:when>
			<xsl:otherwise><rect x="{$targetx}" y="{$targety}" w="{$targetw}" h="{$targeth}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="previous">
		<xsl:choose>
			<xsl:when test="arc:bendpoint"><rect x="{number(arc:bendpoint[position()=last()]/@x)}" y="{number(arc:bendpoint[position()=last()]/@y)}" w="0" h="0"/></xsl:when>
			<xsl:otherwise><rect x="{$sourcex}" y="{$sourcey}" w="{$sourcew}" h="{$sourceh}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="startx">
		<xsl:choose>
			<xsl:when test="$sourcex+$sourcew &lt;= $next/rect/@x"><xsl:value-of select="$sourcex+$sourcew"/></xsl:when>
			<xsl:when test="$sourcex &gt;= $next/rect/@x+$next/rect/@w"><xsl:value-of select="$sourcex"/></xsl:when>
			<xsl:when test="$sourcex &gt;= $next/rect/@x and $sourcex+$sourcew &lt;= $next/rect/@x  + $next/rect/@w"><xsl:value-of select="$sourcex + $sourcew div 2"/></xsl:when>
			<xsl:when test="$sourcex &lt; $next/rect/@x and $sourcex+$sourcew &gt; $next/rect/@x  + $next/rect/@w"><xsl:value-of select="$next/rect/@x+$next/rect/@w div 2"/></xsl:when>
			<xsl:when test="$next/rect/@x &lt; $sourcex+$sourcew div 2 and $next/rect/@x+$next/rect/@w &gt; $sourcex+$sourcew div 2"><xsl:value-of select="$sourcex + $sourcew div 2"/></xsl:when>
			<xsl:when test="$sourcex &lt; $next/rect/@x+$next/rect/@w div 2 and $sourcex+$sourcew &gt; $next/rect/@x+$next/rect/@w div 2"><xsl:value-of select="$next/rect/@x+$next/rect/@w div 2"/></xsl:when>
			<xsl:when test="$sourcex &gt; $next/rect/@x"><xsl:value-of select="$next/rect/@x + $next/rect/@w - 10"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$next/rect/@x + 10"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="starty">
		<xsl:choose>
			<xsl:when test="$sourcey+$sourceh &lt;= $next/rect/@y"><xsl:value-of select="$sourcey+$sourceh"/></xsl:when>
			<xsl:when test="$sourcey &gt;= $next/rect/@y+$next/rect/@h"><xsl:value-of select="$sourcey"/></xsl:when>
			<xsl:when test="$sourcey &gt;= $next/rect/@y and $sourcey+$sourceh &lt;= $next/rect/@y  + $next/rect/@h"><xsl:value-of select="$sourcey + $sourceh div 2"/></xsl:when>
			<xsl:when test="$sourcey &lt; $next/rect/@y and $sourcey+$sourceh &gt; $next/rect/@y  + $next/rect/@h"><xsl:value-of select="$next/rect/@y+$next/rect/@h div 2"/></xsl:when>
			<xsl:when test="$next/rect/@y &lt; $sourcey+$sourceh div 2 and $next/rect/@y+$next/rect/@h &gt; $sourcey+$sourceh div 2"><xsl:value-of select="$sourcey + $sourceh div 2"/></xsl:when>
			<xsl:when test="$sourcey &lt; $next/rect/@y+$next/rect/@h div 2 and $sourcey+$sourceh &gt; $next/rect/@y+$next/rect/@h div 2"><xsl:value-of select="$next/rect/@y+$next/rect/@h div 2"/></xsl:when>
			<xsl:when test="$sourcey &gt; $next/rect/@y"><xsl:value-of select="$next/rect/@y + $next/rect/@h - 10"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$next/rect/@y + 10"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="endx">
		<xsl:choose>
			<xsl:when test="$targetx+$targetw &lt;= $previous/rect/@x"><xsl:value-of select="$targetx + $targetw"/></xsl:when>
			<xsl:when test="$targetx &gt;= $previous/rect/@x+$previous/rect/@w"><xsl:value-of select="$targetx"/></xsl:when>
			<xsl:when test="$targetx &gt;= $previous/rect/@x and $targetx+$targetw &lt;= $previous/rect/@x  + $previous/rect/@w"><xsl:value-of select="$targetx+$targetw div 2"/></xsl:when>
			<xsl:when test="$targetx &lt; $previous/rect/@x and $targetx+$targetw &gt; $previous/rect/@x  + $previous/rect/@w"><xsl:value-of select="$previous/rect/@x+$previous/rect/@w div 2"/></xsl:when>
			<xsl:when test="$targetx &lt; $previous/rect/@x + $previous/rect/@w div 2 and $targetx+$targetw &gt; $previous/rect/@x+$previous/rect/@w div 2"><xsl:value-of select="$previous/rect/@x+$previous/rect/@w div 2"/></xsl:when>
			<xsl:when test="$previous/rect/@x &lt; $targetx + $targetw div 2 and $previous/rect/@x + $previous/rect/@w &gt; $targetx + $targetw div 2"><xsl:value-of select="$targetx + $targetw div 2"/></xsl:when>
			<xsl:when test="$targetx &gt; $previous/rect/@x"><xsl:value-of select="$targetx + 10"/></xsl:when>				
			<xsl:otherwise><xsl:value-of select="$targetx + $targetw - 10"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="endy">
		<xsl:choose>
			<xsl:when test="$targety+$targeth &lt;= $previous/rect/@y"><xsl:value-of select="$targety + $targeth"/></xsl:when>
			<xsl:when test="$targety &gt;= $previous/rect/@y+$previous/rect/@h"><xsl:value-of select="$targety"/></xsl:when>
			<xsl:when test="$targety &gt;= $previous/rect/@y and $targety+$targeth &lt;= $previous/rect/@y  + $previous/rect/@h"><xsl:value-of select="$targety+$targeth div 2"/></xsl:when>
			<xsl:when test="$targety &lt; $previous/rect/@y and $targety+$targeth &gt; $previous/rect/@y  + $previous/rect/@h"><xsl:value-of select="$previous/rect/@y+$previous/rect/@h div 2"/></xsl:when>
			<xsl:when test="$targety &lt; $previous/rect/@y + $previous/rect/@h div 2 and $targety+$targeth &gt; $previous/rect/@y+$previous/rect/@h div 2"><xsl:value-of select="$previous/rect/@y+$previous/rect/@h div 2"/></xsl:when>
			<xsl:when test="$previous/rect/@y &lt; $targety + $targeth div 2 and $previous/rect/@y + $previous/rect/@h &gt; $targety + $targeth div 2"><xsl:value-of select="$targety + $targeth div 2"/></xsl:when>
			<xsl:when test="$targety &gt; $previous/rect/@y"><xsl:value-of select="$targety + 10"/></xsl:when>				
			<xsl:otherwise><xsl:value-of select="$targety + $targeth - 10"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<path d="M{$startx},{$starty} {$bendpoint} L{$endx},{$endy}" style="stroke:{$strokecolor};stroke-width:1; fill:none; {$dash} {$markerstart} {$markerend}"/> 
	
</xsl:template>


</xsl:stylesheet>
