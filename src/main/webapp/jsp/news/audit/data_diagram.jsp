<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<title></title>
<html:link renderURL="/bulData.do" var="bulDataURL" />
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	var panels = new ArrayList();
	panels.add(new Panel("handle", '<fmt:message key='news.data.deal'/>', "showPrecessArea(220)"));
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
		    parent.document.all.zy.cols = "*," + width;
		}catch(e){}
		
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
	
	function saveForm(){
		if(checkEditWindowIsOpen && !checkEditWindowIsOpen('newsAuditEdit')){
			return false;
		}
		if(!checkForm($('dataForm')))
			return false;
		// 数据有效性检查
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager","dataExist", false);
			requestCaller.addParameter(1, "Long", '${bean.id}');
				
		var existflag = requestCaller.serviceRequest();
			if(existflag == 'false'){
				alert(v3x.getMessage("bulletin.data_deleted"));
				window.getA8Top().close();
				return;
			}
			
		var operType = getOperType();
		document.getElementById("form_oper").value=operType;
		document.getElementById("hiddenId").value= "hiddenId";
		document.dataForm.target = "hiddenIframe";
		document.getElementById("b1").disabled=true;
		document.getElementById("dataForm").submit();
	}
	
	function goHead(){
		document.getElementById("method").value= "auditListMain";
		document.dataForm.target = "hiddenIframe";
		document.getElementById("hiddenId").value= "hiddenId";
		$('dataForm').submit();		
	}
	function closeAndRefresh() {
	    try{
	        //工作桌面快速处理刷新 这个方法不管是首页消息还是工作桌面点击打开都能调用？
            if (window.top.opener.getCtpTop && window.top.opener.getCtpTop().refreshDeskTopPendingList) {
               window.top.opener.getCtpTop().refreshDeskTopPendingList();
            }
            if(parent.window.dialogArguments && parent.window.dialogArguments.callback){
            	parent.window.dialogArguments.callback();
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
	
	function unlock(id){
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		}catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
	
</script>
</head>
<body scroll="no" class="precss-scroll-bg" onload="initLoad('handle')" onkeydown="listenerKeyESC()" onunload="unlock('${bean.id}')">
	<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<script type="text/javascript">showMinPanels();</script>
	</div>
<form action="${newsDataURL}" method="post" id="dataForm" name="dataForm">
	<input type="hidden" name="method" value="auditOper" />
	<input type="hidden" name="id" value="${bean.id}" />
	<input type="hidden" name="form_oper" id="form_oper" value="" />	
	<input type="hidden" name="from" value="${param.from}" />
	<input type="hidden" name="hiddenId" id="hiddenId" />
	<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="25" valign="top" class="sign-button-bg"><script
				type="text/javascript">showPanels();</script></td>
			<td align="right" style="padding-right: 10px" class="sign-button-bg"></td>
		</tr>
		<tr>
			<td colspan="2" height="100%"  valign="top">
			<div class="scrollList" style="overflow-y:hidden;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr id="handleTR" style="display:none">
						<td>
						
							<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
                                    <td>
                                      <%-- 审核编辑功能代码判断 --%> 
                                      <%@ include file="newsAuditEdit.jsp"%>
                                    </td>
                                </tr>
								
								<tr>
									<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td>
												<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}"  /><fmt:message key="label.colon" />
												<label for="auditOption1">
													<input type="radio" id="auditOption1" value="publish" name="auditOption" checked><fmt:message key="label.accept2" />
												</label>
												<label for="auditOption2">
													<input type="radio" id="auditOption2" value="audit" name="auditOption"><fmt:message key="label.accept" />
												</label>
												<label for="auditOption3">
													<input type="radio" id="auditOption3" value="noaudit" name="auditOption"><fmt:message key="label.noaccept" />
												</label>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td style="padding: 10px 0;">
										<textarea id="auditAdvice" name="auditAdvice" rows="5" maxSize="150" validate="maxLength" inputName="<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}" />" style="width:100%;height:200px;">${bean.auditAdvice}</textarea>
									</td>
								</tr>
								<tr id="attachmentTr" style="display: none;">
												<td nowrap="nowrap" valign="top">
												<b style="display:block;"><fmt:message key="label.attachments" />:&nbsp;</b>
												  <v3x:attachmentDefine	attachments="${attachments}" />		   
													<script type="text/javascript">					
														showAttachment('${bean.id}', 0, 'attachmentTr', '');					
													</script>
												</td>
											 
								</tr>
								<tr id="attachment2Tr" style="display: none">
									<td nowrap="nowrap" valign="top">
									    <b style="display:block;"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b>
										<v3x:attachmentDefine attachments="${attachments}"  />	   
										<script type="text/javascript">					
											showAttachment('${bean.id}',2, 'attachment2Tr', '');					
										</script>
									</td>
								</tr>   
								<tr>
									<td align="right">
								      	<input id="b1" name="b1"  type="button" onclick="saveForm();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2"/>&nbsp;&nbsp;
								      	<input id="b2" name="b2"  type="button" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="closeAndRefresh();"/>&nbsp;&nbsp;&nbsp;&nbsp;
								   </td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<iframe name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
				</div>
			</td>
		</tr>
	</table>
	</form>
<script type="text/javascript">
			var exist = '${dataExist}';
		try{
		if('false' == exist){	
			alert(v3x.getMessage("bulletin.data_deleted"));
			isFormSumit = true;
			if(window.dialogArguments){
				window.close();
			}else {
				parent.parent.parent.location.href = '${newsDataURL}?method=auditListMain&from=${param.from}&spaceId=${param.spaceId}';
			}
		}}catch(e){}
		
			
	if('${bean.state}' != '10'){
		document.getElementById("auditOption1").disabled = true;
		document.getElementById("auditOption2").disabled = true;
		document.getElementById("auditOption3").disabled = true;
		
		if('${bean.state}' == '30')
			document.getElementById("auditOption1").checked = true;
		if('${bean.state}' == '20')
			document.getElementById("auditOption2").checked = true;
		if('${bean.state}' == '40')
			document.getElementById("auditOption3").checked = true;
			
		document.getElementById("auditAdvice").readOnly = true;
			
		document.getElementById("b1").disabled = true;
	}
</script>
</body>
</html>
