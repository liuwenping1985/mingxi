<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">

var currentIndex1 = 0;
var currentIndex2 = 0;
var bindId = "${pcDatas.bindId}";
var formType = "${formBean.formType}";

$(document).ready(function() {
    initPhoneFields();
    $("#phoneShow").click(function(){
        phoneShowSet($(this), "pcShow","pcShowFields","phoneShow","phoneShowFields");
    });
    $("#phoneQuery").click(function(){
        phoneQuerySet($(this), "pcQuery", "pcQueryFields", "phoneQuery", "phoneQueryFields");
    });
    initChecked();
});

function initChecked() {
    var providedOperations = "${phoneDatas.providedOperations}";
    if(providedOperations != "" || "${phoneDatas.phoneShow}" != "") {
        $(":checkbox", "#dataTable").each(function(){
            $(this).prop("checked", false);
            if(providedOperations.indexOf((","+$(this).attr("id")+","))>-1){
                $(this).prop("checked", true);
            }
        });
    }
}

function phoneShowSet(obj, pcid,pcfieldsid,phoneid,phonefieldsid) {
    if(currentIndex1 == 0 && "${phoneDatas.phoneShow}"=="") {
        setDefaultValue(pcid,pcfieldsid,phoneid,phonefieldsid,4);
        currentIndex1 ++;
    }
    showSetting4Phone(phoneid,phonefieldsid,$.i18n("form.binddesign.phone.showfields.title"),1);
}

function phoneQuerySet(obj, pcid,pcfieldsid,phoneid,phonefieldsid) {
    if(currentIndex2 == 0 && "${phoneDatas.phoneQuery}"=="" && "${phoneDatas.phoneShow}"=="") {
        setDefaultValue(pcid,pcfieldsid,phoneid,phonefieldsid,1);
        currentIndex2 ++;
    }
    showSetting4Phone(phoneid,phonefieldsid,$.i18n("form.binddesign.phone.customqueryfields.title"),2);
}

function showSetting4Phone(phoneid,phonefieldsid,title,flag) {
    var params = {
        phoneDisplay:$("#"+phoneid).val(),
        phoneFields:$("#"+phonefieldsid).val()
    };
    dialog = $.dialog({
        url:_ctxPath + "/form/bindDesign.do?method=showSetting4Phone&bindAuthId="+"${pcDatas.bindId}"+"&flag="+flag,
        title : title,
        transParams:params,
        targetWindow:getCtpTop(),
        width:600,
        height:460,
        buttons : [ {
            text : $.i18n('form.trigger.triggerSet.confirm.label'),
            id:"sure",
            isEmphasize: true,
            handler : function() {
                var rv=dialog.getReturnValue();
                if(typeof rv != "undefined"){
                    var fields = "";
                    var displays = "";
                    for(var i=0;i<rv.length;i++) {
                        if(i == rv.length - 1){
                            fields += rv[i].fieldName;
                            displays += rv[i].fieldDisplay;
                        }else {
                            fields += rv[i].fieldName + ",";
                            displays += rv[i].fieldDisplay + ",";
                        }
                    }
                    $("#"+phoneid).val(displays);
                    $("#"+phonefieldsid).val(fields);
                    dialog.close();
                }
            }
        }, {
            text : $.i18n('form.query.cancel.label'),
            id:"exit",
            handler : function() {
                dialog.close();
            }
        } ]
    });
}

function setDefaultValue(pcid,pcfieldsid,phoneid,phonefieldsid,max) {
    var pcShow = $("#"+pcid).val();
    var pcShowField=$("#"+pcfieldsid).val();
    if(pcShow != "" && pcShowField != "") {
        var pcShows = pcShow.split(",");
        var pcShowFields = pcShowField.split(",");
        var phoneShow = "",phoneShowFields = "";
        for(var i=0;i<pcShows.length;i++) {
            if(i<max) {
                phoneShow += pcShows[i] + ",";
                phoneShowFields += pcShowFields[i] + ",";
            }else{
                break;
            }
        }
        $("#"+phoneid).val(phoneShow.substring(0,phoneShow.length-1));
        $("#"+phonefieldsid).val(phoneShowFields.substring(0,phoneShowFields.length-1));
    }
}

function OK() {
    var phoneShow = $("#phoneShow").val();
    var phoneShowFields = $("#phoneShowFields").val();
    var phoneQuery = $("#phoneQuery").val();
    var phoneQueryFields = $("#phoneQueryFields").val();
    var operationName = new Array();
    $(":checkbox", "#dataTable").each(function(){
        if($(this).attr("checked")=="checked"){
            operationName.push($(this).val());
        }
    });
    var returnValue = new Array();
    var formBind = new formBindDesignManager();
    returnValue[0] = formBind.saveBind4Phone(bindId,{phoneShow:phoneShow,phoneShowFields:phoneShowFields,phoneQuery:phoneQuery,phoneQueryFields:phoneQueryFields,operationName:operationName});
    returnValue[1] = phoneShow;
    return returnValue;
}

function initPhoneFields() {
    if(formType == "3") {
        var param = window.dialogArguments;
        var pcShow = param.showFieldList;
        var pcShowField = param.showFieldNameList;
        $("#pcShow").val(pcShow);
        $("#pcShowFields").val(pcShowField);
        $("#pcQuery").val(pcShow);
        $("#pcQueryFields").val(pcShowField);
        initBaseinfoFields(pcShow, pcShowField);
    }
    if("${phoneDatas.phoneShow}"=="" && "${phoneDatas.phoneQuery}"=="") {
        setDefaultValue("pcShow","pcShowFields","phoneShow","phoneShowFields",4);
        setDefaultValue("pcQuery","pcQueryFields","phoneQuery","phoneQueryFields",1);
    }
}

function initBaseinfoFields(pcShow, pcShowField) {
    var phoneShow = $("#phoneShow").val();
    var phoneQuery = $("#phoneQuery").val();
    if(pcShow != "" && (phoneShow != "" || phoneQuery != "")) {
        var pcShows = pcShow.split(",");
        var pcShowFields = pcShowField.split(",");
        var newphoneShow = "";
        var newphoneShowField ="";
        var newphoneQuery = "";
        var newphoneQueryField = "";
        var phoneShowFields = $("#phoneShowFields").val().split(",");
        var phoneShows = phoneShow.split(",");
        var inputTypes = $("#phoneShowInputType").val().split(",");
        for(var i=0;i<phoneShowFields.length;i++) {
            for(var j = 0 ;j<pcShowFields.length;j++) {
                if((inputTypes[i] == "image" || inputTypes[i] == "barcode") && newphoneShowField.indexOf(phoneShowFields[i]) == -1){
                    newphoneShow += phoneShows[i] + ",";
                    newphoneShowField += phoneShowFields[i] + ",";
                }
                if(pcShowFields[j] == phoneShowFields[i]){
                    newphoneShow += pcShows[j] + ",";
                    newphoneShowField += pcShowFields[j] + ",";
                    break;
                }
            }
        }
        var phoneQueryFields = $("#phoneQueryFields").val().split(",");
        var phoneQuery = $("#phoneQuery").val().split(",");
        for(var i=0;i<phoneQueryFields.length;i++) {
            if($("#pcQueryFields").val().indexOf(phoneQueryFields[i]) > -1){
                newphoneQuery += phoneQuery[i] + ",";
                newphoneQueryField += phoneQueryFields[i] + ",";
            }
        }
        $("#phoneShow").val(newphoneShow==""?"":newphoneShow.substring(0,newphoneShow.length-1));
        $("#phoneShowFields").val(newphoneShowField==""?"":newphoneShowField.substring(0,newphoneShowField.length-1));
        $("#phoneQuery").val(newphoneQuery==""?"":newphoneQuery.substring(0,newphoneQuery.length-1));
        $("#phoneQueryFields").val(newphoneQueryField==""?"":newphoneQueryField.substring(0,newphoneQueryField.length-1));
    }
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/form/design/bindDesign/bindDesign.js${ctp:resSuffix()}"></script>
</head>
<body class="over_hidden font_size12">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr height="50">
            <td>
                <table width="480" height="100%" border="0" cellpadding="0" cellspacing="0" align="center" style="overflow: auto;">
                    <tr align="center">
                        <td width="50%" valign="bottom">${ctp:i18n('form.binddesign.phone.pcdata.title')}</td>
                        <td valign="bottom">${ctp:i18n('form.binddesign.phone.phonedata.title')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr style="height:1px; color:#CCCCCC; width:500px;">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <div style="height: 350px;width:100%;overflow: auto;">
                    <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="90%" align="center" style="overflow: auto;">
                        <!--列表显示列-->
                        <tr height="40" style="margin-top: 5px;">
                            <td width="15%" height="20" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.pcfields.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap">
                                <input name="pcShow" id="pcShow" disabled type="text"  value="${pcDatas.showFieldList}" class="w100b" />
                                <input id="pcShowFields"  name="pcShowFields" type="hidden" value="${pcDatas.showFieldNameList}">
                            </td>
                            <td width="5%"></td>
                            <td width="15%" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.phonefields.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap">
                                <input name="phoneShow" id="phoneShow" type="text" readonly value="${phoneDatas.phoneShow}" class="w100b" style="cursor: pointer;" />
                                <input name="phoneShowFields" id="phoneShowFields" type="hidden"  value="${phoneDatas.phoneShowFields}"  />
                                <input id="phoneShowInputType"  name="phoneShowInputType" type="hidden" value="${phoneDatas.phoneShowInputType}">
                            </td>
                        </tr>
                        <!--自定义查询-->
                        <tr height="40">
                            <td width="15%" height="20" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.query.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap">
                                <input name="pcQuery" id="pcQuery" disabled type="text"  value="${formBean.formType eq 2 ? pcDatas.searchFieldList : pcDatas.showFieldList}" class="w100b" />
                                <input id="pcQueryFields"  name="pcQueryFields" type="hidden" value="${formBean.formType eq 2 ? pcDatas.searchFieldNameList : pcDatas.showFieldNameList}">
                            </td>
                            <td width="5%"></td>
                            <td width="15%" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.query.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap">
                                <input name="phoneQuery" id="phoneQuery" type="text" readonly value="${phoneDatas.phoneQuery}" class="w100b"  style="cursor: pointer;" />
                                <input name="phoneQueryFields" id="phoneQueryFields" type="hidden"  value="${phoneDatas.phoneQueryFields}"  />
                            </td>
                        </tr>
                        <!--操作显示名称、移动提供与否-->
                        <tr height="40">
                            <td width="15%" height="20" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.showopername.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap"></td>
                            <td width="5%"></td>
                            <td width="15%" align="right" nowrap="nowrap">
                                <label>${ctp:i18n('form.binddesign.phone.isprovide.label')}：</label>
                            </td>
                            <td width="33%" align="left" nowrap="nowrap"></td>
                        </tr>
                        <c:if test="${formBean.formType eq 2}">
                        <c:forEach var="sob" items="${sobs}" varStatus="status">
                            <tr height="30">
                                <td width="15%" height="20" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <input name="${sob.name}" id="${sob.name}" disabled type="text"  value='${sob.display}' class="w100b" />
                                </td>
                                <td width="5%"></td>
                                <td width="15%" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                	<!-- 黄奎修改 协同V5OA-118331 https-169：应用绑定设置移动视图，勾选状态的可控范围不对，祥见截图 -->
                                    <label class="margin_r_10 hand">
                                        <input name="${sob.name}${sob.id}_${status.index}" class="radio_com" id="${sob.name}${sob.id}"  type="checkbox" ${sob.name eq 'add' or sob.name eq 'update' or sob.name eq 'allowdelete' ? "checked=\"checked\"" : ""}  value='${sob.name}..${sob.name eq 'add' or sob.name eq 'update' ? sob.value : sob.display}..${sob.display}'>${ctp:i18n('form.binddesign.phone.provide.label')}
                                    </label>
                                </td>
                            </tr>
                        </c:forEach>
                        </c:if>
                        <c:if test="${formBean.formType eq 3}">
                            <!--新建-->
                            <tr height="30">
                                <td width="15%" height="20" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <input name="pcAdd" id="pcAdd" disabled type="text"  value="${ctp:i18n('common.toolbar.new.label')}" class="w100b" />
                                </td>
                                <td width="5%"></td>
                                <td width="15%" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <label class="margin_r_10 hand" for="phoneadd">
                                        <input name="phoneadd" class="radio_com" id="phoneadd"  type="checkbox" checked="checked"  value="add..${ctp:i18n('common.toolbar.new.label')}">${ctp:i18n('form.binddesign.phone.provide.label')}
                                    </label>
                                </td>
                            </tr>
                            <!--修改-->
                            <tr height="30">
                                <td width="15%" height="20" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <input name="pcUpdate" id="pcUpdate" disabled type="text"  value="${ctp:i18n('common.button.modify.label')}" class="w100b" />
                                </td>
                                <td width="5%"></td>
                                <td width="15%" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <label class="margin_r_10 hand" for="phoneupdate">
                                        <input name="phoneupdate" class="radio_com" id="phoneupdate"  type="checkbox" checked="checked"  value="update..${ctp:i18n('common.button.modify.label')}">${ctp:i18n('form.binddesign.phone.provide.label')}
                                    </label>
                                </td>
                            </tr>
                            <!--删除-->
                            <tr height="30">
                                <td width="15%" height="20" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <input name="pcDelete" id="pcDelete" disabled type="text"  value="${ctp:i18n('common.toolbar.delete.label')}" class="w100b" />
                                </td>
                                <td width="5%"></td>
                                <td width="15%" align="right" nowrap="nowrap"></td>
                                <td width="33%" align="left" nowrap="nowrap">
                                    <label class="margin_r_10 hand" for="phoneallowdelete">
                                        <input name="phoneallowdelete" class="radio_com" id="phoneallowdelete"  type="checkbox" checked="checked"  value="allowdelete..删除">${ctp:i18n('form.binddesign.phone.provide.label')}
                                    </label>
                                </td>
                            </tr>
                        </c:if>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>