<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
//获取json对象
var isShowRadio = ${isShowRadio};
//表单域数据
var fieldArray = ${fieldListJSON};
var fieldMap = {};
if(fieldArray!=null && fieldArray.length>0){
    for(var i=0,len=fieldArray.length; i<len; i++){
        fieldMap[fieldArray[i].name] = fieldArray[i];
        fieldMap[fieldArray[i].display] = fieldArray[i];
    }
}
if(!${isCanSetByExtend}){
    var tempDiaog = $.error({
      //'msg': '你选择了不支持的控件类型!',
      'msg' : '${ctp:i18n("workflow.formBranch.validate.2")}',
      ok_fn: function () {
      	tempDiaog.close();
        if(window.dialogArguments && window.dialogArguments.extendDialog){
        	window.dialogArguments.extendDialog.close();
        }
      }
    });
}
function selectPeopleCallback(ret){
	var groupId = "${v3x:getGroup().id}";
	if(ret && ret.obj && ret.obj.length>0){
		var element = ret.obj[0];
		if(element.type=='Post' || element.type=='Level'){
			if(groupId==element.accountId){
				$("#isGroup").val("true");
			}else{
				$("#isGroup").val("false");
			}
		}
	}
}

//初始化
function _init_(){
    selectRadio1("handRadio");
}

function selectRadio1(id){
    var tempObj = $("#"+id);
    if(tempObj.size()>0){
        $("input[type='radio']").each(function(){
            var rId = this.getAttribute("id");
            var tempId = rId.replace("Radio", "");
            if(rId != tempId){
                var tempTextId = tempId + "_txt";
                var tempTextObj = document.getElementById(tempTextId);
                if(tempTextObj){
                    tempTextObj.disabled = true;
                }else{
                    var tempObj = document.getElementById(tempId);
                    if(tempObj){
                        tempObj.disabled = true;
                    }
                }
                
              //角色按钮
                if(tempId == "role"){
                    $("#roleProperty").hide();
                    $("#loginAccountSpan").hide();
                }
            }
        });
        
        var inputObjId = id.replace("Radio", "");
        
      //选人
        var inputTxtId = inputObjId + "_txt";
        var inputTxtObj = document.getElementById(inputTxtId);
        if(inputTxtObj){
            inputTxtObj.disabled = false;
        }else{
            var inputObj = document.getElementById(inputObjId);
            if(inputObj){
                inputObj.disabled = false;
            }
        }
      //角色按钮
        if(inputObjId == "role" && inputTxtObj && inputTxtObj.value != ""){
            $("#roleProperty").show();
            $("#loginAccountSpan").show();
        }
    }
    tempObj = null;
}

//选择角色回调
function selectRoleCallback(ret){
    if(ret && ret.obj){
        
        /* var DEPT_ROLES = ["DepManager", "DepLeader", "DepAdmin", "Departmentexchange"];
        var isSysDeptRole = false;
        for(var i = 0; i < DEPT_ROLES.length; i++){
            if(DEPT_ROLES[i].toLocaleLowerCase() == ret.value.toLocaleLowerCase()){
                isSysDeptRole = true;
                break;
            }
        }
        if(isSysDeptRole){  */
            $("#roleProperty").show();
            $("#loginAccountSpan").show();
        /*  } else {
            $("#roleProperty").hide();
            $("#loginAccountSpan").hide();
        }   */
    }
}

function showProperty(flag){
    if(flag){
        $("span[id$='Property']").show();
    } else {
        $("span[id$='Property']").hide();
    }
}

/**
 * 对话框返回方法
 */
function OK(){
    var fieldInputType = "${type}";
    var operationType= $('#operation').val();
    var rev=[];
    if('checkbox' === fieldInputType){
        rev.push('==');
    }else{
        rev.push(operationType);
    }
    if(isShowRadio){
       var handRadio = $('#handRadio').attr("checked");
       var selectRadio = $('#selectRadio').attr("checked");
       var roleRadio = $('#roleRadio').attr("checked");
       if(handRadio){
   		   var handValue = $('#hand').val();
              if(handValue==null){
                   $.alert("${ctp:i18n('workflow.formBranch.validate.3')}");
                   return "[]";
              }
              if('department' == fieldInputType && handValue!=""){
                   if(handValue.endsWith("|1")){//不包含子部门

                   }else{
                       handValue = handValue+"|0";//默认包含子部门
                   }
              }
              rev.push(handValue);
              rev.push('1');
   		    if($("#isGroup").val()=='true'){
   		        rev.push(true);
   		    }else{
   		        rev.push(false);
   		    }
           return $.toJSON(rev);
       }else if(selectRadio){
       	   var selectValue = $('#select').val();
           if(selectValue==null || selectValue==""){
           	    //$.alert("请选择同类型的表单域");
           	    $.alert("${ctp:i18n('workflow.formBranch.validate.4')}");
                return "[]";
           }
           var fieldObj = fieldMap[selectValue];
           rev.push('{'+fieldObj.display+'}');
           rev.push('2');
           return $.toJSON(rev);
       }else if(roleRadio){
           
           var roleValue = $('#role').val();
           if(roleValue==null || roleValue == ""){
                $.alert("${ctp:i18n('workflow.formBranch.validate.3')}");
                return "[]";
           }
           
           rev.push(roleValue);
           rev.push('3');
           if($("#isGroup").val()=='true'){
               rev.push(true);
           }else{
               rev.push(false);
           }
           
           var isLoginAccount = false;
           $("input[name='loginAccount']").each(function(){
             if(this.checked && this.value=="yes"){
                 isLoginAccount = true;
             }
           });
           rev.push(isLoginAccount);
           
           var departmentsObj= $("#departments4Role")[0];//主岗部门
           var secondPostDepartmentObj= $("#secondPostDepartment4Role")[0];//副岗部门
           var concurrentDepartmentObj= $("#concurrentDepartment4Role")[0];//兼职部门
           
           var departmentType="";
           var checkMainPost = "false";
           var checkSecendPost = "false";
           var checkConcurrent = "false";
           var isSelect = false;
           if(departmentsObj.checked){
             isSelect= true;
             checkMainPost = ("true");
             departmentType = $(departmentsObj).attr("displayValue");
           }
           
           if(secondPostDepartmentObj.checked){
             if(isSelect){
               departmentType += ","+$(secondPostDepartmentObj).attr("displayValue");
             }else{
               departmentType += $(secondPostDepartmentObj).attr("displayValue");
             }
             isSelect= true;
             checkSecendPost= "true";
           }
           
           if(concurrentDepartmentObj && concurrentDepartmentObj.checked){
             if(isSelect){
               departmentType += ","+$(concurrentDepartmentObj).attr("displayValue");
             }else{
               departmentType += $(concurrentDepartmentObj).attr("displayValue");
             }
             isSelect= true;
             checkConcurrent = "true";
           }
           
           if(!isLoginAccount && !isSelect){
             $.alert("${ctp:i18n('workflow.branch.selectdepartment')}");
             return "[]";
           }
           
           rev.push(checkMainPost);
           rev.push(checkSecendPost);
           rev.push(checkConcurrent);
           rev.push(departmentType);
           
           return $.toJSON(rev);
       }
       return "[]";
    }else{
    	if( ( fieldInputType=="select" || fieldInputType=="radio"  )&& operationType=="in"){
    		var enuminElements= document.getElementsByName("enumin");
    		var enumIds= "";
    		var j=0;
    		for(var i=0;i<enuminElements.length;i++){
    			var enuminElement= enuminElements[i];
    			if(enuminElement.checked){
    				if(j==0){
    					enumIds += enuminElement.value;
    				}else{
    					enumIds += ","+enuminElement.value;
    				}
    				j++;
    			}
    		}
    		rev.push(enumIds);
 	   	}else{
        	rev.push($('#hand').val());
 	   	}
        rev.push('1');
        return $.toJSON(rev);
    }
}

function changeOperation(obj){
	var value=$(obj).attr("value");
	if(value=="in"){
		$("#handDiv").hide();
		$("#handSelectInDiv").show();
	}else{
		$("#handSelectInDiv").hide();
		$("#handDiv").show();
	}
}

</script>