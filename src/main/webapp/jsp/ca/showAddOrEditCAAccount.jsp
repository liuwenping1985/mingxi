<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="caaccountHeader.jsp"%>
<script type="text/javascript">
function check(){
    //var loginName = document.getElementById("loginName").value;
    var grantedMemberId = document.getElementById("grantedMemberId").value;
    var keyNum = document.getElementById("keyNum").value;
    if(grantedMemberId.trim() == ""){
        alert("<fmt:message key="ca.loginName.label" /><fmt:message key="ca.cannotbenull" />");
        return false;
    }
    if(keyNum.trim() == ""){
        alert("<fmt:message key="ca.keyNum.label" /><fmt:message key="ca.cannotbenull" />");
        return false;
    }
  
    var keys=document.getElementById("keyNum").value;
    if(keys.length>120){
    	alert('CA Key唯一标识 最大只能输入120位');
    	return false;
    }
    return true;
}


function promptAddSuccess(){
    alert("<fmt:message key="ca.prompt.addaccount.success" />");
    parent.listFrame.location.href = "${caacountURL}?method=listCAAccount";
}

function promptEditSuccess(){
    alert("<fmt:message key="ca.prompt.editaccount.success" />");
    parent.listFrame.location.href = "${caacountURL}?method=listCAAccount";
}

function promptCannotFindMember(){
    alert("<fmt:message key="ca.prompt.cannotfindmember" />");
}

function promptAccountExist(){
    alert("<fmt:message key="ca.prompt.promptAccountExist" />");
}

function promptKeyNumExist(){
    alert("<fmt:message key="ca.prompt.promptKeyNumExist" />");
}

function selectMemberJs(elements){
    if(elements){
        var obj1 = getNamesString(elements);
        var obj2 = getIdsString(elements,false);
        document.getElementById("memberName").value = getNamesString(elements);
        document.getElementById("grantedMemberId").value = getIdsString(elements,false);
    }
}

function checkCaEnableState(){
    var caEnable = document.getElementById("caEnable").checked;
    if(caEnable){
        document.getElementById("mobileTR").style.display = "block";
    }else{
        document.getElementById("mobileTR").style.display = "none";
    }
        
}
</script>
</head>

<c:set value="${v3x:parseElementsOfIds(aclIds, 'Member')}" var="authIds"/>
<c:set value="${v3x:showOrgEntitiesOfIds(aclIds, 'Member',  pageContext)}" var="authStr"/>
<c:if test="${readOnly == 'readonly'}">
<c:set value="disabled" var="disable"/>
</c:if>
<script type="text/javascript"></script>
<body scroll="no" style="overflow: no">
<FORM id=addOrEditCAAccountForm name="addOrEditCAAccountForm"
    onsubmit="return check()"
    method=post
    action="${caacountURL}?method=addOrEditCAAccount"
    target="addOrEditCAAccountFrame">
    <input type="hidden" id="operationType" name="operationType" value="${operationType}"/>
<TABLE border=0 cellSpacing=0 cellPadding=0 width="100%" align=center
    height="100%">
    <TBODY>
        <TR align=middle>
            <TD class=detail-top height=8>
            <TABLE border=0 cellSpacing=0 cellPadding=0 width="100%" align=center>
                <TBODY>
                    <TR align=middle>
                        <TD class=detail-top><IMG class=cursor-hand
                            onclick="previewFrame('Up')" border=0
                            src="/seeyon/common/images/button.preview.up.gif" height=10><IMG
                            class=cursor-hand onclick="previewFrame('Down')" border=0
                            src="/seeyon/common/images/button.preview.down.gif" height=10></TD>
                    </TR>
                </TBODY>
            </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>
            <DIV class=scrollList><INPUT id=depsPathStr type=hidden>
            <TABLE border=0 cellSpacing=0 cellPadding=0 width="100%" align=center
                height="96%">
                <TBODY>
                    <TR>
                        <TD class=categorySetTitle height=28 colSpan=2><FONT
                            color=red>*</FONT>为必填项</TD>
                    </TR>
                    <TR vAlign=top>
                        <TD width="50%">
                        <FIELDSET
                            style="BORDER-BOTTOM: 0px; BORDER-LEFT: 0px; WIDTH: 95%; BORDER-TOP: 0px; BORDER-RIGHT: 0px"
                            align=center>
                        <TABLE border=0 cellSpacing=0 cellPadding=0 width="50%"
                            align=center>
                            <TBODY>
                                <TR>
                                    <TD class=bg-gray noWrap align=right>
                                    
                                    </TD>
                                    <TD><DIV class="hr-blue-font"><STRONG>
                                        <c:choose>
                                            <c:when test="${operationType == 'edit'}">
                                                <fmt:message key="ca.prompt.editaccount" />
                                            </c:when>
                                            <c:when test="${operationType == 'add'}">
                                                <fmt:message key="ca.prompt.addaccount" />
                                            </c:when>
                                        </c:choose>
                                        </STRONG></DIV>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class=bg-gray noWrap align=right>
                                    
                                    </TD>
                                    <TD>&nbsp;</TD>
                                </TR>
                                <TR>
                                    <TD class=bg-gray width="25%" noWrap>
                                        <LABEL for=member.loginName><font color="red">*</font><fmt:message key="ca.loginName.label" />:</LABEL></TD>
                                    <TD class=new-column width="75%" noWrap>
                                    <v3x:selectPeople id="selectMember" panels="Department,Admin,Outworker" selectType="Member,Admin" jsFunction="selectMemberJs(elements)" originalElements="${authIds}" maxSize="1" minSize="1"/>
                                    <input type="text" class="cursor-hand" id="memberName" 
                                    <c:if test="${operationType == 'add'}"> onclick="selectPeopleFun_selectMember()" </c:if> 
                                    <c:if test="${operationType == 'edit'}"> disabled="disabled" </c:if> value="${authStr}" ${readOnly}/>
                                    <input type="hidden" id="grantedMemberId" name="grantedMemberId" value="${aclIds}" />
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class=bg-gray width="25%" noWrap><font color="red">*</font><fmt:message key="ca.keyNum.label" />:</TD>
                                    <TD class=new-column width="75%" noWrap><INPUT id="keyNum" type="text"
                                        class="cursor-hand input-100per" value="${v3x:toHTMLWithoutSpace(keyNum)}" name="keyNum" ${readOnly}/></TD>
                                </TR>
                                <tr>
                                    <td class=bg-gray width="25%" noWrap>
                                        <font color="red">*</font><fmt:message key="level.select.state"/>:
                                    </td>
                                    <td class="new-column" nowrap="nowrap" width="75%">
                                        <label for="enabled1"><input type="radio" id="enabled1" name="caState" value="1" 
                                        ${(operationType == 'add' || (caAccount.caState))?'checked':''} ${disable} /><fmt:message key="edoc.element.enabled" bundle='${v3xEdocI18N}'/></label>
                                        <label for="enabled2"><input type="radio" id="enabled2" name="caState" value="0"
                                        ${(operationType == 'add' || (caAccount.caState))?'':'checked'} ${disable}/><fmt:message key="edoc.element.disabled" bundle='${v3xEdocI18N}'/></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="new-column" nowrap="nowrap" width="75%">
                                    <table>
                                        <tr>
                                            <td><label for="caEnable"><input type="checkbox" id="caEnable" name="caEnable" value="1" onclick="checkCaEnableState()"
                                            <c:if test="${operationType == 'add' || caAccount.caEnable}"> checked="checked" </c:if> ${disable}/><fmt:message key="ca.mustUseCA.label"/></label></td>
                                        </tr>
                                        <c:if test="${v3x:hasPlugin('m1')}">
	                                        <tr id="mobileTR" style="display: ${(operationType == 'add' || caAccount.caEnable)?'block':'none'}">
	                                            <td><label for="mobileEnable">
	                                            <input type="checkbox" id="mobileEnable" name="mobileEnable" value="1" 
	                                            ${(operationType == 'add' || caAccount.mobileEnable)? 'checked':'' } ${disable}/><fmt:message key="ca.mobile.label"/></label>
	                                            </td>
	                                        </tr>
                                        </c:if>
                                        <!--  
                                        <tr>
                                            <td><label for="checkUserEnable"><input type="checkbox" id="checkEnable" name="checkEnable" value="1" 
                                            ${(operationType == 'add' || caAccount.checkEnable)? 'checked':'' }/><fmt:message key="ca.check.loginNameAndPassWord"/></label></td>
                                        </tr>
                                        -->
                                    </table>
                                    </td>
                                </tr>
                            </TBODY>
                        </TABLE>
                        </FIELDSET>
                        </TD>
                    </TR>
                </TBODY>
            </TABLE>
            </DIV>
            </TD>
        </TR>
        <c:if test="${operationType != 'view'}">
        <TR>
            <TD class=bg-advance-bottom height=42 align=middle>
                <table>
                    <tr>
                        <td>
                            <INPUT id="submintButton" class=button-default-2 value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" type=submit>
                        </td>
                        <td>
                            <input id="cancelButton" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" type="button" onclick="window.location.href='/seeyon/common/detail.jsp'" />
                        </td>
                    </tr>
                </table>
            
            </TD>
        </TR>
        </c:if>
    </TBODY>
</TABLE>
</FORM>
<IFRAME height=0 marginHeight=0 frameBorder=0 width=0 name=addOrEditCAAccountFrame marginWidth=0 scrolling=no></IFRAME>
</body>
</html>