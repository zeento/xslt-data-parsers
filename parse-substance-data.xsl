<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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

            <xsl:call-template name="header"/>
            <xsl:call-template name="summary"/>
            <xsl:call-template name="regulationDetails"/>
            <xsl:call-template name="approvedUse"/>
            <xsl:call-template name="chemistry"/>
            <xsl:call-template name="generalData"/>
            <xsl:call-template name="health"/>
        </substance>

    </xsl:template>

    <xsl:template name="header">
        <details>
            <xsl:attribute name="name" select="//div[@id='maincontent']//table[1]/tr[1]/td[2]/font/text()"/>

            <xsl:attribute name="description"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Description:')]]/text())"/>

            <xsl:attribute name="examplePestsControlled"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Example pests controlled:')]]/text())"/>

            <xsl:attribute name="exampleApplications"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Example applications:')]]/text())"/>

            <xsl:attribute name="availabilityStatus"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Availability status:')]]/text())"/>

            <xsl:attribute name="introductionKeyDates"
                           select="normalize-space(//font[preceding::font[1][contains(.,'Introduction &amp; key dates:')]]/text())"/>

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
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'CAS RN')]])"/>
            <xsl:attribute name="casName"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'CAS name')]])"/>
            <xsl:attribute name="iupacName"
                           select="normalize-space($tableGeneralData/tr/td[2][preceding::td[1][contains(.,'IUPAC namee')]])"/>
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
        </general>
    </xsl:template>

    <xsl:template name="health">

    </xsl:template>

</xsl:stylesheet>
