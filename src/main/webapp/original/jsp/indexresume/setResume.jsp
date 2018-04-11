<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html"
	prefix="html"%>

<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8"
	src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>


<fmt:setBundle
	basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources"
	var="locale" />
<fmt:setBundle
	basename="com.seeyon.v3x.main.resources.i18n.MainResources"
	var="v3xMainI18N" />
<fmt:setBundle
	basename="com.seeyon.apps.indexResume.resource.i18n.IndexResumeResources" />
<fmt:setBundle
	basename="com.seeyon.apps.index.resource.i18n.IndexResources"
	var="indexResources" />
<fmt:setBundle
	basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"
	var="v3xCommonI18N" />
<html:link renderURL="/index/indexResumeController.do"
	var="indexResumeUrl" />
<head>
<title>重建索引</title>
<%@ include file="../common/INC/noCache.jsp"%>
<script type="text/javascript">
<!--
	var v3x = new V3X();
	v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
	_ = v3x.getMessage;
	v3x.loadLanguage("/apps_res/index/js/i18n/");
	function disableSet() {
		document.getElementById("setOption").disabled = true;
		document.getElementById("setOption1").disabled = true;
		document.getElementById("setOption2").disabled = true;
		document.getElementById("setOption3").disabled = true;
		<c:forEach var="appType" items="${appLibs}" varStatus="status">
		var disenable = document.getElementById("appCheck${appType}").disabled = true;
		</c:forEach>
		document.getElementById("setOption5").disabled = true;
		document.getElementById("setOption6").disabled = true;
	}
	function enableSet() {
		//var disenable=document.getElementById("setOption").style.display= "";
		//var disenable=document.getElementById("setOption2").style.display= "";
		//var disenable=document.getElementById("setOption3").style.display= "";
		document.getElementById("setOption").disabled = false;
		document.getElementById("setOption1").disabled = false;
		document.getElementById("setOption2").disabled = false;
		document.getElementById("setOption3").disabled = false;
		<c:forEach var="appType" items="${appLibs}" varStatus="status">
		document.getElementById("appCheck${appType}").disabled = false;
		</c:forEach>
		document.getElementById("setOption5").disabled = false;
		document.getElementById("setOption6").disabled = false;

	}
	function resumeForm(form) {
		var disenable = document.getElementById("disRadio").checked;
		if (disenable) {
			return true;
		}
		if (checkForm(form)) {
			var myform = document.getElementById("autoForm");
			myform.action = "${indexResumeUrl}?method=saveConfig"
			myform.target = "addConfigFrame";
			var _starTime = myform.starHour.value + myform.starMin.value;
			var _endTime = myform.endHour.value + myform.endMin.value;
			if (_starTime == _endTime) {
				alert("<fmt:message key='indexResume.oper.startime'/><fmt:message key='indexResume.oper.endtime' /><fmt:message key='indexResume.oper.settimeerror'/>");
				return false;
			}
			var beginDate = myform.resumeStarDate;
			var endDate = myform.resumeEndDate;
			if (beginDate.value > endDate.value) {
				alert(getA8Top().v3x.getMessage("V3XLang.index_input_endDate_less_beginDate"));
				return false;
			}
			var ids = document.getElementsByName("appType");
			var y = 0;
			for (var i = 0; i < ids.length; i++) {
				var idCheckBox = ids[i];
				if (idCheckBox.checked) {
					y++;
					var requestCaller = new XMLHttpRequestCaller(this, "ajaxIndex", "searchDateScope", false);
					requestCaller.addParameter(1, "String", beginDate.value);
					requestCaller.addParameter(2, "String", endDate.value);
					requestCaller.addParameter(3, "String", idCheckBox.value);
					var ds1 = requestCaller.serviceRequest();
					if (ds1 != null && ds1 == 'true') {

						if (!confirm(queryMap1.get(idCheckBox.value) + "<fmt:message key='indexResume.oper.exit.tip'/>" + "?")) {
							idCheckBox.checked = false;
							y--;
						}
					}
				}
			}
			if (y == 0) {
				alert("<fmt:message key='indexResume.oper.modle'/>");
				return false;
			}
			// getA8Top().startProc('');
			return true;
		}
		return false;
	}
//-->
</script>

<script type="text/javascript">
	function HashMap() {
		this.map = {};
	}
	HashMap.prototype = {
		put : function(key, value) {
			this.map[key] = value;
		},
		get : function(key) {
			if (this.map.hasOwnProperty(key)) {
				return this.map[key];
			}
			return null;
		}
	};
	var queryMap1 = new HashMap();
</script>
</head>
<body style="overflow: hidden" onload="scroll_Fn()"
	onresize="scroll_Fn()">
	<span id="nowLocation"></span>
	<form action="${indexResumeUrl}?method=saveConfig" name="autoForm"
		id="autoForm" method="post" onsubmit="return (resumeForm(this))"
		target="addConfigFrame">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"
			height="100%" align="center">
			<tr class="page2-header-line">
				<td width="100%" height="41" valign="top"
					class="page-list-border-LRD">
					<table width="100%" height="100%" border="0" cellpadding="0"
						cellspacing="0">
						<tr class="page2-header-line">
							<td width="45" class="page2-header-img"><div
									class="notepager"></div></td>
							<td id="notepagerTitle1" class="page2-header-bg">&nbsp;<fmt:message
									key='indexResume.oper.mainmenu' /></td>
							<td class="page2-header-line padding-right" align="right">&nbsp;
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td id="ssslist_td" class="categorySet-head" valign="top">
					<div id="ssslist" style="height: 10px; overflow: auto;">

						<table width="90%" height="100%" border="0" cellspacing="0"
							cellpadding="0" align="center">
							<tr>
								<td height="50" valign="top"><b><fmt:message
											key='indexResume.oper.enable' />:</b>&nbsp;&nbsp; <label
									for="enableRadio"> <input onclick="enableSet()"
										id="enableRadio" type="radio" name="enableState" value="true"
										${resumeInfo.enableState=='true'? 'checked':''} />
									<fmt:message key='indexResume.oper.enable.true' />
								</label>&nbsp;&nbsp; <label for="disRadio"> <input
										onclick="disableSet()" id="disRadio" type="radio"
										name="enableState" value="false"
										${resumeInfo.enableState=='false'? 'checked':''} />
									<fmt:message key='indexResume.oper.enable.false' />
								</label></td>
							</tr>
							<tr>
								<td valign="top">
									<fieldset>
										<legend>
											<b><fmt:message key="indexResume.oper.set" /></b>
										</legend>
										<table width="100%" id="autoSynchOption" border="0"
											cellspacing="0" cellpadding="0" align="center" height="200">
											<tr>
												<td rowspan="2" align="right"
													style="border-bottom: 2px solid;"><font color="red">*</font>
												<fmt:message key='indexResume.oper.scorptime' />：</td>
												<td nowrap="nowrap" align="right"
													style="vertical-align: bottom;"><fmt:message
														key='indexResume.oper.startime' />：</td>
												<td align="left" style="vertical-align: bottom;"><fmt:message
														key="indexResume.org.auto.everyday" /> <select
													name="starHour"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption">
														<c:forEach items="${starthourList }" var="starHour">
															<option value="${starHour}"
																${resumeInfo.starHour == starHour?'selected':''}>${starHour}</option>
														</c:forEach>
												</select> <fmt:message key="indexResume.org.auto.hour" /> <select
													name="starMin"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption1">
														<c:forEach items="${startMinList }" var="starMin">
															<option value="${starMin}"
																${resumeInfo.starMin == starMin?'selected':''}>${starMin}</option>
														</c:forEach>
												</select> <fmt:message key="indexResume.org.auto.min" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap" align="right"
													style="vertical-align: bottom; border-bottom: 2px solid;">
													<fmt:message key='indexResume.oper.endtime' />：
												</td>
												<td align="left"
													style="vertical-align: bottom; border-bottom: 2px solid;">
													<fmt:message key="indexResume.org.auto.everyday" />
													<select name="endHour"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption2">
														<c:forEach items="${starthourList }" var="endHour">
															<option value="${endHour}"
																${resumeInfo.endHour == endHour?'selected':''}>${endHour}</option>
														</c:forEach>
												</select> <fmt:message key="indexResume.org.auto.hour" /> <select
													name="endMin"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption3">
														<c:forEach items="${startMinList }" var="endMin">
															<option value="${endMin}"
																${resumeInfo.endMin == endMin?'selected':''}>${endMin}</option>
														</c:forEach>
												</select> <fmt:message key="indexResume.org.auto.min" />
												</td>
											</tr>
											<tr>
												<td rowspan="2" nowrap="nowrap" align="right"><font
													color="red">*</font>
												<fmt:message key="indexResume.oper.scorp" />：</td>
												<td nowrap="nowrap" align="right"><fmt:message
														key="indexResume.oper.modle" />：</td>
												<td><c:forEach var="appType" items="${appLibs}"
														varStatus="status">
														<c:set var="checkValue" value="false"></c:set>
														<c:forEach items="${resumeInfo.appType}" var="app">
															<c:if test="${app == appType}">
																<c:set var="checkValue" value="true"></c:set>
															</c:if>
														</c:forEach>
														<label for="appCheck${appType}"> <script
																type="text/javascript">
															queryMap1
																	.put("${appType}",
																			"<fmt:message key='index.application.${appType}.label' bundle='${indexResources }'/> ");
														</script> <input <c:if test="${checkValue}">checked</c:if>
															type="checkbox" name="appType" value="${appType}"
															id="appCheck${appType}"
															${resumeInfo.enableState=='true'? '':'disabled'} /> <fmt:message
																key='index.application.${appType}.label'
																bundle="${indexResources }" /></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <c:if
															test="${status.count%4==0&&status.count!=0}">
															<br>
														</c:if>
													</c:forEach></td>
											</tr>
											<tr>
												<td nowrap="nowrap" align="right"
													style="vertical-align: middle;"><fmt:message
														key='indexResume.oper.timeset' />：</td>
												<td><input type="text" size="9" name="resumeStarDate"
													onclick="whenstart('<%=request.getContextPath() %>',this,300,340);"
													value="${resumeInfo.resumeStarDate}" readonly="readonly"
													validate="notNull"
													inputName="<fmt:message key='indexResume.oper.timeset'/>"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption5" /> <fmt:message
														key='index.com.seeyon.v3x.index.to'
														bundle="${indexResources }" /> <input type="text" size="9"
													name="resumeEndDate"
													onclick="whenstart('<%=request.getContextPath() %>',this,425,340);"
													value="${resumeInfo.resumeEndDate}" readonly="readonly"
													validate="notNull"
													inputName="<fmt:message key='indexResume.oper.timeset'/>"
													${resumeInfo.enableState=='true'? '':'disabled'}
													id="setOption6" /></td>
											</tr>
										</table>
									</fieldset>
								</td>
							</tr>
							<tr>
								<td>
									<p class="description-lable">
										<b><fmt:message key='indexResume.oper.tip' /></b><br />
										<fmt:message key='indexResume.oper.tip.1' />
										<br>
										<fmt:message key='indexResume.oper.tip.2' />
									</p>
								</td>

							</tr>
							<tr>
								<td valign="top">

									<div id="content">
										<ul>
											<c:forEach var="infos" items="${resumeInfo.resumeList}"
												varStatus="status">
												<c:if
													test="${resumeInfo.resumeEndDate==infos.endDate4Resume}">
													<li><fmt:message
															key='index.application.${infos.appType}.label'
															bundle='${indexResources}' />
														<fmt:message key='indexResume.oper.history.notstart'>
														</fmt:message></li>
												</c:if>
												<c:if
													test="${resumeInfo.resumeEndDate!=infos.endDate4Resume}">
													<li><fmt:message
															key='index.application.${infos.appType}.label'
															bundle='${indexResources}' />:&nbsp; <c:choose>
															<c:when test="${infos.endDate4Resume=='OVER'}">
																<fmt:message key='indexResume.oper.history.para1' />
															</c:when>
															<c:otherwise>
																<fmt:message key='indexResume.oper.history.para'>
																	<fmt:param value="${resumeInfo.resumeEndDate}"></fmt:param>
																	<fmt:param value="${infos.endDate4Resume}"></fmt:param>
																</fmt:message>
															</c:otherwise>
														</c:choose></li>
												</c:if>
											</c:forEach>
										</ul>
									</div>

								</td>
							</tr>

						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td height="20" align="center" class="tab-body-bg bg-advance-bottom"
					style="height: 20px; border: 0px"><input type="submit"
					name="submitButton"
					value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"
					class="button-default-2">&nbsp; <input type="button"
					onclick="getA8Top().document.getElementById('homeIcon').click();"
					value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
					class="button-default-2"></td>
			</tr>
		</table>
	</form>
	<iframe id="addConfigFrame" name="addConfigFrame" frameborder="0"
		height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	<iframe name="hiddenFrame" id="hiddenFrame" width="0" height="0"
		frameborder="0"></iframe>
</body>
<script language="javascript">
	showCtpLocation('F04_indexResumeConfig');
	function scroll_Fn() {
		document.getElementById("ssslist").style.display = "none";
		document.getElementById("ssslist").style.height = document.getElementById("ssslist_td").clientHeight;
		document.getElementById("ssslist").style.display = "";
	}
</script>
</html>