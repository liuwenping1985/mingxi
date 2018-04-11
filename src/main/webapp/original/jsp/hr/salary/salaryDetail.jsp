<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
    var onlyLoginAccount_staff = true;
	var isNeedCheckLevelScope_staff = false;
	
	function setStaffs(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("staffNames").value = getNamesString(elements);
    	document.getElementById("staffIds").value = getIdsString(elements, false);
	}
	function reSet() {
		document.location.href = '<c:url value="/common/detail.jsp" />';
	}
    function btn_submit() {
        getA8Top().startProc();
        var formitem = document.forms[0];//获得表单对象
        var check = checkForm(formitem);//检查表单是否为空
        if (check) {   //判断用户操作是保存还是修改　保存则进行验证
            if (formitem.action.indexOf("save") > 0) {
                var name = document.getElementById("staffNames").value;//姓名
                var yearMonth = document.getElementById("yearMonth").value;//月份
                var staffIds = document.getElementById("staffIds").value; //员工ID
                var datas = {uname: name, yearMonth: yearMonth, staffIds: staffIds};
                $.post(hrSalaryURL + '?method=findSalary', datas, function (json) {
                    var jso = eval(json);
                    if (json.indexOf("true") > 0) {
                        if (confirm(jso[0].sName + v3x.getMessage("HRLang.alerts_findsalary"))) {
                            formitem.submit();
                        }
                    } else {
                        formitem.submit();
                    }
                });
            } else {
                formitem.submit();
            }
        }
        getA8Top().endProc();
    }
	
</script>

</head>
<c:choose>
	<c:when test="${isCreated}"> 
		<v3x:selectPeople id="staff" panels="Department" selectType="Member" jsFunction="setStaffs(elements)"/>
	</c:when>
	<c:otherwise>
		<v3x:selectPeople maxSize="1" id="staff" panels="Department" selectType="Member" jsFunction="setStaffs(elements)"/>
	</c:otherwise>
</c:choose>
<body scroll="no" style="overflow: no">
<form id="editForm" name="editForm" method="post" action="${hrSalaryURL}?method=${isCreated ? 'saveSalary' : 'updateSalary'}" onsubmit="return checksub(this);">
<input type="hidden" name="id" id="id" value="${salary.id}"/>	
<input type="hidden" name="isCreated" value="${isCreated}"/>

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
        <tr align="center">
            <td height="8" class="detail-top">
                <script type="text/javascript">
                    getDetailPageBreak();  
                </script>
                <br/>
            </td>
        </tr>
        <tr>
            <td class="categorySet-4" height="8"></td>
        </tr>
    </table>
    </div>
    <div id="docLibBody" class="center_div_row2">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
        <c:set var="ds" value="${v3x:outConditionExpression(dis, 'disabled', '')}" />
        <tr>
            <td width="50%">
                <table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td class="bg-gray"><div class="hr-blue"><strong><fmt:message key="hr.fieldset.salaryinfo.label" bundle='${v3xHRI18N}'/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></div></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap="nowrap">
                            <label for="name"><font color="red">*</font><fmt:message key="hr.salary.name.label" bundle='${v3xHRI18N}'/>:</label>
                        </td>
                        <td class="new-column" width="50%">
                            <input type="hidden" name="staffIds" id="staffIds" value="${salary.staffId}" />
                            <input class="cursor-hand input-100per" type="text" name="staffNames" id="staffNames" validate="notNull" readonly="true" onclick="selectPeopleFun_staff()" value="${salary.name}" inputName="<fmt:message key='hr.salary.name.label' bundle='${v3xHRI18N}'/>" ${ds}/>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="bg-gray" width="25%" nowrap="nowrap">
                            <label for="timestamp"><font color="red">*</font><fmt:message key="hr.salary.mounth.label" bundle='${v3xHRI18N}'/>:</label>
                        </td>
                        <td class="new-column" width="50%">
                            <c:if test="${!isCreated}">
                                <c:set value="${salary.year}-${salary.month}" var="year_month"/>
                            </c:if>
                            <input class="cursor-hand input-100per" type="text" name="yearMonth" id="yearMonth" validate="notNull" readonly="true" onclick="selectDates('yearMonth'); return false;" value="${year_month}" inputName="<fmt:message key='hr.salary.mounth.label' bundle='${v3xHRI18N}'/>" ${ds}/>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
        
        <tr><td height="25" align="center">&nbsp;</td></tr>
    
        <c:choose>
            <c:when test="${isCreated}">
                <c:forEach items="${pages}" var="page">
                    <hr:salaryAddTag model="salary" language="${v3x:getLocale(pageContext.request)}" properties="${pageProperties[page.id]}" />
                    <tr><td height="25" align="center" style="color: #007CD2;">${empty page.memo ? '' : '('}${v3x:toHTML(page.memo)}${empty page.memo ? '' : ')'}</td></tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:forEach items="${pageProperties}" var="p">
                    <hr:salaryViewTag model="salary" language="${v3x:getLocale(pageContext.request)}" properties="${p.value}" readonly="${ds}" />
                    <tr><td height="25" align="center" style="color: #007CD2;">${empty pageMap[p.key].memo ? '' : '('}${pageMap[p.key].memo}${empty pageMap[p.key].memo ? '' : ')'}</td></tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        
        <c:if test="${!dis}">
            <tr>
                <td height="50" align="center" class="bg-advance-bottom">
                    <input type="button" onclick="btn_submit()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="">&nbsp;
                    <input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
                </td>
            </tr>
        </c:if>
    </table>
    </div>
  </div>
</div>
</form>
<script type="text/javascript">
    bindOnresize('docLibBody',0,40);
</script>
</body>
</html>