<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:controls="http://scap.nist.gov/schema/sp800-53/feed/2.0" xmlns:def="http://scap.nist.gov/schema/sp800-53/2.0">
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
								
								<div class="table-responsive">
									<xsl:call-template name="control-version-table" />
								</div>
								
							</div>
							<h2 class="sub-header">Controls</h2>
							<xsl:call-template name="controlsTable" />
						</div>
					</div>
				</div>
				
				<div id="tailorXml" class="hidden"></div>
				<xsl:apply-templates select="/" mode="controlTailoringModal" />
				<xsl:apply-templates select="/controls:controls/controls:control" mode="controlDetailsModal" />
			</body>
		</html>
	</xsl:template>

	<xsl:template name="html-head">
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<title>800-53 Controls - Risk Management Framework (RMF)</title>
		<xsl:call-template name="lib_Js" />
		<xsl:call-template name="lib_Css" />
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='800-53_Js']"/>
	</xsl:template>
	
	<xsl:template match="/" mode="controlTailoringModal">
		<div class="modal fade">
			<xsl:attribute name="id">controlTailoring</xsl:attribute>
			<div class="modal-dialog  modal-fit">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
						<h4 class="modal-title"><em>Tailoring the Selected Security Controls</em></h4>
					</div>
					<div class="modal-body">
						<h3>Tailoring Options</h3>
						<form>
						<table class="table table-striped table-bordered table-curved">
							<thead>
								<tr>
									<th class="col-md-3 main" >Confidentiality</th>
									<th class="col-md-3 main">Integrity</th>
									<th class="col-md-3 main">Availability</th>
									<th class="col-md-3 main">Overlays</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="form-inline">
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radConfidentiality" id="radConfidentiality1" value="Low" checked="checked" /> Low
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radConfidentiality" id="radConfidentiality2" value="Mod" /> Moderate
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radConfidentiality" id="radConfidentiality3" value="High" /> High
										</label>
									</td>
									<td class="form-inline">
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radIntegrity" id="radIntegrity1" value="Low" checked="checked"/> Low
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radIntegrity" id="radIntegrity2" value="Mod" /> Moderate
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radIntegrity" id="radIntegrity3" value="High" /> High
										</label>
									</td>
									<td class="form-inline">
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radAvailability" id="radAvailability1" value="Low" checked="checked" /> Low
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radAvailability" id="radAvailability2" value="Mod" /> Moderate
										</label>
										
										<label class="radio-inline">
											<input class="tailorRad" type="radio" name="radAvailability" id="radAvailability3" value="High" /> High
										</label>
									</td>
									<td>
										<select multiple="multiple" class="form-control" name="overlays" id="overlays" size="5">
											<option>Classified Information</option>
											<option>Cross Domain Solution</option>
											<option> - Transfer</option>
											<option> - Access</option>
											<option> - Multilevel</option>
											<option>Privacy</option>
											<option> - Low</option>
											<option> - Medium</option>
											<option> - High</option>
											<option>Protected Health Information</option>
											<option>Space Platform</option>
										</select>
									</td>
								</tr>
								<tr>
									<th class="col-md-3">Export Options:
								
									</th>
									<td colspan="3" class="col-md-9">
										<button type="button" class="btn btn-info" onclick="$io.export.pdf();">PDF</button>
										<button type="button" class="btn btn-info" onclick="$io.export.doc( true );">DOC</button>
										<button type="button" class="btn btn-info" onclick="$io.export.doc( false );">HTML</button>
										<button type="button" class="btn btn-info" onclick="$io.export.csv($() );">CSV</button> 
										<button type="button" class="btn btn-info" onclick="$io.export.json();">JSON</button>
									</td>
								</tr>
							</tbody>
						</table>
						</form>
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="def:statement" mode="modalStatement">
		<blockquote style="font-size:10pt; margin-bottom:0;">
			<xsl:if test="def:number"><span class="btn bg-info"><xsl:value-of select="def:number" /></span><br />  </xsl:if>
			<xsl:call-template name="replaceNL">
				<xsl:with-param name="pText" select="./def:description"/>
			</xsl:call-template>
			<xsl:apply-templates select="./def:statement" mode="modalStatement" />
		</blockquote>
	</xsl:template>
	
	<xsl:template match="/controls:controls/controls:control" mode="controlDetailsModal">
		<div class="modal ">
			<xsl:attribute name="id">control<xsl:value-of select="./def:number" /></xsl:attribute>
			<div class="modal-dialog modal-fit">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
						<h4 class="modal-title"><em><xsl:value-of select="./def:title" /></em></h4>
					</div>
					<div class="modal-body">
						<table class="table table-striped table-bordered table-curved control-modal-summary">
							<thead>
								<tr>
									<th>Control</th>
									<th>Priority Level</th>
									<th>Subject Area</th>
									<th>Baseline Impact</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><xsl:value-of select="./def:number" /></td>
									<td>
										<xsl:value-of select="./def:priority" />
									</td>
									<td class="ia-controls subjectArea">
										<xsl:value-of select="./def:family" />
									</td>
									<xsl:choose>
										<xsl:when test="./def:baseline-impact = 'LOW'">
											<td class="text-nowrap impact bg-success">Low</td>
										</xsl:when>
										<xsl:when test="./def:baseline-impact = 'MODERATE'">
											<td class="text-nowrap impact bg-warning">Moderate</td>
										</xsl:when>
										<xsl:when test="./def:baseline-impact = 'HIGH'">
											<td class="text-nowrap impact bg-danger">High</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="text-nowrap impact bg-info">Not Selected</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
							</tbody>
						</table>
					
						<h4>Description:</h4>
						<div class="stig-description text-justify small control-description">
							<blockquote style="font-size:10pt;">
								<xsl:call-template name="replaceNL">
									<xsl:with-param name="pText" select="./def:supplemental-guidance/def:description"/>
								</xsl:call-template>
							</blockquote>
						</div>												

						<h4>Instructions:</h4>
						<div class="stig-description text-justify small control-instructions">							
							<xsl:apply-templates select="./def:statement" mode="modalStatement"/>
						</div>

						
						<xsl:if test="./def:supplemental-guidance/def:related">
							<h4>Related RMF Controls (800-53):</h4>
							
							<div class="stig-description text-justify small control-related-rmf">
								<blockquote>
									<xsl:for-each select="./def:supplemental-guidance/def:related" >
										
										<a class="btn btn-primary info related-rmf"  style="margin-bottom:4px;">
											<xsl:attribute name="href">#control<xsl:value-of select="." /></xsl:attribute>
											
											<xsl:value-of select="." />
										</a>
										<xsl:text> </xsl:text>
									</xsl:for-each>
								</blockquote>
							</div>
							
						</xsl:if>
						
						
						<xsl:variable name="thisRMFControl">
							<xsl:value-of select="./def:number" />
						</xsl:variable>
						
						<xsl:if test="document('controlMapping.xml')/controlMapping/control[./rmf = $thisRMFControl]/diacap">
							<h4>Related DIACAP Controls (8500-2)</h4>
							<div class="stig-description text-justify small control-related-diacap">
								<blockquote>
								<xsl:for-each select="document('controlMapping.xml')/controlMapping/control[./rmf = $thisRMFControl]/diacap">

									<a class="btn btn-primary">
										<xsl:value-of select="." />
									</a>
									<xsl:text> </xsl:text>
								</xsl:for-each>
								</blockquote>
							</div>
						</xsl:if>
						

						
						<xsl:if test="./def:control-enhancements/def:control-enhancement[not(./def:withdrawn)]">
						<h4>Enhancements</h4>
						<div class="stig-description text-justify small control-enhancements">							
							<xsl:for-each select="./def:control-enhancements/def:control-enhancement[not(./def:withdrawn)]">
								<blockquote style="font-size:10pt;">
									<xsl:attribute name="id">
										<xsl:text>blockquote</xsl:text>
										<xsl:value-of select="translate(./def:number,' ()','_zz')" />
									</xsl:attribute>
									
									
									<span class="btn bg-info sub-control-number"><xsl:value-of select="./def:number" /></span>
									
									<span class="control-baseline-impact">
										<xsl:if test="./def:baseline-impact">
											<xsl:for-each select="./def:baseline-impact">
												<xsl:text> </xsl:text>
												<xsl:choose>
													<xsl:when test=". = 'LOW'">
														<span class="btn bg-success">Low</span>
													</xsl:when>
													<xsl:when test=". = 'MODERATE'">
														<span class="btn bg-warning">Moderate</span>
													</xsl:when>
													<xsl:when test=". = 'HIGH'">
														<span class="btn bg-danger">High</span>
													</xsl:when>
													<xsl:otherwise>
														<span class="btn bg-info">Not Selected</span>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:if>
									</span>
									<br />
									
									<span class="sub-control-title"><xsl:value-of select="./def:title" /></span>
									<br />
									
									<h5>Description</h5>
									<span class="sub-control-description"><xsl:apply-templates select="./def:statement" mode="modalStatement"/></span>
									

									<xsl:if test="./def:supplemental-guidance/def:description">
										<h5>Supplemental Guidance</h5>
										<span class="sub-control-guidance"><blockquote style="font-size:10pt;" class="supp-guidance"><xsl:value-of select="./def:supplemental-guidance/def:description" /></blockquote></span>
									</xsl:if>
									
									<xsl:if test="./def:supplemental-guidance/def:related">
										<h5> Related RMF Controls (800-53)</h5>
										<div class="stig-description text-justify small">
											
											<xsl:for-each select="./def:supplemental-guidance/def:related" >
												<a class="btn btn-primary info" style="margin-bottom:4px;">
													<xsl:attribute name="href">#control<xsl:value-of select="." /></xsl:attribute>
													
													<xsl:value-of select="." />
												</a>
												<xsl:text> </xsl:text>
											</xsl:for-each>
											
										</div>
									</xsl:if>
								
									
									<xsl:variable name="thisDIACAPControl">
										<xsl:value-of select="./def:number" />
									</xsl:variable>

									<xsl:if test="document('controlMapping.xml')/controlMapping/control[./rmf = $thisDIACAPControl]/diacap">
										<h5>Related DIACAP Controls (8500-2)</h5>
										<xsl:for-each select="document('controlMapping.xml')/controlMapping/control[./rmf = $thisDIACAPControl]/diacap">

											<a class="btn btn-primary">
												<xsl:value-of select="." />
											</a>
											<xsl:text> </xsl:text>
										</xsl:for-each>
									</xsl:if>
									
						
								
								</blockquote>
								<hr />
							</xsl:for-each>
						</div>
						</xsl:if>
						
						<xsl:if test="./def:references/def:reference">
							<h4>References:</h4>
							<div class="stig-description text-justify small control-references">
								<xsl:for-each select="./def:references/def:reference" >
									<li>
										<a target="_blank">
											<xsl:attribute name="href">
												<xsl:value-of select="./def:item/@href" />
											</xsl:attribute>
											<xsl:value-of select="./def:item" />
										</a>
									</li>
								</xsl:for-each>
							</div>
						</xsl:if>
						
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="//controls:control" mode="controlTableData">
		<xsl:for-each select=".">
			<xsl:sort select="substring-before(./def:number,'-')" />
			<xsl:sort select="substring-after(./def:number,'-')" data-type="number" />

			<tr>
				<xsl:attribute name="data-control"><xsl:value-of select="./def:number" /></xsl:attribute>

				<td class="text-nowrap">
					<a data-toggle="modal" href="#myModal" class="btn btn-primary">
						<xsl:attribute name="href">#control<xsl:value-of select="./def:number" /></xsl:attribute>
						<xsl:value-of select="./def:number" />
					</a>
				</td>
				<xsl:choose>
					<xsl:when test="./def:baseline-impact = 'LOW'">
						<td class="text-nowrap impact bg-success">Low</td>
					</xsl:when>
					<xsl:when test="./def:baseline-impact = 'MODERATE'">
						<td class="text-nowrap impact bg-warning">Moderate</td>
					</xsl:when>
					<xsl:when test="./def:baseline-impact = 'HIGH'">
						<td class="text-nowrap impact bg-danger">High</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="text-nowrap impact bg-info">Not Selected</td>
					</xsl:otherwise>
				</xsl:choose>
				<td class="priority">
					<xsl:value-of select="./def:priority" />
				</td>
				<td class="family text-nowrap hidden-xs"><xsl:value-of select="./def:family" /></td>
				<td class=""><xsl:value-of select="./def:title" /></td>
				<td class="control-description hidden-xs hidden-sm">
					<xsl:call-template name="replaceNL">
						<xsl:with-param name="pText" select="./def:supplemental-guidance/def:description"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:for-each>
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
								<xsl:value-of select="substring-before(./controls:controls/@pub_date,'T')" />
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="border-bottom:1px solid #ccc;">
							<div class="row h3">
								Controls
							</div>
							<div class="row" id='stigDate'>
								<xsl:value-of select="count(/controls:controls/controls:control)" />
							</div>
						</div>
					</div>
					
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							Priority Level
						</div>
						<div class="row"  style="border-bottom:1px solid #ccc;">
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<a class="btn btn-block btn-danger" onclick="$view.filters.priority('P1')">
									P1 <span class="badge"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P1'])" /></span>
								</a>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<a class="btn btn-block btn-warning" onclick="$view.filters.priority('P2')">
									P2 <span class="badge"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P2'])" /></span>
								</a>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<a class="btn btn-block btn-success" onclick="$view.filters.priority('P3')">
									P3 <span class="badge"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P3'])" /></span>
								</a>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<a class="btn btn-block btn-info" onclick="$view.filters.priority('P0')">
									P0 <span class="badge"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P0'])" /></span>
								</a>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<a class="btn btn-block btn-primary" onclick="$view.filters.priority('NA')">
									NA <span class="badge"><xsl:value-of select="count(/controls:controls/controls:control[not(./def:priority ) ])" /></span>
								</a>
							</div>
						</div>
					</div>
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >
						<div class="row h3 ">
							Impact Code
						</div>
						<div class="row">
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<button class="btn btn-primary btn-danger" type="button" onclick="$view.filters.impact('High')" style="width:125px;">
									High 
									<span class="badge">
										<xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact][not(./def:baseline-impact = 'LOW')][not(./def:baseline-impact = 'MODERATE') ])" />
									</span>
								</button>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<button class="btn btn-primary btn-warning" type="button" onclick="$view.filters.impact('Moderate')" style="width:125px;">
									Moderate 
									<span class="badge">
										<xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact and not(./def:baseline-impact = 'LOW')   ]) - count(/controls:controls/controls:control[./def:baseline-impact][not(./def:baseline-impact = 'LOW')][not(./def:baseline-impact = 'MODERATE') ])" />
									</span>
								</button>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<button class="btn btn-primary btn-success" type="button" onclick="$view.filters.impact('Low')" style="width:125px;">
									Low 
									<span class="badge">
										<xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact = 'LOW'])" />
									</span>
								</button>
							</div>
							<div class="col-xs-4 col-sm-3 col-md-4 col-lg-3">
								<button class="btn btn-primary" type="button" onclick="$view.filters.impact('NA')" style="width:125px;">
									N.A 
									<span class="badge">
										<xsl:value-of select="count(/controls:controls/controls:control[not(./def:baseline-impact)])" />
									</span>
								</button>
							</div>
						</div>
					</div>
					
				</div>
				
				<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						<div class="row h3 ">
							Triad
						</div>
						<div class="row">
								
								<table class="ciaTriad table table-striped table-bordered table-curved">
									<tr>
										<th class="col-md-3"></th>
										<th class="col-md-3">C</th>
										<th class="col-md-3">I</th>
										<th class="col-md-3">A</th>
									</tr>
									<tr>
										<th>High</th>
										<td id="ch"></td>
										<td id="ih"></td>
										<td id="ah"></td>
									</tr>
									<tr>
										<th>Mod</th>
										<td id="cm"></td>
										<td id="im"></td>
										<td id="am"></td>
									</tr>
									<tr>
										<th>Low</th>
										<td id="cl"></td>
										<td id="il"></td>
										<td id="al"></td>
									</tr>
								</table>
								
								<button class="btn btn-primary pull-right" type="button" id="clearTriad" >
									Clear
								</button>
								<button type="button" data-toggle="modal" href="#myModal" class="btn btn-primary pull-right">
									<xsl:attribute name="href">#controlTailoring</xsl:attribute>
									Export Controls
								</button>
								
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
		
	<xsl:template name="control-description-table">
	
		<div class="container-fluid table table-curved">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12 em h3" style="border-bottom:1px solid #ccc;">
					<em>800-53 Risk Management Framework - Security Controls</em>
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
			<table class="table-bordered table-hover tablesorter stig-finding" id="table-findings">
				<thead>
					<tr>
						<th>Control</th>
						<th>Baseline Impact</th>
						<th>Priority Level</th>
						<th class="hidden-xs">Subject Area</th>
						<th>Title</th>
						<th class=" hidden-xs hidden-sm">Description</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="/controls:controls/controls:control[not(./def:withdrawn)]" mode="controlTableData" />
				</tbody>
			</table>
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
					<a class="navbar-brand" href="#">800-53 Controls</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<ul class="nav navbar-nav navbar-right">
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Priority Level <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.priority('');">All</a></li>
								<li><a href="#" onclick="$view.filters.priority('P1');">P1<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P1'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.priority('P2');">P2<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P2'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.priority('P3');">P3<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P3'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.priority('P0');">P0<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:priority/text() = 'P0'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.priority('NA');">NA<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[not(./def:priority ) ])" /></span></a></li>
							</ul>
						</li>
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Baseline Impact<span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.impact('');">All</a></li>
								<li><a href="#" onclick="$view.filters.impact('Low');">Low<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact = 'LOW'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.impact('Moderate');">Moderate<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact and not(./def:baseline-impact = 'LOW')   ]) - count(/controls:controls/controls:control[./def:baseline-impact][not(./def:baseline-impact = 'LOW')][not(./def:baseline-impact = 'MODERATE') ])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.impact('High');">High<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[./def:baseline-impact][not(./def:baseline-impact = 'LOW')][not(./def:baseline-impact = 'MODERATE') ])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.impact('NA');">NA<span class="badge pull-right"><xsl:value-of select="count(/controls:controls/controls:control[not(./def:baseline-impact)])" /></span></a></li>
							</ul>
						</li>
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Subject Areas<span class="caret"></span>
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
									<select class="form-control navbar-btn" onchange="location.href = this.value + location.href.substr(location.href.lastIndexOf('.'))" id="stigMenu">
										<xsl:apply-templates select="document('configurations.xml')/configurations/menu/item" mode="stig-menu">	
											<xsl:with-param name="selectedStig" select="'800-53'" />
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
		<xsl:variable name="subjectAreas" select="/controls:controls/controls:control/def:family" />
		<xsl:for-each select="$subjectAreas">
			<xsl:sort select="." />
			<xsl:if test="generate-id() = generate-id($subjectAreas[. = current()][1])">
				<xsl:variable name="subjectAreaName" select="." />
				<li>
					<a href="#" >
						<xsl:attribute name="onclick">
							$view.filters.subjectArea('<xsl:value-of select="." />');
						</xsl:attribute>
						<xsl:call-template name="CamelCase">
							<xsl:with-param name="text"><xsl:value-of select="substring(text(),0,30)" /></xsl:with-param>
						</xsl:call-template>
						<xsl:text> </xsl:text>
						<span class="badge pull-right"> <xsl:value-of select="count(/controls:controls/controls:control/def:family[text() = $subjectAreaName])" /></span>
					</a>
				</li>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>