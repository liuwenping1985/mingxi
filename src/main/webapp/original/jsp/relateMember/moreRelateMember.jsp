<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/memberMenu.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
    document.oncontextmenu=function(){event.returnValue=false};//屏蔽右键
    ${alertString}
</script>
<c:set var="hasSendColl" value="${v3x:hasPlugin('collaboration') && v3x:hasNewCollaboration()}"/>
<c:set var="hasSendMsg" value="${v3x:hasPlugin('uc')}"/>
<c:set var="hasSendMail" value="${v3x:hasPlugin('webmail') && v3x:hasNewMail()}"/>
</head>
<body scroll="auto" style="padding-left: 5px;">
<div class="scrollList">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <c:if test="${!empty leaderlist}">
                <tr><td class="sortsHead"><fmt:message key="relate.type.leader"/></td></tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <c:forEach items="${leaderlist}" var="ll" varStatus="ordinal">
                                    <td width="25%" class="cursor-hand1 sorts">
                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top" width="52">
                                                    <div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">
                                                        <div style="width: 52px; height: 52px; text-align: center;">
                                                            <a class="defaulttitlecss" href="<html:link renderURL='/relateMember.do?method=relateMemberInfo&memberId=${ll.relateMemberId }&relatedId=${ll.relatedMemberId }' psml='default-page.psml'/>" target="_parent">
                                                            <img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" class="left padding" width="52" height="52" src="${v3x:avatarImageUrl(ll.relateMemberId)}" border="0"/>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5" onMouseOver="showMemberMenu('${ll.relateMemberId}', '${ll.relateMemberName}', '${ll.relateMemberEmail}', '${hasSendColl}', '${hasSendMsg}', '${hasSendMail}', '_parent', document.getElementById('${ll.relateMemberId}Img'))" onMouseOut="leave()">
                                                                    <a class="defaulttitlecss" href="${pageContext.request.contextPath }/relateMember.do?method=relateMemberInfo&memberId=${ll.relateMemberId }&relatedId=${ll.relatedMemberId }" target="_parent">
                                                                        ${v3x:getLimitLengthString(ll.relateMemberName,14,"...")}<img id="${ll.relateMemberId}Img" src="<c:url value="/apps_res/peoplerelate/images/button.gif"/>" border="0">
                                                                    </a>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <c:set value="${v3x:showDepartmentFullPath((v3x:getMember(ll.relateMemberId)).orgDepartmentId)}" var="deptName" />
                                                               <span class="margin_l_5"><fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>:<label title="${deptName}">${v3x:toHTML(v3x:getLimitLengthString(deptName,16,"..."))}</label></span>
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
                
                <c:if test="${! empty juniorlist}">
                <tr><td class="sortsHead"><fmt:message key="relate.type.junior"/></td></tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <c:forEach items="${juniorlist}" var="jl" varStatus="ordinal">
                                    <td width="25%" class="cursor-hand1 sorts">
                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top" width="52">
                                                    <div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">
                                                        <div style="width: 52px; height: 52px; text-align: center;">
                                                            <a class="defaulttitlecss" href="<html:link renderURL='/relateMember.do?method=relateMemberInfo&memberId=${jl.relateMemberId }&relatedId=${jl.relatedMemberId }' psml='default-page.psml'/>" target="_parent">
																<img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" class="left padding" width="52" height="52" src="${v3x:avatarImageUrl(jl.relateMemberId)}" border="0"/>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5" onMouseOver="showMemberMenu('${jl.relateMemberId}', '${jl.relateMemberName}', '${jl.relateMemberEmail}', '${hasSendColl}', '${hasSendMsg}', '${hasSendMail}', '_parent', document.getElementById('${jl.relateMemberId}Img'))" onMouseOut="leave()">
                                                                    <a class="defaulttitlecss" href="${pageContext.request.contextPath}/relateMember.do?method=relateMemberInfo&memberId=${jl.relateMemberId }&relatedId=${jl.relatedMemberId }" target="_parent">
                                                                        ${v3x:getLimitLengthString(jl.relateMemberName,14,"...")}<img id="${jl.relateMemberId}Img" src="<c:url value="/apps_res/peoplerelate/images/button.gif"/>" border="0">
                                                                    </a>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <c:set value="${v3x:showDepartmentFullPath((v3x:getMember(jl.relateMemberId)).orgDepartmentId)}" var="deptName" />
                                                               <span class="margin_l_5"><fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>:<label title="${deptName}">${v3x:toHTML(v3x:getLimitLengthString(deptName,16,"..."))}</label></span> 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td title="${jl.relateMemberTel}">
                                                                <span class="margin_l_5"><fmt:message key="relate.memberinfo.tel"/>${v3x:getLimitLengthString(jl.relateMemberTel,13,"...")}</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                              <span class="margin_l_5"><fmt:message key="relate.memberinfo.handphone3"/>${jl.relateMemberHandSet}</span>  
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
                
                <c:if test="${! empty assistantlist}">
                <tr><td class="sortsHead"><fmt:message key="relate.type.assistant"/></td></tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <c:forEach items="${assistantlist}" var="al" varStatus="ordinal">
                                    <td width="25%" class="cursor-hand1 sorts">
                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top" width="52">
                                                    <div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">
                                                        <div style="width: 52px; height: 52px; text-align: center;">
                                                            <a class="defaulttitlecss" href="<html:link renderURL='/relateMember.do?method=relateMemberInfo&memberId=${al.relateMemberId }&relatedId=${al.relatedMemberId }' psml='default-page.psml'/>" target="_parent">
                                                            <img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" class="left padding" width="52" height="52" src="${v3x:avatarImageUrl(al.relateMemberId)}" border="0"/>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5" onMouseOver="showMemberMenu('${al.relateMemberId}', '${al.relateMemberName}', '${al.relateMemberEmail}', '${hasSendColl}', '${hasSendMsg}', '${hasSendMail}', '_parent', document.getElementById('${al.relateMemberId}Img'))" onMouseOut="leave()">
                                                                    <a class="defaulttitlecss" href="${pageContext.request.contextPath }/relateMember.do?method=relateMemberInfo&memberId=${al.relateMemberId }&relatedId=${al.relatedMemberId }" target="_parent">
                                                                        ${v3x:getLimitLengthString(al.relateMemberName,14,"...")}<img id="${al.relateMemberId}Img" src="<c:url value="/apps_res/peoplerelate/images/button.gif"/>" border="0">
                                                                    </a>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <c:set value="${v3x:showDepartmentFullPath((v3x:getMember(al.relateMemberId)).orgDepartmentId)}" var="deptName" />
                                                                <span class="margin_l_5"><fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>:<label title="${deptName}">${v3x:toHTML(v3x:getLimitLengthString(deptName,16,"..."))}</label></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td title="${al.relateMemberTel}">
                                                                <span class="margin_l_5"><fmt:message key="relate.memberinfo.tel"/>${v3x:getLimitLengthString(al.relateMemberTel,13,"...")}</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5"><fmt:message key="relate.memberinfo.handphone3"/>${al.relateMemberHandSet}</span>
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
                
                <c:if test="${! empty confrerelist}">
                <tr><td class="sortsHead"><fmt:message key="relate.type.confrere"/></td></tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <c:forEach items="${confrerelist}" var="cl" varStatus="ordinal">
                                    <td width="25%" class="cursor-hand1 sorts">
                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top" width="52">
                                                    <div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">
                                                        <div style="width: 52px; height: 52px; text-align: center;">
                                                            <a class="defaulttitlecss" href="${pageContext.request.contextPath }/relateMember.do?method=relateMemberInfo&memberId=${cl.relateMemberId }&relatedId=${cl.relatedMemberId }" target="_parent">
                                                                <img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" class="left padding" width="52" height="52" src="${v3x:avatarImageUrl(cl.relateMemberId)}" border="0"/>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <span class="margin_l_5" onMouseOver="showMemberMenu('${cl.relateMemberId}', '${cl.relateMemberName}', '${cl.relateMemberEmail}', '${hasSendColl}', '${hasSendMsg}', '${hasSendMail}', '_parent', document.getElementById('${cl.relateMemberId}Img'))" onMouseOut="leave()">
                                                                    <a class="defaulttitlecss" href="${pageContext.request.contextPath }/relateMember.do?method=relateMemberInfo&memberId=${cl.relateMemberId }&relatedId=${cl.relatedMemberId }" target="_parent">
                                                                        ${v3x:getLimitLengthString(cl.relateMemberName,14,"...")}<img id="${cl.relateMemberId}Img" src="<c:url value="/apps_res/peoplerelate/images/button.gif"/>" border="0">
                                                                    </a>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <c:set value="${v3x:showDepartmentFullPath((v3x:getMember(cl.relateMemberId)).orgDepartmentId)}" var="deptName" />
                                                               <span class="margin_l_5"><fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>:<label title="${deptName}">${v3x:toHTML(v3x:getLimitLengthString(deptName,16,"..."))}</label></span> 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td title="${cl.relateMemberTel}">
                                                               <span class="margin_l_5"><fmt:message key="relate.memberinfo.tel"/>${v3x:getLimitLengthString(cl.relateMemberTel,13,"...")}</span> 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               <span class="margin_l_5"><fmt:message key="relate.memberinfo.handphone3"/>${cl.relateMemberHandSet}</span> 
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