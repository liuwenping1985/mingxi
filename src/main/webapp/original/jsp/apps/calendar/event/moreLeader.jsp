<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/memberMenu.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
    //document.oncontextmenu=function(){event.returnValue=false};//屏蔽右键
    ${alertString}
</script>
<c:set var="hasSendColl" value="${v3x:hasNewCollaboration()}"/>
<c:set var="hasSendMsg" value="${v3x:hasPlugin('uc')}"/>
<c:set var="hasSendMail" value="${v3x:hasNewMail()}"/>
</head>
<body scroll="auto" style="padding-left: 5px;">
<div class="scrollList">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <c:if test="${!empty leaderlist}">
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <c:forEach items="${leaderlist}" var="ll" varStatus="ordinal">
                                    <td width="25%" class="cursor-hand1 sorts">
                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top" width="52">
                                                    <div style="border: 1px #CCC solid; width: 52px; height: 52px; text-align: center; background-color: #FFF;">
                                                        <div style="width: 52px; height: 52px; text-align: center;">
                                                            <a class="defaulttitlecss" href="<html:link renderURL='/calendar/calEvent.do?method=calEventViewforLeader&tagetid=${ll.relateMemberId } ' psml='default-page.psml'/>" target="_self">
                                                            <img class="left padding" width="52" height="52" src="${v3x:avatarImageUrl(ll.relateMemberId)}" border="0"/>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5" >
                                                                    <a class="defaulttitlecss" href="${pageContext.request.contextPath }/calendar/calEvent.do?method=calEventViewforLeader&tagetid=${ll.relateMemberId } " target="_self">
                                                                        ${v3x:getLimitLengthString(ll.relateMemberName,14,"...")}
                                                                    </a>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <span class="margin_l_5"><fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>:<label title="${v3x:showDepartmentFullPath((v3x:getMember(ll.relateMemberId)).orgDepartmentId)}">${v3x:getLimitLengthString(v3x:showDepartmentFullPath((v3x:getMember(ll.relateMemberId)).orgDepartmentId),16,"...")}</label></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td title="${ll.relateMemberTel}">
                                                               <span class="margin_l_5"><fmt:message key="relate.memberinfo.tel"/>${v3x:getLimitLengthString(ll.relateMemberTel,13,"...")}</span> 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <span class="margin_l_5"><fmt:message key="relate.memberinfo.handphone3"/>${ll.relateMemberHandSet}</span> 
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                                    <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                                </c:forEach>
                                <c:if test="${i !=0}">                  
                                <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                                    <td class="cursor-hand1 sorts" width="25%">&nbsp;</td>
                                </c:forTokens>
                                </c:if>
                            </tr>
                        </table>
                    </td>
                </tr>
                </c:if>
            </table>
        </td>
    </tr>
</table>
</div>
<div id="memberMenuDIV" onMouseOver="divOver()" onMouseOut="divLeave()" style="width:82px; height:80px; padding-left:5px; border:#ccc 1px solid; background-color:#fff; display:none; position:absolute; line-height:20px;"></div>
</body>
</html>