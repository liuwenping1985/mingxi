<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden" style="padding: 10px 24px 24px 24px;">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
    <title></title> 
    <style>
		.common_tabs{background:#fbfbfb!important;}
		.tab-ul li a{width: 100px;}
     </style>
</head>
<body class="h100b over_hidden page_color">
	<%-- 消息穿透打卡 --%>
	<c:if test="${from == 'msgRemind'}">
		<div class="page_color over_hidden person-body" >
			<iframe src="${path}/attendance/attendance.do?method=punchCard" frameborder="no" border="0"></iframe>
		</div>
	</c:if>
	
	<%-- 个人考勤  --%>
	<c:if test="${from != 'msgRemind' }">
		<div id="tabs" class="comp h100b" comp="type:'tab'"  comptype="tab">
			<div id="tabs_head" class="common_tabs clearfix person-hender" >
				<ul class="left tab-ul">
					<c:if test="${canPunchcard == true}">
					<li id="punchcard" src="${path}/attendance/attendance.do?method=punchCard">
						<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
							${ctp:i18n('attendance.common.online')}
						</a>
					</li>
					</c:if>
					
					<li id="statics" src="${path}/attendance/attendance.do?method=personalStatistic">
						<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
							${ctp:i18n('attendance.common.statisticalinfo')}
						</a>
					</li>
					<li id="details" src="${path}/attendance/attendance.do?method=personalDetails">
						<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
							${ctp:i18n('attendance.common.persondetail')}
						</a>
					</li>
					<li id="at" src="${path}/attendance/attendance.do?method=personalAt">
						<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
							${ctp:i18n('attendance.common.personalAt')}
						</a>
					</li>
				</ul>
			</div>
			<div id="tabs_body" class="page_color over_hidden person-body">
				<iframe id="tab_iframe"  frameborder="no" border="0"></iframe>
			</div>
		</div>
	</c:if>
</body>
<%-- 平台的js --%>
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript">
	<c:if test="${from != 'msgRemind' }">
	//面包屑
	var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/default/menuIcon/personal.png'/></span>";
	html += "<span class='nowLocation_content'>";
	html += "<a class=\"hand\" onclick=\"showMenu('" + _ctxPath + "/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
	html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath + "/attendance/attendance.do?method=intoMyAttendance" +  "')\">" + $.i18n("menu.hr.personal.attendance.manager") + "</a>";
	html += "</span>"; 
	getCtpTop().showLocation(html);
	</c:if>
	var bodyHeight = $("body").height();
	var hHeight = $(".person-hender").height();
	var width = $("body").width();
	$(".person-hender").css({"width"  :	width + "px"});
	$(".person-body,.person-body iframe").css({
		"height" : (bodyHeight - hHeight) + "px",
		"width"  :	width + "px"
	});
	$(function() {
		$(".person-hender li").on("click",function(){
			$("#tab_iframe").attr("src", $(this).attr("src"));
		});
		
		//默认选择
		var target = '${target}';
		if (target != '') {
			$("#"+target).find("a").click();
		}else{
			$("#punchcard").find("a").click();
		}
		
	});
</script>
</html>