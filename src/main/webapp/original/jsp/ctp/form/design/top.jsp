<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/top.js${ctp:resSuffix()}"></script>
<c:if test="${formBean.newForm }">
    <style>
        .step_menu li.step_complate_last span {
            color: #d2d2d2;
        }
    </style>
</c:if>
<form action="${path}/form/fieldDesign.do?method=formDesignSave" id="topForm"></form>
<ul id="topUl">
    <%-- 基础设置 --%>
    <li style="cursor: pointer;" class="first_step ${formBean.newForm?'':'step_complate' }" id="fieldli" step="nextStep" source="/seeyon/form/fieldDesign.do?method=baseInfo"><b> </b> <span>${ctp:i18n('form.pagesign.baseinfo.label') }</span></li>
    <%-- 操作设置 --%>
    <c:if test="${enu.Enums$FormType.planForm != formBean.formType }">
        <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="authli" step="nextStep" source="/seeyon/form/authDesign.do?method=formDesignAuth"><b> </b> <span>${ctp:i18n('form.pagesign.operconfig.label') }</span></li>
    </c:if>
    <%-- 查询设置 --%>
    <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="queryli" step="nextStep" source="/seeyon/form/queryDesign.do?method=queryIndex"><b> </b> <span>${ctp:i18n('form.pagesign.queryconfig.label') }</span></li>
    <%-- 统计设置 --%>
    <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="reportli" step="nextStep" source="/seeyon/report/reportDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.statconfig.label') }</span></li>
    <%-- 应用绑定  --%>
    <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="bindli" step="nextStep" source="/seeyon/form/bindDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.appbind.label') }</span></li>
    <%-- 触发设置 --%>
    <c:if test="${enu.Enums$FormType.planForm != formBean.formType }">
        <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="triggerli" step="nextStep" source="/seeyon/form/triggerDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.trigger.label') }</span></li>
    </c:if>
    <%-- 表单联动 --%>
    <c:if test="${enu.Enums$FormType.manageInfo == formBean.formType }">
        <li style="cursor: pointer;" class="${formBean.newForm?'':'step_complate' }" id="linkageli" step="nextStep" source="/seeyon/form/triggerDesign.do?method=linkage"><span>${ctp:i18n('form.pagesign.linkage.label') }</span></li>
    </c:if>
</ul>