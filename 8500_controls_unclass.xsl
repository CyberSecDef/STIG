<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" >
	<xsl:import href="functions.xsl"/>
	
	<xsl:template match="/">
		<html lang="en">
			<head>
				<xsl:call-template name="html-head" />
			</head>
			<body>
				<xsl:call-template name="nav-header" />
				<div class="container-fluid">
					<div class="row">
						
						<div class="col-sm-12 col-md-12 main">
							<xsl:call-template name="dodImage"/>
							
							<div class="table-responsive">
								<div class="table-responsive">
									<xsl:call-template name="control-description-table" />
								</div>
								
								<div class="table-responsive"><br />
									<xsl:call-template name="control-version-table" />
								</div>
							</div>
							<h2 class="sub-header">Controls</h2>
							<xsl:call-template name="controlsTable" />
						</div>
					</div>
				</div>

				<xsl:apply-templates select="/iaControls/iaControl" mode="controlDetailsModal" />
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="html-head">
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<title>8500-2 Controls </title>
		<xsl:call-template name="lib_Js" />
		<xsl:call-template name="lib_Css" />
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='8500-2_Js']"/>
	</xsl:template>
	
	<xsl:template match="/iaControls/iaControl" mode="controlDetailsModal">
		<div class="modal fade">
			<xsl:attribute name="id">control<xsl:value-of select="./controlNumber" /></xsl:attribute>
			<div class="modal-dialog modal-fit">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
						<h4 class="modal-title"><em><xsl:value-of select="./controlName" /></em></h4>
					</div>
					<div class="modal-body">
					
						<table class="table table-striped table-bordered table-curved">
							<thead>
								<tr>
									<th>Control</th>
									<th>MAC Levels</th>
									<th>Confidentiality</th>
									<th>Subject Area</th>
									<th>Impact Code</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><xsl:value-of select="./controlNumber" /></td>
									<td>
										<xsl:for-each select="./macLevels/mac">
											<xsl:value-of select="." />
											 <xsl:if test="position() != last()">
												 <xsl:text>, </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</td>
									<td>
										<xsl:for-each select="./macLevels/confidentiality">
											<xsl:value-of select="." />
											<xsl:if test="position() != last()">
												 <xsl:text>, </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</td>
									<td class="ia-controls">
										<xsl:value-of select="./subjectArea" />
									</td>
									
									<xsl:choose>
										<xsl:when test="./impactCode = 'High'">
											<td class="bg-danger">High</td>
										</xsl:when>
										<xsl:when test="./impactCode = 'Medium'">
											<td class=" bg-warning">Medium</td>
										</xsl:when>
										<xsl:when test="./impactCode = 'Low'">
											<td class=" bg-success">Low</td>
										</xsl:when>
									</xsl:choose>
									
								</tr>
							</tbody>
						</table>
					
						<h4>Description:</h4>
						<div class="stig-description text-justify small">
							<blockquote style="font-size:10pt;">
							<xsl:call-template name="replaceNL">
								<xsl:with-param name="pText" select="./description"/>
							</xsl:call-template>
							</blockquote>
						</div>
						
						<h4>Threat:</h4>						
						<div class=" text-justify small stig-threat">
							<blockquote style="font-size:10pt;">
								<xsl:call-template name="replaceNL">
									<xsl:with-param name="pText" select="./threat"/>
								</xsl:call-template>
							</blockquote>
						</div>

						
						<h4>Implementation Guidance:</h4>
						<div class=" text-justify small stig-guidance">
							<blockquote style="font-size:10pt;">
							<xsl:call-template name="replaceNL">
								<xsl:with-param name="pText" select="./implementationGuidance"/>
							</xsl:call-template>
							</blockquote>
						</div>


						<xsl:variable name="thisControl">
							<xsl:value-of select="./controlNumber" />
						</xsl:variable>
						
						<xsl:if test="document('controlMapping.xml')/controlMapping/control[./diacap = $thisControl]/rmf">
							<div class=" text-justify small stig-related">
								<h4>Related RMF Controls (800-53)</h4>
								<blockquote>
								<xsl:for-each select="document('controlMapping.xml')/controlMapping/control[./diacap = $thisControl]/rmf">

									<a class="btn btn-primary">
										<xsl:value-of select="." />
									</a>
									<xsl:text> </xsl:text>
								</xsl:for-each>
								</blockquote>
							</div>
						</xsl:if>
						
						<h4>Resources:</h4>						
						<div class=" text-justify small stig-resources">
						<blockquote style="font-size:10pt;">
							<xsl:call-template name="replaceNL">
								<xsl:with-param name="pText" select="./resources"/>
							</xsl:call-template>
						</blockquote>
						</div>
					
						
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="/iaControls/iaControl" mode="controlTableData">
		<xsl:for-each select=".">
			<xsl:sort select="./controlNumber" />
				<tr>

					<td class="text-nowrap">
						<a data-toggle="modal" href="#myModal" class="btn btn-primary controlButton">
							<xsl:attribute name="href">#control<xsl:value-of select="./controlNumber" /></xsl:attribute>
							<xsl:value-of select="./controlNumber" />
						</a>
					</td>
					<xsl:choose>
						<xsl:when test="./impactCode = 'High'">
							<td class="impact bg-danger">High</td>
						</xsl:when>
						<xsl:when test="./impactCode = 'Medium'">
							<td class="impact bg-warning">Medium</td>
						</xsl:when>
						<xsl:when test="./impactCode = 'Low'">
							<td class="impact bg-success">Low</td>
						</xsl:when>
					</xsl:choose>
					<td class="mac">
						<xsl:for-each select="./macLevels/mac">
							<xsl:choose>
								<xsl:when test="./text() = 'MAC 1'">
									MAC I 
								</xsl:when>
								<xsl:when test="./text() = 'MAC 2'">
									MAC II 
								</xsl:when>
								<xsl:when test="./text() = 'MAC 3'">
									MAC III 
								</xsl:when>
							</xsl:choose>
							
							 
						</xsl:for-each>
					</td>
					<td class="confidentiality">
						<xsl:for-each select="./macLevels/confidentiality" >
							<xsl:value-of select="." />
							 <xsl:if test="position() != last()">
								 <xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="subjectArea text-nowrap hidden-xs hidden-sm"><xsl:value-of select="./subjectArea" /></td>
					<td class="text-nowrap"><xsl:value-of select="./controlName" /></td>
					<td class="control-description hidden-xs hidden-sm">
						<xsl:call-template name="replaceNL">
							<xsl:with-param name="pText" select="./description"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="control-description-table">
		<div class="container-fluid table table-curved">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12 em h3" style="border-bottom:1px solid #ccc;">
					<em>8500-2 DIACAP - Security Controls</em>
				</div>
			</div>
			<div class="row ">
				<div class="col-lg-12 col-md-12 small">
					<p>Information security controls protect the confidentiality, integrity and/or availability of information (the so-called CIA Triad). Again, some would add further categories such as non-repudiation and accountability, depending on how narrowly or broadly the CIA Triad is defined.</p>
					<p>Individual controls are often designed to act together to increase effective protection. Systems of controls can be referred to as frameworks or standards. Frameworks can enable an organization to manage security controls across different types of assets with consistency. For example, a framework can help an organization manage controls over access regardless of the type of computer operating system. This also enables an organization to assess overall risk. Risk-aware organizations may choose proactively to specify, design, implement, operate and maintain their security controls, usually by assessing the risks and implementing a comprehensive security management framework such as ISO27001:2013, the Information Security Forum's Standard of Good Practice for Information Security, or NIST SP 800-53.</p>					
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="controlsTable">
		<div class="table-responsive" id="findings-table">
			<table class="table-striped table-bordered table-hover tablesorter stig-finding" id="table-findings">
				<thead>
					<tr>
						<th>ID</th>
						<th>Impact Code</th>
						<th>MAC Level Applicability</th>
						<th>Confidentiality</th>
						<th  class="hidden-xs hidden-sm">Subject Area</th>
						<th>Title</th>
						<th class="hidden-xs hidden-sm">Description</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="/iaControls/iaControl" mode="controlTableData" />
				</tbody>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="control-version-table">
		<div class="container-fluid table table-curved">
			<div class="row ">
				<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="border-bottom:1px solid #ccc;">
							<div class="row h3 ">
								Version
							</div>
							<div class="row">
								1.0					
							</div>
						</div>
						
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="border-bottom:1px solid #ccc;">
							<div class="row h3">
								Date
							</div>
							<div class="row" id='stigDate'>
								May 26, 2013
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="border-bottom:1px solid #ccc;">
							<div class="row h3">
								Controls
							</div>
							<div class="row">
								<xsl:value-of select="count(/iaControls/iaControl)" /> 
							</div>
						</div>
					</div>
					
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							Export Options
						</div>
						<div class="row"  style="border-bottom:1px solid #ccc;">
							<div class="col-xs-3 col-sm-3 col-md-3 col-lg-2">
								<a class="btn btn-info" onclick="$io.export.pdf();" style="width:75px;">PDF</a>
							</div>
							<div class="col-xs-3 col-sm-3 col-md-3 col-lg-2">
								<a class="btn btn-info" onclick="$io.export.doc(true);" style="width:75px;">DOC</a>
							</div>
							<div class="col-xs-3 col-sm-3 col-md-3 col-lg-2">
								<a class="btn btn-info" onclick="$io.export.doc(false);" style="width:75px;">HTML</a>
							</div>
							<div class="col-xs-3 col-sm-3 col-md-3 col-lg-2">
								<a class="btn btn-info" onclick="$io.export.csv();" style="width:75px;">CSV</a> 
							</div>
							<div class="col-xs-3 col-sm-3 col-md-3 col-lg-2">
								<a class="btn btn-info" onclick="$io.export.json();" style="width:75px;">JSON</a>
							</div>
						</div>
					</div>
						
						
				</div>
				
				<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							MAC Level
						</div>
						<div class="row"  style="border-bottom:1px solid #ccc;">
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-danger" onclick="$view.filters.mac('MAC I')" style="width:125px;">
									MAC I <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 1'])" /></span>
								</a>
							</div>
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-warning" onclick="$view.filters.mac('MAC I')" style="width:125px;">
									MAC II <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 2'])" /></span>
								</a>
							</div>
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-success" onclick="$view.filters.mac('MAC I')" style="width:125px;">
									MAC II <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 3'])" /></span>
								</a>
							</div>
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-info" onclick="$view.filters.mac('MAC I')" style="width:125px;">
									Clear <span class="badge"><xsl:value-of select="count(/iaControls/iaControl)" /></span>
								</a>
							</div>							
						</div>
					</div>
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							Confidentiality
						</div>
						<div class="row"  style="border-bottom:1px solid #ccc;">
								<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
									<a class="btn btn-primary btn-danger" onclick="$view.filters.confidentiality('CLASSIFIED')" style="width:125px;">
										Classified <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'CLASSIFIED'])" /></span>
									</a>
								</div>
								<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
									<a class="btn btn-primary btn-warning" onclick="$view.filters.confidentiality('SENSITIVE')" style="width:125px;">
										Sensitive <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'SENSITIVE'])" /></span>
									</a>
								</div>
								<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
									<a class="btn btn-primary btn-success" onclick="$view.filters.confidentiality('PUBLIC')" style="width:125px;">
										Public <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'PUBLIC'])" /></span>
									</a>
								</div>							
								<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
									<a class="btn btn-primary btn-info" onclick="$view.filters.confidentiality('')" style="width:125px;">
										Clear <span class="badge"><xsl:value-of select="count(/iaControls/iaControl)" /></span>
									</a>
								</div>							
						</div>
					</div>
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							Impact Code
						</div>
						<div class="row"  style="border-bottom:1px solid #ccc;">
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-danger" onclick="$view.filters.impact('High')" style="width:125px;">
									High <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'High'])" /></span>
								</a>
							</div>
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-warning" onclick="$view.filters.impact('Medium')" style="width:125px;">
									Medium <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'Medium'])" /></span>
								</a>
							</div>
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-success" onclick="$view.filters.impact('Low')" style="width:125px;">
									Low <span class="badge"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'Low'])" /></span>
								</a>
							</div>			
							<div class="col-xs-6 col-sm-3 col-md-3 col-lg-3">
								<a class="btn btn-primary btn-info" onclick="$view.filters.impact('')" style="width:125px;">
									Clear <span class="badge"><xsl:value-of select="count(/iaControls/iaControl)" /></span>
								</a>
							</div>
						</div>
					</div>
					
					
				</div>
			</div>
		</div>
	
	
	</xsl:template>

	<xsl:template name="nav-header">
		<nav class="navbar navbar-inverse navbar-fixed-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="#">8500-2 Controls </a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<ul class="nav navbar-nav navbar-right">
					
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								MAC <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.mac('');">All</a></li>
								<li><a href="#" onclick="$view.filters.mac('MAC I');">MAC I <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 1'])" /></span> </a></li>
								<li><a href="#" onclick="$view.filters.mac('MAC II');">MAC II <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 2'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.mac('MAC III');">MAC III <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/mac/text() = 'MAC 3'])" /></span></a></li>
							</ul>
						</li>
						
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Confidentiality <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.confidentiality('');">All</a></li>
								<li id="selClassified"><a href="#" onclick="$view.filters.confidentiality('CLASSIFIED');" >Classified <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'CLASSIFIED'])" /></span> </a></li>
								<li id="selSensitive"><a href="#" onclick="$view.filters.confidentiality('SENSITIVE');" >Sensitive <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'SENSITIVE'])" /></span></a></li>
								<li id="selPublic"><a href="#" onclick="$view.filters.confidentiality('PUBLIC');" >Public <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./macLevels/confidentiality/text() = 'PUBLIC'])" /></span></a></li>
							</ul>
						</li>
						
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Impact Code <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.impact('');">All</a></li>
								<li><a href="#" onclick="$view.filters.impact('Low');">Low <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'Low'])" /></span> </a></li>
								<li><a href="#" onclick="$view.filters.impact('Medium');">Medium <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'Medium'])" /></span> </a></li>
								<li><a href="#" onclick="$view.filters.impact('High');">High <span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl[./impactCode/text() = 'High'])" /></span> </a></li>
							</ul>
						</li>
						
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Subject Area<span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.subjectArea('');">All</a></li>
								<xsl:call-template name="navbar-subject-areas" />
							</ul>
						</li>
						
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Available STIGS <span class="caret"></span>
							</a>
							<ul class="dropdown-menu"  style="left : -200px !important;">
								<li>
									<select class="form-control" onchange="location.href = this.value + location.href.substr(location.href.lastIndexOf('.'))" id="stigMenu">
										<xsl:apply-templates select="document('configurations.xml')/configurations/menu/item" mode="stig-menu">	
											<xsl:with-param name="selectedStig" select="'8500-2'" />
											<xsl:sort select="text()"></xsl:sort>
										</xsl:apply-templates>
									</select>
								</li>
							</ul>
						</li>
						
					</ul>
				</div>
			</div>
		</nav>
	</xsl:template>
	
	<xsl:template name="navbar-subject-areas" >
		<xsl:variable name="subjectAreas" select="/iaControls/iaControl/subjectArea" />
		<xsl:for-each select="$subjectAreas">
			<xsl:sort select="." />
			<xsl:variable name="subjectAreaName" select="." />
			<xsl:if test="generate-id() = generate-id($subjectAreas[. = current()][1])">
				<li>
					<a href="#" >
						<xsl:attribute name="onclick">
								$view.filters.subjectArea('<xsl:value-of select="." />');
							</xsl:attribute>
							<xsl:value-of select="text()" />
							<xsl:text> </xsl:text>
							<span class="badge pull-right"><xsl:value-of select="count(/iaControls/iaControl/subjectArea[text() = $subjectAreaName])" /></span>
					</a>
				</li>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>	
		
	
</xsl:stylesheet>