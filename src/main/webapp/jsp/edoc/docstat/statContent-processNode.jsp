<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="../edocHeader.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${path}/common/all-min.css" />
	<link rel="stylesheet" href="${path}/skin/default/skin.css" />
	<style>
	    .stadic_head_height{
	        height:35px;
	    }
	    .stadic_body_top_bottom{
	    	overflow: auto;
	        bottom: 60px;
	        top: 35px;
	    }
	    .stadic_footer_height{
	        height:60px;
	    }
	</style>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/stat.js" />"></script>
</head>
<body class="h100b over_hidden page_color">
<form name="myForm" method="post" class="h100b">
<input type="hidden" id="scIdValue" value="${scIdValue}"/>
<input type="hidden" id="contentTypeId" value="${contentTypeId}"/>
	<div class="stadic_layout">
	    <div class="stadic_layout_head stadic_head_height">
	        <div class="font_bold padding_tb_5 padding_l_10"><fmt:message key="${statContentName }" /></div>
	        <div class="hr_heng"></div>
	    </div>
	    <div id="statContent" class="stadic_layout_body stadic_body_top_bottom">
			<fieldset class="margin_lr_10">
				<legend style="color:blue; margin-left:3px;">
					<input id="sendall" type="checkbox" onclick="selectall(this,'selectallsend');"/>
					<label for="sendall"><fmt:message key='edoc.stat.send.workflownode'/></label>
				</legend>
				<div id="selectallsend">
				<table>
					<c:forEach items="${sendList}" var="stat" varStatus="status">
						<c:if test="${stat.name != 'niwen'}">
						<tr>
							<td class="padding_t_5 padding_l_5">
								<input id="send${status.index}" type="checkbox" value="${stat.flowPermId}_${stat.name}_${stat.label}" name="statContentId" />
								<c:if test="${stat.type=='0'}">
								<label for="send${status.index}">${stat.label}</label>
								</c:if>
								<c:if test="${stat.type=='1'}">
								<label for="send${status.index}">${stat.name}</label>
								</c:if>
							</td>
						</tr>
						</c:if>
					</c:forEach>
				</table>
				</div>
			</fieldset>
			<fieldset class="margin_t_20 margin_lr_10">
			<legend style="color:blue; margin-left:3px;">
				<input id="recall" type="checkbox" onclick="selectall(this,'selectallrec');"/>
				<label for="recall"><fmt:message key='edoc.stat.rec.workflownode'/></label>
			</legend>
			<div id="selectallrec">
				<table>
					<c:forEach items="${recList}" var="stat" varStatus="status">
						<c:if test="${stat.name != 'dengji'}">
						<tr>
							<td class="padding_t_5 padding_l_5">
								<input id="rec${status.index}" type="checkbox" value="${stat.flowPermId}_${stat.name}_${stat.label}" name="statContentId" />
								<c:if test="${stat.type=='0'}">
								<label for="rec${status.index}">${stat.label}</label>
								</c:if>
								<c:if test="${stat.type=='1'}">
								<label for="rec${status.index}">${stat.name}</label>
								</c:if>
							</td>
						</tr>
						</c:if>
					</c:forEach>
				</table>
			</div>
			</fieldset>
	    </div>
	    <div class="stadic_layout_footer stadic_footer_height">
	        <div class="padding_l_20 padding_tb_5 border_t">
	        	<input id="selectall2" type="checkbox" onclick="selectall(this,'statContent');"/><label class="margin_l_5" for="selectall2"><fmt:message key='edoc.stat.select.selectall'/></label>
	        </div>
	        <div class="hr_heng"></div>
	        <div class="align_right padding_r_10 margin_t_5">
				<input type="button"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize" onclick="setStatContent();" />
				<input type="button" onclick="commonDialogClose('win123');" value="关闭" class="button-default-2">
			</div>
	    </div>
	</div>
</form>
</body>
</html>