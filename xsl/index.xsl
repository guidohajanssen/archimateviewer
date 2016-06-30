<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
    xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	>


<xsl:variable name="instancespropid" select="//arc:propertydef[@name='Instances']/@identifier"/>
<xsl:variable name="inactivepropid" select="//arc:propertydef[@name='Inactive']/@identifier"/>
<xsl:variable name="statuspropid" select="//arc:propertydef[@name='Status']/@identifier"/>
	
<xsl:template match="/">
	<html>
		<head>
			<title><xsl:value-of select="arc:model/arc:name"/> - Model</title>
			<meta charset="utf-8"/>
			<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
			<meta name="viewport" content="width=device-width, initial-scale=1"/>
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
			<!-- REPORT SPECIFIC -->
			<link type="text/css" rel="stylesheet" href="css/model.css"/>
			<script type="text/javascript" src="js/index.js"></script>
			<style>
				ul
				{
					list-style-type: none;
				}
			</style>
		</head>
		<body>
			<div class="ui-layout-north">
				<nav class="navbar navbar-default">
					<div class="navbar-header">
						<span class="navbar-brand"><!--img src="img\pharmapartners.png"/--><xsl:value-of select="arc:model/arc:name"/></span>
						
					</div>
					<div class="collapse navbar-collapse">
						<ul class="nav navbar-nav navbar-right">
							<li><a href="#myModal" data-toggle="modal" class="btn go">About</a></li>
						</ul>
					</div>
				</nav>
			</div>
			<iframe name="contents" class="ui-layout-center" scrolling="yes"></iframe>
			<div class="ui-layout-west">
				<div class="ui-layout-center">
					<div class="panel panel-default root-panel">
						<div class="panel-heading root-panel-heading">
							<div class="input-group">
							  <input id="searchtext" type="text" class="form-control" placeholder="Search for..."/>
							  <span class="input-group-btn">
								<button onclick="search()" class="btn btn-default" type="button">Go!</button>
							  </span>
							</div>
						</div>
						<div class="panel-body root-panel-body">
							<ul class="tree">
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Views']"/>
					
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Business']"/>
					
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Application']"/>
					
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Technology']"/>
								
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Motivation']"/>
								
								<xsl:apply-templates select="/arc:model/arc:organization/arc:item[arc:label='Implementation &amp; Migration']"/>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">x</button>
							<h4>About</h4>
						</div>
						<div class="modal-body">
							<p>Created with architecture report publisher 2.1.0</p>
							<p>Version:<xsl:value-of select="arc:model/arc:metadata/dc:identifier"/></p>
							<p>Creators:<xsl:value-of select="arc:model/arc:metadata/dc:creator"/></p>
							<p>Model Creation date:<xsl:value-of select="arc:model/arc:metadata/dc:date"/></p>
							<p>Report Creation date:<xsl:value-of select="current-dateTime()"/></p>
							<p>Contributors:<xsl:value-of select="arc:model/arc:metadata/dc:contributor"/></p>
							<p><xsl:value-of select="arc:model/arc:documentation"/></p>	
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>	
	  </body>
	</html>
	</xsl:template>

	<xsl:template match="arc:item[arc:label]">
		<li class="tree-folder"><span><i class="glyphicon glyphicon-triangle-right"></i><xsl:value-of select="arc:label"/></span>
			<ul>
				<xsl:for-each select="arc:item[arc:label]">
					<xsl:sort select="arc:label"/>		
					<xsl:apply-templates select="."/>		
				</xsl:for-each>
				<xsl:for-each select="arc:item[@identifierref]">
					<xsl:sort select="//*[@identifier=current()/@identifierref]/arc:label"/>
					<li class="tree-element">
						<a href="browsepage-{@identifierref}.html" target="contents">
							<xsl:value-of select="//*[@identifier=current()/@identifierref]/arc:label"/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</li>
	</xsl:template>
</xsl:stylesheet>
