<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script language="javascript">
	function changeLabel(which){
		switch (which){
			case 1:
				location.href="<html:link renderURL='/logonLog.do?method=summaryStat' />";
				break;
			case 2:
				location.href="<html:link renderURL='/logonLog.do?method=onlineTimeStat' />";
				break;
			case 3:
				location.href="<html:link renderURL='/logonLog.do?method=detailSearch' />";
				break;
			case 4:
				location.href="<html:link renderURL='/logonLog.do?method=unlogSearch' />";
				break;
		}
	}
	
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/log/i18n");
</script>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag" colspan="20">
			<div class="div-float">
			<div class="tab-separator"></div>
			<div id="div1_left" class="${param.method=='summaryStat'?'tab-tag-left-sel':'tab-tag-left' }"></div>
			<div id="div1_middel" class="${param.method=='summaryStat'?'tab-tag-middel-sel':'tab-tag-middel' }" onclick="javascript:changeLabel(1)"><fmt:message key="logon.summaryStat.label" /></div>
			<div id="div1_right" class="${param.method=='summaryStat'?'tab-tag-right-sel':'tab-tag-right' }"></div>
			<div class="tab-separator"></div>
			
			<div id="div2_left" class="${param.method=='onlineTimeStat'?'tab-tag-left-sel':'tab-tag-left' }"></div>
			<div id="div2_middel" class="${param.method=='onlineTimeStat'?'tab-tag-middel-sel':'tab-tag-middel' }" onclick="javascript:changeLabel(2)"><fmt:message key="logon.onlineTimeStat.label" /></div>
			<div id="div2_right" class="${param.method=='onlineTimeStat'?'tab-tag-right-sel':'tab-tag-right' }"></div>
			<div class="tab-separator"></div>
			
			<div id="div3_left" class="${param.method=='detailSearch'?'tab-tag-left-sel':'tab-tag-left' }"></div>
			<div id="div3_middel" class="${param.method=='detailSearch'?'tab-tag-middel-sel':'tab-tag-middel' }" onclick="javascript:changeLabel(3)"><fmt:message key="${resouce}" /></div>
			<div id="div3_right" class="${param.method=='detailSearch'?'tab-tag-right-sel':'tab-tag-right' }"></div>
			<div class="tab-separator"></div>
			
			<div id="div4_left" class="${param.method=='unlogSearch'?'tab-tag-left-sel':'tab-tag-left' }"></div>
			<div id="div4_middel" class="${param.method=='unlogSearch'?'tab-tag-middel-sel':'tab-tag-middel' }" onclick="javascript:changeLabel(4)"><fmt:message key="logon.unlogonSearch.label" /></div>
			<div id="div4_right" class="${param.method=='unlogSearch'?'tab-tag-right-sel':'tab-tag-right' }"></div>
			<div class="tab-separator"></div>
			<%-- 
			<div id="div5_left" class="${param.method=='clearLog'?'tab-tag-left-sel':'tab-tag-left' }"></div>
			<div id="div5_middel" class="${param.method=='clearLog'?'tab-tag-middel-sel':'tab-tag-middel' }" onclick="javascript:changeLabel(5)"><fmt:message key="logon.performanceClear.label" /></div>
			<div id="div5_right" class="${param.method=='clearLog'?'tab-tag-right-sel':'tab-tag-right' }"></div>
			<div class="tab-separator"></div>
			--%>
			</div>
		</td>
	</tr>
