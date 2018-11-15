<%--
 $Author: xiaolin $
 $Rev: 15209 $
 $Date:: 2013-03-04 18:08:56#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title>layout</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=pageManager"></script>
<script>
  $(document).ready(function() {
    $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '空间模板名称',
        name : 'pageName',
        width : '180'
      }, {
        display : '模板类型',
        name : 'pageType',
        width : '180'
        //codecfg : "codeType:'java',codeId:'com.seeyon.ctp.portal.po.PortalSpacePage.PageTypeEnum'"
      }, {
        display : '排序号',
        name : 'sort',
        width : '60'
      } ],
      managerName : "pageManager",
      managerMethod : "selectSpacePage",
      render : rend,
      parentId : "tableDiv",
      vChange : {
        'parentId' : 'center',
        'changeTar' : 'form_area',
        'subHeight' : 90
      }
    });
    
    function rend(txt, data, r, c) {
      if (c == 2) {
        if(txt == "0"){
          return "系统预置";
        } else if(txt == "1"){
          return "自定义";
        } else if(txt == "2"){
          return "实例化";
        }
      } else {
        return txt;
      }
    }
    var row="${row}";
    $("input[type='checkbox'][row="+row+"]").attr("checked","checked");
  });

  function OK() {
    var checkedIds = $("input:checked", $("#mytable"));
    if (checkedIds.size() == 0) {
      alert("请选择1个空间模板！");
      return null;
    } else if (checkedIds.size() > 1) {
      alert("只能选择1个空间模板！");
      return null;
    } else {
      var checkedId = $(checkedIds[0]).attr("value");
      $("#id").val(checkedId);
      $("#form_area input").attr("disabled", false);
      return new pageManager().selectSpacePageById(checkedId);
    }
  }
  
  
</script>
</head>
<body class="h100b">
    <div id="tableDiv" class="h100b">
    	<table id="mytable" style="display: none"></table>
    </div>
</body>
</html>