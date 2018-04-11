
<%--
  这个页面是内嵌页面
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@ page import="com.seeyon.ctp.common.SystemEnvironment" %>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.flag.BrowserEnum"%>

<script type="text/javascript">

function openEdoc(){
	_url = edocURL + "?method=edocDetailInDoc&summaryId=${summary.id}&openFrom=lenPotent&lenPotent=100";
	//alert(_url)
	v3x.openWindow({
		url: _url,
		workSpace : 'yes',
		resizable : "false",
		dialogType:"open"
	});
}
	
//detailId -> 每一条交换回执记录的Id, sendRecordId -> 发送记录的Id 
var _sendRecordId = "";
var _detailId = "";
var _accountId = "";
function withdraw(sendRecordId, detailId, accountId) {
	_sendRecordId = sendRecordId;
	_detailId = detailId;
	_accountId = accountId;
	//验证是否可撤销交换
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "canWithdraw", false);
  	requestCaller.addParameter(1, "String", sendRecordId);  
  	requestCaller.addParameter(2, "String", detailId);  
	var bool = requestCaller.serviceRequest();
	if(bool && bool == "false") {
		alert(v3x.getMessage('ExchangeLang.exchange_send_withdraw_forbidden'));
	 	document.location.reload();
	 	return false;
	}
	getA8Top().win123 = getA8Top().v3x.openDialog({
		title:"<fmt:message key='exchange.send.withdraw'/>",
		transParams:{'parentWin':window},
        url:'exchangeEdoc.do?method=openEdocSendRecordCancelDialog&sendRecordId='+sendRecordId+"&detailId="+detailId,
        width:"400",
        height:"300",
        resizable:"0",
        scrollbars:"true",
        dialogType:"modal"
	});
}
function withdrawCallback(returnValues){
	if(returnValues!=null && returnValues!=undefined) {
		//确认是否撤销交换记录
		if(!window.confirm(v3x.getMessage('ExchangeLang.exchange_send_withdraw'))) {
			return;
		}
		//撤销交换记录
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "withdraw", false);
		requestCaller.addParameter(1, "String", _sendRecordId);  
		requestCaller.addParameter(2, "String", _detailId); 
		requestCaller.addParameter(3, "String", _accountId);
		requestCaller.addParameter(4, "String", returnValues[0]);
		var back = requestCaller.serviceRequest();
		//撤销后刷新当前页面
		var alertNote = '';
		if(back == "3") {
			alertNote = v3x.getMessage('edocLang.exchange_sendRecordDetail_cancel_send_already');//已撤销
		} else if(back == "2") {
			alertNote = v3x.getMessage('edocLang.exchange_sendRecordDetail_stepback_already');//已退回
		} else if(back == "1") {
			alertNote = v3x.getMessage('edocLang.exchange_sendRecordDetail_recieved_already');//已签收
		}
		if(alertNote != '') {
			alert(alertNote);
		}
		location.reload();
	}
}

var _lastSelectVal = "${v3x:showOrgEntitiesOfTypeAndId(elements, pageContext)}";
function setPeopleFields(elements) {
	if(elements) {
		//var obj1 = getNamesString(elements);
		//var obj2 = getIdsString(elements,false);
		
		//document.getElementById("depart").value = getNamesString(elements);
		//document.getElementById("depart").setAttribute("value", getNamesString(elements));
		//setAttribute浏览器不兼容，在IE10下存在问题，不知为何将以前的方法调整成setAttribute，这里修改为用jquery方式来赋值
		//$("#depart").attr("value",getNamesString(elements));
		//document.getElementById("grantedDepartId").value = getIdsString(elements,true);
		
        var _sq = v3x.getMessage("V3XLang.common_separator_label");//分隔符
        var departObj = document.getElementById("depart");
        
        var srcVal = departObj.value;
        
        var sendUnit = getNamesString(elements);
        
        var newValue = _removeRepeat(srcVal, _lastSelectVal, _sq);
        newValue = _removeRepeat(newValue, sendUnit, _sq);
        
        if(sendUnit){
            if(newValue == ""){
                newValue = sendUnit;
            }else{
                newValue += _sq + sendUnit;
            }
        }
		
		_lastSelectVal = sendUnit;
		
		//$("#depart").val(sendUnit);
		//OA-50892 公文收发员打开待发送公文单，添加送往单位时，送往单位选择框显示不出来刚选择的单位
		departObj.value = newValue;
		//OA-49069  在公文交换-待发送列表中填写了送往单位，点击打印，打印的时候显示不出来刚填写的送往单位 
		departObj.setAttribute("value", newValue);
		$("#grantedDepartId").val(getIdsString(elements,true));
	}
}

function _removeRepeat(src, toCon, sq){
    
    var ret = "";
    if(src && toCon){
        var srcArray = src.split(sq);
        var toConArray = toCon.split(sq);
        for(var i = 0; i < srcArray.length; i++){
            var temp = srcArray[i];
            if("" == temp){
                continue;
            }
            var toRemove = false;
            for(var j = 0; j < toConArray.length;j++){
                if(temp == toConArray[j]){
                    toRemove = true;
                    break;
                }
            }
            if(!toRemove){
                if(ret != ""){
                    ret += sq;
                }
                ret += temp;
            }
        }
    }else{
        ret = src;
    }
    
    return ret;
}

//手动输入主送单位时进行ID检验
function _checkInputIds(obj){
    
    var inputIdObj = document.getElementById("grantedDepartId");
    if(inputIdObj){
        
        var objVal = obj.value;
        obj.setAttribute("value", objVal);//打印用
        
        var objEles = elements_grantedDepartId;
        var _sq = v3x.getMessage("V3XLang.common_separator_label");//分隔符
        
        var objValus = objVal.split(_sq);
        
        if(objEles){
            
            var newIds = "";
            var newEles = [];
            var newLastSel = "";
            
            for(var i = 0; i < objEles.length; i++) {
                
                var tempName = objEles[i].name;
                
                var toAdd = false;
                for(var j = 0; j < objValus.length; j++) {
                    if(tempName == objValus[j]){
                        toAdd = true;
                        if(newLastSel != ""){
                            newLastSel += _sq;
                        }
                        newLastSel += tempName;
                        break;
                    }
                }
                if(toAdd){
                    if(newIds != ""){
                        newIds += ",";
                    }
                    newIds += objEles[i].type+"|"+objEles[i].id;
                    newEles[newEles.length] = objEles[i];
                }
            }
            _lastSelectVal = newLastSel;
            inputIdObj.value = newIds;
            elements_grantedDepartId = newEles;
        }
    }
}

function initiate(modelType){
	if(modelType == "toSend"){
		var status = '${bean.status}';
		if(status=="2"){
			document.getElementById("sent").className = "";
		}else{
			var size = "${bean.sendDetailList.size()}";
			if(size > 0 && (status=="1" || status=="3" || status=="4")){//撤销、回退，补发三种情况
				document.getElementById("sent").className = "";
			}else{
				document.getElementById("sent").className = "hidden";
			}
		}
		document.getElementById("sendButton").className = "";
	}
	else if(modelType=="sent"){
		var exchangeMode="${bean.exchangeMode}";
		if(exchangeMode != 1){
			document.getElementById("sent").className = "";
			document.getElementById("sendButton").className = "hidden";
		}
		document.getElementById("sendButton2").className = "";
		var depName = document.getElementById("depart");
	}
	$("#detailForm").height($("body").height() - 80);
}
	
var isNeedCheckLevelScope_grantedDepartId=false;
var showAccountShortname_grantedDepartId = "auto";

var isAllowContainsChildDept_grantedDepartId = true;
var isCheckInclusionRelations_grantedDepartId = false;
var isCanSelectGroupAccount_grantedDepartId=false;

function openStepBackInfo(readOnly,accountId){
	var exchangeSendEdocId = '${bean.id}';
	
	//这个回调为huituiCallback
	getA8Top().win123 = getA8Top().v3x.openDialog({
	      title:"<fmt:message key='exchange.stepBack'/>",
	      transParams:{'parentWin':window},
	      url: 'exchangeEdoc.do?method=openStepBackDlg&exchangeSendEdocId='+exchangeSendEdocId + '&readOnly=1&accountId='+accountId,
	      width:"400",
	      height:"300"
	});
}

/**
 * 点击回退信息显示，防止JS报错
 */
function huituiCallback(returnValues){
    //暂时没有处理
}

function openSendCancelInfo(readOnly, accountId) {
	//这个回调为withdrawCallback
    getA8Top().win123 = getA8Top().v3x.openDialog({
          title:"<fmt:message key='exchange.send.withdraw'/>",
          transParams:{'parentWin':window},
          url: 'exchangeEdoc.do?method=openEdocSendRecordCancelDialog&sendRecordId=${bean.id}&readOnly=1&accountId='+accountId,
          width:"400",
          height:"300"
    });
}


var tempDetailId = "";
function openCuiban(detailId){
  
  //这个回调为withdrawCallback
  getA8Top().win123 = getA8Top().v3x.openDialog({
        title:"<fmt:message key='hasten.label' bundle='${edocI18N}'/>",
        transParams:{'parentWin':window},
        url: 'exchangeEdoc.do?method=openCuiban&detailId='+detailId,
        width:"400",
        height:"300"
  });
  tempDetailId = detailId;
}

/**
 * 催办回调函数
 */
function openCuibanCallback(rv){
    if(rv){
        if(1==rv[0]){
            var formObj = document.getElementById("detailForm");
            formObj.target = "";
            
            var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "cuiban", false);
            requestCaller.addParameter(1,'String',tempDetailId);
            requestCaller.addParameter(2,'String',rv[1]);
            var ret = requestCaller.serviceRequest();
            if(ret == "ok"){
              alert(edocLang.edoc_supervise_sendMessage_success);
            }else{
              alert(edocLang.edoc_supervise_sendMessage_failure);
            }
            location.reload();
        }
      }
}

function sendPrint1(){
    
    
    //table组件高度设置
    var $gBodyEl = $("#bDivsendDetail");
    var gTempHeight = $gBodyEl.height();
    
    $("#scrollListDiv").css("height", "");
    $gBodyEl.css("height", "");
    
    var edocBody = document.getElementById("printDiv").innerHTML;
    
    $("#scrollListDiv").css("height", "100%");
    $gBodyEl.height(gTempHeight);
    
    var edocBodyFrag = new PrintFragment("交换单", edocBody);

	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/apps_res/exchange/css/exchange.css");
	cssList.add("/seeyon/common/skin/default/skin.css");
	var pl = new ArrayList();
	pl.add(edocBodyFrag);
	printList(pl,cssList);
}

</script>
<style type="text/css">
<%--OA-25168 在公文交换---待交换中主送的单位--外部单位手动输入特殊字符，已发送中查看，"链接"是蓝色字体--%>
#exchangeOrg a{
	color : #000;
}
#mainDiv td{
	text-align: left;
}
<%--OA-101029IE8，公文送文单送往单位处显示了横向滚动条 --%>
#depart{
	<%
		String browserString=BrowserEnum.valueOf1(request);
		if (browserString.indexOf("IE") > -1) {
	%>
		width:99%;		
	<%
		} else {
	%>
		width:100%;
	<%		
		}
	%>
}
</style>

<c:set value="${v3x:join(markDef.edocMarkAcls, 'orgDepartment.name', pageContext)}" var="depart" />

	<form name="detailForm" id="detailForm" action="${exchange}?method=${operType}&modelType=${modelType}&reSend=${param.reSend}&fromlist=${param.fromlist}" method="post" target="edocDetailIframe">
		<c:set value="${v3x:parseElementsOfTypeAndId(elements)}" var="grantedDepartId" />
		<v3x:selectPeople id="grantedDepartId" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" jsFunction="setPeopleFields(elements)" originalElements="${grantedDepartId}"  viewPage="" minSize="0"  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" showAllAccount="true"/>
		<input type="hidden" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
		<input type="hidden" name="orgAccountId" value="${summary.orgAccountId}">
		<input type="hidden" id="modelType" name="modelType" value="${modelType}">
		<input type="hidden" id="id" name="id" value="${bean.id}">
		<input type="hidden" id="affairId" name="affairId" value="${affairId}">
		<div align="center" id="printDiv" name="printDiv">
		<div id="mainDiv" name="mainDiv" width="100%">
			<table class="xdLayout" align="center" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 60%; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
				<colgroup>
					<col style="WIDTH: 90px"></col>
					<col style="WIDTH: 180px"></col>
					<col style="WIDTH: 105px"></col>
					<col style="WIDTH: 90px"></col>
					<col style="WIDTH: 90px"></col>
				</colgroup>
				<tbody vAlign="top">
					<tr>
						<td colSpan="5" style="HEIGHT: 40px;PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none" nowrap="nowrap">
							<div style="height: 20px;line-height: 20px;" align="center">
								<font face="宋体" color="#ff0000" size="4">
								<strong>
								<c:if test="${bean.isTurnRec == 0 }">
								<fmt:message key="exchange.edoc.sendform" />
								</c:if>
								<c:if test="${bean.isTurnRec == 1 }">
								收文送文单
								</c:if>
								</strong></font></div>
								<c:if test="${allowShowEdocInSend eq true}">
								<div align="right" onclick="openEdoc();"><font face="宋体" color="#ff0000" size="2" style="cursor:hand;"><fmt:message key="exchange.edoc.preview" /></font></div>
								</c:if>
						</td>
					</tr>
					
					<tr>
						<%-- 标题--%>
						<td style="HEIGHT: 32px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 20px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.title" /></font>
							</div>
						</td>
						<td colSpan="4" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<div id="subject" name="subject" style="overflow: auto;">
							${v3x:toHTML(bean.subject)}</div>
						</td>
					</tr>
					
					<tr>
						<%-- 送往单位--%>
						<td style="BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.sendToNames" /></font>
							</div>
						</td>
						<td colSpan="4" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<div id="exchangeOrg" name="exchangeOrg" style="overflow: auto;">
							<c:if test="${modelType=='toSend'}">
								<input type="text" inputName="<fmt:message key="exchange.edoc.sendToNames" />" validate="notNull" id="depart" onkeyup="_checkInputIds(this)" name="depart" value="<%--${sendEntityName} --%>${sendEntityName!=null?fn:escapeXml(sendEntityName):(v3x:showOrgEntitiesOfTypeAndId(elements, pageContext))}">
								<img id="grantedDepartIdImg" src="<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif" onclick="selectPeopleFun_grantedDepartId()" title="点击选择"/>
								<input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${elements}">									
							</c:if>
							<c:if test="${modelType!='toSend'}">
                                  <%-- ${sendEntityName!=null?sendEntityName:(v3x:showOrgEntitiesOfTypeAndId(elements, pageContext))}--%>
                                  ${v3x:toHTML(sendEntityName)}
							<input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${elements}">									
							</c:if>
							</div>
						</td>
					</tr>						
					
					<tr>
						<%-- 送文人  --%>
						<td style="HEIGHT: 35px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 10px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;"  nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.sendperson" /></font>
							</div>
						</td>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid"><div>
									${bean.sendUserNames}
							</div>
							<input type="hidden" name="sendUserId" id="sendUserId" value="${bean.sendUserId}">
							<input type="hidden" name="sender" id="sender" value="${bean.sendUserNames}">
						</td>
						<%-- 送文日期 --%>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 30px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="edoc.sendTime.label" /></font>
							</div>
						</td>
						<td colSpan="2" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<div id="sendTime" name="sendTime">
								<fmt:formatDate value='${bean.sendTime}' type='both' dateStyle='full' pattern='yyyy年MM月dd日 HH:mm'/>
							</div>
						</td>
					</tr>
					
					<tr>
						<%--  发文单位  --%>
						<td style="HEIGHT: 35px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 10px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.sendaccount" /></font>
							</div>
						</td>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div id="sendUnit" name="sendUnit">${bean.sendUnit}
							</div>
						</td>
						<%-- 公文级别 --%>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 30px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="edoc.unitLevel.label" /></font>
							</div>
						</td>
						<td colSpan="2" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<div id="unitLevel" name="unitLevel">
								<v3x:metadataItemLabel metadata="${colMetadata['edoc_unit_level']}" value="${summary.unitLevel}"/>
							</div>
						</td>
					</tr>
					
					
					<tr>
						<%-- 公文文号     --%>
						<td style="HEIGHT: 35px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 10px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.wordNo" /></font>
							</div>
						</td>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div id="docMark" name="docMark">
								${v3x:toHTML(bean.docMark)}
							</div>
						</td>	
						<%-- 公文种类      --%>
						<td style="padding-right: 30px; border: 1pt solid rgb(255, 0, 0); vertical-align: middle;" width="100%;" nowrap="nowrap">
							<div style="text-align: right;white-space:pre-wrap;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="edoc.element.doctype" bundle="${edocI18N}"/></font>
							</div>
						</td>
						<td colSpan="2" style="border-style: solid none solid solid; padding: 1px; vertical-align: middle; border-top-color: rgb(255, 0, 0); border-bottom-color: rgb(255, 0, 0); border-left-color: rgb(255, 0, 0); border-top-width: 1pt; border-bottom-width: 1pt; border-left-width: 1pt;">
							<div id="docType" name="docType">
								<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}"/>
							</div>
						</td>
					</tr>
					
					<c:if test="${bean.isTurnRec == 0 }">
					<tr>
						<%-- 签发人   --%>
						<td style="HEIGHT: 32px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 20px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.signingpeople" /></font>
							</div>
						</td>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div id="issuer" name="issuer">
							${v3x:toHTML(bean.issuer)}
							</div>
						</td>
						<%-- 签发日期    --%>
						<td style="padding-right:30px; border: 1pt solid rgb(255, 0, 0); vertical-align: middle;" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.signingdate" /></font>
							</div>
						</td>
						<td colSpan="2" style="border-style: solid none solid solid; padding: 1px; vertical-align: middle; border-top-color: rgb(255, 0, 0); border-bottom-color: rgb(255, 0, 0); border-left-color: rgb(255, 0, 0); border-top-width: 1pt; border-bottom-width: 1pt; border-left-width: 1pt;">
							<div id="issueDate" name="issueDate">
								<fmt:formatDate value='${bean.issueDate}' type='both' dateStyle='full' pattern='${datePattern}'/>
							</div>
						</td>
					</tr>
					</c:if>
					
					
					<tr>
						<%-- 密级       --%>
						<td style="HEIGHT: 37px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 20px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.secretlevel" /></font>
							</div>
						</td>
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div id="secretLevel" name="secretLevel">
								<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${bean.secretLevel}"/>
							</div>
						</td>
						<%-- 紧急程度        --%>
						<td style="padding-right: 30px; border: 1pt solid rgb(255, 0, 0); vertical-align: middle;" width="100%;" nowrap="nowrap">
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.urgentlevel" /></font>
							</div>
						</td>
						<td colSpan="2" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<v3x:metadataItemLabel metadata="${colMetadata['edoc_urgent_level']}" value="${bean.urgentLevel}"/>
						</td>
					</tr>
					
					<tr>
						<%-- 根据国家行政公文规范,去掉主题词
						<td style="BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div>
								<font face="宋体" color="#ff0000" size="2"><fmt:message key="edoc.element.keyword" bundle="${edocI18N}" /></font>
							</div>
						</td> 
						<td style="BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid">
							<div id="keywords" name="keywords">${v3x:toHTML(bean.keywords)}
							</div>
						</td> --%>
						<%-- 份数       --%>
						<td style="HEIGHT: 33px;BORDER-left: none ;BORDER-RIGHT: #ff0000 1pt solid; PADDING-RIGHT: 20px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid" nowrap="nowrap">
							<%-- <c:if test="${bean.isTurnRec == 0 }"> --%>
							<div style="text-align: right;">
								<font face="宋体" color="#ff0000" size="4"><fmt:message key="exchange.edoc.copy" /></font>
							</div>
							<%-- </c:if> --%>
						</td>
						<td colSpan="4" style="PADDING-RIGHT: 1px; BORDER-TOP: #ff0000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #ff0000 1pt solid; PADDING-TOP: 1px; BORDER-BOTTOM: #ff0000 1pt solid; BORDER-RIGHT-STYLE: none">
							<%-- <c:if test="${bean.isTurnRec == 0 }"> --%>
							<div id="copies" name="copies">
								${copies}
							</div>
							<%-- </c:if> --%>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<c:if test="${bean.exchangeMode ne 1}">
			<div class="hidden" id="sent" name="sent" style="width: 100%">
				<div id="div1" name="div1">
					<table border="0" align="center" cellspacing="0" cellpadding="0" id="detailTable" name="detailTable" width="80%">
						<tr>
							<td height="30px" style="BORDER-LEFT: none; border-right: none; border-bottom:none">&nbsp;</td>
						</tr>
						<tr>
							<td align="center" class="td-detail">
								<strong><font face="宋体" color="#ff000" size="2"><fmt:message key="exchange.edoc.replyinfo" /></font></strong>
							</td>
						</tr>
						<tr>
							<td style="height:${detailListHeight}px">
							<%-- 组件没有分页信息的时候高度不对，补回30px; --%>
							<div id="scrollListDiv" style="width: 100%;height: 100%;">
								<v3x:table htmlId="sendDetail" data="${bean.sendDetailList}" var="detail" width="100%" showPager="false" bundle="${edocI18N}">
									<v3x:column width="20%" type="String" label="exchange.edoc.exchangeUnit">
										<a style="color: #000" title="${bean.exchangeOrgName}">${v3x:getLimitLengthString(bean.exchangeOrgName,-1,"...")}</a>
									</v3x:column>
									<v3x:column width="20%" type="String" label="exchange.edoc.receiveaccount">
										<c:if test="${not empty detail.recOrgName}"><%--将bean.status==1条件 改为not empty detail.recOrgName，修复GOV-3319 --%>
											<a style="color: #000" title="${detail.recOrgName}">${v3x:getLimitLengthString(detail.recOrgName,-1,"...")}</a>
										</c:if>
									</v3x:column>	
									<v3x:column  width="13%" type="String" label="exchange.edoc.signingNo" alt="${detail.recNo}">
	                                    <c:if test="${detail.status!=0}">
											${v3x:toHTML(v3x:getLimitLengthString(detail.recNo,-1,"..."))}
	                                    </c:if>    
									</v3x:column>
									<v3x:column width="9%" type="String" label="exchange.edoc.receivedperson">
	                                    <c:if test="${detail.status!=0}">
										   <span style="font-size:12px">${detail.recUserName }</span>
	                                    </c:if>
									</v3x:column>
									<v3x:column width="12%" type="Date" align="center" label="exchange.edoc.receiveddate">
	                                    <c:if test="${detail.status!=0}">
										   <span style="font-size:12px"><fmt:formatDate value='${detail.recTime}' pattern='yyyy-MM-dd HH:mm'/></span>
	                                    </c:if>
									</v3x:column>
									<v3x:column width="6%" type="String" align="center" label="exchange.edoc.status">
										<c:choose>
											<c:when test="${detail.status==0}">
												<span style="font-size:12px"><fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}' /></span>
											</c:when>
											<c:when test="${detail.status==1}">
												<span style="font-size:12px"><fmt:message key="exchange.edoc.sign" /></span>
											</c:when>
											<c:when test="${detail.status==2}">
												<a href="javascript:openStepBackInfo(1,'${detail.recOrgId}')"><fmt:message key="exchange.edoc.yihuitui" />
											</c:when>
											<c:when test="${detail.status==3}">
												<a href="javascript:openSendCancelInfo(1,'${detail.recOrgId}')"><fmt:message key="exchange.edoc.yichexiao" />
											</c:when>
										</c:choose>
									</v3x:column>
	                                <c:if test="${bean.status!=0}">
	                                    <v3x:column width="12%" type="String" align="center" label="hasten.label">
	                                        <c:if test="${detail.status==0}">
	                                         <a href="javascript:openCuiban('${detail.id }');"/><fmt:message key="hasten.label" bundle="${edocI18N}"/>（${detail.cuibanNum}<fmt:message key="edoc.supervise.count" bundle="${edocI18N}"/>）</a>
	                                        </c:if>
	                                        <c:if test="${detail.status!=0}">
	                                         <span style="font-size:12px"><fmt:message key="hasten.label" bundle="${edocI18N}"/>（${detail.cuibanNum}<fmt:message key="edoc.supervise.count" bundle="${edocI18N}"/>）</span>
	                                        </c:if>
	                                    </v3x:column>
	                                </c:if>
									<v3x:column width="5%" align="center" label="exchange.send.withdraw">
										<c:if test="${detail.status==0}"> 
											<a href="javascript:withdraw('${bean.id}','${detail.id}','${detail.recOrgId}');" id="withdrawhref${detail.id}"/><fmt:message key='exchange.send.withdraw' /></a>
										</c:if>	
									</v3x:column>
								</v3x:table>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		  </c:if>
		</div>
		
		<div id="sendButton" name="sendButton" class="" style="clear:both;">
			<table border="0" width="100%">
				<tr>
					<c:if test="${v3x:hasPlugin('sursenExchange') && modelType == 'toSend'}">
						<td height="42" align="left" width="50%;">
							<fmt:message key="edoc.exchangeMode" /><fmt:message key="label.colon" /><%-- 交换方式： --%>
							<input id="internalExchange" type="checkbox" name="exchangeMode" value="0" checked="checked"><fmt:message key="edoc.exchangeInternal.input" /></input>   <%-- 交内部公文交换 --%>
							<input id="sursenExchange" type="checkbox" name="exchangeMode" value="1" ><fmt:message key="edoc.exchangeSursen.input" /></input> <%-- 交书生公文交换 --%>
						</td>
					</c:if>	
					
					<td height="42" align="${!v3x:hasPlugin('sursenExchange')?'center':'left'}">
					<input id="oprateBut" type="button" value="<fmt:message key='exchange.edoc.send' />" class="button-default_emphasize" onclick="oprateSubmit();" >
					<input type="button" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onclick="sendPrint2();">
					</td>				
				</tr>					
			</table>
		</div>
		
		<div id="sendButton2" name="sendButton2" class="hidden">
			<table border="0" width="100%">
				<tr>
					<td height="42" align="center">
						<input type="button" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onclick="sendPrint1();">
					</td>
				</tr>					
			</table>								
		</div>
	</form>
	<iframe name="edocDetailIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	
<script type="text/javascript">
	initiate('${modelType}');
</script>
