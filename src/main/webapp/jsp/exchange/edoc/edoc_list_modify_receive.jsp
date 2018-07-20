<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../exchangeHeader.jsp"%>

<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

<%---------------- 签收页面  -------------------%>
<script type="text/javascript">

//在公文交换已签收列表中，点击其中某一条记录，签收明细显示出来，上下结构显示出来
<c:if test="${param.upAndDown == 'true'}">
	getDetailPageBreak();
</c:if>

function oprateSubmit(){	
	var subBtn=document.getElementById("subBtn");
	if(subBtn){
		subBtn.disabled = true;
	}
	var obj = document.getElementById("detailForm");
	if(!checkForm(obj)){
		if(subBtn){
			subBtn.disabled = false;
		}
		return;//验证form
	}
	var recNo = document.getElementById("recNo");
	var isRecNoEmpty = true;
	<%--
	if("${isG6Ver}" != "true"){
		if(recNo==null || recNo.value=="" || recNo.value.replace(/\s*/,"") == ""){
			alert(_("ExchangeLang.exchange_receiveSerialNumber_empty"));
			if(subBtn){
				subBtn.disabled = false;
			}
			return false;
		}else{
			isRecNoEmpty = false;
		}
	}--%>


	if(recNo==null || recNo.value=="" || recNo.value.replace(/\s*/,"") == ""){
	}else{
		isRecNoEmpty = false;
	}
	
	
	//G6 V1.0 SP1后续功能_自定义签收编号start
	//检查签收编号是否存在。
	if(!isRecNoEmpty){
		var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "isEditEdocMarkExist", false);
		requestCaller.addParameter(1,'String',recNo.value);
		requestCaller.addParameter(2,'String',"${bean.id}");
		requestCaller.addParameter(3,'String',document.getElementById("accountId").value);
		requestCaller.addParameter(4,'String',document.getElementById("depId").value);
		isCanBeRegisted = requestCaller.serviceRequest();
		if(isCanBeRegisted == "true"){
			alert(v3x.getMessage("ExchangeLang.exchange_mark_repeat"));
			if(subBtn){
				subBtn.disabled = false;
			}
			return;
		}
	}
	  
		//G6 V1.0 SP1后续功能_自定义签收编号end
	var registerUserId = document.getElementById("registerUserId");
	if(registerUserId==null || registerUserId.value ==""){
		alert(_("ExchangeLang.exchange_register_empty"));
		if(subBtn){
			subBtn.disabled = false;
		}
		return false;
	}
	var flag;
	if("${isG6Ver}" == "true" && "${isAutoRegister}" == "false"){
		flag = isEdocRegisterRole(registerUserId.value);
	}else if("${isG6Ver}" == "true" && "${isAutoRegister}" == "true"){
		flag = isEdocCreateRole(registerUserId.value,"V5-G6");
	}
	else{
		flag = isEdocCreateRole(registerUserId.value,"V5-A8");
	}
	
	if(flag==false) {
		if(subBtn){
			subBtn.disabled = false;
		}
	  	return false;
	}
	obj.submit();		
}


//G6 V1.0 SP1后续功能_签收时自动登记功能_判断签收单位是否有分发人
function isAccountHasEdocSendPerson() {	 
	var exchangeAccountId=document.getElementById("exchangeAccountId").value;
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "hasDistributeUserByAccountId",false);
	requestCaller.addParameter(1, "Long", exchangeAccountId); 
	var ds = requestCaller.serviceRequest();
  	if(ds!="true") {
  		alert(v3x.getMessage("edocLang.edoc_isAccountHasEdocSendPerson_alert"));
    	return false;
  	}
  	return true;
}


function isEdocCreateRole(regUserId,version) {	
  	var exchangeAccountId=document.getElementById("exchangeAccountId").value;
  	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "isEdocCreateRole",false);
 	requestCaller.addParameter(1, "Long", regUserId); 
 	requestCaller.addParameter(2, "Long", exchangeAccountId); 
 	//OA-13942  应用检查---在待签收、已签收中变更登记人，变更时没有提示，且被变更的这个人员都没有给公文管理的资源，变更时也没做是否这个人有登记的权限  
 	if(version == "V5-A8"){
 		requestCaller.addParameter(3, "String", "F07_recRegister"); 
 	}else if(version == "V5-G6"){
 		requestCaller.addParameter(3, "String", "F07_recListFenfaing");
 	}
 	var ds = requestCaller.serviceRequest();
  	if(ds!="true") {
    	var selPerName=document.getElementById("memberId").value;
    	if(version == "V5-A8"){
    		alert(_("ExchangeLang.alert_no_edocRegisterRole",selPerName));
        }else if(version == "V5-G6"){
        	alert(_("edocLang.alert_no_edocDistributeRole",selPerName));
        }
    	return false;
  	}
  	return true;	  
}

/*是否有G6收文登记权限*/
function isEdocRegisterRole(regUserId) {	
  	var exchangeAccountId=document.getElementById("exchangeAccountId").value;
  	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "isEdocCreateRole",false);
 	requestCaller.addParameter(1, "Long", regUserId); 
 	requestCaller.addParameter(2, "Long", exchangeAccountId); 
 	requestCaller.addParameter(3, "String", "F07_recListRegistering"); 
  	var ds = requestCaller.serviceRequest();
  	if(ds!="true") {
    	var selPerName=document.getElementById("memberId").value;
  		alert(_("ExchangeLang.alert_no_edocRegisterRole",selPerName));
    	return false;
  	}
  	return true;	  
}



function relationSend(){
	var url = "edocController.do?method=relationNewEdoc&recEdocId=${recEdocId}&recType=${recType}&date="+new Date();
    var rv = v3x.openWindow({
    	url: url,
		height : 600,
		width  : 600 
  	 });
  	if (rv == "true") {
  	  getA8Top().reFlesh();
	}
}

function initParentTitle(){
	//GOV-4925 【发文管理-分发】和【收文管理-签收】列表里打开标题有空格的公文时，IE标题里显示有&nbsp字符
    parent.document.title="<v3x:out value='${bean.subject}' escapeJavaScript='true' />";
}

//GOV-4894 公文管理，发文分发后，可以多人同时打开收文签收界面，非第一个点签收的人都报脚本错误
function unlockRecieveEditForm(recieveId){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "deleteUpdateRecieveObj",false,"GET",false);
	requestCaller.addParameter(1, "String", recieveId);  
	if((arguments.length>1))
	{
		requestCaller.addParameter(2, "String", arguments[1]);	
	}  
	requestCaller.serviceRequest();	
}


//GOV-4894 公文管理，发文分发后，可以多人同时打开收文签收界面，非第一个点签收的人都报脚本错误
function updateRecieveForm(recieveId){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "editRecieveObjectState",false);
	  requestCaller.addParameter(1, "String", recieveId);  
	  var ds = requestCaller.serviceRequest();
	
	  if(ds.get("curEditState")=="true")
	  { 
		  //将签收按钮置灰
		  //$("#sendButton input[@type=button]").each(function(){
		  //	this.disabled = true;
		  //});
		  if(document.getElementById("subBtn")){
		      document.getElementById("subBtn").style.display="none";
		  }
		  if(document.getElementById("subBtn2")){
		      document.getElementById("subBtn2").style.display="none";
		  }
		  if(document.getElementById("subBtn3")){
		      document.getElementById("subBtn3").style.display="none";
		  }
		  if(document.getElementById("subBtn4")){
		      document.getElementById("subBtn4").style.display="none";
		  }
		  alert("公文收发员["+ds.get("userName")+"]正在处理!");	 
	  	  return true; 
	  }
	  //新建文档，不需要更新
	  if(ds.get("lastUpdateTime")==null){return false;}  
	
	  return false;
}

function _init_(){
    
    initParentTitle();
    updateRecieveForm('${param.id}');
    
    var relSends = "${relSends}";
    if(relSends == "haveMany"){
        document.getElementById("relationNew").style.display="block";
    }
      
    resizeMainTdHeight();

    $(window).resize(function(){
        resizeMainTdHeight();
    });
}

function resizeMainTdHeight(){
    var mainBodyHeight = document.getElementById("content_main_div").clientHeight;
    mainBodyHeight = mainBodyHeight - 40;
    $("#receive_div").height(mainBodyHeight);
}

</script>
</head>

<body style="overflow: hidden;" onload="_init_()" onUnload="unlockRecieveEditForm('${param.id}');">

<div id="content_main_div" class="newDiv" style="height:100%; overflow:hidden;">
<input type="hidden" name="category" id="category" value="${category}" >

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td height="8"></td>
	</tr>
	
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td id="typeLabel" name="typeLabel" class="categorySet-title" width="80" nowrap="nowrap">
						<c:if test="${param.from != 'tobook'}">
							<fmt:message key="exchange.lable.rec" />
						</c:if>
						<c:if test="${param.from == 'tobook'}">
							<fmt:message key='common.toolbar.state.register.label' bundle='${v3xCommonI18N}'/>	
						</c:if>
					</td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td id="receive_div_td" class="categorySet-head">
			<div id="receive_div" class="categorySet-body overflow_auto" style="padding:0;border-bottom:1px solid #a0a0a0;">
	           <div id="relationNew" align="right" style="display:none;"><a href="#" onclick="relationSend()" ><font color=red>关联发文</font></a></div>
    			<%@include file="edoc_receive_detail.jsp" %>		
			</div>		
		</td>
	</tr>
</table>

</div>
</body>
</html>
