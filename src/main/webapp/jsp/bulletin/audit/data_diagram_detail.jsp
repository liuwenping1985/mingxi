<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<title></title>
<html:link renderURL="/bulData.do" var="bulDataURL" />
<link rel="stylesheet" href="/seeyon/skin/default/skin.css">
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
<!--
	var panels = new ArrayList();
	panels.add(new Panel("handle", '<fmt:message key='bul.data.deal'/>', "showPrecessArea(220)"));
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
		var thediv = document.getElementsByTagName('div');
		if(thediv)
			for(var i=0;i<thediv.length;i++){
				if(thediv[i].className=='sign-min-label'){
				var inhtml='<br/><fmt:message key='bul.data.deal'/>';
				thediv[i].innerHTML="";
				thediv[i].className="arrow_2_l";
				thediv[i].innerHTML=inhtml;
				}
			}
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

	function saveForm() {
		if(checkEditWindowIsOpen && !checkEditWindowIsOpen('bulAuditEdit')){
			return false;
		}
		if(!checkForm($('dataForm')))
			return false;
		//数据有效性检查
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "dataExist", false);
		requestCaller.addParameter(1, "Long", '${bean.id}');
			
		var existflag = requestCaller.serviceRequest();
		if(existflag == 'false'){
			alert(v3x.getMessage("bulletin.data_deleted"));		
			//当前所在位置为上列表下详图结构
			parent.parent.getA8Top().document.getElementById('main').src=parent.parent.getA8Top().contentFrame.mainFrame.location;
			return;
		}
		
		var operType = getOperType();
	    $('form_oper').value=operType;
	  	document.getElementById("submitBtn").disabled=true;
	  	$('dataForm').submit();
	}
	
	function goHead(){
		history.go(-2);
	}
	
	function cancelAudit(){
		//上列表下详图结构中，只需将detailFrame返回为说明页面即可
		window.parent.parent.detailFrame.location.href = '${commonDetailURL}';
	}
	
	function preLock(id){
		var action="news.lockaction.audit";
		//进行解锁
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "lock", false);
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
		//newslock[0]="公告锁"
	}
	
	function unlock(id){
		//进行解锁
		var depObj = document.getElementById("department");
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		} catch (ex1) {
			alert("Exception : " + ex1);
		}

	}
//-->
</script>
</head>
<body scroll="no" class="precss-scroll-bg" onkeydown="listenerKeyESC()" onload="lock('${bean.id}');initLoad('handle')" onunload="unlock('${bean.id }');">
	<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<script type="text/javascript">showMinPanels();</script>
	</div>
<form action="${bulDataURL}" method="post" id="dataForm" name="dataForm">
	<input type="hidden" name="method" id="method" value="auditOper" />
	<input type="hidden" name="id" id="id" value="${bean.id}" />
	<input type="hidden" name="form_oper" id="form_oper" value="" />
	<input type="hidden" name="hiddenId" id="hiddenId" />	
	<input type="hidden" name="from" id="from" value="${param.from}" />
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
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
                                    <td>
                                      <%-- 审核编辑功能代码判断 --%> 
                                      <%@ include file="bulAuditEdit.jsp"%>
                                    </td>
                                </tr>
								<tr><td>
									<label for="auditOption1">
										<input type="radio" id="auditOption1" value="publish" name="auditOption" checked><fmt:message key="label.accept2" />
									</label>
									<label for="auditOption2">
										<input type="radio" id="auditOption2" value="audit" name="auditOption"><fmt:message key="label.accept" />
									</label>
									<label for="auditOption3">
										<input type="radio" id="auditOption3" value="noaudit" name="auditOption"><fmt:message key="label.noaccept" />
									</label>
								</td></tr>
								<tr><td style="padding: 10px 0;">
								<textarea id="auditAdvice" name="auditAdvice" rows="10" maxSize="150" validate="maxLength" inputName="<fmt:message key="bul.data.auditAdvice" />"
										  style="width:100%;height:180px;">${bean.auditAdvice}</textarea>
								</td></tr>
								
								<tr>
									<td align="right">
								      	<input type="button" id="submitBtn" onclick="saveForm();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2"/>&nbsp;&nbsp;
								      	<input type="button" id="cancelBtn" onclick="cancelAudit();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" />&nbsp;&nbsp;&nbsp;&nbsp;
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
			parent.location.reload(true);
		}	
		var auditAdviceEle = document.getElementById("auditAdvice");
		if (auditAdviceEle != null && document.body.clientHeight < 400) { 
			auditAdviceEle.style.height = (document.body.clientHeight - 150 ) + "px";
		}
	} catch(e){}
</script>

</body>
</html>