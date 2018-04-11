<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager"></script>
</head>
<body>
<div style="line-height: 200%; font-size: 12px; margin-left: 50px; margin-top: 20px;">
     <div id="titleDiv" style="width: 440px; z-index: 2;">
         <c:if test="${from eq 'templateConfig' }">
             <!-- 配置模板 总计 ${ctp:toHTML(total)} 条 -->
             <span id="titlePlace" class="color_gray2" style="font-size: 26px; font-family: Verdana; font-weight: bolder;padding-right: 20px;">${ctp:i18n_1('template.templateOperDes.configTemplatesTotal',ctp:toHTML(total))}</span>
             <div id="Layer1" style="font-size: 12px; z-index: 1; left: 120px; top: 80px;" class="color_gray2">
               <ul id="descriptionPlace">
                 <!-- 单击列表标题可以进行快速排序。 -->
                 <li>● ${ctp:i18n('collaboration.listDesc.lable2')}</li>
                 <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
                 <li>● ${ctp:i18n('collaboration.listDesc.lable3')}</li>
                 <!-- 点击配置模版，可发布模版至首页。 -->
                 <li>● ${ctp:i18n('collaboration.templateOperDes.label1')}</li>
                 <!-- 点击排序设置，可自定义首页模版排列顺序 -->
                 <li>● ${ctp:i18n('collaboration.templateOperDes.label2')}</li>
               </ul>
             </div>
         </c:if>
         <c:if test="${from ne 'templateConfig' }">
             <!-- 模板管理 总计 ${ctp:toHTML(total)} 条 -->
             <span id="titlePlace" class="color_gray2" style="font-size: 26px; font-family: Verdana; font-weight: bolder;padding-right: 20px;">${ctp:i18n_1('template.templateOperDes.templateManagerTotal',ctp:toHTML(total))}</span>
             <div id="Layer1" style="font-size: 12px; z-index: 1; left: 120px; top: 80px;" class="color_gray2">
               <ul id="descriptionPlace">
                 <!-- 单击列表标题可以进行快速排序。 -->
                 <li>● ${ctp:i18n('collaboration.listDesc.lable2')}</li>
                 <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
                 <li>● ${ctp:i18n('collaboration.listDesc.lable3')}</li>
                 <!-- 勾选列表中的模板，可以进行授权、停用、启用、删除等操作。 -->
                 <li>● ${ctp:i18n('template.templateOperDes.label1')}</li>
               </ul>
             </div>
         </c:if>
       </div>               
</div>
</body>
</html>