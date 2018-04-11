<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=formBindDesignManager"></script>
<title>${ctp:i18n('form.formlist.advanced')}</title>
</head>
<body bgcolor="#f6f6f6">
<div style="height:325" class="scrollList form_area">
<form id="form1" name="form1" method="post" action="fieldDesign.do?method=otherFormSave">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
  <tr>
    <td valign="top">
     <table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
     <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
	      <tr>
			<td width = "40%">${ctp:i18n('form.formotherpage.inputnewformname')}</td>
			<td>
			<div class="common_txtbox_wrap left" style="width: 152px;">
			<input type="text" id="formnewname"  name='formnewname' value="${formnewname}" class="validate font_size12" class="input-100" validate="avoidChar:'\\/|<>:*?;\'&%$#&#34;',notNullWithoutTrim:true,type:'string',name:'${ctp:i18n("form.base.formname.label")}',notNull:true,maxLength:255"/>
			</div>
            </td>
		  </tr>
		    <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>

		  <c:if test="${temList!=null &&fn:length(temList)>0}">
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
			  <td colspan="2">
			  <fieldset>
			  <legend>
				  	${ctp:i18n('form.formotherpage.inputtemplatename')}：
			  </legend>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" id="template">
			  <tr>
			  <td>
					${ctp:i18n('form.formotherpage.oldtemplatename')}
			  </td>
			  <td>
			  		${ctp:i18n('form.formotherpage.newtemplatename')}
			  </td>
			</tr>
			  <c:forEach items="${temList }" var="tem" varStatus="status">
			  	<tr>
				<td width="40%"><input disabled="disabled" style="width: 150px;" type = "text" value="${tem.name}" title="${tem.name}"> ：</td>
				<td>
				<div class="common_txtbox_wrap left" style="width: 150px;"> 
					<input type = "text" id="newTemNames${tem.id }" class="validate" name= "newTemNames${tem.id }" inputName="${templatenameLabel}" title="${tem.name }1" value="${tem.name }1" oldName="${tem.name }" queryId="${tem.id }" class="input-100" validate="name:'${ctp:i18n('form.seeyontemplatename.label')}',notNullWithoutTrim:true,type:'string',notNull:true,maxLength:60,avoidChar:'&&quot;&lt;&gt;'"></div>
				</td>
			  	</tr>
			  </c:forEach>
			  </table>
			  </fieldset>
			  </td>
			  </tr>
		  </c:if>

		  <c:if test="${queryList!=null &&fn:length(queryList)>0}">
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
			  <td colspan="2">
			  <fieldset>
			  <legend>${ctp:i18n('form.formotherpage.inputnewqueryname')}</legend>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" id="query">
			  <tr>
			  <td>${ctp:i18n('form.formotherpage.oldqueryname')}</td>
			  <td>${ctp:i18n('form.formotherpage.newqueryname')}</td>
			  </tr>
			  <c:forEach items="${queryList }" var="query" varStatus="status">
			  	<tr>
				<td width="40%"><input disabled="disabled" style="width: 150px;" type = "text" value="${query.name}" title="${query.name}"> ：</td>
				<td>
				<div class="common_txtbox_wrap left" style="width: 150px;"> 
					<input type = "text" id="newQueryNames${status.index}" class="validate" name= "newQueryNames${status.index}" inputName="${ctp:i18n('form.formotherpage.newqueryname')}" size = "25" maxlength = "80" value="${query.name }1" oldName="${query.name}" queryId="${query.id }" class="input-100" validate="name:'${ctp:i18n('form.query.queryname.label')}',type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\&#39;&quot;&lt;&gt;'">
				</div>
				<input type="text"  id="queryId${status.index}" name="queryId${status.index}" value="${query.id}" style="display:none;"/>
				</td>
			  	</tr>
			  </c:forEach>
			  </table>
			  </fieldset>
			  </td>
			  </tr>
		  </c:if>

		  <c:if test="${reportList!=null &&fn:length(reportList)>0}">
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
			  <td colspan="2">
			  <fieldset>
			  <legend>${ctp:i18n('form.formotherpage.inputnewreportname')}</legend>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" id = "report">
			  <tr>
			  <td>${ctp:i18n('form.formotherpage.oldreportname')}</td>
			  <td>${ctp:i18n('form.formotherpage.newreportname')}</td>
			  </tr>
			  <c:forEach items="${reportList }" var="report" varStatus="status">
			  	<tr>
				<td width="40%"><input disabled="disabled" style="width: 150px;" type = "text" value="${report.reportDefinition.name}" title="${report.reportDefinition.name}"> ：</td>
				<td>
				<div class="common_txtbox_wrap left" style="width: 150px;"> 
					<input type = "text" id="newReportNames${status.index}" class="validate" name= "newReportNames${status.index}" inputName="新的统计名称" size = "25" maxlength = "80" value="${report.reportDefinition.name}1" oldName="${report.reportDefinition.name}" reportId="${report.reportDefinition.id }" class="input-100"  validate="name:'${ctp:i18n('report.reportDesign.templetName')}',type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\&#39;&quot;&lt;&gt;!,@#$%&*()'">
				</div>
				<input type="text"  id="reportId${status.index}" name="reportId${status.index}" value="${report.reportDefinition.id}" style="display:none;"/>
				</td>
			  </tr>
			  </c:forEach>
			  </table>
			  </fieldset>
			  </td>
			  </tr>
		  </c:if>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
	  </table>
	</td>
  </tr>

</table>
</form>
</div>
<%@ include file="formotherpage.js.jsp" %>
</body>
</html>