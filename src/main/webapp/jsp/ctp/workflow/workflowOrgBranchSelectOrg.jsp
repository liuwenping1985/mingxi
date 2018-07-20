<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="<c:url value='/common/SelectPeople/js/orgDataCenter.js${ctp:resSuffix()}' />"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager' />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script language="javascript">
var tempSelected = {text:"",value:""};
var tempSelectedElements = null;
function selectPeopleBranch(orgType){
  var panels= "Account";
  var selectType= "Account";
  var maxSize= 1;
  var minSize= 1;
  var showFixedRole= false;
  var isConfirmExcludeSubDepartment= false;
  var onlyLoginAccount = false;
  var isCanSelectGroupAccount= false;
  if(orgType=='1'){//部门
    panels="Department";
    selectType="Department";
    maxSize= -1;
    isConfirmExcludeSubDepartment= true;
  }else if(orgType=='2'){//组
    panels="Team";
    selectType="Team";
  }else if(orgType=='3'){//岗位
    panels="Post";
    selectType="Post";
  }else if(orgType=='4'){//职务级别
    panels="Level";
    selectType="Level"; 
  }else if(orgType=='5'){//部门岗位
    panels="Department";
    selectType="Post";
  }else if(orgType=='6'){//部门成员
    panels="Department";
    selectType="Member";
  }else if(orgType=='7'){//单位
    panels="Account";
    selectType="Account";
  }else if(orgType=='8'){//角色
    panels="Role";
    selectType="Role"; 
    showFixedRole= true;
    onlyLoginAccount = true;
  }else if(orgType=='9'){//发起人登录单位
    panels="Account";
    selectType="Account";
  }
  $.selectPeople({
    //mode:'open',
    type:'selectPeople',
    targetWindow:window.top,
    panels: panels,
    selectType:selectType,
    showFlowTypeRadio: false,
    hiddenMultipleRadio: false,
    hiddenColAssignRadio: true,
    maxSize:maxSize,
    minSize:minSize,
    showFixedRole:showFixedRole,
    isConfirmExcludeSubDepartment:isConfirmExcludeSubDepartment,
    onlyLoginAccount:onlyLoginAccount,
    isCanSelectGroupAccount:isCanSelectGroupAccount,
    params:tempSelected,
	elements: tempSelectedElements,
    callback:function(ret){
      if(ret && ret.obj){
        tempSelected.text = ret.text;
        tempSelected.value = ret.value;
		tempSelectedElements = ret.obj;
        setOrg(ret.obj);
      }
    }
  });
}
var selectedEntities;
var showBracket = "${orgType!=2&&orgType!=5?'true':'false'}";
var groupId = "${v3x:getGroup().id}";
function setOrg(elements){
	if(elements){
		selectedEntities = elements;
		var showName = "";
		
		for(var i=0;i<elements.length;i++){
		    //alert(elements[i]+","+elements[i].excludeChildDepartment);
			if(showBracket=="true"){
				showName += (elements[i].accountShortname?"("+elements[i].accountShortname+")":"") + elements[i].name;
			}else{
				showName += elements[0].name;
			}
			if(i != elements.length-1){
				showName += "${ctp:i18n('workflow.branch.separator.label')}";
			}
			<c:if test="${orgType==1 && isFormData!='true'}">
				document.getElementById("includeChildren").value = !elements[i].excludeChildDepartment;
			</c:if>
			<c:if test="${orgType==8 && isFormData!='true'}">
				 var $loginAccount1 = $("#loginAccount1");
		         //如果选择了按发起人单位，保持现状
		         if($loginAccount1.length == 0 || !$loginAccount1.attr("checked")){
		            $("#roleProperty").show();
		         }else{
		        	 $("#roleProperty").hide();
		         }	         
			     $("#loginAccountSpan").show();
			</c:if>
			<c:if test="${(orgType==3 || orgType==4) && param.isFormData!='true'}">
				var accountId = elements[0].accountId;
				if(accountId == groupId){
					$("#loginAccountSpan").show();
					var $loginAccount1 = $("#loginAccount1");
			         //如果选择了按发起人单位，保持现状
					if($loginAccount1.length == 0 || !$loginAccount1.attr("checked")){
						<c:if test="${orgType==3}">
						$("#postProperty").show();
						</c:if>
						<c:if test="${orgType==4}">
							$("#levelProperty").show();
						</c:if>
					}else{
						<c:if test="${orgType==3}">
						$("#postProperty").hide();
						</c:if>
						<c:if test="${orgType==4}">
							$("#levelProperty").hide();
						</c:if>
					}
				} else {
					$("#loginAccountSpan").hide();
					<c:if test="${orgType==3}">
						$("#postProperty").show();
					</c:if>
					<c:if test="${orgType==4}">
						$("#levelProperty").show();
					</c:if>
				}
			</c:if>
		}
		document.getElementById("deptName").value=showName;
	}
}

/**
 * 提供给父页面的回调函数
 */
function OK(jsonArgs) {
  var innerButtonId= jsonArgs.innerButtonId;
  if(innerButtonId=='ok'){
    return selectCondition('${addBracket }');
  }
}

/**
 * 设置选择的组织模型分支条件
 */
function selectCondition(addBracket){
  if(!selectedEntities || selectedEntities.length==0){
      $.alert("${ctp:i18n('workflow.branch.selectorg')}");
      return false;
  }
  var arr = new Array();
  var operationSel = document.getElementById("operation");
  var operation = operationSel.options[operationSel.selectedIndex];
  arr[0] = operation.value;//操作符号
  arr[1] = operation.value;//操作符号
  var orgId = "";//组织模型ID
  var orgName = "";//组织模型名称
  var accountShortname = "";//单位简称
  var accountId = "";//单位ID
  var orgType = "";//组织模型类型
  var addSeparator = false;//是否使用分隔符号
  var isRole = addBracket!="false" && document.getElementById("orgType").value!='Role';
  for(var i=0;i<selectedEntities.length;i++){
      addSeparator = i != selectedEntities.length-1;
      <c:choose>
         <c:when test="${orgType==1 && isFormData!='true'}">
         orgId +=  selectedEntities[i].id+"|"+!selectedEntities[i].excludeChildDepartment + (addSeparator?"↗":"");
         </c:when>
         <c:otherwise>
         orgId +=  selectedEntities[i].id + (addSeparator?"↗":"");
         </c:otherwise>
      </c:choose>
      orgName += (isRole?"[":"")+selectedEntities[i].name + (isRole?"]":"") + (addSeparator?"↗":"");
      accountShortname += selectedEntities[i].accountShortname + (addSeparator?"↗":"");
      accountId += selectedEntities[i].accountId + (addSeparator?"↗":"");
      orgType += selectedEntities[i].type + (addSeparator?"↗":"");
  }
  arr[2] = orgId;//组织模型ID
  arr[3] = orgName;//组织模型名称
  arr[4] = accountShortname;//单位简称
  arr[5] = accountId;//单位ID
  arr[6] = orgType;//组织模型类型
  ////////////岗位条件部分//////////////////
  arr[7] = "";
  arr[8] = "";
  arr[9] = "";
  arr[10] = "";
  ////////////部门条件部分///////////////////
  arr[11] = "";
  arr[12] = "";
  arr[13] = "";
  arr[14] = "";
  arr[15] = "";//是否包含子部门
  /////////////单位条件部分////////////////////////////
  arr[16] = "";
  arr[17] = "";
  arr[18] = "";
  //////////////职务级别条件//////////////////////////////////////
  arr[19] = "";
  arr[20] = "";
  arr[21] = "";
  arr[22] = false;//是否按照发起人登录判断
  var isLoginAccount = false;
  var loginAccountObjs = $("input[name='loginAccount']");
  loginAccountObjs.each(function(){
	if(this.checked && this.value=="yes"){
		isLoginAccount = true;
	}
  });
  arr[22] = isLoginAccount;
  var isSelect= false;
  <c:if test="${orgType==3 && isFormData!='true'}">
  var primaryPostObj= $("#primaryPost")[0];//主岗
  var secondPostObj= $("#secondPost")[0];//副岗位
  var cntpostObj= $("#cntpost")[0];//兼职岗位
  var postType = "";
  if(primaryPostObj.checked){
    isSelect= true;
    arr[7] = "true";
    postType = $(primaryPostObj).attr("displayValue");
  }else{
    arr[7] = "false";
  }
  if(secondPostObj.checked){
    if(isSelect){
      postType += ","+$(secondPostObj).attr("displayValue");
    }else{
      postType += $(secondPostObj).attr("displayValue");
    }
    isSelect= true;
    arr[8] = "true";
  }else{
    arr[8] = "false";
  }
  if(cntpostObj){
    if(cntpostObj.checked){
      if(isSelect){
        postType += ","+$(cntpostObj).attr("displayValue");
      }else{
        postType += $(cntpostObj).attr("displayValue");
      }
      isSelect= true;
      arr[9] = "true";
    }else{
      arr[9] = "false";
    }
  }else{
    arr[9] = "false";
  }
  arr[10] = postType;
  if(!isLoginAccount && !isSelect){
    $.alert("${ctp:i18n('workflow.branch.selectpost')}");
    return false;
  }
  </c:if>
  //新增的部门条件
  <c:if test="${orgType==1 && isFormData!='true'}">
  var departmentsObj= $("#departments")[0];//主岗部门
  var secondPostDepartmentObj= $("#secondPostDepartment")[0];//副岗部门
  var concurrentDepartmentObj= $("#concurrentDepartment")[0];//兼职部门
  var departmentType="";
  if(departmentsObj.checked){
    isSelect= true;
    arr[11]= "true";
    departmentType = $(departmentsObj).attr("displayValue");
  }else{
    arr[11]= "false";
  }
  if(secondPostDepartmentObj.checked){
    if(isSelect){
      departmentType += ","+$(secondPostDepartmentObj).attr("displayValue");
    }else{
      departmentType += $(secondPostDepartmentObj).attr("displayValue");
    }
    isSelect= true;
    arr[12]= "true";
  }else{
    arr[12]= "false";
  }
  if(concurrentDepartmentObj && concurrentDepartmentObj.checked){
    if(isSelect){
      departmentType += ","+$(concurrentDepartmentObj).attr("displayValue");
    }else{
      departmentType += $(concurrentDepartmentObj).attr("displayValue");
    }
    isSelect= true;
    arr[13]= "true";
  }else{
    arr[13]= "false";
  }
  if(!isSelect){
    $.alert("${ctp:i18n('workflow.branch.selectdepartment')}");
    return false;
  }
  var includeChildren = document.getElementById("includeChildren");
  if(includeChildren){
    arr[15] = includeChildren.value == "true" ? true : false;
    departmentType += ",${ctp:i18n('workflow.branch.includeChildren')}";
  }else{
    departmentType += ",${ctp:i18n('workflow.branch.excludeChildren')}";
  }
  arr[14]= departmentType;
  </c:if>
  //新增的单位条件
  <c:if test="${orgType==7 && isFormData!='true'}">
  var belongAcuntObj= $("#belongAcunt")[0];//所属单位
  var concurrentAcuntObj= $("#concurrentAcunt")[0];//兼职单位
  var acuntType="";
  if(belongAcuntObj.checked){
    acuntType =$(belongAcuntObj).attr("displayValue");
    isSelect= true;
    arr[16]= "true";
  }else{
    arr[16]= "false";
  }
  if(concurrentAcuntObj && concurrentAcuntObj.checked){
    if(isSelect){
      acuntType += ","+$(concurrentAcuntObj).attr("displayValue");
    }else{
      acuntType += $(concurrentAcuntObj).attr("displayValue");
    }
    isSelect= true;
    arr[17]= "true";
  }else{
    arr[17]= "false";
  }
  arr[18]= acuntType;
  if(!isSelect){
    $.alert("${ctp:i18n('workflow.branch.selectaccount')}");
    return false;
  }
  </c:if>
  //新增的职务级别条件
  <c:if test="${orgType==4 && isFormData!='true'}">
  var belongLevlObj= $("#belongLevl")[0];//主职务级别
  var concurrentLevlObj= $("#concurrentLevl")[0];//兼职职务级别
  var levlType="";
  if(belongLevlObj.checked){
    levlType= $(belongLevlObj).attr("displayValue");
    isSelect= true;
    arr[19] = "true";
  }else{
    arr[19] = "false";
  }
  if(concurrentLevlObj && concurrentLevlObj.checked){
    if(isSelect){
      levlType += ","+$(concurrentLevlObj).attr("displayValue");
    }else{
      levlType += $(concurrentLevlObj).attr("displayValue");
    }
    isSelect= true;
    arr[20] = "true";
  }else{
    arr[20] = "false";
  }
  arr[21] = levlType;
  if(!isLoginAccount && !isSelect){
    $.alert("${ctp:i18n('workflow.branch.selectlevel')}");
    return false;
  }
  </c:if>
  //新增的角色条件
  <c:if test="${orgType==8 && isFormData!='true'}">
      var departmentsObj= $("#departments4Role")[0];//主岗部门
      var secondPostDepartmentObj= $("#secondPostDepartment4Role")[0];//副岗部门
      var concurrentDepartmentObj= $("#concurrentDepartment4Role")[0];//兼职部门
      var departmentType="";
      if(departmentsObj.checked){
        isSelect= true;
        arr[11]= "true";
        departmentType = $(departmentsObj).attr("displayValue");
      }else{
        arr[11]= "false";
      }
      if(secondPostDepartmentObj.checked){
        if(isSelect){
          departmentType += ","+$(secondPostDepartmentObj).attr("displayValue");
        }else{
          departmentType += $(secondPostDepartmentObj).attr("displayValue");
        }
        isSelect= true;
        arr[12]= "true";
      }else{
        arr[12]= "false";
      }
      if(concurrentDepartmentObj && concurrentDepartmentObj.checked){
        if(isSelect){
          departmentType += ","+$(concurrentDepartmentObj).attr("displayValue");
        }else{
          departmentType += $(concurrentDepartmentObj).attr("displayValue");
        }
        isSelect= true;
        arr[13]= "true";
      }else{
        arr[13]= "false";
      }
      if(!isLoginAccount && !isSelect){
        $.alert("${ctp:i18n('workflow.branch.selectdepartment')}");
        return false;
      }
      arr[14]= departmentType;
  </c:if>
  return arr;
}
$().ready(function() {
<c:choose>
	<c:when test="${orgType==8 && isFormData!='true'}">
	$("#roleProperty").show();
    $("#loginAccountSpan").show();
    $("#loginAccount1").attr("checked",false);
    $("#loginAccount2").attr("checked",true);
	</c:when>
	<c:otherwise>
	$("#loginAccountSpan").hide();
	</c:otherwise>
</c:choose>
});

function showProperty(flag){
	if(flag){
		$("span[id$='Property']").show();
	} else {
		$("span[id$='Property']").hide();
	}
}
</script>
<body bgcolor="#f6f6f6">
<input type="hidden" id="orgId">
<input type="hidden" id="orgName">
<input type="hidden" id="accountShortname">
<input type="hidden" id="accountId">
<input type="hidden" id="orgType">
<table border="0" cellpadding="0" cellspacing="0" align="center"> 
<tr><td colspan="2">&nbsp;</td></tr>
<!-- 查询条件 -->
<tr>
  <td class="font_size12 align_right">${ctp:i18n('workflow.branch.search.label')}：</td>
  <td><div class="common_selectbox_wrap">
    <select id="operation"><%--${ctp:i18n('workflow.branch.operation.equal')}${ctp:i18n('workflow.branch.operation.notequal')}--%>
      <option value="==">=</option>
      <option value="<>">&lt;&gt;</option>
      <c:if test="${orgType==4}">
      	 <option value="--">${ctp:i18n('workflow.branchGroup.3.3')}</option>
      	 <option value=">>">${ctp:i18n('workflow.branchGroup.3.4')}</option>
      	 <option value="<<">${ctp:i18n('workflow.branchGroup.3.5')}</option>
      </c:if>
    </select></div>
  </td>
 </tr>
 <tr><td colspan="2">&nbsp;</td></tr>
 <!-- 组织模型类型名称：单位、部门、岗位、职务级别、组、角色 -->
 <tr>
  <td class="font_size12 align_right">${messageKey }：</td>
  <td><div class="common_txtbox_wrap">
  	<input class="hand" type="text" name="deptName" readonly="readonly" id="deptName"
     value="${ctp:i18n('workflow.branch.default.selectpeople')}" onclick="selectPeopleBranch('${orgType}')"/>
  </div></td>
 </tr>
 
 <!-- 按发起人登录判断 -->
 <c:if test="${isFormData!='true' && (orgType == 3 || orgType == 4 || orgType == 8) && isGroup == true }">
 <tr><td colspan="2">&nbsp;</td></tr>
 <tr>
 	<td colspan="2" class="font_size12">
 		<span id="loginAccountSpan">
	 		${ctp:i18n('workflow.branch.byloginaccount.label')}：
	        <input type="radio" name="loginAccount" id="loginAccount1" onclick="showProperty(false);" value="yes"><label for="loginAccount1">${ctp:i18n('common.true')}</label>
	        <input type="radio" name="loginAccount" id="loginAccount2" onclick="showProperty(true);" value="no" checked><label for="loginAccount2">${ctp:i18n('common.no')}</label>
        </span>
	</td>
 </tr>
</c:if>
<!-- 添加的职务级别属性 -->
<c:if test="${orgType==4 && isFormData!='true'}">
 	<tr><td colspan="2">&nbsp;</td></tr>
 	<tr>
   		<td colspan="2">
   			<span id="levelProperty">
            <input type="checkbox" id="belongLevl" checked name="levlType" displayValue="${belongLevlLabel}">
            <label for="belongLevl" class="font_size12">${belongLevlLabel}</label>
			<c:if test="${isGroup == true }">
				<input type="checkbox" id="concurrentLevl" name="levlType" displayValue="${concurrentLevlLabel}">
				<label for="concurrentLevl" class="font_size12">${concurrentLevlLabel}</label>
			</c:if>
			</span>
 		</td>
 	</tr>
</c:if>
<!-- 添加的单位属性 -->
<c:if test="${orgType==7 && isFormData!='true'}">
 	<tr><td colspan="2">&nbsp;</td></tr>
 	<tr>
   		<td colspan="2">
            <input type="checkbox" id="belongAcunt" checked name="acuntType" displayValue="${ctp:i18n('workflow.branch.belong.label')}${ctp:i18n('org.account.label')}">
            <label for="belongAcunt" class="font_size12">${ctp:i18n('workflow.branch.belong.label')}${ctp:i18n('org.account.label')}</label>
            <input type="checkbox" id="concurrentAcunt" name="acuntType" displayValue="${ctp:i18n('org.mamber_form.concurrentAcunt.label')}">
            <label for="concurrentAcunt" class="font_size12">${ctp:i18n('org.mamber_form.concurrentAcunt.label')}</label>
 		</td>
 	</tr>
 </c:if>
<!-- 添加岗位属性 -->
 <c:if test="${orgType==3 && isFormData!='true'}">
 <tr><td colspan="2">&nbsp;</td></tr>
 <tr>
   <td colspan="2">
   <span id="postProperty">
	   <input type="checkbox" id="primaryPost" checked name="postType" checked="true"  displayValue="${ctp:i18n('workflow.branch.org.member_form.primaryPost.label')}">
	   <label for="primaryPost" class="font_size12">${ctp:i18n('workflow.branch.org.member_form.primaryPost.label')}</label>
	   <input type="checkbox" id="secondPost" name="postType" displayValue="${ctp:i18n('org.secondPost.label')}">
	   <label for="secondPost" class="font_size12">${ctp:i18n('org.secondPost.label')}</label>
	   <c:if test="${v3x:getSysFlagByName('form_showAccount')}">
	   	<input type="checkbox" id="cntpost" name="postType" displayValue="${ctp:i18n('cntPost.body.cntpost.label')}">
	    <label for="cntpost" class="font_size12">${ctp:i18n('cntPost.body.cntpost.label')}</label>
	   </c:if>
   </span>
 </tr>
 </c:if>
 <!-- 添加部门属性 -->
 <c:if test="${orgType==1 && isFormData!='true'}">
 	<tr><td colspan="2">&nbsp;</td></tr>
 	<tr>
   		<td colspan="2">
 			<input type="hidden" id="includeChildren" value="true">
 			<input type="checkbox" id="departments" name="departType" checked="checked"  displayValue="${ctp:i18n('workflow.branch.org.member_form.deptName.label')}">
                <label for="departments"  class="font_size12">${ctp:i18n('workflow.branch.org.member_form.deptName.label')}</label>
            <input type="checkbox" id="secondPostDepartment" name="departType" displayValue="${ctp:i18n('org.member_form.secondPostDepartment.label')}">
            <label for="secondPostDepartment"  class="font_size12">${ctp:i18n('org.member_form.secondPostDepartment.label')}</label>
            <c:if test="${isGroup == true }">
            	<input type="checkbox" id="concurrentDepartment" name="departType" displayValue="${ctp:i18n('org.member_form.concurrentDepartment.label')}"> 
            	<label for="concurrentDepartment"  class="font_size12">${ctp:i18n('org.member_form.concurrentDepartment.label')}</label>
            </c:if>
 		</td>
 	</tr>
 </c:if>
 <!-- 添加角色属性 -->
 <c:if test="${orgType==8 && isFormData!='true'}">
 <tr><td colspan="2">&nbsp;</td></tr>
 <tr>
    <td colspan="2">
        <span id="roleProperty" style="display: none;">
            <input type="checkbox" id="departments4Role" name="departType4Role" checked="checked"  displayValue="${ctp:i18n('workflow.branch.org.member_form.deptName.label')}">
                <label for="departments4Role" class="font_size12">${ctp:i18n('workflow.branch.org.member_form.deptName.label')}</label>
            <input type="checkbox" id="secondPostDepartment4Role" name="departType4Role" displayValue="${ctp:i18n('org.member_form.secondPostDepartment.label')}">
            <label for="secondPostDepartment4Role" class="font_size12">${ctp:i18n('org.member_form.secondPostDepartment.label')}</label>
            <c:if test="${isGroup == true }">
            	<input type="checkbox" id="concurrentDepartment4Role" name="departType4Role" displayValue="${ctp:i18n('org.member_form.concurrentDepartment.label')}"> 
            	<label for="concurrentDepartment4Role" class="font_size12">${ctp:i18n('org.member_form.concurrentDepartment.label')}</label>
            </c:if>
        </span>
    </td>
 </tr>
 </c:if>
</table>
</body>
</html>