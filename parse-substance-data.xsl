<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:zeento="http://zeento.cloud">
    <!--
    Pesticide Properties DataBase Markup converter

    To use, run first html2xml.dll on markup files collected to convert them into transformable format

    @version 2019-07-05
    @author Skitsanos
    -->
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="/">
        <substance>
            <meta>
                <description>
                    <xsl:value-of select="//head/meta[@name='description']/@content"/>
                </description>
            </meta>

            <xsl:call-template name="details"/>
            <xsl:call-template name="regulationDetails"/>
            <xsl:call-template name="approvedUse"/>
            <xsl:call-template name="chemistry"/>
            <xsl:call-template name="generalData"/>
            <xsl:call-template name="health"/>
        </substance>

    </xsl:template>

    <xsl:template name="details">
        <details>
            <xsl:attribute name="name" select="//div[@id='maincontent']//table[1]/tr[1]/td[2]/font/text()"/>

            <xsl:attribute name="description"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Description:')]])"/>

            <xsl:attribute name="examplePestsControlled"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Example pests controlled:')]])"/>

            <xsl:attribute name="exampleApplications"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Example applications:')]])"/>

            <xsl:attribute name="availabilityStatus"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Availability status:')]])"/>

            <xsl:attribute name="introductionKeyDates"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Introduction &amp; key dates:')]])"/>

            <aliases>
                <xsl:variable name="aliases"
                              select="//div[@id='maincontent']//table[1]/tr[1]/td[2]/node()/font/text()"/>
                <xsl:analyze-string select="." regex="\*\s(.+?)\s\*">
                    <xsl:matching-substring>
                        <alias>
                            <xsl:value-of select="normalize-space(regex-group(1))"/>
                        </alias>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </aliases>

            <xsl:call-template name="summary"/>
        </details>
    </xsl:template>

    <xsl:template name="summary">
        <xsl:variable name="summaryText" select="//font[preceding::font[1][contains(.,'SUMMARY')]]/text()"/>
        <xsl:if test="$summaryText">
            <summary>
                <xsl:value-of select="normalize-space($summaryText)"/>
            </summary>
        </xsl:if>
    </xsl:template>

    <xsl:template name="regulationDetails">
        <requlation>
            <xsl:variable name="tableRegulation"
                          select="//div[@id='maincontent']//table[preceding::font[1][contains(.,'EC Regulation')]]"/>

            <xsl:attribute name="status"
                           select="normalize-space($tableRegulation/tr/td[2][preceding::td[1][contains(.,'Status')]])"/>
            <xsl:attribute name="rapporteur"
                           select="normalize-space($tableRegulation/tr/td[2][preceding::td[1][contains(.,'Dossier rapporteur')]])"/>
            <xsl:attribute name="inclusionExpiresOn"
                           select="normalize-space($tableRegulation/tr/td[2][preceding::td[1][contains(.,'Date inclusion expires')]])"/>
            <xsl:attribute name="cfs"
                           select="normalize-space($tableRegulation/tr/td[2][preceding::td[1][contains(.,'U Candidate for substitution (CfS)')]])"/>
            <xsl:attribute name="euListed"
                           select="normalize-space($tableRegulation/tr/td[2][preceding::td[1][contains(.,'Listed in EU database')]])"/>

        </requlation>
    </xsl:template>

    <xsl:template name="approvedUse">
        <approvedIn>
            <xsl:variable name="tableApproved"
                          select="//div[@id='maincontent']//table[preceding::font[1][contains(.,'Approved for use')]]"/>
            <xsl:for-each select="$tableApproved/tr[1]/td">
                <xsl:variable name="currentPosition" select="position()"/>
                <xsl:element name="country">
                    <xsl:attribute name="code" select="normalize-space(.)"/>
                    <xsl:variable name="approvedResult">
                        <xsl:choose>
                            <xsl:when
                                    test="$tableApproved/tr[2]/td[position()=$currentPosition]//img[1][contains(@src,'tick.jpg')]">
                                y
                            </xsl:when>
                            <xsl:when
                                    test="$tableApproved/tr[2]/td[position()=$currentPosition]//img[1][contains(@src,'tick2.jpg')]">
                                -
                            </xsl:when>
                            <xsl:when
                                    test="$tableApproved/tr[2]/td[position()=$currentPosition]//img[1][contains(@src,'hashw.jpg')]">
                                #
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="approved" select="normalize-space($approvedResult)"/>
                </xsl:element>

            </xsl:for-each>
        </approvedIn>
    </xsl:template>

    <xsl:template name="chemistry">
        <chemistry>
            <xsl:variable name="tableChemistry"
                          select="//div[@id='maincontent']//table[preceding::font[1][contains(.,'Chemical structure:')]]"/>

            <xsl:attribute name="isomerism"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'Isomerism')]])"/>
            <xsl:attribute name="formula"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'Chemical formula')]])"/>
            <xsl:attribute name="smilesCanonical"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'Canonical SMILES')]])"/>
            <xsl:attribute name="smilesIsometric"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'Isomeric SMILES')]])"/>
            <xsl:attribute name="inChIKey"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'International Chemical Identifier key (InChIKey)')]])"/>
            <xsl:attribute name="inChI"
                           select="normalize-space($tableChemistry/tr/td[2][preceding::td[1][contains(.,'International Chemical Identifier (InChI)')]])"/>
        </chemistry>
    </xsl:template>

    <xsl:template name="generalData">
        <general>
            <xsl:variable name="tableGeneralData"
                          select="//div[@id='maincontent']//table[preceding::font[1][contains(.,'General status:')]]"/>

            <xsl:attribute name="pesticideType"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Pesticide type')]])"/>
            <xsl:attribute name="substanceGroup"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Substance group')]])"/>
            <xsl:attribute name="masp"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Minimum active substance purity')]])"/>
            <xsl:attribute name="knownImpurities"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Known relevant impurities')]])"/>
            <xsl:attribute name="substanceOrigin"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Substance origin')]])"/>
            <xsl:attribute name="moa"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Mode of action')]])"/>
            <xsl:attribute name="casNumber"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'CAS RN') and not(contains(.,'/old CAS RN'))]])"/>
            <xsl:attribute name="casName"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'CAS name')]])"/>
            <xsl:attribute name="iupacName"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'IUPAC name')]])"/>
            <xsl:attribute name="ecn"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'EC number')]])"/>
            <xsl:attribute name="cipacn"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'CIPAC number')]])"/>
            <xsl:attribute name="usEpaCode"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'US EPA chemical code')]])"/>
            <xsl:attribute name="pubChem"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'PubChem CID')]])"/>
            <xsl:attribute name="mass"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Molecular mass')]])"/>
            <xsl:attribute name="physicalState"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Physical state')]])"/>
            <xsl:attribute name="otherStatus"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Other status information')]])"/>
            <xsl:attribute name="envWQS"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Relevant Environmental Water Quality Standards')]])"/>
            <xsl:attribute name="hrac"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Herbicide Resistance Classification (HRAC)')]])"/>
            <xsl:attribute name="wssa"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Herbicide Resistance Classification (WSSA)')]])"/>
            <xsl:attribute name="irac"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Insecticide Resistance Classification (IRAC)')]])"/>
            <xsl:attribute name="frac"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Fungicide Resistance Classification (FRAC)')]])"/>
            <xsl:attribute name="recordedResistance"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Examples of recorded resistance')]])"/>
            <xsl:attribute name="relatedSubstances"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'Related substances &amp; organisms')]])"/>
        </general>
    </xsl:template>

    <xsl:template name="health">
        <xsl:variable name="tableHealthIssues"
                      select="//div[@id='maincontent']//table[preceding::font[1][contains(.,'Health issues:')]]"/>

        <healthIssues>
            <xsl:attribute name="carcinogen"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[1]//img/@src))"/>
            <xsl:attribute name="genotoxic"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[2]))"/>
            <xsl:attribute name="endocrineDisruptor"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[3]//img/@src))"/>
            <xsl:attribute name="reproductionEffects"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[4]//img/@src))"/>
            <xsl:attribute name="ci"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[5]//img/@src))"/>
            <xsl:attribute name="neurotoxicant"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[2]/td[6]//img/@src))"/>
            <xsl:attribute name="respiratoryIrritant"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[4]/td[1]//img/@src))"/>
            <xsl:attribute name="skinIrritant"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[4]/td[2]//img/@src))"/>
            <xsl:attribute name="skinSensitiser"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[4]/td[3]//img/@src))"/>
            <xsl:attribute name="eyeIrritant"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[4]/td[4]//img/@src))"/>
            <xsl:attribute name="phototoxicant"
                           select="normalize-space(zeento:extractIssueData($tableHealthIssues/tr[4]/td[5]//img/@src))"/>
            <xsl:attribute name="notes"
                           select="normalize-space(zeento:extractText($tableHealthIssues/tr[5]/td[2]))"/>
            <!-- <notes>
                 <xsl:copy-of select="zeento:extractText($tableHealthIssues/tr[5]/td[2])"/>
             </notes>-->
        </healthIssues>
    </xsl:template>

    <xsl:function name="zeento:extractIssueData">
        <xsl:param name="el"/>
        <xsl:choose>
            <xsl:when test="contains($el,'question.jpg')">?</xsl:when>
            <xsl:when test="contains($el,'cross.jpg')">x</xsl:when>
            <xsl:when test="contains($el,'tick.jpg')">y</xsl:when>
            <xsl:when test="$el">
                <xsl:value-of select="$el"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="zeento:extractText">
        <xsl:param name="el"/>
        <xsl:variable name="temp">
            <xsl:for-each select="$el//text()">
                <xsl:element name="note">
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="string-length(normalize-space(.))&gt;0">;</xsl:if>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="$temp"/>
    </xsl:function>
</xsl:stylesheet>
