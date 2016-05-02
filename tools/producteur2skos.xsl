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

  <xsl:output method="xml"
              encoding="UTF-8"
              include-content-type="yes"
              indent="yes"/>

  <xsl:function name="daobs:strip" as="xs:string">
    <xsl:param name="text" as="xs:string"/>

    <xsl:value-of select="concat('http://registries.geocatalogue.fr/producer#',
                                  replace(normalize-unicode(replace(normalize-unicode(
                                    lower-case(normalize-space($text)),'NFKD'),'\p{Mn}',''),'NFKC')
                                    , ' ', ''))"/>
  </xsl:function>
  <xsl:template match="/">
    <rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
             xmlns:dc="http://purl.org/dc/elements/1.1/"
             xmlns:skos="http://www.w3.org/2004/02/skos/core#"
             xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <skos:ConceptScheme rdf:about="http://registries.geocatalogue.fr/producer">
        <dc:title>Contacts harmonisés</dc:title>
        <dc:description/>
        <dc:creator>
          <foaf:Organization>
            <foaf:name>BRGM</foaf:name>
          </foaf:Organization>
        </dc:creator>
        <dc:uri>http://registries.geocatalogue.fr/producer</dc:uri>
        <dc:rights/>
        <dcterms:issued>2016-04-08T12:56:00</dcterms:issued>
        <dcterms:modified>2016-04-08T12:56:00</dcterms:modified>
        <!-- Search top concepts -->
        <xsl:for-each-group select="//producteur/parent0[text() != '']" group-by=".">
          <skos:hasTopConcept rdf:resource="{daobs:strip(current-grouping-key())}"/>
        </xsl:for-each-group>
      </skos:ConceptScheme>

      <xsl:variable name="producteurs"
                    select="//producteur"/>

      <!-- Create parent 0 concepts (which are not producteur) -->
      <xsl:for-each-group select="//producteur[
                                      parent0 != '' and
                                      parent0 != labelFull]"
                          group-by="parent0">
        <skos:Concept rdf:about="{daobs:strip(current-grouping-key())}">
          <skos:prefLabel xml:lang="fr"><xsl:value-of select="current-grouping-key()"/> </skos:prefLabel>

          <!-- narrower -->
          <xsl:variable name="list">
            <xsl:for-each select="current-group()">
              <xsl:variable name="id"
                            select="if (parent1 != '') then parent1
                                    else if (parent2 != '') then parent2
                                    else labelFull"/>
              <entry><xsl:value-of select="$id"/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:narrower rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>

          <!-- No broader for top concepts -->
        </skos:Concept>
      </xsl:for-each-group>





      <!-- Create parent 1 concepts -->
      <xsl:for-each-group select="//producteur[
                                      parent1/text() != '' and
                                      parent1 != labelFull]"
                          group-by="parent1">
        <skos:Concept rdf:about="{daobs:strip(current-grouping-key())}">
          <skos:prefLabel xml:lang="fr"><xsl:value-of select="current-grouping-key()"/> </skos:prefLabel>
          <!-- narrower -->
          <xsl:variable name="list">
            <xsl:for-each select="current-group()">
              <xsl:variable name="id"
                            select="if (parent2 != '') then parent2
                                    else labelFull"/>
              <entry><xsl:value-of select="$id"/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:narrower rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>




          <xsl:variable name="list">
            <xsl:for-each select="current-group()/parent1[. != '']">
              <entry><xsl:value-of select="parent1"/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:broader rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>

        </skos:Concept>
      </xsl:for-each-group>



      <!-- Create parent 2 concepts -->
      <xsl:for-each-group select="//producteur[
                                      parent2/text() != '' and
                                      parent2 != labelFull]"
                          group-by="parent2">
        <skos:Concept rdf:about="{daobs:strip(current-grouping-key())}">
          <skos:prefLabel xml:lang="fr"><xsl:value-of select="current-grouping-key()"/> </skos:prefLabel>

          <!-- narrower -->

          <xsl:variable name="list">
            <xsl:for-each select="current-group()/labelFull">
              <entry><xsl:value-of select="."/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:narrower rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>



          <xsl:variable name="list">
            <xsl:for-each select="current-group()/parent2[. != '']">
              <entry><xsl:value-of select="parent2"/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:broader rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>
        </skos:Concept>
      </xsl:for-each-group>





      <!-- Create producteurs -->
      <xsl:for-each-group select="//producteur"
                          group-by="labelFull">
        <skos:Concept rdf:about="{daobs:strip(current-grouping-key())}">
          <skos:prefLabel xml:lang="fr"><xsl:value-of select="current-grouping-key()"/> </skos:prefLabel>


          <xsl:for-each-group select="current-group()/labelShort[. != '']" group-by=".">
            <!-- TODO: Better tag name ? -->
            <skos:acronym xml:lang="fr"><xsl:value-of select="current-grouping-key()"/></skos:acronym>
          </xsl:for-each-group>

          <xsl:for-each-group select="current-group()/labelLong[. != '']|
                                      current-group()/label[. != '']" group-by=".">
            <skos:altLabel xml:lang="fr"><xsl:value-of select="current-grouping-key()"/></skos:altLabel>
          </xsl:for-each-group>

          <!-- TODO: Note is probably not the best -->
          <xsl:for-each-group select="current-group()/territoire[. != '']" group-by=".">
            <skos:note xml:lang="fr"><xsl:value-of select="current-grouping-key()"/></skos:note>
          </xsl:for-each-group>

          <!-- No narrower. Only broader -->

          <xsl:variable name="list">
            <xsl:for-each select="current-group()">
              <xsl:variable name="id"
                            select="if (parent2 != '') then parent2
                                    else if (parent1 != '') then parent1
                                    else parent0"/>
              <entry><xsl:value-of select="$id"/></entry>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each-group select="$list" group-by="entry">
            <skos:broader rdf:resource="{daobs:strip(current-grouping-key())}"/>
          </xsl:for-each-group>
        </skos:Concept>
      </xsl:for-each-group>
    </rdf:RDF>
  </xsl:template>

</xsl:stylesheet>
