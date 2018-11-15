<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript">
    if(getCtpTop().processBar)getCtpTop().processBar.close();
    var currentUserId = "${currentUserId}";
</script>
<script type="text/javascript" src="${path}/common/form/design/formListShow.js${ctp:resSuffix()}"></script>
</head>
<body id='layout' class="comp" comp="type:'layout'">
<c:if test="${formType eq enu.Enums$FormType.processesForm}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_flowFormList'"></div>
</c:if>
<c:if test="${formType eq enu.Enums$FormType.manageInfo}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_unflowInfoFormList'"></div>
</c:if>
<c:if test="${formType eq enu.Enums$FormType.baseInfo}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_unflowBasicFormList'"></div>
</c:if>
<c:if test="${formType eq enu.Enums$FormType.planForm}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_planFormList'"></div>
</c:if>
<!-- add by lib 修改面包 -->
<c:if test="${formType eq enu.Enums$FormType.dynamicForm}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_wfdynamic'"></div>
</c:if>
<c:if test="${property == 'accountForm'}">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_formManager'"></div>
</c:if>
    <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
     <div id="toolbar"></div>

    </div>
     <c:if test = "${ property eq 'accountForm'}">
    <div class="layout_west" id="west" layout="width:240">
            <div id="tree"></div>
        </div>
     </c:if>
            <input id = "ownerId" type="hidden" name="ownerId" mytype=99 >
    <div class="layout_center" id="center" style="overflow:hidden;">
        <table class="flexme3" style="display: none" id="mytable"></table>
        <div id='grid_detail'>  
            <iframe id="viewFrame" frameborder="0" src="${path }/form/formList.do?method=helpInfo&formType=${ctp:toHTML(formType)}&property=${ctp:toHTML(property)}"  style="width: 100%;height:100%;"></iframe>
            <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'1',extensions:'xsn',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'xsn',callMethod:'callBk'">
            <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'1',extensions:'xsn',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'xsn1',callMethod:'callBk1'">
            <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'1',extensions:'pak',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'pak',callMethod:'inportForm'">
        </div>
        
     <div>
     <form id="myfrm" name="form4" method="post" action="fieldDesign.do?method=changeFormField" style="display: none">
     <input id = "matchdatavalue" type="hidden" name="matchdatavalue">
           <input id = "oldvalue" type="hidden" name="oldvalue" >
           <input id = "editvalue" type="hidden" name="editvalue">
           <input id = "oldeditvalue" type="hidden" name="oldeditvalue">
           <input id = "noequalvalue" type="hidden" name="noequalvalue">
           <input id = "addvalue" type="hidden" name="addvalue">
           <input id = "delevalue" type="hidden" name="delevalue">
            <input id = "fileId" type="hidden" name="fileId">
             <input id = "formId" type="hidden" name="formId">
                 </form></div>
    
    </div>
    <iframe id="download" style="display: none"></iframe>
    <iframe id="exportForm" style="display: none"></iframe>
 <%@ include file="formListShow.js.jsp" %>
 <%@ include file="../common/common.js.jsp" %>
 <script type="text/javascript" src="${path}/ajax.do?managerName=formListManager"></script>
 <script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=formDesignManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/template/js/template_pub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<%@include file="../../workflow/workflowDesigner_js_api.jsp"%>
</body>
</html>