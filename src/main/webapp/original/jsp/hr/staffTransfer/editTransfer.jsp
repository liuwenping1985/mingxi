<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
<html>
<head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script language="JavaScript"> 
//  onlyLoginAccount_${id}       true|false   是否只显示登录单位
var onlyLoginAccount_post=true;
var onlyLoginAccount_dept = true;
var onlyLoginAccount_level = true;

// isNeedCheckLevelScope_${id} true|false  是否进行职务级别范围验证，默认true
var isNeedCheckLevelScope_dept= false;
var isNeedCheckLevelScope_post= false;
var isNeedCheckLevelScope_level= false;

//是否隐藏"另存为组"，默认为false
var hiddenSaveAsTeam_dept = true;
var hiddenSaveAsTeam_post = true;
var hiddenSaveAsTeam_level = true;
	
$(function(){
	$(editForm).submit(function() {
		if ($('#typeid').val() == '' || $('#typeid').val() == null || $('#typeid').val() == -1) {
			alert(v3x.getMessage("HRLang.hr_staffTransfer_input_validation",v3x.getMessage("HRLang.hr_staffTransfer_type")));
			$('#typeid').focus();
			return false;
		}
		if ($('#toDepartment_name').val() == '' ) {
			alert(v3x.getMessage("HRLang.hr_staffTransfer_input_validation",v3x.getMessage("HRLang.hr_staffInfo_department")));
			selectPeopleFun_dept();
			return false;
		}
		if ($('#toPost_name').val() == '') {
			alert(v3x.getMessage("HRLang.hr_staffTransfer_input_validation",v3x.getMessage("HRLang.hr_staffInfo_position")));
			selectPeopleFun_post();
			return false;
		}
		if ($('#toLevel_name').val() == '') {
			alert(v3x.getMessage("HRLang.hr_staffTransfer_input_validation",v3x.getMessage("HRLang.hr_staffInfo_level")));
			selectPeopleFun_level();
			return false;
		}				
	});
});

var accountName = '${webStaffTransfer.toAccount_name}'; //判断单位是否相同（部门、岗位和职务之间）
//根据部门ID取单位名称(暂停用)
function setAccountName(paramType, paramId, elementName, elementValue) {
		  	var options = {
	    	url: '${hrStaffTransferURL}?method=getAccount',
	    	params: {paramType:paramType,paramId:paramId},
	    	success: function(json) {
	    			if (accountName == '') {
	    				accountName = json[0].accountName;
	    			}
	    			if (accountName == json[0].accountName) {
						$('#'+elementName).val(getNamesString(elementValue) + json[0].accountName);
						$('#toAccount_id').val(json[0].accountId);
					} else {
						alert(v3x.getMessage("HRLang.hr_staffInfo_same_of_selected",v3x.getMessage("HRLang.hr_staffInfo_account")));
						$('#'+elementName).click();
					}
		    	}
			};
			getJetspeedJSON(options);
}

function setLevel(elements){	
    if (!elements) {
        return;
    }   
	document.getElementById("toLevel_name").value = getNamesString(elements);
    document.getElementById("toLevel_id").value = getIdsString(elements,false);
    
    // setAccountName('level', $('#toLevel_id').val(), 'toLevel_name', elements);
}

function setPost(elements){	
    if (!elements) {
        return;
    }   
    document.getElementById("toPost_name").value = getNamesString(elements);
    document.getElementById("toPost_id").value = getIdsString(elements,false);
    
    // setAccountName('post', $('#toPost_id').val(), 'toPost_name', elements);
}
function setDept(elements){	
    if (!elements) {
        return;
    }   
    
    document.getElementById("toDepartment_id").value = getIdsString(elements,false);
    document.getElementById("toDepartment_name").value = getNamesString(elements);
    
    // setAccountName('dept', $('#toDepartment_id').val(), 'toDepartment_name', elements);
}
$(function(){
	$('input#transfer_time').click(function() {
		if ('${ro}' != 'readOnly')
			whenstart('${pageContext.request.contextPath}', this, 675, 440);
	});
	$('input#toDepartment_name').click(function() {
		if ('${ro}' != 'readOnly')
		 	selectPeopleFun_dept();
	});
	$('input#toPost_name').click(function() {
		if ('${ro}' != 'readOnly')
			selectPeopleFun_post();
	});
	$('input#toLevel_name').click(function() {
		if ('${ro}' != 'readOnly')
			selectPeopleFun_level();
	});
});


function reSet() {
	parent.document.location.href = '<c:url value="/common/detail.jsp" />';
 }
</script>
</head>
<body scroll="no" style="overflow: no">

<v3x:selectPeople id="dept" maxSize="1" minSize="1" panels="Department" selectType="Account,Department"
	jsFunction="setDept(elements)" originalElements="Department|${member.v3xOrgMember.orgDepartmentId}"/>
<v3x:selectPeople id="post" maxSize="1" minSize="1" panels="Post" selectType="Post"
	jsFunction="setPost(elements)"/>
<v3x:selectPeople id="level" maxSize="1" minSize="1" panels="Level" selectType="Level"
	jsFunction="setLevel(elements)"/>
	
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>

<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.data.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>

<form id="editForm" method="post" action="${hrStaffTransferURL}?method=updateTransfer">
	<input type="hidden" name="id" id="id" value="${staffTransfer.id}" />
	<input type="hidden" name="toAccount_id" id="toAccount_id" />	
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="hr.staffInfo.detail.label" bundle="${v3xHRI18N}"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body">
				<p>&nbsp;</p>
             <fieldset style="width:80%" align="center">
	            <legend><strong><fmt:message key="hr.staffInfo.label" bundle="${v3xHRI18N}"/></strong></legend>
	             <div style="padding:8px">
                   	<table align="center" width="90%">
			         
                       <tr>
			           <td class="bg-gray" width="6%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap">  
			               <input type="hidden" name="staffid" id="staffid" value="${orgMember.id}" />	  
			               <input type="text" id="name" name="name" class="input-100per" value="${orgMember.name}" readonly/>
                       </td>
                       <td class="bg-gray" width="6%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.sex.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap">
				           <c:choose>
	                          <c:when test="${staffinfo.sex == '1'}">
	                            <fmt:message key="hr.staffInfo.male.label" bundle="${v3xHRI18N}" var="staffsex"/> 
	                          </c:when>
	                          <c:when test="${staffinfo.sex == '2'}"> 
	                            <fmt:message key="hr.staffInfo.female.label" bundle="${v3xHRI18N}" var="staffsex"/>  
	                          </c:when> 
	                       </c:choose>
			               <input type="text" id="sex" name="sex" class="input-100per" value="${staffsex}" readonly/>
                       </td>
                       <td class="bg-gray" width="6%" nowrap="nowrap">                       
			               <fmt:message key="hr.staffInfo.position.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap"> 
			               <c:choose>
	                          <c:when test="${staffinfo.political_position == '1'}">
	                            <fmt:message key="hr.staffInfo.commie.label" bundle="${v3xHRI18N}" var="politicalPosition"/> 
	                          </c:when>
	                          <c:when test="${staffinfo.political_position == '2'}"> 
	                            <fmt:message key="hr.staffInfo.others.label" bundle="${v3xHRI18N}" var="politicalPosition"/>  
	                          </c:when> 
	                       </c:choose>   
			               <input type="text" id="political_position" name="political_position" class="input-100per" value="${politicalPosition}" readonly/>
                       </td>
                       </tr>
                       
                       <tr>
			           <td class="bg-gray" width="6%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.birthday.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap"> 
			              <input type="text" name="birthday" id="birthday" class="input-100per" readonly
                                 value="<fmt:formatDate value="${staffinfo.birthday}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" >
                       </td> 
                       <td class="bg-gray" width="6%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.workingtime.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap">   
			               <input type="text" id="working_time" name="working_time" class="input-100per" value="${staffinfo.working_time}" readonly/>
                       </td> 
                       <td class="bg-gray" width="6%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.workStartingDate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="17%" nowrap="nowrap"> 
			              <input type="text" name="work_starting_date" id="work_starting_date" class="input-100per" readonly
                                 value="<fmt:formatDate value="${staffinfo.work_starting_date}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" >
                       </td>                			           
                      </tr>		          
		            </table>
                 </div>
             </fieldset>
             <br />
             <br />
             <fieldset style="width:80%" align="center">
	            <legend><strong><fmt:message key="hr.staffTransfer.message.label" bundle="${v3xHRI18N}"/></strong></legend>
	             <div style="padding:8px">
                   	<table align="center" width="80%">
			          <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.transferType.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">
			               <select class="input-100per" name="typeid" id="typeid" ${dis}>
			            	 <c:choose>
		  	           	        <c:when test="${staffTransfer.type.id == 1}">
		              	        <option value="1" selected><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			            	    <c:when test="${staffTransfer.type.id == 2}">
				        	    <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2" selected><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>	
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>   
			           	        </c:when>
			           	        <c:when test="${staffTransfer.type.id == 3}">
				        	    <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3" selected><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>     
			           	        </c:when>
			           	        <c:when test="${staffTransfer.type.id == 4}">
			           	        <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4" selected><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			           	        <c:when test="${staffTransfer.type.id == 5}">
			           	        <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5" selected><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			           	        <c:when test="${staffTransfer.type.id == 6}">
			           	        <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6" selected><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			           	        <c:otherwise>
			           	        <option value="-1">
		               	        <option value="1"><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/>
				       	        <option value="3"><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/>
				       	        <option value="4"><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/>
				       	        <option value="5"><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/>
				       	        <option value="6"><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/>  
			           	        </c:otherwise>
			          	     </c:choose>
                           </select>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffTransfer.date.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap">
                           <input type="text" name="transfer_time" id="transfer_time" style="cursor:hand" class="input-100per" readonly
                             value="<fmt:formatDate value="${staffTransfer.transfer_time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
                       </td>                     
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.fromDepartment.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">
			               <input type="hidden" name="fromDepartment_id" id="fromDepartment_id" value="${staffTransfer.fromDepartment_id}">   
			               <input type="text" id="fromDepartment_name" name="fromDepartment_name" class="input-100per" value="${webStaffTransfer.fromDepartment_name}" readonly/>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">  
                           <fmt:message key="hr.staffTransfer.toDepartment.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap"> 
			               <input type="hidden" name="toDepartment_id" id="toDepartment_id" value="${staffTransfer.toDepartment_id}">	     
				           <input type="text" id="toDepartment_name" name="toDepartment_name" class="input-100per" value="${webStaffTransfer.toDepartment_name}" validate="notNull" style="cursor:hand" ${ro}/>
                       </td>                     
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.fromPost.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			               <input type="hidden" name="fromPost_id" id="fromPost_id" value="${staffTransfer.fromPost_id}">   
			               <input type="text" id="fromPost_name" name="fromPost_name" class="input-100per" value="${webStaffTransfer.fromPost_name}" readonly/>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffTransfer.toPost.label" bundle="${v3xHRI18N}"/>:
                       </td>
                       <td class="new-column" width="35%" nowrap="nowrap">    
			               <input type="hidden" name="toPost_id" id="toPost_id" value="${staffTransfer.toPost_id}">   
			               <input type="text" id="toPost_name" name="toPost_name" class="input-100per" value="${webStaffTransfer.toPost_name}" validate="notNull" style="cursor:hand"  ${ro}/>
                       </td>
                      </tr>
                      <tr>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.fromLevel.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			               <input type="hidden" name="fromLevel_id" id="fromLevel_id" value="${staffTransfer.fromLevel_id}">   
			               <input type="text" id="fromLevel_name" name="fromLevel_name" class="input-100per" value="${webStaffTransfer.fromLevel_name}" readonly/>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffTransfer.toLevel.label" bundle="${v3xHRI18N}"/>:
                       </td>
                       <td class="new-column" width="35%" nowrap="nowrap">    
			               <input type="hidden" name="toLevel_id" id="toLevel_id" value="${staffTransfer.toLevel_id}">   
			               <input type="text" id="toLevel_name" name="toLevel_name" class="input-100per" value="${webStaffTransfer.toLevel_name}" validate="notNull" style="cursor:hand"  ${ro}/>
                       </td>
                      </tr>
                      <tr>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.fromMemberType.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			              <select class="input-100per" name="fromMember_type" id="fromMember_type" disabled>
				            <v3x:metadataItem metadata="${orgMeta['org_property_member_type']}" showType="option" name="type"
				            selected="${staffTransfer.fromMember_type}"/>
				          </select>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.toMemberType.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			              <select class="input-100per" name="toMember_type" id="toMember_type" ${dis}>
				            <v3x:metadataItem metadata="${orgMeta['org_property_member_type']}" showType="option" name="type"
				            selected="${staffTransfer.toMember_type}"/>
				          </select>
                       </td>
                      </tr>
                      <tr>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.fromMemberState.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			              <select class="input-100per" name="fromMember_state" id="fromMember_state" disabled>
				            <v3x:metadataItem metadata="${orgMeta['org_property_member_state']}" showType="option" name="type"
				            selected="${staffTransfer.fromMember_state}"/>
				          </select>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.toMemberState.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			              <select class="input-100per" name="toMember_state" id="toMember_state" ${dis}>
				            <v3x:metadataItem metadata="${orgMeta['org_property_member_state']}" showType="option" name="type"
				            selected="${staffTransfer.toMember_state}"/>
				          </select>
                       </td>
                      </tr>
                      <tr>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffTransfer.reason.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="80%" nowrap="nowrap" colspan="3">
			               <textarea class="input-100per" name="reason" id="reason" rows="3" cols=""  ${ro}>${staffTransfer.reason}</textarea>
                       </td>
                      </tr>                  
		            </table>
                 </div>
             </fieldset>
			</div>		
		</td>
	</tr>
	<c:if test="${!ReadOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
</body>
</html>