<%--
 $Author:  苗永锋$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>取回确认页面</title>
<script type="text/javascript">
function OK(){
	var theForm = document.forms["commentForm"];
	var saveComment = theForm.saveComment;
	var save = 2;
	if(saveComment.checked){
		save = 1;
	}
	return save;
}
</script>
</head>
<body scroll="no" style="background:#fafafa;">
<form name="commentForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='col.takeBack.title' /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="28" valign="top">
                        <!-- 确认要取回选中的协同？ -->
						<span class="msgbox_img_4 left margin_l_10"></span><span class="font_size12 left margin_t_5">${ctp:i18n('collaboration.takebackConfirm.backCol')}</span>
					</td>
				</tr>
				<tr>
					<td valign="top">
                        <!-- 直接对原意见修改 -->
                        <!--wxj 取回后直接进入处理页面，增加默认选择对愿意见修改 checked="checked"  -->
						<label class="font_size12 padding_l_30 margin_l_20"><input type="checkbox" name="saveComment" value="1" checked="checked">&nbsp;&nbsp;${ctp:i18n('collaboration.takebackConfirm.updateComment')}</label>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>