<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cdf="http://checklists.nist.gov/xccdf/1.1" xmlns:cci="http://iase.disa.mil/cci" >
	

	<xsl:import href="functions.xsl"/>
	<xsl:preserve-space elements="cdf:check cdf:checkcontent" />
	
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
									<xsl:call-template name="stig-description-table" />
								</div>
								
								<div class="table-responsive">
									<xsl:call-template name="stig-version-table" />
								</div>
								

							</div>
							<h2 class="sub-header">Requirements</h2>
							<xsl:call-template name="findingsTable" />
							<xsl:call-template name="cklFindingsTable" />
							<xsl:call-template name="rawFindingsTable" />
							<xsl:call-template name="exportFindingsTable" />
						</div>
					</div>
				</div>
				
				<xsl:apply-templates select="//cdf:Rule" mode="ruleDetailsModal" />
				<xsl:call-template name="ruleCklDetailsModal" />
				<xsl:call-template name="cklModal" />
				<xsl:call-template name="stig-object" />
			</body>
		</html>
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
					<a class="navbar-brand" href="#">STIG Transformer</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<ul class="nav navbar-nav navbar-right">
						<li role="presentation" class="dropdown">
							 <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								STIG Format <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
							  <li><a href="#" onclick="$view.tables.showFormat('Elegant');">Elegant</a></li>
							  <li><a href="#" onclick="$view.tables.showFormat('Raw');">Raw</a></li>
							  <li><a href="#" onclick="$view.tables.showFormat('Ckl');">Checklist</a></li>
							</ul>
						</li>
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Severity <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="#" onclick="$view.filters.showAll();">All</a></li>
								<li><a href="#" onclick="$view.filters.severity('High')">High<span class="badge pull-right"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'high'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.severity('Medium')">Medium<span class="badge pull-right"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'medium'])" /></span></a></li>
								<li><a href="#" onclick="$view.filters.severity('Low')">Low<span class="badge pull-right"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'low'])" /></span></a></li>
							</ul>
						</li>
						<li>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
								Profiles <span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<xsl:apply-templates select="cdf:Benchmark/cdf:Profile/cdf:title" mode="navbarProfileList"></xsl:apply-templates>
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
											<xsl:with-param name="selectedStig" select="/cdf:Benchmark/cdf:title" />
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
	
	
	<xsl:template name="cklFindingsTable">
		<div class="table-responsive" id="findings-table">
			<table class="table-striped table-bordered tablesorter stig-finding hidden" id="ckl-findings-table">
				<thead>
					<tr>
						<th>IDs</th>
						<th>Status</th>
						<th>Severity</th>
						<th>Title</th>
						<th class="col-md-2 hidden-sm hidden-xs">Finding Details</th>
						<th class="col-md-2 hidden-sm hidden-xs">Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="//cdf:Rule" mode="cklFindingsData" />
				</tbody>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="cklModal">
		<div class="modal fade" id="myCklModal">
			
			<div class="modal-dialog  modal-fit">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
						<h4 class="modal-title"><em><xsl:value-of select="cdf:Benchmark/cdf:title" /> - STIG Checklist</em></h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-md-6">
								<table class="table table-bordered table-curved table-condensed">
									<thead>
										<tr>
											<th>Requirement Totals</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div class="row">
													<div class="clearfix"></div>
													<div class="col-md-12">
														<div id="chart_div" class="chart"></div>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
						
								<table class="table table-condensed table-striped table-bordered table-curved">
									<thead>
										<tr>
											<th>Category</th>
											<th>Open</th>
											<th>Not Reviewed</th>
											<th>Not Applicable</th>
											<th>Not a Finding</th>
										</tr>
									</thead>
									<tbody>
										<tr id="overAll">
											<td>Overall</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr id="catI">
											<td>Cat I</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr id="catII">
											<td>Cat II</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr id="catIII">
											<td>Cat III</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
											<td>0</td>
										</tr>
									</tbody>
								</table>
								
								
							</div>
							<div class="col-md-6">
								<table class="table-condensed table-striped table-bordered table-curved">
									<tbody>
										<tr>
											<th>Asset Type</th>
											<td><select name="assetType"><option>Computing</option><option>Non-Computing</option></select></td>
										</tr>
										<tr>
											<th>Hostname</th>
											<td><input type="text" name="hostname" id="hostname" /></td>
										</tr>
										<tr>
											<th>IP Address</th>
											<td><input type="text" name="ip" id="ip" /></td>
										</tr>
										<tr>
											<th>MAC Address</th>
											<td><input type="text" name="mac" id="mac" /></td>
										</tr>
										<tr>
											<th>Fully Qualified Domain Name</th>
											<td><input type="text" name="fqdn" id="fqdn" /></td>
										</tr>
										<tr>
											<th>Role</th>
											<td><select name="role"><option>None</option><option>Workstation</option><option>Member Server</option><option>Domain Controller</option></select></td>
										</tr>
										<tr>
											<th>Tech Area</th>
											<td><select name="techArea">
											<option>None</option>
											<option>Application Review</option>
											<option>Boundary Security</option>
											<option>CDS Admin Review</option>
											<option>CDS Technical Review</option>
											<option>Database Review</option>
											<option>Domain Name System (DNS)</option>
											<option>Exchange Server</option>
											<option>Host Based Security System (HBSS)</option>
											<option>Internal Network</option>
											<option>Mobility</option>
											<option>Releasable Networks (REL)</option>
											<option>Traditional Security</option>
											<option>UNIX OS</option>
											<option>VVOIP Review</option>
											<option>Web Review</option>
											<option>Windows OS</option>
											<option>Other Review</option>
											
											</select></td>
										</tr>
									</tbody>
								</table>
								<br />
								<table class="table table-striped table-bordered table-curved table-condensed">
									<thead>
										<tr>
											<th> Import File (.xccdf or .ckl)</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<input type="file" id="xccdfFile" name="xccdfFile"/>			
											</td>
										</tr>
									</tbody>
								</table>
								
								<table class="table table-striped table-bordered table-curved table-condensed">
									<thead>
										<tr>
											<th> Import Progress</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div >
													<div class="progress" style="height:35px;">
														<div class="progress-bar progress-bar-striped center-block" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="height:35px; width:0%; padding-top:10px;font-size:18pt;font-weight:bold;" id="fileImport"></div>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								<table class="table table-striped table-bordered table-curved table-condensed">
									<thead>
										<tr>
											<th>Generate Checklist</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div class="row">
													<div class="col-md-3 center-block">
														<button href="#" class="btn btn-primary" onclick="$io.export.ckl()">Generate</button>
													</div>
													<div class="col-md-9">
														<div class="progress" style="height:35px;">
															<div  class="progress-bar progress-bar-striped center-block" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="height:35px; width:0%; padding-top:10px;font-size:18pt;font-weight:bold;" id="cklExport"></div>
														</div>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="exportFindingsTable">
		<table class="hidden" id="exportfindingsTable">
			<tr>
				<th>VulnId</th>
				<th>RuleId</th>
				<th>Severity</th>
				<th>Title</th>
				<th>Description</th>
				<th>IAControls</th>
				<th>FixId</th>
				<th>FixText</th>
				<th>CheckId</th>
				<th>CheckText</th>
			</tr>
			<xsl:apply-templates select="//cdf:Rule" mode="exportFindingsData" />
		</table>
	</xsl:template>	
	
	<xsl:template name="findingsTable">
		<div class="table-responsive" id="findings-table">
			<table class="table-striped table-bordered table-hover tablesorter stig-finding" id="table-findings">
				<thead>
					<tr>
						<th>IDs</th>
						<th>Severity</th>
						<th>Title</th>
						<th class="hidden-sm hidden-xs">Description</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="//cdf:Rule" mode="findingsData" />
				</tbody>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="html-head">
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<title>Stig Transformer - <xsl:value-of select="cdf:Benchmark/cdf:title" /> </title>
		<xsl:call-template name="lib_Js" />
		<xsl:call-template name="lib_Css" />
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='stig_Js']"/>
	</xsl:template>
	
	<xsl:template name="rawFindingsTable">
		<div class="table-responsive hidden" id="raw-findings-table">
			<xsl:apply-templates select="//cdf:Rule" mode="rawFindingsData"/>
		</div>
	</xsl:template>
	
	<xsl:template name="ruleCklDetailsModal">
		<div class="modal fade" id="stigCklModal">
			<div class="modal-dialog  modal-fit">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
						<h4 class="modal-title" id="stigCklModalTitle"><em></em></h4>
					</div>
					<div class="modal-body">
						<table class="table table-striped table-bordered table-curved">
							<thead>
								<tr>
									<th>Status</th>
									<th>Vulnerability ID</th>
									<th>Version</th>
									<th>Rule ID</th>
									<th>RMF Controls</th>
									<th>DIACAP Controls</th>
									<th>Severity</th>
									
								</tr>
							</thead>
							<tbody>
								<tr>
								
									<td>
										<select  id="stigCklModalStatus">
											<option>Open</option>
											<option>Not Reviewed</option>
											<option>Not Applicable</option>
											<option>Not a Finding</option>
										</select>
									</td>
									<td id="stigCklModalId"></td>
									<td id="stigCklModalVersion"></td>
									<td id="stigCklModalRuleId"></td>
									<td id="stigCklModalRMF"></td>
									<td id="stigCklModalDIACAP"></td>
									<td id="stigCklModalSeverity"></td>
								</tr>
							</tbody>
						</table>
					
						<h4>Description:</h4>
						<div class="stig-description text-justify small" id="stigCklModalDescription"></div>
						
						<h4>Check Text ( <span id="stigCklModalCheckRef"></span> ):</h4>
						<pre><div class="text-justify small" id="stigCklModalCheckContent"></div></pre>
						
						<h4>Fix Text ( <span id="stigCklModalFixRef"></span> ):</h4>
						<pre><div class="text-justify small" id="stigCklModalFixText"></div></pre>
						
						<h4>Finding Details:</h4>
						<div class="text-justify small">
							<textarea class="form-control" rows="5" id="stigCklModalFinding"></textarea>
						</div>
						
						<h4>Comments:</h4>
						<div class="text-justify small">
							<textarea class="form-control" rows="5" id="stigCklModalComments"></textarea>
						</div>
						
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="stig-description-table">
		<xsl:if test="cdf:Benchmark/cdf:description">
			<div class="container-fluid table table-curved">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12 em h3" style="border-bottom:1px solid #ccc;">
						<em><xsl:value-of select="cdf:Benchmark/cdf:title" /> 	</em>
					</div>
				</div>
				<div class="row ">
					<div class="col-lg-12 col-md-12 small">
						<xsl:value-of select="cdf:Benchmark/cdf:description" />
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="stig-version-table">
		<div class="container-fluid table table-curved">
			<div class="row ">
				<div>
					<div class="col-lg-2 col-md-6 col-sm-6 col-xs-6" style="border-bottom:1px solid #ccc;">
						<div class="row h3 ">
							Version
						</div>
						<div class="row" id='stigVersion'>
						
						</div>
					</div>
					<div class="col-lg-2 col-md-6 col-sm-6 col-xs-6" style="border-bottom:1px solid #ccc;">
						<div class="row h3">
							Date
						</div>
						<div class="row" id='stigDate'>
						
						</div>
					</div>
				</div>
				<div class="col-lg-4 col-md-12 h3">
					<div class="row">
						Finding Count ( <xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule)" />  )
					</div>
					<div class="row">
						<div class="col-sm-4 col-md-3 col-lg-4">
							<a class="btn btn-block btn-danger" type="button" onclick="$view.filters.severity('High')">
								CAT I<span class="badge"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'high'])" /></span>
							</a>
						</div>
						<div class="col-sm-4 col-md-3 col-lg-4">
							<a class="btn btn-block btn-warning" type="button" onclick="$view.filters.severity('Medium')">
								CAT II<span class="badge"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'medium'])" /></span>
							</a>
						</div>
						<div class="col-sm-4 col-md-3 col-lg-4">
							<a class="btn btn-block btn-success" type="button" onclick="$view.filters.severity('Low')">
								CAT III<span class="badge"><xsl:value-of select="count(cdf:Benchmark/cdf:Group/cdf:Rule[@severity = 'low'])" /></span>
							</a>
						</div>
					
					</div>
				</div>
				<div class="col-lg-4 col-md-12 h3">
					<div class="row">
						Export Options
					</div>
					<div class="row">
						<div class="col-sm-4 col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" onclick="$io.export.pdf();">PDF</a>
						</div>
						<div class="col-sm-4  col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" onclick="$io.export.doc(true);">DOC</a>
						</div>
						<div class="col-sm-4 col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" onclick="$io.export.doc(false);">HTML</a>
						</div>
						<div class="col-sm-4 col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" onclick="$io.export.csv($('#exportFindingsTable tr') );">CSV</a> 
						</div>
						<div class="col-sm-4 col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" onclick="$io.export.json();">JSON</a>
						</div>
						<div class="col-sm-4 col-md-2 col-lg-4">
							<a class="btn btn-info btn-block" data-toggle="modal" href="#myCklModal" >Checklist</a>
						</div>
					</div>
				</div>
				
				
				
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="stig-object" >
<script>

$(document).ready(function(){
	var vstring = 'Version <xsl:value-of select="cdf:Benchmark/cdf:version" />, <xsl:value-of select="cdf:Benchmark/cdf:plain-text[@id = 'release-info']" />'.split('Date:');
	$('#stigVersion').text(  vstring[0].replace(':','').trim() );
	$('#stigDate').text( vstring[1] );
});

var $objStig = {
	"stig" :{
		"getCklCounts" : function(){
			var counts = {};
			var v1,v2,i1,i2;
			$.each(['high','medium','low'], function(i1,v1){
				counts[v1] = {};
				$.each(['Open','Not_Reviewed','NotApplicable','NotAFinding'],function(i2,v2){
					counts[v1][v2] = ($.map( $objStig.stig.findings , function(obj){ if(obj.status == v2 &amp;&amp; obj.severity == v1 ){return obj}; }).length);
				});
			});
			return counts;
		},
		"getRule" : function(ruleID){
			var rule;
			$.each( $objStig.stig.findings, function(){
				 if(this.ruleID == ruleID){
					rule = this;
					return false;
				 }
			});
			
			return rule;
		},
		"updateRule" : function(ruleID, vulnID, name, value){
			//first try to match rules, if that doesn't work match vulns
			var m = false;
			$.each( $objStig.stig.findings, function(){
				if(this.ruleID == ruleID){
					this[name] = value;
					m = true;
					return false;
				}
			});
			
			//didn't match a rule, search for vulns now
			if(!m){
				$.each( $objStig.stig.findings, function(){
					if(this.id == vulnID){
						this[name] = value;
						return false;
					}
				})
			}
		},
	
		"id" : "<xsl:value-of select="/cdf:Benchmark/@id" />",
		"date" : "<xsl:value-of select="/cdf:Benchmark/cdf:status/@date" />",
		"title": <xsl:call-template name="escape-string"><xsl:with-param name="s" select="/cdf:Benchmark/cdf:title"/></xsl:call-template>,
		"version": "<xsl:value-of select="/cdf:Benchmark/cdf:version" />",
		"release" : "<xsl:value-of select="/cdf:Benchmark/cdf:plain-text[@id='release-info']" />",
		"description" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="/cdf:Benchmark/cdf:description" /></xsl:call-template>,
		"notice" : "<xsl:value-of select="/cdf:Benchmark/cdf:notice/@id" />",
		"source" : "<xsl:value-of select="/cdf:Benchmark/cdf:reference/dc:source" />",
		"profiles": {<xsl:for-each select="cdf:Benchmark/cdf:Profile">
			<xsl:call-template name="escape-string"><xsl:with-param name="s" select="./cdf:title" /></xsl:call-template> : {
				"description" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="./cdf:description" /></xsl:call-template>,
				"id": "<xsl:value-of select="@id" />", 
				"title": <xsl:call-template name="escape-string"><xsl:with-param name="s" select="./cdf:title" /></xsl:call-template>, 
				"findings" : {<xsl:for-each select="./cdf:select">
					"<xsl:value-of select="@idref" />" : "<xsl:value-of select="@selected" />"<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				}
			}<xsl:if test="position() != last()">,</xsl:if>
</xsl:for-each>
		},
		"findings" : {<xsl:for-each select="//cdf:Rule">
				"<xsl:value-of select="../@id" />" : {
					"id" : "<xsl:value-of select="../@id" />",
					"ruleID" : "<xsl:value-of select="@id" />",
					"severity" : "<xsl:value-of select="@severity" />",
					"title" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="./cdf:title" /></xsl:call-template>,
					"groupTitle" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="../cdf:title" /></xsl:call-template>,
					"version" : "<xsl:value-of select="./cdf:version" />",
					"description" : "<xsl:call-template name="string-replace-all"><xsl:with-param name="text" select="substring-after(substring-before(./cdf:description,'&lt;/VulnDiscussion&gt;'),'&lt;VulnDiscussion&gt;')" /></xsl:call-template>",
					"checkId" : "<xsl:value-of select="./cdf:check/@system" />",
					"checkText" : "<xsl:call-template name="search-and-replace-whole-words-only">
	<xsl:with-param name="input">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="./cdf:check/cdf:check-content" />
		</xsl:call-template>
	</xsl:with-param>
	<xsl:with-param name="search-string" select="'script'" />
	<xsl:with-param name="replace-string" select="'scr ipt'" />
</xsl:call-template>",
					"fixId" : "<xsl:value-of select="./cdf:fix/@id" />",
					"fixText" : "<xsl:call-template name="string-replace-all"><xsl:with-param name="text" select="./cdf:fixtext" /></xsl:call-template>",
					"cci" : "<xsl:value-of select="./cdf:ident[@system='http://iase.disa.mil/cci']" />",
					"documentable" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/Documentable&gt;'),'&lt;Documentable&gt;')" /></xsl:call-template>,
					"responsibility" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/Responsibility&gt;'),'&lt;Responsibility&gt;')" /></xsl:call-template>,
					"mitigations" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/Mitigations&gt;'),'&lt;Mitigations&gt;')" /></xsl:call-template>,
					"mitigationControl" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/MitigationControl&gt;'),'&lt;MitigationControl&gt;')" /></xsl:call-template>,
					"severityOverideGuidance" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/SeverityOverrideGuidance&gt;'),'&lt;SeverityOverrideGuidance&gt;')" /></xsl:call-template>,
					"potentialImpacts" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/PotentialImpacts&gt;'),'&lt;PotentialImpacts&gt;')" /></xsl:call-template>,
					"thirdPartyTools" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/ThirdPartyTools&gt;'),'&lt;ThirdPartyTools&gt;')" /></xsl:call-template>,
					"vulnerabilityDiscussion" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/VulnDiscussion&gt;'),'&lt;VulnDiscussion&gt;')" /></xsl:call-template>,
					"falsePositives" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/FalsePositives&gt;'),'&lt;FalsePositives&gt;')" /></xsl:call-template>,
					"falseNegatives" : <xsl:call-template name="escape-string"><xsl:with-param name="s" select="substring-after(substring-before(./cdf:description,'&lt;/FalseNegatives&gt;'),'&lt;FalseNegatives&gt;')" /></xsl:call-template>,
					"iacontrols" : "<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/IAControls&gt;'),'&lt;IAControls&gt;')"/>",
					"references" : {<xsl:for-each select="./cdf:reference/*">
							"<xsl:value-of select="local-name()" />" : "<xsl:value-of select="." />"<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					},
					"status" : "Not_Reviewed",
					"finding" : "",
					"comments" : "",
					"severity_override" : "",
					"severity_justification" : ""
				}<xsl:if test="position() != last()">,</xsl:if>
			</xsl:for-each>
		}
	}
}
		</script>
	</xsl:template>
	
	<xsl:template match="//cdf:Rule" mode="cklFindingsData">
		<xsl:for-each select=".">
			<tr>
				<xsl:attribute name="id">cklTr<xsl:value-of select="@id" /></xsl:attribute>
			
				<td class="text-nowrap col-md-2">
					Vuln ID: <xsl:value-of select="../@id" /><br />
					Rule ID: <xsl:value-of select="@id" /> <br />
					
					<a class="btn btn-primary">
						<xsl:attribute name="onclick">
							$view.modals.showCkl('<xsl:value-of select="@id" />');
						</xsl:attribute>
						 
						
						Show Checklist
					</a>
				</td>
				<td class="bg-warning ckl-status col-md-1"><xsl:attribute name="id">cklVuln<xsl:value-of select="../@id" /></xsl:attribute>Not Reviewed</td>
				<xsl:choose>
					<xsl:when test="@severity = 'high'">
						<td class="bg-danger col-md-2">High</td>
					</xsl:when>
					<xsl:when test="@severity = 'medium'">
						<td class=" bg-warning col-md-2">Medium</td>
					</xsl:when>
					<xsl:when test="@severity = 'low'">
						<td class=" bg-success col-md-2">Low</td>
					</xsl:when>
				</xsl:choose>
				<td class="col-md-2"><xsl:value-of select="./cdf:title" /></td>
				<td class="stig-description ckl-findings col-md-2 hidden-sm hidden-xs"></td>
				<td class="stig-description ckl-comments col-md-2 hidden-sm hidden-xs"></td>
				
			</tr>
			
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="cdf:Benchmark/cdf:Profile/cdf:title" mode="contentProfiles">
		<xsl:for-each select=".">
			<xsl:variable name="selProfile" select="../@id" />
			<div class="col-md-4 placeholder text-left ">
				<button class="btn btn-default" type="button">
					<xsl:attribute name="onclick">
						$view.filters.profile('<xsl:value-of select="." />');
					</xsl:attribute>
					<xsl:value-of select="." />
					<xsl:text> </xsl:text>
					<span class="badge"> <span class="badge pull-right"><xsl:value-of select="count(/cdf:Benchmark/cdf:Profile[@id = $selProfile]/cdf:select)" /></span> </span>
				</button>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="//cdf:Rule" mode="exportFindingsData">
		<xsl:for-each select=".">
			<tr>
				<td><xsl:value-of select="../@id" /></td>
				<td><xsl:value-of select="@id" /></td>
				<td><xsl:value-of select="@severity" /></td>
				<td><xsl:value-of select="./cdf:title" /></td>
				<td class="stig-description"><xsl:value-of select="./cdf:description" /></td>
				<td></td>
				<td><xsl:value-of select="./cdf:fix/@id" /></td>
				<td><xsl:value-of select="./cdf:fixtext" /></td>
				<td><xsl:value-of select="./cdf:check/@system" /></td>
				<td><xsl:value-of select="./cdf:check/cdf:check-content" /></td>
				
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="//cdf:Rule" mode="findingsData">
		<xsl:for-each select=".">
			<tr>
				<td class="text-nowrap">
					Vuln ID: <xsl:value-of select="../@id" /><br />
					Rule ID: <xsl:value-of select="@id" /> <br />
					
					<a data-toggle="modal" href="#myModal" class="btn btn-primary">
						<xsl:attribute name="href">#finding<xsl:value-of select="@id" /></xsl:attribute>
						Show Details
					</a>
				</td>
				<xsl:choose>
					<xsl:when test="@severity = 'high'">
						<td class="bg-danger">High</td>
					</xsl:when>
					<xsl:when test="@severity = 'medium'">
						<td class=" bg-warning">Medium</td>
					</xsl:when>
					<xsl:when test="@severity = 'low'">
						<td class=" bg-success">Low</td>
					</xsl:when>
				</xsl:choose>
				<td class=""><xsl:value-of select="./cdf:title" /></td>
				<td class="stig-description hidden-xs hidden-sm"><xsl:value-of select="./cdf:description" /></td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="//cdf:Rule" mode="ruleDetailsModal">
		<xsl:variable name="cci" select="./cdf:ident[@system='http://iase.disa.mil/cci']" />
		<xsl:variable name="iactls" select="document('U_CCI_List.xml')/cci:cci_list/cci:cci_items/cci:cci_item[@id=$cci]/cci:references/cci:reference[starts-with(@title,'NIST SP 800-53 Revision 4')]/@index" />
		<xsl:variable name="rmfCtls">								
			<xsl:for-each select="$iactls" >
				<xsl:sort select="." />
				<rmf>
					<xsl:if test="generate-id() = generate-id($iactls[. = current()][1])">
						<xsl:value-of select="." />
					</xsl:if>
				</rmf>
			</xsl:for-each>
		</xsl:variable>
								
								
		<div class="modal ">
			<xsl:attribute name="id">finding<xsl:value-of select="@id" /></xsl:attribute>
			<div class="modal-dialog modal-fit">
				<div class="modal-content">
					<div class="modal-header">
					
						<div class="btn-group pull-right" role="group">
							<button type="button" class="btn btn-default prev-modal" data-dismiss="modal" aria-label="Previous Requirement" onclick="$('#' + $('div#finding' + $(this).attr('data-rule') ).prev().attr('id')  ).modal();">
								<xsl:attribute name="data-rule"><xsl:value-of select="@id" /></xsl:attribute>
								&lt;
							</button>
							<button type="button" class="btn btn-default prev-modal" data-dismiss="modal" aria-label="Next Requirement" onclick="$('#' + $('div#finding' + $(this).attr('data-rule') ).next().attr('id')  ).modal();">
								<xsl:attribute name="data-rule"><xsl:value-of select="@id" /></xsl:attribute>
								&gt;
							</button>
							<button type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">X</button>
						</div>
						<h4 class="modal-title"><em><xsl:value-of select="./cdf:title" /></em></h4>
					</div>
					<div class="modal-body">
						<table class="table table-responsive table-striped table-bordered table-curved">
							<thead>
								<tr>
									<th>Vulnerability ID	</th>
									<th>Version</th>
									<th>Rule ID</th>
									<th>RMF Controls</th>
									<th>DIACAP Controls</th>
									<th>Severity</th>
									
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><xsl:value-of select="../@id" /></td>
									<td><xsl:value-of select="./cdf:version" /></td>
									<td><xsl:value-of select="@id" /></td>
									<td class="rmf-controls">
										<xsl:for-each select="msxsl:node-set($rmfCtls)/rmf" >
											<xsl:if test=". != ''">
												<xsl:copy-of select="." />
												 <xsl:if test="position() != last()">, </xsl:if>
											</xsl:if>									
										</xsl:for-each>
									</td>
									<td class="rmf-controls">
										<xsl:for-each select="msxsl:node-set($rmfCtls)/rmf[not(preceding-sibling::rmf)]" >
											<xsl:variable name="rmfCurCtl" select="concat(substring(.,1,3),translate(substring(.,4,2),'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ',''))" />
											
											<xsl:for-each select="document('controlMapping.xml')/controlMapping/control[./rmf=$rmfCurCtl]/diacap">
												<xsl:value-of select="." />
												 <xsl:if test="position() != last()">, </xsl:if>
											</xsl:for-each>
										</xsl:for-each>									
									</td>
									<xsl:choose>
										<xsl:when test="@severity = 'high'">
											<td class="bg-danger">High</td>
										</xsl:when>
										<xsl:when test="@severity = 'medium'">
											<td class=" bg-warning">Medium</td>
										</xsl:when>
										<xsl:when test="@severity = 'low'">
											<td class=" bg-success">Low</td>
										</xsl:when>
									</xsl:choose>
									
								</tr>
							</tbody>
						</table>
					
						<h4>Description:</h4>
						<div class="stig-description small">
							<xsl:value-of select="./cdf:description" />
						</div>
						
						<h4>Check Text ( <xsl:value-of select="./cdf:check/@system" /> ):</h4>
						<div class="text-justify small">
							<pre><xsl:value-of select="./cdf:check/cdf:check-content" /></pre>
						</div>
						
						<h4>Fix Text ( <xsl:value-of select="./cdf:fixtext/@fixref" /> ):</h4>
						<div class="text-justify small">
							<pre><xsl:value-of select="./cdf:fixtext" /></pre>
						</div>
						
						<xsl:if test="./cdf:ident[@system='http://iase.disa.mil/cci']">
							
							<h4>CCI Information ( <xsl:value-of select="$cci" /> ):</h4>
							<div class="text-justify small cci">
								<xsl:value-of select="document('U_CCI_List.xml')/cci:cci_list/cci:cci_items/cci:cci_item[@id=$cci][1]/cci:definition" />
								<br />
								<xsl:for-each select="document('U_CCI_List.xml')/cci:cci_list/cci:cci_items/cci:cci_item[@id=$cci]/cci:references/cci:reference">
									<xsl:sort select="@version" />
									<xsl:value-of select="./@title"/>
									<xsl:value-of select="' - '" />
									<xsl:value-of select="./@index"/>
									<br />
								</xsl:for-each>
							</div>
						</xsl:if>
						<h4>References</h4>
						<table class="small table table-striped table-bordered table-condensed table-curved">
							<xsl:for-each select="./cdf:reference/*">
								<tr>
									<th>
										<span class="text-capitalize">
											<strong>
												<xsl:value-of select="local-name()" />
											</strong>
										</span>
									</th>
									<td>
										<xsl:value-of select="." /><br />	
									</td>
								</tr>
							</xsl:for-each>
						</table>
						
					</div>
					<div class="modal-footer">
						<a href="#" data-dismiss="modal" class="btn btn-primary">Close</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>




	
	<xsl:template match="//cdf:Rule" mode="rawFindingsData">
		<xsl:for-each select=".">
			<div class="rawFindings">
				<strong>Group ID (Vulid):</strong>
				<xsl:value-of select="../@id" />
				<br />
				
				<strong>Group Title: </strong>
				<xsl:value-of select="../cdf:title" />
				<br />
						
				<strong>Rule ID: </strong>
				<xsl:value-of select="@id" /> 
				<br />
				<strong>Severity: </strong>
				<span class='rawSeverity'>
					<xsl:choose>
						<xsl:when test="@severity = 'high'">
							CAT I
						</xsl:when>
						<xsl:when test="@severity = 'medium'">
							CAT II
						</xsl:when>
						<xsl:when test="@severity = 'low'">
							CAT III
						</xsl:when>
					</xsl:choose>
				</span>
				<br />
				
				<strong>Rule Version (STIG-ID): </strong>
				<xsl:value-of select="./cdf:version" />
				<br />
				
				<strong>Rule Title: </strong>
				<xsl:value-of select="./cdf:title" />
				<br />
				
				<xsl:if test="string-length(substring-after(substring-before(.,'&lt;/IAControls&gt;'), '&lt;IAControls&gt;'))>0">
					<strong>IAControls: </strong>
					<xsl:value-of select="substring-after(substring-before(.,'&lt;/IAControls&gt;'),'&lt;IAControls&gt;')"/>
					<br/>
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/Documentable&gt;'), '&lt;Documentable&gt;'))>0">
					<strong>Documentable: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/Documentable&gt;'),'&lt;Documentable&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/Responsibility&gt;'), '&lt;Responsibility&gt;'))>0">
					<strong>Responsibility: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/Responsibility&gt;'),'&lt;Responsibility&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/Mitigations&gt;'), '&lt;Mitigations&gt;'))>0">
					<strong>Mitigations: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/Mitigations&gt;'),'&lt;Mitigations&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/MitigationControl&gt;'), '&lt;MitigationControl&gt;'))>0">
					<strong>Mitigation Control: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/MitigationControl&gt;'),'&lt;MitigationControl&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/SeverityOverrideGuidance&gt;'), '&lt;SeverityOverrideGuidance&gt;'))>0">
					<strong>Severity Override Guidance: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/SeverityOverrideGuidance&gt;'),'&lt;SeverityOverrideGuidance&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/PotentialImpacts&gt;'), '&lt;PotentialImpacts&gt;'))>0">
					<strong>Potential Impacts: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/PotentialImpacts&gt;'),'&lt;PotentialImpacts&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/ThirdPartyTools&gt;'), '&lt;ThirdPartyTools&gt;'))>0">
					<strong>Third Party Tools: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/ThirdPartyTools&gt;'),'&lt;ThirdPartyTools&gt;')"/>
					<br />
				</xsl:if>
				
				<strong>Vulnerability Discussion: </strong>
				<blockquote class="small">
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/VulnDiscussion&gt;'),'&lt;VulnDiscussion&gt;')" />
				</blockquote>
				
				<strong>Check Content ( <xsl:value-of select="./cdf:check/@system" /> ): </strong>
				<blockquote class="small">
				<pre><xsl:value-of select="./cdf:check/cdf:check-content" /></pre>
				</blockquote>
				
				<strong>Fix Text ( <xsl:value-of select="./cdf:fixtext/@fixref" /> ): </strong>
				<blockquote class="small">
				<pre><xsl:value-of select="./cdf:fixtext" /></pre>
				</blockquote>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/FalsePositives&gt;'), '&lt;FalsePositives&gt;'))>0">
					<strong>False Positives: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/FalsePositives&gt;'),'&lt;FalsePositives&gt;')"/>
					<br />
				</xsl:if>
				
				<xsl:if test="string-length(substring-after(substring-before(./cdf:description,'&lt;/FalseNegatives&gt;'), '&lt;FalseNegatives&gt;'))>0">
					<strong>False Negatives: </strong>
					<xsl:value-of select="substring-after(substring-before(./cdf:description,'&lt;/FalseNegatives&gt;'),'&lt;FalseNegatives&gt;')"/>
					<br />
				</xsl:if>
				
				<strong>References: </strong>
				<br />
				<blockquote class="small">
					<xsl:for-each select="./cdf:reference/*">
						<span class="text-capitalize">
							<strong>
								<xsl:value-of select="local-name()" />
							</strong>: 
						</span>
							
						<xsl:value-of select="." /><br />	
					</xsl:for-each>
				</blockquote>
				<hr />
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="cdf:Benchmark/cdf:Profile/cdf:title" mode="navbarProfileList">
		<xsl:for-each select=".">
			<xsl:variable name="selProfile" select="../@id" />
			<li><a href="#">
				<xsl:attribute name="onclick">
				$view.filters.profile('<xsl:value-of select="." />');
				</xsl:attribute>
	
				<xsl:value-of select="." />
				<span class="badge pull-right"><xsl:value-of select="count(/cdf:Benchmark/cdf:Profile[@id = $selProfile]/cdf:select)" /></span>
			</a></li>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
