<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
<title>
	<c:set value="${bean.id==null ? 'oper.new' : 'oper.edit'}" var="titleKey" />
	<fmt:message key="${titleKey}" /><fmt:message key="news.type" />
</title>
<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
   <c:if test="${!isGroup&&spaceType!=18&&spaceType!=17}">
		var onlyLoginAccount_manager=true;
		var onlyLoginAccount_auditUser=true;
	</c:if>
	var nameList = new Array();
	<c:forEach var="tname" items="${typeNameList}">
		var name = "${v3x:escapeJavascript(tname.typeName)}";
	    nameList.push(name);
	</c:forEach>
	<!--
	function myCheckForm(myform){
		if(!checkForm(myform))
			return false;
		if($('auditFlag1').checked){
		    var auditUserName= $("auditUserName")==null?"":$("auditUserName").value;
		    var auditUser= $("auditUser")==null?"":$("auditUser").value;
			if(auditUserName==null || auditUserName=='' || auditUserName.indexOf("<")==0){
				alert('<fmt:message key="error.audituser.notblank" />');
				return false;
			}
			if(auditUser=="${bean.auditUser}" && "${isAlert}"=="true"){
		        alert("审核员不在空间访问范围内，请重新选择!");
		        return false;
		    }
		}
		return isSameName();
	}
	function isSameName(){
	       var theNewName = document.getElementById("typeName");
	       for(var j = 0;j<nameList.length;j++ ){
	           if(theNewName.value.trim() == nameList[j].trim()){
	              alert(v3x.getMessage("bulletin.bulletin_notAlreay_exists"));
	              theNewName.focus();
	              return false;
	           }
	       }
	       return true;
	     } 
	function disableSub(){
		document.getElementById("submit").disabled = true;
		//getA8Top().startProc('');
		return true;
	}
  <c:if test="${isAlert}">
	  alert("审核员不在空间访问范围内，请重新选择!");
	</c:if>
	//-->
</script>
<base>
</head>
<body style="text-align:center">
<iframe id="addDeptFrame" name="addDeptFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<form action="${newsTypeURL}" method="post" target="addDeptFrame" onsubmit="return (myCheckForm(this) && disableSub())">
<input type="hidden" name="method" value="save" />
<input type="hidden" name="spaceId" value="${param.spaceId}" />
<input type="hidden" name="spacetype" value="${param.spaceType}" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="needTransfer2NewAuditor" value="${needTransfer2NewAuditor}" />
<input type="hidden" name="oldAuditorId" value="${oldAuditorId}" />
<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr align="center">
        <td height="8" class="detail-top">
            <script type="text/javascript">
            getDetailPageBreak();
        </script>
        </td>
    </tr>
    <tr>
        <td  valign="top">
           
            <div id="connect" style="width:100%; height: 210px; overflow: auto;">

                <table border="0" cellpadding="0" cellspacing="0" align="center">
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><font color="red">*</font>&nbsp;<fmt:message key="news.type.typeName" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">
                            <fmt:message key="news.type.typeName" var="_myLabel"/>
                            <fmt:message key="label.please.input" var="_myLabelDefault">
                                <fmt:param value="${_myLabel}" />
                            </fmt:message>                          
                            <c:set var="_value" value="${bean.typeName}" />                                     
                            <c:if test="${empty bean.typeName}">
                                 <c:set var="_value" value="${_myLabelDefault}" /> 
                            </c:if>                     
                            <input type="text" class="input-100per" name="typeName" id="typeName"
                                value="${v3x:toHTML(_value)}" 
                                title="${v3x:toHTML(_value)}" defaultValue="${_myLabelDefault}"
                                onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)"
                                inputName="${_myLabel}" validate="notNull,isDefaultValue"
                                maxSize="30" ${v3x:outConditionExpression(readOnly, 'disabled', '')}/>
                        </td>
                    </tr>
                    <tr class="hidden">
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.spaceType" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">
                        <c:if test="${isGroup}">
                            <label for="spaceType0">
                                    <input type="radio" name="spaceType" ${v3x:outConditionExpression(readOnly, 'disabled', '')} id="spaceType0" value="3" /><fmt:message key="news.type.spaceType.0" />
                            </label>
                        </c:if>
                            <label for="spaceType1">
                                <input type="radio" name="spaceType" ${v3x:outConditionExpression(readOnly, 'disabled', '')} id="spaceType1" value="2" /><fmt:message key="news.type.spaceType.1" />
                            </label>
                            <label for="spaceType2" style="display:none">
                                <input type="radio" name="spaceType"  ${v3x:outConditionExpression(readOnly, 'disabled', '')} id="spaceType2" value="1" /><fmt:message key="news.type.spaceType.2" />
                            </label>
                            <c:if test="${bean.id==null}">
                                <script type="text/javascript">
                                    <c:if test="${!isGroup}">
                                        $('spaceType1').checked=true;
                                        $('spaceType2').disable();
                                    </c:if>
                                    <c:if test="${isGroup}">
                                        $('spaceType0').checked=true;
                                        $('spaceType1').disable();
                                        $('spaceType2').disable();
                                    </c:if>
                                </script>
                            </c:if>
                            <c:if test="${isGroup && bean!=null and bean.spaceType=='3'}">
                                <script type="text/javascript">
                                    $('spaceType0').checked=true;
                                    $('spaceType1').disable();
                                    $('spaceType2').disable();
                                </script>
                            </c:if>
                            <c:if test="${bean!=null and bean.spaceType=='2'}">
                                <script type="text/javascript">
                                    $('spaceType1').checked=true;
                                    <c:if test="${isGroup}">
                                        $('spaceType0').disable();
                                    </c:if>
                                    $('spaceType2').disable();
                                </script>
                            </c:if>
                            <c:if test="${bean!=null and bean.spaceType=='1'}">
                                <script type="text/javascript">
                                    $('spaceType2').checked=true;
                                    <c:if test="${isGroup}">
                                        $('spaceType0').disable();
                                    </c:if>
                                    $('spaceType1').disable();
                                </script>
                            </c:if>
                        </td>
                    </tr>
                    <tr>        
                        <td class="bg-gray" width="25%" nowrap><font color="red">*</font>&nbsp;<fmt:message key="news.type.managerUsers" /><fmt:message key="label.colon" /></td>
                    <td class="new-column" width="75%" ${dis }>
                    <c:set value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" var="publishScopeValue" />
                    <c:set value="${v3x:parseElementsOfIds(bean.managerUserIds, 'Member')}" var="org"/>
                    <script type="text/javascript">
                     <!--
                     var includeElements_manager = "${v3x:parseElementsOfTypeAndId(entity)}";
                     //-->
                     </script>
                    <v3x:selectPeople id="manager" originalElements="${org}" panels="Department,Post,Level,Team" selectType="Member" jsFunction="setBulPeopleFields(elements,'managerUserIds','managerUserNames')" maxSize="50" />  
                    <fmt:message key="news.type.managerUsers" var="_myLabel"/>
                    <fmt:message key="label.please.select" var="_myLabelDefault"><fmt:param value="${_myLabel}" /></fmt:message>
                    <input type="hidden" id="managerUserIds" name="managerUserIds" value="${bean.managerUserIds}"/>
                    <input type="text" class="cursor-hand input-100per" id="managerUserNames" name="managerUserNames" readonly="true" 
                        value="<c:out value="${publishScopeValue}" default="${_myLabelDefault}" escapeXml="true" />"
                        defaultValue="${_myLabelDefault}" onfocus="checkDefSubject(this, true)"
                        onblur="checkDefSubject(this, false)" inputName="${_myLabel}" 
                        validate="notNull,isDefaultValue" ${v3x:outConditionExpression(readOnly, 'disabled', '')}
                        onclick="selectPeople('manager','managerUserIds','managerUserNames');"/>
                </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.outterFlag" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">
                            <label for="outterFlag1">
                                <input type="radio" id="outterFlag1" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="outterPermit" value="1" /><fmt:message key="common.true" bundle="${v3xCommonI18N}" />
                            </label>
                            <label for="outterFlag0">
                                <input type="radio" id="outterFlag0" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="outterPermit" value="0" /><fmt:message key="common.false" bundle="${v3xCommonI18N}" />
                            </label>
                            <script type="text/javascript">
                                setRadioValue("outterPermit","<c:if test="${bean.outterPermit}">1</c:if><c:if test="${not bean.outterPermit}">0</c:if>");
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.commentFlag" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">
                            <label for="commentFlag1">
                                <input type="radio" id="commentFlag1" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="commentPermit" value="1" /><fmt:message key="common.true" bundle="${v3xCommonI18N}" />
                            </label>
                            <label for="commentFlag0">
                                <input type="radio" id="commentFlag0" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="commentPermit" value="0" /><fmt:message key="common.false" bundle="${v3xCommonI18N}" />
                            </label>
                            <script type="text/javascript">
                                setRadioValue("commentPermit","<c:if test="${bean.commentPermit}">1</c:if><c:if test="${not bean.commentPermit}">0</c:if>");
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.auditFlag" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">
                            <label for="auditFlag1">
                                <input type="radio" id="auditFlag1" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="auditFlag" value="1" onclick="if(this.checked) {$('auditUser0').show();$('isAuditorModifyTrId').show();if(document.getElementById('connect').parentNode.clientHeight - document.getElementById('connect').clientHeight > 50){document.getElementById('connect').style.marginTop = -50 + 'px'}}"/><fmt:message key="label.audit" />
                            </label>
                            <label for="auditFlag0">
                                <input type="radio" id="auditFlag0" ${v3x:outConditionExpression(readOnly, 'disabled', '')} name="auditFlag" value="0" onclick="if(this.checked) {$('auditUser0').hide();$('isAuditorModifyTrId').hide();if(document.getElementById('connect').parentNode.clientHeight - document.getElementById('connect').clientHeight > 50){document.getElementById('connect').style.marginTop = -30 + 'px'}}"/><fmt:message key="label.noaudit" />
                            </label>
                            <script type="text/javascript">
                                setRadioValue("auditFlag","<c:if test="${bean.auditFlag}">1</c:if><c:if test="${not bean.auditFlag}">0</c:if>");
                            </script>
                            <c:if test="${hasPending || needTransfer2NewAuditor  || isAlert}">
                                <script type="text/javascript">                                 
                                    $('auditFlag0').disable();                                  
                                </script>
                            </c:if>
                        </td>
                    </tr>
                    <tr id="auditUser0">        
                        <td class="bg-gray" width="25%" nowrap><span><fmt:message key="news.type.auditUser" /><fmt:message key="label.colon" /></span></td>
	                    <td class="new-column" width="75%" ${dis }>
		                <c:if test="${hasPending and bean.auditUser!= null}">
		                    <c:set value="noEditAuditUserAlert()" var="clickEvent" />
		                </c:if> 
		                <c:if test="${!hasPending || bean.auditUser == null}">
		                    <c:set value="selectPeople('auditUser','auditUser','auditUserName')"  var="clickEvent" />
		                </c:if>
		                    <span id="auditUser1">
		                        <fmt:message key="news.type.auditUser" var="_myLabel"/>
		                        <fmt:message key="label.please.select" var="_myLabelDefault"><fmt:param value="${_myLabel}" /></fmt:message>
		                        <%-- 三元分离使得此处审核员默认显示为"审计管理员"，需要作一下调整 --%>
		                        <c:set value="${bean.auditUser ==null || bean.auditUser == 1 || bean.auditUser == 0}" var="auditDefault" />
		                        <c:set value="${auditDefault=='true' ? _myLabelDefault : v3x:showMemberName(bean.auditUser)}"  var="publishScopeValue" />
		                        <c:set value="${auditDefault=='true' ? '' : v3x:parseElementsOfIds(bean.auditUser, 'Member')}" var="org"/>
		                        <c:set var="maxSize" value="1" />
		                        <c:if test="${maxSize==null}">
		                            <c:set var="maxSize" value="" />
		                        </c:if>
		                        <script type="text/javascript">
		                         <!--
		                         var includeElements_auditUser = "${v3x:parseElementsOfTypeAndId(entity)}";
		                         //-->
		                         </script>
		                        <v3x:selectPeople id="auditUser" originalElements="${org}" panels="Department,Post,Level,Team" maxSize="${maxSize}" selectType="Member" jsFunction="setBulPeopleFields(elements,'auditUser','auditUserName')" />   
		                        <input type="hidden" name="auditUser" id="auditUser" value="${bean.auditUser}"/>
		                        <input type="text" class="cursor-hand input-100per" name="auditUserName" id="auditUserName" readonly="true" 
		                            value="<c:out value="${publishScopeValue}" default="${_myLabelDefault}" escapeXml="true" />"
		                            defaultValue="${_myLabelDefault}" onfocus="checkDefSubject(this, true)"
		                            onblur="checkDefSubject(this, false)" inputName="${_myLabel}" validate=""
		                            ${v3x:outConditionExpression(readOnly, 'disabled', '')} onclick="${clickEvent}"/>
		                    </span>             
		                </td>
                    </tr>
                    
                    <tr id="isAuditorModifyTrId">
	                    <td class="bg-gray" width="25%" nowrap><span><fmt:message key="news.auditor.is.modify" /></span></td>
	                    <td class="new-column" width="75%">
	                    	<label for="isAuditorModify1">    
	                            <input type="radio" id="isAuditorModify1" name="isAuditorModify" value="1"/><fmt:message key="news.yes" />
	                        </label>
	                        <label for="isAuditorModify0">    
	                            <input type="radio" id="isAuditorModify0" name="isAuditorModify" value="0"/><fmt:message key="news.no" />
	                        </label>
	                    </td>
                	</tr>
                    
                    <script type="text/javascript">
                        <c:if test="${not bean.auditFlag}">
                            $('auditUser0').hide();
                            $('isAuditorModifyTrId').hide();
                        </c:if>
                        if('${bean.isAuditorModify}'=='true'){
                        	document.getElementById('isAuditorModify1').setAttribute("checked","checked");
                        }else{
                        	document.getElementById('isAuditorModify0').setAttribute("checked","checked");
                        }
                    </script>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap valign="top"><fmt:message key="news.type.style" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%" ${dis }>
                            <table>
                                <tr>
                                    <td>
                                        <img src="<c:url value='/apps_res/news/images/standard1.png' />" alt='<fmt:message key="news.type.style.1"/>' width="84" height="102" class="${dis=='disabled'?' ':'cursor-hand'}" ${dis } onClick="javascript:chooseStyle('a');">
                                    </td>
                                    <td>
                                        <img src="<c:url value='/apps_res/news/images/standard2.png' />" alt='<fmt:message key="news.type.style.2"/>' width="84" height="102" class="${dis=='disabled'?' ':'cursor-hand'}" ${dis } onClick="javascript:chooseStyle('b');">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="a">
                                            <input type="radio" <c:if test="${bean.ext1=='0'}">checked</c:if> name="ext1" id="a" value="0" /><fmt:message key="news.type.style.1"/>
                                        </label>
                                    </td>
                                    <td>
                                        <label for="b">
                                            <input type="radio" <c:if test="${bean.ext1=='1'}">checked</c:if> name="ext1"  id="b" value="1" /><fmt:message key="news.type.style.2"/>
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <c:if test="${bean.id==null}">
                                <script type="text/javascript">
                                    $('a').checked=true;
                                </script>
                            </c:if>
                            <c:if test="${bean.ext1!='0' && bean.ext1!='1'}">
                                <script type="text/javascript">
                                    $('a').checked=true;
                                </script>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.topCount" /><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%" >
                            <select name="topCount" ${v3x:outConditionExpression(readOnly, 'disabled', '')}>
                                <v3x:metadataItem metadata="${topCountMetaData}" showType="option" name="topCount" selected="${bean.topCount}" switchType="input" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap><fmt:message key="news.type.topNumber" /><fmt:message key="label.colon" /></td>
                        <input type="hidden" name="oldTopNumber" value="${bean.topNumber}" />
                        <td class="new-column" width="75%" >
                            <select name="topNumber" ${v3x:outConditionExpression(readOnly, 'disabled', '')}>
                                <v3x:metadataItem metadata="${topNumberData}" showType="option" name="topNumber" selected="${bean.topNumber}" switchType="input" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap valign="top"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" /></td>
                        <td class="new-column" width="75%">             
                            <textarea name="description"  rows="5" cols="70" ${v3x:outConditionExpression(readOnly, 'readonly="readonly"', '')} maxSize="80" validate="maxLength" inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}"/>">${bean.description}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap></td>
                        <td class="new-column" width="75%"></td>
                    </tr>
                </table>

            </div>
           
           
        </td>
    </tr>
    <c:if test="${!readOnly}">
    <tr>
        <td class="bg-advance-bottom" align="center">
                
            <input  id="submit" type="submit" class="button-default-2 common_button_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
            <input type="button" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" onclick="parent.document.location.reload();" />

        </td>
    </tr>
    </c:if>
</table>
</form>
<script type="text/javascript">
var isread = '${readOnly}';
if('true'==isread){
    bindOnresize('connect', 0, 10);
} else {
    bindOnresize('connect', 0, 64);
}
</script>
</body>
</html> 