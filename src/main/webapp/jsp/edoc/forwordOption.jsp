<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>转发文</title>
<%@ include file="edocHeader.jsp" %>
</head>
<script type="text/javascript">
  function checkOption(val){
	  document.getElementById("optionValue").value=val;
  }

</script>
<body style="overflow:hidden;background-color:#ededed;">
  <form action="" method="post" id="forwordForm" name="forwordForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="PopupTitle"><fmt:message key="edoc.form.title.textturndraft" />
		</td>
	</tr>
	<tr >
		<td class="bg-advance-middel">
		<div style="height:100px;_height:90px;padding-left: 80px">
		<input class="" type="radio" name="forwordName" id="forwordName0" value="0" ${disableContent == true ? " disabled=true " :  " checked='checked'"}  onclick="checkOption(0)"/><fmt:message key="edoc.form.textturntext" /><br>
        <input class="" type="radio" name="forwordName" id="forwordName1" value="1" ${disableContent == true ? "checked='checked'" :  ""} onclick="checkOption(1)"/><fmt:message key="edoc.form.textturnfile" /><br>
       <%--puyc 新增功能 收文关联发文 --%>   
       <input class="" type="checkbox"  id="newContactReceive_1" name="newContactReceive" value="1"/><fmt:message key='edoc.associated.newposting'/><br>
       <input class="" type="checkbox"  id="newContactReceive_2" name="newContactReceive" value="2"/><fmt:message key='edoc.associated.newgeting'/><br>
       
       <%--OA-28621 将一条pdf正文格式的收文转发文操作，勾选将原正文作为新公文的附件，结果到发文的时候没有显示该附件，新拟文页面的正文类型也什么都没有选中了 --%>
       <input type="hidden" name="optionValue" value="${disableContent == true ? 1 : 0}" id="optionValue"/>
       </div>
		</td>
	</tr>
    <%--puyc 新增功能 收文关联发文 结束 --%> 
	<tr>
		<td align="center"" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key="edoc.form.button.ok" />" onclick="javascript:checkForwdForm();" class="button-default_emphasize"/>
			<input type="button" value="<fmt:message key="edoc.form.button.cancel" />" onclick="transParams.parentWin.showForwardWDTwoWin.close()" class="button-default-2"/>
		</td>
	</tr>
</table>
    </form>
</body>
</html>
 