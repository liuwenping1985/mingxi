<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
//获取json对象
var isShowRadio = true;
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
    }
    tempObj = null;
}
/**
 * 对话框返回方法
 */
function OK(){
    var fieldInputType = "${type}";
    var rev=[];
    var operationType= $('#operation').val();
    if('checkbox' === fieldInputType){
        rev.push('==');
    }else{
        rev.push(operationType);
    }
    if(isShowRadio){
       var handRadio = $('#handRadio').attr("checked");
       var selectRadio = $('#selectRadio').attr("checked");
       if(handRadio){
           var handValue = $('#hand').val();
           if(handValue==null){
                $.alert("${ctp:i18n('workflow.formBranch.validate.3')}");
                return "[]";
           }
           if('multidepartment' ==fieldInputType && 'include'==operationType){
        	   var deptIdStr= "";
        	   var deptIdArr= handValue.split(",");
        	   for(var i=0;i<deptIdArr.length;i++){
        		   var deptId= deptIdArr[i];
        		   if(deptId){
        			   if(deptId.endsWith("|1")){//不包含子部门
                		   
                	   }else{
                		   deptId = deptId+"|0";//默认包含子部门
                	   }
        			   if(i==0){
        				   deptIdStr += deptId;
        			   }else{
        				   deptIdStr += ","+deptId;
        			   }
        		   }
        	   }
        	   handValue= deptIdStr;
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
       }
       return "[]";
    }else{
        rev.push($('#hand').val());
        rev.push('1');
        return $.toJSON(rev);
    }
}
var preOperation= "==";
function changeMultiDepartment(obj){
	preOperation= obj.value;
	if(preOperation== obj.value){
		return;
	}else if( preOperation=="==" && obj.value=="!="){
		return;
	}else if( preOperation=="!=" && obj.value=="=="){
		return;
	}else if( (preOperation=="!=" || preOperation=="==") && obj.value=='include'){
		return;
	}
	if(obj.value=='include'){
		var comp='<input id="hand" type="text"  class="comp" comp="type:\'selectPeople\',panels:\'Department\',selectType:\'Department\',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:true,isNeedCheckLevelScope:false,isAllowContainsChildDept:true"/>';
		$("#handDiv_MultiDepartment").html(comp);
	}else{
		var comp='<input id="hand" type="text"  class="comp" comp="type:\'selectPeople\',panels:\'Department\',selectType:\'Department\',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:false,isNeedCheckLevelScope:false,isAllowContainsChildDept:true"/>';
		$("#handDiv_MultiDepartment").html(comp);
	}
	$("body").comp();
}
</script>