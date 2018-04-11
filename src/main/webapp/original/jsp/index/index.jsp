<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.indexInterface.resource.i18n.IndexResources"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>全文检索-搜索</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript">
<!--
//getA8Top().hiddenNavigationFrameset();

var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;
	
function cursorTag(n){
	 var search1Obj = document.getElementById("search1");
	 var search2Obj = document.getElementById("search2");
	if(n==1){
		removeClass(search2Obj,"li_current");
		addClass(search1Obj,"li_current");
		if(${keyword==null}){
			document.getElementById('containerFrame').src="<c:url value='/index/indexController.do?method=searchAll&AdvanceOption=${AdvanceOption}&collaboration=1&doc=1&bbs=1&meeting=1&bulletin=1&news=1&inquiry=1&calendar=1'/>";
		}else{
			document.getElementById('containerFrame').src="<c:url value='/index/indexController.do?method=searchAll'><c:param name='keyword' value='${keyword}'/><c:param name='AdvanceOption' value='${AdvanceOption}'/></c:url>";
		}
		
	}else if(n==2){
		removeClass(search1Obj,"li_current");
		addClass(search2Obj,"li_current");
		document.getElementById('containerFrame').src='<c:url value='/isearch.do?method=index&page=content'/>';
	}
}

function hasClass(obj, cls) { 
    return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)')); 
} 

function addClass(obj, cls) { 
    if (!this.hasClass(obj, cls)) { 
        obj.className += " " + cls; 
    } 
} 

function removeClass(obj, cls) { 
    if (hasClass(obj, cls)) { 
        var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)'); 
        obj.className = obj.className.replace(reg, ' '); 
    } 
} 
//-->
</script>
<style type="text/css">
	.border_b_s{
		border-bottom: 1px solid #b6b6b6;
	}
	.nowLoc_DIV_ul{
		overflow: hidden;
		list-style: none;
		margin:0;
		padding:0;
		padding-left:20px;

	}
	.nowLoc_DIV_li{
		float:left;
		line-height: 30px;
		height:30px;
		width: 100px;
		border-bottom: 2px solid transparent;
		text-align: center;
		cursor: default;
	}
	.nowLoc_DIV_li.li_current{
		color:#6d9fed;
		border-bottom: 2px solid #0088ff;
	}
</style>
</head>
<body srcoll="no">
<span id="nowLocation"></span>
<table width="100%" height="99%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" valign="bottom" height="33" class="tab-tag" style="border-right: 0">
			<div class="div-float">
				<!-- <div class="tab-separator"></div>
			    <c:if test="${v3x:hasMenu('F12_isearch')}">	
				<div id="l-2" class="${searchType==null?'tab-tag-left':'tab-tag-left-sel'}"></div>
				<div id="m-2" class="${searchType==null?'tab-tag-middel':'tab-tag-middel-sel'}" style="border-bottom-width: 0px;" onclick="cursorTag(2)"><fmt:message key="menu.tools.isearch" bundle="${v3xMainI18N}"/></div> --><!--综合查询-->
				<!-- <div id="r-2" class="${searchType==null?'tab-tag-right':'tab-tag-right-sel'}"></div>
				<div class="tab-separator"></div>
		        </c:if>
				<div id="l-1" class="${searchType==null?'tab-tag-left-sel':'tab-tag-left'}"></div>
				<div id="m-1" class="${searchType==null?'tab-tag-middel-sel':'tab-tag-middel'}" style="border-bottom-width: 0px;" onclick="cursorTag(1)"><fmt:message key='menu.index' bundle="${v3xMainI18N}" /></div> --><!--全文检索-->
				<!-- <div id="r-1" class="${searchType==null?'tab-tag-right-sel':'tab-tag-right'}"></div>
				<div class="tab-separator"></div> -->
				<div class="nowLoc_DIV">
					<ul class="nowLoc_DIV_ul">
					<c:if test="${v3x:hasMenu('F12_isearch')}">	
						<li class="nowLoc_DIV_li  ${searchType!=null?'li_current':''}" id="search2" onclick="cursorTag(2)">
							<span>
								<fmt:message key="menu.tools.isearch" bundle="${v3xMainI18N}"/>	
							</span>	
						</li>
					</c:if>
						<li class="nowLoc_DIV_li  ${searchType==null?'li_current':''}" id="search1"  onclick="cursorTag(1)">
							<span>
								<fmt:message key='menu.index' bundle="${v3xMainI18N}" />
							</span>
						</li>
					</ul>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3" width="100%" height="100%" class="page-list-border-LRD">
		<c:choose>
			<c:when test="${searchType==null}">
				<c:choose>
				<c:when test="${keyword==null && accessoryName==null}">
					<iframe src="<c:url value='/index/indexController.do?method=goToAdvancePage&page=content'/>" name="containerFrame" id="containerFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
				</c:when>
				<c:otherwise>
					<iframe src="<c:url value='/index/indexController.do?method=searchAll'><c:param name='keyword' value='${keyword}'/><c:param name='accessoryName' value='${accessoryName}'/><c:param name='appCategory' value='${appCategory}'/></c:url>" name="containerFrame" id="containerFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					<script language="javascript">
						showCtpLocation('F04_indexSearch');
					</script>
				</c:otherwise>
				</c:choose>
			</c:when>
		<c:otherwise>
			<iframe src="<c:url value='/isearch.do?method=index&page=content'/>" name="containerFrame" id="containerFrame" frameborder="0" height="100%" width="100%" scrolling="auto" marginheight="0" marginwidth="0"></iframe>
		</c:otherwise>
		</c:choose>
		</td>
	</tr>
</table>
</body>
</html>