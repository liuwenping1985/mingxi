<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:set value="${pageContext.request.contextPath}" var="path" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/jquery-ui.custom.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script>

    window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
    
    /**
     *内部方法，向上层页面返回参数
     */
    function _returnValue(value){

        if(transParams.popCallbackFn){//该页面被两个地方调用
            transParams.popCallbackFn(value);
        }else{
        	window.returnValue = value;
        }
    }
    
    /**
     *内部方法，关闭当前窗口
     */
    function _closeWin(flag){
    	if(flag!='' && flag=='close'){
    		_returnValue(flag);
        }
        if(transParams.popWinName){//该页面被两个地方调用
            transParams.parentWin[transParams.popWinName].close();
        }else{
            transParams.parentWin.supTypeWin.close();
        }
        
        
    }

	function returnUrl(){
		var sel = document.getElementById("enumItem");
		var str = sel.value;
		var text = sel.options[sel.options.selectedIndex].innerHTML;
		_returnValue(str);
		_closeWin();
	}
</script>
<style type="text/css">
	table{
		padding:20px 10px;
	}
	td{
		height:10%;
	}
	select{
		border:1px solid #ccc;
	}
	input[type="button"]{
		padding:4px 20px;
		font-size:12px;
		margin-right:10px;
	}
	.xl_menu{
		text-align:right;
	}
	.xl_menu>.xl_btn{
		margin-right:30px;
	}
</style>
</head>
<body bgColor="#f6f6f6">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height=80%>
			<label nowrap="nowrap" align="left" style="margin-right:10px">事项类别：</label>
		</td>
		<td>
			<select id="enumItem" name="enumItem" style="width:220px">
				<c:forEach items="${enumItemList}" var="enumItem">
					<option value="${enumItem.enumvalue}" showText="${enumItem.showvalue}">${enumItem.showvalue}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr align="center" valign="bottom">
		<td colspan="2" class="xl_menu">
			<input type="button" name="close" value="${ctp:i18n('common.button.cancel.label')}" class="xl_btn_cancel"
				onclick="_closeWin('close');" />
				<input type="button" name="Submit" value="${ctp:i18n('common.button.ok.label')}" class="xl_btn"
				onclick="returnUrl()" />
		</td>
	</tr>
</table>
</body>
</html>