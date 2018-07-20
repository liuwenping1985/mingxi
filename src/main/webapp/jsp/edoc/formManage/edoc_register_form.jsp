<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.common.SystemEnvironment" %>
<script type="text/javascript">
//选人界面来源  1主送单位 2抄送单位 3分发人选择
var selectType = 1;
var sendToId = "";
var sendToUnit = "";
var lastSelSendToUnit = "";
var copyToId = "";
var copyToUnit = "";
var lastSelCopyToUnit = "";
var distributerId = -1;
var distributer = "";

//选人界面参数控制
window.showRecent_distributerSelect = false;//隐藏最近标签
window.accountId_distributerSelect = "${bean.orgAccountId}";//限定只显示电子公文登记的单位
window.onlyLoginAccount_distributerSelect = true;//不切换单位


function openUnitWindow(obj) {

	elements_sendToSelect = selPerElements.get(obj.name, "");
	selectPeopleFun_sendToSelect();
	
}

//选人界面回调函数
function setPeopleFields(elements) {
    
    var _sq = "、";
    
	if(selectType==1) {
		sendToId = "";
		sendToUnit = "";
	} else if(selectType==2) {
		copyToId = "";
		copyToUnit = "";
	}
	for(var i=0; i<elements.length; i++) {
		if(selectType==1) {
			sendToId += elements[i].type+"|"+elements[i].id+",";
			sendToUnit += elements[i].name + _sq;
		} else if(selectType==2) {
			copyToId += elements[i].type+"|"+elements[i].id+",";
			copyToUnit += elements[i].name + _sq;
		} else if(selectType==3) {
			distributerId = elements[i].id;
			distributer = elements[i].name;
		}
	}
	if(sendToId!="") {
		sendToId = sendToId.substring(0, sendToId.length-1);
		sendToUnit = sendToUnit.substring(0, sendToUnit.length-1); 
	}
	if(copyToId!="") {
		copyToId = copyToId.substring(0, copyToId.length-1);
		copyToUnit = copyToUnit.substring(0, copyToUnit.length-1); 
	}
	
	if(selectType==1) {
		$("#sendForm").find("[@name='sendToId']").val(sendToId);
		var $sendTo = $("#sendForm").find("[@name='sendTo']");
		var tempSrcValue = $sendTo.val();
		if(tempSrcValue == sendlt){
		    tempSrcValue = "";
		}
		var newVal = _getNewValue(tempSrcValue, lastSelSendToUnit, sendToUnit, _sq);
		lastSelSendToUnit = sendToUnit;
		$sendTo.val(newVal);
	} else if(selectType==2) {
		$("#sendForm").find("[@name='copyToId']").val(copyToId);
		var $copyTo = $("#sendForm").find("[@name='copyTo']");
		var tempSrcValue = $copyTo.val();
		if(tempSrcValue == copylt){
            tempSrcValue = "";
        }
        var newVal = _getNewValue(tempSrcValue, lastSelSendToUnit, copyToUnit, _sq);
        lastSelCopyToUnit = copyToUnit;
        $copyTo.val(newVal);
	} else if(selectType==3) {
		$("#sendForm").find("[@name='distributerId']").val(distributerId);
		$("#sendForm").find("[@name='distributer']").val(distributer);
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
    
    var inputIdObj = null;
    var objEles = null;
    
    var isSendTo = obj.name == "sendTo";
    var isCopyTo = obj.name == "copyTo";
    
    if(isSendTo){
        inputIdObj = $("#sendForm").find("[@name='sendToId']")[0];
        objEles = elements_sendToSelect;
    }else if(isCopyTo){
        inputIdObj = $("#sendForm").find("[@name='copyToId']")[0];
        objEles = elements_copyToSelect;
    }else{
        return;
    }
    
    
    if(inputIdObj){
        
        var objVal = obj.value;
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
            
            if(isSendTo){
                lastSelSendToUnit = newLastSel;
                elements_sendToSelect = newEles;
                
            }else if(isCopyTo){
                lastSelCopyToUnit = newLastSel;
                elements_copyToSelect = newEles;
            }
            
            inputIdObj.value = newIds;
        }
    }
}

function _getNewValue(srcVal, _lastSelectVal, newSelVal, _sq){
    
    var newValue = _removeRepeat(srcVal, _lastSelectVal,_sq);
    newValue = _removeRepeat(newValue, newSelVal, _sq);
    if(newSelVal){
        if(newValue == ""){
            newValue = newSelVal;
        }else{
            newValue += _sq + newSelVal;
        }
    }
    
    return newValue;
}

//弹出内部文号录入界面。
function changeSerialNo() {
	var _obj = document.getElementById("serialNo");	
	//判断页面上是否存在内部文号
	if(_obj==null) {
		alert(_("edocLang.edoc_form_noSerialNo"));
		return;
	} 
	if(_obj != null) {		
		window.serialNoWin = getA8Top().$.dialog({
	        title:'<fmt:message key="serial.no.input" />',
		    transParams:{'parentWin':window},
		    url: edocMarkURL+"?method=serialNoInputEntry",
		    targetWindow:getA8Top(),
		    width:"350",
		    height:"200"
		});
	}		   
	return;
}

/**
 * 手动输入内部文号回调函数
 */
function changeSerialNoCallback(receivedObj){
	if(receivedObj != undefined){  
        _obj = document.getElementById("serialNo"); 
        seSerialNoEdit(_obj);
        for (var i = 0; i < _obj.options.length; i++) {
            var a = _obj.options[i].value;
            if (a == receivedObj[0]) {
                _obj.options[i].selected = true;
                return;
            }
        }
        var option = document.createElement("OPTION");
        //option.value = receivedObj[0];
        option.text = receivedObj[1];
        //文号值改为和显示值一样，不用两端加 | 符号
        option.value = option.text;
        _obj.options.add(option);
        option.selected = true;
        isUpdateEdocForm = true;
        edocMarkUpd=true;
    }
}

function seSerialNoEdit(wordObj) {
	var i;
	var jsObj=null;
	var divObj=null;
	if(wordObj.disabled==true || (wordObj.tableName!="SELECT" && wordObj.readOnly==true)) {
		for(i=0;i<fieldInputListArray.length;i++) {			
			if(fieldInputListArray[i].fieldName==wordObj.name) {
				jsObj=fieldInputListArray[i];
				break;
			}
		}			
		if(jsObj!=null) {	
			jsObj.change(wordObj);		
			addEditWordNoImage(document.getElementById(wordObj.id));
		}
	}
}

</script>
<c:set value="${v3x:parseElementsOfTypeAndId(bean.sendToId)}" var="sendToOrgEles"/>
<v3x:selectPeople id="sendToSelect" 
	  panels="Account,Department,ExchangeAccount,OrgTeam" 
	  selectType="Account,Department,ExchangeAccount,OrgTeam" 
	  jsFunction="setPeopleFields(elements)" 
	  originalElements="${sendToOrgEles}"  
	  viewPage="" 
	  minSize="0"/>
	  
<v3x:selectPeople id="copyToSelect" 
	  panels="Account,Department,ExchangeAccount,OrgTeam" 
	  selectType="Account,Department,ExchangeAccount,OrgTeam" 
	  jsFunction="setPeopleFields(elements)" 
	  originalElements="${copyToSelect}"
	  viewPage="" 
	  minSize="0"  />	  

<v3x:selectPeople id="distributerSelect" 
	panels="Department,Post,Team" 
	selectType="Member" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
 	jsFunction="setPeopleFields(elements, 'detailIframe')" 
 	viewPage="" 
 	minSize="0" 
 	maxSize="1" 
 	/>
 <script type="text/javascript">
<!--
try {
    lastSelSendToUnit = getNamesString(elements_sendToSelect, "、");
    lastSelCopyToUnit = getNamesString(elements_copyToSelect, "、");
} catch (e) {
}
   
//-->
</script>

	<div align="center">
		<table style="BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; WIDTH: 624px; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-RIGHT: medium none" class="xdLayout" border="1" borderColor="buttontext">
			<colgroup>
				<col style="WIDTH: 106px"/>
				<col style="WIDTH: 179px"/>
				<col style="WIDTH: 101px"/>
				<col style="WIDTH: 238px"/>
			</colgroup>
			<tbody vAlign="top">
				<tr style="MIN-HEIGHT: 30px">
					<%-- 收文登记单 --%>
					<td colSpan="4" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #000000 1pt; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div align="center"><font color="#ff0000" size="6"><fmt:message key="edoc.element.receive.register_form"></fmt:message></font></div>
					</td>
				</tr>
				<tr style="MIN-HEIGHT: 30px">
					<%-- 标题 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="exchange.edoc.title" bundle="${exchangeI18N }"/></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<%--<input id="subject" name="subject" value="${bean.subject}" style="PADDING-BOTTOM: 1%; PADDING-LEFT: 1%; WIDTH: 100%; PADDING-RIGHT: 1%; PADDING-TOP: 1%" class="xdTextBox" /> xiangfan 注释，修复GOV-4404--%>
						<textarea name="subject" id="subject" style="padding-bottom: 1%; padding-left: 1%; width: 100%; padding-right: 1%; padding-top: 1%;" wrap="physical" access="edit" allowprint="true" allowtransmit="true" required="null" canSubmit="true" value="${bean.subject}">${bean.subject}</textarea>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 收文编号 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.serial_no" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<select id="serialNo" name="serialNo" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option selected value=""><fmt:message key="common.pleaseSelect.label"/><fmt:message key="edoc.element.receive.serial_no" /></option>
							<c:forEach var="serialNoBean" items="${serialNoList}">
							<option value="${serialNoBean.wordNo}" ${serialNoBean.wordNo==bean.serialNo?'selected=selected':'' }>${serialNoBean.mark} </option>
							</c:forEach>
						</select>
						<IMG id="imgSerialNo" onclick=changeSerialNo(); style="display:none" src="<%=request.getContextPath() %>/apps_res/edoc/images/wordnochange.gif">
					</td>
					<%--  来文文号 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="edoc.communicationsSymbol" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						 <INPUT id="docMark" name="docMark" value="${bean.docMark}" style="WIDTH: 100%; HEIGHT: 24px;" class="xdTextBox" />
					</td>
				</tr>
				
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 公文种类 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.doctype" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<select id="docType" name="docType" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='401'></option>
							<v3x:metadataItem metadata="${edocTypeMetadata}" showType="option" name="docType" bundle="${colI18N}" selected="${bean.docType}" />
						</select>
					</td>
					<%-- 来文类别 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.send_unit_type" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<select id="sendUnitType" name="sendUnitType" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='411'></option>
							<v3x:metadataItem metadata="${sendUnitTypeData}" showType="option" name="sendUnitType" selected="${bean.sendUnitType}"/>
						</select>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 打印份数 --%>
					 <td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
                        <div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.prints"/></font></div>
                    </td>
                    <td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
                            <INPUT name="registerCopies" id="registerCopies" value="${bean.copies }" style="WIDTH: 100%; HEIGHT: 24px;" class="xdTextBox" title="" />
                    </td>
					<%-- 密级 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="edoc.dense" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<select id="secretLevel" name="secretLevel" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='403'></option>
							<v3x:metadataItem metadata="${edocSecretLevelData}" showType="option" name="secretLevel" selected="${bean.secretLevel}"/>					
						</select>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 紧急程度 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.urgentlevel" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<select id="urgentLevel" name="urgentLevel" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='404'></option>
							<v3x:metadataItem metadata="${edocUrgentLevelData}" showType="option" name="urgentLevel" selected="${bean.urgentLevel}"/>
						</select>
					</td>
					<%-- 保密期限 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="exchange.edoc.keepperiod2" bundle="${exchangeI18N }"/></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<select name="keepPeriod" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='405'></option>
							<v3x:metadataItem metadata="${edocKeepPeriodData}" showType="option" name="keepPeriod" selected="${bean.keepPeriod}"/>
						</select>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 成文日期  --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.edoc_date" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<INPUT id="edocDate" name="edocDate" id='edocDate' value="${bean.edocDate }" onclick="whenstart('${pageContext.request.contextPath}', document.all.edocDate,575,140);"   style="WIDTH: 100%; HEIGHT: 24px; CURSOR: hand" class="xdTextBox input-date" title="" readOnly />
					</td>
					 <%-- 公文级别 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="edoc.unitLevel.label" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<select name="unitLevel" style="width: 100%; height: 24px" class="xdComboBox xdBehavior_Select">
							<option value='' itemName='405'></option>
							<v3x:metadataItem metadata="${edocUnitLevelData}" showType="option" name="unitLevel" selected="${bean.unitLevel}"/>
						</select>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 成文单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.edoc_unit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<INPUT id="edocUnit" name="edocUnit" value="${bean.edocUnit}" style="WIDTH: 100%; HEIGHT: 24px;" class="xdTextBox" />
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 主送单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.sendtounit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<TEXTAREA id="sendTo" name="sendTo" value="${fn:escapeXml(bean.sendTo)}" onkeyup="_checkInputIds(this)" onfocus="formOnfocus('sendTo')" onblur="formOnblur('sendTo');" style="WIDTH: 100%; HEIGHT: 24px; CURSOR: hand;">${v3x:toHTMLWithoutSpace(bean.sendTo)}</TEXTAREA>
						<img src="<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif" onclick="selectType=1; selectPeopleFun_sendToSelect();" title="点击选择"/>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 抄送单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.copytounit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<TEXTAREA name="copyTo" value="${fn:escapeXml(bean.copyTo)}" onfocus="formOnfocus('copyTo')" onkeyup="_checkInputIds(this)" onblur="formOnblur('copyTo');" style="WIDTH: 100%; HEIGHT: 24px; CURSOR: hand;">${v3x:toHTMLWithoutSpace(bean.copyTo)}</TEXTAREA>		
						<img src="<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif" onclick="selectType=2;selectPeopleFun_copyToSelect()" title="点击选择"/>	
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 31px">
					<%-- 登记人 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.edoctitle.regPerson.label" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<INPUT name="registerUserName" value="${bean.registerUserName }" style="WIDTH: 100%; HEIGHT: 24px;" class="xdTextBox" title="" readOnly/>
					</td>
					<%-- 登记日期 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align:right;"><font color="#ff0000" size="4"><fmt:message key="edoc.edoctitle.regDate.label" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<fmt:formatDate value='${bean.registerDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' var="registerDate"/>	
						<INPUT name="registerDate" value="${registerDate }" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);"  style="WIDTH: 100%; HEIGHT: 24px; CURSOR: hand" class="xdTextBox input-date" title="">
					</td>
				</tr>
				
				
				<%-- 根据国家行政公文规范,去掉主题词
				<tr style="MIN-HEIGHT: 32px">
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div><font color="#ff0000" size="4"><fmt:message key="edoc.element.keyword" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<INPUT name="keywords" id="keywords" value="${v3x:toHTML(bean.keywords) }" style="WIDTH: 100%; HEIGHT: 24px;" class="xdTextBox" />
						<!-- lijl add -->
						<img src="<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif" title="单击选择主题词" onclick="openSelectKeywordWin();">
					</td>
				</tr> --%>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 分发人 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.distributer" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<INPUT name="distributer" value="${bean.distributer }" style="WIDTH: 100%; HEIGHT: 24px; CURSOR: hand" class="xdTextBox" title="" readOnly />
						<a onclick="selectType=3;selectPeopleFun_distributerSelect();" class="ico16 select_single_16"></a>
					</td>
				</tr>
			
				<tr style="MIN-HEIGHT: 30px">
					<%-- 附件说明 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.att_note" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<%-- GOV-4502 公文登记附言中输入特俗字符后，打开发现附言框变小了 --%>
						<TEXTAREA name="attNote"  style="WIDTH: 100%; HEIGHT: 60px;" >${v3x:toHTML(bean.attNote) }</TEXTAREA>		
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 31px">
					<%-- 附注 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.note_append" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<INPUT name="noteAppend" value="${v3x:toHTML(bean.noteAppend) }" style="WIDTH: 100%; HEIGHT: 24px; " class="xdTextBox" title="">
					</td>
				</tr>
				
				
			</tbody>
		</table>
	</div>	
