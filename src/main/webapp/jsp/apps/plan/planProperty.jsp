<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="tabs" class="comp" comp="type:'tab',width:600,height:200">
    <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
            <li class="current"><a href="javascript:void(0)" tgt="tab2_div" class='last_tab'><span>${ctp:i18n('plan.summary.tab.property')}</span></a></li>
        </ul>
    </div>
    <div id='tabs2_body' class="common_tabs_body">
        <div id="tab2_div">
            <table border="0" cellpadding="0" cellspacing="0" width="100%"
                    style="margin: 10px; line-height: 30px;">
                <tr>
                    <td width="80" align="right">${ctp:i18n('plan.summary.tab.plantime')}:&nbsp;&nbsp;</td>
                    <td width="210">${ctp:formatDate(startTime) } ${ctp:i18n('plan.summary.tab.to')} ${ctp:formatDate(endTime) }</td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" align="right">${ctp:i18n('plan.summary.tab.plantype')} :&nbsp;&nbsp;</td>
                    <td width="210">${planType }</td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" style="line-height: 20px;" nowrap="nowrap"
                        align="right" valign="top"> ${ctp:i18n('plan.toolbar.button.to')} :&nbsp;&nbsp;</td>
                    <td width="210" style="overflow: auto; line-height: 20px;"
                        valign="top" title="${allRelUsers.mainTo}"> ${allRelUsers.mainTo} </td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" style="line-height: 20px;" nowrap="nowrap"
                        align="right" valign="top"> ${ctp:i18n('plan.toolbar.button.cc')} :&nbsp;&nbsp;</td>
                    <td width="210" style="overflow: auto; line-height: 20px;"
                        valign="top" title="">${allRelUsers.ccList }</td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" style="line-height: 20px;" nowrap="nowrap"
                        align="right" valign="top"> ${ctp:i18n('plan.toolbar.button.apprize')} :&nbsp;&nbsp;</td>
                    <td width="210" style="overflow: auto; line-height: 20px;" valign="top" title="">
                    ${allRelUsers.tellList }
                    </td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relateproject')} :&nbsp;&nbsp;</td>
                    <td width="210">${relProject }</td>
                    <td width="10"></td>
                </tr>
                <tr>
                    <td width="80" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relatedep')}:&nbsp;&nbsp;</td>
                    <td width="210">${relDepartment }</td>
                    <td width="10"></td>
                </tr>
            </table>
        </div>
    </div>
</div>
</body>
</html>