<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>提及我的列表</title>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp" %>
<script type="text/javascript">
var needDisplayNames = '${param.needDisplayNames}';
var id="${planRefCfg.id}";
var dayPlanCount="${planRefCfg.dayPlanCount}";
var weekPlanCount="${planRefCfg.weekPlanCount}";
var monthPlanCount="${planRefCfg.monthPlanCount}"; 
var anyScopePlanCount="${planRefCfg.anyScopePlanCount}";
var formatedPersonIds="";
var personIds="${planRefCfg.referenceIds}";
var personString="${ctp:showOrgEntitiesOfIds(planRefCfg.referenceIds,'Member',pageContext)}";
var subTableName = "${param.subTableName}";
var formId = "${param.formId}";
var listDataObj = null;
var descFieldName = "";
function initUI(){
	$("#setup").html('${ctp:i18n("plan.referMeSetup")}');
}
function initTable (userIds) {
      initData();
      refrenceCondition.userIds = userIds;
      refrenceCondition.subTableName = subTableName;
      refrenceCondition.formId = formId;
      refrenceCondition.descFieldName = descFieldName;
      $("#repeatList").ajaxgridLoad(refrenceCondition);
}
/**
 * 初始化任务里列表数据
 */
function initData() {
    initListData();
}
/**
 * 初始化列表数据
 */
 
function initListData() {
    var colModelString = initCol();
    listDataObj = $("#repeatList").ajaxgrid(
                    {
                        resizable:false,
                        colModel : colModelString,
                        dblclick : doubleClickEvent,        
                        onSuccess : bindCheckBoxEvent,
                        managerName : "planManager",
                        managerMethod : "getRepeatList",
                        sortname: "createTime",
                        sortorder: "desc",
                        parentId : $('.layout_center').eq(0).attr('id')
                    });
}
function initCol(){
	var colNames="";
	var discriptionNum="";
	if(needDisplayNames!=""){
	    var temp = needDisplayNames.split("!");
	    colNames = temp[0].split(",");
	    discriptionNum = temp[1];
	    if (temp.length > 2) {
	    	descFieldName = temp[2];
	    }
	}
	var colobj1 = new Object();
    colobj1.display="id";
    colobj1.name="id";
    colobj1.width="5%";
    colobj1.align="center";
    colobj1.type="checkbox";
    var arr = new Array();
    arr.push(colobj1);
    var discripwidth = 66-(colNames.length-1)*10;//67=100-5-8-20-1; 100%减去id 发起者，计划标题 的像素，然后再减去除事项描述的几个字段的宽度10，再给1给滚动条，剩下的都分给事项描述
	for(var i=0;i<colNames.length;i++){
		var colobj = new Object();
		colobj.display=colNames[i];
		colobj.name="field"+(i+1);
		colobj.sortable = "true";
	    if(i==discriptionNum-1){
	       colobj.width =discripwidth+"%";
	    }else{
	       colobj.width ="10%";
	    }
	   arr.push(colobj);
	}
	var colobj2 = new Object();
    colobj2.display=$.i18n('plan.sender');
    colobj2.name="senderName";
    colobj2.width="8%";
    colobj2.sortable = "true";
    arr.push(colobj2);
    var colobj2 = new Object();
    colobj2.display=$.i18n('plan.title');
    colobj2.name="planTitle";
    colobj2.width="20%";
    colobj2.sortable = "true";
    arr.push(colobj2);
	return arr;
}
function doubleClickEvent(data, r, c) {
   clickEvent(data, r, c);
}
function clickEvent(data, r, c){
	if(data.planId!=undefined&&data.planId!=""){
      //打开计划
      openPlan(data.planId,function(){},true,false,function(){},true);
    }
}
function referSetup(){
    showRefConfigPanel();
}
function selectPeople(){
      formatPersonIds();
      var obj = new Object();
      obj.type='selectPeople';
      if(formatedPersonIds!=""){
      	obj.value=formatedPersonIds;
        obj.text = personString;
      }
      $.selectPeople({
        panels: 'Department,Team,Post,Level,Outworker,RelatePeople',
        selectType: 'Member',
        minSize: 0,
        maxSize: 200, 
        isNeedCheckLevelScope : false,
        params : obj,
        callback : function(ret) {
            formatedPersonIds = ret.value;
            personString = ret.text;
          $("#selectPeople").val(personString);
        }
    });
    
}
function formatPersonIds(){
    if(personIds=="" || personIds == null){return;}
    var ids = personIds.split(",");
    var formatId="";
    formatedPersonIds="";
    for(var i=0;i<ids.length;i++){
        var id = ids[i];
        formatId = "Member|"+id;
        formatedPersonIds += formatId;
        if(i != ids.length-1){
            formatedPersonIds+=",";
        }
    }
}
function disFormatPersonIds(){
    if(formatedPersonIds==""){personIds="";return;}
    var ids = formatedPersonIds.split(",");
    var formatId="";
    personIds="";
    for(var i=0;i<ids.length;i++){
        var id = ids[i];
        formatId = id.split("|");
        personIds += formatId[1];
        if(i!=ids.length-1){
            personIds+=",";
        }
    }
}
function submitConfigForm(){
    disFormatPersonIds();
    dayPlanCount = $("#dayPlanCountSelect").val();
    weekPlanCount = $("#weekPlanCountSelect").val();
    monthPlanCount = $("#monthPlanCountSelect").val();
    anyScopePlanCount = $("#anyScopePlanCountSelect").val();
    var obj=new Object();
    obj.id=id;
    obj.dayPlanCount=parseInt(dayPlanCount);
    obj.weekPlanCount=parseInt(weekPlanCount);
    obj.monthPlanCount=parseInt(monthPlanCount);
    obj.anyScopePlanCount=parseInt(anyScopePlanCount);
    obj.referenceIds=personIds;
    obj.refType = 1;//1表示提及我的参照配置，0表示计划参照配置
    var pm = new planManager();
    pm.saveRefConfig(
        obj,
        {
            success:function(ret){
                id= ret.id;
                dayPlanCount = ret.dayPlanCount;
                weekPlanCount = ret.weekPlanCount;
                monthPlanCount = ret.monthPlanCount;
                anyScopePlanCount = ret.anyScopePlanCount;
                personIds = ret.referenceIds;
                refrenceCondition.dayPlanCount = dayPlanCount;
                refrenceCondition.weekPlanCount = weekPlanCount;
                refrenceCondition.monthPlanCount = monthPlanCount;
                refrenceCondition.anyScopePlanCount = anyScopePlanCount;
                refrenceCondition.refType=1;
                initTable(personIds);//这里就查指定人发给我的计划
            }
        }

    );
}
function showRefConfigPanel(){
    $("#selectPeople").val(personString);
    $("#weekPlanCountSelect").val(weekPlanCount);
    $("#dayPlanCountSelect").val(dayPlanCount);
    $("#monthPlanCountSelect").val(monthPlanCount);
    $("#anyScopePlanCountSelect").val(anyScopePlanCount);
    var configDialog = $.dialog({
        id: 'html',
        htmlId: 'configPanel',
        width:400,
        height:140,
        title: "${ctp:i18n('plan.numberSet')}",
        buttons:[{
            text: "${ctp:i18n('plan.alert.plannew.confirm')}",
            handler: function () {
                submitConfigForm();
                configDialog.close();
            }
        }, {
            
            text: "${ctp:i18n('plan.alert.plannew.cancel')}",
            handler: function () {
                configDialog.close();
            }
        }]
    });
}

$(document).ready(function() {
   initUI();
   refrenceCondition = new refrenceCondition("",dayPlanCount,weekPlanCount,monthPlanCount,anyScopePlanCount);
   initTable(personIds);//初始化数据
}); 
</script>
</head>
<body class="h100b">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:23,sprit:false,border:false">
            <div id="setup" class="color_black font_size12 padding_5"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="repeatList" class="flexme3" style="display: none"></table>
        </div>
        <div  class="hidden align_center overflow_hidden" id="configPanel">
                    <table align="center" class="w100b margin_t_5">
                        <tr  id="selectPeopleArea" style="height:30px;" class="display_none">
                                <td width="80">${ctp:i18n('plan.label.reference.selectpeople')}:</td>
                                <td colspan="2" class='align_left'><input id="selectPeople" type="text" value="${ctp:showOrgEntitiesOfIds(planRefCfg.referenceIds,'Member',pageContext)}" onclick="selectPeople()" style="width:290px;"/></td>
                        </tr>
                        <tr id="planTypeArea" style="height:25px;">
                                <td>${ctp:i18n('plan.label.reference.selectplan')}: </td>
                                <td align="right" valign="bottom" style="line-height:25px;">
                                        ${ctp:i18n('plan.type.weekplan')}：
                                </td>
                                <td align="left" width="230">${ctp:i18n('plan.label.reference.rencently')}
                                    <select id="weekPlanCountSelect" style="width:40px;height:20px">
                                        <c:forEach  begin="1" end="12" varStatus="status" var="count">
                                            <option value="${count}" <c:if test="${count==planRefCfg.weekPlanCount}">selected</c:if>>${count}</option>
                                        </c:forEach>
                                    </select>
                                    ${ctp:i18n('plan.desc.article')}
                                </td>
                        </tr>
                        <tr style="height:25px;">
                                <td></td>
                                <td align="right" valign="bottom" style="line-height:25px;">
                                        ${ctp:i18n('plan.type.monthplan')}：
                                </td>
                                <td align="left">${ctp:i18n('plan.label.reference.rencently')}
                                    <select id="monthPlanCountSelect" style="width:40px;">
                                        <c:forEach  begin="1" end="3" varStatus="status" var="count">
                                            <option value="${count}" <c:if test="${count==planRefCfg.monthPlanCount}">selected</c:if>>${count }</option>
                                        </c:forEach>
                                    </select>
                                    ${ctp:i18n('plan.desc.article')}
                                </td>
                        </tr>
                        <tr style="height:25px;">
                                <td></td>
                                <td align="right" valign="bottom" style="line-height:25px;">
                                         ${ctp:i18n('plan.type.dayplan')}：
                                </td>
                                <td align="left">${ctp:i18n('plan.label.reference.rencently')}
                                    <select  id="dayPlanCountSelect" style="width:40px;">
                                        <c:forEach  begin="1" end="31" varStatus="status" var="count">
                                            <option value="${count}" <c:if test="${count==planRefCfg.dayPlanCount}">selected</c:if>>${count }</option>
                                        </c:forEach>
                                    </select>
                                    ${ctp:i18n('plan.desc.article')}
                                </td>
                        </tr>
                        <tr style="height:25px;">
                                <td></td>
                                <td align="right" nowrap="nowrap" valign="bottom" style="line-height:25px;">
                                        ${ctp:i18n('plan.type.anyscopeplan')}：
                                </td>
                                <td align="left">${ctp:i18n('plan.label.reference.rencently')}
                                    <select  id="anyScopePlanCountSelect" style="width:40px;">
                                        <c:forEach  begin="1" end="12" varStatus="status" var="count">
                                            <option value="${count}" <c:if test="${count==planRefCfg.anyScopePlanCount}">selected</c:if>>${count }</option>
                                        </c:forEach>
                                    </select>
                                    ${ctp:i18n('plan.desc.article')}
                                </td>
                        </tr>
                    </table>
         </div>
    </div>
</body>
</html>