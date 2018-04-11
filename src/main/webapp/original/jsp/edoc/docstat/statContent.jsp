<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="../edocHeader.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><fmt:message key="edoc.stat.content.select"/></title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	<link rel="stylesheet" href="${path}/common/all-min.css" />
	<link rel="stylesheet" href="${path}/skin/default/skin.css" />
	<style>
	    .stadic_head_height{
	        height:25px;
	    }
	    .stadic_body_top_bottom{
	    	overflow: auto;
	        bottom: 70px;
	        top: 25px;
	    }
	    .stadic_footer_height{
	        height:70px;
	    }
	</style>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/stat.js" />"></script>
</head>
<body class="h100b over_hidden bg_color_gray">
<form class="h100b" name="myForm" action="${pageContext.request.contextPath}/edocController.do?method=saveCustomerTypes&edocType=${edocType}" method="post">
   <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
			<input type="hidden" id="scIdValue" value="${scIdValue}"/>
			<input type="hidden" id="contentTypeId" value="${contentTypeId}"/>
            <div class="margin_l_10 margin_t_10 padding_b_10 font_bold">
				<fmt:message key="${statContentName }" />
			</div>
			<div class="hr_heng"></div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom">
            <table id="statContent" border="0" cellspacing="0" cellpadding="0" class="margin_t_5">
			<c:forEach items="${statList}" var="stat" varStatus="status">
				<tr>
					<td>
						<div class="padding_l_10 padding_b_5">
						<c:if test="${!empty statList }">
							<input id="statc${status.index}" type="checkbox" value="${stat.statContentId}_${v3x:toHTML(stat.statContentName)}" name="statContentId" />
							<c:choose>
						  	<c:when test="${contentTypeId == 1}">
						  		<label for="statc${status.index}">${v3x:toHTML(stat.statContentName)}</label>
						  	</c:when>
						  	<c:when test="${contentTypeId == 3}">
						  		<label for="statc${status.index}"><fmt:message key='${v3x:toHTML(stat.statContentName)}'/></label>
						  	</c:when>
						  	</c:choose>
					  	</c:if>
					  	</div>
					</td>
				</tr>
			</c:forEach>
			</table>
        </div>
        <div class="stadic_layout_footer stadic_footer_height">
        	<div class="padding_l_10 padding_tb_5 border_t">
        		<label for="selectall2" class="margin_r_10 hand"><input id="selectall2" type="checkbox" class="radio_com" onclick="selectall(this,'statContent');"/><fmt:message key='edoc.stat.select.selectall'/></label>
        	</div>
			<div class="hr_heng"></div>
            <!-- 确定/取消 -->
			<div class="padding_t_5 padding_r_10 align_right">
				<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="common_button common_button_gray" onclick="setStatContent();" />
				<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" class="common_button common_button_gray" onclick="javascript:commonDialogClose('win123');" />
			</div>
        </div>
    </div>
</form>
</body>
</html>