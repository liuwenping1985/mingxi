<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="<c:url value="/apps_res/supervision/css/summary_supervise_list.css${v3x:resSuffix()}" />">
<title>督办事项列表</title>
</head>
<body>

	<div class="xl_box">
		<div class="xl_menu">督办事项</div>
		<div class="xl_container">
			<p>督办事项</p>
			<!-- xl 7-3修改 -->
			<ul style="height:550px;overflow-y:auto;">
				<c:forEach items="${supervisionItems }" var="item">
					<li>
					<a href="<c:url value="/supervision/supervisionController.do?method=formIndex&masterDataId=${item.supervisionId}&isFullPage=true&moduleId=${item.supervisionId}&moduleType=37&viewState=2" />"  target="_blank">
						<p class="xl_title">
							<img src="${item.warningText }" style="vertical-align:bottom;"/>
							 <span>${item.supervisionTitle }</span>
							 <p class="xl_footer">
								<span class="text_overflow" title="${item.createDepartmentName }" style="width:180px;display:inline-block;">${item.createDepartmentName }</span> <span style="padding-left:10px;vertical-align:top;">${item.createTime }</span>
							 </p>
						</p>
						
					</a>		
					</li>
				</c:forEach>
			</ul>
		</div>
	</div>
	<script>
		$(function() {
			$(".xl_menu").click(function() {
				$(".xl_box").toggleClass("xl_box_hidden");
			})
		})
	</script>
</body>
</html>