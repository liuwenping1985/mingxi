<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planListCommon.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计划</title>
</head>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript">
var Conditions = function(id,creatorId,planType,refAccountId,refDepartmentId,
        refProjectId,title,startTimeScope,endTimeScope,createTimeScope,
        status,planStatus,hasAttatchment,contentType,refUserId,refType,process,processTimeScope){
    this.id = id;
    this.creatorId=creatorId;
    this.planType = planType;
    this.refAccountId = refAccountId;
    this.refDepartmentId=refDepartmentId;
    this.refProjectId=refProjectId;
    this.title = title;
    this.startTimeScopeScope=startTimeScope;
    this.endTimeScope=endTimeScope;
    this.createTimeScope=createTimeScope;
    this.status=status;
    this.planStatus=planStatus;
    this.hasAttatchment=hasAttatchment;
    this.contentType=contentType;
    this.refUserId=refUserId;
    this.refType=refType;
    this.process=process;
    this.processTimeScope=processTimeScope;
};
function printPlan(){
    // var printSubject ="";
    var printsub = "<center><span style='font-size:24px;line-height:24px;'></span><hr style='height:1px' class='Noprint'&lgt;</hr></center>";
    
    // var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
    var colBody=convertTable();
    // var printSubFrag = new PrintFragment("",printsub );   
    var colBodyFrag= new PrintFragment("", colBody); 
    
    var cssList = new ArrayList();
    cssList.add("/apps_res/collaboration/css/collaboration.css")
    
    var pl = new ArrayList();
    // pl.add(printSubFrag);
    pl.add(colBodyFrag);
    printList(pl,cssList)
}


function convertTable(){      
    var mxtgrid = $("#id");
    var str = "";
    if(mxtgrid.length > 0 ){
        var tableHeader = jQuery(".hDivBox thead");               
        var tableBody = jQuery(".bDiv tbody");
        var headerHtml =tableHeader.html();
        var bodyHtml = tableBody.html();
        if(headerHtml == null || headerHtml == 'null'){
            headerHtml ="";
        }
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        bodyHtml = bodyHtml.replace(/text_overflow/g,'word_break_all');
        str+="<table class='only_table edit_table font_size12' border='0' cellspacing='0' cellpadding='0'>"
        str+="<thead>";
        str+=headerHtml;
        str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
    }
    return str;
}

function toBeanCollection(){
  $("#title").val("");
  var curHtml = convertTable();
  $("#contentHtml").val(curHtml);
  $("#planConditions").attr("action",_ctxPath+"/calendar/calEvent.do?method=reportForwardCol");
  $("#planConditions").submit();
}
var condition = new Conditions();
/**
 * 导出excel方法
 */
function exportToExcel() {
  var curUrl = _ctxPath+"/plan/plan.do?method=exportToExcel";

  if(condition.creatorId != null && $.trim(condition.creatorId)!=""){
  	curUrl = curUrl+"&creatorId="+condition.creatorId;
  }else{
	  curUrl = curUrl+"&creatorId=";
  }
  if(condition.status !=null && $.trim(condition.status)!=""){
  	curUrl = curUrl+"&status="+condition.status;
  }else{
	  curUrl = curUrl+"&status=";
  }
  if(condition.refType !=null && $.trim(condition.refType)!=""){
  	curUrl = curUrl+"&refType="+condition.refType;
  }else{
	  curUrl = curUrl+"&refType=";
  }
  if(condition.startTimeScope !=null && $.trim(condition.startTimeScope)!=""){
  	curUrl = curUrl+"&startTimeScope="+condition.startTimeScope;
  }else{
	  curUrl = curUrl+"&startTimeScope=";
  }
  if(condition.endTimeScope !=null && $.trim(condition.endTimeScope)!=""){
  	curUrl = curUrl+"&endTimeScope="+condition.endTimeScope;
  }else{
	  curUrl = curUrl+"&endTimeScope=";
  }
  if(condition.id !=null && $.trim(condition.id)!=""){
  	curUrl = curUrl+"&id="+condition.id;
  }else{
	  	curUrl = curUrl+"&id=";
  }
  if(condition.planType !=null && $.trim(condition.planType)!=""){
  	curUrl = curUrl+"&planType="+condition.planType;
  }else{
  	curUrl = curUrl+"&planType=";
  }
  if(condition.refAccountId !=null && $.trim(condition.refAccountId)!=""){
  	curUrl = curUrl+"&refAccountId="+condition.refAccountId;
  }else{
	  curUrl = curUrl+"&refAccountId=";
  }
  if(condition.refDepartmentId !=null && $.trim(condition.refDepartmentId)!=""){
  	curUrl = curUrl+"&refDepartmentId="+condition.refDepartmentId;
  }else{
	  curUrl = curUrl+"&refDepartmentId=";
  }
  if(condition.refProjectId !=null && $.trim(condition.refProjectId)!=""){
  	curUrl = curUrl+"&refProjectId="+condition.refProjectId;
  }else{
	  curUrl = curUrl+"&refProjectId=";
  }
  if(condition.title !=null && $.trim(condition.title)!=""){
  	curUrl = curUrl+"&title="+condition.title;
  }else{
	  curUrl = curUrl+"&title=";
  }
  if(condition.createTimeScope !=null && $.trim(condition.createTimeScope)!=""){
  	curUrl = curUrl+"&createTimeScope="+condition.createTimeScope;
  }else{
	  curUrl = curUrl+"&createTimeScope=";
  }
  if(condition.planStatus !=null && $.trim(condition.planStatus)!=""){
  	curUrl = curUrl+"&planStatus="+condition.planStatus;
  }else{
	  curUrl = curUrl+"&planStatus=";
  }
  if(condition.hasAttatchment !=null && $.trim(condition.hasAttatchment)!=""){
  	curUrl = curUrl+"&hasAttatchment="+condition.hasAttatchment;
  }else{
	  curUrl = curUrl+"&hasAttatchment=";
  }
  if(condition.contentType !=null && $.trim(condition.contentType)!=""){
  	curUrl = curUrl+"&contentType="+condition.contentType;
  }else{
	  curUrl = curUrl+"&contentType=";
  }
  if(condition.refUserId !=null && $.trim(condition.refUserId)!=""){
  	curUrl = curUrl+"&refUserId="+condition.refUserId;
  }else{
	  curUrl = curUrl+"&refUserId=";
  }
  if(condition.process !=null && $.trim(condition.process)!=""){
  	curUrl = curUrl+"&process="+condition.process;
  }else{
	  curUrl = curUrl+"&process=";
  }
  if(condition.processTimeScope !=null && $.trim(condition.processTimeScope)!=""){
  	curUrl = curUrl+"&processTimeScope="+condition.processTimeScope;
  }else{
	curUrl = curUrl+"&processTimeScope=";
  }
  $("#planConditions").attr("action",curUrl );
  $("#planConditions").jsonSubmit();
}
$().ready(function(){
  $("#toolbar").toolbar(
      {
        toolbar : [
            {
              name : "${ctp:i18n('report.queryReport.index_right.toolbar.synergy')}",
              click : toBeanCollection,
              className : "ico16 forwarding_16"
            },
            {
              name : "${ctp:i18n('calendar.event.create.out')}Excel",
              click : exportToExcel,
              className : "ico16 export_excel_16"
            },
            {
              name : "${ctp:i18n('report.queryReport.index_right.toolbar.print')}",
              click : printPlan,
              className : "ico16 print_16"
            } ]

      });
	condition.id="${param.id}";
	condition.creatorId="${param.creatorId}";
	condition.planType="${param.planType}";
	condition.refAccountId="${param.refAccountId}";
	condition.refDepartmentId="${param.refDepartmentId}";
	condition.refProjectId="${param.refProjectId}";
	condition.title="${param.title}";
	condition.startTimeScope="${param.startTimeScope}";
	condition.endTimeScope="${param.endTimeScope}";
	condition.createTimeScope="${param.createTimeScope}";
	condition.status="${param.status}";
	condition.planStatus="${param.planStatus}";
	condition.hasAttatchment="${param.hasAttatchment}";
	condition.contentType="${param.contentType}";
	condition.refUserId="${param.refUserId}";
	condition.refType="${param.refType}";
	condition.process="${param.process}";
	condition.processTimeScope="${param.processTimeScope}";
	initPlanTable();
	loadList(condition);
});
function loadList(condition){
	$("#planList").ajaxgridLoad(condition);
}
var initPlanTable = function(type, toPage) {
    var needpager = true; //是否需要翻页组件
    if (toPage == "myplan" && type < 4) { //我的计划中除了任意期计划外 其他三种都不需要翻页。
      needpager = false;
    }
      table = $("#planList").ajaxgrid({
      usepager : needpager,
      colModel : [{
        display : "${ctp:i18n('plan.grid.label.title')}",
        name : 'title',
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
          display : "${ctp:i18n('plan.grid.label.creator')}",
          name : 'createUserName',
          width : '10%',
          sortable : true,
          align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.begintime')}",
        name : 'startTime',
        cutsize : 10,
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.endtime')}",
        name : 'endTime',
        cutsize : 10,
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.finishratio')}",
        name : 'finishRatio',
        width : '10%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.status')}",
        name : 'planStatusName',
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.publishstatus')}",
        name : 'publishStatusName',
        width : '15%',
        sortable : true,
        align : 'left'
      } ],
      vChange: true,
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      width:"auto",
      showTableToggleBtn: false,
      slideToggleBtn: true,
      parentId: $('.layout_center').eq(0).attr('id'),
      managerName : "planManager",
      managerMethod : "getListByConditions",
      dblclick : showPlan,
      click : showPlan,
      render : rend
    });
 };
</script>
<body>    
    <form id="planConditions" action="" method="post" target="main">
            <input type="hidden" name="title" id="title"  />
            <input type="hidden" name="contentHtml" id="contentHtml"  />            
    </form>   
  <div id='layout' class="comp" comp="type:'layout'">
      <div class="layout_north" layout="border:false,height:30,maxHeight:100,minHeight:30">
          <div id="toolbar"></div>
      </div>
      <div class="layout_center stadic_layout_body stadic_body_top_bottom list" id="id" layout="border:false">
            <table id="planList" style="display: none"></table>
            <div id="grid_detail">
                <iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0"></iframe>
            </div>
      </div>      
  </div>
</body>
</html>