<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title><fmt:message key="module.sort" bundle="${surveyI18N}"/></title>
</head>
<body scroll='no' style="overflow: hidden;">
<form name="formorder" method="post">
<input type=hidden name="projects" value="">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key='inquiry.type.order.label' bundle='${surveyI18N}' /></td>
	</tr>
	<tr>
	<td  class="categorySet-head2">
		<center>
		  <table width="100%" height="100%" border="0">
            <tr>
              <td width="37%" height="70">&nbsp;</td>
              <td rowspan="5">
				  <select id="projectsObj" name="projectsObj" size="12" multiple style="width:250px;height:150px">
					  <c:forEach var="pro" items="${bbsBoardList}">
					  	<option value="${pro.id}">${v3x:toHTML(pro.name)}</option>
					  </c:forEach>
	              </select>
              </td>
			  <td width="37%">&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
			  <p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
						alt='<fmt:message key="selectPeople.alt.up" bundle='${v3xMainI18N}'/>'width="24"
						height="24" class="cursor-hand" onClick="up(formorder.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
			  <p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
						alt='<fmt:message key="selectPeople.alt.down" bundle='${v3xMainI18N}'/>' width="24"
						height="24" class="cursor-hand" onClick="down(formorder.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>		
		</center>
	  </td>				
	</tr>
    <tr>
      <td height="42" align="center" class="bg-advance-bottom">
	  <input name="Submit" type="button" onClick="saveOrder();" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />&nbsp;
	  <input type="button" name="b2" onclick="getA8Top().bbsBoardOrdersWin.close();"	value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />
	  </td>
    </tr>
</table>
</form>
</body>
</html>
