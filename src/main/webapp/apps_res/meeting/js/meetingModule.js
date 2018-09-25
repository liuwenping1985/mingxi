/**
 * 转会议接口，页面之间跳转到新建会议页面
 * @param affairId 
 * @param collaborationFrom
 * @param frameObj     需要跳转到新建会议的框架
 * @param closeWin     是否关闭当前窗口，true：关闭；false：不关闭
 */
function createmeeting(affairId,collaborationFrom,frameObj,time,closeWin){
    if(!frameObj){
      return;
    }
    var url = _ctxPath + "/meetingNavigation.do?method=entryManager&entry=meetingArrange&listMethod=create&affairId="+affairId+"&collaborationFrom="+collaborationFrom+"&formOper=new&time=" + time;

    frameObj.location.href = url;
    if(closeWin == true)
      window.close();
}

/**
 * 新建会议接口
 * @param frame  需要更新的框架
 * @param time    会议默认时段
 */
function newMeeting4Scheduler(time){
  createmeeting("","",window,time,false);
}

/**
 * 查看会议接口
 * @param id   会议id
 */
var dialogDealColl;
function openMeetingDetail(id, subject){
	var url = _ctxPath + "/mtMeeting.do?method=myDetailFrame&id=" + id;
	var width = $(getA8Top().document).width() - 100;
	var height = $(getA8Top().document).height() - 50;
	if(!subject) {
		subject = "会议";
	}
	dialogDealColl = $.dialog({
		url : url,
		width: width,
	    height: height,
	    title : subject,
	    targetWindow:top,
	    transParams:window
	});
}
