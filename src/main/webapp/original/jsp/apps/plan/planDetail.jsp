<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager,enumManagerNew"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript" src="${path}/apps_res/plan/js/planPrint.js${v3x:resSuffix()}"></script>
<c:if test="${ctp:hasPlugin('taskmanage') }">
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('plan.dialog.showPlanTitle')}</title>
<style>
            .stadic_head_height{
                
            }
            .stadic_body_top_bottom{
                bottom: 0px;
                border-top-style:solid;
               	border-top-width:1px;
               	border-top-color:#b6b6b6;
               	overflow:auto;
            }
        </style>

</head>
<script type="text/javascript">
var v3x = new V3X();
var temp = true;
//转任务
function transmitTask(obj){
   if(!$.ctx.resources.contains('F02_projecttask')) {
     $.alert("${ctp:i18n('plan.noPurview.trans_task')}");
     return;
   }
   <c:if test="${!v3x:hasPlugin('taskmanage')}">
     $.alert("${ctp:i18n('plan.noPurview.trans_task')}");
     return;
    </c:if>
    
   //得到这一行的数据
   var lineData = $("#mainbodyFrame")[0].contentWindow.$("#img").data("currentRow");
   //调用转发任务接口
   var datas = lineData.datas;
   var obj = new Object();
   obj.flag = 1;
   var ishaseventDesc = false;
   //将表单的值赋给对象(需要根据表单的预置数据来确定)
   for(i=0;i<datas.length;i++){
     var fieldData = datas[i];
     if(fieldData.displayName==="事项描述"){
       obj.eventDesc = fieldData.value;
       ishaseventDesc = true;
     }else if(fieldData.displayName==="重要程度"){
       if(fieldData.value !=="null"){
         var em = new enumManagerNew();
         var embean = em.getCtpEnumItem(fieldData.value);
         if(embean!=null){
           obj.importantLevel = embean.enumvalue;
         }
       }else{
         obj.importantLevel = 2;
       }
     }else if(fieldData.displayName==="开始时间"){
    	 if(fieldData.value && fieldData.value.length == 10){
	       	obj.startTime = fieldData.value + " 00:00";
    	 }else{
    		 obj.startTime = fieldData.value;
    	 }
       obj.dateType = 2;
     }else if(fieldData.displayName==="结束时间"){
    	 if(fieldData.value && fieldData.value.length == 10){
		       obj.endTime = fieldData.value + " 23:59";
    	 }else{
		       obj.endTime = fieldData.value;
    	 }
       obj.dateType = 2;
     }else if(fieldData.displayName==="责任人"){
       obj.owner = fieldData.value;
     }else if(fieldData.displayName==="参与人"){
       obj.participate = fieldData.value;
     }else if(fieldData.displayName==="检查人"){
       obj.examiner = fieldData.value;
     }else if(fieldData.displayName==="开始日期"){
    	 if(fieldData.value){
	       obj.startTime = fieldData.value.slice(0,10);
    	 }
       	 obj.dateType = 1;
     }else if(fieldData.displayName==="结束日期"){
    	 if(fieldData.value){
	       obj.endTime = fieldData.value.slice(0,10);
    	 }
         obj.dateType = 1;
     }
   }
   if(!ishaseventDesc){
     $.alert("${ctp:i18n('plan.alert.plandetail.cannottransfer')}");
     return false;
   }
   obj.planId = "${id}";
   obj.planName = "${ctp:toHTML(title)}";
   obj.recordId = lineData.id;
   
   //--------------构建转任务参数---------------//
   var options = {};
   //任务标题
   options.subject = obj.eventDesc; 
   //重要程度
   options.importantLevel = obj.importantLevel == 0 ? 3 : obj.importantLevel == 2 ? 2 : 1;
   options.fulltime = obj.dateType == "1" ? "1" : "0";//1代表全天任务
   //计划开始时间&结束时间
   var startTime = obj.startTime, endTime = obj.endTime;
   if (!startTime) {
	   if (endTime) {
		   if (obj.fulltime == "1") {
			   startTime = endTime;
		   } else {
			   var date = new Date(parseDate(endTime.substring(0, 16)));
			   var toDate = date.getTime() - 1800000;
			   startTime = new Date(toDate).print("%Y-%m-%d %H:%M");
		   }
	   } else {
		   startTime = '${startTime}';
	   }
   }
   if (!endTime) {
	   if (obj.startTime) {
		   if (obj.fulltime == "1") {
			   endTime = obj.startTime;
		   } else {
			   var date = new Date(parseDate(obj.startTime.substring(0, 16)));
			   var toDate = date.getTime() + 1800000;
			   endTime = new Date(toDate).print("%Y-%m-%d %H:%M");
		   }
	   } else {
		   endTime = '${endTime}';
	   }
   }
   options.beginDate = startTime;
   options.endDate = endTime;
   options.managers = obj.owner;
   options.participators = obj.participate;
   options.inspectors = obj.examiner;
   options.sourceId = obj.planId;
   options.sourceType = 5;
   options.sourceRecordId = obj.recordId;
   taskInfoAPI.newTask(options, function(json){
	   (new planManager()).sendMessageForTran(0, options.sourceId, json.taskId, options.subject,{
		   success: function(){
			   //TODO:什么也不做
		   }
	   });
   });   
   //newTaskInfo(obj);
}
/*字符串转换为日期*/
function parseDate(dateStr) {
	return Date.parse(dateStr.replace(/\-/g, '/'));
}
//转发事件
function transmitEvent(){
   if(!$.ctx.resources.contains('F02_eventlist')) {
     $.alert("${ctp:i18n('plan.noPurview.trans_event')}");
     return;
   }
   
   <c:if test="${!v3x:hasPlugin('calendar')}">
	   $.alert("${ctp:i18n('plan.noPurview.trans_task')}");
	   return;
 	</c:if>
 	
   //得到这一行的数据
   var lineData = $("#mainbodyFrame")[0].contentWindow.$("#img").data("currentRow");
   var datas = lineData.datas;
   var obj = new Object();
   var ishaseventDesc = false;
   //将表单的值赋给对象(需要根据表单的预置数据来确定)
   var dateType;
   for(i=0;i<datas.length;i++){
     var fieldData = datas[i];
     if(fieldData.displayName==="事项描述"){
       obj.eventDesc = fieldData.value;
       ishaseventDesc = true;
     }else if(fieldData.displayName==="重要程度"){
       if(fieldData.value !=="null"){
         var em = new enumManagerNew();
         var embean = em.getCtpEnumItem(fieldData.value);
         if(embean!=null){
           obj.importantLevel = embean.enumvalue;
         }
       }else{
         obj.importantLevel = 2;
       }
     }else if(fieldData.displayName==="开始时间"){
       obj.startTime = fieldData.value;
       if(obj.startTime=="null"){
         obj.startTime = "";
       }
       dateType = 2;
     }else if(fieldData.displayName==="结束时间"){
       obj.endTime = fieldData.value;
       if(obj.endTime=="null"){
         obj.endTime = "";
       }
       dateType = 2;
     }else if(fieldData.displayName==="开始日期"){
       obj.startTime = fieldData.value;
       if(obj.startTime=="null"){
         obj.startTime = "";
       }
       dateType = 1;
     }else if(fieldData.displayName==="结束日期"){
       obj.endTime = fieldData.value;
       if(obj.endTime=="null"){
         obj.endTime = "";
       }
       dateType = 1;
     }
   }
   obj.recordId = lineData.id;
   obj.planId = "${id}";
   obj.appId = 5;
   obj.receiveMemberId = "";
   obj.dateType = dateType;

   if(!ishaseventDesc){
     $.alert("${ctp:i18n('plan.alert.plandetail.cannottransfer')}");
     return false;
   }
   //调用转发事件接口
   //AddCalEvent(obj.startTime,"${planId}",5,obj.endTime,obj.eventDesc,obj.importantLevel,"",dateType);
   AddCalEventObj(obj);
}


var locationPlan = null;

//初始化计划路径 TODO 这个获取路径的代码很有问题，为了尊重历史，只能容错处理，后续要好好梳理下
function initLocationPlan(){
    try{
    	locationPlan = window.parent.parent.location.href;
    } catch(e) {
    	try{
    		locationPlan = getCtpTop().location.href;
    	}catch(e){
    		if(window.parent.location){//从微协同打开
        		locationPlan = window.parent.location.href;
        	}else{
        		locationPlan = "";
        	}
    	}
    }
}
var parentlocationPlan = window.location.href;
var isRef = "${isFromRefer}";
//为表单添加事件
function addButton4Form(){
    //前边列增加checkbox列
    if(locationPlan.indexOf("method=planReference")>-1){
      if(window.frames["mainbodyFrame"].window.initRelationSubTable!==undefined){
        window.frames["mainbodyFrame"].window.initRelationSubTable({onclick:selectedOne});
      }
    }else{
      if(isRef!="true"){
        if(window.frames["mainbodyFrame"].window.initButton!==undefined){
          var hasTaskNew="${ctp:hasResourceCode('F02_taskPage')}";
          if(hasTaskNew==="true"){
	      	window.frames["mainbodyFrame"].window.initButton("<div><span class=\"ico16 plan_totask_16\" title=\"${ctp:i18n('plan.alert.plandetail.transfertask')}\" id=\"transmitTaskButton\" onClick=\"parent.transmitTask(this)\"></span></div>");
       	  }
	      window.frames["mainbodyFrame"].window.initButton("<div><span class=\"ico16 forward_event_16\" title=\"${ctp:i18n('plan.alert.plandetail.transferevent')}\" id=\"transmitTaskButton\" onClick=\"parent.transmitEvent(this)\"></span></div>");
          //$("#mainbodyFrame")[0].contentWindow.$("#img").parent().css("padding-left","39px");
          //$("#mainbodyFrame")[0].contentWindow.$("#img").parent().css("padding-right","39px");
          $("#mainbodyFrame")[0].contentWindow.$("#img").parent().css("margin-right","16px");
        }
      }
    }
}


//选中之后的回调
function selectedOne(checkbox){
    var param = new Object();
    var planTitle = "${ctp:toHTML(title)}";
    param.masterId=$(checkbox).attr("masterId");
    param.recordId= $(checkbox).val();
    param.formId = $(checkbox).attr("formId");
    param.subTableName =$(checkbox).attr("tableName");
    var oneData;
    if(checkbox.checked){
      var ishaseventDesc = false;
      var fm = new formManager();
      var data = window.frames["mainbodyFrame"].window.getRowDataById(param.recordId,param.subTableName);
      var oneLineData = data.datas;
      var length = oneLineData.length;
      for(var i=0;i<length;i++){
        if(oneLineData[i].displayName=="事项描述"){
          ishaseventDesc = true;
        }
      }
      if(!ishaseventDesc){
        $.alert("${ctp:i18n('plan.alert.plandetail.noeventdesc')}");
        checkbox.checked = false;
        return false;
      }
      var displayName = planTitle+"："+escapeStringToHTML(getName(data.datas), true, false);
      //var data = fm.getJsonSubDataById(param);//这是从后台获取这一行的数据，上一行是从前台，但前台获取有缺陷，隐藏的字段取不到，先用前台，计划不涉及隐藏字段
      var item = new parent.parent.refItem(param.recordId,displayName,"myPlan",'${id}',param.subTableName,param.masterId,'${createUserId}',param.formId);
      window.parent.addToList(item);
    }else{
      //取消选中
      window.parent.parent.deleteItem(param.recordId,"myPlan");
    }
}

//查看关联情况
function relationPlan(obj){
  //if(isRef!="true"){
//     var pm = new planManager();
//     var reftype = pm.getRefType("${planId}","${CurrentUser.id}");
//     if(reftype == 0){
//       $.alert("${ctp:i18n('plan.alert.plandetail.cannotviewotherrefer')}");
//       return false;
//     }
    var recordHTML = $(obj).parent().find("span");
    var recordid =  window.frames["mainbodyFrame"].window.getRecordIdByJqueryField(recordHTML);
    viewReferPlan(recordid);
 // }else{
    //仅支持在“我的计划”中，查看自身计划参照情况。
  //  $.alert("${ctp:i18n('plan.alert.plandetail.cannotviewrefer')}");
 //   return false;
 // }
}
var viewReferPlan = function(recordid){  
  var url=_ctxPath+"/plan/plan.do?method=viewReferInfo&dataId="+recordid;
  var timestamp = Date.parse(new Date()); 
  var dialog = $.dialog({
      id: 'url'+timestamp,
      url: url,
      width: 600,
      height: 400,
      title: "${ctp:i18n('plan.alert.plandetail.viewrefer')}",
      targetWindow:getCtpTop(),
      buttons: [{
          text: "${ctp:i18n('plan.dialog.close')}",
          handler: function () {
             dialog.close();
          }
      }]
  });
  }

function getName(data){
  var title = "";
  for(i=0;i<data.length;i++){
    var fieldData = data[i];
    if(fieldData.displayName==="事项描述"){
      title = fieldData.value;
    }
  }
  return title;
}

function showPeopleCardForPlan(){
  if(!locationPlan.indexOf("method=planReference")>-1){
    $.PeopleCard({memberId:"${createUserId}"});
  }
}

function getFormHTML(){
  var contentHTML = window.frames["mainbodyFrame"].window.getHTML();
  return contentHTML;
}

/**
 * 根据htmlIframe高度来设置mainbodyFrame的高度
 */
function setMainBodyFrameHeightByHtmlIframe() {
	if ($("#officeTransIframe", getIFrameDOM("mainbodyFrame")).size() > 0) {
		var htmlIframeHeight = $("#mainbodyFrame").contents().find('#officeTransIframe').contents().find("#htmlFrame").contents().find("html").height();
		var mainFrameHeight = $("#mainbodyFrame").height();
		if (htmlIframeHeight > mainFrameHeight) {
			htmlIframeHeight = htmlIframeHeight + 35;
			$("#mainbodyFrame").attr("height", htmlIframeHeight + "px");
		}
	}
}

var resizeContentFrame = function(){
		var iframe = document.getElementById('mainbodyFrame');
		//获取子页面的高度，并设置父页面高度
		var height = getIFrameDOM("mainbodyFrame").body.scrollHeight;
		var height2 = getIFrameDOM("mainbodyFrame").documentElement.scrollHeight;//IE7下需要使用这个
		height = height2>height?height2:height;
		var contentHeight = $("#contentDiv").height();
		var commentHeight = $("#summaryAndComment").height();
		var tempHeight = height + commentHeight;
		if(tempHeight < contentHeight) {
		  height = contentHeight - commentHeight;
		  iframe.setAttribute("height",height);
		} else {
		  iframe.setAttribute("height",height);
		}
		
		//获取子页面的宽度，并设置父页面宽度		
		var width  = getIFrameDOM("mainbodyFrame").body.scrollWidth;
        var width2  = getIFrameDOM("mainbodyFrame").documentElement.scrollWidth;
        //alert(width+"   "+width2)
        
        width = width2>width?width2:width;
        if("${contentType}" == "20"){
        	var paddingAndMargin = 16;//正文组件padding-left+margin-left
        	width = width+paddingAndMargin*2;
        }
        $("#mainbodyFrameLi").width(width);
		iframe.setAttribute("width",width);
		if($("#iframe_area").width()<width){
			$("#iframe_area").width(width);
		}
		//使正文部分和评论总结部分宽度一致。
		$("#iframe_area").width($("#iframe_area").width());
		if("${contentType}" == "20"){
			$("#summaryAndComment").width($("#mainbodyFrameLi").width()+60);
		}else{
			$("#summaryAndComment").width($("#iframe_area").width());
		}	
		//ie7下表单右边显示不出，需要动态设置表单宽度，但是会改变表单原来的样式。
		if($.browser.msie&&parseInt($.browser.version,10)<=7){
			$("table.xdLayout",getIFrameDOM("mainbodyFrame")).each(function(){
				var width = this.scrollWidth;
				$(".xdRepeatingTable",$(this)).each(function(){
					width = this.scrollWidth>width?this.scrollWidth:width;
				});
				$(this).width(width);
			});	
		}
		$("#iframe_area").css("visibility","visible");	
		setMainBodyFrameHeightByHtmlIframe();
		
		//根据表单参照关系来判断表单图标的显影
	    var planRefRelations = $.parseJSON('${planRefRelations}');
	    //OA-72452工作任务--任务内容页面，计划转任务，计划来源名称为特殊脚本字符，点击报js
		//var taskInfo = $.parseJSON('${taskInfo}');
		var taskInfo =${taskInfo};
		var calEvent=null;
		try {
			calEvent = $.parseJSON('${calEvent}');
		} catch(e) {}
	    $("input[name='id']",$("#mainbodyDiv",getIFrameDOM("mainbodyFrame"))).each(function(index){
			var recorid = $(this).val();
			var ishasRelation = false;
		    var ishasTask = false;//该条记录是否有转任务记录
		    var ishasEvent = false;//该条记录是否有转事件记录
			var ishasByRef = false;//该条记录是否有被参照记录

			for(var i=0;i<planRefRelations.length;i++){
				if(planRefRelations[i].toDataId == recorid){
					ishasRelation = true;
				}
				if(planRefRelations[i].sourceDataId == recorid){
					ishasByRef = true;
				}
			}
		    //各图标等曾静良让UE做好以后再添加进去
			var icoClassName = "";
			for(var i=0;i<taskInfo.length;i++){
				if(taskInfo[i].sourceRecordId == recorid){
				  ishasTask = true;
				}
			}
			if (calEvent != null) {
				for(var i=0;i<calEvent.length;i++){
					if(calEvent[i].fromRecordId == recorid){
					  ishasEvent = true;
					}
				}
			}
			if(ishasTask||ishasEvent){
				icoClassName="ico16 by_reference_16";
			}
			if(ishasRelation){
				icoClassName="ico16 reference_to_the_self_16";
			}
			if(ishasByRef){
				icoClassName="ico16 by_reference_16";
			}
			if(ishasRelation&&(ishasByRef||ishasTask||ishasEvent)){
				icoClassName="ico16 bidirectional_reference_16";
			}
			if(!ishasRelation&&!ishasByRef&&!ishasTask&&!ishasEvent){
				 $(this).parents("tr[recordid]").find(".correlation_form_16").hide();
			}
			if(icoClassName!=""){
				try{//OA-75144
					$(this).parents("tr[recordid]").find(".correlation_form_16")[0].className  = icoClassName;
				}catch(e){}
			}
	    });
};

function getIFrameDOM(id){
	  return document.getElementById(id).contentDocument || document.frames[id].document;
}
function getIFrameWindow(id){
	  return document.getElementById(id).contentWindow || document.frames[id].window;
}

$(document).ready(function(){
    initLocationPlan();
  	$("#attachmentAreaa").attr("style","overflow:hidden;width:auto;");
  	initPlanContentUI();
	initPrint();
});

var intert;
var secondIntert;
/**
 * 初始化计划内容区域渲染效果
 */
function initPlanContentUI() {
	var count = 0;
	var sameCount = 0;
	var mainBodyHeightOld = 0;
	intert = window.setInterval(function(){
		if(getIFrameDOM("mainbodyFrame").readyState=="complete"){
			//调用正文组件的方法判断正文是否加载完成
			//OA-95910360极速模式：在他人计划列表双击打开计划，计划窗口显示一直在加载
			var mainbodyFrame = getIFrameWindow("mainbodyFrame");
			var isComplete = mainbodyFrame.content_isComplete && getIFrameWindow("mainbodyFrame").content_isComplete();
   			if(isComplete== true || isComplete == "true"){//如果加载完成重新设置正文高度
				window.clearInterval(intert);
	  			resizeContentFrame();
	   			fixContentHeadHeight();
				addButton4Form();
				setTimeout(closeProgressBar,300);//正文加载完成之后去掉进度条提示，注：300毫秒延迟是为了提高体验，表单加载完成时如果直接关闭可能还是会有白的感觉，所以延迟300毫秒
   			}
   		}
  	},300);
	secondIntert = window.setInterval(function() {
  		if(getIFrameDOM("mainbodyFrame").readyState=="complete"){
  			var mainBodyHeight = $("#mainbodyFrame").height();
  			var mainBodyDivHeight = $("#mainbodyDiv", getIFrameDOM("mainbodyFrame")).height();
  			if (parseInt(mainBodyDivHeight) > parseInt(mainBodyHeight)) {
  				resizeContentFrame();
  			}
  			if (mainBodyHeight == mainBodyHeightOld) {
  				sameCount++;
  			}
  			if (count > 4 || sameCount == 2) {
  				window.clearInterval(secondIntert);
  			}
  			mainBodyHeightOld = mainBodyHeight;
  			count++;
   		}
  	},3000);
}

 function fixContentHeadHeight(){	             //使用静态布局修正右侧y轴滚动条，需要动态的设置contentHead的height值。
	var h1 = $("#contentHead_1").height()+10;
  	$("#contentHead").css("height",h1);
  	$("#contentDiv").css("top",h1+5);
  	$("#attachment2Areab").css("overflow","hidden");  //去掉关联文档的滚动条
  	$("#attachment2Areab").height(parseInt($("#attachment2Areab").height()+10));
} 

 function showAtts(id){
	 $("#"+id).compThis();
 }
 // 全屏打开office控件
 function contentDiv(){
	$("#officeFrameDiv",getIFrameDOM("mainbodyFrame")).attr("style", "width:0px;height:0px;overflow:hidden; position: absolute;");
 	mainbodyFrame.fullSize();
 }
 // 判断是否需要显示原文档按钮
 function isTransOffice(){ 
	var isTransOffice = ${isTransOffice};
	var contentType = ${contentType};
	if(isTransOffice && (contentType==41||contentType==42||contentType==43||contentType==44)){
		$("#orgindoc").addClass("display_block");
	}
 }
 
 /**
 * 获取附件文件的html信息
 * @param type
 */
 function getFileAttachmentNameHtml(type) {
	var attachmentNameStr = "";
	var attsDom = $("div[attsdata]",$("#attachmentTRa"));
	if(attsDom.length > 0) {
		var attsDataVal = $(attsDom[0]).attr("attsdata");
		if (attsDataVal.length > 0) {
			var attsDataJson = eval("(" + attsDataVal + ")");
			for (var i=0; i<attsDataJson.length; i++) {
				if(attsDataJson[i].type == type) {
					attachmentNameStr += "<div id='attachmentDiv_" + attsDataJson[i].fileUrl + "' style='float: left;px; line-height: 14px;' noWrap>";
					attachmentNameStr += "<img src='" + _ctxPath + "/common/images/attachmentICON/" + attsDataJson[i].icon + "' border='0' height='16' width='16' align='absmiddle' style='margin-right: 3px;'/>";
					attachmentNameStr += attsDataJson[i].filename;
					attachmentNameStr += "&nbsp;</div>";
				}
			}
		}
	}
	return attachmentNameStr;
}

/**
 * 初始化打印信息
 *
 */
function initPrintObj() {
	var printObj = new Object();
	printObj.contentType = "${contentType}";
	printObj.subject = $("#subject").val();
	printObj.creater = "${ctp:showMemberName(createUserId)}";
	printObj.departName = "${deparmentName}";
	printObj.postName = "${postName}";
	printObj.createDate = "${ctp:formatDateTime(createTime)}";
	if ($("#attachmentNumberDiva").html().length == 0) {
		printObj.attNumber = 0;
	} else {
		printObj.attNumber = $("#attachmentNumberDiva").html();
	}
	printObj.attNameHtml = getFileAttachmentNameHtml(0);
	var summaryAndCommentHtml = $("div.processing_view",$("#summaryAndComment"));
	printObj.opinionComment = '<div class="processing_view" style="padding:1px 0;">' + $(summaryAndCommentHtml[0]).html() + '</div>';
	printObj.summary = '<div class="processing_view" style="padding:1px 0;">' + $(summaryAndCommentHtml[1]).html() + '</div>';
	printObj.operaType = "view";
	return printObj;
}

function initPrint() {
	$("#print").bind("click", function() {
		var printObj = initPrintObj();
        doPrint(printObj);
    });
}
</script>
<body class="h100b over_hidden" onload="isTransOffice()"  onbeforeunload="removeCtpWindow('${param.planId}',2)">
  <div class="stadic_layout">
	<div class="newinfo_area title_view padding_l_10  stadic_layout_head stadic_head_height"  id="contentHead">
	  <div id="contentHead_1">
		<table border="0" cellspacing="0" cellpadding="0" width="99%">
			<tr>
				<td>
					<table border="0" cellspacing="0" cellpadding="0" class="w100b"> <!-- 这不能设宽度，否则引起    OA-31459 -->
						<tr>
							<td >
							 <div><span style="float:left;color:#717171">${ctp:i18n('plan.detail.desc.titlefirst')}:</span><b>${ctp:toHTML(title)}</b></div>
                             <input type="hidden" id="subject" name="subject" value="${ctp:toHTML(title)}"/>
                            </td>
						</tr>
						<tr>
							<td >
							<div>
								<div class="color_gray2" style="text-align:justify;float: left">${ctp:i18n('plan.detail.desc.sender')}:</div>
								<div style="float: left">							
								<c:choose>
									<c:when test="${isRef == 'true'}">
										${ctp:showMemberName(createUserId)}
									</c:when>
									<c:otherwise>
									<a href="javascript:void(0)" class="showPeopleCard" onclick="showPeopleCardForPlan()">${ctp:showMemberName(createUserId)}</a>
									</c:otherwise>
								</c:choose>
									(${ctp:formatDateTime(createTime)})
								<c:if test="${updateTime ne null}">
									<span class="color_gray2" style="position: relative; left: 70px;">${ctp:i18n('plan.detail.desc.lastmodifytime')}：<span class="color_black">${ctp:formatDateTime(updateTime)}</span></span>
								</c:if>
								</div>
							</div>
							</td>
						</tr>
						<tr id="attachmentTRa" style="display: none;">			
							<td >
								<div style="float:left;">
                                    <span class="ico16 affix_16" style="margin-left: 32px"></span><span style="color: #717171">:</span>
									<span >(<span id="attachmentNumberDiva"></span>)</span>
								</div>
								<div class="comp" comp="type:'fileupload',applicationCategory:'5',attachmentTrId:'a',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false" attsdata='${atts}'></div>
							</td>
						</tr>
						<tr id="attachment2TRb" style="display: none;">
							<td >
								<div style="float:left;">
                                    <span class="ico16 associated_document_16" style="margin-left: 32px"></span><span style="color: #717171">:</span>
									<span>(<span id="attachment2NumberDivb"></span>)</span>
								</div>
								<div class="comp" comp="type:'assdoc',applicationCategory:'5',attachmentTrId:'b',canDeleteOriginalAtts:false, modids:'1,3,6'" attsdata='${atts}'></div>														
							</td>
						</tr>
							
					</table>
			</td>
			<td style="vertical-align: bottom; width: 120px;">
				<table border="0" cellspacing="0" cellpadding="0" align="right">
					
					<tr>
						<c:if test="${(contentType eq '41' || contentType eq '42') && v3x:isOfficeTran()}">
							<td><div id="orgindoc" class="display_none color_blue hand" onclick="contentDiv()">${ctp:i18n('plan.detail.showorgindoc')}</div></td>
						</c:if>
						<td><div id="print" class="hand"><span class="ico16 print_16 margin_lr_5" title="${ctp:i18n('collaboration.newcoll.print')}"></span>${ctp:i18n('collaboration.newcoll.print')}</div></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	  </div>
	</div>
	<div class="stadic_layout_body stadic_body_top_bottom" style="background: #FFF;" id="contentDiv"> 
	  <div id="iframe_area" class="<c:if test='${contentType eq 10}'>content_view padding_b_10</c:if> " style="visibility:hidden">
		   <li class="view_li" id="mainbodyFrameLi" <c:if test='${contentType eq 10}'>style="padding:30px 30px;"</c:if> >
			  <iframe id="mainbodyFrame" name="mainbodyFrame" width="100%" height="500px" frameBorder="no" scrolling="no" src='${path }/content/content.do?isFullPage=true&moduleId=${param.planId}&moduleType=5&viewState=2'></iframe>
		  </li>
	  </div>
	  <div id="summaryAndComment" class="content_view <c:if test='${contentType ne 10}'>padding_t_10</c:if>">
		  <jsp:include page="/WEB-INF/jsp/common/content/comment.jsp"></jsp:include>
	  </div>
    </div> 
  </div>
</body>
</html>
