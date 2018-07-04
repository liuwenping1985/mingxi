<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title></title>
	<style type="text/css">
	     body{background: #f5f5f5;}
		 .common_tabs{overflow: hidden;padding-top:5px;}
		 .tab-ul{margin-left: 5px;}
		 .tab-ul li a{width: 100px;}
	</style>
</head>
<body class="h100b over_hidden">
	<!-- 面包屑 -->
	<c:choose>
		<c:when test="${isDept == true}">
			<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_deptRecord'"></div>
		</c:when>
		<c:otherwise>
			<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_hrRecord'"></div>
		</c:otherwise>
	</c:choose>

	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:36,sprit:false,border:false">
			<div id="tabs" class="comp page_color" comp="type:'tab'">
				<div id="tabs_head" class="common_tabs clearfix">
					<ul class="left tab-ul">
						<li id="staffAttendance" targetSrc='${path }/attendance/attendance.do?method=staffAttendance&isDept=${isDept}'>
							<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
								<span>${ctp:i18n('attendance.common.staffattendance')}</span>
							</a>
						</li>
						<li id="staffStatics" targetSrc='${path }/attendance/attendance.do?method=staffStatics&isDept=${isDept}'>
							<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
								<span>${ctp:i18n('attendance.common.attendancestatistical')}</span>
							</a>
						</li>
						<%-- 考勤提醒只有考勤管理能设置 --%>
						<c:if test="${isDept == false && isAttendanceAdmin == true}">
						<li id="remind" targetSrc='${path }/attendance/attendance.do?method=attendanceRemind'>
							<a hidefocus="true" href="javascript:void(0)" tgt="tab_iframe">
								<span>${ctp:i18n('attendance.common.attendanceremind')}</span>
							</a>
						</li>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
		<div class="layout_center page_color over_hidden" layout="border:false" style="overflow: hidden;">
			<iframe id="tab_iframe" name="tab_iframe" border="0"  frameBorder="no" width="100%" height="100%"></iframe>
		</div>
	</div>
</body>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<script type="text/javascript">
		$(".tab-ul li a").on("click",function(){
			var $t = $(this).parent();
			if($t.hasClass("current")){
				return;
			}
			$("#tabs_head").find("li.current").removeClass("current");
			$("#tab_iframe").attr("src",$t.attr("targetSrc"));
			$t.addClass("current");
		});
		$(function(){
			//模拟触发,OA-122121HR管理-考勤管理页面有2个一样的请求，导致在IE8下页面刷新显示
			$(".tab-ul li a").first().click();
		})
	</script>
</html>