<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
//调用后台常用格式模板新建计划时 moduleType=1039 
//完全新建时isNew = true;调用模板是不需传入该参数
var relationDatas = new Object();
var prm = new planRefRelationManager();
var isModifyFlag = $("#isModifyInput").val()==="1";
var isCopy = false;
var  myplanListAll = ${mySendPlanList};
function jstoHTMLWithoutSpacetitle(){
	return "${ctp:toHTMLWithoutSpace(simplePlan.title)}"
}
function jsparseElementsOfTypeAndId(obj){
	return '${ctp:parseElementsOfTypeAndId(obj)}'
}
function getplanRefRelations(){
	return '${planRefRelations}';
}
function parseElementsOfTypeAndIdplanToMainUser(){
	return '${simplePlan.planToMainUser}';
}
function parseElementsOfTypeAndIdplanSubMainUser(){	
	return '${simplePlan.planSubMainUser}';
}
function parseElementsOfTypeAndIdplanTellUser(){	
	return '${ctp:parseElementsOfTypeAndId(simplePlan.planTellUser)}';
}
function parseElementsOfTypeAndIdrelateDepartment(){	
	return '${ctp:parseElementsOfTypeAndId(simplePlan.relateDepartment)}';
}
</script>