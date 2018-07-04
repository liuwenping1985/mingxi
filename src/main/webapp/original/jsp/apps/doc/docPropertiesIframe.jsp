<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.properties.title'/></title>
</head>
	<style>
	input{
		outline:none;
	}
	</style>
<script type="text/javascript">
<!-- 
	window.onload = function () {
		if(document.getElementById('saveBtn') && document.getElementById('cancelBtn')) {
			document.getElementById('saveBtn').disabled=false;
			document.getElementById('cancelBtn').disabled=false;
		}		
	}
	
	function closeAndRefresh(url) {
		window.dialogArguments.getA8Top().contentFrame.mainFrame.rightFrame.location.href = url;
		window.close();
	}
	
	var loadedFlag = false;
	function doChangeMenu(sign){
		if(!loadedFlag)
			return;
	 
		var array=new Array("myCommon","docCommon","normal","borrow","extend");
		for(var j=0;j<array.length;j++){
			if(array[j] == sign){
				document.getElementById(array[j]+1).className="tab-tag-left-sel";
				document.getElementById(array[j]+2).className="tab-tag-middel-sel";
				document.getElementById(array[j]+3).className="tab-tag-right-sel";
			} else {
				var theDocument=document.getElementById(array[j]+1);
				if(theDocument == null){
					continue;
				} else {
					document.getElementById(array[j]+1).className="tab-tag-left";
					document.getElementById(array[j]+2).className="tab-tag-middel";
					document.getElementById(array[j]+3).className="tab-tag-right";
				}
			}
		}
		
		for(var i=0;i<array.length;i++){
			var o=docPropertyIframe.document.getElementById(array[i]+"TR");
			if(array[i] == sign){
				if( o.style.display == "none"){
					 o.style.display = "";
				}else{
					continue;
				}
			}else{
				o.style.display="none";
			}
		}
		var oSaveBtn = document.getElementById("saveBtn");
		if(oSaveBtn!=null){
			oSaveBtn.focus();
		}else{
			var oCancelBtn = document.getElementById("cancelBtn");
			if(oCancelBtn!=null){
				oCancelBtn.focus();
			}
		}
	}
	
	function toDoProp(){
		if (typeof(docPropertyIframe.doProperty) == "undefined"){
            getA8Top().LibPropWin.close();
        }else{
            docPropertyIframe.doProperty();
        }
	}
	
	
	function openHelp(flag){
		getA8Top().helpWin = getA8Top().$.dialog({
            title:'<fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/>',
            transParams:{'parentWin':window},
            url: "${detailURL}?method=openHelp&isPersonLib="+flag,
            width: 420,
            height: 400,
            isDrag:false
        });
	}
	
	function OK(){
		toDoProp();
	}
//-->	
</script>
<body scroll="no" onkeydown="listenerKeyESC()" class="tab-body">
<c:set value="${param.allAcl eq 'true' || param.editAcl eq 'true' || param.addAcl eq 'true' || param.readOnlyAcl eq 'true' || param.browseAcl eq 'true' || param.all eq 'true' || param.edit eq 'true' || param.add eq 'true' || param.readonly eq 'true' || param.browse eq 'true' }" var="showShare" />
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<c:set var="isExtend" value="${extandexit}"/>
	<tr style="background:rgb(250,250,250);">
		<td colspan="3" valign="bottom" height="26" class="panel_tab_div tab-tag border_b" style="padding:0 20px;border-bottom: none;">
			<script type="text/javascript">
				// 页签是否显示标记
				var labelPublicShare = false;
				var labelPersonalShare = false;
				var labelBorrow = false;
				var	labelExtend = false;
			</script>
            <c:if test="${ param.isPersonalShare ne 'true' }">
                <div class="tab-separator"></div>
            </c:if>
			<div style="border-bottom: solid 1px #7DC1FD; height: 26px;line-height: 26px;">
				<c:set var="PFlag" value="${param.isP == 'true' ? '-sel' : ''}" />
                <c:if test="${ param.isPersonalShare ne 'true' }">
                    <div class="tab-tag-left${PFlag}" id="normal1"></div>
                    <div class="tab-tag-middel${PFlag}" id="normal2"><a class="non-a" onclick="doChangeMenu('normal');"><fmt:message key='doc.jsp.properties.label.common'/></a></div>
                    <div class="tab-tag-right${PFlag}" id="normal3"></div>
                </c:if>
				<c:if test="${v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
				<c:if test="${param.isFolder == 'true' && param.isPersonalLib == 'false' && param.isShareAndBorrowRoot == 'false' && noShare == false && showShare}">
					<script type="text/javascript">
					//非全部权限者 也显示    删除 && param.allAcl == 'true'
						// 页签是否显示标记
						labelPublicShare = true;
					</script>
				
					<c:set var="CFlag" value="${param.isC == 'true' ? '-sel' : ''}" />
					<div class="tab-separator"></div>	
					<div class="tab-tag-left${CFlag}" id="docCommon1"></div>
					<div class="tab-tag-middel${CFlag}" id="docCommon2"><a class="non-a" onclick="doChangeMenu('docCommon');"><fmt:message key='doc.jsp.properties.label.share'/></a></div>
					<div class="tab-tag-right${CFlag}" id="docCommon3"></div>
				</c:if>
				
				<c:if test="${param.isFolder == 'true' && param.docLibId == '9000' && showShare}">
					<script type="text/javascript">
						// 页签是否显示标记
						labelPublicShare = true;
					</script>
					
					<c:set var="CFlag" value="${param.isC == 'true' ? '-sel' : ''}" />	
					<div class="tab-separator"></div>	
					<div class="tab-tag-left${CFlag}" id="docCommon1"></div>
					<div class="tab-tag-middel${CFlag}" id="docCommon2"><a class="non-a" onclick="doChangeMenu('docCommon');"><fmt:message key='doc.jsp.properties.label.share'/></a></div>
					<div class="tab-tag-right${CFlag}" id="docCommon3"></div>
				</c:if>
							
				<c:if test="${param.isFolder == 'true' && param.isPersonalLib == 'true'&& param.isShareAndBorrowRoot == 'false' && showShare}">
					<script type="text/javascript">
					//非全部权限者 也显示    删除 && param.allAcl == 'true'
						// 页签是否显示标记
						labelPersonalShare = true;
					</script>
					
					<c:set var="MFlag" value="${param.isM == 'true' ? '-sel' : ''}" />	
					<div class="tab-separator"></div>
					<div class="tab-tag-left${MFlag}" id="myCommon1"></div>
					<div class="tab-tag-middel${MFlag}" id="myCommon2"><a class="non-a" onclick="doChangeMenu('myCommon');"><fmt:message key='doc.jsp.properties.label.share'/></a></div>
					<div class="tab-tag-right${MFlag}" id="myCommon3"></div>
				</c:if>	
				
				<c:if test="${(param.isFolder == 'false' && folderLink == false && docLink == false && param.isShareAndBorrowRoot == 'false' && param.allAcl == 'true') ||(isPerBorrow)||(param.frType=='111')}">
					<script type="text/javascript">
						// 页签是否显示标记
						labelBorrow = true;
					</script>
					<c:set var="BFlag" value="${param.isB == 'true' ? '-sel' : ''}" />	
					<div class="tab-separator"></div>
					<div class="tab-tag-left${BFlag}" id="borrow1"></div>
					<div class="tab-tag-middel${BFlag}" id="borrow2" ><a class="non-a" onclick="doChangeMenu('borrow');"><fmt:message key='doc.jsp.properties.label.borrow'/></a></div>
					<div class="tab-tag-right${BFlag}" id="borrow3" ></div>				
				</c:if>
				
				<c:if test="${isExtend == 'true' }">
					<script type="text/javascript">
						// 页签是否显示标记
						labelExtend = true;
					</script>
					<div class="tab-separator"></div>
					<div class="tab-tag-left" id="extend1"></div>
					<div class="tab-tag-middel" id="extend2"><a class="non-a" onclick="doChangeMenu('extend');"><fmt:message key='doc.jsp.properties.label.advanced'/></a></div>
					<div class="tab-tag-right" id="extend3"></div>				
				</c:if>
				</c:if> 
				<div class="totle-search-l right">
				  <c:if test="${v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
				  <c:if test="${param.isFolder == 'true' && param.isPersonalLib == 'false' && param.isShareAndBorrowRoot == 'false' && param.allAcl == 'true' && noShare == false}">
				    <span onclick='openHelp(false)' id='helpDiv' class='like-a '><fmt:message key='common.toolbar.help.label' bundle='${v3xCommonI18N}'/></span>&nbsp;&nbsp;
			      </c:if>
			      <c:if test="${param.isFolder == 'true' && param.isPersonalLib == 'true'&& param.isShareAndBorrowRoot == 'false' && param.allAcl == 'true'}">
			         <span onclick='openHelp(true)' id='helpDiv' class='like-a '><fmt:message key='common.toolbar.help.label' bundle='${v3xCommonI18N}'/></span>&nbsp;&nbsp;
			      </c:if>
			      </c:if>
		          &nbsp;
				</div>				
			</div>
			<div class="tab-separator"></div>
		</td>
	</tr>

	<tr style="background:rgb(250,250,250);" >
		<td class="tab-body-bg" colspan="3">
			<iframe  name="docPropertyIframe" id="docPropertyIframe" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0">
			</iframe>
			<script type="text/javascript">
				var _all = '${param.all}';
				var _edit = '${param.edit}';
				var _add = '${param.add}';
				var _create = '${param.create}';
				var _readonly = '${param.readonly}';
				var _browse = '${param.browse}';
				var _read = '${param.read}';
				var _list = '${param.list}';	
				var _isShareAndBorrowRoot = '${param.isShareAndBorrowRoot}';			
				var _resId = '${param.resId}';
				var _parentCommentEnabled = '${param.parentCommentEnabled}';
				var _frType = '${param.frType}';	
				var _docLibId = '${param.docLibId}';
				var _docLibType = '${param.docLibType}';	
				var _flag = '${v3x:escapeJavascript(param.flag)}';
				docPropertyIframe.window.location.href = jsURL + "?method=docProperty&isP=${v3x:escapeJavascript(param.isP)}&isC=${v3x:escapeJavascript(param.isC)}&isM=${v3x:escapeJavascript(param.isM)}" + 
							"&isB=${v3x:escapeJavascript(param.isB)}&isFolder=${v3x:escapeJavascript(param.isFolder)}&docResId=${param.docResId}&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}" +
							"&propEditValue=${v3x:escapeJavascript(param.propEditValue)}&isLib=${v3x:escapeJavascript(param.isLib)}&docLibType=${param.docLibType}&isPersonalLib=${v3x:escapeJavascript(param.isPersonalLib)}" +
							"&docLibId=${param.docLibId}&isPerBorrow=${isPerBorrow}&lPublic=" + labelPublicShare + "&lPersonal=" + labelPersonalShare + 
							"&lBorrow=" + labelBorrow + "&lExtend=" + labelExtend + "&frType=${param.frType}" + "&_docLibId=" + _docLibId +"&allAcl=${v3x:escapeJavascript(param.allAcl)}"+
							"&_docLibType=" + _docLibType + "&_resId=" + _resId + "&_frType=" + _frType + "&_isShareAndBorrowRoot=${param.isShareAndBorrowRoot}" + 
							"&_all=" + _all + "&_edit=" + _edit + "&_add=" + _add + "&_create="+ _create + "&_readonly=" + _readonly + "&_browse=" + _browse + "&_read=" + _read + "&_list=" + _list +
							"&_parentCommentEnabled=" + _parentCommentEnabled + "&_flag=" + encodeURI(_flag) + "&isPig=${v3x:escapeJavascript(param.isPig)}&from=${param.from}&isPersonalShare=${param.isPersonalShare}&v=${v3x:escapeJavascript(v)}";
			</script>
		</td>
	</tr>
	<tr style="background:rgb(250,250,250);">
    	<td height="42" align="right" class="bg-advance-bottom" colspan="3">
    		<input disabled="disabled" id="saveBtn" name="saveBtn" type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize"  onclick="toDoProp();">&nbsp;
    		<input disabled="disabled" id="cancelBtn" name="cancelBtn" type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="getA8Top().LibPropWin.close();">
    	</td>
    </tr>
</table>
</body>
</html>