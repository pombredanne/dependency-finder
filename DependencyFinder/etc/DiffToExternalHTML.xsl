<?xml version="1.0"?> 

<!--
  --  Dependency Finder - Comparing API differences between JAR files
  --  Copyright (C) 2001  Jean Tessier
  --  
  --  This library is free software; you can redistribute it and/or
  --  modify it under the terms of the GNU Lesser General Public
  --  License as published by the Free Software Foundation; either
  --  version 2.1 of the License, or (at your option) any later version.
  --  
  --  This library is distributed in the hope that it will be useful,
  --  but WITHOUT ANY WARRANTY; without even the implied warranty of
  --  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  --  Lesser General Public License for more details.
  --  
  --  You should have received a copy of the GNU Lesser General Public
  --  License along with this library; if not, write to the Free Software
  --  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  -->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:validator="xalan://com.jeantessier.diff.PackageValidator"
    exclude-result-prefixes="validator">

    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/> 

    <xsl:param name="validation-list">public_packages.txt</xsl:param>
    <xsl:variable name="validator" select="validator:new($validation-list)"/>

    <xsl:template match="differences">
	<html>

	<head>
	    <title>Public API Change History - Version <xsl:value-of select="old"/> to Version <xsl:value-of select="new"/></title>
	</head>

	<body bgcolor="#ffffff">

	<h1>Public API Change History - Version <xsl:value-of select="old"/> to Version <xsl:value-of select="new"/></h1>

	<xsl:apply-templates/>

	</body>

	</html>
    </xsl:template>

    <xsl:template match="old | new"></xsl:template>

    <xsl:template match="removed-packages[name[validator:IsPackageAllowed($validator,text())]]">
	<h2>Removed Packages:</h2>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>

    <xsl:template match="removed-packages"></xsl:template>
 
    <xsl:template match="removed-interfaces[name[validator:IsClassAllowed($validator,text())]]">
	<h2>Removed Interfaces:</h2>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="removed-interfaces"></xsl:template>
 
    <xsl:template match="removed-classes[name[validator:IsClassAllowed($validator,text())]]">
	<h2>Removed Classes:</h2>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="removed-classes"></xsl:template>
 
    <xsl:template match="deprecated-interfaces[name[validator:IsClassAllowed($validator,text())]]">
	<h2>Newly Deprecated Interfaces:</h2>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="deprecated-interfaces"></xsl:template>
 
    <xsl:template match="deprecated-classes[name[validator:IsClassAllowed($validator,text())]]">
	<h2>Newly Deprecated Classes:</h2>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="deprecated-classes"></xsl:template>
 
    <xsl:template match="modified-interfaces">
	<h2>Modified Interfaces:</h2>
	<blockquote>
	    <xsl:apply-templates/>
	</blockquote>
   </xsl:template>
 
    <xsl:template match="modified-classes">
	<h2>Modified Classes:</h2>
	<blockquote>
	    <xsl:apply-templates/>
	</blockquote>
    </xsl:template>

    <xsl:template match="undeprecated-interfaces"></xsl:template>
    <xsl:template match="undeprecated-classes"></xsl:template>
 
    <xsl:template match="new-packages"></xsl:template>
    <xsl:template match="new-interfaces"></xsl:template>
    <xsl:template match="new-classes"></xsl:template>
 
    <xsl:template match="class[@visibility='public' and validator:IsClassAllowed($validator,name) and
			       (modified-declaration[(old-declaration/@visibility='public' and new-declaration/@visibility='package') or
			                             (not(old-declaration/@abstract) and new-declaration/@abstract) or
			                             (not(old-declaration/@final) and new-declaration/@final) or
			                             (old-declaration/@extends!=new-declaration/@extends) or
			                             (old-declaration/@implements!=new-declaration/@implements)] or
			        removed-fields/declaration[@visibility='public' or @visibility='protected'] or
			        removed-constructors/declaration[@visibility='public' or @visibility='protected'] or
			        removed-methods/declaration[@visibility='public' or @visibility='protected'] or
			        deprecated-fields/declaration[@visibility='public' or @visibility='protected'] or
			        deprecated-constructors/declaration[@visibility='public' or @visibility='protected'] or
			        deprecated-methods/declaration[@visibility='public' or @visibility='protected'] or
			        .//feature[(@visibility='public' or @visibility='protected') and
					   modified-declaration[(old-declaration/@visibility='public' and
								    (new-declaration/@visibility='private' or
								     new-declaration/@visibility='package' or
								     new-declaration/@visibility='protected')) or
								(old-declaration/@visibility='protected' and
							 	    (new-declaration/@visibility='package' or
								     new-declaration/@visibility='private')) or
								(not(old-declaration/@abstract) and new-declaration/@abstract) or
								(not(old-declaration/@static) and new-declaration/@static) or
								(not(old-declaration/@final) and new-declaration/@final) or
								(old-declaration/@type!=new-declaration/@type) or
								(old-declaration/@return-type!=new-declaration/@return-type) or
								(old-declaration/@throws!=new-declaration/@throws)]])]">
	<h3><code><xsl:value-of select="name"/></code></h3>
	<blockquote>
	    <xsl:if test="modified-declaration[(old-declaration/@visibility='public' and new-declaration/@visibility='package') or
					       (not(old-declaration/@abstract) and new-declaration/@abstract) or
					       (not(old-declaration/@final) and new-declaration/@final) or
					       (old-declaration/@extends!=new-declaration/@extends) or
					       (old-declaration/@implements!=new-declaration/@implements)]">
		<h4>Declaration Changes:</h4>
	    </xsl:if>
	    <xsl:apply-templates/>
	</blockquote>
    </xsl:template>

    <xsl:template match="class"></xsl:template>

    <xsl:template match="removed-fields[declaration[(@visibility='public' or @visibility='protected') and not(@inherited)]]">
	<h4>Removed Fields:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="removed-constructors[declaration[(@visibility='public' or @visibility='protected') and not(@inherited)]]">
	<h4>Removed Constructors:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="removed-methods[declaration[(@visibility='public' or @visibility='protected') and not(@inherited)]]">
	<h4>Removed Methods:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="deprecated-fields[declaration[@visibility='public' or @visibility='protected']]">
	<h4>Newly Deprecated Fields:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="deprecated-constructors[declaration[@visibility='public' or @visibility='protected']]">
	<h4>Newly Deprecated Constructors:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="deprecated-methods[declaration[@visibility='public' or @visibility='protected']]">
	<h4>Newly Deprecated Methods:</h4>
	<ul>
	    <xsl:apply-templates/>
	</ul>
    </xsl:template>
 
    <xsl:template match="modified-fields[feature[(@visibility='public' or @visibility='protected') and
						 modified-declaration[(old-declaration/@visibility='public' and
									  (new-declaration/@visibility='private' or
									   new-declaration/@visibility='package' or
									   new-declaration/@visibility='protected')) or
								      (old-declaration/@visibility='protected' and
									  (new-declaration/@visibility='package' or
									   new-declaration/@visibility='private')) or
								      (not(old-declaration/@static) and new-declaration/@static=) or
								      (not(old-declaration/@final) and new-declaration/@final) or
								      (old-declaration/@type!=new-declaration/@type)]]]">
	<h4>Field Declaration Changes:</h4>
	<xsl:apply-templates/>
    </xsl:template>
 
    <xsl:template match="modified-constructors[feature[(@visibility='public' or @visibility='protected') and
						       modified-declaration[(old-declaration/@visibility='public' and
										(new-declaration/@visibility='private' or
										 new-declaration/@visibility='package' or
										 new-declaration/@visibility='protected')) or
									    (old-declaration/@visibility='protected' and
										(new-declaration/@visibility='package' or
										 new-declaration/@visibility='private')) or
					 				    (not(old-declaration/@abstract) and new-declaration/@abstract) or
									    (not(old-declaration/@static) and new-declaration/@static) or
									    (not(old-declaration/@final) and new-declaration/@final) or
									    (old-declaration/@return-type!=new-declaration/@return-type) or
									    (old-declaration/@throws!=new-declaration/@throws)]]]">
	<h4>Constructor Declaration Changes:</h4>
	<xsl:apply-templates/>
    </xsl:template>
 
    <xsl:template match="modified-methods[feature[(@visibility='public' or @visibility='protected') and
						  modified-declaration[(old-declaration/@visibility='public' and
									   (new-declaration/@visibility='private' or
									    new-declaration/@visibility='package' or
									    new-declaration/@visibility='protected')) or
								       (old-declaration/@visibility='protected' and
									   (new-declaration/@visibility='package' or
									    new-declaration/@visibility='private')) or
					 			       (not(old-declaration/@abstract) and new-declaration/@abstract) or
								       (not(old-declaration/@static) and new-declaration/@static) or
								       (not(old-declaration/@final) and new-declaration/@final) or
								       (old-declaration/@return-type!=new-declaration/@return-type) or
								       (old-declaration/@throws!=new-declaration/@throws)]]]">
	<h4>Method Declaration Changes:</h4>
	<xsl:apply-templates/>
    </xsl:template>
 
    <xsl:template match="undeprecated-fields"></xsl:template>
    <xsl:template match="undeprecated-constructors"></xsl:template>
    <xsl:template match="undeprecated-methods"></xsl:template>
 
    <xsl:template match="new-fields"></xsl:template>
    <xsl:template match="new-constructors"></xsl:template>
    <xsl:template match="new-methods"></xsl:template>
 
    <xsl:template match="class/name | feature/name"></xsl:template>

    <xsl:template match="feature[@visibility='public' or @visibility='protected']">
	<xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="feature"></xsl:template>

    <xsl:template match="modified-declaration[(old-declaration/@visibility='public' and
						  (new-declaration/@visibility='private' or
						   new-declaration/@visibility='package' or
						   new-declaration/@visibility='protected')) or
					      (old-declaration/@visibility='protected' and
						  (new-declaration/@visibility='package' or
						   new-declaration/@visibility='private')) or
					      (not(old-declaration/@abstract) and new-declaration/@abstract) or
					      (not(old-declaration/@static) and new-declaration/@static) or
					      (not(old-declaration/@final) and new-declaration/@final) or
					      (old-declaration/@extends!=new-declaration/@extends) or
					      (old-declaration/@implements!=new-declaration/@implements) or
					      (old-declaration/@type!=new-declaration/@type) or
					      (old-declaration/@return-type!=new-declaration/@return-type) or
					      (old-declaration/@throws!=new-declaration/@throws)]">
	<blockquote>
	<p><nobr><code>
	<b>old:</b> <xsl:value-of select="old-declaration"/>
	<xsl:if test="old-declaration[@deprecated='yes']"> <b>[deprecated]</b></xsl:if>
	<br/>
	<b>new:</b> <xsl:value-of select="new-declaration"/>
	<xsl:if test="self::node()[@deprecated='yes']"> <b>[deprecated]</b></xsl:if>
	</code></nobr></p>
	</blockquote>
    </xsl:template>

    <xsl:template match="modified-declaration"></xsl:template>

    <xsl:template match="name[@visibility='package' or @visibility='private'] | declaration[@visibility='package' or @visibility='private']"></xsl:template>

    <xsl:template match="removed-packages/name[validator:IsPackageAllowed($validator,text())]">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="removed-interfaces/name[validator:IsClassAllowed($validator,text())]">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="removed-classes/name[validator:IsClassAllowed($validator,text())]">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="deprecated-interfaces/name[validator:IsClassAllowed($validator,text())]">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="deprecated-classes/name[validator:IsClassAllowed($validator,text())]">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="declaration">
	<li><nobr><code><xsl:value-of select="."/></code></nobr></li>
    </xsl:template>

    <xsl:template match="declaration[@inherited]"></xsl:template>

    <xsl:template match="name"></xsl:template>

</xsl:stylesheet>

