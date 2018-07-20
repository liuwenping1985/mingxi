<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<title></title>
<html:link renderURL="/bulData.do" var="bulDataURL" />
<%@ include file="../include/header.jsp"%>
<script>
<!--
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

	function saveForm(){
		if(checkEditWindowIsOpen && !checkEditWindowIsOpen('newsAuditEdit')){
			return false;
		}
		
		if(!checkForm(document.getElementById("dataForm")))
			return false;
	
		// 數據有效性检查
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "dataExist", false);
		requestCaller.addParameter(1, "Long", '${bean.id}');
			
		var existflag = requestCaller.serviceRequest();
		if(existflag == 'false'){
			alert(v3x.getMessage("bulletin.data_deleted"));
			parent.parent.location.reload(true);//.href = '${bulDataURL}?method=auditListMain&from=${param.from}';				
			return;
		}
		
		var operType = getOperType();
		document.getElementById('form_oper').value = operType;
    	document.getElementById("submitBtn").disabled=true;
    	document.getElementById("dataForm").submit();
	}
	
	function goHead(){
		history.go(-2);
	}
		
	function cancelAudit(){		
		parent.parent.detailFrame.location.href = '${commonDetailURL}';
	}
	
	function preLock(id) {
		var action="news.lockaction.audit";
		//进行加锁
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "lock", false);
			requestCaller.addParameter(1, "Long", id);
			requestCaller.addParameter(2, "String",action);
			var ds= requestCaller.serviceRequest();
			//alert(ds)
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}

	}
	
	function lock(id){
		preLock(id)
		//进行加锁
		//newslock[0]="新闻锁"
	}
	
	//进行解锁
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
//-->
</script>
</head>
<body scroll='no'  onkeydown="listenerKeyESC()" onload="lock('${bean.id}');initLoad('handle')" onunload="unlock('${bean.id}')" class="precss-scroll-bg">
<div style="width:100%;height:100%;overflow:auto">
	<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<script type="text/javascript">showMinPanels();</script>
	</div>
<form action="${newsDataURL}" method="post" id="dataForm" name="dataForm">
	<input type="hidden" id="method" name="method" value="auditOper" />
	<input type="hidden" id="id" name="id" value="${bean.id}" />
	<input type="hidden" id="form_oper" name="form_oper" value="" />	
	<input type="hidden" id="from" name="from" value="${param.from}" />
	<input type="hidden" name="hiddenId" id="hiddenId" />
	<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="25" valign="top" class="sign-button-bg"><script
				type="text/javascript">showPanels();</script></td>
			<td align="right" style="padding-right: 10px" class="sign-button-bg"></td>
		</tr>
		<tr>
			<td colspan="2" height="100%"  valign="top">
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
                                        <fmt:message key="news.share" /><fmt:message key="label.colon" />
                                        <label for="shareWeixin">
                                            <input type="checkbox" name="shareWeixin" id="shareWeixin" disabled ${v3x:outConditionExpression(bean.shareWeixin, 'checked', '')}/>
                                            <span><fmt:message key="news.share.weixin" /></span>
                                        </label>
                                    </td>
                                </tr>
								<tr>
									<td>
										<table width="100%"  border="0" cellpadding="0" cellspacing="0">
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
										<textarea id="auditAdvice" name="auditAdvice" rows="5" maxSize="150" validate="maxLength" inputName="<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}" />" style="width:100%;height:170px;">${bean.auditAdvice}</textarea>
									</td>
								</tr>
								<tr id="attachmentTr" style="display: none;">
									<td nowrap="nowrap" width="50" class="font-12px">
									    <b style="display:block;" class="margin_b_5"><fmt:message key="label.attachments" />:&nbsp;</b>
										<v3x:attachmentDefine attachments="${attachments}"  />	   
										<script type="text/javascript">					
											showAttachment('${bean.id}', 0, 'attachmentTr', '');					
										</script>
									</td>
	
								</tr>
								<tr id="attachment2Tr" style="display: none">
									<td nowrap="nowrap" width="100%" class="font-12px">
									    <b style="display:block;" class="margin_b_5"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b>
										<v3x:attachmentDefine attachments="${attachments}"  />	   
										<script type="text/javascript">					
											showAttachment('${bean.id}',2, 'attachment2Tr', '');					
										</script>
									</td>
								</tr>  
								<tr>
									<td align="right">
								      	<input type="button" id="submitBtn" onclick="saveForm();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2"/>&nbsp;&nbsp;
								      	<input type="button" id="cancelBtn" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="cancelAudit();"/>&nbsp;&nbsp;&nbsp;&nbsp;
								   </td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<iframe id="hiddenIframe" name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
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
			parent.parent.parent.location.href = '${newsDataURL}?method=auditListMain&from=${param.from}&spaceId=${param.spaceId}';
		}
	}catch(e){}
</script>
</div>
</body>
</html>
