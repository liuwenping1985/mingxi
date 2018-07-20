<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key='mr.label.mrApplication'/></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<%
String locale = "_cn";
if(com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request).equals("en")) {
	locale = "";
}
%>
<!-- 图形化会议室插件js -->
<script src="apps_res/plugin/meetingroom/codebase/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>
<script src="apps_res/plugin/meetingroom/sources/locale<%= locale %>.js" type="text/javascript" charset="utf-8"></script>
<script src="apps_res/plugin/meetingroom/sources/locale_recurring_cn.js" type="text/javascript" charset="utf-8"></script>
<script src="apps_res/plugin/meetingroom/codebase/ext/dhtmlxscheduler_tooltip.js"></script>
<script src="apps_res/plugin/meetingroom/codebase/ext/dhtmlxscheduler_timeline.js"></script>
<script src="apps_res/plugin/meetingroom/codebase/ext/dhtmlxscheduler_minical.js"></script><!-- 时间 -->
<script type="text/javascript" charset="UTF-8" src="<c:url value='/common/js/V3X.js${v3x:resSuffix()}' />"></script>

<link rel="stylesheet" href="apps_res/plugin/meetingroom/codebase/dhtmlxscheduler_glossy.css" type="text/css" title="no title" charset="utf-8"/>
<%-- ${v3x:skin()} TODO 5.0 改为下面的方式写死!--%>
<link href="common/skin/default4GOV/skin.css?V=V3_50SP1_null" type="text/css" rel="stylesheet"></link>
<script type="text/javascript">var skinType = 'common/skin/default4GOV';</script>

<style type="text/css" media="screen">
	body{
		margin:0px;
		padding:0px;
		height:100%;
		overflow:hidden;
		position:absolute;
		left:0;
		width:100%;
	}
	.one_line{
		white-space:nowrap;
		overflow:hidden;
		padding-top:5px;
		padding-left:5px;
		text-align:left!important;
	}
	.dhx_cal_event_line,.dhx_cal_event_line1,.dhx_cal_event_line2 {
		height:85%;
		/**filter: Alpha(Opacity=70);设置拖动DIV的背景透明 */
	}
</style>

<script type="text/javascript" charset="utf-8">

window.transParams = window.transParams || window.parent.transParams || {};//弹出框参数传递
window.dialogArguments = window.transParams.parentWin; 

/**
 *内部方法，向上层页面返回参数
 */
function _returnValue(value){
    if(transParams.popCallbackFn){//该页面被两个地方调用
        transParams.popCallbackFn(value);
    }else{
        transParams.parentWin.showMTRoomCallback(value)
    }
}

/**
 *内部方法，关闭当前窗口
 */
function _closeWin(){
    if(transParams.popWinName){//该页面被两个地方调用
        transParams.parentWin[transParams.popWinName].close();
    }else{
    	try {
    		commonDialogClose('win123');
   		} catch (failed) {
     
   		}
    }
}
//sections设定为全局变量，后台排序后对此变量数据进行修改
var sections = ${mtRoom};
var needApp = ${needApp};
var action="${v3x:escapeJavascript(action)}";
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
v3x.loadLanguage("/apps_res/meeting/js/i18n");

//初始化js Ajax-------------------------------Start
var request = false;
try {
   	request = new XMLHttpRequest();
 } catch (trymicrosoft) {
   	try {
     		request = new ActiveXObject("Msxml2.XMLHTTP");
   	} catch (othermicrosoft) {
     	try {
       		request = new ActiveXObject("Microsoft.XMLHTTP");
   		} catch (failed) {
     		request = false;
   		}
   	}
 }
 if (!request){
   	alert("初始化XMLHttpRequest的错误!");
 }
//初始化js Ajax-------------------------------End

var old_id = "";//记录上一次选择的时间段自动生成的Id
var oldRoomAppId = ${oldRoomAppId};//记录回显时的Id
var currentdate = "";//当前的时间,不一定是当前,可以是随意选择的时间
var deleteStatusId = "";//删除状态,在移动已经申请过的会议室时,要给它赋上值

/**
 * 从父页面获得周期性对应的所有日期，如：2014-06-13,2014-06-14,2014-06-15
 */
function getPeriodicityDatesInParentPage(){
	var periodicityDates = "";
	if(window.dialogArguments){
		var p = dialogArguments;
    	if(p && p.document.getElementById("periodicityDates")){
    		periodicityDates = p.document.getElementById("periodicityDates").value;
    	}
	}
	return periodicityDates;
}

/******************************** 初始化数据 start **************************************/
function init() {
	if(sections=="1"){
		//alert("<fmt:message key='mr.alert.addroom'/>!");
		//window.close();
		document.getElementById("scheduler_here").style.display = 'none';
		document.getElementById("roomButtomDiv").style.display = 'none';
		document.getElementById("noRoomMsgDiv").style.display = '';
		return;
	}

	scheduler.locale.labels.timeline_tab = "<fmt:message key='mt.label.time'/>";
	scheduler.locale.labels.section_custom="<fmt:message key='mr.label.mrApplication'/>";
	scheduler.config.details_on_create=true;
	scheduler.config.details_on_dblclick=true;
	scheduler.config.xml_date="%Y-%m-%d %H:%i";
	scheduler.createTimelineView({
		name:"timeline",
		x_unit:"minute",
		x_date:"%H:%i",
		x_step:15,
		x_size:63.9,//判断时间长度
		x_start:32,
		x_length:96,
		y_unit:sections,
		y_property:"section_id",
		render:"bar",
		dy:10
	});

	//------------------------------------------------------------将时间设置成整小时
	scheduler._render_x_header = function (a, b, c, d) {
		var e = document.createElement("DIV");
		e.className = "dhx_scale_bar";
		this.set_xy(e, this._cols[a] - 1, this.xy.scale_height - 2, b, 0);
		var timeVar=this.templates[this._mode + "_scale_date"](c, this._mode);

		if(timeVar.substring(3)=="00") {
			e.innerHTML ="&nbsp;&nbsp;&nbsp;"+timeVar;
			d.appendChild(e);
		}
	};
	scheduler.init('scheduler_here',null,"timeline");
	var jsonMeeting=${jsonMt};
	scheduler.parse(jsonMeeting, "json");//加载从数据库中读取的会议室申请记录

	//会议修改时，勾选上之前申请的会议室复选框
	<%--
	for(var i=0;i<jsonMeeting.length;i++){
		if("${meetId}" == jsonMeeting[i].meetingid){
			var selRoom = document.getElementById("room_"+jsonMeeting[i].section_id);
			if(selRoom){
				selRoom.checked = true;
				break;
			}
		}
	}
	--%>


	//-----------------------------回显手动选择的会议室(考虑了周期性的)------------------------------------start
	var returnMrs=${returnMr};//在没入库前,点击再次进入时要显示回显的数据
	if(returnMrs!=null&&""!=returnMrs&&"null"!=returnMrs){
		$("#start_time").val(returnMrs[0].start_date);
		$("#end_time").val(returnMrs[0].end_date);


		//从父页面获得周期性的所有日期字符串
		var periodicityDates = getPeriodicityDatesInParentPage();
		if(periodicityDates != ""){
			try{
				var start_date = returnMrs[0].start_date.substr(0,10);
				//当设置了周期性后，再选择了会议室，确定后，再打开会议室时，就要判断当前日期是否在所设置的周期性时间内，在的话当前日期时间区域才会显示出来
				if(periodicityDates.indexOf(start_date)>-1){
					scheduler.parse(returnMrs, "json");//加载选择的记录
					var roomM = document.getElementById("room_"+returnMrs[0].section_id);
					if(roomM){
						roomM.checked = true;
						room_obj = document.getElementById("room_"+returnMrs[0].section_id);
					}
				}
			}catch(e){
			}
		}else{
			scheduler.parse(returnMrs, "json");//加载选择的记录
			var roomM = document.getElementById("room_"+returnMrs[0].section_id);
			if(roomM){
				roomM.checked = true;
				room_obj = document.getElementById("room_"+returnMrs[0].section_id);
			}
		}

	}
	//-----------------------------回显手动选择的会议室(考虑了周期性的)------------------------------------end
	else if(window.opener || window.dialogArguments){
		var _parentWindow = window.opener || window.dialogArguments;
		if(_parentWindow.document.getElementById("beginDate") && _parentWindow.document.getElementById("endDate")){
			$("#start_time").val(_parentWindow.document.getElementById("beginDate").value);
			$("#end_time").val(_parentWindow.document.getElementById("endDate").value);
		}
	}

	//----------------------------------------------------------------------移动后触发
	scheduler.attachEvent("onEventChanged", function(event_id, event_object){
	    var id = event_object.id;
	    var text = event_object.text;
	    var convert = scheduler.date.date_to_str("%Y-%m-%d %H:%i");
	    var start_date = convert(event_object.start_date);
	    var end_date = convert(event_object.end_date);
        var section_id = event_object.section_id;
        var status=event_object.status;
        if(status==2){//如果拖动从数据库读出的时间段,则把新拖动的给删除掉
		    scheduler.deleteEvent(old_id);//删除上一个新建的时间段
		    scheduler.deleteEvent(oldRoomAppId);//删除回显的时间段
		    deleteStatusId=id;
        	//old_id=id;
		}

        document.getElementById("meetingRoom").value=section_id;
		document.getElementById("startDate").value=start_date;
		document.getElementById("endDate").value=end_date;
	    //这里使用true刷心主窗口
	    return true;
	});

	//--------------------------------------------------------------------拖动时触发
	scheduler.attachEvent("onBeforeEventChanged", function (a) {
		//用来记录是添加还是修改的标记(如果是添加则不能拖动任何的时间段,如果是修改,再去判断拖动的是否是当前的会议,如果是则可拖动,否则不难拖动)
		var action="${v3x:escapeJavascript(action)}";
		//修改的时候取得会议的ID用来判断只许修改当前ID的会议
		var meetId="${v3x:escapeJavascript(meetId)}";
		//添加,时不能修改其他的会议时间段,如果meetingid!=null的话就表示当前是拖动的其他时间段,如果是新增的这个是不会有值的
		if(action=="create" && a.meetingid!=null){
			alert("不能修改已申请的时间段。");
			return false;
		}
		//修改时meetId会有值,判断当前拖动的会议时间段是不是属于当前会议室
		if(a.meetingid!=null){
			if(action=="edit" && meetId!=a.meetingid){
				alert("对不起,此时间段不属于当前会议。");
				return false;
			}
		}
		//检查当选择的时间是否小于系统时间，如查小于系统时间则不允许选择会议室
		var convert1 = scheduler.date.date_to_str("%Y-%m-%d");
		if(currentdate!=null&&""!=currentdate){
			var curdate=convert1(currentdate);
			var nowdate=convert1(new Date());
			if(curdate<nowdate){
				//alert("选择的时间不能小于系统当天时间。");
				alert("<fmt:message key='mr.time.lessthan'/>!");
				return false;
			}
		}
		var id = a.id;
		var status=a.status;//判断是否有权限修改 1不是本人添加的时间,2是本人添加,3其他情况
		var timeout=a.timeout;
	    var convert = scheduler.date.date_to_str("%Y-%m-%d %H:%i");
	    var start_date = convert(a.start_date);
	    var end_date = convert(a.end_date);
	    if(convert(new Date())>start_date){
			alert("<fmt:message key='mt.alert.startTimeError'/>!");//开始时间不能小于系统当前时间
		    return false;
		}
        var section_id = a.section_id;
		var flag=false;
        if(status==1){//没有权限
			alert("<fmt:message key='mt.alert.moveMessage'/>!");
			return false;
		}
		if(timeout==2){//会议已经开始
			alert("<fmt:message key='mt.label.mtstart'/>!");
			return false;
		}
		if(timeout==3){//会议已经结束
			alert("<fmt:message key='mt.label.mtend'/>!");
			return false;
		}
		if(status==2||status==null||""==status||"undefined"==status){//有权限或者是新建都,要去后台查询是否被占用
			flag = checkRoomDisabled(start_date, end_date, section_id);
		}else{//其他情况
			alert("Error");
		}
		//同步到上方的时间框和右侧的勾选框
		$("#start_time").val(start_date);
		$("#end_time").val(end_date);
		disableCheckBox();
		room_obj = document.getElementById("room_"+section_id);
		if(!room_obj.checked){
			room_obj.checked = true;
		}else {
			room_obj.checked = false;
		}
		return flag;
	});

	//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－绘制出图形时触发的事件(弹出框)
	scheduler.showLightbox = function(id){
		var ev = scheduler.getEvent(id);
	    var convert = scheduler.date.date_to_str("%Y-%m-%d %H:%i");
	    var start_date = convert(ev.start_date);
	    var end_date = convert(ev.end_date);
	    //判断用户选反时间是否是>=30分钟,如果超过三十分钟则进行其他操作,不到三十分钟则提示并删除当前选择项
	    //if(((getDateTimeStamp(end_date))-(getDateTimeStamp(start_date)))>=1800000){
	    	var section_id=ev.section_id;
			//在绘制新的时间段时,要先恢复以前拖动的时间段---------------------------------------------Start
			if(currentdate==null||""==currentdate||"undefined"==currentdate){
				currentdate=new Date();
			}
			timebutton(currentdate);
		  	//如果在绘制新的时间段时,要先恢复以前拖动的时间段---------------------------------------------End
		  	//在绘制新的时间段时,删除原来"回显"时绘制的时间段---------------------------------------------Statr
			if(oldRoomAppId!=null&&""!=oldRoomAppId&&"null"!=oldRoomAppId){
				scheduler.deleteEvent(oldRoomAppId);
			}
			//在绘制新的时间段时,删除原来"回显"时绘制的时间段---------------------------------------------End
			//如果用户选择第二个时间段时清除上一个新建的时间段--------------------------------------------Start
			if((""!=old_id)||(null!=old_id)){
				scheduler.deleteEvent(old_id);
			}
			//如果用户选择第二个时间段时清除上一个选择的时间段--------------------------------------------End
			old_id=id;
		    document.getElementById("meetingRoom").value=section_id;
			document.getElementById("startDate").value=start_date;
			document.getElementById("endDate").value=end_date;

			//原来的方法保留并做修改(注销)
			if (id && this.callEvent("onBeforeLightbox", [id])) {
				var b = this._get_lightbox();
				//this.showCover(b);//去掉弹出的框
				this._fill_lightbox(id, b);
				this.callEvent("onLightbox", [id]);
		    }
		    //保存
			scheduler.save_lightbox();

			//同步信息到上面的时间框里面
			$("#start_time").val(start_date);
			$("#end_time").val(end_date);
			disableCheckBox();
			room_obj = document.getElementById("room_"+section_id);
			if(!room_obj.checked){
				room_obj.checked = true;
			}else {
				room_obj.checked = false;
			}
		//}else{
			//alert("会议时间必须超过三十分钟");
			//scheduler.deleteEvent(id);
		//}
	}

	//鼠标放在上边提示的信息
	scheduler.templates.tooltip_text = function (b, d, c) {
		var status=c.status;//鼠标放在上边就为隐藏表单赋值
		if(status==2||status==null||""==status||"undefined"==status){
			//这里赋值是为了区分在删除的时候,是删除数据库还是删除刚新建的会议室
			document.getElementById("mtid").value=c.mtappid;
			document.getElementById("boxid").value=c.id;
		}
		var startdate=scheduler.templates.tooltip_date_format(b);
		var enddate=scheduler.templates.tooltip_date_format(d);
		var startdates=startdate.split(" ");
		var enddates=enddate.split(" ");
		var time=startdates[1]+"—"+enddates[1];
		var text=c.text_hid;
		var tooltipMsg="";
		if(null!=c.createUserName && ""!=c.createUserName && "undefined" != c.createUserName){
		tooltipMsg+="<div style='height:18px;'>&nbsp;&nbsp;&nbsp;<b><fmt:message key='mt.list.column.app_person'/>:</b> "+c.createUserName+"</div>";
		}
		tooltipMsg+="<b><fmt:message key='mt.label.meetingtime'/>:</b> " + time;
		return tooltipMsg;
	};
}

function disableCheckBox(){
	var _allCheckBox = document.getElementsByName("autoSelectRoom");
	if(_allCheckBox){
		for(var i=0; i<_allCheckBox.length; i++){
			document.getElementById(_allCheckBox[i].getAttribute("id")).checked = false;
		}
	}
}

//会议时候被占用
function checkRoomDisabled(start_date, end_date, section_id){
	var _result = false;
	var url = ${mrUrl}"?method=checkMeetingRoomIsZY&startDate="+start_date+"&endDate="+end_date+"&roomId="+section_id+"&date="+new Date();
	request.open("GET", url, false);
	request.onreadystatechange = function(){
		if (request.readyState == 4) {
			if (request.status == 200) {
				var response = request.responseText;
				response=response.trim();
				if(response=='y'){//如果允许托动的话,则把新的时间段和会议室赋值
					document.getElementById("meetingRoom").value=section_id;
					document.getElementById("startDate").value=start_date;
					document.getElementById("endDate").value=end_date;
					_result=true;
				}else if(response=='n'){
					alert("<fmt:message key='mt.alert.timeExist'/>");
				}
			}else{
			}
		}else{
		}
	};
	request.send(null);
	return _result;
}
/******************************** 初始化数据 end **************************************/

//点击删除时弹出提示框,点击确定则删除,否则取消删除
var deleteFlag = false;/** xiangfan 修复GOV-3901，默认为false */
function showDelete(){
	var initW = typeof(dialogArguments)=='undefined'?null:dialogArguments; //获得父窗口对象
	var roomAppId=document.getElementById("mtid").value;
	var boxid=document.getElementById("boxid").value;
	var periodicityStartDate = "";
	if(initW){
	    var pEle = initW.document.getElementById("periodicityStartDate");
	    if(pEle){
	        periodicityStartDate = pEle.value
	    }
	}
	var flag=confirm("<fmt:message key='mr.alert.sureDelete'/>?");
	if(flag){
		if(roomAppId!=""&&roomAppId!=null&&"undefined"!=roomAppId){//如果不是从数据库读出的数据则不需要进入后台删除数据
			var meetingId = initW==null?"${v3x:escapeJavascript(param.meetingId)}":initW.document.getElementById("meetingId").value;
			var sendType = initW==null?"${v3x:escapeJavascript(param.sendType)}":initW.document.getElementById("sendType").value;//如果会议申请转会议通知时sendType=publishAppToMt,其他情况为空值
			var appType = initW==null?"${v3x:escapeJavascript(param.appType)}":initW.document.getElementById("appType").value;//xiangfan 添加， 会议室申请有两个入口【申请会议室】和【新建会议通知】RoomApp表示入口是【申请会议室】 MtMeeting表示入口是【新建会议通知】
			var url = ${mrUrl}"?method=deleteMeetingRoomById&roomId="+roomAppId+"&date="+new Date()+"&meetingId="+meetingId+"&sendType="+sendType+"&appType="+appType+"&periodicityStartDate="+periodicityStartDate;
		    request.open("GET", url, true);
		    request.onreadystatechange = function(){
		    	if (request.readyState == 4) {
			    	if (request.status == 200) {
			        	var response = request.responseText;
			        	response=response.trim();
			        	if(response==0){
			        		document.getElementById("meetingRoom").value="";
			        		scheduler.deleteEvent(boxid);//提示删除成功
			        		//xiangfan 添加删除后清除遗留数据，修复 删除会议室还能提交会议通知的错误
			        		if(appType != "RoomApp" && appType != "PortalRoomApp"){
								//当删除之前申请的会议室时，需要将父页面的 关于会议室的参数都清空
			        			cleanParentMeetingParams();
			        		}
					        alert("<fmt:message key='mr.alert.successRemoved'/>");
					        deleteFlag = true;/** xiangfan 修复GOV-3901，如果是真删，设置为 true */
				        }else if(response==2){
					        alert("不允许删除不属于当前会议的会议室！");
					        return null;
				        }else{//提示删除失败
					        alert("<fmt:message key='mr.alert.deleteFailed'/>");
					    }
			       }else{
			       }
			   	}else{
				}
			};
		    request.send(null);
		}else{
			//清除父页面的值(调用父页面的函数)
			try{
				//window.parent.dialogArguments.cleanMt();
				cleanParentMeetingParams();
			}catch(err){
			}
			document.getElementById("meetingRoom").value="";
			scheduler.deleteEvent(boxid);
			disableCheckBox();
		}
	}
}

function cleanParentMeetingParams(){
	var initW = typeof(dialogArguments)=='undefined'?null:dialogArguments; //获得父窗口对象
	if(initW && initW.document.getElementById("selectRoomType").options){
		initW.document.getElementById("portalRoomAppId").value = "";
		initW.document.getElementById("meetingPlace").value = "";
		initW.document.getElementById("isFromPortal").value = "";
		initW.document.getElementById("hasMeetingRoom").value = "";
		initW.document.getElementById("oldRoomAppId").value = "";
		initW.document.getElementById("roomAppId").value = "";
		initW.document.getElementById("selectedRoomName").value = "";
		initW.document.getElementById("meetingroomId").value = "";
		initW.document.getElementById("meetingroomName").value = "";
		initW.document.getElementById("needApp").value = "";
		initW.document.getElementById("roomAppBeginDate").value = "";
		initW.document.getElementById("roomAppEndDate").value = "";
		initW.document.getElementById("selectRoomType").options[0].text = "<请选择已申请会议室或录入地点>";
	}
}


//显示时间图标
function show_minical(){
	if (scheduler.isCalendarVisible()){
		scheduler.destroyCalendar();
	}else{
		scheduler.renderCalendar({
			position:"dhx_minical_icon",
			date:scheduler._date,
			navigation:true,
			handler:function(date,calendar){
				//根据选择的日期查询出申请记录
				timebutton(date);
				scheduler.setCurrentView(date);
				scheduler.destroyCalendar();
			}
		});
	}
}

//确定事件
function OK(){
	//如果是拖动从数据库读出的已申请的会议室,则先删除
	var meetingRoom = document.getElementById("meetingRoom").value;
	if(meetingRoom!=null && meetingRoom!="") {
		if(deleteStatusId!=null && ""!=deleteStatusId){
			var flag = confirm("<fmt:message key='mt.alert.sureUpdate'/>?");
			if(flag){
				var url = ${mrUrl}"?method=deleteMeetingRoomById&roomId="+deleteStatusId+"&date="+new Date();
			    request.open("GET", url, true);
			    request.onreadystatechange = function(){
			    	if (request.readyState == 4) {
				    	if (request.status == 200) {
				        	var response = request.responseText;
				        	response=response.trim();
				        	if(response==0){
				        		deleteStatusId="";//重新赋值
				        		okSetValue();//删除成功后,将值传递到调用页面
					        }else{//提示删除失败
						        alert("<fmt:message key='mr.alert.deleteFailed'/>");
						    }
				       }else{
				       }
				   	}else{
					}
				};
			    request.send(null);
			}else{
				//点击取消,一切都得还原
				document.getElementById("meetingRoom").value="";
				document.getElementById("startDate").value="";
				document.getElementById("endDate").value="";
				deleteStatusId="";
				if(currentdate==null||""==currentdate||"undefined"==currentdate){
					currentdate=new Date();
				}
				timebutton(currentdate);
			}
		}else{
			//如果不是拖动原来的时间段,则直接将值传递到调用页面
			okSetValue();
		}
	}else{
		alert("<fmt:message key='mt.alert.selectroom'/>");
	}
}

//将值传递给调用的页面
function okSetValue(){
	var meetingRoom=document.getElementById("meetingRoom").value;
	var startDate=document.getElementById("startDate").value;
	var endDate=document.getElementById("endDate").value;

	var newDate = "${v3x:escapeJavascript(newDate)}";
	var curretnDate = new Date(newDate);
    curretnDate = curretnDate.format("yyyy-MM-dd HH:mm");
    curretnDate = Date.parse(curretnDate.replace(/\-/g,"/"));
    if(Date.parse(startDate.replace(/\-/g,"/")) < curretnDate){
      alert("开始时间不能小于系统当前时间！");
      return ;
    }

	if(meetingRoom!=null&&meetingRoom!=""){//将会议室ID转换成会议室名称
		if(${param.linkSectionId!=null && param.linkSectionId!=''}) {
			var url = ${mrUrl}"?method=execApp&id="+meetingRoom+"&linkSectionId=${v3x:escapeJavascript(param.linkSectionId)}&startDatetime="+startDate+"&endDatetime="+endDate+"&date="+new Date();
			request.open("GET", url, true);
			request.onreadystatechange = function(){
				if (request.readyState == 4) {
					if (request.status == 200) {
						var response = request.responseText;
						response=response.trim();
						var res  = response.split("|");
						if(res!=null && res.length==2) {
							document.getElementById("roomAppId").value = res[0];
							document.getElementById("resourceMsg").innerHTML = res[1];
							window.mtRoomAppPromptWin = getA8Top().$.dialog({
							    title : "会议室申请",
							    transParams : {
							        'parentWin' : window,
							        "popWinName" : "mtRoomAppPromptWin",
							        "popCallbackFn" : function() {
							        }
							    },
							    url : "meetingroom.do?method=meetingRoomAppPrompt",
							    targetWindow : getA8Top(),
							    width : "400",
							    height : "260"
							});
						}else{
						    if(response){
						        alert(response);
						    }
						}
				   }
				}
			};
			request.send(null);

		} else {
			var url = ${mrUrl}"?method=getMeetingRoomByIdAjax&roomId="+meetingRoom+"&date="+new Date();
			request.open("GET", url, true);
			request.onreadystatechange = function(){
				if (request.readyState == 4) {
					if (request.status == 200) {
						var response = request.responseText;
						response=response.trim();
						if(response!=""&&response!=null){
							old_id=meetingRoom;

							var retObj = response+","+startDate+","+endDate+","+old_id;
							if(typeof(transParams)!="undefined"){
							    _returnValue(retObj);
							}
							_closeWin();
						}
				   }else{
				   }
				}else{
				}
			};
			request.send(null);
		}
	}else{
		alert("<fmt:message key='mt.alert.selectroom'/>");
	}
}

//取消事件
function Cancel(){
	<c:if test="${param.linkSectionId!=''}">
	//_closeWin();
	scheduler.deleteEvent(old_id);//删除上一个新建的时间段
	scheduler.deleteEvent(oldRoomAppId);//删除回显的时间段
	</c:if>
	if(deleteFlag){
		if(!confirm("会议室已被取消，是否不再将此会议绑定会议室？")){/** 修复GOV-3901，如果编辑一个已经选择了所登记的会议室，删除后，在'取消'时应该弹出该提示框 */
			return;
		}
		deleteFlag = false;
	}
	_closeWin();
}

String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}
//点击选择时间调用方法
function timebutton(date){
	var action="${v3x:escapeJavascript(action)}";
	var meetId="${v3x:escapeJavascript(meetId)}";
	//格試化日期
	var time=formatDate(date);
	currentdate=date;
    var url = ${mrUrl}"?method=mtroomAjax&timepams="+time+"&action="+action+"&meetingId="+meetId+"&date="+new Date();
    request.open("GET", url, true);
    request.onreadystatechange = timebuttonFun;
    request.send(null);
}

var room_obj;
function timebuttonFun() {
   	if (request.readyState == 4) {
    	if (request.status == 200) {

        	var response = request.responseText;
        	var jsonMeeting=response;

        	var periodicityDates = "";
        	if(typeof(transParams)!="undefined"){
        		if(transParams.parentWin){
            		var p = transParams.parentWin;
            	if(p && p.document.getElementById("periodicityDates")){
            		periodicityDates = p.document.getElementById("periodicityDates").value;
            	}
        	}
        	}
        	var jsonDate = "";
        	var time=formatDate(currentdate);
        	var start_time = $("#start_time").val();
			var end_time = $("#end_time").val();
        	//当设置了周期性，且翻页日期不是 当前图形化会议的日期时，才显示
        	if(periodicityDates!=""){
        		if(periodicityDates.indexOf(time+"")>-1 && start_time.substr(0,10)!=time){
        			var meetingRoom = document.getElementById("meetingRoom").value;
        			if(meetingRoom != ""){
        				var curStartTime = time+" "+start_time.substr(11);
        				var curEndTime = time+" "+end_time.substr(11);
        				//这里 id meetingId mtappid 必须要设置一个值，不然来回切换日期的时候，就会重复绘制
        				jsonDate = '{"color":"","createUserName":"","end_date":"'+curEndTime+'","id":"123","meetingid":"123","mtappid":"123","section_id":"'+meetingRoom+'","start_date":"'+curStartTime+'","state":2,"status":3,"text":"","textColor":"","text_hid":"","timeout":0,"upmtid":""}';
        			}
        		}
        	}

        	if(jsonDate!=""){
            	//切换到另一个日期 有已经申请的会议室
				if(jsonMeeting.length>10){
					jsonMeeting = jsonMeeting.substr(0,jsonMeeting.length-3)+","+jsonDate+"]";
				}
				//切换到另一个日期只是这次选择的会议室
				else{
					jsonMeeting = "["+jsonDate + "]";
				}
			}
         	scheduler.parse(jsonMeeting, "json");
         	disableCheckBox();
         	if(room_obj){
        		document.getElementById(room_obj.getAttribute("id")).checked = true;
			}


			<%--
			//修改会议时，会议室中勾选之前选择的(这是之前已经入库的会议室选择的时间)
         	try{
         		//执行后，相当于 var mJson = {'-3003389996589236068':'','-3382854253173915387':'','1386749369450450396':''};
            	if("${mJson}" != ""){
                	eval("${mJson}");
                	var jm = eval(jsonMeeting);
    				for(var k = 0;k<jm.length;k++){
    					if(mJson[jm[k].meetingid] == ""){
    						var selRoom = document.getElementById("room_"+jm[k].section_id);
    						if(selRoom){
    							selRoom.checked = true;
    							break;
    						}
    					}
    				}
            	}
         	}catch(e){
			}--%>
       }
   	}
}

//日期转换，将date日期转换为yyyy-mm-dd类型
function formatDate(v){
   if(typeof v == 'string') v = parseDate(v);
   if(v instanceof Date){
     var y = v.getFullYear();
     var m = v.getMonth() + 1;
     var d = v.getDate();
     var h = v.getHours();
     var i = v.getMinutes();
     var s = v.getSeconds();
     var ms = v.getMilliseconds();
     if(ms>0) return y + '-' + m + '-' + d + ' ' + h + ':' + i + ':' + s + '.' + ms;
     if(h>0 || i>0 || s>0) return y + '-' + m + '-' + d + ' ' + h + ':' + i + ':' + s;
     if(m<10)m = "0"+m;
     if(d<10)d = "0"+d;
     return y + '-' + m + '-' + d;
   }
   return '';
}

//将时间字符串转换成毫秒
function getDateTimeStamp(dateStr){
	return Date.parse(dateStr.replace(/-/gi,"/"));
}

//点击会议室弹出会议室详细信息
function showMTInfo(mtId) {

    window.showMTInfoWin = getA8Top().v3x.openDialog({
        title : '会议室详情信息',
        transParams : {
            'parentWin' : window,
            "popWinName" : "showMTInfoWin",
            "popCallbackFn" : function() {
            }
        },
        url : "meetingroom.do?method=getMeetingRoomById&roomId="+mtId+"&date="+new Date(),
        targetWindow : getA8Top(),
        width : 500,
        height : 495
    });
}

function loadUE() {
	if("${v3x:escapeJavascript(param.appType)}" != "portalRoomApp"){
		$('body').height("100%");
	}else {//二级栏目
		$('#scheduler_here').height("83%");
	}
	<c:if test="${mtRoom!='1'}">
		var _body = $('body').width(); //这里的判断主要是时间安排portal的周视图窄栏处理
		if (_body < 1052) {
			$('body').width(1052);
		}
	</c:if>
}

var selectRoomTimeCallback_param = {};//选择时间控件回调参数
function selectRoomTime(thisDom) {
    
    var evt = v3x.getEvent();
    var x = evt.clientX?evt.clientX:evt.pageX;
    var y = evt.clientX?evt.clientX:evt.pageY;
    selectRoomTimeCallback_param.thisDom = thisDom;
    
    whenstart('${pageContext.request.contextPath}', thisDom, x, y,'datetime',false,320,320,{callBackFun:selectRoomTimeCallback});
    if(v3x.getBrowserFlag('openWindow') != false){//通过模态窗口打开的,直接调用验证
        _vilidateDate();
    }
}

/**
 * 选择时间回调函数
 * @param retValue
 */
function selectRoomTimeCallback(retValue){
    var obj = selectRoomTimeCallback_param.thisDom;
    obj.value = retValue;
    _vilidateDate();
}

/**
 * 时间校验
 */
function _vilidateDate(){
    
    var autoSelectRooms = document.getElementsByName("autoSelectRoom");
    var temp_start_time = $("#start_time").val();
    var temp_end_time = $("#end_time").val();
    
    var start_time = $("#start_time").val();
    var end_time = $("#end_time").val();
    

    var convert = scheduler.date.date_to_str("%Y-%m-%d %H:%i");
    //获得服务器端的当前日期时间
    var newDate = "${newDate}";
    
    if(start_time != "" && convert(new Date(newDate))>start_time){
        alert("<fmt:message key='mt.alert.startTimeError'/>!");//开始时间不能小于系统当前时间
        $("#start_time").val(temp_start_time);
        $("#end_time").val(temp_end_time);
        return false;
    }
    if(start_time != "" && end_time != "" && start_time>end_time){
        alert("开始时间不能大于结束时间");
        $("#start_time").val(temp_start_time);
        $("#end_time").val(temp_end_time);
        return false;
    }
    
    if(start_time != "" && end_time != ""){
        for(var i=0; i<autoSelectRooms.length; i++){
            if(autoSelectRooms[i].checked){
                if(!checkRoomDisabled($("#start_time").val(), $("#end_time").val(), 
                    autoSelectRooms[i].getAttribute("id").split("_")[1])){
                    $("#start_time").val(temp_start_time);
                    $("#end_time").val(temp_end_time);
                    return ;
                }
                selectMtRoom(autoSelectRooms[i], "timeWidget")
                break;
            }
        }
    }
}


var save_old_section_id = "";//当拖动的蓝色区域直接删除时，要记录删除的对应的section_id
function selectMtRoom(obj, from){
	//如果是勾选
	if(document.getElementById(obj.getAttribute("id")).checked){
		//当时间为空时，勾选一个会议室，需要将其他的取消掉
		disableCheckBox();
		document.getElementById(obj.getAttribute("id")).checked = true;
	}

	var periodicityDates = "";
	if(window.dialogArguments){
		var p = dialogArguments;
		if(p.document.getElementById("periodicityDates")){
			periodicityDates = p.document.getElementById("periodicityDates").value;
		}
	}
	var id_str = obj.getAttribute("id");
	id_str = id_str.split("_")[1];
	var start_time = $("#start_time").val();
	var end_time = $("#end_time").val();

	var convert = scheduler.date.date_to_str("%Y-%m-%d %H:%i");
	if(start_time == "" || end_time == ""){
		return false;
	}else if(convert(new Date())>start_time){
		/*
		if(periodicityDates==""){
			alert("<fmt:message key='mt.alert.startTimeError'/>!");//开始时间不能小于系统当前时间
			obj.checked = false;
		    return false;
		}*/
	}
	//校验会议室是否已经被占用了
	if(from != "timeWidget" && !checkRoomDisabled(start_time, end_time, id_str)){
		obj.checked = false;
		return false;
	}

	if(start_time != '' && end_time != ''){
		var old_section_id = "";
		var jsonDate = [{id:id_str,start_date: start_time, end_date: end_time,section_id:id_str}
		                ];
		for(var i in scheduler._events){
			if(!scheduler._events[i].createUserName && !scheduler._events[i].mtappid ){
				old_id = i;
				break;
			}
		}
		if(old_id != null && old_id != ""){
			try{
				old_section_id = scheduler._events[old_id].section_id;
			}catch(e){
				old_section_id = save_old_section_id;
			}
			//document.getElementById("room_"+old_section_id).checked = false;
			scheduler.deleteEvent(old_id);
			old_id = "";
		}

		if(from != "timeWidget" && obj.getAttribute("id") == ("room_"+old_section_id) &&
		 !document.getElementById(obj.getAttribute("id")).checked){
			document.getElementById("room_"+old_section_id).checked = false;
			document.getElementById("meetingRoom").value="";
			document.getElementById("startDate").value="";
			document.getElementById("endDate").value="";
			/*  下面代码会将会议通知页面的 时间和地点清空，不清楚老代码为什么要这样做，这样有问题啊
			if(window.opener || window.dialogArguments){
				var _p = window.opener || window.dialogArguments;
				if(_p.cleanMt)
					_p.cleanMt();
			}*/
			return ;
		}


    	var time=$("#start_time").val().substr(0,10);
    	var flag = false;
    	if(periodicityDates!=""){
        	//当是周期性会议时，需要判断当前日期 是否在周期性里面，在才显示出来
    		if(periodicityDates.indexOf(time)>-1){
        		flag = true;
    		}
    	}else{
        	flag = true;
    	}

		if(flag){
			scheduler.parse(jsonDate, "json");
			for(var i in scheduler._events){
				if(!scheduler._events[i].createUserName && !scheduler._events[i].mtappid ){
					old_id = i;
					save_old_section_id = old_id;
					break;
				}
			}

			document.getElementById("meetingRoom").value=id_str;
			document.getElementById("startDate").value=start_time;
			document.getElementById("endDate").value=end_time;

			//原来的方法保留并做修改(注销)
			if (old_id && scheduler.callEvent && scheduler.callEvent("onBeforeLightbox", [old_id])) {
				var b = scheduler._get_lightbox();
				//this.showCover(b);//去掉弹出的框
				scheduler._fill_lightbox(old_id, b);
				scheduler.callEvent("onLightbox", [old_id]);
			}

			//保存
			scheduler.save_lightbox();
		}
	}

	disableCheckBox();
	if(!document.getElementById(obj.getAttribute("id")).checked){
		document.getElementById(obj.getAttribute("id")).checked = true;
		room_obj = obj;
	}
	resetDate(start_time);

}

function resetDate(start_time){
	var convert = scheduler.date.date_to_str("%Y-%m-%d");
	var nowDate = convert(new Date());
	var selected_start_Date = start_time.split(" ")[0];
	//if(nowDate != selected_start_Date){
		//var interval_date = (new Date(selected_start_Date) - new Date(nowDate))/1000/60/60/24;
		timebutton(new Date(selected_start_Date.replace(/-/g,"/")));
		scheduler.setCurrentView(new Date(selected_start_Date.replace(/-/g,"/")));
	//}
}
//刷新页面，改变会议室显示的排序方式
function changeShow(v){
  if(sections=="1" || sections == undefined){//如果无数据，返回,不改变排序顺序
    return;
  }
 // var needApp = ${needApp};
  var url = ${mrUrl}"?method=getAllMeetingRoomAjax&sort="+v+"&needApp="+needApp+"&date="+new Date();
  request.open("GET", url, false);
  request.onreadystatechange = function(){
      if (request.readyState == 4) {
          if (request.status == 200) {
              var response = request.responseText;
              response=response.trim();
              if(response != null){
                data = eval("("+response+")");
                sections = data;
                scheduler.createTimelineView({
                  name:"timeline",
                  x_unit:"minute",
                  x_date:"%H:%i",
                  x_step:15,
                  x_size:63.9,//判断时间长度
                  x_start:32,
                  x_length:96,
                  y_unit:sections,
                  y_property:"section_id",
                  render:"bar",
                  dy:10
              });
              //刷新显示内容
              scheduler.render_view_data();
              }else {
                //不改变排序
              }
               
          }else{
          }
      }else{
      }
     
  };
  request.send(null);
}
</script>
</head>

<body onload="loadUE();init();"  width="100%" style="overflow:auto;overflow-y:hidden;">
<input type="hidden" id="meetingRoom" name="meetingRoom" value="${v3x:toHTML(meetingRoom)}"/>
<input type="hidden" id="startDate" name="startDate" value="${v3x:toHTMLWithoutSpace(startDate)}"/>
<input type="hidden" id="endDate" name="endDate" value="${v3x:toHTMLWithoutSpace(endDate)}"/>
<input type="hidden" id="mtid" name="mtid"/>
<input type="hidden" id="boxid" name="boxid"/>

	<div id="scheduler_here" class="dhx_cal_container" style='width:100%;height:91%'>
		<div class="dhx_cal_navline" style="background-color:white">
			<div class="dhx_cal_prev_button" style=" margin-top: 3px; ">&nbsp;</div>
			<div class="dhx_cal_next_button" style=" margin-top: 3px; ">&nbsp;</div>
			<div class="dhx_cal_today_button" style="display:none;"></div>
			<div class="dhx_cal_date" style=" margin-top: 3px; "></div>
			<div class="dhx_minical_icon" id="dhx_minical_icon" onclick="show_minical()" style=" margin-top: 3px; ">&nbsp;</div><!--时间图标-->
			<div class="dhx_cal_tab" name="timeline_tab" style="right:20px; display:none;"></div>
			<div style=" margin-left: 230px;">
					<fmt:message key='mt.meeting.beginTime'/><input type="text" style=" width: 120px; " id="start_time" name="textfield" class="" onclick="selectRoomTime(this);" readonly="">
					<fmt:message key='mt.meeting.endTime'/><input type="text" style=" width: 120px; " id="end_time" name="textfield" class="" onclick="selectRoomTime(this);" readonly="">
			</div>
	          <div style="right:290px;">
	          <fmt:message key='mt.meetingroom.sortStyle'/>
	           <select id="sortTag" onchange="changeShow(this.value)" class="w100b">
	               <option  value="1"  selected ><fmt:message key='mt.meetingroom.sortByCreateTime'/></option>
	               <option  value="2"  ><fmt:message key='mt.meetingroom.sortByName'/></option>
	           </select>
	          </div>
			
			<div style="right:25px;">
				<table>
					<tr>
						<td><fmt:message key='mt.label.legend'/>：</td>
						<td width="20"><div style="width:15px;height:15px;background-color:#ffffff; border:1px solid #000;"></div></td>
						<td><fmt:message key='mt.label.leisure'/></td>
						<td width="20"><div style="width:15px;height:15px;background-color:#7f7f7f; border:1px solid #000;"></div></td>
						<td><fmt:message key='mt.label.booked'/></td>
						<td width="20"><div style="width:15px;height:15px;background-color:#64be0f; border:1px solid #000;"></div></td>
						<td><fmt:message key='mt.label.application'/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="dhx_cal_header"></div>
		<div class="dhx_cal_data"></div>
	</div>

	<div id="roomButtomDiv" align='right' class="bg-advance-bottom" style="background-color:#f3f3f3;background-image:none;">
        <div class="h100b" style="float:left;vertical-align: middle;">
            <span style="font-size: 12px;"><fmt:message key='meeting.room.instruction'/>&nbsp;<fmt:message key='meeting.room.view.promt'/></span>
        </div>
        <div class="h100b" style="float:right; padding-top:10px;">
            <input type="button" style="float:left;margin-right:10px;" class="button-default-2 button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" onclick="OK();"/>
            <input type="button" style="float:left;" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="Cancel();"/>
        </div>
        <div style="clear:both;"></div>
		
	</div>

	<div id="resourceMsg" style="display:none"></div>
	<input type="hidden" id="roomAppId" />

	<div id="noRoomMsgDiv" style="text-align:center;margin-top:90px; display:none;font-size: 15px;color: #B6B6B6">
        <img style="vertical-align: middle;" src="<c:url value='/skin/default/images/zszx_empty.png' />">
        <fmt:message key='mr.alert.addroom'/>
	</div>

</body>
</html>
