<?xml version="1.0"?>
<!--
  ~ Copyright 2014-2016 European Environment Agency
  ~
  ~ Licensed under the EUPL, Version 1.1 or – as soon
  ~ they will be approved by the European Commission -
  ~ subsequent versions of the EUPL (the "Licence");
  ~ You may not use this work except in compliance
  ~ with the Licence.
  ~ You may obtain a copy of the Licence at:
  ~
  ~ https://joinup.ec.europa.eu/community/eupl/og_page/eupl
  ~
  ~ Unless required by applicable law or agreed to in
  ~ writing, software distributed under the Licence is
  ~ distributed on an "AS IS" basis,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
  ~ either express or implied.
  ~ See the Licence for the specific language governing
  ~ permissions and limitations under the Licence.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output method="xml"
              encoding="UTF-8"
              include-content-type="yes"
              indent="yes"/>

  <xsl:template match="/rdf:RDF">
    <xsl:copy>
      <xsl:apply-templates select="skos:ConceptScheme|skos:Concept"/>
    </xsl:copy>
  </xsl:template>

  <!-- Append broader terms by extracting narrower refs. -->
  <xsl:template match="skos:Concept">
    <xsl:variable name="id" select="@rdf:about"/>
    <xsl:copy>
      <xsl:copy-of select="@*|*"/>
      <xsl:for-each select="//skos:Concept[skos:narrower/@rdf:resource = $id]">
        <skos:broader rdf:resource="{@rdf:about}"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- Copy everything -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
