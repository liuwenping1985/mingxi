<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<html:link renderURL="/blog.do" var="detailURL" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL='/genericController.do' var="genericController" />

<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource" var="v3xDocI18N"/>
<fmt:message key="common.datetime.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.apps.blog.resources.i18n.BLOGResources" />

<c:url value="/common/detail.jsp" var="commonDetailURL" />

<link rel="stylesheet" type="text/css"
		href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/blog/css/blog.css${v3x:resSuffix()}" />">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/blog/js/blog.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/blog/js/relateMember.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	var genericURL = '${detailURL}';
	var genericControllerURL = "${genericController}?ViewPage=";
	var deleteActionURL = genericURL + "?method=deleteArticle&from=${param.method}";
	var deleteFavoritesActionURL = genericURL + "?method=delFavoritesArticle&from=${param.method}";
	var newActionURL = genericURL + "?method=blogNew&from=${param.method}";
	var alertDeleteItem = "<fmt:message key="delete.article.notice.alertDeleteItem" />";
	var deleteArticleConfirm = "<fmt:message key="delete.article.notice.label" />";
	var deleteFavoritesArticleConfirm = "<fmt:message key="delete.favorites.post.notice.label" />";
	var alertDelete = "<fmt:message key="blog.select_delete_record" />";
	var alertPeople = "<fmt:message key="blog.select_people_record" />";
	var deleteConfirm = "<fmt:message key="blog.confirm_delete" />";
	var alertChooseFavoritesFamily = "<fmt:message key="blog.family.favorites.choose.alert" />";
	var alertChooseOneFavoritesFamily = "<fmt:message key="blog.family.favorites.choose.onealert" />";

	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", 
		"<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
	_ = v3x.getMessage;
	v3x.loadLanguage("/apps_res/blog/js/i18n");
	v3x.loadLanguage("/apps_res/doc/i18n");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
	v3x.loadLanguage("/common/js/i18n");
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<style type="text/css">
.border_b {  border-bottom: 1px solid #b6b6b6;}
</style>
