<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<title><fmt:message key="welcome.label"><fmt:param value="${currentUserName}"/></fmt:message></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">

<link href="<c:url value="/common/skin/default${v3x:getSysFlagByName('SkinSuffix')}/images/favicon.ico" />" type="image/x-icon" rel="shortcut icon"/>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/common/js/message/BaseMessage.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/common/js/message/imMessage.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/common/js/message/longPolling.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/apps_res/v3xmain/js/onlineIM.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/orgDataCenter.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	var Constants_Component = new Properties();
	Constants_Component.put(Constants_Account, "<fmt:message key='org.account.label'/>");
	Constants_Component.put(Constants_Department, "<fmt:message key='org.department.label'/>");
	Constants_Component.put(Constants_Team, "<fmt:message key='org.team.label'/>");
	Constants_Component.put(Constants_Post, "<fmt:message key='org.post.label'/>");
	Constants_Component.put(Constants_Level, "<fmt:message key='org.level.label${v3x:suffix()}'/>");
	Constants_Component.put(Constants_Member, "<fmt:message key='org.member.label'/>");
	Constants_Component.put(Constants_Role, "<fmt:message key='org.role.label'/>");
	Constants_Component.put(Constants_Outworker, "<fmt:message key='org.outworker.label'/>");
	Constants_Component.put(Constants_ExchangeAccount, "<fmt:message key='org.exchangeAccount.label'/>");
	Constants_Component.put(Constants_OrgTeam, "<fmt:message key='org.orgTeam.label'/>");
	Constants_Component.put(Constants_RelatePeople, "<fmt:message key='org.RelatePeople.label'/>");
	Constants_Component.put(Constants_FormField, "<fmt:message key='form.selectPeople.extend'/>");
	Constants_Component.put(Constants_Admin, "<fmt:message key='org.admin.label'/>");
	
	Constants_Component.put("AccountAdmin", "<fmt:message key='sys.role.rolename.AccountAdmin' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("AccountManager", "<fmt:message key='sys.role.rolename.AccountManager' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("DepAdmin", "<fmt:message key='sys.role.rolename.DepAdmin' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("DepManager", "<fmt:message key='sys.role.rolename.DepManager' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("DepLeader", "<fmt:message key='sys.role.rolename.DepLeader' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("FormAdmin", "<fmt:message key='sys.role.rolename.FormAdmin' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("HrAdmin", "<fmt:message key='sys.role.rolename.HrAdmin' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("ProjectBuild", "<fmt:message key='sys.role.rolename.ProjectBuild' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("BlankNode", "<fmt:message key='sys.role.rolename.BlankNode' bundle='${v3xSysI18N}'/>");
	
	<%--公文角色--%>
	Constants_Component.put("account_edoccreate", "<fmt:message key='sys.role.rolename.account_edoccreate' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("account_exchange", "<fmt:message key='sys.role.rolename.account_exchange' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("department_exchange", "<fmt:message key='sys.role.rolename.department_exchange' bundle='${v3xSysI18N}'/>");
    Constants_Component.put("AccountEdocAdmin", "<fmt:message key='sys.role.rolename.AccountEdocAdmin' bundle='${v3xSysI18N}'/>");
	
	Constants_Component.put("Sender", "<fmt:message key='sys.role.rolename.Sender' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("SenderDepManager", "<fmt:message key='sys.role.rolename.SenderDepManager' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("SenderDepLeader",  "<fmt:message key='sys.role.rolename.SenderDepLeader' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("SenderSuperManager", "<fmt:message key='sys.role.rolename.SenderSuperManager' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("NodeUserDepManager", "<fmt:message key='sys.role.rolename.NodeUserDepManager' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("NodeUserDepLeader", "<fmt:message key='sys.role.rolename.NodeUserDepLeader' bundle='${v3xSysI18N}'/>");
	Constants_Component.put("NodeUserSuperManager", "<fmt:message key='sys.role.rolename.NodeUserSuperManager' bundle='${v3xSysI18N}'/>");
	
	var PeopleRelate_TypeName = {
			1 : "<fmt:message key='relate.type.leader' bundle='${v3xRelateI18N}' />",
			2 : "<fmt:message key='relate.type.assistant' bundle='${v3xRelateI18N}' />",
			3 : "<fmt:message key='relate.type.junior' bundle='${v3xRelateI18N}' />",
			4 : "<fmt:message key='relate.type.confrere' bundle='${v3xRelateI18N}' />"
		}
//-->
</script>
<script type="text/javascript">
<!--
	//长连接状态
	var longConnection = false;

	//服务器时间和本地时间的差异
	var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();

	//是否来自精灵
	var isA8genius = "${param.from == 'A8genius'}";

	var ncSuffix = "${v3x:ncSuffixInJs()}";
	var suffixVersion = "${v3x:suffixInJS()}";
	
	//是否播放声音
	var isEnableMsgSound = <c:out value="${isEnableMsgSound}" default="false" />;
	
	//存储在线IM消息
	var IMMsgProperties = new Properties();

	//启动服务
	function doStart() {
		//创建token
		doNewToken();
		//创建客户端的服务器调用接口
		longPollingServer = new LongPollingListener("/seeyon/longPollingWaitServlet?token=", "UTF-8", "${currentUserId}");
	    //启动服务
	    longPollingServer.start();
	    //修改长连接状态
	    longConnection = true;
	}

	//添加动态调整页面布局大小的事件
	function addResizeAction(){
		if(document.all){
	        window.attachEvent("onresize", initLayoutWidth);
	    }else{
	    	window.addEventListener("resize", initLayoutWidth, false);
		}

		setTimeout("initLayoutWidth()", 500);
	}

	//动态调整页面布局大小
	function initLayoutWidth(){
		try{
			var bodyWidth = parseInt(document.body.clientWidth);
			var centerWidth = 410;
			var eastWidth = bodyWidth - 610;
			if($("#east_region").width() == 0){
				centerWidth = bodyWidth - 200;
				eastWidth = 0;
			}
			$('body').layout('panel','west').panel('resize',{
				width:200
			});
			$('body').layout('panel','center').panel('resize',{
				width:centerWidth
			});
			$('body').layout('panel','east').panel('resize',{
				width:eastWidth
			});
			$('body').layout().resize();
		}catch(e){}
	}

	$(document).ready(function(){
		try{
			//如果长连接未断开,则需要断开长连接
			var hasToken = doGetToken();
			if(hasToken == "true"){
				doStopToken();
			}
			
			$('#imTabs').tabs({
				onSelect: function(title){
					var currentPanel = $('#imTabs').tabs('getTab', title);
					var currentTab = currentPanel.panel('options').tab;
					currentTab.removeClass("tabs-selected-sel");
				},
				onClose: function(title){
					if($.data(this,"tabs").tabs.length == 0){
						$('body').layout('panel','east').panel('resize',{
							width:1
						});
						$('body').layout('panel','east').panel('close');
						$('body').layout().resize();
						initLayoutWidth();
						isResize = false;
					}
				}
			});

			//动态调整页面布局大小
			addResizeAction();
			
			//从A8首页右下角消息提示框进入或通讯录等其它地方
			if("${param.id}" != ""){
				if("${param.fromcol}" != ""){
					showIMTab("5", "${param.id}", "${param.name}", "false");
				}else if("${param.name}" != ""){//从通讯录等其它地方进入,打开页签即可
					showIMTab("1", "${param.id}", "${v3x:showMemberNameOnly(param.id)}", "false");
				}else{//从A8首页右下角消息提示框进入,打开页签并显示消息
					var parentWin = v3x.getParentWindow();
					var msg = parentWin.msgProperties.get("${param.id}");
					var tID = "";
					var tName = "";
					if(msg.get(0).messageType == 1){
						tID = msg.get(0).senderId;
						tName = msg.get(0).senderName;
					}else{
						tID = msg.get(0).referenceId;
						tName = getTeamName(msg.get(0).messageType, msg.get(0).referenceId);
					}
					IMMsgProperties.put("${param.id}", msg);
					parentWin.msgProperties.remove("${param.id}");
					showIMTab(msg.get(0).messageType, tID, tName, "true");
				}
			}
		}catch(e){
			
		}
	});

	window.onbeforeunload = function(){
		try{
			var parentWin = v3x.getParentWindow();
			if(parentWin && parentWin.onlineWin){
				parentWin.onlineWin = null;
			}
			doStopToken();
		}catch(e){}
	}
//-->
</script>
</head>
<body class="easyui-layout">
	<div region="north" border="false" style="height:42px;">
		<table cellpadding="0" cellspacing="0" width="100%" height="42" class="north-bg">
			<tr>
				<td valign="middle" width="15">
					&nbsp;
				</td>
				<td valign="middle" class="north-title">
					<fmt:message key='message.title'/>(<c:if test="${!isAdmin}">${deptOnlineNumber}/</c:if>${allOnlineNumber})
				<%--
					<c:if test="${!isAdmin}">
						<span id="imStateImg" class="im-leave-img"></span>&nbsp;
						<span id="imStateTitle" class="im-leave-title"><fmt:message key='im_leave'/></span>
					</c:if>
				 --%>
				</td>
			</tr>
		</table>
	</div>
	
	<div region="west" id="west_region" border="true" split="true" style="width:205px;overflow:hidden;">
    	<iframe src='${onlineURL}?method=showOnlineUserTree' name='onlineUserTreeIframe' id='onlineUserTreeIframe' frameborder='0' width='100%' height='100%' scrolling='no'></iframe>
	</div>
	
	<div region="center" border="true" split="true" style="width:395px;overflow:hidden;">
		<iframe src='${onlineURL}?method=showOnlineUserList' name='onlineUserListIframe' id='onlineUserListIframe' frameborder='0' width='100%' height='100%' scrolling='no'></iframe>
	</div>
	
	<div region="east" id="east_region" closed="true" border="true" split="true" style="width:1px;overflow:hidden;">
		<div id="imTabs" class="easyui-tabs" fit="true"  border="false"></div>
	</div>
	
	<%-- 播放声音 --%>
	<iframe id="playSoundHelper" name="playSoundHelper" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>