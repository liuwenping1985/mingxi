<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../header.jsp" %>
<c:set var="ro" value="${v3x:outConditionExpression(readonly, 'disabled', '')}" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	var tempNameMapEN = new Properties();
	var tempNameMapModel = new Properties();
    <c:forEach items="${webPages}" var="tempEN">
		tempNameMapEN.put('${tempEN.labelName_en}','${tempEN.page_id}');
		tempNameMapModel.put('${tempEN.labelName_en}','${tempEN.modelName}');
    </c:forEach>
    
   	function updateSame(){
		var tempNameEN = document.propertyForm.pageLabel_en.value;
		var modelName = document.getElementById("modelName").value;
		if(tempNameMapEN.get(tempNameEN) != '${page.id}' && tempNameMapModel.get(tempNameEN) == modelName){
			if(tempNameMapEN.get(tempNameEN)){
				alert("页签英文重复！");
				return false;
			}
		}
		return true;
	}

    function submitForm(){
    	document.getElementById("b1").disabled = true;
        var propertyForm = document.getElementById("propertyForm");
        if(!(checkForm(propertyForm) && valid("pageLabel_en") && updateSame())){
        	document.getElementById("b1").disabled = false;
            return;
        }
    	var ids = document.getElementById("List3");
    	var pIds = "";
    	for(var i = 0; i < ids.length; i ++){
			pIds += ids[i].value + ",";
		}
		document.getElementById("pIds").value = pIds;
		propertyForm.submit();
	}

	function changeCategory(id){
		var options = {
	      	url: '${hrUserDefined}?method=changeCategory',
	      	params: {categoryId: id},
	      	success: function(json) {
	      		var options = '';
				for (var i = 0; i < json.length; i ++) {
			     	options += '<option value="' + json[i].optionValue + '">' + json[i].optionDisplay + '</option>';
			    }
		      	$("select#memberDataBody").html(options);
	      	}
		};
		getJetspeedJSON(options);
	}
	
    $(document).ready(function(){
    	$('select#categoryId').change(function() {
    		changeCategory($(this).val())
  		});

    	changeCategory($('select#categoryId').val());
	});
//-->
</script>
</head>
<body scroll="no" style="overflow: no">
<form id="propertyForm" name="propertyForm" action="${hrUserDefined}?method=updatePage&settingType=${param.settingType}" method="post" target="hiddenIframe">
<input type="hidden" id="isNew" name="isNew" value="${isNew}" />
<input type="hidden" name="page_id" value="${page.id}" />

<input type="hidden" name="verdictModelName" value="${page.modelName}" />
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
     <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
    <tr align="center">
        <td height="8" class="detail-top">
            <script type="text/javascript">
                getDetailPageBreak();  
            </script>
        </td>
    </tr>
    <tr>
        <td class="categorySet-4" height="8"></td>
    </tr>
 <tr>
 <td class="categorySet-head">
    <div id="docLibBody" class="categorySet-body">
     
     
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="padding_t_5">
                    <tr>
                        <td width="50%" valign="top">
                            <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td height="30" align="right" valign="top">
                                    <div class="hr-blue-font"><strong><fmt:message key="hr.userDefined.page.info.label" bundle="${v3xHRI18N}" />&nbsp;&nbsp;</strong></div>
                                  </td>
                                  <td></td>
                                </tr>
                                <tr height="35">
                                    <td class="bg-gray" width="25%" nowrap="nowrap"><label for="pageName"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.page.name.label" bundle="${v3xHRI18N}" />:</label></td>
                                    <td class="new-column" width="75%">
                                        <input type="text" class="input-100per" name="pageName" value="${v3x:toHTML(page.pageName)}"  validate="notNull,isWord" maxlength="20" inputName="<fmt:message key="hr.userDefined.page.name.label" bundle="${v3xHRI18N}" />" ${ro}/>
                                    </td>
                                </tr>
                                <tr height="35">
                                    <td class="bg-gray" width="25%" nowrap="nowrap"><label for="pageLabel_en"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />:</label></td>
                                    <td class="new-column" width="75%">
                                        <input type="text" class="input-100per" id="pageLabel_en"  name="pageLabel_en" value="${labelName_en }" validate="notNull" maxlength="30" inputName="<fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />" ${ro}/>
                                    </td>
                                </tr>
                                <tr height="35">
                                    <td class="bg-gray" width="25%" nowrap="nowrap"><label for="display"><fmt:message key="hr.userDefined.page.isDisplay.label" bundle="${v3xHRI18N}" />:</label></td>
                                    <td class="new-column" width="75%">
                                        <select name="pageDisplay" id="pageDisplay" class="input-100per" ${ro}>
                                            <option value="0" ${page.pageDisplay == 0 ? 'selected' : ''}><fmt:message key="hr.userDefined.yes.label" bundle="${v3xHRI18N}" /></option>
                                            <option value="1" ${page.pageDisplay == 1 ? 'selected' : ''}><fmt:message key="hr.userDefined.no.label" bundle="${v3xHRI18N}" /></option>                                               
                                        </select>
                                    </td>
                                </tr>
                                <tr height="35">
                                    <td class="bg-gray" width="25%" nowrap="nowrap"><label for="modelName"><fmt:message key="hr.userDefined.page.belonged.label" bundle="${v3xHRI18N}" />:</label></td>
                                    <td class="new-column" width="75%">
                                        <c:choose>
											<c:when test="${v3x:isRole('SalaryAdmin', v3x:currentUser()) && v3x:isRole('HrAdmin', v3x:currentUser())}">
												<select name="modelName" id="modelName" class="input-100per" ${ro}>
													<c:if test="${isNew}">
														<option value="salary"><fmt:message key="menu.hr.laborageMgr" bundle="${v3xMainI18N}" /></option>
														<option value="staff"><fmt:message key="menu.hr.staffinfoMgr" bundle="${v3xMainI18N}"/></option>
													</c:if>
													<c:if test="${!isNew}">
														<c:if test="${page.modelName == 'staff'}">
															<option value="staff"><fmt:message key="menu.hr.staffinfoMgr" bundle="${v3xMainI18N}"/></option>
														</c:if>
														<c:if test="${page.modelName == 'salary'}">
															<option value="salary"><fmt:message key="menu.hr.laborageMgr" bundle="${v3xMainI18N}" /></option>
														</c:if>
													</c:if>
												</select>
											</c:when>
											<c:when test="${v3x:isRole('SalaryAdmin', v3x:currentUser())}">
												<select name="modelName" id="modelName" class="input-100per" ${ro}>
													<option value="salary"><fmt:message key="menu.hr.laborageMgr" bundle="${v3xMainI18N}" /></option>
												</select>
											</c:when>
											<c:otherwise>
												<select name="modelName" id="modelName" class="input-100per" ${ro}>
													<option value="staff"><fmt:message key="menu.hr.staffinfoMgr" bundle="${v3xMainI18N}"/></option>
												</select>
											</c:otherwise>
										</c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="bg-gray" valign="top" width="25%" nowrap="nowrap"><label for="memo"><fmt:message key="hr.record.remark.label" bundle="${v3xHRI18N}"/>:</label></td>
                                    <td class="new-column" width="75%" valign="top">
                                        <textarea class="input-100per" maxSize="100" validate="maxLength"  inputName="<fmt:message key='hr.record.remark.label' bundle='${v3xHRI18N}'/>" name="memo" id="memo" rows="7" cols="67" ${ro}>${page.memo}</textarea>
                                    </td>
                                </tr>
                            </table>                            
                        </td>
                        <td width="50%" valign="top">
                            <table width="430" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td colspan="4" height="30" valign="top">
                                    <div class="hr-blue-font"><strong><fmt:message key='hr.userDefined.setOption.label' bundle='${v3xHRI18N}' />&nbsp;&nbsp;</strong></div>
                                  </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="category"><fmt:message key="hr.userDefined.option.category.label" bundle="${v3xHRI18N}" />:</label>
                                        <select style="width:120px" name="categoryId" id="categoryId" ${ro}>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}">${v3x:toHTML(category.name)}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td width="35">&nbsp;</td>
                                    <td><fmt:message key="hr.userDefined.option.selected.label"  bundle="${v3xHRI18N}"/>:</td>
                                    <td width="35">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="180" valign="top">
                                        <select id="memberDataBody" ondblclick="Selectbox.moveSelectedOptions(memberDataBody,List3,false,'')" multiple="multiple" style="width:180px;" size="19" ${ro}></select>
                                    </td>
                                    <td width="35" align="center" valign="middle">
                                        <c:choose>
                                            <c:when test="${!readonly}">
                                                <c:set value="Selectbox.moveSelectedOptions(document.getElementById('memberDataBody'),document.getElementById('List3'),false,'')" var="onClick1" />
                                                <c:set value="Selectbox.moveSelectedOptions(document.getElementById('List3'),document.getElementById('memberDataBody'),false,'')" var="onClick2" />
                                            </c:when>
                                            <c:otherwise>
                                            </c:otherwise>
                                        </c:choose>
                                        <p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>" alt='<fmt:message key="selectPeople.alt.select" bundle="${v3xHRI18N}"/>' width="17" height="17" class="cursor-hand" onClick="${onClick1}"></p><br/>
                                        <p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>" alt='<fmt:message key="selectPeople.alt.unselect"  bundle="${v3xHRI18N}"/>' width="17" height="17" class="cursor-hand" onClick="${onClick2}"></p><br/>
                                    </td>
                                    <td width="180" valign="top">
                                        <select id="List3" ondblclick="Selectbox.moveSelectedOptions(List3,memberDataBody,false,'')" multiple="multiple" style="width:180px" size="19" ${ro}>
                                            <c:forEach items="${uses}" var="use">
                                                <option value="${use.id}">${v3x:toHTML(use.name)}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="hidden" id="pIds" name="pIds" value="" />
                                    </td>
                                    <td width="35" align="center" valign="middle">
                                        <p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>" alt='<fmt:message key="selectPeople.alt.up"  bundle="${v3xHRI18N}"/>'width="17" height="17" class="cursor-hand" onClick="Selectbox.moveOptionUp(document.getElementById('List3'))"></p><br/>
                                        <p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>" alt='<fmt:message key="selectPeople.alt.down"  bundle="${v3xHRI18N}"/>' width="17" height="17" class="cursor-hand" onClick="Selectbox.moveOptionDown(document.getElementById('List3'))"></p><br/>                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                
    </table>
    </td>
    </tr>
        </div>
     <c:choose>   
    <c:when test="${!readonly}">
    <script type="text/javascript">
		bindOnresize('docLibBody',36,96)
	</script>
        <tr>
            <td colspan="2"><br><div class="hr_heng"></div></td>
        </tr>
        <tr>
            <td height="42" align="center" colspan="2" class="page_color">
                <input id="b1" type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
                <input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
            </td>
        </tr>
    </c:when>
    <c:otherwise>
    <script type="text/javascript">
		bindOnresize('docLibBody',36,44)
	</script>
    </c:otherwise>
    </c:choose>


         </table>
    </div>

  </div>
</div>
</form>
<iframe name="hiddenIframe" id="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>