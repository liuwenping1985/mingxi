<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.edoc.manager.EdocSwitchHelper"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var contentOfficeId;
</script>
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key="common.page.title" bundle="${v3xCommonI18N}" /></title>

<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/jquery/themes/default/easyui.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
<c:set var="canEditAtt" value="false"/>
<%-- 存为签章OBJECT对象的 --%>
<div id="iSignatureHtmlDiv" style="height:0;overflow:hidden;"></div>
<SCRIPT language=javascript for=SignatureControl  event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
<%-- 作用：重新获取签章位置--%>
 if(typeof(SignatureControl)!= 'undefined' && EventId == 4 ){
   CalculatePosition();
   SignatureControl.EventResult = true;
 }
</SCRIPT>
<SCRIPT type="text/javascript">
<%-- 页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置--%>
 window.onresize = function (){
     moveISignatureOnResize();
 } 
 <%-- 页面离开的时候卸载签章、释放文单签批锁--%>
 window.onbeforeunload=cbfun;
 function cbfun(){
     try{releaseISignatureHtmlObj();}catch(e){}
     if(typeof(beforeCloseCheck) =='function'){
        return beforeCloseCheck();
     }
 }
 </SCRIPT>
<%
    response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", 0);
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
%>
<script type="text/javascript">

var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
function initRegister() {
	showRegisterInfo("edocform");
	try{
		showLayout();
	}catch(e){
	}
	//显示正文附件区域，由于布局的关系 ，导致在firefox下面或者两次调用这个方法，导致显示不正常。故将其移动到页面初始化方法中
	showAttachment('${bean.id}', 2, 'attachment2TrContent', 'attachment2NumberDivContent','attachmentHtml2Span');
	showAttachment('${bean.id}', 0, 'attachmentTrContent', 'attachmentNumberDivContent','attachmentHtml1Span');
	var attDiv =document.getElementById("attDiv");
	var att2Div= document.getElementById("att2Div");

	if(attDiv){
	 exportAttachment(attDiv);
	}
	if(att2Div){
	 exportAttachment(att2Div);
	}
	if( document.getElementById("attachment2TrContent").style.display=="none" && document.getElementById("attachmentTrContent").style.display=="none" ){
	  document.getElementById("attTrLabel").style.display="none";
	}
	//这个地方不要随便动啊。防止OFfice正文加载两次，同时正确显示HTML正文
	if( bodyType=="HTML"){
	    $('#edocContentDiv').css({"overflow":"auto", "height":"100%"});
	    
		$('#scrollContentTd').html($('#ctn').html());
		//$('#scrollContentTd').html(content);
	}
	
	parent.document.title="${v3x:toHTMLWithoutSpace(bean.subject)}";
}

function showLayout(){
    //body
	$('body').layout('panel','east').panel('resize',{
		width:350
	});
	var img1 = document.getElementById('img1');
	var img2 = document.getElementById('img2');
	var signAreaTable = document.getElementById('signAreaTable');
	var signMinDiv = document.getElementById('signMinDiv');

	if(img1) img1.style.display='';
	if(img2) img2.style.display='none'

	if(signAreaTable) signAreaTable.style.display='';
	if(signMinDiv) signMinDiv.style.display='none'

	$('body').layout().resize();
}


function showRegisterInfo(type){
	
	var edocformTR = document.getElementById('edocformTR');
	var contentTR = document.getElementById('contentTR');
	
	var edocform_input = document.getElementById('edocform_btn');
	var content_input = document.getElementById('content_btn');

	function initSet(){
		if(contentTR)contentTR.style.display = 'none';
		if(edocform_input)edocform_input.className = 'deal_btn_l';
	}

	if((type == "content") && bodyType != "HTML"){
		//当前点击正文按钮，并且是非HTML正文时，按钮样式不变化
	} else {
		initSet();
	}
	
	if(type == 'edocform'){
		if(edocformTR)edocformTR.style.display = '';
		if(edocform_input)edocform_input.className = 'deal_btn_l_sel';
	} else if(type == 'content') {
		if(contentTR && bodyType == "HTML"){
			if(edocformTR)edocformTR.style.display = 'none';
			contentTR.style.display = '';
			content_input.className = 'deal_btn_m_sel';
		} else {
			LazyloadOffice('0');
		}
	}
	//装载印章
	if((type == "content") && bodyType == "HTML"){
		 loadSignatures('${edocId}',false,false,false,3);
	}
}
function relationSendV(){
  	openRelationSendV('${recEdocId}','${recType}',"${ctp:escapeJavascript(param.forwardType)}");
}

function loadRelationButton(){
  //关联发文
  var relSends = "${relSends}";
  if(relSends == "haveMany"){
	 document.getElementById("relationSend").style.display="block";
  }
}


</script>
</head>
<body id="easyui-layout"  class="easyui-layout" scroll="no" onload="initRegister();loadRelationButton();">

	<input type="hidden" id="bodyType" value="${registerBody.contentType}"/>

	<div region="center" id="center_reagin" border="false" style="overflow: hidden;">

		<v3x:attachmentDefine attachments="${attachments}" />

		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
			<tr id="attTrLabel">
				<td height="36px" class="detail-summary" valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
					
						<tr id="attachment2TrContent" style="display: none">
							<td height="18" nowrap class="bg-gray" style="padding-top:5px;" valign="top"><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" /> : </td>
							<td width="100%" >
								<div class="div-float" id=att2Div style="margin-top: 4px;">
									<div class="div-float font-12px">(<span id="attachment2NumberDivContent" class="font-12px"></span>)</div>
									<span id="attachmentHtml2Span">
									</span>
								</div>
							</td>
						</tr>
			
						<tr id="attachmentTrContent" >
							<td height="18" nowrap class="bg-gray" valign="top" style="padding-top:5px;">
								
								  	<c:if test="${canEditAtt }">
										<span id="uploadAttachmentTR" style="margin-left:10px; vertical-align:middle;" ><a href="javascript:senderEditAtt()">&nbsp;&nbsp;<fmt:message key="common.toolbar.updateAttachment.label" bundle="${v3xCommonI18N}"/></a></span>
									</c:if>
									<c:if test="${!canEditAtt }">
										<span id="normalText"  style="margin-left:10px; vertical-align:middle;"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></span> 
									</c:if>
									 : 
								</td>
								<td valign="middle" width="100%">
									<div class=" div-float" id="attDiv" style="margin-top: 4px;">
										<div class="div-float font-12px">(<span id="attachmentNumberDivContent" class="font-12px">0</span>)</div>
										<span id="attachmentHtml1Span">
										</span>			
									</div>
								  </td>
								</tr>
	                           
					</table>
				</td>
			</tr>
			
			<tr>
				<td height="37" class="top_div_row3_deal_bg deal_toobar_m">
					<table cellpadding="0" cellspacing="0" width="100%" height="100%">
						<tr>
							<td width="16" class="top_div_row3_deal_l">&nbsp;</td>
							<td valign="top">
								<table cellpadding="0" cellspacing="0" width="100%" height="35">
									<tr>
									    <td valign="middle" nowrap="nowrap" class=""> 
										    <input id="edocform_btn" class="deal_btn_l_sel" onclick="showRegisterInfo('edocform')" type="button" value="<fmt:message key='edocform.label'/>"/>
										    <input id="content_btn" class="deal_btn_r" onclick="showRegisterInfo('content')" type="button" value="<fmt:message key='common.toolbar.content.label'  bundle='${v3xCommonI18N}'/>"/>
									    </td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table cellpadding="0" cellspacing="0" width="100%" height="100%">
						<tr>
							<td width="16" class="center_div_row3_deal_l_bg">&nbsp;</td>
							<td>
								<table cellpadding="0" cellspacing="0" width="100%" height="100%">
									<%--切换菜单及操作按钮开始 --%>
									<tr>
										<td valign="top">
											<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
												<tr id="closeTR" style="display: none" valign="top">
												    <td colspan="3">&nbsp;</td>
												</tr>
												<tr id="edocformTR">	
													<td colspan="3">
														<div id="relationSend" align="right" style="display:none;"> 
														<a href="#" onclick="relationSendV()" ><font color=red><fmt:message key='edoc.associated.posting'/></font></a></div>
													
														<iframe src="${controller}?method=edocRegisterFormDetail&registerId=${bean.id}" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
													</td>
												</tr>	
												<tr id="contentTR" style="display:none;">
													<td colspan="3" valign="top" align="center" id="scrollContentTd">
													
													</td>
												</tr>
											</table>
										</td>
									 </tr>
								</table>
							</td>
						</tr>	
					</table>
				</td>
			</tr>
			<tr>
				<td height="15" class="bottom_div_row3_deal_bg">
					<table cellpadding="0" cellspacing="0" width="100%" height="15">
						<tr>
							<td width="16" class="bottom_div_row3_deal_l_bg">&nbsp;</td>
							<td>&nbsp;</td>
							<td width="16" class="bottom_div_row3_deal_r_bg">&nbsp;</td>
						</tr>	
					</table>
				</td>
			</tr>
		</table>

		<div id="formContainer" style="display:none"></div>  
		<iframe name="showDiagramFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		
	</div>
	<div style="width:0px;height:0px;overflow:hidden;position: absolute;" id="ctn">
		<div name="edocContentDiv" id="edocContentDiv" style="width:100%;height:1px;overflow:hidden">
			<v3x:showContent  htmlId="edoc-contentText" content="${registerBody.content}" type="${registerBody.contentType}" createDate="${registerBody.createTime}" viewMode ="edit"/>
		</div>
		<input type="hidden" name="bodyContentId" value="${registerBody.id}">
	</div>
	
	<script type="text/javascript">
	    editType="4,0";
		var bodyType = "${registerBody.contentType}";
	
		if(bodyType!="HTML") {
			contentOfficeId = new Properties();
			//newEdocBodyId = fileId;
			contentOfficeId.put("${registerBody.contentNo}", "${contentNo}");
		}
			
	</script>
	
	
</body>
</html>