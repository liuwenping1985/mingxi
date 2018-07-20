<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>转发文</title>
<%@ include file="../edoc/edocHeader.jsp" %>
</head>
<script type="text/javascript">
  function OK(){
	  var result = "";
	  $(".forwordName").each(function(){
		  if($(this).attr("checked")){
			  result += $(this).val() + ".";
		  }
	  });
	  result += ($("#newContactReceive_1").attr("checked") ? true : false) + ".";
	  result += ($("#newContactReceive_2").attr("checked") ? true : false);
	  return result;
  }

</script>
<body style="overflow:hidden;background-color:#ededed;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="PopupTitle"><fmt:message key="edoc.form.title.textturndraft" />
		</td>
	</tr>
	<tr >
		<td class="bg-advance-middel">
		<div style="height:100px;_height:90px;padding-left: 80px">
		<input class="forwordName" type="radio" name="forwordName" id="forwordName0" value="0" checked="checked"/><fmt:message key="edoc.form.textturntext" /><br>
        <input class="forwordName" type="radio" name="forwordName" id="forwordName1" value="1" /><fmt:message key="edoc.form.textturnfile" /><br>
       <%--puyc 新增功能 收文关联发文 --%>   
       <input class="" type="checkbox"  id="newContactReceive_1" name="newContactReceive" value="1"/><fmt:message key='edoc.associated.newposting'/><br>
       <input class="" type="checkbox"  id="newContactReceive_2" name="newContactReceive" value="2"/><fmt:message key='edoc.associated.newgeting'/><br>
       
       </div>
		</td>
	</tr>
</table>
</body>
</html>
 