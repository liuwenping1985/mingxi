<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>静态布局-左右</title>
<%@include file="/WEB-INF/jsp/common/common_header.jsp"%>
<link rel="stylesheet" href="${path}/apps_res/project/css/projectSystemManager.css${ctp:resSuffix()}">
<script type="text/javascript">
	var loginAccount = "${CurrentUser.loginAccount}";
</script>
</head>
<body class="h100b over_hidden">
	<div class="comp" comp="type:'breadcrumb',code:'F02_projectSystemPage'"></div>
	<div class="stadic_layout">
		<div class="stadic_right">
			<div class="stadic_content h100">
				<!--右边内容区域-->
				<div class="stadic_layout h100b">
					<div id="toolbar" class="stadic_layout_head stadic_head_height"></div>
					<div class="stadic_layout_body stadic_body_top_bottom projectList" id="center" >
						<table id="projectList"></table>
					</div>
				</div>
			</div>
		</div>
		<div class="stadic_left">
			<div id="topButton" >
				<!--  margin_t_15 -->
				<span onclick="newProjectType();" style="cursor: pointer;" title="${ctp:i18n("project.system.projecttype.entertoadd") }">
				<span class="ico16 task_add_16 margin_l_5" 
					id="add_operea"></span>${ctp:i18n("project.system.projecttype.entertoadd") }
				</span>
			</div>
			<!--左边项目类型区域-->
			<div id="menu">
				<ul>
				</ul>
			</div>
			<div class="pageBtn">
				<span class="page_up" onclick="pageUp();"><em id="page_up" class="ico24 arrow_l_24"></em></span> 
				<span class="page_down" onclick="pageDown();"><em id="page_down" class="ico24 arrow_r_24"></em></span>
				<div class="pageBtnBottom"></div>
			</div>
		</div>
	</div>

	<!-- 新建项目类型dialog -->
	<div id="projectTypeDialog" class="hidden">
		<form action="${path}/project/project.do?method=saveProjectType"
			id="typeForm">
			<div class="form_area">
				<div class="one_row common_tabs_body color_gray2 font_size14">
					<table border="0" cellspacing="0" cellpadding="0"
						style="width: 90%;" align="center">
						<tbody>
							<tr>
								<td nowrap="nowrap" class="padding_t_15"><span
									class="color_red" >*</span> <label
									class="margin_r_10" for="text">${ctp:i18n('project.style.name')}:</label>
								</td>
							</tr>
							<tr>
								<td width="100%">
									<div class="common_txtbox_wrap">
										<input id="projectTypeId" name="projectTypeId" type="hidden">
										<input id="name" name="name" type="text" maxlength="100" class="validate" 
											validate="name:'${ctp:i18n('project.style.name')}',type:'string',notNullWithoutTrim:true,maxLength:65" />
									</div>
								</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="padding_t_15"><label
									class="margin_r_10" for="text">${ctp:i18n('project.style.describe')}:</label></td>
							</tr>
							<tr>
								<td>
									<div class="common_txtbox  clearfix">
										<textarea cols="30" rows="5" class="w100b validate" id="memo"
											validate="name:'${ctp:i18n('project.style.describe')}',type:'string',notNull:false,maxLength:85"></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</form>

	</div>
</body>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<script type="text/javascript" src="${path}/ajax.do?managerName=projectQueryManager"></script>
	<script type="text/javascript" src="${path}/apps_res/project/js/projectSystemManager.js${ctp:resSuffix()}"></script>
</html>