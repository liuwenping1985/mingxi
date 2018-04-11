<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

var isNewForm = "${formBean.newForm }";
//将所属应用置灰且只有计划格式的值
var locationUrl = window.location.href;
if(locationUrl.indexOf("form/fieldDesign.do")>-1){
//将所属应用固定为计划格式
var planFormatSelect = $("#categoryId");
planFormatSelect.attr("disabled", "true");
var option = document.createElement("OPTION");
option.text = $.i18n("form.base.formtype.planformat"); //计划格式
option.value = "5";
option.selected = true;
planFormatSelect[0].add(option);
//屏蔽掉唯一标识
$("#setUniqueMarkBtn").hide();
//屏蔽掉校验规则
$("#setCheckRule").hide();
//屏蔽掉下拉菜单里的属性
var allInputTypeSelect = $("select[name^='inputType']");
allInputTypeSelect.each(function(index){
    //移除关联控件
    $(this).find("optgroup[label='关联控件']").remove();
    //移除签章
    $(this).find("option[value='handwrite']").remove();
    //移除标签
    $(this).find("option[value='lable']").remove();
    //移除选择数据交换任务
    $(this).find("option[value='exchangetask']").remove();
    //移除查询控件交换引擎任务
    $(this).find("option[value='querytask']").remove();
    //移除外部写入
    $(this).find("option[value='outwrite']").remove();
    //移除外部预写
    $(this).find("option[value='externalwrite-ahead']").remove();
    
    //除事项描述外去掉计划格式控件
    if($("#fieldName"+index).attr("display")!="事项描述" || $("#fieldName"+index).attr("isMasterField")=="true"){
        $(this).find("option[value='customplan']").remove();
    }
});
var allInputFieldName = $("span[name^='fieldName']");
var isHasEventDescription = false;
var isHasEndTime = false;
var isHasStartTime = false;
var isHasStartDate = false;
var isHasEndDate = false;
var dateComponentNum = 0;
allInputFieldName.each(function(index){
    if($(this).attr("display")=="事项描述"&&$(this).attr("isMasterField")=="false"){
        //事项描述只能是计划控件
        isHasEventDescription = true;
        $("#inputType"+index).val("customplan");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("500");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="发起者部门"&&$(this).attr("isMasterField")=="true"){
        //发起者部门只能是部门选择控件
        $("#inputType"+index).val("department");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="发起者姓名"&&$(this).attr("isMasterField")=="true"){
        //发起者姓名只能是部门选人组件
        $("#inputType"+index).val("member");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="发起者岗位"&&$(this).attr("isMasterField")=="true"){
        //发起者岗位只能是发起者选择岗位组件
        $("#inputType"+index).val("post");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="责任人"&&$(this).attr("isMasterField")=="false"){
        //责任人只能是选择多人组件
        $("#inputType"+index).val("multimember");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("4000");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="参与人"&&$(this).attr("isMasterField")=="false"){
        //参与人只能是选择多人组件
        $("#inputType"+index).val("multimember");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("4000");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="检查人"&&$(this).attr("isMasterField")=="false"){
        //检查人只能是选择多人组件
        $("#inputType"+index).val("multimember");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("4000");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="开始时间"&&$(this).attr("isMasterField")=="false"){
        //开始时间只能是日期时间组件
        $("#inputType"+index).val("datetime");
        $("#inputType"+index).attr("disabled", "true");
        changeInputType(index);
        $("#fieldType"+index).attr("disabled", "true");
        $("#formula"+index).hide();
        isHasStartTime = true;
        dateComponentNum += 1; 
    }else if($(this).attr("display")=="结束时间"&&$(this).attr("isMasterField")=="false"){
        //结束时间只能是日期时间组件
        $("#inputType"+index).val("datetime");
        $("#inputType"+index).attr("disabled", "true");
        changeInputType(index);
        $("#fieldType"+index).attr("disabled", "true");
        $("#formula"+index).hide();
        isHasEndTime = true;
        dateComponentNum += 1;
    }else if($(this).attr("display")=="开始日期"&&$(this).attr("isMasterField")=="false"){
        //结束时间只能是日期时间组件
        $("#inputType"+index).val("date");
        $("#inputType"+index).attr("disabled", "true");
        changeInputType(index);
        $("#fieldType"+index).attr("disabled", "true");
        $("#formula"+index).hide();
        isHasStartDate = true;
        dateComponentNum += 1;
    }else if($(this).attr("display")=="结束日期"&&$(this).attr("isMasterField")=="false"){
        //结束时间只能是日期时间组件
        $("#inputType"+index).val("date");
        $("#inputType"+index).attr("disabled", "true");
        changeInputType(index);
        $("#fieldType"+index).attr("disabled", "true");
        $("#formula"+index).hide();
        isHasEndDate = true;
        dateComponentNum += 1;
    }else if($(this).attr("display")=="重要程度"&&$(this).attr("isMasterField")=="false"){
        //绑定重要程度
        var em = new enumManagerNew();
        var embean = em.getEnumByProCode("cal_event_signifyType");
        $("#inputType"+index).val("select");
        $("#inputType"+index).attr("disabled", "true");
        $("#selectBindInput"+index).val("重要程度");
        $("#selectBindInput"+index).show();
        $("#selectBindInput"+index).attr("disabled", "true");
        $("#selectBindInput"+index).unbind("click");
        $("#bindSetAttr"+index).attr("enumId",embean.id);
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="一级维度"&&$(this).attr("isMasterField")=="false"){
        //一级维度只能是文本框
        $("#inputType"+index).val("text");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="二级维度"&&$(this).attr("isMasterField")=="false"){
        //二级维度只能是文本框
        $("#inputType"+index).val("text");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="计划耗时"&&$(this).attr("isMasterField")=="false"){
        //计划耗时只能是文本框
        $("#inputType"+index).val("text");
        $("#inputType"+index).attr("disabled", "true");
        $("#fieldType"+index).val("VARCHAR");
        $("#fieldType"+index).attr("disabled", "true");
        $("#fieldLength"+index).val("255");
        $("#fieldLength"+index).attr("disabled", "true");
        $("#formula"+index).hide();
    }else if($(this).attr("display")=="序号"&&$(this).attr("isMasterField")=="false"){
        //绑定序号
        if(isNewForm == true || isNewForm == "true") {
            $("#inputType"+index).val("linenumber");
            //$("#inputType"+index).attr("disabled", "true");
            $("#fieldType"+index).val("DECIMAL");
            $("#fieldLength"+index).val("20");
            $("#formula"+index).hide();
        }
    }
});
//隐藏关联对象相关列
$("#relationObjectTH").hide();
$("#relationTH").hide();
$("td[id^='relationObjectTD']").each(function(){
    $(this).hide();
});
$("td[id^='relationTD']").each(function(){
    $(this).hide();
});
var checkSuccess = true;
if(dateComponentNum>=1&&isHasEventDescription){
  if((!isHasEndDate&&!isHasEndTime)||(dateComponentNum>2)||(dateComponentNum==2&&!((isHasEndDate&&isHasStartDate)||(isHasEndTime&&isHasStartTime)))){
      $.alert($.i18n('plan.alert.forminterface.timemistake'));
      //将另存为和全部保存置空
      //OA-100660计划格式制作-上传重复表中仅包开始时间的表单，提示不能上传后，下一步按钮没有置灰，仍可点击
      parent.$("#otherFormSave").hide();
      parent.$("#doSaveAll").hide();
      parent.$("#nextStep").addClass("common_button_disable").unbind("click");
      checkSuccess = false;
  }
}
if(checkSuccess){
//检查是否含有必填字段，如果没有，那么就不能制作该表单
if(!isHasEventDescription){
    var confirm = $.confirm({
    'msg': $.i18n('plan.alert.forminterface.cannotuseplanform'),
    ok_fn: function () { 
    },
    cancel_fn:function(){
      //将另存为和全部保存置空
      window.history.back();
    }
  });
}
}
//固定表头
initFixHead();
$("#formTable").FixedHead({ tableLayout: "fixed" });
$("#centerList thead").replaceWith($(".fixedheadwrap thead"));
}else if(locationUrl.indexOf("queryDesign.do?method=queryIndex")){
    //视图默认勾选，对应bug23674
    $("#viewShow").hide();
}


