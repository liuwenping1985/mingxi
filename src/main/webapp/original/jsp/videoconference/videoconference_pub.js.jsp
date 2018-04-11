<%@page import="com.seeyon.apps.videoconference.util.VideoConferenceConfig" %>
<c:url value="/videoConference.do" var="videoconfURL" />
<script type="text/javascript">
<!--

/**
 * 参加视频会议
 * @param joinType 1:开启会议;2:参加会议
 * @param confKey
 * @param meetingPassword
 * @param failureUrl 失败跳转URL
 */
function joinVideoconference(joinType, confKey, meetingPassword, failureUrl,meetId) {
    //如果视频会议系统瘫痪
    <%if(VideoConferenceConfig.VIDEO_CONF_STATUS.equals("disable")){%>
        alert(v3x.getMessage("meetingLang.videoMeeting_error"));
        return;
    <%}%>
    
    <%if(VideoConferenceConfig.MULTIPLE_MASTER_SERVER_ENABLE){%>
        var sendResult = v3x.openWindow({
            url : "${videoconfURL}?method=choseServerWindow",
            width : "260",
            height : "130",
            scrollbars:"no"
        });
       if(sendResult == null){
           return;
       }else if(!sendResult){
           //正常开会
       }else{
           document.getElementById("serverName").value = sendResult;
       }
    <%}%>
    
    var dataForm = document.getElementById("dataForm");
    if(joinType == "1"){
        dataForm.action = "videoConference.do?method=startVideoMeeting";
    } else if(joinType == "2"){
        dataForm.action = "videoConference.do?method=joinVideoMeeting";
    }
    document.getElementById("confKey").value = confKey;
    document.getElementById("meetingPassword").value = meetingPassword;
    document.getElementById("failureUrl").value = failureUrl;
    document.getElementById("meetId").value = meetId;
    document.getElementById("dataForm").submit();
}

//-->
</script>
<form action="" method="post" id="dataForm" name="dataForm" target="targetIframe">
<input type="hidden" name="serverName" id="serverName" value="">
<input type="hidden" name=meetId id="meetId" value="">
<input type="hidden" name="confKey" id="confKey" value="">
<input type="hidden" name="meetingPassword" id="meetingPassword" value="">
<input type="hidden" name="failureUrl" id="failureUrl" value="">
</form>
<iframe id="targetIframe" name="targetIframe" width="0" height="0" style="display: none;"></iframe>