<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript">
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="comp" comp="type:'breadcrumb',code:'T02_showMoveDeptframe'">
        </div>
        <div class="layout_center" layout="border:false" id="center">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
                <thead>
                    <tr>
                        <th>${ctp:i18n('group.move.dept')}</th>
                        <th>${ctp:i18n('group.moveto.account')}</th>
                        <th>${ctp:i18n('common.state.label')}</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${resultList}" var="data">
                        <tr class="erow">
                            <td width="15%" align="left" valign="top">
                                ${data.str1}
                            </td>
                            <td width="15%" align="left" valign="top">
                                ${data.str2}
                            </td>
                            <td align="left" valign="top">
                                <c:if test="${fn:length(data.validateList)==0}">
                                    ${ctp:i18n('organization.ok')}
                                </c:if>
                                <c:if test="${fn:length(data.validateList)!=0}">
                                    ${ctp:i18n('organization.no')}
                                </c:if>
                                <c:forEach items="${data.validateList}" var="item">
                                    <c:if test="${item[0] == '1'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.1.js', item[1], item[2])}
                                    </c:if>
                                    <c:if test="${item[0] == '2'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.2.js', item[1], item[2])}
                                    </c:if>
                                    <c:if test="${item[0] == '3'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.3.js', item[1], item[2])}
                                    </c:if>
                                    <c:if test="${item[0] == '4'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.4.js', item[1], item[2])}
                                    </c:if>
                                    <c:if test="${item[0] == '5'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.5.js', item[1], item[2])}
                                    </c:if>
                                    <c:if test="${item[0] == '6'}">
                                        <br>${ctp:i18n_2('department.move.account.validate.6.js', item[1], item[2])}
                                    </c:if>
                                    
                                </c:forEach>
                                <c:forEach items="${data.moveLogList}" var="item">
                                    <c:if test="${item[0] == '1'}">
                                        <br>${ctp:i18n_2('department.move.account.log.1.js', item[1], item[2])}
                                    </c:if>
                                </c:forEach>
                                <br>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>