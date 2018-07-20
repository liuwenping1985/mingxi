<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<script type="text/javascript">
var pageData=new Object();
var ajaxKnowledgePageManager = new knowledgePageManager();
$(function() {
    pageData.proce = $.progressBar(); 
    pageData.data=new Object();
    pageData.proce.close();
    
    ajaxKnowledgePageManager.getPotentModelUsers("${param.docId}", false, {
        success : function(data) {
            var users = $.parseJSON(data);
            var selectObj = new Array();
            var unselectObj = new Array();
            
            if(users.length == 1){
                $("#spc1_people").val(users[0].userName);
                $("#spc1").val(users[0].userType+"|"+users[0].userId);
                pageData.data.selectIds = [0];
                selectObj[0] = users[0];
            }else{
                unselectObj =  users;
            }
            //缓存数据
            pageData.data.users = users;
            pageData.data.selectObj = selectObj;
            pageData.data.unselectObj = unselectObj;
        }
    });
});

function OK() {
    if (!$('#bForm').validate())
        return false;
    if (!$('#borrowMsg').validate())
        return false;
    var docBorrow = new Object();
    docBorrow.createUserId = $("#spc1").val();
    docBorrow.description = $("#borrowMsg").html();
    var data = $("#bForm").formobj();
    return $.toJSON(data);
}

function openDiv() {
    ajaxKnowledgePageManager.getPotentModelUsers("${param.docId}", false, {
        success : function(data) {
            var users = $.parseJSON(data);
            var selectObj = new Array();
            var unselectObj = new Array();
            
            if(users.length == 1){
                $("#spc1_people").val(users[0].userName);
                $("#spc1").val(users[0].userType+"|"+users[0].userId);
                pageData.data.selectIds = [0];
                selectObj[0] = users[0];
            }else{
                unselectObj =  users;
            }
            //缓存数据
            pageData.data.users = users;
            pageData.data.selectObj = selectObj;
            pageData.data.unselectObj = unselectObj;
            
            
            var dialog = $.dialog({
                id : 'selectPeopleDiv',
                url:'${path}/doc/knowledgeController.do?method=link&prefix=community&path=applyBorrowSelectPeople&docId=${docId}',
                title : '${ctp:i18n('doc.jsp.apply.select.people1')}',
                width : 538,
                height : 358,
                targetWindow : getCtpTop().top,
                transParams : pageData.data,
                buttons : [ {
                    text : $.i18n('common.button.ok.label'),
                    handler : function() {
                        var returnValue = dialog.getReturnValue();
                        if(returnValue.len==0){
                            $.alert("${ctp:i18n('doc.jsp.apply.select.no.people')}");
                        }else{
                            $("#spc1_people").val(returnValue.name);
                            $("#spc1").val(returnValue.values);
                            pageData.data.selectObj = returnValue.selectObj;
                            pageData.data.unselectObj = returnValue.unselectObj;
                            dialog.close();
                        }
                    }
                }, {
                    text : $.i18n('common.button.cancel.label'),
                    handler : function() {
                        dialog.close();
                    }
                }]
            });
            
        }
    });
}
</script>
</head>
<body class="over_hidden">
    <div class="form_area align_center" id="toBorrowId">
        <form id="bForm" class="align_center">
            <table border="0" cellSpacing="0" cellPadding="0" width="300" align="center">
                <tbody>
                    <tr>
                        <th noWrap="nowrap"><label class="margin_r_5" for="text"><font class="color_red">*</font>${ctp:i18n('doc.title.apply.owner')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                    <input type="text" id="spc1_people" name="spc1_people" class="comp validate font_size12"
                                        validate="name:'${ctp:i18n('doc.title.apply.owner')}',notNull:true"
                                        onclick="openDiv();" />
                                    <input type="hidden" id="spc1" name="spc1"/>
                             </div>
                        </td>
                    </tr>
                    <tr>
                        <th noWrap="nowrap" valign="top"><label class="margin_r_5" for="text"><font class="color_red">*</font>${ctp:i18n('sender.note.label')}:</label>
                        </th>
                        <td width="100%">
                            <div>
                                <textarea id='borrowMsg' class="padding_5 font_size12" name="borrowMsg"
                                    style="width: 95%; height: 50px;" class="validate"
                                    validate="name:'${ctp:i18n('sender.note.label')}',isWord:true,maxLength:200,notNull:true">${ctp:i18n('doc.jsp.knowledge.borrow.default.message')}</textarea>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>
</body>
</html>