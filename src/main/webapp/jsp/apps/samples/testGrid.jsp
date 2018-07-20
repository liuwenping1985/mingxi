<%--
 $Author: wuym $
 $Rev: 1458 $
 $Date:: 2012-10-19 19:34:41#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>AjaxPagingGrid测试</title>
<script text="text/javascript">
  $(function() {
    $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'orgid1',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '组织名称',
        name : 'orgname',
        width : '180'
      }, {
        display : '父组织ID',
        name : 'parentid',
        width : '180',
        codecfg : "codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'"
      } ],
      click : clk,
      dblclick : dblclk,
      render : rend,
      width : 1200,
      height : 400,
      managerName : "testPagingManager",
      managerMethod : "testPaging"
    });
    //手动加载表格数据
    //var o = new Object();
    //o.orgname = "%";
    //$("#mytable").ajaxgridLoad(o);
    function rend(txt, data, r, c) {
      if (c == 1 && r == 2)
        return '<a href="test.do?method=testGrid&orgid=' + data.orgid + '">'
            + txt + '</a>';
      else
        return txt;
    }
    function clk(data, r, c) {
      $("#txt").val("clk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
    }
    function dblclk(data, r, c) {
      $("#txt").val("dblclk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
    }
    $("#btn").click(function() {
      var v = $("#mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
      alert($.toJSON(v));
    });
    
    $("#mytable2").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'orgid1',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '组织名称',
        name : 'orgname',
        width : '180'
      }, {
        display : '父组织ID',
        name : 'parentid',
        width : '180',
        codecfg : "codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'"
      } ],
      params : {
        orgname : '致远'
      },
      width : 1200,
      height : 400,
      managerName : "testPagingManager",
      managerMethod : "testPaging"
    });
    
    var o = new Object();
    o.orgname = "组织%";
    $("#mytable2").ajaxgridLoad(o);
  });
</script>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <input id="txt" type="text" size="100">
    <input id="btn" type="button" value="取数">
    <div class="classification">
        <div class="title">grid示例</div>
        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable" style="display: none"></table>
            </div>
        </div>
    </div>
    <div class="classification">
        <div class="title">grid示例</div>
        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable2" style="display: none"></table>
            </div>
        </div>
    </div>
</body>
</html>
