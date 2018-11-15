<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <div id="tabs2" class="comp" comp="type:'tab',width:300,height:1,parentId:'center',showTabIndex:${index }">
                <div id="tabs2_head" class="common_tabs clearfix">
                    <ul class="left">
                        <li ${param.type eq "flow" ? "class='current'" : "" }><a id="btn1" href="javascript:formFlow()" tgt="formFlowFrame"><span>${ctp:i18n('formsection.config.column.category.formflow') }</span></a></li>
                        <li ${param.type eq "query" ? "class='current'" : "" }><a id="btn2" href="javascript:formSearch()" tgt="formFlowFrame"><span>${ctp:i18n('menu.formquery.label') }</span></a></li>
                        <li ${param.type eq "statistic" ? "class='current'" : "" }><a id="btn3" href="javascript:formStatistics()" tgt="formFlowFrame"><span>${ctp:i18n('menu.formstat.label') }</span></a></li>
                    </ul>
                </div>
                <div id='tabs2_body' class="common_tabs_body border_all">
                    <iframe id="formFlowFrame"width="100%" height="100%" border="0" frameBorder="no" src=""></iframe>
                </div>
                <div id="functionDIV" class="link_box clearfix" style="text-align: right;z-index: 100;position: absolute;width: 400px;top: 2px;cursor: pointer;right: 10px;">
                    <a onClick="javascript:showTemplate();">[${ctp:i18n('formsection.infocenter.biztemplate') }]</a>
                    <c:if test="${isCreater }">
                    <a onClick="javascript:changeConfig();">[${ctp:i18n('formsection.infocenter.editconfig') }]</a>
                    <c:if test="${section.sectionType eq 1 or section.sectionType eq 2 }">
                    <a id="cancelMount" onClick="javascript:cancelMount();">[${ctp:i18n('formsection.infocenter.cancelconfig') }]</a>
                    </c:if>
                    </c:if>
                    <a onClick="getCtpTop().back();">[${ctp:i18n('formsection.infocenter.baktohomepage') }]</a>
                </div>
            </div>
        </div>
    </div>
   <%@ include file="formSectionMessageCenter.js.jsp" %>
</body>
</html>