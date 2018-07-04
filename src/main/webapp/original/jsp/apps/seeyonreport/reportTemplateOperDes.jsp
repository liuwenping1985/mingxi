<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body>
<div style="line-height: 200%; font-size: 12px; margin-left: 50px; margin-top: 20px;">
     <div id="titleDiv" style="width: 440px; z-index: 2;">
         <span id="titlePlace" style="font-size: 26px; font-family: Verdana; font-weight: bolder; color: #6699cc; padding-right: 20px;">报表模板管理 总计 ${total } 条</span>
         <div id="Layer1" style="font-size: 12px; z-index: 1; left: 120px; top: 80px; color: #999999;">
           <ul id="descriptionPlace">
             <li>${ctp:i18n("seeyonreport.report.desc.li") }</li>
             <li>${ctp:i18n("seeyonreport.report.desc.li2") }</li>
             <li>${ctp:i18n("seeyonreport.report.desc.li3") }</li>
           </ul>
         </div>
     </div>
</div>
</body>
</html>