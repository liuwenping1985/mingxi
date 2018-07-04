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
<script text="text/javascript">
	var dialog = null;
    function OK() {
    	var retv = dialog.getReturnValue();
        if (retv == -1) {
        	return;
        }
        var array = new Array();
    	array[0] = retv.text;
    	array[1] = retv.value;
        
    	var arr=new Array();
    	arr[0] = array;
		return arr;
    }
    
    var parentWindow =  window.opener;
    if(typeof parentWindow == 'undefined') parentWindow = window.dialogArguments.window;
    function getParentWindowData(_name){
        try{
            var data = null;
            // ,|分隔的数据
            eval("data = parentWindow." + _name + "_" + '${param.id}');
            if(typeof data == 'undefined') return null;
            return data;
        }
        catch(e){
            return null;
        }
    }
    $(function() {
    	
        function selectPeople(options) {
            var settings = {
                mode : 'div'
            };
            options._window = window;
            options = $.extend(settings, options);
            var url = _ctxPath + '/selectpeople.do?showAllAccount=${showAllAccount}', ret;
            if (options.mode == 'open') {
                // 弹出新窗口
                var retv = window.showModalDialog(url, options,
                        'dialogWidth=708px;dialogHeight=530px');
                if (retv)
                    ret = retv;
            } else {
                dialog = $.dialog({
                    id : "SelectPeopleDialog",
                    url : url,
                    width : 680,
                    height : 520,
                    checkMax:false,
                    title : '${ctp:i18n("selectPeople.page.title")}',
                    isDrag :false,
                    panelParam : {'show':false},
                    maxParam :  {'show':false},
                    minParam :  {'show':false},
                    closeParam :  {'show':false,handler:function(){window.close();}},
                    transParams : options,
                    isFromModle : true,
                    isHead: false,
                    buttons:[]
                });

                //dialog.maxfn();
            }
            return ret;
        };
        <c:set var="currentUser" value="${v3x:currentUser()}" />
        var params = window.dialogArguments ? window.dialogArguments : null;
        var options = {
                type : 'selectPeople',
                mode : 'div',
                panels : '${Panels}',
                selectType : '${SelectType}',
                includeElements : parseElements(${authMember}.join(",")),
                maxSize : <c:out value="${maxSize}" default="1000" />,
                minSize : <c:out value="${minSize}" default="1" />,  
                params : {
                	text : params ? params.split(",")[0] : "",
         			value: params ? params.split(",")[1] : ""
                }
            };
        // 转换父窗口变量为参数
        var arr = ['accountId','departmentId','memberId','postId','levelId',
                'elements','showOriginalElement','excludeElements','isNeedCheckLevelScope','onlyLoginAccount',
                'showAccountShortname','showConcurrentMember','hiddenPostOfDepartment','hiddenRoleOfDepartment',
                'onlyCurrentDepartment','showDeptPanelOfOutworker','unallowedSelectEmptyGroup','showTeamType',
                'hiddenOtherMemberOfTeam','hiddenAccountIds','isCanSelectGroupAccount','showAllOuterDepartment',
                'hiddenRootAccount','hiddenGroupLevel','showDepartmentsOfTree','hiddenSaveAsTeam','hiddenMultipleRadio',
                'showAdminTypes','includeElements','extParameters'];
        
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