<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="../../formula/formulaCommon.js.jsp" %>
<!-- 重定向设置各种计算式公用方法 -->
<script>
var currentTr;

function setCurrentTr(obj){
    currentTr = $(obj).parents("tr");
}

function getTempCurrentTr(obj){
    return $(obj).parents("tr");
}

function afterValueChange(){
    $("input[name='value4Show']",currentTr).css("border","1px solid #b6b6b6");
}

function setNewValue4Formula(result,needConvert){

    var oldValue = $("input[name='value4Show']",currentTr).val();
    $("input[name='value4Show']",currentTr).val(result.text);
    var newValue = result.value;
    if (needConvert){
        newValue = result.value.substring(result.value.indexOf("|")+1) + "::" + result.text + "::";
        autoChangeSameValue(result,newValue,oldValue);
    }
    $("input[name='newValue']",currentTr).val(newValue);
    $("input[name='needRedirect']",currentTr).val("false");
    afterValueChange();
}

/**
 * 自动刷新同名字段值
 * @param result
 * @param newValue
 **/
function autoChangeSameValue(result,newValue,oldValue){
    var fieldName = $("input[name='name4System']",currentTr).val();

    $("input[name='name4System'][value='"+fieldName+"']").each(function(){
        var tempCurrentTr = getTempCurrentTr(this);

        if ($("input[name='value4Show']",tempCurrentTr).val() == oldValue && $("input[name='needRedirect']",tempCurrentTr).val() == "true"){

            $("input[name='value4Show']",tempCurrentTr).val(result.text);
            $("input[name='newValue']",tempCurrentTr).val(newValue);
            $("input[name='needRedirect']",tempCurrentTr).val("false");
            $("input[name='value4Show']",tempCurrentTr).css("border","1px solid #b6b6b6");
        }
    });
}
    function redirectMember4Formula(obj){
        $.selectPeople({
            panels: 'Department,Team,Post,Level,Outworker,RelatePeople',
            selectType: 'Member',
            isNeedCheckLevelScope:false,
            hiddenFormFieldRole:true,
            maxSize:1,
            minSize:1,
            callback : function(ret) {
                setNewValue4Formula(ret,true);
            }
        });
    }

    function redirectDept4Formula(obj){
        $.selectPeople({
            panels: 'Department',
            selectType: 'Department',
            isAllowContainsChildDept:true,
            isConfirmExcludeSubDepartment:false,
            maxSize:1,
            minSize:1,
            callback : function(ret) {
                setNewValue4Formula(ret,true);
            }
        });
    }

    function redirectLevel4Formula(obj){
        $.selectPeople({
            panels: 'Level',
            selectType: 'Level',
            maxSize:1,
            minSize:1,
            callback : function(ret) {
                setNewValue4Formula(ret,true);
            }
        });
    }

    function redirectPost4Formula(obj){
        $.selectPeople({
            panels: 'Post',
            selectType: 'Post',
            maxSize:1,
            minSize:1,
            callback : function(ret) {
                setNewValue4Formula(ret,true);
            }
        });
    }

    function redirectAccount4Formula(obj){
        $.selectPeople({
            panels: 'Account',
            selectType: 'Account',
            maxSize:1,
            minSize:1,
            callback : function(ret) {
                setNewValue4Formula(ret,true);
            }
        });
    }

function redirectMsgReciver(obj){
    var par = {};
    par.value = $("#value4System",currentTr).val();
    par.text = $("#value4Show",currentTr).val();
    $.selectPeople({
        panels: 'Department,Team,Post,Level,Node,FormField',
        selectType: 'Department,Team,Post,Level,Role,Member,FormField,Node',
        extParameters:$.ctx.CurrentUser.id +',33331,true,'+getSubTableNameFromCondition()+getSubTableNameFromMsg(),
        isNeedCheckLevelScope:false,
        hiddenFormFieldRole:false,
        excludeElements: "Node|NodeUser,Node|BlankNode,Node|NodeUserSuperDept,Node|NodeUserLeaderDep,Node|NodeUserManageDep,Node|SenderLeaderDep,Node|SenderManageDep,Node|NodeUserSuperAccount",
        minSize:1,
        params : par,
        callback : function(ret) {
            setNewValue4Formula(ret,false);
        }
    });
}

function getSubTableNameFromCondition() {
    return $("#conditionTable", currentTr).val();
}

function getSubTableNameFromMsg() {
    return $("#messageTable", currentTr).val();
}

function redirectAuth(obj){
    $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Outworker',
        type:'selectPeople',
        selectType: 'Account,Department,Team,Post,Level,Member',
        hiddenPostOfDepartment:true,
        isNeedCheckLevelScope:false,
        minSize:0,
        callback : function(ret) {
            setNewValue4Formula(ret,false);
        }
    });
}

function redirectSender(obj){
    //触发流程、数据存档、联动分发、汇总、双向支持表单控件重定向
    var actionType = $("#type4System", currentTr).val();
    var par = new Object();
    par.value = $("#value4System", currentTr).val();
    par.text = $("#value4Show", currentTr).val();
    var selectTypes = "";
    var slave = "true";
    var hiddenFormFieldRole = true;
    if (actionType == "flow" || actionType == "unflow") {
        //触发流程、数据存档
        selectTypes = "33031";//主表单/多人、单/多部门、单/多单位、重复表单/多人、单部门
        hiddenFormFieldRole = false;
    } else if (actionType == "distribution") {
        //联动分发
        selectTypes = "330";//主表单/多人、单/多部门
    } else if (actionType == "gather") {
        //联动汇总
        selectTypes = "100";//主表单人
    } else if (actionType == "bilateralgo") {
        //联动双向
        selectTypes = "1001";//主表单人、重复表单人且重复表单人不受数据域条件设置的影响，
        slave = "false";
    }
    var extParameters = $.ctx.CurrentUser.id + "," + selectTypes + "," + slave + "," + getSubTableNameFromCondition();

    $.selectPeople({
        panels: 'Department,Team,Post,Level,Outworker,FormField',
        selectType: 'Member,FormField',
        isNeedCheckLevelScope: false,
        hiddenFormFieldRole: hiddenFormFieldRole,
        extParameters: extParameters,
        params: par,
        maxSize: 1,
        minSize: 1,
        callback: function (ret) {
            setNewValue4Formula(ret, false);
        }
    });
    /*$.selectPeople({
        panels: 'Department,Team,Post,Level,Outworker',
        selectType: 'Member',
        isNeedCheckLevelScope:false,
        hiddenFormFieldRole:true,
        maxSize:1,
        minSize:1,
        callback : function(ret) {
            setNewValue4Formula(ret,false);
        }
    });*/
}

function redirectSupervisor(obj){
    $.selectPeople({
        type:'selectPeople',
        panels:"Department",
        selectType:'Member',
        maxSize:10,
        minSize:1,
        onlyLoginAccount: true,
        returnValueNeedType: false,
        isNeedCheckLevelScope: false,
        targetWindow:getCtpTop(),
        callback : function(ret){
            setNewValue4Formula(ret,false);
        }
    });
}

function redrectProject(obj,validate){
    var chooseProjectdialog = $.dialog({
        id:"projectSelectDialog",
        url : _ctxPath+"/project/project.do?method=projectSelect",
        title : $.i18n('form.base.relationProject.title'),
        width : 700,
        height : 450,
        targetWindow : getCtpTop(),
        transParams: {
            projectRole: "0,1,2,4,5",
            projectState: 0 //已开始的项目
            //projectId: selectId 勾选的项目
        },
        buttons : [{
            text : $.i18n('common.button.ok.label'),
            isEmphasize:true,
            handler : function() {
                var retObj = chooseProjectdialog.getReturnValue();
                if(retObj == false){
                    $.alert($.i18n('form.base.relationProject.chooseItem'));
                    return;
                }else{
                    var result = {};
                    result.value = retObj.projectId;
                    result.text = retObj.projectName;
                    setNewValue4Formula(result,validate);
                    chooseProjectdialog.close();
                }
            }
        }, {
            text : $.i18n('common.button.cancel.label'),
            handler : function() {
                chooseProjectdialog.close();
            }
        }]
    });
}
function redrectArchive(obj){
    var dialog = $.dialog({
        url:"${path}/form/business.do?method=redrectArchive",
        title : '设置预归档到',
        width:300,
        height:200,
        buttons : [{
            text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
            id:"sure",
            isEmphasize: true,
            handler : function() {
                var result = dialog.getReturnValue();
                if(result && result.success) {
                    setNewValue4Formula(result,false);
                    dialog.close();
                }
            }
        }, {
            text : "${ctp:i18n('form.query.cancel.label')}",
            id:"exit",
            handler : function() {
                dialog.close();
            }
        }]
    });
}

function redirectAuthRelation(obj){
    $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Node,FormField,Outworker',
        selectType: 'Account,Department,Team,Post,Level,Role,Member,FormField,Node',
        extParameters:'${CurrentUser.id},333',
        isNeedCheckLevelScope:false,
        hiddenFormFieldRole:true,
        hiddenPostOfDepartment:true,
        hiddenRoleOfDepartment:true,
        excludeElements: "Node|NodeUser,Node|BlankNode,Node|NodeUserSuperDept",
        minSize:0,
        callback : function(ret) {
            setNewValue4Formula(ret,false);
        }
    });
}

function redirectWorkFlow(obj){
    copyFlowData();
    modifyWFTemplateForEgg(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}",$("#value4System",currentTr).val(),window,"collaboration","${CurrentUser.id}","${fn:escapeXml(CurrentUser.name)}","${fn:escapeXml(CurrentUser.loginAccountName)}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${ctp:i18n("collaboration.newColl.collaboration")}");
}

function createWorkFlow(obj) {
    copyFlowData(true);
    modifyWFTemplateForEgg(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}","",window,"collaboration","${CurrentUser.id}","${fn:escapeXml(CurrentUser.name)}","${fn:escapeXml(CurrentUser.loginAccountName)}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${ctp:i18n("collaboration.newColl.collaboration")}");
}

function copyFlowData(clearData){
    $("#isFlowCopy",$("#second")).val(clearData ? "" : $("#isFlowCopy",currentTr).val());
    $("#process_id",$("#second")).val(clearData ? "" : $("#process_id",currentTr).val());
    $("#process_xml",$("#second")).val(clearData ? "" : $("#process_xml",currentTr).val());
    $("#process_desc_by",$("#second")).val(clearData ? "" : $("#process_desc_by",currentTr).val());
    $("#process_subsetting",$("#second")).val(clearData ? "" : $("#process_subsetting",currentTr).val());
    $("#process_rulecontent",$("#second")).val(clearData ? "" : $("#process_rulecontent",currentTr).val());
    $("#workflow_newflow_input",$("#second")).val(clearData ? "" : $("#workflow_newflow_input",currentTr).val());
    $("#workflow_node_peoples_input",$("#second")).val(clearData ? "" : $("#workflow_node_peoples_input",currentTr).val());
    $("#workflow_node_condition_input",$("#second")).val(clearData ? "" : $("#workflow_node_condition_input",currentTr).val());
    $("#process_xml_clone",$("#second")).val(clearData ? "" : $("#process_xml_clone",currentTr).val());
    $("#process_xml_clone2flowCopy",$("#second")).val(clearData ? "" : $("#process_xml_clone2flowCopy",currentTr).val());
    $("#process_event",$("#second")).val(clearData ? "" : $("#process_event",currentTr).val());
}
/**
*创建重定向列表
1、实例化
var grid = new RedirectGrid({
   headType:0/1/2                       //列头类型，0默认，1第二列列头为类型，不是录入类型
  data:List<FormValidateResultBean>,  //必备参数，传入Javascript对象，对应Java后台的List<FormValidateResultBean>
  dom:document.getElementById("div")  //选填参数，期望在页面哪个元素里显示表格内容,默认body下
});

2、可用方法
grid.getIndex(dom); //返回该dom元素处于列表的第几行（行数从0开始）

3、隐藏域
每一行都有隐藏域，隐藏域的name属性与FormValidateResultBean的属性一致，比如$("input[name='name4System']")获得 名称-系统标识
隐藏域的id唯一，定义格式为"属性名_行数",$("#name4System_0")表示第一行的名称-系统标识

4、第四列“对象值”
这是一个文本框，id为"td_value4Show_行数",name为"value4Show"
*/
function RedirectGrid(options){
    this.dom = options.dom ? $(options.dom) : $("body");
    this.data = options.data;
    this.headType = options.headType ? options.headType : 0;
    this.showInputType = options.showInputType || options.showInputType==false ? options.showInputType : true;
    var gridHtml = this.getGridHtml();
    if(!$.isNull(gridHtml)){
        this.dom.html(gridHtml);
    }else{
        this.dom.html("${ctp:i18n('bizconfig.import.redirectform.dialog.nodirectdata')}");
    }
}

/**
*在已知重定向表格某个Dom元素的前提下，获取该元素处于列表的第几行（下标从0开始）
*dom:Javascript dom对象
*返回整数值，没有找到则返回-1
*/
RedirectGrid.prototype.getIndex = function(dom){
    var id = $(dom).attr("id");
    if($.isNull(id)){
        return -1;
    }else{
        var last = id.lastIndexOf("_");
        if(last != -1){
            return parseInt(id.substring(last+1));
        }else{
            return -1;
        }
    }
};

RedirectGrid.prototype.getGridHtml = function() {
    var gridHtml = null;
    if (this.data != undefined && this.data.length > 0) {
        //<table>标签
        gridHtml = "<table class=\"only_table edit_table\" style=\"border-left:none;border-right:none;\" border=\"0\" cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\" id=\"ftable\">";
        //<thead>头标签
        if (this.headType == 1) {
            gridHtml += this.getTheadHtml(["${ctp:i18n('form.trigger.triggerSet.triggerName.label')}", "${ctp:i18n('form.inputtype.label')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.position')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.objectval')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}"]);
        } else if (this.headType == 2) {
            if (this.showInputType) {
                gridHtml += this.getTheadHtml(["${ctp:i18n('form.pagesign.appbindname.label')}","${ctp:i18n('DataDefine.Name')}", "${ctp:i18n('form.inputtype.label')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.position')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.objectval')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}"]);
            } else {
                gridHtml += this.getTheadHtml(["${ctp:i18n('form.pagesign.appbindname.label')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.position')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.objectval')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}"]);
            }
        } else if (this.headType == 7) {
            gridHtml += this.getTheadHtml(["${ctp:i18n('form.trigger.triggerSet.linkage.name.label')}", "${ctp:i18n('form.inputtype.label')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.position')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.objectval')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}"]);
        } else {
            gridHtml += this.getTheadHtml(["${ctp:i18n('DataDefine.Name')}", "${ctp:i18n('form.inputtype.label')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.position')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.objectval')}", "${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}"]);
        }
        //<tbody>内容标签
        gridHtml += this.getTbodyHtml(this.data);
        gridHtml += "</table>";
    }
    return gridHtml;
};

/**
*获取表格头部HTML信息
*arrays：表头文字(数组)
**/
RedirectGrid.prototype.getTheadHtml = function(arrays){
    var gridHtml = "<thead>";
    gridHtml += "<tr>";
    for(var i=0;i<arrays.length;i++){
        gridHtml += "<th nowrap=\"nowrap\" style=\"text-align: center;line-height:20px;\">"+arrays[i]+"</th>";
    }
    gridHtml += "</tr>";
    gridHtml += "</thead>";
    return gridHtml;
};

/**
*获取表格内容HTML信息
*beanList:对应Java的List<FormValidateResultBean>
*/
RedirectGrid.prototype.getTbodyHtml = function(beanList){
    var gridHtml = "<tbody>";
    for(var i=0;i<beanList.length;i++){
        gridHtml += "<tr id=\"tr_"+i+"\" style=\"height:30px;\">"; //id="tr_0"下标用于标识第几组数据
        gridHtml += this.getTdHtml(beanList[i],i);
        gridHtml += "</tr>";
    }
    gridHtml += "</tbody>";
    return gridHtml;
};

/**
*获取每一行的HTML内容
*validateBean:该行数据，对应FormValidateResultBean
*index:第几行，下标从0开始
*/
RedirectGrid.prototype.getTdHtml = function(validateBean,index){
    var gridHtml = "";
    //隐藏域内容
    gridHtml += "<td id=\"td_a_"+index+"\">"
    gridHtml += this.getHiddeHtml("name4System","name4System",validateBean.name4System);
    gridHtml += this.getHiddeHtml("type4System","type4System",validateBean.type4System);
    gridHtml += this.getHiddeHtml("location4System","location4System",validateBean.location4System);
    gridHtml += this.getHiddeHtml("firstReference","firstReference",validateBean.firstReference);
    gridHtml += this.getHiddeHtml("secondReference","secondReference",validateBean.secondReference);
    gridHtml += this.getHiddeHtml("thirdReference","thirdReference",validateBean.thirdReference);
    gridHtml += this.getHiddeHtml("fourthReference","fourthReference",validateBean.fourthReference);
    gridHtml += this.getHiddeHtml("value4System","value4System",validateBean.value4System);
    gridHtml += this.getHiddeHtml("newValue","newValue",validateBean.newValue);
    gridHtml += this.getHiddeHtml("needRedirect","needRedirect",validateBean.needRedirect);
    gridHtml += this.getHiddeHtml("allowClear","allowClear",validateBean.allowClear);
    gridHtml += this.getHiddeHtml("allowCreate","allowCreate",validateBean.allowCreate);
    gridHtml += this.getHiddeHtml("allowRedirect","allowRedirect",validateBean.allowRedirect);
    gridHtml += this.getHiddeHtml("name4Show","name4Show",validateBean.name4Show);
    gridHtml += this.getHiddeHtml("type4Show","type4Show",validateBean.type4Show);
    gridHtml += this.getHiddeHtml("location4Show","location4Show",validateBean.location4Show);
    gridHtml += this.getHiddeHtml("jsFunction","jsFunction",validateBean.jsFunction);
    if (validateBean.extraMap) {
        for (var v in validateBean.extraMap) {
            if (typeof v == "string") {
                gridHtml += this.getHiddeHtml(v,v,validateBean.extraMap[v]);
            }
        }
    }
    //每一格内容
    gridHtml += (validateBean.name4Show?validateBean.name4Show:"&nbsp;")+"</td>";
    if (this.showInputType){
        if(this.headType == 2){//无流程应用绑定重定向显示名称列，自定义查询项初始值的时候，需要显示属于那个字段的
            gridHtml += "<td id=\"td_f_"+index+"\">"+(validateBean.extraMap["fieldDisplay"]?validateBean.extraMap["fieldDisplay"]:"&nbsp;")+"</td>";
        }
        gridHtml += "<td id=\"td_b_"+index+"\">"+(validateBean.type4Show?validateBean.type4Show:"&nbsp;")+"</td>";
    }
    gridHtml += "<td id=\"td_c_"+index+"\">"+validateBean.location4Show+"</td>";
    gridHtml += ("<td id=\"td_d_"+index+"\"><input style=\"width:100%;"+ (validateBean.needRedirect ? "border: 1px solid red" : "border: 1px solid #b6b6b6")+"\" type=\"text\" id=\"value4Show"+"\" name=\"value4Show\" readonly=\"readonly\" value=\""+validateBean.value4Show+"\" title=\""+validateBean.value4Show+"\" ></td>");
    //重指向、创建、清除
    gridHtml += "<td id=\"td_e_"+index+"\">";
    if(validateBean.allowRedirect){//重定向
        gridHtml += "<a id=\"btnsave\" class=\"common_button common_button_gray\" href=\"javascript:void(0)\" onclick=\"setCurrentTr(this);"+validateBean.jsFunction+"\">${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}</a>";
    }else{
        gridHtml += "<a class=\"common_button common_button_disable\" href=\"javascript:void(0)\">${ctp:i18n('bizconfig.import.redirectform.dialog.redirect')}</a>";
    }
    //gridHtml += " 创建"; //创建本期不做
    if(validateBean.allowClear){
        gridHtml += " <a id=\"btnsave\" class=\"common_button common_button_gray margin_l_5\" href=\"javascript:void(0)\" onclick=\"setCurrentTr(this);clearRediret(this,"+index+");\">${ctp:i18n('form.bind.set.pigeonhole.clear.js')}</a>";
    } else {
        gridHtml += "<a class=\"common_button common_button_disable margin_l_5\" href=\"javascript:void(0)\">${ctp:i18n('form.bind.set.pigeonhole.clear.js')}</a>";
    }
    if (validateBean.allowCreate) {
        gridHtml += " <a id=\"btncreate\" class=\"common_button common_button_gray margin_l_5\" href=\"javascript:void(0)\" onclick=\"setCurrentTr(this);"+validateBean.createFunction+"\">${ctp:i18n('form.bizmap.link.open.new.label')}</a>";
    }
    gridHtml += "</td>";
    return gridHtml;
};

/**
*创建隐藏域
*id:隐藏属性id
*name：隐藏属性name
*value:隐藏属性value
*/
RedirectGrid.prototype.getHiddeHtml = function(id,name,value){
  return "<input type=\"hidden\" id=\""+id+"\" name=\""+name+"\" value=\""+(value!=null?value:"")+"\" >";
};

//重定向表格[清除]操作
function clearRediret(dom,index){
    $("#value4Show",currentTr).val("");
    $("#value4System",currentTr).val("");
    $("#newValue",currentTr).val("");
    $("input[name='needRedirect']",currentTr).val("false");
    afterValueChange();
}

RedirectGrid.prototype.getResultJSON = function (){
    if ($("#ftable")[0]){
        return $.toJSON($("#ftable").formobj());
    }else {
        return "";
    }
};

/**
*检查该页面是否全部重定向
*返回：如果验证通过返回true，验证失败弹出提示并返回false
*/
RedirectGrid.prototype.checkRedirectRight = function(){
    var result = true;
    $("input[name='needRedirect']").each(function(index){
      if(this.value == "true"){
        $.alert($.i18n('biz.redirect.need.redirect.tips',(index+1)));
          result = false;
        return false;
      }
    });
  return result;
}
</script>