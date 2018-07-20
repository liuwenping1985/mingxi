<%--
 $Author: duansy $
 $Rev: 261 $
 $Date:: 2012-11-19 15:19:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>设置界面</title>
</head>
<body scroll="no">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="form_area_content" style="width:100%;">
                    <div class="one_row">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <th nowrap="nowrap">
                                        <label class="margin_r_10" for="text" >&nbsp;&nbsp;${ctp:i18n('workflow.formBranch.formdatafield') }:</label></th>
                                    <td width="90%" nowrap="nowrap">
                                        <label class="margin_r_10" for="text" id="field">${formField.display }</label>
                                    </td>
                                </tr>
                                <tr id="operationTr">
                                    <th nowrap="nowrap">
                                        <label class="margin_t_5 hand display_block" for="text">${ctp:i18n('workflow.formBranch.operator') }:</label></th>
                                    <td width="70%">
                                        <div class="common_txtbox_wrap" id="handDiv"><input id="operation" type="text" value="in" readonly="readonly"/></div>
                                    </td>
                                </tr>
                                <tr id="handTr" onclick="selectRadio1('handRadio')">
                                    <th nowrap="nowrap">
                                         <label for="handRadio" id="handRadioLabel" class="margin_t_5 hand display_block">
                                         <input type="radio" value="1" id="handRadio"  checked name="option" class="radio_com">${ctp:i18n('workflow.formBranch.handOption') }:</label>
                                      </th>
                                    <td width="70%"><c:choose>
                                            <c:when test="${type=='member' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',returnValueNeedType:false,selectType:'Member',maxSize:-1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='account' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Account',selectType:'Account',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='department' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department',selectType:'Department',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:true,isNeedCheckLevelScope:false,isAllowContainsChildDept:true"/></div></c:when>
                                            <c:when test="${type=='post' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Post',selectType:'Post',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='level' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Level',selectType:'Level',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                    </c:choose><input id="isGroup" type="hidden" value="false"></td>
                                </tr>
                                <tr id="selectTr" onclick="selectRadio1('selectRadio')">
                                    <th nowrap="nowrap">
                                       <label for="selectRadio" id="selectRadioLabel" class="margin_t_5 hand display_block">
                                        <input type="radio" value="2" id="selectRadio" name="option" class="radio_com">${ctp:i18n('workflow.formBranch.formfield') }:</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                             <select id="select">
                                                    <option value=""></option><c:forEach items="${fieldList}" var="field" varStatus="status">
                                                    <option value="${field[1] }">${field[0] }</option>
                                             </c:forEach></select>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
    </form>
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
        if(window.dialogArguments && window.dialogArguments.inDialog){
            window.dialogArguments.inDialog.close();
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
        tempObj.prop("checked", true);
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
           if('department' ==fieldInputType && 'in'==operationType){
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
</script>
</body>
</html>