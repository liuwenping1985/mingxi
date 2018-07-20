<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html style="height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<style type="text/css">
/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:40px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:40px;
 bottom:0px;
}
.top_div_row2 {
 height:40px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
/***layout*row1+row2****end**/
</style>
<title>Insert title here</title>
</head>
<c:set value="${param.flag=='group'? v3x:suffix():''}" var="suffix"/>
<script type="text/javascript">
<c:if test="${param.where != 'space'}">
//TODO getA8Top().showLocation(2006, "<fmt:message key='menu.${param.flag}.bulletin.set${suffix}' bundle='${v3xMainI18N}'/>");
</c:if>
</script>
</head>
<body scroll="no" class="padding5" style="height:100%;">
<div class="main_div_row2">
	<div class="right_div_row2">
		<div class="top_div_row2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			   <tr>
			      <td valign="bottom" height="26" class="tab-tag  ">
						<div class="div-float">
							<div class="tab-separator"></div>	
							<div class="tab-tag-left-sel"></div>
							<div class="tab-tag-middel-sel cursor-hand" onclick="location.reload();">
								<fmt:message key='menu.${param.flag}.bulletin.set${suffix}' bundle="${v3xMainI18N}"/>
							</div>
							<div class="tab-tag-right-sel"></div>
		
							<div class="tab-separator"></div>	
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/inquiry.do?method=inquiryManageIndex&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}' />'">
								<fmt:message key='menu.${param.flag}.inquiry.set${suffix}' bundle="${v3xMainI18N}"/>
							</div>
							<div class="tab-tag-right"></div>
		
							<div class="tab-separator"></div>
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/bbs.do'/>?method=bbsManageIndex&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}'">
								<fmt:message key='menu.${param.flag}.bbs.set${suffix}' bundle="${v3xMainI18N}"/>
							</div>
							<div class="tab-tag-right"></div>
							
							<div class="tab-separator"></div>	
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/newsType.do?method=newsManageIndex&flag=${param.flag}&notIndex=true&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}' />'">
							 	<fmt:message key='menu.${param.flag}.news.set${suffix}' bundle="${v3xMainI18N}"/>
							</div>
							 <div class="tab-tag-right"></div>
		                    <div class="tab-separator"></div>
						</div>
				  </td>
			  </tr>
		</table>
		</div>
		<div class="center_div_row2" id="scrollListDiv" style="overflow: hidden;">
			<iframe width="100%" height="100%" id="bulletinFrame" frameborder="0" src="${bulTypeURL}?method=listMain&spaceType=${param.spaceType}&spaceId=${param.spaceId}" />
		</div>
	</div>
</div>
</body>		
</html>