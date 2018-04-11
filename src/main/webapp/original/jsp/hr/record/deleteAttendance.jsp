<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='hr.record.delete.label' bundle='${v3xHRI18N}' /></title>
<script type="text/javascript">
function cancel(){
  getA8Top().deleteAttendanceWin.close() ;
}
function OK(){
	if(!confirm("<fmt:message key='hr.record.delete.alert.notice.label' bundle='${v3xHRI18N}' />")){
		getA8Top().deleteAttendanceWin.close();
	}else{
		var windowObj = transParams.parentWin;
		var deleteType = document.getElementById("deleteType").value;
		var deleteForm = document.getElementById("deleteForm");
		deleteForm.action = "${hrRecordURL}?method=deleteAttendance&recordDept=${recordDept}&deleteType=" + deleteType;
		deleteForm.submit();
		windowObj.parent.listFrame.location.reload(true);
		getA8Top().deleteAttendanceWin.close();
	}
}
</script>
</head>
<body scroll='no' style="overflow: hidden;">
<form action="" target='submitFrame' name="deleteForm" id="deleteForm" method="post" >
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight" >
	<tr class="PopupTitle" height="15" >
	  <td class="PopupTitle" ><fmt:message key='hr.record.delete.label' bundle='${v3xHRI18N}' /></td>
	</tr>
	<tr >
		<td><label style="width:140">&nbsp;&nbsp;<fmt:message key='hr.record.delete.select.label' bundle='${v3xHRI18N}' /></label>
			<select style="width:83" name="deleteType" id="deleteType">
				<option value="1"><fmt:message key='hr.record.delete.one.month.label' bundle='${v3xHRI18N}' /></option>
				<option value="3"><fmt:message key='hr.record.delete.three.month.label' bundle='${v3xHRI18N}' /></option>
				<option value="6"><fmt:message key='hr.record.delete.six.month.label' bundle='${v3xHRI18N}' /></option>
				<option value="9"><fmt:message key='hr.record.delete.nine.month.label' bundle='${v3xHRI18N}' /></option>
				<option value="12"><fmt:message key='hr.record.delete.one.year.label' bundle='${v3xHRI18N}' /></option>
				<option value="24"><fmt:message key='hr.record.delete.two.year.label' bundle='${v3xHRI18N}' /></option>
				<option value="36"><fmt:message key='hr.record.delete.three.year.label' bundle='${v3xHRI18N}' /></option>
				<option value="60"><fmt:message key='hr.record.delete.five.year.label' bundle='${v3xHRI18N}' /></option>
			</select>
		</td>
	</tr>
	<tr valign="bottom" height="20px">
		<td class="description-lable" style="word-break:break-all;">*<fmt:message key="hr.record.delete.notice.label" bundle="${v3xHRI18N}" /></td>
	</tr>
	<tr>
	    <td align="center" class="bg-advance-bottom" colspan="2" >
		     <input type="button" onclick="OK()" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" id="b1" name="b1" />&nbsp;&nbsp;&nbsp;&nbsp;
		     <input type="button" onclick="cancel()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" id="b2" name="b2" />
	    </td>
	</tr>
</table>
</form>
<iframe name="submitFrame" frameborder="0"></iframe>
</body>
</html>
