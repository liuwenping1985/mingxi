<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="../../common/common.jsp"%>
<c:if test="${ctp:hasPlugin('uc') && !CurrentUser.admin}">
<%@ include file="/WEB-INF/jsp/apps/uc/uc_connection.jsp" %>
</c:if>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/apps_res/plugin/genius/js/geniusBaseMessage.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/apps_res/plugin/genius/js/geniusMessage.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/apps_res/plugin/genius/js/geniusOnlineMessage.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="${path}/main/common/css/frame-common.css" />
<script type="text/javascript">
<!--
	var isA8geniusMsg = true;

	var ncSuffix = "${v3x:ncSuffixInJs()}";

	//消息链接
	var messageLinkConstants = new Properties();
	${main:showMessageLink(pageContext)}

	//是否播放声音
	var isEnableMsgSound = <c:out value="${isEnableMsgSound}" default="false" />;
	//消息查看后是否从消息框中移出
	var msgClosedEnable = <c:out value="${msgClosedEnable}" default="false" />;

	//定义消息窗口是否可见
	var isSysMessageWindowEyeable = false;
	var isPerMessageWindowEyeable = false;

	//存储在线消息
	var msgProperties = new Properties();
	//在线消息总个数
	var msgTotalCount = 0;

	var message_header_system_label = "${ctp:i18n('message.header.system.label')}";
	var message_header_person_label = "${ctp:i18n('messageManager.count.person')}";
	var message_person_reply_label = "${ctp:i18n('message.person.reply.label')}";
	var message_header_unit_label = "${ctp:i18n('message.header.unit.label')}";

	var isTalkingDlgShow = false;//精灵在线IM窗口是否打开
	
	//设置精灵在线IM窗口是打开状态
	function setTalkingDlgShow(state){
		if(state == "true"){
			isTalkingDlgShow = true;
		}else{
			isTalkingDlgShow = false;
		}
	}

	//精灵重新登录、退出、切换首页或我的文档时，UC下线
	function gniusDoStop(){
		if("${ctp:hasPlugin('uc')}" == "true" && "${CurrentUser.admin}" != "true"){
			closeUC();
        }
	}

    $(document).ready(function () {
    	//UC中心
        if("${ctp:hasPlugin('uc')}" == "true" && "${CurrentUser.admin}" != "true"){
            setTimeout("initConnection()", 1000);
        }
        
    	initMessage(${ctp:getSystemProperty('message.interval.second')});
    });
//-->
</script>
</head>
<body>
<div id="msgWindowDIV" style="width:280px; position:absolute; right:0px; bottom:0px; display:none; z-index:104;" class="page_color border_all">
	<table id="helperTable" width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="32" class="title-background-1">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="84%" class="msgTitle">${ctp:i18n('portal.msgTitle.label')}</td>
						<td width="8%" title="${ctp:i18n('message.header.mini.alt')}" onclick="changeMessageWindow('genius')" class="hand"><span class="dialog_min right"></span></td>
						<td width="8%" title="${ctp:i18n('message.header.close.alt')}" onclick="destroyMessageWindow('true', 'genius')" class="hand"><span class="dialog_close right"></span></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr id="PerMsgContainerTR" style="display: none;"><td id="PerMsgContainer" align="right"></td></tr>
		<tr id="SysMsgContainerTR" style="display: none;"><td id="SysMsgContainer" align="right"></td></tr>
		<tr align="center" valign="bottom"><td class="bottom-background-1">&nbsp;</td></tr>
	</table>
</div>

<%-- 播放声音 --%>
<iframe id="playSoundHelper" name="playSoundHelper" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<%-- 附件下载 --%>
<iframe id="downloadFileFrame" name="downloadFileFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>

<script type="text/javascript">
<!--
	//精灵自动登录缓冲
	function isJsLoad(){
		return "true"; 
	}
//-->
</script>
</body>
</html>