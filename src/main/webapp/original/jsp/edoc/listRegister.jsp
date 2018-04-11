<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/exchange/js/exchange.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var edocType = ${edocType};
if(${param.recListType == 'registerDone'}){
	try {
		parent.treeFrame.changeHandler("registerDone");
	} catch(e) {}
}

//列表类型
//var listType = "${param.list}";
var listType = "${v3x:escapeJavascript(param.recListType)}";
var list = "${param.listType}";
//登记状态
var state = ${state};
//登记类型
var registerType = ${registerType};
//外来单位能否修改登记
var canUpdateContent = ${canUpdateContent};



//新建时加载登记数据
function newEdocRegister(comm,docRegisterType) {
	var checkObj;
	var id_checkbox = document.getElementsByName("id");
	if (!id_checkbox) {
		return;
	}
	/*if(!$.browser.msie){
		alert(v3x.getMessage("edocLang.isNotIe"));
		return;
	}*/
	var title = "";
	var checkedNum = 0;
	var distributeState = -1;
	var len = id_checkbox.length;
	for (var i = 0; i < len; i++) {
		if (id_checkbox[i].checked) {            
			checkedNum++;
			if(checkedNum==1){
				checkObj=id_checkbox[i];
			}
			//已登记，已分发
			if(checkObj.getAttribute("state")==2 && checkObj.getAttribute("distributeState")==2 && comm=="modify") {
				title = checkObj.getAttribute("subject");
				distributeState = 2;
				break;
			}
			if(checkObj.getAttribute("state")==2 && checkObj.getAttribute("distributeState")==0 && comm=="modify") {
				title = checkObj.getAttribute("subject");
				distributeState = 0;
				break;
			}
	    }
	}
	//如果是电子登记，那么需要选择一条待登记数据
	if(1 == docRegisterType){
	    if(checkedNum==0) {
	        if(${registerType}==0 || ${registerType}==1 || ${registerType}==2) {//电子登记
	            if(comm == "create" || comm=="edit" || comm == "modifyRegister") {
	            	alert(_("edocLang.edoc_alertDontSelectMulti"));
	              	return;
	            }
	        } 
	        if(comm=="edit" || comm=="modify") {
	        	alert(_("edocLang.edoc_alertDontSelectMulti"));
	          	return;
	        }
	    }
	    var isRetreat = checkObj.getAttribute("isRetreat");
	    if(isRetreat == 1)comm = "edit";
		    
	}
    if(checkedNum>1) {
    	if(comm=="edit" || comm == "modifyRegister") {
        	alert(_("edocLang.edoc_alertOnlyOneSelectMultiToEdit"));
          	return;
        } else if(comm=="modify" || comm=="create") {
        	alert(_("edocLang.edoc_alertOnlyOneSelectMultiToRegister"));
          	return;
        }
    }

    /*
   	 *	已登记时，编辑修改，需要判断是否已经分发了
   		已经分发就不能编辑了
    */
	if(comm == "modifyRegister"){
		var distributeEdocId =  checkObj.getAttribute("distributeEdocId");
		if(distributeEdocId != -1){
			alert("公文已经收文分发了，不能再编辑修改了");
			return;
		}
	}

    /**
    	下面这个分支暂时没有用到
    */
    if(comm == "modify") {//登记后进行修改，所选择的项已经分发
		if(!docRegisterType){
		    docRegisterType = checkObj.getAttribute("registerType");
		}
        
    	if(title != "") {
        	if(distributeState==2) {
				alert(_("edocLang.edoc_alertEdocRegisterLeft") +title+ _("edocLang.edoc_alertEdocRegisterRightEdit"));
        	} else if(distributeState==0) {
        		alert(_("edocLang.edoc_alertEdocRegisterLeft") +title+ _("edocLang.edoc_alertEdocRegisterRightEdit0"));
            }
	      	return;
        }
    }
    /*
    if(comm=="modify" || comm=="edit" || (comm=="create"&&${registerType==0||registerType==1})) {
    	previewFrame('Down'); 
    } */   
    var edocId = -1;
    var recieveId = -1;
    var sendUnitId = -1;
    var registerId = -1;
    var registerType = ${registerType};
    if(checkObj != null) {
        // xiangfan调整 取值方法 兼容FireFox;GOV-2301
    	edocId = checkObj.getAttribute("edocId");
        //本地安装的是永中office，正文类型是wps给出提示
        var isWpsBodyType = checkWpsBodyType(edocId);
        var isYoZoOffice = parent.isYoZoOffice();
        if(isWpsBodyType && isYoZoOffice){
        	//本地安装的Office环境不支持此公文正文类型的保存和发送，无法正常登记，请安装WPS或微软Office软件！
        	alert(_("edocLang.edoc_alertWpsYozoOffice"));
     	   	return;
        }
        recieveId = checkObj.getAttribute("recieveId");
        sendUnitId = checkObj.getAttribute("sendUnitId");
        registerId = checkObj.value;
        registerType = checkObj.getAttribute("registerType");
    }
    if(registerType==0) registerType = 1;
    var registerForm = $("#registerForm");
    registerForm.append("<input type='hidden' name='method' value='newEdocRegister'/>");
    registerForm.append("<input type='hidden' name='comm' value='"+comm+"'/>");
    registerForm.append("<input type='hidden' name='edocType' value='${edocType}'/>");
    if(1 == docRegisterType){
    	registerForm.append("<input type='hidden' name='recieveId' value='"+recieveId+"'/>");
        registerForm.append("<input type='hidden' name='edocId' value='"+edocId+"'/>");
    }
    registerForm.append("<input type='hidden' name='registerType' value='"+docRegisterType+"'/>");
    registerForm.append("<input type='hidden' name='sendUnitId' value='"+sendUnitId+"'/>");
    registerForm.append("<input type='hidden' name='registerId' value='"+registerId+"'/>");
    registerForm.append("<input type='hidden' name='listType' value='${listType}'/>");
    registerForm.append("<input type='hidden' name='recListType' value='${listType}'/>");
    registerForm.attr("action", genericURL+"?method=newEdocRegister");
    registerForm.submit();

}
/**
 * 检查是否是wps正文
 */
function checkWpsBodyType(edocId){
	var retValue=false;
	if(edocId && edocId != ""){
		var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "getBodyType",false);
		requestCaller.addParameter(1, "String", edocId);
		var tempBodyType = requestCaller.serviceRequest();
		if(tempBodyType && (tempBodyType == "WpsWord" || tempBodyType == "WpsExcel")){
			retValue = true; 
		}
	}
	return retValue;
}

//撤销
function cancelRegister() {
	var checkObj;
	var id_checkbox = document.getElementsByName("id");
	if (!id_checkbox) {
		return;
	}
	var checkedNum = 0;
	var objs = [];
	var len = id_checkbox.length;
	for (var i = 0; i < len; i++) {
		if (id_checkbox[i].checked) {
			if(id_checkbox[i].registerType==1 && id_checkbox[i].recieveId!=-1) {//电子登记不允许撤销
				alert("<fmt:message key='edoc.noRevoke.electronic.documents'/>");
				return;
			}      
			objs[checkedNum] = id_checkbox[i];
			checkedNum ++;
			if(checkedNum==1){
				checkObj=id_checkbox[i];
			}
	    }
	}
    if(checkedNum==0) {
		alert(_("edocLang.edoc_alertCancelItem"));
      	return;
    }

    if(confirm("<fmt:message key='edoc.sure.revoke.document'/>")) {
	    var delform = $("#registerForm");
	   	var title = "";
		for(var i=0; i<objs.length; i++) {
	      	delform.append("<input type='hidden' name='registerId' value='"+objs[i].value+"'/>");
	      	delform.append("<input type='hidden' name='registerType' value='"+objs[i].registerType+"'/>");
		}
	    delform.append("<input type='hidden' name='edocType' value='${edocType}'/>");
	    delform.append("<input type='hidden' name='method' value='cancelRegister'/>");
	    delform.append("<input type='hidden' name='listType' value='${listType}'/>");
	    delform.attr("action", genericURL+"?method=cancelRegister");
	
	    delform[0].submit();
    }
}

function deleteRegister() {
	var checkObj;
	var id_checkbox = document.getElementsByName("id");
	if (!id_checkbox) {
		return;
	}
	var checkedNum = 0;
	var objs = [];
	var len = id_checkbox.length;
	for (var i = 0; i < len; i++) {
		if (id_checkbox[i].checked) {      
			objs[checkedNum] = id_checkbox[i];
			checkedNum ++;
			if(checkedNum==1){
				checkObj=id_checkbox[i];
			}
	    }
	}
    if(checkedNum==0) {
		alert(_("edocLang.edoc_alertDontSelectMulti"));
      	return;
    }
    if(confirm(_("edocLang.edoc_confirmDeleteItem"))) {
        var delform = $("#registerForm");
    	var title = "";
        for(var i=0; i<objs.length; i++) {
        	delform.append("<input type='hidden' name='registerId' value='"+objs[i].getAttribute("value")+"'/>");
        	delform.append("<input type='hidden' name='registerType' value='"+objs[i].getAttribute("registerType")+"'/>");
        	var tempDistState = objs[i].getAttribute("distributeState");
			if(objs[i].getAttribute("state")==2 && tempDistState!=2 && tempDistState!=0) {//已登记，未分发
				title = objs[i].getAttribute("subject");
				break;
			}
        }
        if(title != "") {
        	alert(_("edocLang.edoc_alertEdocRegisterLeft") +title+ _("edocLang.edoc_alertEdocRegisterRightDelete"));
			delform.html("");
			return;
        }
        delform.append("<input type='hidden' name='edocType' value='${edocType}'/>");
        delform.append("<input type='hidden' name='method' value='deleteRegister'/>");
        delform.append("<input type='hidden' name='listType' value='${listType}'/>");
        delform.attr("action", genericURL+"?method=deleteRegister");

        delform[0].submit();
    }
}

//展示登记信息
function showRegisterDetail(id, recieveId, registerState) {
	if(registerState == '1') {
		parent.detailFrame.window.location = 'exchangeEdoc.do?method=edit&id='+recieveId+'&modelType=received&from=tobook';
	}else if(registerState == '3'){
		parent.detailFrame.window.location = 'exchangeEdoc.do?method=edit&id='+recieveId+'&modelType=received&from=tobook';
	} else {
		parent.detailFrame.window.location = genericURL + "?method=edocRegisterDetail&registerId="+id;  
	}  
}


function openRegisterDetail(id, recieveId, registerState,edocId) {
  	var url = '';
  	if(registerState == '1') {  
  	  	//lijl注销GOV-3287.【收文管理-待登记】在列表里单击一条记录，应该是实现签收单。选中了一条记录，然后点"登记"按钮，才应该进入公文登记页面。现在单击和点登记按钮一样了。改过来。
    	//url = genericURL+'?method=newEdocRegister&comm=create&edocId='+edocId+'&registerId='+id+'&recieveId='+recieveId+'&registerType=1&listType=${listType}&edocType=${edocType}';
    	url = "exchangeEdoc.do?method=edit&modelType=received&id="+recieveId+"&newDate="+new Date().getTime()+"&nodeAction=swWaitRegister";
    	previewFrame('Down');
    	//window.location = url;  
  	} else {
  		url = genericURL+'?method=edocRegisterDetail&forwardType=registered&registerId='+id;
  	} 	
	var rv = v3x.openWindow({
        url: url,
        workSpace: 'yes',
        dialogType: 'open'
    });
    if (rv == "true") {
        getA8Top().reFlesh();
    }
    
}

//退回功能
var recieveId = "";
var registerId = "";
var competitionAction = "";
function stepBackRegisterEdoc(){
	var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }

    var id_checkbox = document.getElementsByName("id");
    if (!id_checkbox) {
        return true;
    }

    var hasMoreElement = false;
    var len = id_checkbox.length;
    var countChecked = 0;
    var obj;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	obj = id_checkbox[i];
            hasMoreElement = true;
            countChecked++;
            var tempRegisterType = obj.getAttribute("registerType");
            if(tempRegisterType == 2 || tempRegisterType == 3) {//纸质与二维码不能退回
            	alert("<fmt:message key='edoc.notAllowed.revoke'/>");
                return false;
            }
            if(id_checkbox[i].getAttribute("exchangeMode")==1){
				alert(v3x.getMessage("edocLang.edoc_exchange_sursen"));
				return;
			}      
        }
    }

    if (!hasMoreElement) {
        alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
        return true;
    }
    
    if(countChecked > 1){
    	alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
        return true;
    }
    recieveId = obj.getAttribute("recieveId");
    registerId = obj.value;

    var exchangeCheck = checkStepBackCompetition(recieveId);
    var canSubmit = exchangeCheck.canSubmit;
	competitionAction=exchangeCheck.competitionAction;
    
  	//条件满足后，进行提交回退操作
	if(canSubmit) {
		if (window.confirm(v3x.getMessage("edocLang.edoc_confirmRecessionItem"))) {
			getA8Top().win123 = getA8Top().$.dialog({
				title:"<fmt:message key='exchange.stepBack'/>",
			    transParams:{'parentWin':window},
		        url:'exchangeEdoc.do?method=openStepBackDlg4Resgistering&resgisteringEdocId='+recieveId,
		        width:"400",
		        height:"300",
		        resizable : "no"
		    });
		}
	}
}
function huituiCallback(returnValues){
	var theForm = document.getElementsByName("listForm")[0];
	if(returnValues!=null && returnValues != undefined){
        if(1==returnValues[0]){
            var aa  = '${exchangeEdoc}';
            theForm.action = 'exchangeEdoc.do?method=stepBackRecievedEdoc&recieveId='+recieveId+'&registerId='+registerId
                +'&stepBackInfo='+encodeURIComponent(returnValues[3])+'&competitionAction='+competitionAction;
            theForm.method = "POST";
            theForm.submit();
        }
    }
}

function doSearch2(){
	var flag = true;
	var recTime = document.getElementById("recTimeDiv");
	if(recTime && recTime.style.display == "block"){
		var begin = document.getElementById("recieveDateBegin").value;
		var end = document.getElementById("recieveDateEnd").value;
		flag = timeValidate(begin,end);
	}
	<c:if test="${state == 2}">
	var registerDate = document.getElementById("registerDateDiv");
	if(registerDate && registerDate.style.display == "block"){
		var begin = document.getElementById("registerDateBegin").value;
		var end = document.getElementById("registerDateEnd").value;
		flag = timeValidate(begin,end);
	}
	</c:if>
	if(flag){
		doSearch();
	}
}
$(function(){
	<%--
	$(".nbtn").parent("div").css("padding","0");
	$(".nbtn").click(function(e){
		var nul=$(".nUL"); //菜单div
		var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
		nul.toggleClass("hidden");
		nul.css({"left":left+"px","top":"25px"});
		addEvent(document.body,"mousedown",clickOther);
	});
	if('${hasSubjectWrap}') {
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}--%>
});
function init(){}

function getSursenSummary(){ 
	var theForm = document.getElementsByName("listForm")[0];
            theForm.action = 'exchangeEdoc.do?method=getSursenSummary';
            theForm.method = "POST";
            theForm.submit();
}
function getSursenSummary(){ 
	location.href= 'exchangeEdoc.do?method=getSursenSummary';
}
</script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
div{line-height:1em;}
</style>
</head>
<body scroll="no" onload="setMenuState('menu_pending');init();">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar" style="padding:0;">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
			    	<script type="text/javascript">
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	<c:if test="${edocType == 1}">
			    		<c:choose>
			    		<c:when test="${state == 1}">
			    			<%-- 登记纸质公文 --%>
			    			myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.register.paperReceipt.label'/>", "javascript:newEdocRegister('create',2)", [18,1], "", null));
			    			<%-- 二维码扫描 --%>
			    			myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.register.dimensionalCodeScanning.label'/>", "javascript:newEdocRegister('create',3)", [18,3], "", null));
			    			<%-- 登记电子公文 --%>
			    			myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.register.electronicDocuments.label'/>", "javascript:newEdocRegister('create',1)", [18,2], "", null));
				    		<c:if test="${registerType == 0 || registerType == 1}">
								myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:stepBackRegisterEdoc()", [10,4], "", null));
							</c:if>
			    		</c:when>
			    		<%-- 已登记 --%>
			    		<c:when test="${state == 0}">
				    		myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.receive.register.edit' />", "javascript:newEdocRegister('edit',1)", [15,1], "", null));
				    		myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.form.deleteform' />", "javascript:deleteRegister()", [1,3], "", null));
							<c:if test="${registerType == 1}">
								//myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return' />", "", [4,5], "", null));
							</c:if>
							<c:if test="${registerType == 0 || registerType == 1}">
                                myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:stepBackRegisterEdoc()", [10,4], "", null));
                            </c:if>
				    	</c:when>
				    	<c:when test="${state == 2}">
				    	myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.form.deleteform' />", "javascript:deleteRegister()", [1,3], "", null));
				    	myBar.add(new WebFXMenuButton("edit", "<fmt:message key='edoc.receive.register.edit' />", "javascript:newEdocRegister('modifyRegister',1)", [15,1], "", null));//编辑
			    		
						</c:when>
				    	
			    		<%-- 退件箱 --%>
			    		<c:when test="${state == 4}">
			    		myBar.add(new WebFXMenuButton("edit", "<fmt:message key='edoc.receive.register.edit' />", "javascript:newEdocRegister('edit')", [15,1], "", null));//编辑
			    		myBar.add(new WebFXMenuButton("return", "<fmt:message key='menu.edocNew.return'/>", "javascript:stepBackRegisterEdoc()", [10,4], "", null));//撤销
			    		myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}'/>", "javascript:cancelRegister()", [4,1], "", null));//退回
			    		</c:when>
			    		<%-- 草稿箱 --%>
			    		<c:otherwise>
				    		myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.receive.register.edit' />", "javascript:newEdocRegister('edit',1)", [15,1], "", null));
							myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.form.deleteform' />", "javascript:deleteRegister()", [1,3], "", null));
							<%--puyc--%>
							/* myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.new.type.forwardarticle'/>", "javascript:showForwardWDOne()", [10,2], "", null)); */

							//lijl添加,登记列表添加"退回"按钮,退回到签收列表
							/* myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:stepBackRegisterEdoc()", [4,1], "", null)); */
							//lijl注销
							//<c:if test="${list == 'registerRetreat'}">
								//myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:stepBackRegisterEdoc()", [4,1], "", null));
							//</c:if>

			    		</c:otherwise>
			    		</c:choose>
			    	</c:if>
			    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>	
			    	document.write(myBar.toString());
			    	document.close();
			    	</script>			
				</td>
				<td>

				   <form action="${controller}" name="searchForm" id="searchForm" method="post" onsubmit="return false">
					<input type="hidden" value="${param.method}" name="method" />
					<input type="hidden" value="${edocType}" name="edocType" />
					<input type="hidden" value="${listType}" name="listType" />
					<input type="hidden" value="${listType}" name="recListType" />
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    <option value="edocUnit"><fmt:message key="edoc.element.sendunit" /></option>
							    <c:choose>
								    <c:when test="${state == 2}">
								        <option value="registerDate"><fmt:message key="edoc.element.register.date" /></option>
								    </c:when>
								    <c:otherwise>
								        <option value="recTime"><fmt:message key="exchange.edoc.receiveddate" /></option>
								    </c:otherwise>
							    </c:choose>
							    <%--交换方式 --%>
                                <c:if test="${v3x:hasPlugin('sursenExchange')}"> 
									<option value="exchangeMode"  <c:if test="${condition == 'exchangeMode'}">selected</c:if>><fmt:message key="edoc.exchangeMode" /></option>  <%-- 交换方式 --%>
								</c:if>
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="secretLevelDiv" class="div-float hidden">
                            <select name="textfield" class="condition" style="width:90px">
                                <option value=""><fmt:message key="common.pleaseSelect.label" /></option>
                                <c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
                                    <c:if test="${secret.state == 1}">
                                    <option value="${secret.value}">
                                        <c:choose>
                                        <c:when test="${secret.i18n == 1 }">
                                        ${v3x:_(pageContext, secret.label)}
                                        </c:when>
                                        <c:otherwise>
                                         ${secret.label}
                                        </c:otherwise>
                                        </c:choose>
                                    </option>
                                    </c:if>
                                </c:forEach>
                            </select>   
                        </div>
					  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="edocUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" /></div>
					  	<c:choose>
						  	<c:when test="${state == 2}">
						  		<div id="registerDateDiv" class="div-float hidden">
							  		<input type="text" name="textfield" id="registerDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
							  		-
							  		<input type="text" name="textfield1" id="registerDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
							  	</div>
						  	</c:when>
						  	<c:otherwise>
							  	<div id="recTimeDiv" class="div-float hidden">
							  		<input type="text" name="textfield" id="recieveDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
							  		-
							  		<input type="text" name="textfield1" id="recieveDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
							  	</div>	
						  	</c:otherwise> 
						</c:choose>
						<%--交换方式 --%>
						<c:if test="${v3x:hasPlugin('sursenExchange')}">
						  	<div id="exchangeModeDiv" class="div-float hidden">
								<select name="textfield">
									<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
									<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
								</select>
						  	</div>
						</c:if>
						<div onclick="javascript:doSearch2()" class="condition-search-button"></div>
				  	</div>
				  	</form>
				</td>			
			</tr>  
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<ul class="nUL hidden" id="showAllSubject">
    		<li><input type="checkbox" id="showAllSubjectId" onclick="javascript:subjectWrapSettting('ajax');"/><fmt:message key="edoc.subject.wrap" /></li>
    	</ul>    		
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" bundle="${exchangeI18N}">
			
				<c:choose>
					<c:when test="${bean.proxy}">
						<c:set value="1" var="proxy" />
						<c:set value="${bean.proxyId}" var="proxyId" />
					</c:when>
					<c:otherwise>
						<c:set value="0" var="proxy" />
						<c:set value="-1" var="proxyId" />
					</c:otherwise>
				</c:choose>
				
				<c:set value="proxy-${bean.proxy}" var="proxyClass"></c:set>
				
				<v3x:column width="3%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="${bean.id}" edocType="${bean.edocType}" recieveId="${bean.recieveId }" 
					registerType="${bean.registerType }" recieveId="${bean.recieveId}" edocId="${bean.edocId}" sendUnitId="${bean.sendUnitId}" 
					state="${bean.state }" distributeState="${bean.distributeState}" isRetreat="${bean.isRetreat }" subject="${bean.subject }"
					distributeEdocId = "${bean.distributeEdocId }" exchangeMode="${bean.exchangeMode}"/>
				</v3x:column>
				
				
				
				<%--  标题 --%>
				<c:choose>
					<c:when test="${param.listType=='registerRetreat'}"><%-- 退件箱 --%>
						<v3x:column width="22%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" label="edoc.element.subject" className="cursor-hand sort mxtgrid_black" importantLevel="${bean.urgentLevel}" hasAttachments="${bean.hasAttachments}" bodyType="${bean.registerBody.contentType }">
						${bean.subject}
<!--						lijl去掉(被退回)(<fmt:message key='edoc.beReturned'/>)-->
						</v3x:column>
						<c:if test="${listType eq 'registerPending' || listType eq 'listRegister'}">
						<%-- 
						<v3x:column width="20" label="<span class='cursor-hand nbtn'>&nbsp</span>">
						</v3x:column>
						--%>
						</c:if>
					</c:when>
					<c:otherwise>
                        <c:choose>
                            <c:when test="${bean.state==1}">
                                <c:set var="pClass" value="${proxyClass}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="pClass" value=""/>
                            </c:otherwise>
                        </c:choose>
						<v3x:column width="22%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" label="edoc.element.subject" className="cursor-hand sort ${pClass} mxtgrid_black" importantLevel="${bean.urgentLevel}" hasAttachments="${bean.hasAttachments}" bodyType="${bean.registerBody.contentType }">
							<c:choose>
								<c:when test="${bean.proxy}">
									${createAccountName}${v3x:toHTML(bean.subject)}
									<c:choose>
										<c:when test="${proxyId ne null }">
											 <c:choose>
											  	<c:when test="${bean.state==1 }"><%-- 待登记 --%>
											  		(<fmt:message key="edoc.proxy"/>${v3x:showMemberName(bean.proxyId)})
											  	</c:when>
											  	<c:otherwise>
											  		${bean.proxyLabel }
											  	</c:otherwise>
										  	</c:choose>
										</c:when>
										<c:otherwise>
											${bean.proxyLabel }
										</c:otherwise>
									</c:choose>
				
								</c:when>
								<c:otherwise>
									${createAccountName}${v3x:toHTML(bean.subject)}
								</c:otherwise>
							</c:choose>
						</v3x:column>
						<c:if test="${listType eq 'registerPending' || listType eq 'listRegister'}">
						<%-- 
						<v3x:column width="20" label="<span class='cursor-hand nbtn'>&nbsp</span>">
						</v3x:column>
						--%>
						</c:if>
					</c:otherwise>
				</c:choose>
				
				<%-- 密级 --%>
				<v3x:column width="11%" type="String" onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10"  symbol="..." >
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" bundle="${edocI18N}"/>
				</v3x:column>
				
				<%--  公文文号 --%>
				<v3x:column width="15%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" maxLength="18" label="edoc.element.wordno.label" className="cursor-hand sort"  symbol="..." value="${bean.docMark}">
				</v3x:column>
				
				<%--  成文单位--%>
				<v3x:column width="9%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
					label="edoc.element.sendunit" className="cursor-hand sort" maxLength="15"  symbol="..." value="${bean.edocUnit}">
				</v3x:column>
				
				<%-- 送往单位--%>
				<c:if test="${state != 2 }">
				<v3x:column width="9%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
					label="exchange.edoc.sendToNames" className="cursor-hand sort" maxLength="15"  symbol="..." value="${bean.sendTo}">
				</v3x:column>
				</c:if>
				
				
				<%-- 份数 --%>
				<%-- 
				<v3x:column width="7%" type="String" label="exchange.edoc.copy" className="cursor-hand sort" maxLength="7"  symbol="..." value="${bean.copies}">
				</v3x:column>
				--%>
				
				<c:choose>
					<c:when test="${state==2}">
						<%-- 登记人 --%>
						<v3x:column width="10%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
						label="exchange.edoc.booker" className="cursor-hand sort" maxLength="9"  symbol="..." value="${bean.registerUserName}">
						</v3x:column>
						
						<%-- 登记时间 --%>
						<fmt:formatDate value='${bean.registerDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' var="registerDate"/>		
						<v3x:column width="13%" type="String" onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
						label="edoc.element.register.date" className="cursor-hand sort" maxLength="15"  symbol="..." value="${registerDate}">
						</v3x:column>
					</c:when>
					<c:otherwise>
						<%-- 签收人 --%>
						<v3x:column width="10%" type="String"  onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
						label="exchange.edoc.receivedperson" className="cursor-hand sort" maxLength="9"  symbol="..." value="${bean.recieveUserName}">
						</v3x:column>
						
						<%-- 签收时间 --%>
						<fmt:formatDate value='${bean.recTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd' var="recTime"/>		
						<v3x:column width="13%" type="String" onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
						label="exchange.edoc.receiveddate" className="cursor-hand sort" maxLength="15"  symbol="..." value="${recTime}">
						</v3x:column>
					</c:otherwise>
				</c:choose>
				<%--交换方式 --%>
				<c:if test="${v3x:hasPlugin('sursenExchange')}"> 
					<v3x:column width="10%" type="String" onClick="openRegisterDetail('${bean.id}', '${bean.recieveId}', '${state}','${bean.edocId}');" 
						label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
						<c:if test="${bean.exchangeMode==0}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
						<c:if test="${bean.exchangeMode==1}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
					</v3x:column>
				</c:if>
				
				
			</v3x:table>	
		
		</form>  
    </div>
  </div>
</div>
<iframe name="newRegisterFrame" style="height:0px;width:0px"></iframe>
<%-- parent.parent.location.href='edocController.do?method=listIndex&from=newEdoc&edocType='+${edocType}+'&meetingSummaryId='+summaryId;--%>
<%--puyc添加收文转发文 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<%--puyc添加收文转发文  结束--%>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
var info = "";
if(listType=="listRegister" || listType=="registerPending" || listType=="registerByAutomatic" || listType=="registerByManual" || listType=="registerByCode") {
	info = "<fmt:message key='edoc.workitem.state.register' />";
} else {
	info = "<fmt:message key='exchange.edoc.registered' bundle='${exchangeI18N}'/>";
}	
//showDetailPageBaseInfo("detailFrame", info, [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	var edocType = "${edocType}";
	//4:收文-签收
	var listType = 4;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}
//-->
</script>

<form id="registerForm">
</form>

</body>
</html>