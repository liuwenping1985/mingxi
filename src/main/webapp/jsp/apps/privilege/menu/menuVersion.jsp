<%--
 $Author: yans $
 $Rev: 8709 $
 $Date:: 2012-12-03 14:03:07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script>
  $(function() {
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
    }
    var canonicalVersions = $afg.canonicalVersions;
    var productVersion = "${productVersion}";
    $(canonicalVersions).each(function(index, elem){
      if(elem && elem != productVersion){
        $(".common_radio_box").append("<label for=\"radio1\" class=\"margin_t_5 hand display_block\">");
        $(".common_radio_box").append("<input type=\"radio\" value=\""+elem+"\" id=\"option\" name=\"option\" class=\"radio_com\">"+elem+"</label>");
      }
    });
  });
  
  //
  function OK() {
    var frmobj = $("#myfrm").formobj().option;
    return frmobj;
  }
</script>
</head>
<body>
  <form id="myfrm">
    <div class="common_radio_box clearfix">
      <label for="radio1" class="margin_t_5 hand display_block">
      <input type="radio" value="" id="option" name="option" class="radio_com" checked="checked">${ctp:i18n('privilege.menu.systemDefault.label')}</label>
    </div>
  </form>
</body>
</html>
