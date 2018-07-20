<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/exchange/js/exchange.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var jsEdocType=${edocType};
var list = "${ctp:escapeJavascript(param.list)}";

var resgisteringEdocId = "";
var theForm = "";
var competitionAction="no";
function distributeRetreat(){
	theForm = document.getElementsByName("listForm")[0];	
    if (!theForm) {
        return false;
    }
	var id_checkbox = document.getElementsByName("id");
	var hasMoreElement = false;
    var len = id_checkbox.length;
    var countChecked = 0;
    var obj;
    var exchangeMode=0;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	obj = id_checkbox[i];
            hasMoreElement = true;
            exchangeMode=obj.getAttribute("exchangeMode");
            countChecked++;
        }
    } 
    if(exchangeMode==1){
		alert(v3x.getMessage("edocLang.edoc_exchange_sursen"));
		return;
	}    
    if (!hasMoreElement) {
        alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
        return true;
    }
    
    if(countChecked > 1){
    	alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
        return true;
    }
	var registerType = obj.getAttribute("registerType");

	//纸质登记的，登记开关关闭时，就不能回退了
	if("${isOpenRegister}" == "false" && registerType != 1){
		//当前环境已关闭登记环节，纸质登记与二维码登记的公文暂时不能回退。
        alert(v3x.getMessage("edocLang.edoc_alert_register_stepback1"));
		return;
	}
    
    resgisteringEdocId = obj.getAttribute("registerId");
    var isAutoRegister = obj.getAttribute("autoRegister");
    var canSubmit = true;
    var jzRun=true;
	//当如果是自动登记的，分发回退就需要判断 原签收人还有签收权限吗
	if("${isOpenRegister}" == "false"||isAutoRegister == 1){
		//获得签收记录id
		var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "getRecieveIdByRegisterId", false);
		//传递签收ID
	    requestCaller.addParameter(1, 'Long', resgisteringEdocId);
	    var recieveId = requestCaller.serviceRequest();
	    var exchangeCheck = checkStepBackCompetition(recieveId);
	    if(exchangeCheck){
	    	canSubmit = exchangeCheck.canSubmit;
			competitionAction=exchangeCheck.competitionAction;
	    }else{
	    	canSubmit = false;
		}
	}
	
	//判断公文登记人是否还有权限（    登记开关打开  && isAutoRegister：这条登记数据是否自己登记产生 ）
	if("${isOpenRegister}" == "true" && isAutoRegister != 1){
		var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "checkRegisterByRegisterEdocId", false);
	    requestCaller.addParameter(1, 'Long', resgisteringEdocId);
	    var res = requestCaller.serviceRequest();
	    res=res.split(",");
	    if(res[0] == "false" && res[1] == "false"){
		    alert(_("edocLang.edoc_noRegisterExistCannotStepBack"));
		    return;
	    }else if(res[0] == "false" && res[1] == "true"){
	    	if(!window.confirm(_("edocLang.edoc_confirmRegisterCancelStepBackOther"))){
				return;
		    }else{
		    	jzRun=false;
		    	competitionAction = "yes";
		    }
	    }
	}
	
    if(canSubmit){
    	if (jzRun && !window.confirm(_("edocLang.edoc_confirmStepBackItem")))
        {
            return;
        }
    	getA8Top().win123 = getA8Top().$.dialog({
    		title:'<fmt:message key='exchange.stepBack'/>',
			transParams:{'parentWin':window},
	        url:'exchangeEdoc.do?method=openStepBackDistribute&resgisteringEdocId='+resgisteringEdocId,
	        width:"400",
	        height:"300",
	        resizable:"0",
	        scrollbars:"true",
	        dialogType:"modal"
	        });
    }
}
function huituiCallback(returnValues){
	if(returnValues!=null && returnValues != undefined){
		if(1==returnValues[0]){
				theForm.action = genericURL+'?method=distributeRetreat&registerId='+resgisteringEdocId+'&stepBackInfo=' + encodeURIComponent(returnValues[3])
					+'&competitionAction='+competitionAction;
				theForm.method = "POST";
				theForm.submit();
			}
		}
}
function doSearch2(){
	var flag = true;
	var recieveDate = document.getElementById("recieveDateDiv");
	if(recieveDate && recieveDate.style.display == "block"){
		var begin = document.getElementById("recieveDateBegin").value;
		var end = document.getElementById("recieveDateEnd").value;
		flag = timeValidate(begin,end);
	}

	var registerDate = document.getElementById("registerDateDiv");
	if(registerDate && registerDate.style.display == "block"){
		var begin = document.getElementById("registerDateBegin").value;
		var end = document.getElementById("registerDateEnd").value;
		flag = timeValidate(begin,end);
	}
	
	if(flag){
		doSearch();
	}
}

function openRegisterDetail(id, recieveId, registerState) {
  	var url = '';
  	if(registerState == '1') {  
    	url = genericURL+'?method=newEdocRegister&comm=create&recieveId='+recieveId+'&registerType=1&listType=${listType}&edocType=${edocType}';
    	previewFrame('Down');
    	window.location = url;  
  	} else {
  		url = genericURL+'?method=edocRegisterDetail&forwardType=waitSent&registerId='+id;
  		var rv = v3x.openWindow({
  	        url: url,
  	        workSpace: 'yes',
  	        dialogType: 'open'
  	    });
  	    if (rv == "true") {
  	        getA8Top().reFlesh();
  	    }
  	} 	
    
}

function barCodeRecEdoc(){
    location.href="edocController.do?method=newEdoc&edocType=1&barCode=true&registerType=3";
}

function newEdoc(edocType, isNew) {
	if(isNew == true) {
		location.href=genericURL+"?method=newEdoc&edocType="+edocType;
	} else {
		var oCheckbox = document.getElementsByName("id");
		var count =0;
		var registerId = "";
	    for(var i=0;i<oCheckbox.length;i++) {
	    	if(oCheckbox[i].checked) {
	    		registerId=oCheckbox[i].getAttribute("registerId");
	    		count++;
	    	}
	    }
	    if(count==0) {
			alert(_("edocLang.edoc_alertDontSelectMulti"));
			return;
	    } else if(count>1) {
			alert(_("edocLang.edoc_alertOnlyOneSelectMultiToFenfa"));
			return;
		} else {
			//本地安装的是永中office，正文类型是wps给出提示
	        var isWpsBodyType = checkWpsBodyType(registerId);
	        var isYoZoOffice = parent.isYoZoOffice();
	        if(isWpsBodyType && isYoZoOffice){
	        	//本地安装的Office环境不支持此公文正文类型的保存和发送，无法正常登记，请安装WPS或微软Office软件！
	        	alert(_("edocLang.edoc_alertWpsYozoOffice"));
	     	   	return;
	        }
			location.href=genericURL+"?method=newEdoc&comm=distribute&recListType=listDistribute&edocType="+edocType+"&registerId="+registerId;
		}
	}
}
/**
 * 检查待登记公文的正文类型是否是wps
 */
function checkWpsBodyType(registerId){
	var retValue=false;
	if(registerId && registerId != ""){
		var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "getRegisterBodyType",false);
		requestCaller.addParameter(1, "String", registerId);
		var tempBodyType = requestCaller.serviceRequest();
		if(tempBodyType && (tempBodyType == "WpsWord" || tempBodyType == "WpsExcel")){
			retValue = true; 
		}
	}
	return retValue;
}

$(function(){
	$(".nbtn").parent("div").css("padding","0");
	$(".nbtn").click(function(e){
		var nul=$(".nUL"); //菜单div
		var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
		nul.toggleClass("hidden");
		nul.css({"left":left+"px","top":"25px"});
		addEvent(document.body,"mousedown",clickOther);
	});
	if(${hasSubjectWrap}) {
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}
});
function init(){}

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
    <div class="top_div_row2 webfx-menu-bar">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="65%">
			    	<script type="text/javascript">   
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	if("${edocType}" == "1") {

			    		//新建收文
					    myBar.add(new WebFXMenuButton("", "分发纸质公文", "javascript:newEdoc('${edocType}', true)", [18,1], "", null));
						if("${isOpenRegister}" == "false"){
					    	myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.toolbar.Two_dimensional_code.label'/>", "javascript:barCodeRecEdoc()", [4,1], "", null));
						}
					    myBar.add(new WebFXMenuButton("", "分发电子公文", "javascript:newEdoc('${edocType}')", [18,2], "", null));
					    if("${showBanwenYuewen}"=="true"){
						    myBar.add(
			                        new WebFXMenuButton(
			                            "newBtn", 
			                            "阅文批量分发", 
			                            "showReadBatchWD("+"${canSelfCreateFlow}"+");", 
			                            [1,7], 
			                            "", 
			                            null
			                        )
			                    );
					    }
					    myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return' />", "javascript:distributeRetreat()", [10,4], "", null));	
				    }
			    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>	
			    	document.write(myBar);
			    	document.close();
			    	</script>
				</td>
				<td><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">		
					<input type="hidden" value="<c:out value='${param.list}' />" name="list">	
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    <option value="edocUnit"><fmt:message key="edoc.element.sendunit"/></option>
							    <c:if test="${isOpenRegister == 'true'}">
							        <option value="registerDate"><fmt:message key="edoc.element.registration_date"/></option>
								</c:if>
							    <c:if test="${isOpenRegister != 'true'}">
							        <option value="recieveDate"><fmt:message key="edoc.element.receipt_date"/></option>
		                        </c:if>
		                        <%--交换方式 --%>
		                        <c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'}"> 
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
					  	<div id="edocUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<c:if test="${isOpenRegister == 'true'}">
						  	<div id="registerDateDiv" class="div-float hidden">
						  		<input type="text" name="textfield" id="registerDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
						  		-
						  		<input type="text" name="textfield1" id="registerDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
						  	</div>
					  	</c:if>
					  	<c:if test="${isOpenRegister != 'true'}">
						  	<div id="recieveDateDiv" class="div-float hidden">
						  		<input type="text" name="textfield" id="recieveDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
						  		-
						  		<input type="text" name="textfield1" id="recieveDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
						  	</div>
					  	</c:if>
					  	<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'}">
						  	<div id="exchangeModeDiv" class="div-float hidden">
								<select name="textfield">
									<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
									<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
								</select>
						  	</div>
						</c:if>
					  	<div onclick="javascript:doSearch2()" class=" div-float condition-search-button"></div>
				  	</div></form>
				</td>			
			</tr>  
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
    	<ul class="nUL hidden" id="showAllSubject">
    		<li><input type="checkbox" id="showAllSubjectId" onclick="javascript:subjectWrapSettting('ajax');"/><fmt:message key="edoc.subject.wrap" /></li>
    	</ul>
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
		<c:url value='/common/images/overTime.gif' var="overTime" />
		<c:url value='/common/images/timeout.gif' var="timeOut" />
		<input type="hidden" id="checkAffirId" name="checkAffirId" value=""/>
		<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis edocellipsis">
			<c:set value="${v3x:toHTML(col.summary.subject)}" var="subject"  />

			<!-- 
			lijl修改js方法openDetail为openDetailInfo
			<c:set var="click" value="openDetail('', 'from=Pending&affairId=${col.affairId}&from=Pending&state=2')"/>
			-->
			<c:set var="click" value="openRegisterDetail('${col.registerId }', '-1', '2');"/>

	
            <v3x:column width="35" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" subject="${subject}"
				registerType="${col.registerType }" registerId="${col.registerId }" edocId="${col.edocId}" autoRegister="${col.autoRegister }"
				exchangeMode="${col.exchangeMode}"/>
			    <input type = "hidden" name ='${col.summary.id}' id ='${col.summary.id}' value="${col.affairId}"/>
			</v3x:column>	
			<!-- 
			lijl修改js方法openDetail为openDetailInfo,修改为双击出来分发单
			<c:set var="dblclick" value="openDetail('', 'from=Pending&affairId=${col.affairId}&from=Pending&state=2')"/>
			-->
			<c:set var="dblclick" value="javascript:newEdoc('${edocType}')"/>
			<c:set var="isRead" value="${col.state != 0}"/>
			
			<v3x:column width="10%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" 
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
			</v3x:column>
			
			<v3x:column width="30%" type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy} mxtgrid_black" 
			bodyType="${col.bodyType}"  hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" 
			extIcons="${(col.deadLine ne null && col.deadLine ne ''&& col.deadLine ne '0') ? (col.overtopTime eq true ? timeOut : overTime) : null}"
			importantLevel="${col.summary.urgentLevel}">
			<%-- TODO(5.0sprint3) V5目前保持A8的显示，G6的时候再打开
			<c:if test="${col.summary.isRetreat==0}">
			${v3x:toHTML(col:showSubjectOfEdocSummary(col.summary, col.proxy, -1, col.proxyName,false))}
			</c:if>
			<c:if test="${col.summary.isRetreat==1}">
			${v3x:toHTML(col:showSubjectOfEdocSummary(col.summary, col.proxy, -1, col.proxyName,false))}(<fmt:message key='edoc.beReturned'/>)
			</c:if>--%>
			<%-- 
            ${col.summary.subject }
			--%>
				<c:choose>
					<c:when test="${col.proxy}">
						${v3x:toHTML(col.summary.subject)}
						(<fmt:message key="edoc.proxy"/>${col.proxyName})
					</c:when>
					<c:otherwise>
						${v3x:toHTML(col.summary.subject)}
					</c:otherwise>
				</c:choose>
			</v3x:column>	
			
			<v3x:column width="12%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort" 
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.docMark)}">${v3x:toHTML(col.summary.docMark)}</span>&nbsp;
			</v3x:column>
			
			
			<v3x:column width="10%" type="String" label="edoc.element.sendunit"
			className="cursor-hand sort" 
			 onClick="${click}" >
				<span title="${col.summary.sendUnit}">${col.summary.sendUnit}</span>&nbsp;
			</v3x:column>
			<c:if test="${isOpenRegister=='true' }">
				<v3x:column width="10%" type="String" label="exchange.edoc.booker"
					className="cursor-hand sort" 
					 onClick="${click}" >
					<span title="${col.registerUserName}">${col.registerUserName}</span>&nbsp;
				</v3x:column>
			
				<v3x:column width="10%" type="String" label="edoc.element.registration_date"
						className="cursor-hand sort" 
						 onClick="${click}" >
					<span title="<fmt:formatDate value="${col.registerDate}"  pattern="yyyy-MM-dd"/>"><fmt:formatDate value="${col.registerDate}"  pattern="yyyy-MM-dd"/></span>&nbsp;
				</v3x:column>
			</c:if>
			
			<c:if test="${isOpenRegister=='false' }">
				<v3x:column width="10%" type="String" label="exchange.edoc.sendToNames"
					className="cursor-hand sort" 
					 onClick="${click}" >
					<span title="${col.summary.sendTo}">${col.summary.sendTo}</span>&nbsp;
				</v3x:column>
				<v3x:column width="10%" type="String" label="exchange.edoc.receivedperson"
					className="cursor-hand sort" 
					 onClick="${click}" >
					<span title="${col.recUserName}">${col.recUserName}</span>&nbsp;
				</v3x:column>
				<v3x:column width="10%" type="String" label="exchange.edoc.receiveddate"
					className="cursor-hand sort" 
					 onClick="${click}" >
					<span title="<fmt:formatDate value="${col.recieveDate}"  pattern="yyyy-MM-dd"/>"><fmt:formatDate value="${col.recieveDate}"  pattern="yyyy-MM-dd"/></span>&nbsp;
				</v3x:column>
				
			</c:if>
			<%--交换方式 --%>
			<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'}"> 
				<v3x:column width="10%" type="String" onClick="${click}" 
					label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
					<c:if test="${col.exchangeMode==0}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
					<c:if test="${col.exchangeMode==1}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
				</v3x:column>
			</c:if>
			
			<%-- 内部文号 --%>
			<%-- 
			<v3x:column width="10%" type="String"  label="edoc.element.wordinno.label" className="cursor-hand sort" 
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.serialNo)}">${v3x:toHTML(col.summary.serialNo)}</span>&nbsp;
			</v3x:column>
			--%>	
							
			<%-- 发起人 --%>		
			<%-- 		
			<v3x:column width="10%" type="String" label="common.sender.label"
			className="cursor-hand sort" 
			 onClick="${click}" >
				<span title="${col.summary.startMember.name}">${col.summary.startMember.name}</span>&nbsp;
			</v3x:column>
			--%>
			<%-- 发起时间 --%>	
			<%--
			<v3x:column width="12%" type="Date" label="edoc.supervise.startdate" className="cursor-hand sort" align="left" 
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>
			--%>
			<%-- 处理期限 --%>	
			<%--
			<v3x:column width="8%" type="String" label="edoc.node.cycle.label" className="cursor-hand sort" 
			 onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
				<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${col.deadLine}"/>	
			</v3x:column>
			--%>
			<%-- 催办次数 --%>	
			<%--
			<v3x:column type="Number" align="center" label="hasten.number.label" className="cursor-hand sort" 
			 onClick="${click}" value="${col.hastenTimes}">
			</v3x:column>
			--%>
			<%--
			<v3x:column width="6%" type="String" align="center" label="processLog.list.title.label" >
				<img src="<c:url value='/apps_res/collaboration/images/workflowDetail.gif' />" onclick="showProcessLog('${col.summary.processId}');" class="cursor-hand sort">
			</v3x:column>
			--%>
		</v3x:table>
		</form>
    </div> 
  </div>
</div>
<div>
  
<form name="sendForm" id="sendForm"  action="" method="post">
  <input type="hidden" value="" name="note" id="note"/>
  <span id="people" style="display:none;">
	<c:out value="${peopleFields}" escapeXml="false" />
  </span>
  <input id="workflowInfo" name="workflowInfo" type="hidden"></div>
  <input type="hidden" value="" name="edoctable" id="edoctable"/>
</form>

</div>
<%--puyc添加收文转发文 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<%--puyc添加收文转发文  结束--%>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
var info = "";
var list = "${param.list}";
if(list=="listDistribute" || list=="aistributining") {
	info = "<fmt:message key='edoc.receive.toAttribute'/>";
} else if(list=="aistributeDone") {
	info = "<fmt:message key='edoc.receive.attributed'/>";
} else {
	info = "<fmt:message key='edoc.receive.draft_box'/>";
}
//showDetailPageBaseInfo("detailFrame", info, [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	var edocType = "${edocType}";
	//5:收文-分发
	var listType = 5;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}
//-->
</script>
<form id="readBatchForm" name="readBatchForm" action="">
<input type="hidden" id="registerStr" name="registerStr" value="1"/>
<input type="hidden" id="processXml" name="processXml" value="1"/>
<input type="hidden" id="comment" name="comment" value="1"/>
</form>
</body>
</html>