<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
<title></title>
<%@ include file="../common/INC/noCache.jsp"%>
<script>
	var panels = new ArrayList();
	panels.add(new Panel("handle", '<fmt:message key='inquiry.data.deal'/>', "showPrecessArea(220)"));
	function initLoad(sign){
		var array=new Array("handle");		
		for(var i=0;i<array.length;i++){
			var o=document.getElementById(array[i]+"TR");
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
		changeLocation('handle');	
		showPrecessArea(220);
	}
	function showPrecessArea(width) {
		width = 300;
		try{
		
		    parent.document.getElementById('zy').cols = "*," + width;
		}	
		catch(e){		
		}
	    document.getElementById('signAreaTable').style.display = "";
	    var _signMinDiv = document.getElementById('signMinDiv');
	    _signMinDiv.style.display = "none";
	    _signMinDiv.style.height = "0px";
	}
	function hiddenPrecessArea() {
	    parent.document.all.zy.cols = "*,45";
	    document.getElementById('signAreaTable').style.display = "none";
	    var _signMinDiv = document.getElementById('signMinDiv');
	    _signMinDiv.style.display = "";
	    _signMinDiv.style.height = "100%";
	}
	
	function getOperType(){
		var eles = document.getElementsByName("auditOption");
		for(var i = 0 ; i < eles.length; i++){
			if(eles[i].checked)
				return eles[i].value;
		}
		return  'publish';
	}
	
	function submitCheck(){
		var checkRadioArr = document.all.checkMindRadio;
		var flag = "";
		for( var i = 0 ; i < checkRadioArr.length ; i++ ){
			if(checkRadioArr[i].checked){
				flag = checkRadioArr[i].value;
				break;
			}
		}
		if(document.all.checkMind.value.length>150){
	  		alert(v3x.getMessage("InquiryLang.inquiry_checkmind_too_long", 150));
	  		document.all.checkMind.focus();
	  		return false;
	    }
	    
		//var dialogArguments = top.window.dialogArguments;
		var opener = parent.opener;
		//if(dialogArguments){
		if(parent.window.dialogArguments || parent.window.opener){
			mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}&close=close";
			document.mainForm.target="checkDetailHidden";
		}else{
			mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}&systemMessage=${systemMessage}";
		}
		document.getElementById("B1").disabled = true;
		mainForm.submit();
		//firefox可能会在返回前关闭
		/* try{
            if(parent.window.dialogArguments){
                parent.window.dialogArguments.callbackOfPendingSection();
            }
          }catch(e){
          }  */
		
	}
		
	function closeAndRefresh() {
        try{
        	//工作桌面快速处理刷新 这个方法不管是首页消息还是工作桌面点击打开都能调用？
            if (window.top.opener.getCtpTop && window.top.opener.getCtpTop().refreshDeskTopPendingList) {
               window.top.opener.getCtpTop().refreshDeskTopPendingList();
            }
        	if(parent.window.dialogArguments && parent.window.dialogArguments.callbackOfPendingSection){
                parent.window.dialogArguments.callbackOfPendingSection();
            }else if (parent.window.opener && parent.window.opener.reFlesh) {
                window.getA8Top().close();
                parent.window.opener.reFlesh();
            }else{
                window.getA8Top().close();
            }
          }catch(e){
        	  window.getA8Top().close();
          }
    }
	function cancelAudit(){
	    var systemFlag = document.getElementById("messageFlag").value;
        if(parent.window.dialogArguments && parent.window.dialogArguments.callbackOfPendingSection){
            parent.window.dialogArguments.callbackOfPendingSection();
        }else if(systemFlag == "message"){
            window.getA8Top().close();
        }else{
            parent.parent.location.reload();
        }
	}
</script>
</head>
<body scroll="no" class="precss-scroll-bg" onload="initLoad()">
	<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<script type="text/javascript">showMinPanels();</script>
	</div>
<form name="mainForm" action="${basicURL}?method=user_vote&tid=${tid}" method="post">
<input type="hidden" id="messageFlag" name="messageFlag" value="${systemMessage}">
	<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="25" valign="top" class="sign-button-bg"><script
				type="text/javascript">showPanels();</script></td>
			<td align="right" style="padding-right: 10px" class="sign-button-bg"></td>
		</tr>
		<tr>
			<td colspan="2" height="100%"  valign="top">
			<div class="scrollList" style="padding: 10px;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr id="handleTR" style="display:none">
						<td>
						
							<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td>
												 <fmt:message key='inquiry.check.mind' />:&nbsp;&nbsp;
												 <c:choose>
												 <c:when test="${sbcompose.inquirySurveybasic.censor==4 || sbcompose.inquirySurveybasic.censor==null}">
												  <label for="checkMindPublic" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindPublic" checked value="2" ${ sbcompose.inquirySurveybasic.censor!=4 ? 'disabled' : '' }><fmt:message key='inquiry.issue.straight' /></label>&nbsp;&nbsp;
												  <label for="checkMindPass" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindPass" value="0" ${ sbcompose.inquirySurveybasic.censor!=4 ? 'disabled' : '' }><fmt:message key='inquiry.audit.pass.label' /></label>&nbsp;&nbsp;
												  <label for="checkMindForbid" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindForbid" value="1" ${ sbcompose.inquirySurveybasic.censor!=4 ? 'disabled' : '' }><fmt:message key='audit.back' bundle='${v3xCommonI18N}'/></label>
												 </c:when>
												 <c:otherwise>
												  <label for="checkMindPublic" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindPublic" value="8" ${sbcompose.inquirySurveybasic.censor==8 ? 'checked' : ''} disabled><fmt:message key='inquiry.issue.straight' /></label>&nbsp;&nbsp;
												  <label for="checkMindPass" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindPass" value="2" ${sbcompose.inquirySurveybasic.censor==2 ? 'checked' : ''} disabled><fmt:message key='inquiry.audit.pass.label' /></label>&nbsp;&nbsp;
												  <label for="checkMindForbid" style="margin-left:-10px;"><input type="radio" name="checkMindRadio" id="checkMindForbid" value="1" ${sbcompose.inquirySurveybasic.censor==1 ? 'checked' : ''} disabled><fmt:message key='audit.back' bundle='${v3xCommonI18N}'/></label>&nbsp;&nbsp;
												 </c:otherwise>
												 </c:choose>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td style="padding: 10px 0px 10px 10px;">
										<textarea rows="5" cols="80" class="input-100per" ${sbcompose.inquirySurveybasic.censor==8 ? 'disabled' : '' } ${ sbcompose.inquirySurveybasic.censor!=4 ? 'readonly' : '' }  name="checkMind" id="checkMind">${sbcompose.inquirySurveybasic.checkMind}</textarea>
										<div style="color: green">
										<fmt:message key="guestbook.content.help" bundle="${v3xMainI18N}">
											<fmt:param value="150" />
										</fmt:message>
										</div>
									</td>
								</tr> 
								<tr>
									<td height="42" align="right">
										<input type="button" id="B1" onclick="submitCheck();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" name="B1" class="button-default-2" ${ sbcompose.inquirySurveybasic.censor!=4 ? 'disabled' : '' }>&nbsp;&nbsp; 
										<input type="button" onclick="cancelAudit();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name="B2" class="button-default-2" ${ sbcompose.inquirySurveybasic.censor!=4 ? 'disabled' : '' } >&nbsp;&nbsp;&nbsp;&nbsp;
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<iframe name="checkDetailHidden" width="0" height="0" frameborder="0"></iframe>
				</div>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>