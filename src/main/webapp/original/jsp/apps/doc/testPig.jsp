<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../collaboration/Collaborationheader.jsp" %>	
<%@ include file="pigeonholeHeader.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
	function pig() {
		var appName = document.getElementById("appKey").value;
		var sourceIds = document.getElementById("srcIds").value;
		var atts = document.getElementById("atts").value;
		alert("--" + appName + "--" + sourceIds + "--" + atts + "--")
		var ret = pigeonhole(appName, sourceIds, atts);
		alert("pigeonhole " + ret);
	}
	function prepig() {
		var appName = document.getElementById("appKey").value;
		//var sourceIds = document.getElementById("srcIds").value;
		alert("--" + appName + "--")
		var ret = pigeonhole(appName, null);
		alert("pigeonhole " + ret);
	}
	function projectPig() {
		var appName = document.getElementById("appKey").value;
		var sourceIds = document.getElementById("srcIds").value;
		var atts = document.getElementById("atts").value;
		var projectId = document.getElementById("projectId").value;
		var ret = projectPigeonhole(appName, sourceIds, projectId, atts);
		alert("project pigeonhole " + ret);
	}
</script>
</head>

<BODY scroll="no" >
<h3>假设其他模块，进行归档测试</h3>
<br>
	global(0), // 全局
	collaboration(1), // 协同应用
	form(2), // 表单
	doc(3), // 知识管理
	edoc(4), // 公文
	plan(5), // 计划
	meeting(6), // 会议
	bulletin(7), // 公告
	news(8), // 新闻
	bbs(9), // 讨论
	inquiry(10), // 调查
	calendar(11), // 日程事件
	mail(12), // 邮件
	organization(13),// 组织模型
	project(14), // 项目
	relateMember(15), // 关联人员
	exchange(16), // 交换
	hr(17), //人力资源
	blog(18); //博客
<br>
应用key：<input type="text" id="appKey" />
<br>
sourceIds：<input type="text" id="srcIds" size="100" />
<br>
附件：<input type="text" id="atts" size="100" />
<br>
<input type="button" value="普通归档" onclick="pig()" />
<input type="button" value="预归档" onclick="prepig()" />
<br>
关联项目id：<input type="text" id="projectId" />
<br>
<input type="button" value="关联项目归档" onclick="projectPig()" /><br>

</BODY>