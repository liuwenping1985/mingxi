<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<style type="text/css">
.stadic_left {
  float: left;
  width: 550px;
  height: 100%;
  position: absolute;
  z-index: 300;
}

.stadic_right {
  float: right;
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: 100;
}

.stadic_right .stadic_content {
  margin-left: 555px;
  height: 100%;
}
</style>
<%@ include file="linkFrame.js.jsp" %>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_left">
            <form id="searchForm" name="searchForm" method="post" action="${path}/form/bizMap.do?method=linkTree&linkType=${ctp:toHTML(param.linkType)}&layoutType=${ctp:toHTML(param.layoutType)}" target="tree_iframe">
                <input type="hidden" id="searchType" name="searchType" value="" />
                <input type="hidden" id="condition" name="condition" value="" />
                <input type="hidden" id="textfield" name="textfield" value="" />
            </form>
            <table width="100%" height="465" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td height="100%">
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td height="30" align="right">
                                    <c:if test="${bizMapLinkType.supportedSearchType eq '2'}">
                                        <label for="user" class="hand margin_l_10 font_size12">
                                            <input type="radio" id="user" name="templateOption" value="user" onclick="linkSearch('user', '', '')" />
                                            <span class="margin_l_5">${ctp:i18n("bizconfig.create.my")}</span>
                                        </label>
                                    </c:if>
                                    <label for="admin" class="hand margin_l_10 font_size12">
                                        <input type="radio" id="admin" name="templateOption" value="admin" onclick="linkSearch('admin', '', '')" />
                                        <span class="margin_l_5">${ctp:i18n("bizconfig.create.all")}</span>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td id="tree_td" height="100%" valign="top">
                                    <div id="tree_div" style="width: 100%; height: 100%; padding: 5px;">
                                        <iframe id="tree_iframe" width="100%" height="100%" frameborder="0" class="border_all"></iframe>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="stadic_right">
            <div class="stadic_content">
                <div class="left margin_l_10" style="width: 40px; height: 100%;">
                    <p id="columnRight" style="margin-top: 220px;">
                        <span class="ico16 select_selected" onclick="selectToRight()"></span>
                    </p>
                    <br>
                    <p id="columnLeft">
                        <span class="ico16 select_unselect" onclick="removeToLeft()"></span>
                    </p>
                </div>
                <div class="left" style="width: 388px; height: 465px;">
                    <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td height="35">
                                <c:if test="${bizMapLinkType.supportedShowType eq '2'}">
                                    <label for="view" class="hand margin_l_10 font_size12">
                                        <input type="radio" id="view" name="linkShowType" value="0" checked="checked" />
                                        <span class="margin_l_5">${ctp:i18n("form.bizmap.link.open.new.label")}</span>
                                    </label>
                                    <label for="list" class="hand margin_l_10 font_size12">
                                        <input type="radio" id="list" name="linkShowType" value="1" />
                                        <span class="margin_l_5">${ctp:i18n("form.bizmap.link.open.list.label")}</span>
                                    </label>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <td height="100%" valign="top">
                                <div id="domain2" class="left border_all" style="width: 100%; height: 100%;">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>