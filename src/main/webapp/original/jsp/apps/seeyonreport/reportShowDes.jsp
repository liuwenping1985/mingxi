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
      <span id="titlePlace"
        style="font-size: 26px; font-family: Verdana; font-weight: bolder; color: #6699cc; padding-right: 20px;">
        ${ctp:i18n_1('seeyonreport.report.total.num.lable',total)}
        </span>
      <div id="Layer1" style="font-size: 12px; z-index: 1; left: 120px; top: 80px; color: #999999;">
        <ul id="descriptionPlace">
        <!-- 选择左侧报表模板查看分析结果 -->
          <li>● ${ctp:i18n('seeyonreport.report.desc.1.label')}</li>
          <!--  根据模板设计可以将分析结果打印、输出  -->
          <li>● ${ctp:i18n('seeyonreport.report.desc.2.label')}</li>
          <!-- 单击列表中的信息可以穿透到其它报表或者相应的数据 -->
          <li>● ${ctp:i18n('seeyonreport.report.desc.3.label')}</li>
        </ul>
      </div>
    </div>
  </div>
</body>
</html>