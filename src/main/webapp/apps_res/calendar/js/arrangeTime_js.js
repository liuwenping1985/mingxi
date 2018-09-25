/**
 * 新建任务
 */
function newTask(time) {
	var o = new Object();
	if(typeof (time) != 'undefined'){
		time = time.split(" ");
		o.beginDate = time[0];
	}
	o.flag = 0;
	o.height=397;
	o.runFunc = refleshPage;
	newTaskInfo(o);
}

/**
 * 新建计划
 */
function newPlan(time){
	var url = _ctxPath;
	url = url + "/plan/plan.do?method=newPlan";
	url = url + "&type=" + getDateTypeValue($("#type").val());
	if (time != undefined) {
		url = url + "&beginDate=" +time;
	}
	openCtpWindow({'url':url, 'id':'123123123123123123'});
/*	if($("#arrangePage").val()=="arrangeWeeKTime"){
		setTimeout(function(){  
			window.parent.location.href = url;
		},0);  
	}
	if($("#arrangePage").val()!="arrangeWeeKTime"){
    	setTimeout(function(){  
    		window.location.href = url;
    	},0);  
	}*/
}

/**
 * 根据时间视图类型，获取时间类型值
 */
function getDateTypeValue(type) {
	var dateTypeValue = 2;
	if (type == "day") {
		dateTypeValue = 1;
	} else if (type == "week") {
		dateTypeValue = 2;
	} else if (type == "month") {
		dateTypeValue = 3;
	} else {
		dateTypeValue = 2;
	}
	return dateTypeValue;
}

/**
 * 新建会议
 */
function newMeeting(time){
    var affairId = "";
    var collaborationFrom = "";
    var url = _ctxPath + "/meetingNavigation.do?method=entryManager&entry=meetingArrange&listMethod=create&affairId="+affairId+"&collaborationFrom="+collaborationFrom+"&formOper=new&time=" + time;
    if($("#arrangePage").val()=="arrangeWeeKTime"){
           setTimeout(function(){  
      		window.parent.location.href = url;
      	 },0);  
    }
    if($("#arrangePage").val()!="arrangeWeeKTime"){
          setTimeout(function(){  
      		window.location.href = url;
      	},0);  
    }
}
