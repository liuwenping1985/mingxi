<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.common.SystemEnvironment" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script language="javascript">
var recUnitObj;
var selPerElements =new Properties();
var exclude_sendTo = new Array();
var exclude_copyTo = new Array();
var exclude_reportTo = new Array();
var exclude_sendTo2 = new Array();
var exclude_copyTo2 = new Array();
var exclude_reportTo2 = new Array();
var selSendVals = {};//保存之前选择的数据

<c:if test="${formModel.edocSummary.sendUnitId!=null && formModel.edocSummary.sendUnitId != ''}">
<c:set value="${formModel.edocSummary.sendUnitId}" var="su"/>
</c:if>
<c:if test="${formModel.edocSummary.sendUnitId2 != null && formModel.edocSummary.sendUnitId2 != ''}">
<c:set value="${formModel.edocSummary.sendUnitId2}" var="su2"/>
</c:if>
<c:set value="${v3x:parseElementsOfTypeAndId(su)}" var="typeAndIdSu" />

<c:if test="${formModel.edocSummary.sendDepartmentId!=null && formModel.edocSummary.sendDepartmentId != ''}">
<c:set value="${formModel.edocSummary.sendDepartmentId}" var="sd"/>
</c:if>
<c:if test="${formModel.edocSummary.sendDepartmentId2 != null && formModel.edocSummary.sendDepartmentId2 != ''}">
<c:set value="${formModel.edocSummary.sendDepartmentId2}" var="sd2"/>
</c:if>
<c:set value="${v3x:parseElementsOfTypeAndId(sd)}" var="typeAndIdSd" />
var srcDispData_SendUint=parseElements("${v3x:escapeJavascript((typeAndIdSu))}");
var srcDispData_SendDepartment=parseElements("${v3x:escapeJavascript((typeAndIdSd))}");
var srcDispData_SendTo=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.sendToId)))}");
var srcDispData_copyTo=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.copyToId)))}");
var srcDispData_reportTo=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.reportToId)))}");

var srcDispData_SendUint2=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(su2)))}");
var srcDispData_SendDepartment2=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(sd2)))}");
var srcDispData_SendTo2=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.sendToId2)))}");
var srcDispData_copyTo2=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.copyToId2)))}");
var srcDispData_reportTo2=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.reportToId2)))}");

var srcDispData_printUnitId=parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.printUnitId)))}");
var srcDispData_undertakenoffice = parseElements("${v3x:escapeJavascript((v3x:parseElementsOfTypeAndId(formModel.edocSummary.undertakenofficeId)))}");


function confirmSelectPersonSetDefaultValue()
{
  if(obj=document.getElementById("my:send_unit")==null)
  {
    srcDispData_SendUint=null;
  }
  if(obj=document.getElementById("my:send_unit2")==null)
  {
    srcDispData_SendUint2=null;
  }
  
  if(obj=document.getElementById("my:send_department")==null)
  {
    srcDispData_SendDepartment=null;
  }
  if(obj=document.getElementById("my:send_department2")==null)
  {
    srcDispData_SendDepartment2=null;
  }
}

function setExchangeUnitFields(elements)
{ 
    
    if(recUnitObj.name == "my:send_to" || recUnitObj.name == "my:copy_to" ||recUnitObj.name == "my:report_to" ||
            recUnitObj.name == "my:send_to2" ||recUnitObj.name == "my:copy_to2" ||recUnitObj.name == "my:report_to2"){
        
        var _sq = v3x.getMessage("V3XLang.common_separator_label");//分隔符
        
        var srcVal = recUnitObj.value;
        var beforEls = selSendVals[recUnitObj.name];
        
        var newValue = _removeRepeat(srcVal, beforEls, _sq);
        
        var newSelVal = getNamesString(elements);
        newValue = _removeRepeat(newValue, newSelVal, _sq);
        if(newSelVal){
            if(newValue != ""){
                newValue += _sq;
            }
            newValue += newSelVal;
        }
        selSendVals[recUnitObj.name] = newSelVal;
        recUnitObj.value = newValue;
        
    }else if(recUnitObj.name=="my:send_unit" || recUnitObj.name=="my:send_unit2") {
        //recUnitObj.value = getFullNamesString(elements);
        recUnitObj.value = getNamesString(elements);
    } else {
        recUnitObj.value=getNamesString(elements);
    }
    //textarea不出现滚动条，自动扩展
    if(_changeTextareaHeight){
        _changeTextareaHeight(recUnitObj);
    }
  var inputIdObj = getIdObjs(recUnitObj.name);
  
  if(inputIdObj!=null){inputIdObj.value=getIdsString(elements);}
  selPerElements.put(recUnitObj.name,elements);
  
  
  //if(recUnitObj.name == "my:send_to"){
  //    exclude_sendTo = elements;
 // }else if(recUnitObj.name == "my:copy_to"){
  //    exclude_copyTo = elements;
 // }else if(recUnitObj.name == "my:report_to"){
 //     exclude_reportTo = elements;    
 // }else if(recUnitObj.name == "my:send_to2"){
 //     exclude_sendTo2 = elements;
 // }else if(recUnitObj.name == "my:copy_to2"){
 //     exclude_copyTo2 = elements;
 // }else if(recUnitObj.name == "my:report_to2"){
 //     exclude_reportTo2 = elements;   
 // }  
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

//获取显示字段对应的ID
function getIdObjs(name){
    
    var inputIdObj;
    if(name.charAt(name.length-1)=="2") {
      inputIdObj=document.getElementById(name.substr(0,name.length-1)+"_id2");
    } else {
      inputIdObj=document.getElementById(name+"_id");
    }
    
    return inputIdObj;
}

function openSelectKeywordWin() {
    var url = "<%=SystemEnvironment.getContextPath()%>/edocKeyWordController.do?method=selectKeyword";
    window.openSelectKeywordDialog = getA8Top().$.dialog({
        title:'<fmt:message key="selectPeople.page.title"  bundle="${v3xMainI18N}"/>',
        transParams:{'parentWin':window},
        url: url,
        targetWindow:getA8Top(),
        width:"608",
        height:"469"
    });
}

/**
 * 选择主题词回调函数
 */
function openSelectKeywordWinCallback(returnValue){
    if(returnValue){
        if(returnValue.length>85){
            alert(v3x.getMessage("edocLang.edoc_keyword_overflow")); 
        }else{
            document.getElementById("my:keyword").value = returnValue;
        }
    }
}
    
function openSelectUnitWin(selObjId)
{
  if(typeof(selObjId)== 'string')
  {
    recUnitObj=document.getElementById(selObjId);
  }
  else
  {
    if(document.all){  
        recUnitObj=window.event.srcElement;
    }else{
        recUnitObj=selObjId.target;
    }
  }  

  excludeElements_ExchangeUnit = new Array();

  if(recUnitObj.name == "my:send_to"){
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_copyTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
  }else if(recUnitObj.name == "my:copy_to"){
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_sendTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
  }else if(recUnitObj.name == "my:report_to"){  
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_sendTo,exclude_copyTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
  }else if(recUnitObj.name == "my:send_to2"){
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_sendTo,exclude_copyTo,exclude_reportTo,exclude_copyTo2,exclude_reportTo2);
  }else if(recUnitObj.name == "my:copy_to2"){
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_sendTo,exclude_copyTo,exclude_reportTo,exclude_sendTo2,exclude_reportTo2);
  }else if(recUnitObj.name == "my:report_to2"){ 
    excludeElements_ExchangeUnit = excludeElements_ExchangeUnit.concat(exclude_sendTo,exclude_copyTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2);
  }
  if(recUnitObj.name == "my:send_department"){
        selectPeopleFun_ExchangeDepartment();
  }else if(recUnitObj.name == "my:send_department2"){
      selectPeopleFun_ExchangeDepartment2();
  }else if(recUnitObj.name == "my:undertakenoffice"){//承办机构
      elements_UndertakenofficeSelect = selPerElements.get(recUnitObj.name,"");
      selectPeopleFun_UndertakenofficeSelect();
  }else{
    elements_ExchangeUnit=selPerElements.get(recUnitObj.name,"");
    selectPeopleFun_ExchangeUnit();
  }
}

/**
 * 初始化文单上选人界面元素
 * 
 * @param showEleId ：
 *            名称元素的ID， 必须
 * @param hideEleId :
 *            ID值的ID，必须
 * @param srcData ：
 *            初始值对象， 必须
 * @param typeValidParam :
 *            EdocType类型验证内容 { typeObj : 类型对象, 
 *                                 assertValue : 期望值, 
 *                                 assertType : 比较类型 eq:相等， nq : 不想等 
 *                                }
 *            不需要验证传null或不传
 */
function _initPeopleSelect(showEleId, hideEleId, srcData, typeValidParam) {

    var showEleObj = document.getElementById(showEleId);
    var hideEleObj = document.getElementById(hideEleId);

    var typeValValidRet = true;
    if(typeValidParam){
        var typeObj = typeValidParam["typeObj"];
        var assertValue = typeValidParam["assertValue"];
        var assertType = typeValidParam["assertType"];
        
        if(typeObj){
            if("eq" == assertType){
                typeValValidRet = (typeObj.value == assertValue);
            }else{
                typeValValidRet = (typeObj.value != assertValue);
            }
        }
    }

    if (showEleObj && typeValValidRet && showEleObj.readOnly == false) {
        
        if(showEleId == "my:send_to" || showEleId == "my:copy_to" ||showEleId == "my:report_to" ||
                showEleId == "my:send_to2" ||showEleId == "my:copy_to2" ||showEleId == "my:report_to2"){
            
            var param = {
                    "obj" : showEleObj,
                    "tip" : "点击选择",
                    "clickFn" : "openSelectUnitWin('" + showEleId + "')",
                    "extendAttr" : {}
            }
             _addImgAndEvent(param);
            
            selSendVals[showEleId] = getNamesString(srcData);
            
            if(window.addEventListener){ 
                // Mozilla, Netscape, Firefox
                showEleObj.addEventListener('keyup', function(){_checkInputIds(showEleObj);}, false); 
            } else { 
                // IE 
                showEleObj.attachEvent('onkeyup',  function(){_checkInputIds(showEleObj);}); 
            } 
            
        }else{
            
            showEleObj.onclick = openSelectUnitWin;
            showEleObj.readOnly = true;
            showEleObj.title = jsStr_ClickInput;
            showEleObj.style.cursor = "hand";
        }
    }

    if (showEleObj && hideEleObj && srcData) {
        selPerElements.put(showEleObj.name, srcData);
    }
}
 
 //手动输入主送单位时进行ID检验
function _checkInputIds(obj){
    
    var inputIdObj = getIdObjs(obj.name);
    if(inputIdObj){
        
        var objVal = obj.value;
        var objEles = selPerElements.get(obj.name, "");
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
            selSendVals[obj.name] = newLastSel;
            inputIdObj.value = newIds;
            selPerElements.put(obj.name, newEles);
        }
    }
}

//能否手动输入文号
var personInput='${personInput}';
var _isTemplete=false;
try{_isTemplete=isTemplete;}catch(e){}
function setObjEvent()
{
    var obj;
    var obj1;
    var type = document.getElementById("edocType");
    
    _initPeopleSelect("my:send_unit", "my:send_unit_id", srcDispData_SendUint, 
            {"typeObj":type,
             "assertValue":"1",
             "assertType":"nq"});
    
    //OA-22641  lixsh在拟文时，发文部门子段点击不能弹出选人界面  
    _initPeopleSelect("my:send_department", "my:send_department_id", srcDispData_SendDepartment, null);
    
    _initPeopleSelect("my:send_department2", "my:send_department_id2", srcDispData_SendDepartment2, null);
    
    _initPeopleSelect("my:send_to", "my:send_to_id", srcDispData_SendTo, null);
    
    _initPeopleSelect("my:copy_to", "my:copy_to_id", srcDispData_copyTo, null);
    
    _initPeopleSelect("my:report_to", "my:report_to_id", srcDispData_reportTo, null);
    
    _initPeopleSelect("my:send_unit2", "my:send_unit_id2", srcDispData_SendUint2, 
            {"typeObj":type,
             "assertValue":"1",
             "assertType":"nq"});
    
    _initPeopleSelect("my:send_to2", "my:send_to_id2", srcDispData_SendTo2, null);
    
    _initPeopleSelect("my:copy_to2", "my:copy_to_id2", srcDispData_copyTo2, null);
  
    _initPeopleSelect("my:report_to2", "my:report_to_id2", srcDispData_reportTo2, null);
    
    _initPeopleSelect("my:print_unit", "my:print_unit_id", srcDispData_printUnitId, null);
    
    _initPeopleSelect("my:undertakenoffice", "my:undertakenoffice_id", srcDispData_undertakenoffice, null);
  
  obj = document.getElementById("my:doc_mark");
  
  if(type.value!="1"){
      if(obj!=null && ((obj.tagName=="SELECT" && obj.disabled==false) || (obj.tagName=="INPUT" && obj.readOnly==false)) && _isTemplete!=true){
          addEditWordNoImage(obj);
      }
      //j????????}????????
      obj = document.getElementById("my:doc_mark2");
      if(obj!=null && ((obj.tagName=="SELECT" && obj.disabled==false) || (obj.tagName=="INPUT" && obj.readOnly==false)) && _isTemplete!=true){
          addEditWordNoImage(obj);
      }
  }

  //为主题词输入框添加
  obj = document.getElementById("my:keyword");
  if(obj!=null && obj!=null && obj != null && obj.readOnly==false){
      addEditKeywordImage(obj);
   }
  
   //内部文号添加手写图标，让用户可以点击图标，输入内部文号.
   //GOV-4731.调用发文模版，文号默认为空 start
  obj = document.getElementById("my:serial_no"); 
  if(obj!=null && ((obj.tagName=="SELECT" && obj.disabled==false) || (obj.tagName=="INPUT" && obj.readOnly==false)) 
          && _isTemplete!=true && personInput=='true'){
        addEditSerialNoImage(obj);
  }
  //GOV-4731.调用发文模版，文号默认为空 end
  if(type.value=="1")
  {
    obj = document.getElementById("my:send_unit");
    if(obj!=null && obj.readOnly==false)
    {
      addEditSendUintImage(obj);
    } 
    
    obj = document.getElementById("my:send_unit2");
    if(obj!=null && obj.readOnly==false)
    {
      addEditSendUintImage(obj);
    }
  }
  
}
if (typeof(HTMLElement) != "undefined") {
        //insertAdjacentElement
        HTMLElement.prototype.insertAdjacentElement = function(where, parsedNode) {
            switch (where) {
                case "beforeBegin":
                    this.parentNode.insertBefore(parsedNode, this);
                    break;
                case "afterBegin":
                    this.insertBefore(parsedNode, this.firstChild);
                    break;
                case "beforeEnd":
                    this.appendChild(parsedNode);
                    break;
                case "afterEnd":
                    if (this.nextSibling)
                        this.parentNode.insertBefore(parsedNode, this.nextSibling);
                    else
                        this.parentNode.appendChild(parsedNode);
                    break;
            }
        }
        
        if ((typeof Range !== "undefined") && !Range.prototype.createContextualFragment) {
            Range.prototype.createContextualFragment = function(html) {
                var frag = document.createDocumentFragment(), 
                div = document.createElement("div");
                frag.appendChild(div);
                div.outerHTML = html;
                return frag;
            };
        }
        
        HTMLElement.prototype.insertAdjacentHTML = function(where, htmlStr) {
            var r = this.ownerDocument.createRange();
            r.setStartBefore(this);
            try{
              var parsedHTML = r.createContextualFragment(htmlStr);
              this.insertAdjacentElement(where, parsedHTML);
            }catch(e){}
            
        }
        HTMLElement.prototype.insertAdjacentText = function(where, txtStr) {
            var parsedText = document.createTextNode(txtStr);
            this.insertAdjacentElement(where, parsedText);
        }
}

/**
 * 添加图片
 * @param obj
 * @param tip 提示
 * @param clickFn 点击事件
 */
function _addImgAndEvent(param){
    
    var obj = param.obj;
    var tip = param.tip;
    var clickFn = param.clickFn;
    var extendAttr = param.extendAttr;
    
    var image = "&nbsp;&nbsp;<img src=\"<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif\" onclick=\"" + clickFn + "\" ";
    if(tip){
        image += " title=\"" + tip +"\" ";
    }
    if(extendAttr){
        for(var key in extendAttr){
            image += " "+key+"=\"" + extendAttr[key] +"\" ";
        }
    }
    image += "/>";
    obj.insertAdjacentHTML("afterEnd",image);
}

function addEditWordNoImage(obj)
{
   //var image = "&nbsp;&nbsp;<img src=\"<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif\" onclick=\"WordNoChange('"+obj.id+"');\">";;
   //obj.insertAdjacentHTML("afterEnd",image);
   
   var param = {
           "obj" : obj,
           "tip" : "",
           "clickFn" : "WordNoChange('"+obj.id+"')",
           "extendAttr" : {}
   }
    _addImgAndEvent(param);
}
//添加内部文号输入图标。
function addEditSerialNoImage(obj){
   //var image = "&nbsp;&nbsp;<img src=\"<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif\" onclick=\"SerialNoChange();\">";;
   //obj.insertAdjacentHTML("afterEnd",image);
   var param = {
           "obj" : obj,
           "tip" : "",
           "clickFn" : "SerialNoChange()",
           "extendAttr" : {}
   }
    _addImgAndEvent(param);
}

//添加主题词输入图标。
function addEditKeywordImage(obj){
   //var image = "&nbsp;&nbsp;<img src=\"<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/wordnochange.gif\" title=\"单击选择主题词\" onclick=\"openSelectKeywordWin();\" class=\"zhutici\">";;
   //obj.insertAdjacentHTML("afterEnd",image);
    var param = {
            "obj" : obj,
            "tip" : "单击选择主题词",
            "clickFn" : "openSelectKeywordWin()",
            "extendAttr" : {"class" : "zhutici"}
    }
     _addImgAndEvent(param);
}
function addEditSendUintImage(obj)
{
   var image = "&nbsp;&nbsp;<img src=\"<%=SystemEnvironment.getContextPath()%>/apps_res/edoc/images/selSendUnit.gif\" onclick=\"openSelectUnitWin('"+obj.id+"');\">";;
   obj.insertAdjacentHTML("afterEnd",image);
}

var isNeedCheckLevelScope_ExchangeUnit=false;
var isAllowContainsChildDept_ExchangeUnit = true;
var showAccountShortname_ExchangeUnit = "auto";
var isCheckInclusionRelations_ExchangeUnit = false;
var isCanSelectGroupAccount_ExchangeUnit=false;
var isAllowContainsChildDept_ExchangeDepartment=true;
var isAllowContainsChildDept_ExchangeDepartment2=true;
var isCanSelectGroupAccount_UndertakenofficeSelect=false;//承办机构设置成不能选择根单位

</script>
<v3x:selectPeople id="ExchangeUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />
<%--OA-22641  lixsh在拟文时，发文部门子段点击不能弹出选人界面   --%>
<v3x:selectPeople id="ExchangeDepartment" panels="Department" selectType="Department" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />
<v3x:selectPeople id="ExchangeDepartment2" panels="Department" selectType="Department" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />
<v3x:selectPeople id="UndertakenofficeSelect" panels="Account,Department" selectType="Account,Department" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />

<input type="hidden" name="my:send_unit_id" id="my:send_unit_id" value="${formModel.edocSummary.sendUnitId}">
<input type="hidden" name="my:send_to_id" id="my:send_to_id" value="${formModel.edocSummary.sendToId}">
<input type="hidden" name="my:copy_to_id" id="my:copy_to_id" value="${formModel.edocSummary.copyToId}">
<input type="hidden" name="my:report_to_id" id="my:report_to_id" value="${formModel.edocSummary.reportToId}">

<input type="hidden" name="my:send_unit_id2" id="my:send_unit_id2" value="${formModel.edocSummary.sendUnitId2}">
<input type="hidden" name="my:send_to_id2" id="my:send_to_id2" value="${formModel.edocSummary.sendToId2}">
<input type="hidden" name="my:copy_to_id2" id="my:copy_to_id2" value="${formModel.edocSummary.copyToId2}">
<input type="hidden" name="my:report_to_id2" id="my:report_to_id2" value="${formModel.edocSummary.reportToId2}">

<input type="hidden" name="my:print_unit_id" id="my:print_unit_id" value="${formModel.edocSummary.printUnitId}">

<input type="hidden" name="my:send_department_id" id="my:send_department_id" value="${formModel.edocSummary.sendDepartmentId}">
<input type="hidden" name="my:send_department_id2" id="my:send_department_id2" value="${formModel.edocSummary.sendDepartmentId2}">
<input type="hidden" name="my:undertakenoffice_id" id="my:undertakenoffice_id" value="${formModel.edocSummary.undertakenofficeId}"/>