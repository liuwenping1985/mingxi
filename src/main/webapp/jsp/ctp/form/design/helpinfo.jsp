<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('form.formcreate.label')}</title>
</head>
<body id="layout">
<div class="color_gray margin_l_20">
    <div class="clearfix margin_t_20 margin_b_10">
        <h2 class="left margin_0">${title}</h2>
        <div class="font_size12 left margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('form.helpinfo.total')} <span id= "sizespan" class="font_bold color_black">${size}</span>${ctp:i18n('form.helpinfo.article')}</div>
        </div>
    </div>
    <div class="line_height160 font_size14">
    <c:if test="${formtype eq enu.Enums$FormType.processesForm}">
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform1')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform2')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform3')}</p>
         <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform4')}</p>
          <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform5')}</p>
           <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform6')}</p>
             <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform8')}</p>
        </c:if>
         <c:if test="${formtype eq enu.Enums$FormType.manageInfo}">
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.manageInfo1')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform3')}</p>
         <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform4')}</p>
          <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform5')}</p>
           <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform6')}</p>
             <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform8')}</p>
        </c:if>
          <c:if test="${formtype eq enu.Enums$FormType.baseInfo}">
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.baseInfo1')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform3')}</p>
         <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform4')}</p>
          <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform5')}</p>
           <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform6')}</p>
             <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.processesform8')}</p>
        </c:if>
        <c:if test="${formtype eq enu.Enums$FormType.planForm}">
        <p>${ctp:i18n('plan.form.helpinfo.planform1')}</p>
        <p>${ctp:i18n('plan.form.helpinfo.planform2')}</p>
         <p> ${ctp:i18n('plan.form.helpinfo.planform3')}</p>
          <p> ${ctp:i18n('plan.form.helpinfo.planform4')}</p>
           <p> ${ctp:i18n('plan.form.helpinfo.planform5')}</p>
            <p>${ctp:i18n('plan.form.helpinfo.planform6')}</p>
        </c:if>
    </div>
</div>
</body>
</html>
