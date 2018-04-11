<%--
 $Author: maxc $
 $Rev: 3859 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n("selectPeople.page.title")}</title>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<script text="text/javascript">
    function OK() {
        var v = {
            value : $('#spd').val(),
            text : $('#spdText').val()
        }
        window.returnValue = v;
        return v;
    }
    var parentWindow =  window.opener;
    if(window.transParams) parentWindow = window.transParams.parentWin;
    if(typeof parentWindow == 'undefined') parentWindow = window.dialogArguments.window;
    function getParentWindowData(_name){
        try{
//          if(!parentWindow || !spId){
//              return;
//          }
            var data = null;
            // ,|分隔的数据
            eval("data = parentWindow." + _name + "_" + '${ctp:escapeJavascript(param.id)}');
            if(typeof data == 'undefined') return null;
            return data;
        }
        catch(e){
            return null;
        }
    }
    $(function() {

        $('#btnOk').click(function() {
            OK();
            window.close();
        });
        $('#btnCancel').click(function() {
            window.close();
        });
        var params = window.dialogArguments ? window.dialogArguments : null;
        if (params) {
            $('#spd').val(params.value);
            $('#spdText').val(params.text);
        }
        function selectPeople(options) {
            var settings = {
                mode : 'div'
            };
            options._window = window;
            options = $.extend(settings, options);
            var url = _ctxPath + '/selectpeople.do?showAllAccount=${param.showAllAccount}', ret;
            if (options.mode == 'open') {
                // 弹出新窗口
                var retv = window.showModalDialog(url, options,
                        'dialogWidth=830px;dialogHeight=540px');
                if (retv)
                    ret = retv;
            } else {
                var dialog = $.dialog({
                    id : "SelectPeopleDialog",
                    url : url,
                    width : 690,
                    height : 480,
                    title : '${ctp:i18n("selectPeople.page.title")}',
                    isDrag :false,
                    panelParam : {'show':false},
                    maxParam :  {'show':false},
                    minParam :  {'show':false},
                    closeParam :  {'show':false,handler:function(){window.close();}},
                    transParams : options,
                    targetWindow: window,
                    isFromModle : true,
                    isHead: false,
                    nextShade:true,
                    buttons : [ {
                        text : '${ctp:i18n("common.button.ok.label")}',
                        isEmphasize:true,
                        handler : function() {
                            var retv = dialog.getReturnValue();
                            if (retv == -1) {
                                    return;
                            }
                            if (retv && options.callback)
                                options.callback(retv);
                        }
                    }, {
                        text : '${ctp:i18n("common.button.cancel.label")}',
                        handler : function() {
                          	parentWindow.${ctp:escapeJavascript(param.id)}_win.close();
                        }
                    } ]
                });

                dialog.maxfn();
                setTimeout(function(){
                    var thisParent = $("#SelectPeopleDialog_main_iframe_content");
                    var newWidth = thisParent.width()+20;
                    var newHeight = thisParent.height()+20;
                    thisParent.css({
                        "width": newWidth,
                        "height": newHeight
                    });
                },100)
            }
            return ret;
        };
        <c:set var="currentUser" value="${v3x:currentUser()}" />
        var options = {
                type : 'selectPeople',
                mode : 'div',
                panels : '${ctp:escapeJavascript(param.Panels)}',
                selectType : '${ctp:escapeJavascript(param.SelectType)}',
                memberId     : '${ctp:escapeJavascript(param.memberId)}',
                departmentId : '${ctp:escapeJavascript(param.departmentId)}' || '${currentUser.departmentId}',
                postId       : '${ctp:escapeJavascript(param.postId)}',
                levelId      : '${ctp:escapeJavascript(param.levelId)}',
                showMe       : ${ctp:escapeJavascript(param.ShowMe)},
                maxSize : <c:out value="${param.maxSize}" default="1000" />,
                minSize : <c:out value="${param.minSize}" default="1" />,
                showFlowTypeRadio : ${"selectNode4EdocWorkflow"==viewPage || ("selectNode4Workflow"==viewPage)},
                spId : '${ctp:escapeJavascript(param.id)}',           
                params : {},
                parentWindow : parentWindow,
                callback : function(data) {
                      var elements = data.obj;
                      eval("parentWindow." + transParams.fun_call);
                      eval("parentWindow." + transParams.setElements);
                      parentWindow.${ctp:escapeJavascript(param.id)}_win.close();
                    
                }
            };
        // 转换父窗口变量为参数
        var arr = ['accountId','departmentId','memberId','postId','levelId',
                'elements','showOriginalElement','excludeElements','isNeedCheckLevelScope','onlyLoginAccount',
                'showAccountShortname','showConcurrentMember','hiddenPostOfDepartment','hiddenRoleOfDepartment',
                'onlyCurrentDepartment','showDeptPanelOfOutworker','unallowedSelectEmptyGroup','showTeamType',
                'hiddenOtherMemberOfTeam','hiddenAccountIds','isCanSelectGroupAccount','showAllOuterDepartment',
                'hiddenRootAccount','hiddenGroupLevel','showDepartmentsOfTree','hiddenSaveAsTeam','hiddenMultipleRadio',
                'showAdminTypes','includeElements','extParameters','showSecondMember', 'isAllowContainsChildDept','isCheckInclusionRelations','showRecent','notShowAccountRole'];
        
        for(var i=0;i<arr.length;i++){
            var v = getParentWindowData(arr[i]);
            if(v!=null){
                options[arr[i]] = v;
            }
        }
        if(getParentWindowData("elements")) {
            options.params.value = getIdsString(getParentWindowData("elements"));
        }
        
        selectPeople(options);
    });
</script>
</head>
<body class="h100b over_hidden">

</body>
</html>
