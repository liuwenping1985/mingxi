<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
var params = window.dialogArguments;
//获取json对象
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
$(function(){
	if(params && params.display){
		$("#field").html(params.display);
	}
});
/**
 * 对话框返回方法
 */
function OK(){
    var inputType = "${type}", textType = "${textType}";
    var rev=[];
    if('text' == inputType){
        rev.push(textType);
    }else if(${isShowDisignerByUser==true }){
        rev.push($('#operation').val());
    }else{
    	rev.push("");
    }
    var handValue = $('#hand').val();
    if(handValue==null){
        $.alert("${ctp:i18n('workflow.formBranch.validate.3')}");
        return "[]";
    }
    rev.push(handValue);
    return $.toJSON(rev);
}
</script>