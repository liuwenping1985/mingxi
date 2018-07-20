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
<title>表单模板列表</title>
<script type="text/javascript">
  var retv = {};
  function OK() {
    return retv;
  }
  $(function() {
    $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '表单名称',
        name : 'name',
        width : '300',
        sortable : true,
        align : 'left'
      }, {
        display : '所属应用',
        name : 'formType',
        width : '100',
        sortable : true,
        align : 'left'
      }, {
        display : '所属人',
        name : 'ownerId',
        width : '120',
        sortable : true,
        align : 'center'
      }, {
        display : '应用绑定',
        name : 'categoryId',
        width : '150',
        sortable : true,
        align : 'left'
      }, {
        display : '状态',
        name : 'state',
        width : '100',
        sortable : true,
        align : 'left'
      }, {
        display : '标识',
        name : 'useFlag',
        width : '100',
        sortable : true,
        align : 'center'
      }, {
        display : '制作时间',
        name : 'createTime',
        width : '150',
        sortable : true,
        align : 'left'
      } ],
      managerName : "formListManager",
      managerMethod : "designFormshow",
      click : clk
    });
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    function clk(data, r, c) {
      retv = data;
    }
  });
</script>
</head>
<body>
    <div class="classification">
        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable" style="display: none"></table>
            </div>
        </div>
    </div>
</body>
</html>