<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
    <style type="text/css">
        .stadic_body_top_bottom { bottom: 0px; top: 0px; }
    </style>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/chooseProject.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
    <!-- 指定回退再处理的流转方式 -->
    <div class="stadic_layout_body stadic_body_top_bottom border_t page_color">
    		<input type="hidden" name="id" value="id" value="" >
            <table align="center" class="margin_t_10 font_size12">
            	<tr>
                <td>查询:</td>
            		<td>
                  <div class="common_txtbox_wrap">
            		    <input type="text" onkeyup="fnSearch();" name="search" id="search"/>
                 </div>
            		</td>
            	</tr>
                <tr>
                    <td colspan="2">
                        ${ctp:i18n('permission.operation.wait.choose')}<%--候选操作 --%><br />
                        <select id="reserve" name="reserve" multiple="multiple" class="margin_t_10" 
                            style="width: 220px; height: 380px;">
                            <c:forEach items="${pos}" var="project">
                                <option value="${project.id}" title="${ctp:toHTML(project.projectName)}">${ctp:toHTML(project.projectName)}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 select_selected" id="toRight"></em><br />
                        <em class="ico16 select_unselect" id="toLeft"></em>
                    </td>
                    <td>
                        ${ctp:i18n('permission.operation.check.choose')}<%--选中操作 --%><br />
                        <select id="selected" name="selected" multiple="multiple" class="margin_t_10" 
                            style="width: 220px; height: 380px;">
                            <c:forEach items="${existData}" var="project">
                                <option value="${project.id}" title="${ctp:toHTML(project.projectName)}">${ctp:toHTML(project.projectName)}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 sort_up" id="toUp"></em><br />
                        <em class="ico16 sort_down" id="toDown"></em>
                    </td>
                </tr>
            </table>
        </div>
</body>
</html>
