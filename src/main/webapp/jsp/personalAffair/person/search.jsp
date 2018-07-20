<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	  function search(){
    	var keyword = document.getElementById("keyword").value;
    	//form1.submit();
    	
    	var url = "<html:link renderURL='/indexInterface.do?method=search' psml='default-page.psml' />&keyword=" + encodeURI(keyword);
    	document.location.href = url;
  }

</script>

<table width="360" border="0" cellspacing="0" cellpadding="0">
  <tr>
	 <td>
		<input type="text" value="" id="keyword" name="keyword" maxlength="40"/>
		<input type="button" value="????" onclick="search()"/>
		<input type="button" value="???????" onclick=""/>
	 </td>
	
  </tr>
</table>

