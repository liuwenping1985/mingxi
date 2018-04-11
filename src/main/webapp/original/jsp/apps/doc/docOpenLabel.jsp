<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	var docLibId = '${param.docLibId}';
	var docLibType = '${param.docLibType}';
    
	function doChangeMenu(sign) {
		var array = new Array("att");
		<%-- 
		<c:if test="${param.versionFlag eq 'HistoryVersion'}">
			array = new Array("att", "prop");		
		</c:if>
		--%>
		for(var i=0; i<array.length; i++){
			var o = document.getElementById(array[i]+"TR");
			
			if(array[i] == sign){
				if( o.style.display == "none"){
					o.style.display = "";
				} else {
					continue;
				}
			}else{
				o.style.display="none";
			}
		}
		changeLocation('att');	
		showPrecessArea(220);
	}
	var panels = new ArrayList();
	panels.add(new Panel("att", '<fmt:message key='doc.jsp.open.label.att'/>', "showPrecessArea(220)"));
	<%-- 
	<c:if test="${param.versionFlag eq 'HistoryVersion'}">
		panels.add(new Panel("prop", '<fmt:message key='doc.jsp.open.label.prop'/>', "showPrecessArea(220)"));
	</c:if>
	--%>
	
	function showPrecessArea(width) {
		width = width || "220";
		try{
		    parent.document.all.docOpenMainFrame.cols = "*," + width;
		}	
		catch(e){		
		}
	    document.getElementById('signAreaTable').style.display = "";
	    var _signMinDiv = document.getElementById('signMinDiv');
	    _signMinDiv.style.display = "none";
	    _signMinDiv.style.height = "0px";
	}
	
	function hiddenPrecessArea() {
	    parent.document.all.docOpenMainFrame.cols = "*,45";
	
	    document.getElementById('signAreaTable').style.display = "none";
	    var _signMinDiv = document.getElementById('signMinDiv');
	    _signMinDiv.style.display = "";
	    _signMinDiv.style.height = "100%";
	}
	var hasChangeMenu = false;
</script>
<v3x:attachmentDefine attachments="${atts}" />
</head>
<c:if test="${param.noChangeMenu !='true'}">
	<c:set var="loadAction" value="onload=\"doChangeMenu('att')\""/>
</c:if>
<body class="precss-scroll-bg" ${loadAction} scroll="no">
	<div id="signMinDiv" style="height: 100%;font-weight: normal;" class="sign-min-bg">
	    <script type="text/javascript">showMinPanels();hasChangeMenu=false;</script>
	</div>
	<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		    <td height="25" valign="top" class="sign-button-bg">
		        <script type="text/javascript">showPanels();hasChangeMenu=true;</script>
		    </td>
			<td align="right" style="padding-right: 10px" class="sign-button-bg"></td>
	    </tr>
		<tr>
			<td colspan="2" height="100%">

<table id="contentTable" width="100%" height="96%" border="0" cellspacing="0" cellpadding="0">
<tr id="propTR" style="display:none;width:100%;height:100%;overflow:auto;" valign="top">
<td>
<div class="doc-label-scrollList" id="scrollDiv">
<table width="90%" border="0" cellspacing="0" align="center"
	cellpadding="0" id="propNormalTable" style="word-break:break-all;word-wrap:break-word;">
		<tr height="25">
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr height="25">
			<td align="left" valign="top" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<b><fmt:message key='doc.jsp.properties.label.common'/></b></td>
		</tr>	

		<tr height="25">
			<td align="right" valign="top" width="45%"><fmt:message key='doc.jsp.properties.common.contenttype'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">${v3x:toHTML(v3x:_(pageContext, prop.type))}</td></tr>			
		<tr height="25">
			<td align="right" valign="top" ><fmt:message key='doc.jsp.properties.common.path'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top"><c:out value="${prop.path}" escapeXml="true" /></td></tr>				
		<tr height="25">
			<td align="right" ><fmt:message key='doc.metadata.def.size'/>:</td><td width="2%">&nbsp;</td>
			<td>${prop.size}</td></tr>			
		<tr height="25"><td align="right" valign="top" ><fmt:message key='doc.metadata.def.creater'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">${prop.createUserName}</td></tr>
		<tr height="25"><td align="right" valign="top" ><fmt:message key='doc.metadata.def.createtime'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top"><fmt:formatDate value='${prop.createTime}' pattern='${datetimePattern}' /></td></tr>	
		<tr height="25">
			<td align="right" valign="top" ><fmt:message key='doc.metadata.def.lastuser'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">${prop.lastUserName}</td></tr>			
		<tr height="25">
			<td align="right" valign="top" ><fmt:message key='doc.metadata.def.lastupdate'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top"><fmt:formatDate value='${prop.lastUpdate}' pattern='${datetimePattern}' /></td></tr>		
		<tr height="25">
			<td align="right" valign="top" ><fmt:message key='doc.metadata.def.keywords'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">${v3x:toHTML(prop.keywords)}</td></tr>		
		<c:if test="${isPersonalLib == false}">			
			<tr height="25">
				<td align="right" valign="top" ><fmt:message key='doc.jsp.properties.common.accesscount'/>:</td><td width="2%">&nbsp;</td>
				<td valign="top">${prop.accessCount}</td></tr>	
			<c:if test="${prop.commentEnabled == true}">
			<tr height="25"><td align="right" valign="top" ><fmt:message key='doc.jsp.properties.common.commentcount'/>:</td><td width="2%">&nbsp;</td>
				<td valign="top"><span id="commentCount">${prop.commentCount}</span></td></tr>
			</c:if>
		</c:if>
		<tr height="25"><td align="right" valign="top" ><fmt:message key='doc.metadata.def.desc'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">${v3x:toHTML(prop.desc)}</td></tr>
	</table>

	<c:if test="${extendSize > 0}">
		<table width="90%" border="0" cellspacing="0" align="center" cellpadding="0" id="propExtendTable">
				<tr height="25">
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr height="25">
					<td align="left" valign="top" valign="bottom" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<b><fmt:message key='doc.jsp.properties.label.advanced'/></b></td>
				</tr>	
				<tr><td>
					${metadataHtml}
				</td></tr>
				<tr><td >&nbsp;</td></tr>
		</table>
	</c:if>	
</div>
</td>
</tr>

<tr id="attTR" style="display:none"  valign="top">
<td>
<c:set value="${param.versionFlag eq 'HistoryVersion' ? param.docVersionId : param.docResId}" var="resId" />
<div class="doc-body-scrollList">
	<table width="90%" border="0" cellspacing="0" align="center" cellpadding="0"  id="attTable" style="word-break:break-all;word-wrap:break-word">
		<tr height="25">
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr height="25" class="${isUploadFile==true?'hidden':''}">
			<td align="left" valign="top" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></b>(<span id="attachmentNumberDiv"></span>)</td>
		</tr>	
		<tr height="25" class="${isUploadFile==true?'hidden':''}">
			<td width="15%" valign="top"></td>
			<td align="left" valign="top">
			<%-- 暂时屏蔽掉此处的逻辑(保证可以浏览附件)
			<c:if test="${param.all == 'true' || param.edit == 'true' || param.readonly == 'true'}">
			</c:if>
			--%>
				<script>
					showAttachment('${resId}', 0, 'attachmentTr', 'attachmentNumberDiv');
				</script>
			</td>			
		</tr>	

		<tr height="25">
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr height="25">
			<td align="left" valign="top" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" /></b>(<span id="attachment2NumberDiv"></span>)</td>
		</tr>	
		<tr height="25">
			<td width="15%" valign="top"></td>
			<td align="left" valign="top">
				<script>
					showAttachment('${resId}', 2, 'attachment2Tr', 'attachment2NumberDiv');
				</script>
			</td>			
		</tr>	
</table>
</div>
</td>
</tr>
</table>
</td>
</tr>
</table>
<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
<script>
initIpadScroll("scrollDiv",620);
</script>
</body>
</html>