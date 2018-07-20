<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript">
var initPlanTable = function() {
      table = $("#myPlanList").ajaxgrid({
          colModel : [{
            display : "${ctp:i18n('plan.grid.label.title')}",
            name : 'title',
            width : '30%',
            sortable : true,
            align : 'left'
          },{
	        display : $.i18n('plan.grid.label.isMentioned'),
	        name : 'isMentioned',
	        width : '7%',
	        sortable : true,
	        align : 'left'
	      },{
            display : "${ctp:i18n('plan.grid.label.creator')}",
            name : 'createUserName',
            width : '10%',
            sortable : true,
            align : 'left'
          },{
           	display : "${ctp:i18n('plan.summary.tab.plantype')}",
           	name : 'type',
           	width : '10%',
           	sortable : true,
           	align : 'left'
          },{
            display : "${ctp:i18n('plan.initdata.startDate')}",
            name : 'startTime',
            cutsize : 10,
            width : '15%',
            sortable : true,
            align : 'left'
          }, {
            display : "${ctp:i18n('plan.initdata.endDate')}",
            name : 'endTime',
            cutsize : 10,
            width : '15%',
            sortable : true,
            align : 'left'
          }, {
            display : "${ctp:i18n('plan.label.reference.sendtime')}",
            name : 'createTime',
            width : '15%',
            //cutsize : 10,
            sortable : true,
            align : 'left'
          } ],
          vChange: true,
          vChangeParam: {
              overflow: "auto",
              autoResize:true
          },
          singleSelect:false,
          showTableToggleBtn: true,
          slideToggleBtn: true,
          parentId: "listArea",
          managerName : "planManager",
          managerMethod : "getPlansForRefrence",
          click : showPlan,
          onSuccess:bindCheckBoxEvent,
          render : rend
        });
  }
function reFreshConfigPanel(){};
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
       	height:240,
        title: "${ctp:i18n('plan.label.reference.refercondition')}",
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

function reFreshRefPersonList(){
	if(personIds==""||personString==""){return;}
	var ids = personIds.split(",");
	var names = personString.split("${ctp:i18n('common.separator.label')}");
	var divStr="<li class='padding_5' style='background-color:#296fbe;'><a class='color_black' style='width: 100px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;color:#ffffff' id='person_all' href='javascript:void(0)' onclick='loadListByPerson(\""+personIds+"\",true);' title='${ctp:i18n('plan.portal.label.allpeople')}' >${ctp:i18n('plan.portal.label.allpeople')}</a></li>";
	for(var i=0;i<ids.length;i++){
		var str="<li class='padding_5'><a class='color_black' style='width: 100px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;' id='person_"+ids[i]+"' href='javascript:void(0)' onclick='loadListByPerson(\""+ids[i]+"\");' title='"+names[i]+"'>"+names[i]+"</a></li>";
		divStr += str;
	}
	$("#refPersonList").html(divStr);
}
function loadListByPerson(id,isall){
	//#ffe6b0树节点选中颜色   #296fbe蓝色
	$("a[id^='person']").each(function(){$(this).parent().css("background-color","");});
	$("a[id^='person']").each(function(){$(this).css("color","");});
	if(isall){
		$("#person_all").parent().css("background-color","#296fbe");
		$("#person_all").css("color","#ffffff");
	}else{
		$("#person_"+id).parent().css("background-color","#296fbe");
		$("#person_"+id).css("color","#ffffff");
	}
	initTable(id,isall);
	//修正:参照计划时，点击某条计划后，选择右边人员，左边区域下面部分没有刷新
	document.getElementById("planContentFrame").src="";
	table.grid.resizeGridUpDown('down');
}
var id="${planRefCfg.id}";
var dayPlanCount="${planRefCfg.dayPlanCount}";
var weekPlanCount="${planRefCfg.weekPlanCount}";
var monthPlanCount="${planRefCfg.monthPlanCount}"; 
var anyScopePlanCount="${planRefCfg.anyScopePlanCount}";
var formatedPersonIds="";
var personIds="${planRefCfg.referenceIds}";
var personString="${ctp:showOrgEntitiesOfIds(planRefCfg.referenceIds,'Member',pageContext)}";

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
	obj.refType = 0;//1表示提及我的参照配置，0表示计划参照配置
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
				refrenceCondition.refType=0;
				initTable(personIds,true);
				reFreshRefPersonList();
			}
		}

	);
}

function selectPeople(){
	  formatPersonIds();
	  $.selectPeople({
	    panels: 'Department,Team,Post,Level,Outworker,RelatePeople',
	    selectType: 'Member',
	    minSize: 0,
	    maxSize: 200, 
	    isNeedCheckLevelScope : false,
	    params : {
	      type: 'selectPeople',
	      value : formatedPersonIds,
	      text : personString
	    },
	    callback : function(ret) {
	        if(ret.value.length > 0){
	          formatedPersonIds = ret.value;
	          personString = ret.text;
	        } else {
	          formatedPersonIds = "Member|" + $.ctx.CurrentUser.id;
	          personString = $.ctx.CurrentUser.name;
	        }
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
    personIds="";
	if(formatedPersonIds==""){return;}
	var ids = formatedPersonIds.split(",");
	var formatId="";
	for(var i=0;i<ids.length;i++){
		var id = ids[i];
		formatId = id.split("|");
		personIds += formatId[1];
		if(i!=ids.length-1){
			personIds+=",";
		}
	}
}

$().ready(function(){
	reFreshRefPersonList();
    initPlanTable();
    refrenceCondition = new refrenceCondition("",dayPlanCount,weekPlanCount,monthPlanCount,anyScopePlanCount);
    initTable(personIds,true);
    $("#grid_detail").css("overflow","hidden");
    formatPersonIds();
});
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_west " layout="border:true,width:137,minWidth:80,maxWidth:300,sprit:false"  >
			<div id="personList" class="font_size12 tree_area" style="height:400px;overflow-y:auto;overflow-x:hidden;">
				<div>
					<li class="padding_5">
						<a id="submitit" class="common_button common_button_gray" href="javascript:void(0)" onclick="showRefConfigPanel();">${ctp:i18n('plan.label.reference.refercondition')}</a>
					</li>
				</div>
				<div id="refPersonList">			
				</div>
				<div  class="hidden align_center overflow_hidden" id="configPanel">
					<table align="center" class="w100b">
						<tr  id="selectPeopleArea" style="height:30px;">
								<td width="80">${ctp:i18n('plan.label.reference.selectpeople')}:</td>
								<td colspan="2" class='align_left'><input id="selectPeople" type="text" value="${ctp:showOrgEntitiesOfIds(planRefCfg.referenceIds,'Member',pageContext)}" onclick="selectPeople()" style="width:290px;"/></td>
						</tr>
						<tr id="planTypeArea" style="height:25px;">
								<td>${ctp:i18n('plan.label.reference.selectplan')}: </td>
								<td align="right" valign="bottom" style="line-height:25px;">
<!--									<label for="Checkbox2" class="margin_r_5 hand"> -->
										${ctp:i18n('plan.type.weekplan')}：
<!--									</label>-->
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
<!--									<label for="Checkbox2" class="margin_r_5 hand"> -->
										${ctp:i18n('plan.type.monthplan')}：
<!--									</label>-->
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
<!--									<label for="Checkbox3" class="margin_r_5 hand"> -->
										 ${ctp:i18n('plan.type.dayplan')}：
<!--					 				</label> -->
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
<!--					 				<label for="Checkbox4" class="margin_r_5 hand">-->
										${ctp:i18n('plan.type.anyscopeplan')}：
<!--									</label>-->
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
		</div>
        <div class="layout_center over_hidden" id="listArea" layout="border:false">
            <table id="myPlanList" style="display: none"></table>
            <div id="grid_detail" style="overflow:hidden;">
        		<iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0"></iframe>
    		</div>
        </div>
    </div>
</body>
</html>