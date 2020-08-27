<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:output method="xml" encoding="iso-8859-1"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd";
  doctype-pubilc="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
-->
<xsl:output method="xml"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    omit-xml-declaration="yes"
    encoding="UTF-8"
    indent="yes" /><!--<xsl:param name="param1" />-->

<xsl:template name="FormTree">
  <xsl:param name="FormsetPath"/>
  <xsl:param name="FormId"/>
  <xsl:param name="TreeLevel"/>

  <xsl:choose>
    <xsl:when test="$FormsetPath/Form[@fid=$FormId]">
    <li>
      <xsl:choose>
        <xsl:when test="count($FormsetPath/Form[@fid=$FormId]/Ref[not(@exp) or @exp!='sif true']) > 0">

<!--
        <xsl:attribute name="exp"><xsl:value-of select="$FormsetPath/Form[@fid=$FormId]/Ref/@exp"/></xsl:attribute>
-->
        <input type="checkbox">
          <xsl:attribute name="id"><xsl:value-of select="$FormId"/></xsl:attribute>
        </input>
        <label>
          <xsl:attribute name="for"><xsl:value-of select="$FormId"/></xsl:attribute>
          <xsl:value-of select="$FormsetPath/Form[@fid=$FormId]/Subtitle/Pmt"/>
        </label>

        <ul class="SubMenu">
          <xsl:attribute name="class">SubMenu MenuLevel<xsl:value-of select="$TreeLevel"/></xsl:attribute>
          <xsl:for-each select="$FormsetPath/Form[@fid=$FormId]/Ref[not(@exp) or @exp!='sif true']">
            <xsl:call-template name="FormTree">
              <xsl:with-param name="FormsetPath" select="$FormsetPath"/>
              <xsl:with-param name="FormId" select="current()/@fid"/>
              <xsl:with-param name="TreeLevel" select="$TreeLevel + 1"/>
            </xsl:call-template>
          </xsl:for-each>
        </ul>
        </xsl:when>

        <xsl:otherwise>
        <a href="#">
          <xsl:attribute name="id">
            <xsl:value-of select="$FormId"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$FormsetPath/Form[@fid=$FormId]/Subtitle/Pmt != ''">
              <xsl:value-of select="$FormsetPath/Form[@fid=$FormId]/Subtitle/Pmt"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:value-of select="$FormsetPath/Form[@fid=$FormId]/@name"/>
            </xsl:otherwise>

          </xsl:choose>
        </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<xsl:template name="FormMenu">
  <xsl:param name="FormsetPath"/> <!-- formset path -->

  <xsl:choose>
    <xsl:when test="$FormsetPath">
    <li>
      <xsl:choose>
        <xsl:when test="count($FormsetPath/Form[1]/Ref) > 0">
        <input type="checkbox">
          <xsl:attribute name="id"><xsl:value-of select="$FormsetPath/Form[1]/@name"/></xsl:attribute>
        </input>
        <label>
          <xsl:attribute name="for"><xsl:value-of select="$FormsetPath/Form[1]/@name"/></xsl:attribute>
          <xsl:value-of select="$FormsetPath/Form[1]/@name"/>
        </label>

        <ul class="SubMenu">
          <xsl:for-each select="$FormsetPath/Form[1]/Ref[not(@exp) or @exp!='sif true']">
            <xsl:call-template name="FormTree">
              <xsl:with-param name="FormsetPath" select="$FormsetPath"/>
              <xsl:with-param name="FormId" select="current()/@fid"/>
              <xsl:with-param name="TreeLevel" select="1"/>
            </xsl:call-template>
          </xsl:for-each>
        </ul>
        </xsl:when>

        <xsl:otherwise>
        <a href="#">
          <xsl:attribute name="id"><xsl:value-of select="$FormsetPath/Form[1]/@name"/></xsl:attribute>
          <xsl:value-of select="$FormsetPath/Form[1]/@name"/>
        </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
    </xsl:when>
  </xsl:choose>

</xsl:template>


<xsl:template name="GenFormInfo">
  <xsl:param name="FormName"/> <!-- form name -->

  <xsl:for-each select="/Root/Formset/Form[@name=$FormName]/*">
<!--
    <xsl:if test="current()[name()='Ref' and @exp='']">
    <div class="Row TxtRow">
      <span class="ToPopupTitle">
        <xsl:attribute name="fid">
          <xsl:value-of select="@fid"/>
        </xsl:attribute>
        <xsl:value-of select="current()/Pmt"/>
      </span>
    </div>
    </xsl:if>
-->
    <xsl:variable name="SelectedFormSet" select="../../@name" />
    <xsl:variable name="SelectedFormId" select="../@fid" />

    <xsl:choose>
      <xsl:when test="current()[name()='Subtitle']">
        <xsl:choose>
          <xsl:when test="Pmt != '' and Pmt != ' ' and position() != 1">
          <div class="Row TxtRow">
            <xsl:attribute name="exp">
              <xsl:value-of select="@exp"/>
            </xsl:attribute>
            <xsl:attribute name="rid">
              <xsl:value-of select="@rid"/>
            </xsl:attribute>

            <div class="OneLineField"><xsl:value-of select="Pmt"/></div>
          </div>
          </xsl:when>

          <xsl:when test="position() != 1 and position() != 2">
          <div class="Row TxtRow">
            <xsl:attribute name="exp">
              <xsl:value-of select="@exp"/>
            </xsl:attribute>
            <xsl:attribute name="rid">
              <xsl:value-of select="@rid"/>
            </xsl:attribute>
          </div>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="current()[name()='Txt']">
        <xsl:choose>
          <xsl:when test="Pmt != '' and Pmt != ' '">
          <div class="Row TxtRow">
            <xsl:attribute name="exp">
              <xsl:value-of select="@exp"/>
            </xsl:attribute>
            <xsl:attribute name="rid">
              <xsl:value-of select="@rid"/>
            </xsl:attribute>
            <span class="TitleField"><xsl:value-of select="Pmt"/></span>
            <span class="ContentField"><xsl:value-of select="Cont"/></span>
          </div>
          </xsl:when>

          <xsl:when test="(Pmt = '' or Pmt = ' ') and position() != 1">
          <div class="Row TxtRow">
            &#160;
          </div>
          </xsl:when>
        </xsl:choose>
      </xsl:when><!-- Txt -->

      <xsl:when test="current()[name()='Ref' and Pmt!='' and Pmt!=' ']">
      <div class="Row TxtRow">
        <xsl:attribute name="exp">
          <xsl:value-of select="@exp"/>
        </xsl:attribute>
        <xsl:attribute name="rid">
          <xsl:value-of select="@rid"/>
        </xsl:attribute>

        <span class="TriangleImage">
          <img src="Images/Triangle.png" height="16" />
        </span>
        <a class="ToPopupTitle" href="#">
          <xsl:attribute name="id">Ref<xsl:value-of select="@fid"/></xsl:attribute>
          <xsl:attribute name="fid">
            <xsl:value-of select="@fid"/>
          </xsl:attribute>
          <xsl:value-of select="current()/Pmt"/>
        </a>
      </div>
      </xsl:when><!-- Ref -->

      <xsl:when test="current()[name()='Numeric']">
      <div class="Row InputRow">
        <xsl:attribute name="exp">
          <xsl:value-of select="@exp"/>
        </xsl:attribute>
        <xsl:attribute name="rid">
          <xsl:value-of select="@rid"/>
        </xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
        <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
        <xsl:if test="current()[Pmt='' or Pmt=' ']">
          <xsl:attribute name="style">display: none</xsl:attribute>
        </xsl:if>

        <span class="TitleField OneOfNumericColor"><xsl:value-of select="Pmt"/></span>
        <span class="ContentField">
          <!--
            Numeric init code is 1
            Type-CallbackId-Offset-Width=Value
               1-CallbackId-Offset-Width=Value
          -->
          <input type="text">
            <xsl:attribute name="id">Numeric-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="name">1-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
            <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
            <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
            <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
            <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
            <xsl:attribute name="step"><xsl:value-of select="@step"/></xsl:attribute>
            <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
            <xsl:attribute name="size">8</xsl:attribute>
            <xsl:attribute name="maxlength">6</xsl:attribute>
<!--
            <xsl:attribute name="size"><xsl:value-of select="@max"/></xsl:attribute>
            <xsl:attribute name="maxlength"><xsl:value-of select="@max"/></xsl:attribute>
-->
<!--
            <xsl:attribute name="disabled">true</xsl:attribute>
-->
          </input>
        </span>

        <span class="HelpField" style="display: none">
          <xsl:value-of select="Help"/>
        </span>
      </div><!-- Row -->
      </xsl:when><!-- Numeric -->

      <xsl:when test="current()[name()='Oneof']">
      <div class="Row InputRow">
        <xsl:attribute name="exp">
          <xsl:value-of select="@exp"/>
        </xsl:attribute>
        <xsl:attribute name="rid">
          <xsl:value-of select="@rid"/>
        </xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
        <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
        <xsl:if test="current()[@name='' or @name=' ']">
          <xsl:attribute name="style">display: none</xsl:attribute>
        </xsl:if>

        <span class="TitleField OneOfNumericColor">
          <xsl:value-of select="@name"/>
        </span>
        <span class="ContentField">
          <!--
            Oneof init code is 0
            Type-CallbackId-Offset-Width=Value
               0-CallbackId-Offset-Width=Value
          -->
          <select>
            <xsl:attribute name="id">OneOf-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="name">0-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
            <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
            <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
<!--
            <xsl:attribute name="disabled">true</xsl:attribute>
-->
            <xsl:if test="@cid">
              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="SelectedVal" select="@crt" />

            <xsl:for-each select="Option">
            <option>
              <xsl:attribute name="id"><xsl:value-of select="@val"/></xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
              <xsl:if test="$SelectedVal=@val">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="."/>
            </option>
            </xsl:for-each>
          </select>
        </span>
        <div class="ClearBoth"></div>

        <span class="HelpField" style="display: none">
          <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
          <div class="HelpPopMsg">&#160;</div>
        </span>
      </div><!-- Row -->
      </xsl:when><!-- Oneof -->
    </xsl:choose>
  </xsl:for-each>

  <xsl:if test="$FormName='Boot'">
    <!-- Boot order -->
    <xsl:if test="Formset[@name='BootOrder']">
    <div id="BootOrderTable">
      <div id="BootOrderLoading">Loading Boot Devices ...<img src="Images/loading.gif" height="24" width="24" /></div>
      <div id="BootOrderContent" style="display: none">
        <span class="SectionTitle">Boot Order List</span>
        <xsl:for-each select="Formset[@name='BootOrder']/Form/*">
          <xsl:variable name="SelectedFormSet" select="../../@name" />
          <xsl:variable name="SelectedFormId" select="../@fid" />
          <span class="BootDeviceRow">
            <xsl:attribute name="idx">
              <xsl:value-of select="@order"/>
            </xsl:attribute>
            <span class="TitleField OneOfNumericColor"><xsl:value-of select="current()"/></span>
            <span class="ContentField">
              <!--
                Boot Order init code is 3
                Type-CallbackId-Offset-Width=Value
                   3-0-0-Index=Order
              -->
              <input class="BootOrder" type="hidden">
                <xsl:attribute name="id">BootDev-0-0-<xsl:value-of select="@idx"/></xsl:attribute>
                <xsl:attribute name="name">3-0-0-<xsl:value-of select="@idx"/></xsl:attribute>
                <xsl:attribute name="order"><xsl:value-of select="@order"/></xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="@order"/></xsl:attribute>
              </input>
              <span class="BootOrderUp BootOrderControl">
                <img src="Images/UpPic.png" height="18">
                <xsl:attribute name="id">BootBtnUp<xsl:value-of select="@idx"/></xsl:attribute>
                </img>
              </span>
              <span class="BootOrderDown BootOrderControl">
                <img src="Images/DownPic.png" height="18">
                <xsl:attribute name="id">BootBtnDown<xsl:value-of select="@idx"/></xsl:attribute>
                </img>
              </span>
              <span class="ClearBoth"></span>
            </span><!-- ContentField -->
            <div class="ClearBoth"></div>
          </span><!-- BootDeviceRow -->
          <div class="ClearBoth"></div>
        </xsl:for-each>
      </div>
      <br />
    </div><!-- BootOrderTable -->
    </xsl:if>

    <!-- Boot type order -->
    <xsl:if test="Formset[@name='BootTypeOrder']">
    <div id="BootTypeOrderTable">
      <div id="BootTypeOrderLoading">Loading Boot Types ...<img src="Images/loading.gif" height="24" width="24" /></div>
      <div id="BootTypeOrderContent" style="display: none">
        <span class="SectionTitle">Boot Type List</span>
        <xsl:for-each select="Formset[@name='BootTypeOrder']/Form/*">
          <xsl:variable name="SelectedFormSet" select="../../@name" />
          <xsl:variable name="SelectedFormId" select="../@fid" />
          <span class="BootDeviceRow">
            <xsl:attribute name="idx">
              <xsl:value-of select="@order"/>
            </xsl:attribute>
            <span class="TitleField OneOfNumericColor"><xsl:value-of select="current()"/></span>
            <span class="ContentField">
              <!--
                Boot Type Order init code is 4
                Type-CallbackId-Offset-Width=Value
                   4-0-Offset-Index=Order
              -->
              <input class="BootOrder" type="hidden">
                <xsl:attribute name="id">BootType-0-<xsl:value-of select="@offset"/>-<xsl:value-of select="@idx"/></xsl:attribute>
                <xsl:attribute name="name">4-0-<xsl:value-of select="@offset"/>-<xsl:value-of select="@idx"/></xsl:attribute>
                <xsl:attribute name="order"><xsl:value-of select="@order"/></xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="@order"/></xsl:attribute>
              </input>
              <span class="BootOrderUp BootOrderControl">
                <img src="Images/UpPic.png" height="18">
                <xsl:attribute name="id">BootypeBtnUp<xsl:value-of select="@idx"/></xsl:attribute>
                </img>
              </span>
              <span class="BootOrderDown BootOrderControl">
                <img src="Images/DownPic.png" height="18">
                <xsl:attribute name="id">BootypeBtnDown<xsl:value-of select="@idx"/></xsl:attribute>
                </img>
              </span>
              <span class="ClearBoth"></span>
            </span><!-- ContentField -->
            <div class="ClearBoth"></div>
          </span><!-- BootDeviceRow -->
          <div class="ClearBoth"></div>
        </xsl:for-each>
      </div>
      <br />
    </div><!-- BootTypeOrderTable -->
    </xsl:if>
  </xsl:if>

  <xsl:if test="$FormName='Security'">
    <!-- Password -->
    <xsl:for-each select="Formset[@name='Password']/Form/*">
      <xsl:variable name="SelectedFormSet" select="../../@name" />
      <xsl:variable name="SelectedFormId" select="../@fid" />
      <div id="PasswordTable" class="Row">
        <xsl:attribute name="exp"><xsl:value-of select="@exp"/></xsl:attribute>
        <span class="PasswordTitle"><xsl:value-of select="Pmt"/></span>
        <div class="Row InputRow">
          <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>

          <span class="TitleField OneOfNumericColor">Old password</span>
          <span class="ContentField">
            <!--
              Password (Old) init code is 5
              Type-CallbackId-Offset-Width=Value
                 5-CallbackId-0-0=OldPassword
            -->
            <input type="text">
              <xsl:attribute name="id">Passwd-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="name">5-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
              <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
              <xsl:attribute name="size">16</xsl:attribute>
              <xsl:attribute name="maxlength"><xsl:value-of select="@max"/></xsl:attribute>
            </input>
          </span>

          <span class="HelpField" style="display: none">
            <div class="HelpContent">Please input old password to make chage work&#160;</div>
            <div class="HelpPopMsg">&#160;</div>
          </span>
        </div><!-- Row -->

        <div class="Row InputRow">
          <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>

          <span class="TitleField OneOfNumericColor">New Password</span>
          <span class="ContentField">
            <!--
              Password (New) init code is 6
              Type-CallbackId-Offset-Width=Value
                 6-CallbackId-0-0=NewPassword
            -->
            <input type="text">
              <xsl:attribute name="id">PasswdNew-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="name">6-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
              <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
              <xsl:attribute name="size">16</xsl:attribute>
              <xsl:attribute name="maxlength"><xsl:value-of select="@max"/></xsl:attribute>
            </input>
          </span>

          <span class="HelpField" style="display: none">
            <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
            <div class="HelpPopMsg">&#160;</div>
          </span>
        </div><!-- Row -->

        <div class="Row InputRow">
          <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>

          <span class="TitleField OneOfNumericColor">Confirm Password</span>
          <span class="ContentField">
            <!--
              Password (Confirm) init code is 7
              Type-CallbackId-Offset-Width=Value
                 7-CallbackId-0-0=NewPassword
            -->
            <input type="text">
              <xsl:attribute name="id">PasswdCfm-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="name">7-<xsl:value-of select="@cid"/>-0-0</xsl:attribute>
              <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
              <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
              <xsl:attribute name="size">16</xsl:attribute>
              <xsl:attribute name="maxlength"><xsl:value-of select="@max"/></xsl:attribute>
            </input>
          </span>
        </div><!-- Row -->
      <div class="ClearBoth"></div>
      <br />
    </div><!-- PasswordTable -->
    </xsl:for-each>

  </xsl:if>
</xsl:template>

<xsl:template match="/Root">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <!-- It may not work immediatly on IE -->
  <meta http-equiv="Pragma" content="no-cache"/>
  <!-- Same as above line -->
  <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate"/>
  <!-- Set web page expiration time is 0, ie is -1 -->
  <meta http-equiv="Expires" content="-1"/>
  <meta http-equiv="X-Content-Type-Options" content="nosniff"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />

  <link rel="stylesheet" type="text/css" href="CssStyle/Common.css" />
  <link rel="stylesheet" type="text/css" href="CssStyle/PopupWin.css" />
  <link rel="stylesheet" type="text/css" href="CssStyle/Setup.css" />

  <xsl:choose>
    <xsl:when test="/Root/Header[@type='1']">
      <link rel="stylesheet" type="text/css" href="CssStyle/ThemeDefaultImg.css" />
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="/Root/Header[@type='1']">
      <title>BIOS Default Settings</title>
    </xsl:when>

    <xsl:otherwise>
      <title>BIOS Settings Migration</title>
    </xsl:otherwise>
  </xsl:choose>
</head>

<body>
  <div id="TopFrame">
    <div id="TopFrameCont">
      <span id="TopBoxLeft">
        <xsl:choose>
          <xsl:when test="/Root/Header[@type='1']">
            <div id="InsydeLogo"><span><a href="/"><img src="Images/InsydeLogo_h2ouve_default.png" /></a></span></div>
          </xsl:when>

          <xsl:otherwise>
            <div id="InsydeLogo"><span><a href="/"><img src="Images/InsydeLogo_h2ouve.png" /></a></span></div>
          </xsl:otherwise>
        </xsl:choose>
      </span><!-- TopBoxLeft -->
      <span id="TopBoxRight">
        <div id="AdminBar">Current User: Admin</div>
      </span><!-- TopBoxRight -->
      <span class="ClearBoth"></span>
    </div>
  </div><!-- TopFrame -->

  <div id="MidFrame">
    <div id="MainFrame">
      <div id="MainFrameTopBorder">
        <span class="MainFrameCorner MainFrameCornerLeft"></span>
        <span class="MainFrameCorner MainFrameCornerRight"></span>
        <span class="ClearBoth"></span>
      </div><!-- MainFrameTopBorder -->

      <span id="MenuList">
        <xsl:choose>
          <xsl:when test="/Root/Header[@type='1']">
            <div class="LinkTitle">BIOS Default Settings</div>
          </xsl:when>

          <xsl:otherwise>
            <div class="LinkTitle">BIOS Settings Migration</div>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="Formset[@name='Information']">
        <div><a id="InformationLink" class="LinkBtn">Information</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Main']">
        <div><a id="MainLink" class="LinkBtn">Main</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Advanced']">
        <div><a id="AdvancedLink" class="LinkBtn">Advanced</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Boot']">
        <div><a id="BootLink" class="LinkBtn">Boot</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Power']">
        <div><a id="PowerLink" class="LinkBtn">Power</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Server']">
        <div><a id="ServerLink" class="LinkBtn">Server</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Security']">
        <div><a id="SecurityLink" class="LinkBtn">Security</a></div>
        </xsl:if>
        <xsl:if test="Formset[@name='Exit']">
        <div><a id="ExitLink" class="LinkBtn">Exit</a></div>
        </xsl:if>
<!--
        <ul>
          <li>
            <input id="setup" type="checkbox" checked="checked" />
            <xsl:choose>
              <xsl:when test="/Root/Header[@type='1']">
                <label for="setup">BIOS Default Settings</label>
              </xsl:when>

              <xsl:otherwise>
                <label for="setup">BIOS Settings Migration</label>
              </xsl:otherwise>
            </xsl:choose>
            <ul class="SubMenu">
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Information']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Main']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Advanced']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Boot']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Power']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Server']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Security']"/>
              </xsl:call-template>
              <xsl:call-template name="FormMenu">
                <xsl:with-param name="FormsetPath" select="/Root/Formset[@name='Exit']"/>
              </xsl:call-template>
            </ul>
          </li>
        </ul>
-->
      </span><!-- MenuList -->

      <span id="MainContent" class="ContPage" style="display: inline-block;">
        <div id="InnerFrame" class="" style="">

          <div id="InfoBody" class="" style="">
            <form id="DataForm" method="post">
              <xsl:choose>
                <xsl:when test="/Root/Header[@type='1']">
                  <!--
                    Header init code is 8
                    Type-CallbackId-Offset-Width=Value
                       8-BiosImgDefault=Value
                  -->
                  <input type="hidden" id="BiosImgDefault" name="8-BiosImgDefault" value="1" />
                </xsl:when>
              </xsl:choose>
              <!--
                Header init code is 8
                Type-CallbackId-Offset-Width=Value
                   8-FileGenTime=Value
              -->
              <input type="hidden" id="FileGenTime" name="8-FileGenTime" value="" />

              <div id="StdBody">

                <xsl:if test="Formset[@name='Information']">
                <div id="InformationInfo" class="FormFrame" style="display: none">
                  <xsl:call-template name="GenFormInfo">
                    <xsl:with-param name="FormName" select="'Information'"/>
                  </xsl:call-template>
                </div><!-- BootInfo -->
                </xsl:if>

                <div id="MainInfo" class="FormFrame" style="display: none">
                  <div style="height: 60px;">
                    <div id="Systime" class="">
                      <span class="TimeTitle">System Date</span>
                      <a id="SystemDate" class="TimeContentField">Loading...<img src="Images/loading.gif" height="24" width="24" /></a>
                      <span class="TimeTitle">System Time</span>
                      <a id="SystemTime" class="TimeContentField">Loading...<img src="Images/loading.gif" height="24" width="24" /></a>
                    </div><!-- Systime -->
                    <div id="EditSystime" style="display: none">
                      <span class="TimeTitle">System Date</span>
                      <span class="TimeContentField">
                        <!--
                          Header init code is 8
                          Type-CallbackId-Offset-Width=Value
                             8-Year=Value
                             8-Month=Value
                             8-Day=Value
                             8-Hour=Value
                             8-Minute=Value
                             8-Second=Value
                        -->
                        <input id="Month" name="8-Month" type="text" size="2" maxlength="2" value="" style="width: 40px" />/
                        <input id="Day" name="8-Day" type="text" size="2" maxlength="2" value="" style="width: 40px" />/
                        <input id="Year" name="8-Year" type="text" size="4" maxlength="4" value="" style="width: 80px" />
                      </span>
                      <span class="TimeTitle">System Time</span>
                      <span class="TimeContentField">
                        <input id="Hour" name="8-Hour" type="text" size="2" maxlength="2" value="" style="width: 40px" />:
                        <input id="Minute" name="8-Minute" type="text" size="2" maxlength="2" value="" style="width: 40px" />:
                        <input id="Second" name="8-Second" type="text" size="2" maxlength="2" value="" style="width: 40px" />
                      </span>
                    </div><!-- EditSystime -->
                  </div>
                  <xsl:call-template name="GenFormInfo">
                    <xsl:with-param name="FormName" select="'Main'"/>
                  </xsl:call-template>
                </div><!-- MainInfo -->

                <div id="AdvancedInfo" class="FormFrame" style="display: none">
                  <xsl:call-template name="GenFormInfo">
                    <xsl:with-param name="FormName" select="'Advanced'"/>
                  </xsl:call-template>
                </div><!-- AdvancedInfo -->

                <xsl:if test="Formset[@name='Boot']">
                <div id="BootInfo" class="FormFrame" style="display: none">
                  <xsl:call-template name="GenFormInfo">
                    <xsl:with-param name="FormName" select="'Boot'"/>
                  </xsl:call-template>
                </div><!-- BootInfo -->
                </xsl:if>

                <xsl:if test="Formset[@name='Power']">
                <div id="PowerInfo" class="FormFrame" style="display: none">
                <xsl:call-template name="GenFormInfo">
                  <xsl:with-param name="FormName" select="'Power'"/>
                </xsl:call-template>
                </div><!-- PowerInfo -->
                </xsl:if>

                <div id="ServerInfo" class="FormFrame" style="display: none">
                <xsl:call-template name="GenFormInfo">
                  <xsl:with-param name="FormName" select="'Server'"/>
                </xsl:call-template>
                </div><!-- End of ServerInfo -->

                <div id="SecurityInfo" class="FormFrame" style="display: none">
                <xsl:call-template name="GenFormInfo">
                  <xsl:with-param name="FormName" select="'Security'"/>
                </xsl:call-template>
                </div><!-- End of SecurityInfo -->

                <div id="ExitInfo" class="FormFrame" style="display: none">
                  <xsl:for-each select="/Root/Formset/Form[@name='Exit']/*">
                    <xsl:variable name="SelectedFormSet" select="../../@name" />
                    <xsl:variable name="SelectedFormId" select="../@fid" />
                    <xsl:choose>

                      <xsl:when test="current()[name()='Txt']">
                        <xsl:choose>
                          <xsl:when test="current()[Pmt='Save Changes and Exit' or Pmt='Exit Saving Changes']">
                          <div class="Row TxtRow">
                            <xsl:attribute name="exp">
                              <xsl:value-of select="@exp"/>
                            </xsl:attribute>
                            <xsl:attribute name="rid">
                              <xsl:value-of select="@rid"/>
                            </xsl:attribute>
                            <div class="ExitBtn TitleField" funnum="1" exit="1" >
                              <span><xsl:value-of select="Pmt"/></span>
                            </div>
                            <span class="HelpField" style="display: none">
                              <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                              <div class="HelpPopMsg">&#160;</div>
                            </span>
                          </div>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Discard Changes and Exit' or Pmt='Exit Discarding Changes']">
                          <div class="Row TxtRow">
                            <xsl:attribute name="exp">
                              <xsl:value-of select="@exp"/>
                            </xsl:attribute>
                            <xsl:attribute name="rid">
                              <xsl:value-of select="@rid"/>
                            </xsl:attribute>
                            <div class="ExitBtn TitleField" funnum="2" exit="1">
                              <span><xsl:value-of select="Pmt"/></span>
                            </div>
                            <span class="HelpField" style="display: none">
                              <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                              <div class="HelpPopMsg">&#160;</div>
                            </span>
                          </div>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Save Changes' or Pmt='Save Change Without Exit']">
                          <div class="Row TxtRow">
                            <xsl:attribute name="exp">
                              <xsl:value-of select="@exp"/>
                            </xsl:attribute>
                            <xsl:attribute name="rid">
                              <xsl:value-of select="@rid"/>
                            </xsl:attribute>
                            <div class="ExitBtn TitleField" funnum="3" exit="0">
                              <span><xsl:value-of select="Pmt"/></span>
                            </div>
                            <span class="HelpField" style="display: none">
                              <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                              <div class="HelpPopMsg">&#160;</div>
                            </span>
                          </div>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Discard Changes']">
                          <div class="Row TxtRow">
                            <xsl:attribute name="exp">
                              <xsl:value-of select="@exp"/>
                            </xsl:attribute>
                            <xsl:attribute name="rid">
                              <xsl:value-of select="@rid"/>
                            </xsl:attribute>
                            <div class="ExitBtn TitleField" funnum="4" exit="0">
                              <span><xsl:value-of select="Pmt"/></span>
                            </div>
                            <span class="HelpField" style="display: none">
                              <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                              <div class="HelpPopMsg">&#160;</div>
                            </span>
                          </div>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Load Optimal Defaults']">
                            <xsl:choose>
                              <xsl:when test="/Root/Header[@type='1']">
                              </xsl:when>

                              <xsl:otherwise>
                                <div class="Row TxtRow">
                                  <xsl:attribute name="exp">
                                    <xsl:value-of select="@exp"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="rid">
                                    <xsl:value-of select="@rid"/>
                                  </xsl:attribute>
                                  <div class="ExitBtn TitleField" funnum="5" exit="0">
                                    <span><xsl:value-of select="Pmt"/></span>
                                  </div>
                                  <span class="HelpField" style="display: none">
                                    <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                                    <div class="HelpPopMsg">&#160;</div>
                                  </span>
                                </div>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Load Customized Defaults' or Pmt='Load Custom Defaults']">
                            <xsl:choose>
                              <xsl:when test="/Root/Header[@type='1']">
                              </xsl:when>

                              <xsl:otherwise>
                                <div class="Row TxtRow">
                                  <xsl:attribute name="exp">
                                    <xsl:value-of select="@exp"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="rid">
                                    <xsl:value-of select="@rid"/>
                                  </xsl:attribute>
                                  <div class="ExitBtn TitleField" funnum="6" exit="6">
                                    <span><xsl:value-of select="Pmt"/></span>
                                  </div>
                                  <span class="HelpField" style="display: none">
                                    <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                                    <div class="HelpPopMsg">&#160;</div>
                                  </span>
                                </div>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>

                          <xsl:when test="current()[Pmt='Save Customized Defaults' or Pmt='Save Custom Defaults']">
                            <xsl:choose>
                              <xsl:when test="/Root/Header[@type='1']">
                              </xsl:when>

                              <xsl:otherwise>
                                <div class="Row TxtRow">
                                  <xsl:attribute name="exp">
                                    <xsl:value-of select="@exp"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="rid">
                                    <xsl:value-of select="@rid"/>
                                  </xsl:attribute>
                                  <div class="ExitBtn TitleField" funnum="7" exit="0">
                                    <span><xsl:value-of select="Pmt"/></span>
                                  </div>
                                  <span class="HelpField" style="display: none">
                                    <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                                    <div class="HelpPopMsg">&#160;</div>
                                  </span>
                                </div>
                              </xsl:otherwise>
                            </xsl:choose>

                          </xsl:when>
                        </xsl:choose>
                      </xsl:when><!-- Txt -->

                      <xsl:when test="current()[name()='Numeric']">
                      <div class="Row InputRow">
                        <xsl:attribute name="exp">
                          <xsl:value-of select="@exp"/>
                        </xsl:attribute>
                        <xsl:attribute name="rid">
                          <xsl:value-of select="@rid"/>
                        </xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                        <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                        <xsl:if test="current()[Pmt='' or Pmt=' ']">
                          <xsl:attribute name="style">display: none</xsl:attribute>
                        </xsl:if>

                        <span class="TitleField OneOfNumericColor"><xsl:value-of select="Pmt"/></span>
                        <span class="ContentField">
                          <!--
                            Numeric init code is 1
                            Type-CallbackId-Offset-Width=Value
                               1-CallbackId-Offset-Width=Value
                          -->
                          <input type="text">
                            <xsl:attribute name="id">Numeric-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="name">1-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                            <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
                            <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
                            <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
                            <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
                            <xsl:attribute name="step"><xsl:value-of select="@step"/></xsl:attribute>
                            <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                            <xsl:attribute name="size">8</xsl:attribute>
                            <xsl:attribute name="maxlength">6</xsl:attribute>
<!--
                            <xsl:attribute name="disabled">true</xsl:attribute>
-->
                          </input>
                        </span>

                        <span class="HelpField" style="display: none">
                          <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                          <div class="HelpPopMsg">&#160;</div>
                        </span>
                      </div><!-- Row -->
                      </xsl:when><!-- Numeric -->

                      <xsl:when test="current()[name()='Oneof']">
                      <div class="Row InputRow">
                        <xsl:attribute name="exp">
                          <xsl:value-of select="@exp"/>
                        </xsl:attribute>
                        <xsl:attribute name="rid">
                          <xsl:value-of select="@rid"/>
                        </xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                        <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                        <xsl:if test="current()[@name='' or @name=' ']">
                          <xsl:attribute name="style">display: none</xsl:attribute>
                        </xsl:if>

                        <span class="TitleField OneOfNumericColor">
                          <xsl:value-of select="@name"/>
                        </span>
                        <span class="ContentField">
                          <!--
                            Oneof init code is 0
                            Type-CallbackId-Offset-Width=Value
                               0-CallbackId-Offset-Width=Value
                          -->
                          <select>
                            <xsl:attribute name="id">OneOf-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="name">0-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
                            <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
                            <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
<!--
                            <xsl:attribute name="disabled">true</xsl:attribute>
-->
                            <xsl:if test="@cid">
                              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                            </xsl:if>
                            <xsl:variable name="SelectedVal" select="@crt" />

                            <xsl:for-each select="Option">
                            <option>
                              <xsl:attribute name="id">Opt<xsl:value-of select="@val"/></xsl:attribute>
                              <xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
                              <xsl:if test="$SelectedVal=@val">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="."/>
                            </option>
                            </xsl:for-each>
                          </select>
                        </span>
                        <div class="ClearBoth"></div>

                        <span class="HelpField" style="display: none">
                          <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                          <div class="HelpPopMsg">&#160;</div>
                        </span>
                      </div><!-- Row -->
                      </xsl:when><!-- Oneof -->
                    </xsl:choose>
                  </xsl:for-each>
                </div><!-- End of ExitInfo -->

              </div><!-- StdBody -->

              <div id="InnerBody" style="display: none">
                <div class="ControlBar">
                  <span class="InnerTitle SubSecTitle">Loading...</span>
                  <span class="InnerBoddyClose"><img id="CloseInner" src="Images/Close.png" height="24" /></span>
                  <span class="ClearBoth"></span>
                </div>
                <br />
                <div class="InnerBoddyContent">
                  <xsl:for-each select="Formset/Form[@fid!='0' and @fid!='1']">
                  <div class="FormFrame" style="display: none">
                    <xsl:attribute name="id"><xsl:value-of select="@fid"/>Info</xsl:attribute>
<!--
                    <xsl:attribute name="id">form<xsl:value-of select="@fid"/></xsl:attribute>
-->
                    <xsl:if test="current()/Subtitle[position()=1]">
                      <xsl:choose>
                        <xsl:when test="Pmt != '' and Pmt != ' '">
                          <xsl:attribute name="title"><xsl:value-of select="Pmt"/></xsl:attribute>
                        </xsl:when>

                        <xsl:otherwise>
<!--                              <xsl:attribute name="name"><xsl:value-of select="../@name"/></xsl:attribute>-->
                          <xsl:attribute name="title"></xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>

                    <xsl:for-each select="current()/*">
                      <xsl:variable name="SelectedFormSet" select="../../@name" />
                      <xsl:variable name="SelectedFormId" select="../@fid" />
                      <xsl:choose>
                        <xsl:when test="current()[name()='Subtitle']">
                          <xsl:choose>
                            <xsl:when test="Pmt != '' and Pmt != ' ' and position() != 1">
                            <div class="Row TxtRow">
                              <xsl:attribute name="exp">
                                <xsl:value-of select="@exp"/>
                              </xsl:attribute>
                              <xsl:attribute name="rid">
                                <xsl:value-of select="@rid"/>
                              </xsl:attribute>

                              <div class="OneLineField"><xsl:value-of select="Pmt"/></div>
                            </div>
                            </xsl:when>

                            <xsl:when test="position() != 1 and position() != 2">
                            <div class="Row TxtRow">
                              <xsl:attribute name="exp">
                                <xsl:value-of select="@exp"/>
                              </xsl:attribute>
                              <xsl:attribute name="rid">
                                <xsl:value-of select="@rid"/>
                              </xsl:attribute>
                              &#160;
                            </div>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>

                        <xsl:when test="current()[name()='Txt']">
                          <xsl:choose>
                            <xsl:when test="Pmt != '' and Pmt != ' '">
                            <div class="Row TxtRow">
                              <xsl:attribute name="exp">
                                <xsl:value-of select="@exp"/>
                              </xsl:attribute>
                              <xsl:attribute name="rid">
                                <xsl:value-of select="@rid"/>
                              </xsl:attribute>
                              <span class="TitleField"><xsl:value-of select="Pmt"/></span>
                              <span class="ContentField"><xsl:value-of select="Cont"/></span>
                            </div>
                            </xsl:when>

                            <xsl:when test="(Pmt = '' or Pmt = ' ') and position() != 1">
                            <div class="Row TxtRow">
                              &#160;
                            </div>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when><!-- Txt -->

                        <xsl:when test="current()[name()='Ref' and Pmt!='' and Pmt!=' ']">
                        <div class="Row TxtRow">
                          <xsl:attribute name="exp">
                            <xsl:value-of select="@exp"/>
                          </xsl:attribute>
                          <xsl:attribute name="rid">
                            <xsl:value-of select="@rid"/>
                          </xsl:attribute>

                          <span class="TriangleImage">
                            <img src="Images/Triangle.png" height="16" />
                          </span>
                          <a class="ToPopupTitle" href="#">
                            <xsl:attribute name="id">Ref<xsl:value-of select="@fid"/></xsl:attribute>
                            <xsl:attribute name="fid">
                              <xsl:value-of select="@fid"/>
                            </xsl:attribute>
                            <xsl:value-of select="current()/Pmt"/>
                          </a>

                          <!--
                          <span class="HelpField" style="display: none">
                            <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                          </span>
                          -->
                        </div>
                        </xsl:when><!-- Ref -->

                        <xsl:when test="current()[name()='Numeric']">
                        <div class="Row InputRow">
                          <xsl:attribute name="exp">
                            <xsl:value-of select="@exp"/>
                          </xsl:attribute>
                          <xsl:attribute name="rid">
                            <xsl:value-of select="@rid"/>
                          </xsl:attribute>
                          <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                          <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                          <xsl:if test="current()[Pmt='' or Pmt=' ']">
                            <xsl:attribute name="style">display: none</xsl:attribute>
                          </xsl:if>

                          <span class="TitleField OneOfNumericColor"><xsl:value-of select="Pmt"/></span>
                          <span class="ContentField">
                            <!--
                              Numeric init code is 1
                              Type-CallbackId-Offset-Width=Value
                                 1-CallbackId-Offset-Width=Value
                            -->
                            <input type="text">
                              <xsl:attribute name="id">Numeric-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="name">1-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                              <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
                              <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
                              <xsl:attribute name="min"><xsl:value-of select="@min"/></xsl:attribute>
                              <xsl:attribute name="max"><xsl:value-of select="@max"/></xsl:attribute>
                              <xsl:attribute name="step"><xsl:value-of select="@step"/></xsl:attribute>
                              <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                              <xsl:attribute name="size">8</xsl:attribute>
                              <xsl:attribute name="maxlength">6</xsl:attribute>
<!--
                              <xsl:attribute name="size"><xsl:value-of select="@max"/></xsl:attribute>
                              <xsl:attribute name="maxlength"><xsl:value-of select="@max"/></xsl:attribute>
-->
<!--
                              <xsl:attribute name="disabled">true</xsl:attribute>
-->
                            </input>
                          </span>

                          <span class="HelpField" style="display: none">
                            <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                            <div class="HelpPopMsg">&#160;</div>
                          </span>
                        </div><!-- Row -->
                        </xsl:when><!-- Numeric -->

                        <xsl:when test="current()[name()='Oneof']">
                        <div class="Row InputRow">
                          <xsl:attribute name="exp">
                            <xsl:value-of select="@exp"/>
                          </xsl:attribute>
                          <xsl:attribute name="rid">
                            <xsl:value-of select="@rid"/>
                          </xsl:attribute>
                          <xsl:attribute name="value"><xsl:value-of select="@crt"/></xsl:attribute>
                          <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                          <xsl:if test="current()[@name='' or @name=' ']">
                            <xsl:attribute name="style">display: none</xsl:attribute>
                          </xsl:if>

                          <span class="TitleField OneOfNumericColor">
                            <xsl:value-of select="@name"/>
                          </span>
                          <span class="ContentField">
                            <!--
                              Oneof init code is 0
                              Type-CallbackId-Offset-Width=Value
                                 0-CallbackId-Offset-Width=Value
                            -->
                            <select>
                              <xsl:attribute name="id">OneOf-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="name">0-<xsl:value-of select="@cid"/>-<xsl:value-of select="@offset"/>-<xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="cwidth"><xsl:value-of select="@width"/></xsl:attribute>
                              <xsl:attribute name="crt"><xsl:value-of select="@crt"/></xsl:attribute>
                              <xsl:attribute name="dft"><xsl:value-of select="@dft"/></xsl:attribute>
<!--
                              <xsl:attribute name="disabled">true</xsl:attribute>
-->
                              <xsl:if test="@cid">
                                <xsl:attribute name="cid"><xsl:value-of select="@cid"/></xsl:attribute>
                              </xsl:if>
                              <xsl:variable name="SelectedVal" select="@crt" />

                              <xsl:for-each select="Option">
                              <option>
                                <xsl:attribute name="id">Opt<xsl:value-of select="@val"/></xsl:attribute>
                                <xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
                                <xsl:if test="$SelectedVal=@val">
                                  <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="."/>
                              </option>
                              </xsl:for-each>
                            </select>
                          </span>
                          <div class="ClearBoth"></div>

                          <span class="HelpField" style="display: none">
                            <div class="HelpContent"><xsl:value-of select="Help"/>&#160;</div>
                            <div class="HelpPopMsg">&#160;</div>
                          </span>
                        </div><!-- Row -->
                        </xsl:when><!-- Oneof -->
                      </xsl:choose>
                    </xsl:for-each>
                  </div>
                  </xsl:for-each>

                </div><!-- InnerBoddyContent -->
              </div><!-- InnerBody -->

            </form><!-- DataForm -->

          </div><!-- InfoBody -->

          <div id="HelpBody" class="" style="display: none;">
            &#160;
          </div><!-- End of HelpBody -->

          <div class="ClearBoth"></div>

        </div><!-- InnerFrame -->
      </span><!-- MainContent -->

      <hr />

    </div><!-- MainFrame -->

  </div><!-- MidFrame -->

  <div id="Footer">
    <p>Copyright © 2012 Insyde</p>
  </div><!-- Footer -->

  <!-- Fixed on the bottom of browser widown not bottom of html -->
  <div id="FixedBottomBar">
    <div style="width: 980px; height: inherit; margin: 0 auto;">
      <span id="FixedBottomInfo">&#160;</span>
      <span id="HelpMsgSwitch">
        <input type="checkbox" />Help Message
      </span>
<!--      <button type="button">Enable Help Message</button>
      <span id="HelpMsgSwitch">Enable Help Message</span>-->
      <span class="ClearBoth"></span>
    </div>
  </div><!-- FixedBottomBar -->

  <!-- Pop-up window ver1.1 -->
  <div id="PopupWin" style="display: none;">
    <div id="PopupBG">&#160;</div>
    <div id="PopupMain">
      <div id="PopupTitle">&#160;</div>
      <div id="LoadingImg" style="display: none;">
        <img src="Images/loading.gif" height="30" width="30" />
      </div>
      <div id="ProgressBar" style="display: none;">
        <table border="0" cellpadding="0" cellspacing="2" style="width:100%">
          <tbody>
            <tr>
              <td id="tdPopupProgress1">&#160; &#160;</td>
              <td id="tdPopupProgress2">&#160; &#160;</td>
              <td id="tdPopupProgress3">&#160; &#160;</td>
              <td id="tdPopupProgress4">&#160; &#160;</td>
              <td id="tdPopupProgress5">&#160; &#160;</td>
              <td id="tdPopupProgress6">&#160; &#160;</td>
              <td id="tdPopupProgress7">&#160; &#160;</td>
              <td id="tdPopupProgress8">&#160; &#160;</td>
              <td id="tdPopupProgress9">&#160; &#160;</td>
              <td id="tdPopupProgress10">&#160; &#160;</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div id="PopupCont">&#160;</div>
      <div id="PopupCtrl" style="display: none;">
        <button type="button" name="ok" style="display: none;">OK</button>
        <button type="button" name="yes" style="display: none;">Yes</button>
        <button type="button" name="no" style="display: none;">No</button>
        <button type="button" name="stop" style="display: none;">Stop</button>
      </div>
    </div><!-- PopupMain -->
  </div><!-- PopupWin -->

  <div id="InsertedJsCbArea" style="display: none">&#160;</div>
  <script type="text/python" src="./common.py"></script>
  <!-- Those scripts must at bottom of html on IE and Chrome, when this is xslt file -->
  <script type="text/javascript" src="../ScuHandler.js"></script>
  <script type="text/javascript" src="Scripts/jquery-1.9.1.min.js"></script>
  <script type="text/javascript" src="Scripts/common.js"></script>
  <script type="text/javascript" src="Scripts/formparser.js"></script>
  <script type="text/javascript" src="Scripts/popupwin.js"></script>
  <script type="text/javascript" src="Scripts/ipparser.js"></script>
  <script type="text/javascript" src="Scripts/setup.js"></script>
  <script type="text/javascript">
  window.onload = function() {
    InitTab ();
    AsyncInitialization ();
    InitFunctionBinding ();
    ClosePopup ();
  }
  </script>
  <noscript>
    Your browser does not support javascript!
  </noscript>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
