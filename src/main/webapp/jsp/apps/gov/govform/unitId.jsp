<%@ page language="java" pageEncoding="UTF-8"%>

<c:if test="${formModel.infoSummary.reportUnit!=null && formModel.infoSummary.reportUnit != ''}">
	<c:set value="${formModel.infoSummary.reportUnitId}" var="su"/>
</c:if>

<c:set value="true" var="personInput"/>

<script language="javascript">
var recUnitObj;
var selPerElements = new Properties();
var exclude_sendTo = new Array();
var exclude_copyTo = new Array();
var exclude_reportTo = new Array();
var exclude_sendTo2 = new Array();
var exclude_copyTo2 = new Array();
var exclude_reportTo2 = new Array();

var srcDispData_SendUint = "";
//能否手动输入文号
var personInput = '${personInput}';
var _isTemplete = false;
try {
	_isTemplete = isTemplete;
} catch(e) {}

//解决 r.createContextualFragment找不到方法的错误 IE9
if ((typeof Range !== "undefined") && !Range.prototype.createContextualFragment)
{
    Range.prototype.createContextualFragment = function(html)
    {
        var frag = document.createDocumentFragment(), 
        div = document.createElement("div");
        frag.appendChild(div);
        div.outerHTML = html;
        return frag;
    };
}

if(typeof(HTMLElement) != "undefined") {
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
	HTMLElement.prototype.insertAdjacentHTML = function(where, htmlStr) {
        var r = this.ownerDocument.createRange();
        r.setStartBefore(this);
        var parsedHTML = r.createContextualFragment(htmlStr);
        this.insertAdjacentElement(where, parsedHTML);
    }
    HTMLElement.prototype.insertAdjacentText = function(where, txtStr) {
        var parsedText = document.createTextNode(txtStr);
        this.insertAdjacentElement(where, parsedText);
    }
}

function confirmSelectPersonSetDefaultValue() {
  	if(obj=document.getElementById("my:send_unit")==null) {
    	srcDispData_SendUint=null;
  	}
  	if(obj=document.getElementById("my:send_unit2")==null) {
   		srcDispData_SendUint2=null;
  	}
}

function setExchangeUnitFields(elements) {
  	if(recUnitObj.name=="my:report_unit") {
		recUnitObj.value = getFullNamesString(elements);
	} else {
		recUnitObj.value=getNamesString(elements);
	}
  	var inputIdObj;
  	if(recUnitObj.name.charAt(recUnitObj.name.length-1)=="2") {
    	inputIdObj=document.getElementById(recUnitObj.name.substr(0,recUnitObj.name.length-1)+"_id2");
  	} else {
  		inputIdObj=document.getElementById(recUnitObj.name+"_id");
  	}
  	if(inputIdObj!=null) {
  	  	inputIdObj.value=getIdsString(elements);
  	}
  	selPerElements.put(recUnitObj.name,elements);
}

function openSelectKeywordWin() {
	var returnValue = v3x.openWindow({url:"/seeyon/infoKeyWordController.do?method=selectKeyword",height:488,width:608},resizable="no");
	if(returnValue){
		document.getElementById("my:keyword").value = returnValue;
	}
}

function openSelectUnitWin(selObjId) {
	if(typeof(selObjId)== 'string') {
	    recUnitObj=document.getElementById(selObjId);
	} else {
		if(document.all) {  
	    	recUnitObj=window.event.srcElement;
		} else {
			recUnitObj=selObjId.target;
		}
	}
	elements_ExchangeUnit=selPerElements.get(recUnitObj.name,"");
	excludeElements_ExchangeUnit = new Array();
	if(recUnitObj.name == "my:report_unit") {
		excludeElements_ExchangeUnit = eval("excludeElements_ExchangeUnit").concat(exclude_copyTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
		//selectPeopleFun_ExchangeUnit();
		
		var tempParams = {
				value : ""
			}
		var tempValueId = getSelectObjectId(recUnitObj);
		if(tempValueId && document.getElementById(tempValueId)){
			tempParams["value"] = document.getElementById(tempValueId).value;
		}
		var params = {
				panels:"Account",
				selectType:"Account",
				maxSize : 1,
				minSize : 0,
				params : tempParams
		}
		openSelectPeoplePanel(params);
		
	}else if(recUnitObj.name == "my:reporter"){
		excludeElements_ExchangeUnit = eval("excludeElements_ExchangeUnit").concat(exclude_sendTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
		//selectPeopleFun_auth();
		
		var tempParams = {
				value : ""
			}
		var tempValueId = getSelectObjectId(recUnitObj);
		if(tempValueId && document.getElementById(tempValueId)){
			tempParams["value"] = document.getElementById(tempValueId).value;
		}
		var params = {
				panels:"Department,Team,Post,Level",
				selectType:"Member",
				maxSize : 1,
				minSize : 0,
				params : tempParams
		}
		openSelectPeoplePanel(params);
		
	}else if(recUnitObj.name == "my:report_dept"){
		excludeElements_ExchangeUnit = eval("excludeElements_ExchangeUnit").concat(exclude_sendTo,exclude_reportTo,exclude_sendTo2,exclude_copyTo2,exclude_reportTo2);
		//selectPeopleFun_ExchangeDepartment();
		
		var tempParams = {
				value : ""
			}
		var tempValueId = getSelectObjectId(recUnitObj);
		if(tempValueId && document.getElementById(tempValueId)){
			tempParams["value"] = document.getElementById(tempValueId).value;
		}
		var params = {
				panels:"Department",
				selectType:"Department",
				maxSize : 1,
				minSize : 0,
				params : tempParams
		}
		openSelectPeoplePanel(params);
	}
}

/**
 * 获取部门，申报人，或单位相应的id
 */
function getSelectObjectId(pRecUnitObj){
  	var ret = "";
  	if(pRecUnitObj.name.charAt(pRecUnitObj.name.length-1)=="2") {
  		ret = pRecUnitObj.name.substr(0,recUnitObj.name.length-1)+"_id2";
  	} else {
  		ret = pRecUnitObj.name+"_id";
  	}
  	return ret;
}


/**
 * 打开选择用户面板
 */
function openSelectPeoplePanel(params){
	var config = {
			type : 'selectPeople',
			panels : 'Department',
			selectType : 'Member',
			text : $.i18n('common.default.selectPeople.value'),
			showFlowTypeRadio : false,
			returnValueNeedType : true,
			maxSize : 1,
			minSize : 1,
			params : {
				value : ""
			},
			targetWindow : window.top,
			callback : function(res) {
				if (res && res.obj) {
					var selPeopleId = "";
					var selPeopleName = "";
					if(res.obj.length > 0) {
						for ( var i = 0; i < res.obj.length; i++) {
							if (i == res.obj.length - 1) {
								selPeopleId += res.obj[i].type + "|" + res.obj[i].id;
								selPeopleName += res.obj[i].name;
							} else {
								selPeopleId += res.obj[i].type + "|" + res.obj[i].id + ",";
								selPeopleName += res.obj[i].name + ",";
							}
						}
					}
					if(recUnitObj.name=="my:report_unit") {
						//recUnitObj.value = getFullNamesString(elements);
						recUnitObj.value = selPeopleName;
					} else {
						//recUnitObj.value=getNamesString(elements);
						recUnitObj.value = selPeopleName;
					}
				  	var inputIdObj;
				  	if(recUnitObj.name.charAt(recUnitObj.name.length-1)=="2") {
				    	inputIdObj=document.getElementById(recUnitObj.name.substr(0,recUnitObj.name.length-1)+"_id2");
				  	} else {
				  		inputIdObj=document.getElementById(recUnitObj.name+"_id");
				  	}
				  	if(inputIdObj!=null) {
				  	  	inputIdObj.value=selPeopleId;
				  	}
				  	//selPerElements.put(recUnitObj.name,elements);
				} else {

				}
			}
		};
	
	if(params){
		for(var key in params){
			config[key] = params[key];
		}
	}
	$.selectPeople(config);
}


//修改文单
function setObjEvent() {
	var obj;
	var obj1;
	var type = document.getElementById("infoType");
  	obj = document.getElementById("my:report_unit");
  	//如果报送单中有上报单位
 	if(null != obj && obj.readOnly==false) {
 	 	//obj.ondblclick=openSelectUnitWin;obj.title=jsStr_ClickInput;obj.style.cursor="hand";
 	 	addEditSerialNoImage(obj);
 	}
  	obj1 = document.getElementById("my:report_unit_id");
  	
	//xiangfan添加 SP1 新需求项
  	obj = document.getElementById("my:report_dept");
  	if(null != obj && obj.readOnly==false){
  		addEditSerialNoImage(obj);
  	}
  	obj1 = document.getElementById("my:report_dept_id");
  	
  	obj=document.getElementById("my:reporter");
	if(obj!=null && type != null && obj.readOnly==false){
		$(obj).bind("click", openSelectUnitWin);
		$(obj).attr("readonly", true);
		$(obj).attr("title", jsStr_ClickInput);
		$(obj).css("cursor", "hand");
	}

  	if(obj!=null && obj1!=null) {
  	  	selPerElements.put(obj.name,srcDispData_SendUint);
  	}
  	
  	addEditDateImage();
  	
}

function addEditDateImage() {
	$("#govFormData").find(".input_date").each(function(i) {
	      $(this).compThis();
	});
}

//添加上报单位选择图标
function addEditSerialNoImage(obj){
	obj.readOnly = true;
	var image = "<img src=\"/seeyon/apps_res/edoc/images/wordnochange.gif\" onclick=\"openSelectUnitWin('"+obj.id+"');\" style=\"cursor:hand;margin-left:5px;margin-right:5px;\" />";
   	obj.insertAdjacentHTML("afterEnd",image);
   	var width = $(obj).width();
   	$(obj).width(width - 32);
}
	
//添加主题词输入图标。
function addEditKeywordImage(obj){
   	var image = "&nbsp;&nbsp;<img src=\"/seeyon/apps_res/edoc/images/wordnochange.gif\" title=\"${ctp:i18n('govform.label.selectKeywords')}\" onclick=\"openSelectKeywordWin();\">";//单击选择主题词
   	obj.insertAdjacentHTML("afterEnd",image);
}

function addEditSendUintImage(obj) {
  	var image = "&nbsp;&nbsp;<img src=\"/seeyon/apps_res/edoc/images/selSendUnit.gif\" onclick=\"openSelectUnitWin('"+obj.id+"');\">";
   	obj.insertAdjacentHTML("afterEnd",image);
}

</script>
<v3x:selectPeople id="ExchangeUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />
<v3x:selectPeople id="ExchangeDepartment" panels="Department" selectType="Department" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setExchangeUnitFields(elements)" viewPage="" minSize="0" maxSize="5000" showAllAccount="true" />
<v3x:selectPeople id="auth" minSize="0" panels="Department,Team,Post,Level" selectType="Department,Team,Member,Post,Level" jsFunction="setExchangeUnitFields(elements)" />
<input type="hidden" name="my:report_unit_id" id="my:report_unit_id" value="${summaryVO.summary.reportUnitId}" />
<input type="hidden" name="my:report_dept_id" id="my:report_dept_id" value="${summaryVO.summary.reportDeptId}" />
<input type="hidden" name="my:reporter_id" id="my:reporter_id" value="<c:if test="${summaryVO.summary.reportId != null && summaryVO.summary.reportId != ''}">Member|${summaryVO.summary.reportId}</c:if>" />
