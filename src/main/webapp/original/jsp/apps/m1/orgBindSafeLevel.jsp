<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@include file="./orgBindSafeLevel_js.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>org bind num</title>

<script type="text/javascript">

</script>

</head>

<body>
<div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" ></div>
        <div class="layout_north" layout="height:40,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
    
	    <div id="center"  class="layout_center" layout="border:true">
		    <form id="form1" action="<c:url value='/m1/mClientBindController.do'/>?method=setSafeLevel" method="post">
				<input type="hidden" id="entityId" name="entityId" value="<c:out value='${entityId}'/>" />
				</br>
				</br>
				<fieldset>
					<legend><font>${ctp:i18n("m1.bind.safelevel.label")}</font></legend>
					<table>
						<tr></tr>
						<tr></tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("m1.bind.high.safelevel")}:</td>
							<td>
								<textarea id = "highSafeList" value = "" readonly="readonly" disabled="disabled" rows="5" cols="60"  style="color:gray;overflow-y:auto">${entityName}</textarea>
								<br/>
								<br/>
								<span>${ctp:i18n("m1.bind.safeLevel.label")}</span>
							</td>
						</tr>
					</table>
				</fieldset>
			</form>
	    <div id="err_div">
			<c:if test="${errMsg != null}">
				<fmt:message key="${errMsg.key}" bundle="${mobileManageBundle}" >
					<c:forEach items="${errMsg.vars}" var="avar"><fmt:param value="${avar}"></fmt:param></c:forEach>
				</fmt:message>
			</c:if>
		</div>
		<div id="btnArea" class="stadic_layout_footer">
                 <div id="button_area" align="center" class="page_color button_container border_t padding_t_5" style="height:35px;">
                     <table  >
                         <tbody>
                             <tr>
                                 <td >
                                     <a href="javascript:void(0)" id="btnok"
                                         class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                     <a href="javascript:void(0)" id="btncancel"
                                         class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                                 </td>
                             </tr>
                         </tbody>
                     </table>
                 </div>
			 </div>
		</div>
	</div>
</body>
</html>