<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script>
    $(document).ready(function() {
        var searchobj = $.searchCondition({
            top: 7,
            right: 10,
            searchHandler: function() {
                var retJSON = searchobj.g.getReturnValue();
                if (retJSON == null) {
                    refreshTable();
                } else {
                    var params = new Object();
                    params.accountId = $("#accountId").val();
                    params.spaceCategory = $("#spaceCategory").val();
                    if (retJSON.condition == "spaceName") {
                        params.spacename = retJSON.value;
                    } else {
                        params.state = retJSON.value;
                    }
                    $("#mytable").ajaxgridLoad(params);
                }
            },
            conditions: [{
                id: 'spaceName',
                name: 'spaceName',
                type: 'input',
                text: "${ctp:i18n('space.label.name')}",
                value: 'spaceName'
            }, {
                id: 'spaceState',
                name: 'spaceState',
                type: 'select',
                text: "${ctp:i18n('common.state.label')}",
                value: 'spaceState',
                items: [{
                    text: "${ctp:i18n('common.state.normal.label')}",
                    value: "0"
                }, {
                    text: "${ctp:i18n('common.state.invalidation.label')}",
                    value: "1"
                }]
            }]
        });

        var mytable = $("#mytable").ajaxgrid({
            colModel: [{
                display: 'id',
                name: 'id',
                width: '4%',
                sortable: false,
                align: 'center',
                type: 'checkbox'
            }, {
                display: "${ctp:i18n('space.label.name')}",
                name: 'spacename',
                sortable: true,
                width: '19%'
            }, {
                display: "${ctp:i18n('space.label.modelPage')}",
                name: 'pageName',
                width: '19%',
                sortable: true
            }, {
                display: "${ctp:i18n('common.state.label')}",
                name: 'state',
                sortable: true,
                width: '19%'
            }, {
                display: "${ctp:i18n('common.sort.label')}",
                name: 'sortId',
                sortType: 'number',
                sortable: true,
                width: '19%'
            }, {
                display: "${ctp:i18n('space.label.isDefaultSpace')}",
                name: 'defaultspace',
                sortable: true,
                width: '19%'
            }],
            click: tclk,
            managerName: "spaceManager",
            managerMethod: "selectSpace",
            params: {
                accountId : $("#accountId").val(),
                spaceCategory : $("#spaceCategory").val()
            },
            render: rend,
            parentId: "center",
            resizable: false,
            vChange: true,
            vChangeParam: {
                autoResize: true
            }
        });

        function rend(txt, data, r, c, clm) {
            if (clm.name == "spacename") {
                return $.i18n(txt) || txt;
            } else if (clm.name == "pageName") {
                return $.i18n(txt) || txt;
            } else if (clm.name == "state") {
                if (data.state == "1") {
                    return "${ctp:i18n('common.state.invalidation.label')}";
                } else if (data.state == "0") {
                    return "${ctp:i18n('common.state.normal.label')}";
                }
            } else if (clm.name == "defaultspace") {
                if (data.defaultspace == "0") {
                    return "${ctp:i18n('space.type.isSystemSpace.false')}";
                } else if (data.defaultspace == "1") {
                    return "${ctp:i18n('space.type.isSystemSpace.true')}";
                }
            } else {
                return txt;
            }
        }
        var myToolbar = $("#toolbar2").toolbar({
            searchHtml: 'sss',
            toolbar: [
            <c:if test="${productId ne 'a6s'}">
            {
                id: "new",
                name: "${ctp:i18n('common.toolbar.new.label')}",
                className: "ico16",
                click: function() {
                    var categoryType = '${spaceCategory}';
                    if(categoryType === 'weixin'||categoryType === 'm3'){
                        openCtpWindow1({
                            'url': "${path}/vjoin/portal.do?method=mobileDesigner&type=new&spaceCategory=" + categoryType + "&accountType=${param.accountType}",
                            'id': "spaceEdit1"
                        });
                    }else{
                        openCtpWindow1({
                            'url': "${path}/portal/spaceController.do?method=spaceEdit&accountType=${param.accountType}",
                            'id': "spaceEdit1"
                        });
                    }
                }
            }, 
            </c:if>
            {
                id: "modify",
                name: "${ctp:i18n('link.jsp.modify')}",
                className: "ico16 modify_text_16",
                click: function() {
                    var checkedIds = $("input:checked", $("#mytable"));
                    if (checkedIds.size() == 0) {
                        $.alert("${ctp:i18n('space.select.prompt')}");
                    } else if (checkedIds.size() > 1) {
                        $.alert("${ctp:i18n('space.select.selectone.prompt')}");
                    } else {
                        var checkedId = $(checkedIds[0]).attr("value");
                        var categoryType = '${spaceCategory}';

                        if(categoryType === 'weixin'||categoryType === 'm3'){
                            openCtpWindow1({
                                'url': "${path}/vjoin/portal.do?method=mobileDesigner&type=modify&spaceCategory=" + categoryType + "&accountType=${param.accountType}&spaceId=" + checkedId,
                                'id': "spaceEdit1"
                            });
                        }else{
                            openCtpWindow1({
                                'url': "${path}/portal/spaceController.do?method=spaceEdit&accountType=${param.accountType}&spaceId=" + checkedId,
                                'id': "spaceEdit1"
                            });
                        }
                    }
                }
            }
            <c:if test="${productId != 'a6s'}">
            , {
                id: "delete",
                name: "${ctp:i18n('link.jsp.del')}",
                className: "ico16 del_16",
                click: function() {
                    var categoryType = '${spaceCategory}';
                    var checkedIds = $("input:checked", $("#mytable"));
                    if (checkedIds.size() == 0) {
                        $.alert("${ctp:i18n('space.select.prompt')}");
                    } else {
                        var params = new Array();
                        for (var i = 0; i < checkedIds.size(); i++) {
                            var dataMap = new spaceManager().selectSpaceById($(checkedIds[i]).val());
                            if (dataMap.defaultspace == 1) {
                                $.alert("${ctp:i18n('space.delete.prompt1')}");
                                return;
                            }
                            if (categoryType !== 'weixin' && categoryType !== 'm3' &&isCurrentSpaceDefault(dataMap.id, dataMap.type)) {
                                $.alert("${ctp:i18n('space.delete.prompt3')}");
                                return;
                            }
                            params.push($(checkedIds[i]).val());
                        }
                        $.messageBox({
                            'title': "${ctp:i18n('common.prompt')}",
                            'type': 1,
                            'msg': "<span class='msgbox_img_4 left'></span><span class='margin_l_5'>${ctp:i18n('space.delete.prompt')}</span>",
                            ok_fn: function() {
                                new spaceManager().deleteSpaceByIds(params, {
                                    success: function(data) {
                                        refreshTable();
                                    },
                                    error: function(data) {
                                        var dataMessage = $.parseJSON(data.responseText);
                                        $.alert(dataMessage.message);
                                    }
                                });
                            }
                        });
                    }
                }
            }
            </c:if>
            <c:if test="${spaceCategory != 'weixin' && spaceCategory != 'm3'}">
            , {
                id: "defaultSpaceSetting",
                name: "${ctp:i18n('space.defaultSpace.setting.label')}",
                className: "ico16 setting_16",
                click: function() {
                    new spaceManager().getDefaultSpaceSettingForGroup({
                        success: function(settingForGroup) {
                            if (getCtpTop().isCurrentUserAdministrator == "true" && settingForGroup.allowChangeDefaultSpace == "0") {
                                <%-- 父级不允许设置默认空间 --%>
                                if (settingForGroup.defaultSpace.length > 0) {
                                    new spaceManager().selectSpaceById(settingForGroup.defaultSpace, {
                                        success: function(spaceAndPage) {
                                            var spacename = escapeStringToHTML(spaceAndPage.spacename + "", false);
                                            spacename = $.i18n(spacename) || spacename;
                                            $.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", spacename));
                                            return;
                                        }
                                    });
                                } else {
                                    var spaceName = null;
                                    if (settingForGroup.spaceType == "5_0_14_16_9_10") {
                                        spaceName = "${ctp:i18n('space.default.personal.label')}";
                                    } else if (settingForGroup.spaceType == "2") {
                                        spaceName = "${ctp:i18n('space.default.corporation.label')}";
                                    } else {
                                        <c:if test="${ctp:getSystemProperty('system.ProductId') == 2}">
                                            spaceName = "${ctp:i18n('space.default.group.label')}";
                                        </c:if>
                                        <c:if test="${ctp:getSystemProperty('system.ProductId') == 4}">
                                            spaceName = "${ctp:i18n('seeyon.top.group.space.label.GOV')}";
                                        </c:if>
                                    }
                                    $.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", spaceName));
                                    return;
                                }
                            } else {
                                defaultSpaceSettingDialog = $.dialog({
                                    id: 'defaultSpaceSetting',
                                    url: "${path}/portal/spaceController.do?method=defaultSpaceSetting",
                                    title: "${ctp:i18n('space.defaultSpace.setting.label')}",
                                    width: 320,
                                    height: 260,
                                    targetWindow: getCtpTop(),
                                    buttons: [{
                                        id: "ok_",
                                        btnType: 1,
                                        text: "${ctp:i18n('common.button.ok.label')}",
                                        handler: function() {
                                            defaultSpaceSettingDialog.getReturnValue();
                                            defaultSpaceSettingDialog.close();
                                        }
                                    }, {
                                        id: "cancel_",
                                        text: "${ctp:i18n('common.button.cancel.label')}",
                                        handler: function() {
                                            defaultSpaceSettingDialog.close();
                                        }
                                    }]
                                });
                            }
                        }
                    });
                }
            }
            </c:if>
            ]
        });

        //单击列表中一行
        function tclk(data, r, c) {
            $("input:checked", $("#mytable")).attr("checked", false);
            $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true);
            var categoryType = '${spaceCategory}';
            if(categoryType === 'weixin'||categoryType === 'm3'){
                openCtpWindow1({
                    'url': "${path}/vjoin/portal.do?method=mobileDesigner&type=modify&spaceCategory=" + categoryType + "&accountType=${param.accountType}&spaceId=" +  data.id,
                    'id': "spaceEdit1"
                });
            }else{
                openCtpWindow1({
                    'url': "${path}/portal/spaceController.do?method=spaceEdit&accountType=${param.accountType}&spaceId=" + data.id,
                    'id': "spaceEdit1"
                });
            }
        }
    });
    
    //刷新列表
    function refreshTable() {
        if(getCtpTop().reFlesh){
            getCtpTop().reFlesh();
        }else{
            window.location.reload();
        }
    }

    //判断当前操作的空间是否是设置的默认空间
    function isCurrentSpaceDefault(currentSpaceId, currentSpaceType) {
        var bool = false;
        var defaultSpaceSettingInfo = null;
        if (getCtpTop().isCurrentUserGroupAdmin == "true") {
            defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForGroup();
        } else if (getCtpTop().isCurrentUserAdministrator == "true") {
            defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForAccount($.ctx.CurrentUser.loginAccount);
        }
        if (defaultSpaceSettingInfo.defaultSpace.length > 0) {
            if (defaultSpaceSettingInfo.defaultSpace == currentSpaceId) {
                bool = true;
            }
        } else {
            if (currentSpaceType == "9") {
                bool = false;
            } else {
                var defaultSpaceTypeStringArray = defaultSpaceSettingInfo.spaceType.split("_");
                for (var i = 0; i < defaultSpaceTypeStringArray.length; i++) {
                    if (defaultSpaceTypeStringArray[i] != "" && defaultSpaceTypeStringArray[i] == currentSpaceType) {
                        bool = true;
                        break;
                    }
                }
            }
        }
        return bool;
    }

    function openCtpWindow1(args) {
        var _wmp = getCtpTop()._windowsMap;
        if (_wmp) {
            var _id = "spaceEdit1";
            var exitWin = _wmp.get(_id);
            var exitBody= null;
            try{
                exitBody= $("body",exitWin);
            }catch(e){}
            if (exitWin && exitBody) {
                try {
                    alert($.i18n("window.already.exit.js"));
                    return;
                } catch (e) {
                    _wmp.remove(_id);
                }
            }else{
                _wmp.remove(_id);
            }
        }
        getCtpTop().openCtpWindow(args);
    }
</script>
</head>
<body>
    <input type="hidden" id="accountId" value="${ctp:toHTML(accountId)}">
    <input type="hidden" id="spaceCategory" value="${ctp:toHTML(spaceCategory)}">
    <div class="comp" id="layout" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
        	<c:if test='${isGroupAdmin==true }'>
        		<div class="comp" comp="type:'breadcrumb',code:'T3_groupSpaceDesign'"></div>
        	</c:if>
            <c:if test='${isAdministrator==true }'>
            <c:choose>
                <c:when test="${param.spaceCategory=='m3'}">
                    <div class="comp" comp="type:'breadcrumb',code:'m3_infoSet'"></div>
                </c:when>
                <c:otherwise>
                    <div class="comp" comp="type:'breadcrumb',code:'T3_accountSpaceDesign'"></div>
                </c:otherwise>
            </c:choose>
        	</c:if>
            <div id="toolbar2"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>