<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<style>
.stadic_head_height {
  height: 10px;
}

.stadic_body_top_bottom {
  top: 10px;
  bottom: 0px;
  overflow: hidden;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=bizMapManager"></script>
<script type="text/javascript">
  var backLinkType = "${linkType}";
  var backLinkShowType = "${linkShowType}";
  var backName = "${ctp:toHTML(formApp.name)}";
  var backSourceType = "${formApp.sourceType}";
  var backSourceValue = "${formApp.sourceValue}";
  var backFormAppmainId = "${formApp.formAppmainId}";
  
  function OK() {
    var linkType = $("#tabs_head").find("li.current").attr("id");
    var iframe = $("#" + linkType + "_iframe")[0].contentWindow;
    if (linkType == "doc" || linkType == "pubInfo") {
      iframe.getSelectedData();
    }
    var obj = {};
    if (linkType != "doc") {
      if (iframe.$("#_linkType").length > 0 && iframe.$("#_linkType").val() != "") {
        obj.linkType = iframe.$("#_linkType").val();//链接分类：表单模板...
        if (iframe.$("input:radio[name='linkShowType']").length > 0) {
            obj.linkShowType = iframe.$("input:radio[name='linkShowType']:checked").val();//链接显示方式
        } else {
            obj.linkShowType = iframe.$("#_linkShowType").val();//链接显示方式
        }
        obj.sourceType = iframe.$("#_sourceType").val();//链接类型：根，分类，模板，具体某个公告...
        obj.sourceValue = iframe.$("#_sourceValue").val();//分类ID，模板ID...
        obj.formAppmainId = iframe.$("#_formAppmainId").val();//表单ID
      }
    } else {//老框架，文档中心
      if (iframe._linkType != "") {
        obj.linkType = iframe._linkType;
        obj.linkShowType = iframe._linkShowType;
        obj.sourceType = iframe._sourceType;
        obj.sourceValue = iframe._sourceValue;
        obj.formAppmainId = "";
      }
    }
    return obj;
  }
</script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height"></div>
        <div id="layout_body" class="stadic_layout_body stadic_body_top_bottom">
            <div id="tabs" class="comp" comp="type:'tab',parentId:'layout_body',refreashTab:'true',showTabIndex:'${showTabIndex}'">
                <div id="tabs_head" class="common_tabs clearfix">
                    <ul class="left">
                        <c:forEach items="${linkTypes}" var="linkType">
                            <li id="${linkType.id}" class="${linkType.sort == '1' ? 'current' : ''}"><a hidefocus="true" href="javascript:void(0)" tgt="${linkType.id}_iframe" title="${linkType.name}"><span>${linkType.name}</span></a></li>
                        </c:forEach>
                    </ul>
                </div>
                <div id="tabs_body" class="common_tabs_body">
                    <c:forEach items="${linkTypes}" var="linkType">
                        <iframe id="${linkType.id}_iframe" class="${linkType.sort == '1' ? '' : 'hidden'}" hSrc="${path}/${linkType.url}&layoutType=${ctp:toHTML(param.layoutType)}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</body>
</html>