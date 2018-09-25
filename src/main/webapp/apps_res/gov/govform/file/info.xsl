<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="www.seeyon.com/form/2007" xmlns:msxsl="www.seeyon.com/form/2007" xmlns:xd="www.seeyon.com/form/2007" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xdExtension="www.seeyon.com/form/2007" xmlns:xdXDocument="www.seeyon.com/form/2007" xmlns:xdSolution="www.seeyon.com/form/2007" xmlns:xdFormatting="www.seeyon.com/form/2007" xmlns:xdImage="www.seeyon.com/form/2007" version="1.0"><xsl:output method="html" indent="no"/>
	<xsl:template match="my:myFields">
		
	<style controlStyle="controlStyle">@media screen 			{ 			_BODY{margin-left:21px;background-position:21px 0px;} 			} 		_BODY{color:windowtext;background-color:window;layout-grid:none;} 		.xdListItem {display:inline-block;width:100%;vertical-align:text-top;} 		.xdListBox,.xdComboBox{margin:1px;} 		.xdInlinePicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) } 		.xdLinkedPicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) url(#default#urn::controls/Binder) } 		.xdHyperlinkBox{word-wrap:break-word; text-overflow:ellipsis;overflow-x:hidden; OVERFLOW-Y: hidden; WHITE-SPACE:nowrap; display:inline-block;margin:1px;padding:5px;border: 1pt solid #dcdcdc;color:windowtext;BEHAVIOR: url(#default#urn::controls/Binder) url(#default#DataBindingUI)} 		.xdSection{border:1pt solid transparent ;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;} 		.xdRepeatingSection{border:1pt solid transparent;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;} 		.xdMultiSelectList{margin:1px;display:inline-block; border:1pt solid #dcdcdc; padding:1px 1px 1px 5px; text-indent:0; color:windowtext; background-color:window; overflow:auto; behavior: url(#default#DataBindingUI) url(#default#urn::controls/Binder) url(#default#MultiSelectHelper) url(#default#ScrollableRegion);} 		.xdMultiSelectListItem{display:block;white-space:nowrap}		.xdMultiSelectFillIn{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;overflow:hidden;text-align:left;}		.xdBehavior_Formatting {BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting);} 	 .xdBehavior_FormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting);} 	.xdExpressionBox{margin: 1px;padding:1px;word-wrap: break-word;text-overflow: ellipsis;overflow-x:hidden;}.xdBehavior_GhostedText,.xdBehavior_GhostedTextNoBUI{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#TextField) url(#default#GhostedText);}	.xdBehavior_GTFormatting{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_GTFormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_Boolean{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#BooleanHelper);}	.xdBehavior_Select{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#SelectHelper);}	.xdBehavior_ComboBox{BEHAVIOR: url(#default#ComboBox)} 	.xdBehavior_ComboBoxTextField{BEHAVIOR: url(#default#ComboBoxTextField);} 	.xdRepeatingTable{BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word;}.xdScrollableRegion{BEHAVIOR: url(#default#ScrollableRegion);} 		.xdLayoutRegion{display:inline-block;} 		.xdMaster{BEHAVIOR: url(#default#MasterHelper);} 		.xdActiveX{margin:1px; BEHAVIOR: url(#default#ActiveX);} 		.xdFileAttachment{display:inline-block;margin:1px;BEHAVIOR:url(#default#urn::xdFileAttachment);} 		.xdSharePointFileAttachment{display:inline-block;margin:2px;BEHAVIOR:url(#default#xdSharePointFileAttachment);} 		.xdAttachItem{display:inline-block;width:100%%;height:25px;margin:1px;BEHAVIOR:url(#default#xdSharePointFileAttachItem);} 		.xdSignatureLine{display:inline-block;margin:1px;background-color:transparent;border:1pt solid transparent;BEHAVIOR:url(#default#SignatureLine);} 		.xdHyperlinkBoxClickable{behavior: url(#default#HyperlinkBox)} 		.xdHyperlinkBoxButtonClickable{border-width:1px;border-style:outset;behavior: url(#default#HyperlinkBoxButton)} 		.xdPictureButton{background-color: transparent; padding: 0px; behavior: url(#default#PictureButton);} 		.xdPageBreak{display: none;}_BODY{margin-right:21px;} 		.xdTextBoxRTL{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:right;word-wrap:normal;} 		.xdRichTextBoxRTL{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:right;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTTextRTL{height:100%;width:100%;margin-left:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButtonRTL{margin-right:-21px;height:17px;width:20px;behavior: url(#default#DTPicker);} 		.xdMultiSelectFillinRTL{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;overflow:hidden;text-align:right;}.xdTextBox{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:left;word-wrap:normal;} 		.xdRichTextBox{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:left;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTPicker{;display:inline;margin:1px;margin-bottom: 2px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-indent:0; layout-grid: none} 		.xdDTText{height:100%;width:100%;margin-right:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButton{margin-left:-21px;height:17px;width:20px;behavior: url(#default#DTPicker);} 		.xdRepeatingTable TD {VERTICAL-ALIGN: top;}</style><style tableEditor="TableStyleRulesID">TABLE.xdLayout TD {
	BORDER-TOP: medium none; BORDER-RIGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium none
}
TABLE.msoUcTable TD {
	BORDER-TOP: 1pt solid; BORDER-RIGHT: 1pt solid; BORDER-BOTTOM: 1pt solid; BORDER-LEFT: 1pt solid
}
TABLE {
	BEHAVIOR: url (#default#urn::tables/NDTable)
}
</style><style languageStyle="languageStyle">BODY {
	FONT-FAMILY: SimSun; FONT-SIZE: 10pt
}
TABLE {
	FONT-FAMILY: SimSun; FONT-SIZE: 10pt
}
SELECT {
	FONT-FAMILY: SimSun; FONT-SIZE: 10pt
}
.optionalPlaceholder {
	FONT-STYLE: normal; PADDING-LEFT: 20px; FONT-FAMILY: SimSun; COLOR: #333333; FONT-SIZE: xx-small; FONT-WEIGHT: normal; TEXT-DECORATION: none; BEHAVIOR: url(#default#xOptional)
}
.langFont {
	FONT-FAMILY: SimSun
}
.defaultInDocUI {
	FONT-FAMILY: SimSun; FONT-SIZE: xx-small
}
.optionalPlaceholder {
	PADDING-RIGHT: 20px
}
</style><style themeStyle="urn:office.microsoft.com:themeBlue">BODY {
	BACKGROUND-COLOR: white; COLOR: black
}
TABLE {
	BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; BORDER-COLLAPSE: collapse; BORDER-TOP: medium none; BORDER-RIGHT: medium none
}
TD {
	BORDER-BOTTOM-COLOR: #517dbf; BORDER-TOP-COLOR: #517dbf; BORDER-RIGHT-COLOR: #517dbf; BORDER-LEFT-COLOR: #517dbf
}
TH {
	BORDER-BOTTOM-COLOR: #517dbf; BACKGROUND-COLOR: #cbd8eb; BORDER-TOP-COLOR: #517dbf; COLOR: black; BORDER-RIGHT-COLOR: #517dbf; BORDER-LEFT-COLOR: #517dbf
}
.xdTableHeader {
	BACKGROUND-COLOR: #ebf0f9; COLOR: black
}
P {
	MARGIN-TOP: 0px
}
H1 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H2 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H3 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H4 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H5 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #517dbf
}
H6 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #ebf0f9
}
.primaryVeryDark {
	BACKGROUND-COLOR: #1e3c7b; COLOR: #ebf0f9
}
.primaryDark {
	BACKGROUND-COLOR: #517dbf; COLOR: white
}
.primaryMedium {
	BACKGROUND-COLOR: #cbd8eb; COLOR: black
}
.primaryLight {
	BACKGROUND-COLOR: #ebf0f9; COLOR: black
}
.accentDark {
	BACKGROUND-COLOR: #517dbf; COLOR: white
}
.accentLight {
	BACKGROUND-COLOR: #ebf0f9; COLOR: black
}
</style><div align="center">
					<table class="xdLayout" style="WORD-WRAP: break-word; BORDER-TOP: medium none; BORDER-RIGHT: medium none; BORDER-COLLAPSE: collapse; TABLE-LAYOUT: fixed; BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; WIDTH: 798px" borderColor="buttontext" border="1">
						<colgroup>
							<col style="WIDTH: 135px"/>
							<col style="WIDTH: 263px"/>
							<col style="WIDTH: 103px"/>
							<col style="WIDTH: 297px"/>
						</colgroup>
						<tbody vAlign="top">
							<tr style="MIN-HEIGHT: 46px">
								<td colSpan="4" style="BORDER-BOTTOM: #ff0000 1pt solid">
									<div align="center">
										<font color="#ff0000" size="6" face="宋体">信息报送单</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 31px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="宋体">标题</font>
									</div>
								</td>
								<td colSpan="3" style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL2" xd:binding="my:subject" style="HEIGHT: 26px; WIDTH: 652px">
												
											<pre><xsl:if test="my:subject[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:subject/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:subject"/></pre></span>
										</div>
									</font>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 31px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">责任编辑</font>
									</div>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL3" xd:binding="my:rs_editor" style="HEIGHT: 27px; WIDTH: 256px">
												
											<pre><xsl:if test="my:rs_editor[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:rs_editor/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:rs_editor"/></pre></span>
										</div>
									</font>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; BORDER-LEFT: #ff0000 1pt solid; PADDING-RIGHT: 1px">
									<div>
										<font color="#ff0000" size="4" face="SimSun">上报时间</font>
									</div>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<div>
										<font color="#ff0000" size="4" face="宋体"><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL12" xd:binding="my:report_date" style="HEIGHT: 25px; WIDTH: 290px">
												
											<pre><xsl:if test="my:report_date[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:report_date/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:report_date"/></pre></span>
										</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 28px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">上报部门</font>
									</div>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL6" xd:binding="my:report_dept" style="HEIGHT: 25px; WIDTH: 255px">
												
											<pre><xsl:if test="my:report_dept[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:report_dept/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:report_dept"/></pre></span>
										</div>
									</font>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; BORDER-LEFT: #ff0000 1pt solid; PADDING-RIGHT: 1px">
									<div>
										<font color="#ff0000" size="4" face="宋体">信息类型</font>
									</div>
								</td>
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<div>
										<font color="#ff0000" size="4" face="宋体"><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL4" xd:binding="my:category" style="HEIGHT: 25px; WIDTH: 290px">
												
											<pre><xsl:if test="my:category[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:category/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:category"/></pre></span>
										</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 168px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">正文</font>
									</div>
								</td>
								<td colSpan="3" style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL7" xd:binding="my:content" style="HEIGHT: 189px; WIDTH: 658px">
												
											<pre><xsl:if test="my:content[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:content/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:content"/></pre></span>
										</div>
									</font>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 84px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">审核意见</font>
									</div>
								</td>
								<td colSpan="3" style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL14" xd:binding="my:shenhe" style="HEIGHT: 76px; WIDTH: 658px">
												
											<pre><xsl:if test="my:shenhe[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:shenhe/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:shenhe"/></pre></span>
										</div>
									</font>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 87px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">采编意见</font>
									</div>
								</td>
								<td colSpan="3" style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL9" xd:binding="my:caibian" style="HEIGHT: 77px; WIDTH: 655px">
												
											<pre><xsl:if test="my:caibian[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:caibian/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:caibian"/></pre></span>
										</div>
									</font>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 47px">
								<td style="BORDER-TOP: #ff0000 1pt solid; BORDER-RIGHT: #ff0000 1pt solid; VERTICAL-ALIGN: middle; BORDER-BOTTOM: #ff0000 1pt solid; PADDING-BOTTOM: 1px; PADDING-TOP: 1px; PADDING-LEFT: 1px; PADDING-RIGHT: 1px">
									<div align="center">
										<font color="#ff0000" size="4" face="SimSun">其它意见</font>
									</div>
								</td>
								<td colSpan="3" style="BORDER-TOP: #ff0000 1pt solid; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-LEFT: #ff0000 1pt solid">
									<font color="#ff0000" size="4" face="宋体">
										<div><span title="" class="xdTextBox" hideFocus="1" tabIndex="0" xd:xctname="PlainText" xd:CtrlId="CTRL11" xd:binding="my:otherOpinion" style="HEIGHT: 84px; WIDTH: 657px">
												
											<pre><xsl:if test="my:otherOpinion[@value]"><xsl:attribute  name="default"><xsl:value-of select="my:otherOpinion/@value"/></xsl:attribute ></xsl:if><xsl:value-of select="my:otherOpinion"/></pre></span>
										</div>
									</font>
								</td>
							</tr>
						</tbody>
					</table>
				</div><div style="display:none;">formStyleHasUpgrade</div></xsl:template>
</xsl:stylesheet>