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
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:daobs="http://daobs.org"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output method="text"
              encoding="UTF-8"
              include-content-type="no"
              indent="no"/>

  <!-- Define type of synonym to build
  * broader
  * acronym: short name
  * territory
  -->
  <xsl:param name="type" select="'broader'" as="xs:string"/>

  <xsl:template match="/">
{
"initArgs": {
"ignoreCase": true,
"expand": false,
"format": "solr"
},
"initializedOn": "2014-09-30T09:46:43.104Z",
"updatedSinceInit": "2014-09-30T09:47:03.147Z",
"managedMap": {
    <xsl:variable name="root" select="/"/>

    <xsl:choose>
      <xsl:when test="$type = 'synonym'">
        <xsl:for-each select="//skos:Concept[skos:prefLabel and skos:altLabel]">
          <xsl:value-of select="concat('&quot;', replace(replace(normalize-space(skos:altLabel), '\\', '\\'), '&quot;', '\\&quot;'), '&quot;:',
                                       ' [&quot;', normalize-space(skos:prefLabel), '&quot;]'
                                       )"/><xsl:if test="position() != last()">,</xsl:if>
<xsl:text>
</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$type = 'territory'">
        <xsl:for-each select="//skos:Concept[skos:note]/(skos:prefLabel|skos:altLabel)">
          <xsl:value-of select="concat('&quot;', replace(replace(normalize-space(.), '\\', '\\'), '&quot;', '\\&quot;'), '&quot;:',
                                       ' [&quot;', normalize-space(../skos:note), '&quot;]'
                                       )"/><xsl:if test="position() != last()">,</xsl:if>
<xsl:text>
</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="//skos:Concept/skos:broader">
          <xsl:variable name="ref" select="@rdf:resource"/>
          <!--<xsl:message><xsl:value-of select="$ref"/> </xsl:message>-->
          <xsl:value-of select="concat('&quot;', replace(replace(normalize-space(../skos:prefLabel), '\\', '\\'), '&quot;', '\\&quot;'), '&quot;:',
                                       ' [&quot;', normalize-space($root//*[@rdf:about = $ref][1]/skos:prefLabel), '&quot;]'
                                       )"/><xsl:if test="position() != last()">,</xsl:if>
<xsl:text>
</xsl:text>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  }
}
  </xsl:template>
</xsl:stylesheet>
