<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:controls="http://scap.nist.gov/schema/sp800-53/feed/2.0" xmlns:def="http://scap.nist.gov/schema/sp800-53/2.0">

	<xsl:template name="CamelCase">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,' ')">
				<xsl:call-template name="CamelCaseWord">
					<xsl:with-param name="text" select="substring-before($text,' ')"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="CamelCase">
					<xsl:with-param name="text" select="substring-after($text,' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="CamelCaseWord">
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="CamelCaseWord">
		<xsl:param name="text"/>
		<xsl:value-of select="translate(substring($text,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" /><xsl:value-of select="translate(substring($text,2,string-length($text)-1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
	</xsl:template>
	
	<xsl:template match="text()" name="replaceNL">
		<xsl:param name="pText" select="."/>

		<xsl:choose>
			<xsl:when test="contains($pText, '&#xA;')">
				<xsl:value-of select="substring-before($pText, '&#xA;')"/>
				<br />
				<br />
				<xsl:call-template name="replaceNL">
					<xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$pText"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!-- Find and replace on whole words only -->
	<xsl:template name="search-and-replace-whole-words-only">
		<xsl:param name="input"/>
		<xsl:param name="search-string"/>
		<xsl:param name="replace-string"/>
		<xsl:variable name="punc" 
			select="concat('.,;:( )[	]!?$@&amp;&quot;&gt;&lt;/',&quot;&apos;&quot;)"/>
			 <xsl:choose>
				 <!-- See if the input contains the search string -->
				 <xsl:when test="contains($input,$search-string)">
				 <!-- If so, then test that the before and after characters are word 
				 delimiters. -->
					 <xsl:variable name="before" 
						select="substring-before($input,$search-string)"/>
					 <xsl:variable name="before-char" 
						select="substring(concat(' ',$before),string-length($before) +1, 1)"/>
					 <xsl:variable name="after"
						select="substring-after($input,$search-string)"/>
					 <xsl:variable name="after-char" 
						select="substring($after,1,1)"/>
					 <xsl:value-of select="$before"/>
					 <xsl:choose>
						<xsl:when test="(not(normalize-space($before-char)) or 
											contains($punc,$before-char)) and 
								 (not(normalize-space($after-char)) or 
											contains($punc,$after-char))"> 
							<xsl:value-of select="$replace-string"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$search-string"/>
						</xsl:otherwise>
					 </xsl:choose>
					 <xsl:call-template name="search-and-replace-whole-words-only">
						<xsl:with-param name="input" select="$after"/>
						<xsl:with-param name="search-string" select="$search-string"/>
						<xsl:with-param name="replace-string" select="$replace-string"/>
					 </xsl:call-template>
				 </xsl:when>
			<xsl:otherwise>
				 <!-- There are no more occurrences of the search string so 
						just return the current input string -->
				 <xsl:value-of select="$input"/>
			 </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="string-replace-all">
		<xsl:param name="text"/>
		<xsl:param name="replace" select="'\, &#xA;, &quot;, &quot;,'"/>
		<xsl:param name="by" select="'|'"/>
		<xsl:param name="times" select="1"/>
		
		<xsl:choose>
			<!--Checks if $text contains the first replace string in the $replace value-->
			<xsl:when test="contains($text, substring-before($replace,','))">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="concat(substring-before($text,substring-before($replace,',')),$by,substring-after($text,substring-before($replace,',')))"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
					<xsl:with-param name="times" select="$times+1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!--Checks to see if there is any strings left to replace-->
					<xsl:when test="substring-after($replace,',') != ''">
						<xsl:choose>
							<!--Here you could call the template directly and the iteration will do the check to see if the next replace string is contained in the $text value-->
							<!--but to save some iteration loops I did the work here-->
							<xsl:when test="contains($text, substring-before(substring-after($replace,','),','))">
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text" select="concat(substring-before($text,substring-before(substring-after($replace,','),',')),$by,substring-after($text,substring-before(substring-after($replace,','),',')))"/>
									<xsl:with-param name="replace" select="substring-after($replace,',')"/>
									<xsl:with-param name="by" select="$by"/>
									<xsl:with-param name="times" select="$times+1"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text" select="$text"/>
									<xsl:with-param name="replace" select="substring-after($replace,',')"/>
									<xsl:with-param name="by" select="$by"/>
									<xsl:with-param name="times" select="$times+1"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(translate(translate(translate(translate(translate($text,'“',''),'”',''),'&#xA;',''),'&quot;',''),'&#9;',''),'&quot;','') "/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--contant-->
	<xsl:variable name="d">0123456789</xsl:variable>

	<!-- ignore document text -->
	<xsl:template match="text()[preceding-sibling::node() or following-sibling::node()]"/>

	<!-- string -->
	<xsl:template match="text()">
		<xsl:call-template name="escape-string">
			<xsl:with-param name="s" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Main template for escaping strings; used by above template and for object-properties 
	Responsibilities: placed quotes around string, and chain up to next filter, escape-bs-string -->
	<xsl:template name="escape-string">
		<xsl:param name="s"/>
		<xsl:text>"</xsl:text>
		<xsl:call-template name="escape-bs-string">
			<xsl:with-param name="s" select="$s"/>
		</xsl:call-template>
		<xsl:text>"</xsl:text>
	</xsl:template>
	
	<!-- Escape the backslash (\) before everything else. -->
	<xsl:template name="escape-bs-string">
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when test="contains($s,'\')">
				<xsl:call-template name="escape-quot-string">
					<xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/>
				</xsl:call-template>
				<xsl:call-template name="escape-bs-string">
					<xsl:with-param name="s" select="substring-after($s,'\')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="escape-quot-string">
					<xsl:with-param name="s" select="$s"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Escape the double quote ("). -->
	<xsl:template name="escape-quot-string">
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when test="contains($s,'&quot;')">
				<xsl:call-template name="encode-string">
					<xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/>
				</xsl:call-template>
				<xsl:call-template name="escape-quot-string">
					<xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="encode-string">
					<xsl:with-param name="s" select="$s"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Replace tab, line feed and/or carriage return by its matching escape code. Can't escape backslash
			 or double quote here, because they don't replace characters (&#x0; becomes \t), but they prefix 
			 characters (\ becomes \\). Besides, backslash should be seperate anyway, because it should be 
			 processed first. This function can't do that. -->
	<xsl:template name="encode-string">
		<xsl:param name="s"/>
		<xsl:choose>
			<!-- tab -->
			<xsl:when test="contains($s,'&#x9;')">
				<xsl:call-template name="encode-string">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#x9;'),'\t',substring-after($s,'&#x9;'))"/>
				</xsl:call-template>
			</xsl:when>
			<!-- line feed -->
			<xsl:when test="contains($s,'&#xA;')">
				<xsl:call-template name="encode-string">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#xA;'),'\n',substring-after($s,'&#xA;'))"/>
				</xsl:call-template>
			</xsl:when>
			<!-- carriage return -->
			<xsl:when test="contains($s,'&#xD;')">
				<xsl:call-template name="encode-string">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#xD;'),'\r',substring-after($s,'&#xD;'))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- number (no support for javascript mantissa) -->
	<xsl:template match="text()[not(string(number())='NaN' or (starts-with(.,'0' ) and . != '0'))]">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- boolean, case-insensitive -->
	<xsl:template match="text()[translate(.,'TRUE','true')='true']">true</xsl:template>
	<xsl:template match="text()[translate(.,'FALSE','false')='false']">false</xsl:template>

	<!-- object -->
	<xsl:template match="*" name="base">
		<xsl:if test="not(preceding-sibling::*)">{</xsl:if>
		<xsl:call-template name="escape-string">
			<xsl:with-param name="s" select="name()"/>
		</xsl:call-template>
		<xsl:text>:</xsl:text>
		<!-- check type of node -->
		<xsl:choose>
			<!-- null nodes -->
			<xsl:when test="count(child::node())=0">null</xsl:when>
			<!-- other nodes -->
			<xsl:otherwise>
				<xsl:apply-templates select="child::node()"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- end of type check -->
		<xsl:if test="following-sibling::*">,</xsl:if>
		<xsl:if test="not(following-sibling::*)">}</xsl:if>
	</xsl:template>

	<!-- array -->
	<xsl:template match="*[count(../*[name(../*)=name(.)])=count(../*) and count(../*)&gt;1]">
		<xsl:if test="not(preceding-sibling::*)">[</xsl:if>
		<xsl:choose>
			<xsl:when test="not(child::node())">
				<xsl:text>null</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="child::node()"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::*">,</xsl:if>
		<xsl:if test="not(following-sibling::*)">]</xsl:if>
	</xsl:template>
	
	<!-- convert root element to an anonymous container -->
	<xsl:template match="/">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	<xsl:template match="item" mode="stig-menu" >
		<xsl:param name="selectedStig"/>
		
		<option>
			<xsl:attribute name="value">
				<xsl:value-of select="@file-ref" />
			</xsl:attribute>
			
			<xsl:if test="@stig-title = $selectedStig">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="text()" />
		</option>
	</xsl:template>
	
	<xsl:template name="dodImage">
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='stigLogo']"/>
	</xsl:template>

	<xsl:template name="lib_Css">
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='lib_Css']"/>
	</xsl:template>

	<xsl:template name="lib_Js">
		<xsl:copy-of select="document('includes.xml')/includes/ref[@id='lib_Js']"/>
	</xsl:template>
	
</xsl:stylesheet>