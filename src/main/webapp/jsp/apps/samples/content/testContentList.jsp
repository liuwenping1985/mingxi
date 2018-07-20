<%--
 $Author: wuym $
 $Rev: 960 $
 $Date:: 2012-09-17 19:24:49#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>测试内容组件列表界面</title>
<script text="text/javascript">
  $(function() {
    $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'ID',
        name : 'id',
        width : '180',
        align : 'center'
      }, {
        display : '创建者',
        name : 'createId',
        width : '180'
      }, {
        display : '模块类型',
        name : 'moduleType',
        width : '50'
      }, {
        display : '模块ID',
        name : 'moduleId',
        width : '180'
      }, {
        display : '内容类型',
        name : 'contentType',
        width : '50'
      }, {
        display : '内容ID',
        name : 'contentId',
        width : '180'
      }, {
        display : '内容标题',
        name : 'title',
        width : '80'
      }, {
        display : '内容排序',
        name : 'sort',
        width : '50'
      } ],
      click : clk,
      width : 1200,
      height : 400,
      managerName : "ctpContentManager",
      managerMethod : "testContentList"
    });

    var o = new Object();
    o.moduleType = ${moduleType};
    $("#mytable").ajaxgridLoad(o);

    function clk(data, r, c) {
        var url = _ctxPath
            + '/samples/testcontent.do?method=testContentView&moduleType='
            + data.moduleType + '&moduleId=' + data.moduleId;
        if(data.contentType == 20)
            url += '&rightId=-271875634122962803';
            //url += '&rightId=3923702095628291555';
        window.location.href = url;
    }
    $("#newContent").click(function(){
        window.location.href = _ctxPath
                  + '/samples/testcontent.do?method=testContentNew';
    });
  });
</script>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div class="classification">
        <div class="title"><a id="newContent" href="javascript:void(0)"
            class="common_button common_button_emphasize">新建</a></div>
        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable" style="display: none"></table>
            </div>
        </div>
    </div>
</body>
</html>
