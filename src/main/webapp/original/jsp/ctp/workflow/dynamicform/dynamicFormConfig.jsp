<%--
  Created by IntelliJ IDEA.
  User: daiyi
  Date: 2015-12-2
  Time: 13:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html class="over_hidden h100b">
<head>
    <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
    <c:set var="isNewForm" value="${formBean.newForm }"/>
    <title>表单设置主框架页面</title>
    <c:if test="${isNewForm }">
        <style>
            .step_menu li.step_complate_last span {
                color: #d2d2d2;
            }
        </style>
    </c:if>
</head>
<body class="h100b page_color">
        <div  class="verticalMiddle" >
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_wfdynamic'"></div>
            <div class="dynamicPart dynamicFirst">
              <div class="dynamic_btn <c:if test="${isFormManager != '1'}">noborder</c:if> " <c:if test="${isFormManager == '1'}">style="cursor: pointer" onclick="javascript:window.location.href='${path}/form/formList.do?method=index&property=myForm&formType=5&_resourceCode=T05_wfdynamic'" </c:if> >
                <span class="dynamic_ico180 dynamic_make"></span>
               	<b>${ctp:i18n('common.detail.label.dynamicForm.create')}</b>
                <p>${ctp:i18n('common.detail.label.dynamicForm')}</p>
              </div>
              <div class="dynamic_info">
                 <p class="padding_t_20">${ctp:i18n('common.detail.label.dynamicForm.des1')}</p>
                 <a onclick="openCreateExp();">${ctp:i18n('dynamicForm.label.create.example')}</a><a href="${path }/form/wfdynamic.do?method=downdynamicTemplate">${ctp:i18n('dynamicForm.label.down.template')}</a>
              </div>
            </div>

            <div class="dynamicPart">
              <div class="dynamic_btn hand" onclick="javascript:window.location.href='${path}/form/formData.do?method=unflowForm&formType=5&_resourceCode=T05_wfdynamic'">
                <span class="dynamic_ico180 dynamic_edit"></span>
                <b>${ctp:i18n('common.detail.label.dynamicForm.view')}</b>
                <p>${ctp:i18n('common.detail.label.dynamicForm')}</p>
              </div>
              <div class="dynamic_info">
                 <p class="padding_t_30">${ctp:i18n('common.detail.label.dynamicForm.des2')}</p>
              </div>
            </div>
            

            <div class="dynamicPart dynamicLast">
              <div class="dynamic_btn <c:if test="${isFormManager != '1'}">noborder</c:if> " <c:if test="${isFormManager == '1'}">style="cursor: pointer" onclick="javascript:window.location.href='${path}/form/formList.do?method=index&property=myForm&formType=1&_resourceCode=T05_flowFormList'"</c:if> >
                <span class="dynamic_ico180 dynamic_makewf"></span>
                <b>${ctp:i18n('common.detail.label.createflowForm')}</b>
              </div>
              <div class="dynamic_info">
                 <p class="padding_t_30">${ctp:i18n('common.detail.label.dynamicForm.des3')}</p>
              </div>
            </div>
        </div>

        

<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/form/design/top.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	function openCreateExp(){
		dialog = $
		.dialog({
			width : 1100,
			height : 500,
			targetWindow : getCtpTop(),
			transParams : window,
			url : _ctxPath + "/form/wfdynamic.do?method=bulidExampleDoc",
			title : "示例查看",// 数据拷贝设置
			buttons : [{
						text : $.i18n('common.button.cancel.label'),
						id : "exit",
						handler : function() {
							dialog.close();
						}
					} ]
		});
	}
</script>
</body>
</html>
