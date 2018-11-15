<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n("system.menuname.PortalConfig")}</title>
<style type="text/css">
    #systemMenuTree {
        width: 250px;
        height: 250px;
        overflow-y: auto;
        overflow-x: auto;
    }
    
    #grid_detail.stadic_layout {
        background: #C4CBCE;
    }
    
    .stadic_head_height {
        height: 50px;
        background: #464E78;
    }
    
    .stadic_body_top_bottom {
        top: 70px;
        bottom: 0;
    }
    
    .stadic_right {
        float: left;
        width: 100%;
        height: 100%;
        position: absolute;
        z-index: 100;
    }
    
    .stadic_right .stadic_content {
        overflow: auto;
        margin-right: 406px;
        height: 100%;
        margin-left: 20px;
    }
    
    .stadic_left {
        float: right;
        width: 366px;
        height: 100%;
        position: absolute;
        z-index: 300;
        right: 20px;
    }
    .stadic_flex{
        width: 20px;
        height: 100%;
        position: absolute;
        z-index: 300;
        right: 386px;
        top:20px;
        background-color: #C4CBCE;
    }
    .expand{
        width: 20px;
        height: 100px;
        position: absolute;
        top: 50%;
        left:0;
        margin-top: -50px;
        cursor: pointer;
        background-image: url(${path}/main/skin/frame/default/images/designer-ss-zk.png?V=V6_1_2017-04-13);
        background-position: center;
        background-repeat: no-repeat;
    }
    .expand.zk{
        background-position: 0 0;
    }
    .expand.zk:hover{
        background-position: -20px 0;
    }
    .expand.sq{
        background-position: -40px 0;
    }
    .expand.sq:hover{
        background-position: -60px 0;
    }
    .table_head {
        color: #333;
    }
    
    .table_left1 {
        width: 100px;
        text-align: left;
        padding-right: 10px;
    }
    
    .table_left2 {
        width: 30px;
        text-align: right;
        padding-right: 10px;
    }
    
    .common_tabs {
        height: 40px;
        border-bottom: none;
        margin: 0 auto;
        background: #F6F6F6;
        border-radius: 3px 3px 0 0;
    }
    
    .common_tabs li a {
        width: 183px;
        max-width: 183px;
        padding: 0;
        height: 40px;
        line-height: 40px;
        color: #fff;
        background: #65788F;
        font-size: 14px;
    }
    
    .common_tabs li.tabs_first a {
        border-radius: 3px 0 0 0;
    }
    
    .common_tabs li.tabs_last a {
        border-radius: 0 3px 0 0;
    }
    
    .common_tabs .current a {
        color: #666;
        height: 40px;
        line-height: 40px;
        border: none;
        background: #F6F6F6;
    }
    
    .common_tabs_body {
        background: #F6F6F6;
        margin: 0 auto;
        padding: 0;
    }
    
    .common_tabs_body .show {
        overflow: auto;
        padding: 0 0 0 10px;
    }
    
    .common_button_action {
        vertical-align: middle;
        height: 50px;
        line-height: 50px;
        text-align: right;
        background: #4d4d4d;
        padding: 0 15px 0 10px;
    }
    
    .common_button_action .common_button {
        min-width: 44px;
        height: 28px;
        line-height: 28px;
        text-align: center;
        vertical-align: top;
    }
    
    .common_txtbox_wrap {
        width: 180px;
    }
    
    #editSpacePage_div {
        overflow: hidden;
        background: #fff;
    }

    .UploadListInit{
        padding: 5px 0 10px 0;
        margin:5px 0 0;
        overflow: hidden;
        width: 99px;
    }
    .UploadListInit li{
        margin:7px 0 0 7px;
        text-align: center;
        width: 86px;
        float: left;
    }
    .UploadListInit li img{
        width: 86px;
        height: 86px;
    }
    .UploadListInit li span.deleteThisSkin{
        background: url("/seeyon/common/designer/images/newDesign/sprite.png?V=V6_1_2017-04-13") 0 -38px no-repeat;
        width: 20px;
        height: 20px;
        margin: -58px 1px 0 0;
        position: relative;
        display: block;
        float: right;
    }
    .UploadListInit li span.deleteThisSkin.hidden{
        display: none;
    }
</style>
<script>
    var isToDefault = false;
    var hasDeptManager="0";

    function UploadListInit() {
        $("#UploadListInit li").unbind().bind({
            mouseover: function() {
                $(this).find(".deleteThisSkin").removeClass("hidden");
            },
            mouseleave: function() {
                $(this).find(".deleteThisSkin").addClass("hidden");
            }
        });
    }

    $(document).ready(function() {


        UploadListInit();


        $("#editSpacePage_div,#editSpacePage").height($("#grid_detail").height() - 70 - 50);
        $("#tabs2_body,#tab1_div,#tab2_div").height($("#grid_detail").height() - 70 - 40);
        
        $(window).resize(function(){
            $("#editSpacePage_div,#editSpacePage").height($("#grid_detail").height() - 70 - 50);
            $("#tabs2_body,#tab1_div,#tab2_div").height($("#grid_detail").height() - 70 - 40);
        });
        
        $("skinList")
        window.onbeforeunload = function() {
            if (window.opener && window.opener.getCtpTop()) {
                var _wmp = window.opener.getCtpTop()._windowsMap;
                if(_wmp){
                    _wmp.remove("spaceEdit1");
        	    }
            }
        };
        
        //新建
        <c:if test="${empty param.spaceId}">
            //管理授权清空
            $("#canmanage").comp({
                value: '',
                text: '',
                minSize: 0,
                showRecent: false
            });
            //使用授权清空
            $("#canshare").comp({
                value: '',
                text: '',
                minSize: 0,
                showRecent: false
            });
            $("#sortId").val(getMaxTableSort() + 1);
            $("#toDefaultButton").hide();
            //默认空间类型
            $("#pageName").val("0");
            spaceTypeOnChangeHandler($("#pageName"));
        </c:if>
        //修改
        <c:if test="${not empty param.spaceId}">
            var checkedId = "${param.spaceId}";
            $("#id").val(checkedId);
            new spaceManager().selectSpaceById(checkedId, {
                success: function(spaceAndPage) {
                    $("#id").val(spaceAndPage.id);
                    var spaceName = $.i18n(spaceAndPage.spacename) || spaceAndPage.spacename;
                    $("#spacename").val(spaceName);
                    $("#path").val(spaceAndPage.path);
                    var isDepartment = $("#path").val().indexOf("/department/") != -1;
                    if (isDepartment) {
                    	hasDeptManager=spaceAndPage.hasDepManager;
                        if (${!CurrentUser.admin}) {//部门空间，前端用户不允许修改空间名称
                            $("#spacename").attr("disabled", true);
                        }
                        $("#spaceDeptDes").show();
                    } else {
                        $("#spaceDeptDes").hide();
                    }
                    $("#pageName").empty();
                    var pageName = $.i18n(spaceAndPage.pageName) || spaceAndPage.pageName;
                    $("#pageName").append("<option value='" + spaceAndPage.pageName + "' path='" + spaceAndPage.path + "'>" + pageName + "</option>");
                    $("#pageName").attr("disabled", true);
                    $("#trCanmanage").hide();
                    $("#canmanage_txt").val("");
                    $("#trCanshare").hide();
                    $("#canshare_txt").val("");
                    if (spaceAndPage.canmanage == 1) {
                        $("#trCanmanage").show();
                    }
                    if (${!CurrentUser.admin} && !isDepartment) {//非部门空间，前端用户不允许修改空间管理授权
                        //$("#trCanmanage").attr("disabled", true);
                        //$("#canmanage_txt").attr("disabled", true);
                    }
                    if (spaceAndPage.canshare == 1) {
                        $("#trCanshare").show();
                    }
					//spaceIcon开始
					var iconUrl=spaceAndPage.spaceIcon;
					if(iconUrl){
						var imageAreaStr = 	"<img name='imgIcon' onclick='uploadSapceIcon();' id = 'imgIcon' src='${path}" + iconUrl + "' width='86' height='86'><span class='deleteThisSkin hidden' onclick='deleteIcon();'></span>";
						$("#spaceIcon").val(iconUrl);
						$("#iconDiv1").html(imageAreaStr);
					}
					//结束
                    new spaceSecurityManager().selectSecurityBOBySpaceId(checkedId, {
                        success: function(spaceSecuritys) {
                            $("#canmanage").comp({
                                value: spaceSecuritys[2],
                                text: spaceSecuritys[3],
                                minSize: 0,
                                showRecent: false
                            });
                            $("#canshare").comp({
                                value: spaceSecuritys[0],
                                text: spaceSecuritys[1],
                                minSize: 0,
                                showRecent: false
                            });
                            //更改授权模型
                            showSecurityType(spaceAndPage.path, spaceAndPage.pageId);
                        }
                    });
                    $("#trCanpush").hide();
                    $("#canpush").attr("checked", false);
                    if (spaceAndPage.canpush == 1) {
                        $("#trCanpush").show();
                        if(spaceAndPage.isAllowpushed){
                        	$("#canpush").attr("checked", true);
                        }else{
                        	$("#canpush").attr("checked", false);
                        }
                    }
                    $("#trCanpersonal").hide();
                    $("#canpersonal").attr("checked", false);
                    if (spaceAndPage.canpersonal == 1) {
                        $("#trCanpersonal").show();
                        $("#canpersonal").attr("checked", spaceAndPage.isAllowDefined);
                    }
                    //个人空间5;外部人员空间14;二级主页空间>=19
                    if (spaceAndPage.type == 5 || spaceAndPage.type == 14 || spaceAndPage.type >= 19) {
                        $("#trSpaceState").hide();
                        $("input[name='state']:first").attr("disabled", true);
                        $("input[name='state']:last").attr("disabled", true);
                    } else {
                        $("#trSpaceState").show();
                        if (spaceAndPage.state == 0) {
                            $("input[name='state']:first").attr("checked", true);
                            $("input[name='state']:last").attr("checked", false);
                        } else {
                            $("input[name='state']:first").attr("checked", false);
                            $("input[name='state']:last").attr("checked", true);
                        }
                    }
                    if (${!CurrentUser.admin}) {
                        $("#trSpaceState").attr("disabled", true);
                    }
                    $("#sortId").val(spaceAndPage.sortId);
                    if (spaceAndPage.canusemenu == 1) {
                        $("#canusemenu").val(1);
                        $("#trCanusemenu").show();
                        $("#spacePubinfoEnable").attr("checked", spaceAndPage.spacePubinfoEnable == 1);
                        $("#spaceMenuEnable").attr("checked", spaceAndPage.spaceMenuEnable == 1);
                        if (spaceAndPage.spaceMenuEnable == 1) {
                            $("#trMenuTree").show();
                            $("#menuTR").show();
                            //显示系统菜单
                            showSystemMenuTree(spaceAndPage.id, true);
                        } else {
                            $("#trMenuTree").hide();
                            $("#menuTR").hide();
                        }
                    } else {
                        $("#canusemenu").val(0);
                        $("#trCanusemenu").hide();
                        $("#spacePubinfoEnable").attr("checked", false);
                        $("#spaceMenuEnable").attr("checked", false);
                    }
                    if (spaceAndPage.defaultspace == 1) {
                        $("#toDefaultButton").show();
                    } else {
                        $("#toDefaultButton").hide();
                    }
                    $(".pure-u-1-8").removeClass("space_edit_hover").css("color","");;
                    $("#" + spaceAndPage.decoration).addClass("space_edit_hover").css("color","#fff");;
                    $("#editSpacePage").unbind("load");
                    $("#editSpacePage").attr("src", spaceAndPage.path + "?showState=edit");
                }
            });
        </c:if>
		var isSave="0";
        $("#submitbtn").click(function() {
        	if(isSave=="1"){
				return;
			}
        	if(frames['editSpacePage'].sectionHandler==null||frames['editSpacePage'].sectionHandler==undefined||frames['editSpacePage'].sectionHandler==""){
        		return ;
        	}
        	isSave="1";
            var isEnable = $("input[name='state']:first").attr("checked");
            if ($("#id").val() != "0") {
                if (!isEnable) {
                    var spaceAndPage = new spaceManager().selectSpaceById($("#id").val());
                    if (isCurrentSpaceDefault(spaceAndPage.id, spaceAndPage.type)) {
                        $("input[name='state']:first").attr("checked", true);
                        $("input[name='state']:last").attr("checked", false);
                        $.alert("${ctp:i18n('space.delete.prompt4')}");
                        isSave="0";
                        return;
                    }
                }
            }
            if ($("#pageName").val() == "") {
                $.alert("${ctp:i18n('space.type.select.prompt')}");
                isSave="0";
                return;
            }
            var checkResult = frames['editSpacePage'].sectionHandler.checkEditSection();
            if (checkResult == false) {
            	isSave="0";
                return;
            }
            if($("#path").val().indexOf("/department/") != -1){
            	if(hasDeptManager=="0"&&isEnable){
            		$.alert("${ctp:i18n('space.dept.hasDeptManager')}");
            		isSave="0";
            		return;
            	}
            }
            if($("#spacename").val()==""||$("#spacename").val().length>100||$("#sortId").val()==""||$("#sortId").val()>9999||$("#sortId").val()<-9999||!isNum($("#sortId").val())){
            	$("a[tgt='tab2_div']").click();
            	isSave="0";
            	if(!$(".expand").hasClass("zk")){
            		expandDesigner();
            	}
            }
            if (!$._isInValid($("#grid_detail").formobj())) {
                showMask();
                frames['editSpacePage'].addLayoutDataToForm();
                var editKeyId=frames['editSpacePage'].getLayoutData("editKeyId")
                if(editKeyId==null||editKeyId==""||editKeyId==undefined||editKeyId=="undefined"){
                	isSave="0";
                	return;
                }
                if ($("#spaceMenuEnable").attr("checked") == "checked") {
                    //转换空间关联的菜单数据为Json格式并添加到隐藏域
                    var result = toJsonSpaceMenus();
                    if (!result) {
                        hideMask();
                        isSave="0";
                        return;
                    }
                } else {
                    $("#sysMenuTree").val("");
                }
                var formobj = $("#grid_detail").formobj();
                formobj.state = isEnable ? "0" : "1";
                new spaceManager().transSaveSpace(formobj, {
                    success: function() {
                        hideMask();
                        $.messageBox({
                            'type': 0,
                            'imgType': 0,
                            'msg': $.i18n('common.successfully.saved.label'),
                            ok_fn: function() {
                            	var spaceId = $("#id").val();
                                getParentWindow().getCtpTop().reFlesh(spaceId,true);
                                if (window.opener && window.opener.getCtpTop()) {
                                    var _wmp = window.opener.getCtpTop()._windowsMap;
                                    if(_wmp){
                                        _wmp.remove("spaceEdit1");
                            	    }
                                }
                                isSave="0";
                                window.close();
                            },
                            close_fn: function() {
                            	var spaceId = $("#id").val();
                                getParentWindow().getCtpTop().reFlesh(spaceId,true);
                                if (window.opener && window.opener.getCtpTop()) {
                                    var _wmp = window.opener.getCtpTop()._windowsMap;
                                    if(_wmp){
                                        _wmp.remove("spaceEdit1");
                            	    }
                                }
                                isSave="0";
                                window.close();
                		    }
                        });
                    },
					error: function(e){
						var responseText= e.responseText;
						var msgJson = $.parseJSON(responseText);
                        $.alert(msgJson.message);
						isSave="0";
					}
                });
            }else{
                isSave="0";
            }
        });

        $("#spaceMenuEnable").click(function() {
            var isChecked = $("#spaceMenuEnable").attr("checked");
            if (isChecked) {
                $("#trMenuTree").show();
                $("#menuTR").show();
                var spaceId = $("#id").val();
                if (spaceId != 0 && !isToDefault) {
                    showSystemMenuTree(spaceId, true);
                } else {
                    showSystemMenuTree(null, true);
                }
            } else {
                $("#trMenuTree").hide();
                $("#menuTR").hide();
            }
        });
    });
    
    function isNum(arry){
    	var flag=true;
    	for(var i=0;i<arry.length;i++){
    		var cur = arry[i];    
            if (!/^\d+$/.test(cur)) {    
            	flag = false;    
            }    
    	}
    	return flag;
    }

    //判断当前操作的空间是否是设置的默认空间
    function isCurrentSpaceDefault(currentSpaceId, currentSpaceType) {
        var bool = false;
        var defaultSpaceSettingInfo = null;
        if (${CurrentUser.groupAdmin}) {
            defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForGroup();
        } else if (${CurrentUser.administrator}) {
            defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForAccount($.ctx.CurrentUser.loginAccount);
        }else{
        	return false;
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

    //如果设置的默认空间停用，需要给出提示
    function spaceStopUseHandler() {
        if ($("#id").val() != "0") {
            new spaceManager().selectSpaceById($("#id").val(), {
                success: function(spaceAndPage) {
                    if (isCurrentSpaceDefault(spaceAndPage.id, spaceAndPage.type)) {
                        $("input[name='state']:first").attr("checked", true);
                        $("input[name='state']:last").attr("checked", false);
                        $.alert("${ctp:i18n('space.delete.prompt4')}");
                        return;
                    }
                }
            });
        }
    }

    //选择空间模板  
    function spaceTypeOnChangeHandler(spaceTypeObj) {
        var pathValue = $(spaceTypeObj).find("option:selected").attr("path");
        $("#path").val(pathValue);
        new pageManager().getPage(pathValue, {
            success: function(spacePage) {
                if (spacePage != null) {
                    $("#path").val(spacePage.path);
                    //管理授权清空
                    $("#trCanmanage").hide();
                    $("#canmanage").comp({
                        value: '',
                        text: '${ctp:i18n("common.default.selectPeople.value")}',
                        minSize: 0,
                        showRecent: false
                    });
                    //使用授权清空
                    $("#trCanshare").hide();
                    $("#canshare").comp({
                        value: '',
                        text: '${ctp:i18n("common.default.selectPeople.value")}',
                        minSize: 0,
                        showRecent: false
                    });
                    if (spacePage.canmanage == 1) {
                        $("#trCanmanage").show();
                    }
                    if (spacePage.canshare == 1) {
                        $("#trCanshare").show();
                    }
                    $("#trCanpush").hide();
                    $("#canpush").attr("checked", false);
                    if (spacePage.canpush == 1) {
                        $("#trCanpush").show();
                    }
                    $("#trCanpersonal").hide();
                    if (pathValue.indexOf("/personal_custom") != -1) {//如果是自定义个人空间，默认勾上允许前端用户自定义
                        $("#canpersonal").attr("checked", true);
                    } else {
                        $("#canpersonal").attr("checked", false);
                    }
                    if (spacePage.canpersonal == 1) {
                        $("#trCanpersonal").show();
                    }
                    $("#trCanusemenu").hide();
                    $("#spacePubinfoEnable").attr("checked", false);
                    $("#trMenuTree").hide();
                    $("#spaceMenuEnable").attr("checked", false);
                    if (spacePage.canusemenu == 1) {
                        $("#trCanusemenu").show();
                    }
                    //更改授权模型
                    showSecurityType(spacePage.path, spacePage.id);
                    $(".pure-u-1-8").removeClass("space_edit_hover");
                    $("#" + spacePage.defaultLayoutDecorator).addClass("space_edit_hover");
                    $("#editSpacePage").unbind("load");
                    $("#editSpacePage").attr("src", spacePage.path + "?showState=edit");
                }
            }
        });
    }

    //获取排序号
    function getMaxTableSort() {
        return parseInt(new spaceManager().getMaxSort());
    }

    //恢复默认
    function toDefault() {
        var editKeyId = frames['editSpacePage'].document.getElementById("editKeyId").value;
        var path = $("#path").val();
        var params = new Object();
        params['editKeyId'] = editKeyId;
        params['pagePath'] = path;
        new pageManager().transToDefaultSpace(params, {
            success: function(result) {
                if (result != null) {
                    $("#editSpacePage").unbind("load");
                    $("#editSpacePage").attr("src", path + "?showState=edit&decorationId=" + result + "&editKeyId=" + editKeyId);
                    selectLayoutType(result);
                    deleteIcon();
                }
            }
        });
        isToDefault = true;
        $("#spacePubinfoEnable").attr("checked", false);
        $("#spaceMenuEnable").attr("checked", false);
        $("#trMenuTree").hide();
        $("#menuTR").hide();
    }

    //取消
    function cancelFun() {
        getParentWindow().getCtpTop().reFlesh();
        if (window.opener && window.opener.getCtpTop()) {
            var _wmp = window.opener.getCtpTop()._windowsMap;
            if(_wmp){
                _wmp.remove("spaceEdit1");
    	    }
        }
        window.close();
    }

    //显示系统菜单
    function showSystemMenuTree(spaceId, enable) {
        new spaceManager().getSpaceMenuIds(spaceId, {
            success: function(portalSpaceMenus) {
                if (portalSpaceMenus) {
                    $("#systemMenuTree").tree({
                        idKey: "idKey",
                        pIdKey: "pIdKey",
                        nameKey: "nameKey",
                        enableCheck: true,
                        enableEdit: enable,
                        enableRename: false,
                        enableRemove: false,
                        nodeHandler: function(n) {
                            if (!n.data.icon) {
                                n.isParent = true;
                            }
                            if (n.idKey == "menu_0") {
                                n.open = true;
                            }
                            n.checked = n.data.checked;
                            n.expand = n.data.expand;
                            n.chkDisabled = !enable;
                        }
                    });
                    var setting = $("#systemMenuTree").treeObj().setting;
                    setting.callback = {
                        beforeDrag: beforeDrag,
                        beforeDrop: beforeDrop,
                        beforeExpand: beforeExpand
                    };
                    setting.edit.drag.autoOpenTime = 99999999;
                    setting.edit.drag.inner = false;
                    $.fn.zTree.init($("#systemMenuTree"), setting, portalSpaceMenus);
                }
            }
        });

        function beforeDrag(treeId, treeNodes) {
            if (treeNodes[0].drag === false) {
                return false;
            }
            return true;
        }

        function beforeDrop(treeId, treeNodes, targetNode, moveType) {
            //当前选中节点
            var selectedNode = treeNodes[0];
            if (selectedNode.pIdKey == targetNode.idKey && moveType == "inner") {
                return true;
            }
            if (selectedNode.pIdKey == targetNode.pIdKey && moveType != "inner") {
                return true;
            }
            return false;
        }

        function beforeExpand(treeId, treeNode) {
            return treeNode.expand;
        }
    }

    //显示空间授权模型
    function showSecurityType(path, pageId) {
        var canshareOnlyLoginAccount = true;
        var canmanageOnlyLoginAccount = false;
        if (path.indexOf("/public_custom/") != -1 || path.indexOf("/custom/") != -1 || path.indexOf("/group/") != -1 || path.indexOf("/public_custom_group/") != -1) {
            canshareOnlyLoginAccount = false;
        }
        if (path.indexOf("/corporation/") != -1 || path.indexOf("/department/") != -1 || path.indexOf("/custom") != -1 || path.indexOf("/public_custom/") != -1) {
            canmanageOnlyLoginAccount = true;
        }
        new pageManager().getPageSecurityModels(pageId, {
            success: function(list) {
                if (list != null) {
                    var sharePanelStrVal, shareSelectTypeStrVal, managePanelStrVal, manageSelectTypeStrVal;
                    for (var i = 0; i < list.length; i++) {
                        var securityModel = list[i];
                        if (securityModel.securityType == 1) {
                            //管理授权模型
                            if (securityModel.showType == "panels") {
                                managePanelStrVal = securityModel.showValue;
                            } else {
                                manageSelectTypeStrVal = securityModel.showValue;
                            }
                        } else {
                            //使用授权模型
                            if (securityModel.showType == "panels") {
                                sharePanelStrVal = securityModel.showValue;
                            } else {
                                shareSelectTypeStrVal = securityModel.showValue;
                                //部门空间使用授权允许选择单位根节点
                                if (path.indexOf("/department/") != -1 && shareSelectTypeStrVal.indexOf("Account") < 0) {
                                    shareSelectTypeStrVal = "Account," + shareSelectTypeStrVal;
                                }
                            }
                        }
                    }
                    $("#canmanage").comp({
                        panels: managePanelStrVal,
                        selectType: manageSelectTypeStrVal,
                        onlyLoginAccount: canmanageOnlyLoginAccount,
                        isCanSelectGroupAccount: false,
                        minSize: 0,
                        showRecent: false
                    });
                    $("#canshare").comp({
                        panels: sharePanelStrVal,
                        selectType: shareSelectTypeStrVal,
                        onlyLoginAccount: canshareOnlyLoginAccount,
                        minSize: 0,
                        showRecent: false
                    });
                }
            }
        });
    }

    //前台提交用到的树对象
    function nodeObj(id, parentId, name, url, icon, checked, sort) {
        this.id = id;
        this.parentId = parentId;
        this.name = name;
        this.url = url;
        this.icon = icon;
        this.checked = checked;
        this.sort = sort;
    }

    function toJsonSpaceMenus() {
        var treeObj = $("#systemMenuTree").treeObj();
        var nodesArray = treeObj.transformToArray(treeObj.getNodes());
        var nodes = new Array();
        var checkedNodes = 0;
        for (var i = 0; i < nodesArray.length; i++) {
            var node = nodesArray[i];
            if (node.idKey == "menu_0") {
                continue;
            } else {
                var n = new nodeObj(node.idKey, node.pIdKey, node.nameKey, node.data.urlKey, node.data.iconKey, node.checked, i);
                nodes.push(n);
            }
            if (node.idKey != "menu_0" && node.pIdKey == "menu_0" && node.checked) {
                checkedNodes++;
            }
        }
        if (checkedNodes <= 0) {
            $.alert($.i18n("portal.space.menu.least", 1));
            return false;
        }
        $("#sysMenuTree").val($.toJSON(nodes));
        return true;
    }
    
    //切换布局
    function changLayoutTypeForDD(decoration, index) {
    	var pagePath = frames["editSpacePage"].pagePath;
    	if(pagePath!=null&&pagePath!='undefined'&&pagePath!=undefined){
	        $(".pure-u-1-8").removeClass("space_edit_hover").css("color","");
	        $("#" + decoration).addClass("space_edit_hover").css("color","#fff");
	        frames["editSpacePage"].changLayoutTypeForDD(decoration, index);
    	}
    }
    //选中布局
	function selectLayoutType(decoration) {
	    $(".pure-u-1-8").removeClass("space_edit_hover");
        $("#" + decoration).addClass("space_edit_hover");
	}

    //收起/展开右侧面板
    function expandDesigner(){
        if($(".expand").hasClass("zk")){
            $(".stadic_content").css("margin-right","20px");
            $("#stadic_flex").css("right","0");
            $("#stadic_left_div").hide();
            $(".expand").removeClass("zk").addClass("sq");
        }else{
            $(".stadic_content").css("margin-right","406px");
            $("#stadic_flex").css("right","386px");
            $("#stadic_left_div").show();
            $(".expand").removeClass("sq").addClass("zk");
        }
        
    }
	//先这样等出个删除按钮....
	function uploadSapceIcon(){
		insertAttachment();
	}
    //spaceIcon上传回调函数
    function iconUploadCallback(obj) {
		if(obj!=null){
			var id=obj.instance[0].fileUrl;
			var createdate=obj.instance[0].createDate;
			if(!createdate){
				createdate=obj.instance[0].createdate;//周玲IE看到这个字段是小写的,兼容
			}
			var iconUrl="/fileUpload.do?method=showRTE&fileId="+id+"&createDate="+createdate+"&type=image";
			var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='${path}" + iconUrl + "' width='86' height='86' onclick='uploadSapceIcon();'><span class='deleteThisSkin hidden' onclick='deleteIcon();'></span>";
			$("#spaceIcon").val(iconUrl);
			$("#iconDiv1").html(imageAreaStr);
		}
    }
	function deleteIcon(){
		$("#spaceIcon").val("");
		$("#iconDiv1").html('<img src="/seeyon/main/login/default/images/addChangeImg.png" width="86" height="86" onclick="uploadSapceIcon();">');
	}
</script>
</head>
<body class="h100b over_hidden" style="background: transparent;">
    <div class="stadic_layout form_area" id="grid_detail">
        <div class="stadic_layout_head stadic_head_height">
            <span class="display_inline-block" style="padding:13px 0 0 25px;"><img src="${path}/common/designer/images/newDesign/spaceEdit.gif"/></span><span class="display_inline-block padding_l_15 color_white font_size16" style="line-height:50px; vertical-align: top;">${ctp:i18n("system.menuname.PortalConfig")}</span>
        </div>
        <input type="hidden" id="id" value="0" />
        <input type="hidden" id="defaultspace" value="0" />
        <input type="hidden" id="decoration" value="" />
        <input type="hidden" id="showState" value="" />
        <input type="hidden" id="editKeyId" value="" />
        <input type="hidden" id="toDefault" value="" />
        <input type="hidden" id="canusemenu" value="" />
        <input type="hidden" id="sysMenuTree" value="" />
        <div class="stadic_layout_body stadic_body_top_bottom clearfix">
            <div class="stadic_right">
                <div class="stadic_content">
                    <div class="two_row" id="editSpacePage_div">
                        <iframe width="100%" height="550px" id="editSpacePage" name="editSpacePage" src="${spacePage.path}?decoration=${decoration}&showState=${param.showFlag!='show'?'edit':'show'}&showFlag=${param.showFlag}&editKeyId=${editKeyId}" frameborder="0"></iframe>
                    </div>
                    <div class="common_button_action">
                        <span id="toDefaultButton" class="common_button common_button_emphasize hand left margin_t_10" onclick="toDefault();">${ctp:i18n("space.button.toDefault")}</span>
                        <span id="submitbtn" class="common_button common_button_emphasize hand margin_l_10 margin_t_10">${ctp:i18n("common.button.ok.label")}</span>
                        <span class="common_button common_button_gray hand margin_l_10 margin_t_10" onclick="cancelFun();">${ctp:i18n("common.button.cancel.label")}</span>
                    </div>
                </div>
            </div>
            <div class="stadic_left" id="stadic_left_div">
                <div id="tabs2" class="comp" comp="type:'tab',width:366,showTabIndex:'${empty param.spaceId ? '1' : '0'}'">
                    <div id="tabs2_head" class="common_tabs clearfix margin_b_10">
                        <ul class="left">
                            <li class="current tabs_first"><a href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n("space.tabs.layout")}</span></a></li>
                            <li class="tabs_last"><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n("space.tabs.baseInfo")}</span></a></li>
                        </ul>
                    </div>
                    <div id="tabs2_body" class="common_tabs_body" style="overflow: auto;">
                        <div id="tab1_div">
                            <div class="padding_t_10">
                                <c:forEach items="${allLayout}" var="layoutKey">
                                    <c:forEach items="${layoutTypes[layoutKey]}" var="deco">
                                        <c:set value="${idIndex+1}" var="idIndex" />
                                        <c:set value="channel.logo.version.label${idIndex}" var="versionKey" />
                                        <c:set var="clickStr" value="changLayoutTypeForDD('${deco}', '${idIndex}')"></c:set>
                                        <c:set var="titleStr" value="channel.logo.version.title.${idIndex}"></c:set>
                                        <div id="${deco}" class="pure-u-1-8 align_center space_default_div" style="width:102px; height:82px; margin:10px 0 0 10px;  display:inline-block;padding-top:13px; float:left;" onclick="${clickStr}">
                                            <div id="layout-img-${idIndex}" class="space_edit_layout space_edit_layout_${idIndex}" title="${ctp:i18n(titleStr)}"></div>
                                            <div class="font_12 color_gray2" style="line-height:25px;">${ctp:i18n(versionKey)}</div>
                                        </div>
                                    </c:forEach>
                                </c:forEach>
                            </div>

                        </div>
                        <div id="tab2_div">
                            <div class="two_row" style="padding: 10px 10px 0 10px;">
                                <table border="0" cellspacing="0" cellpadding="0" class="space_default_table">
                                    <tr>
                                        <th class="font_bold font_size14 table_head table_left1">
                                            ${ctp:i18n("space.title.baseInfo")}
                                        </th>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.name")}</label>
                                        </th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="spacename" class="validate" validate="type:'string',name:'${ctp:i18n("space.label.name")}',notNull:true,minLength:1,maxLength:100" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.type")}</label>
                                        </th>
                                        <td>
                                            <select id="pageName" style="width: 192px;display: block; margin:0 auto; height: 24px" onchange="spaceTypeOnChangeHandler(this)">
                                                <c:forEach items="${selectableSpaceTypes}" var="spaceTypeTmp" varStatus="spaceTypeStatus">
                                                <option value="${spaceTypeStatus.index}" path="${spaceTypeTmp.key}">${ctp:i18n(spaceTypeTmp.value)}</option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" id="path" value="" />
                                        </td>
                                    </tr>
                                    <tr id="trCanmanage" style="display: none">
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text">${ctp:i18n("space.manage.auth.label")}</label>
                                        </th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="canmanage" value="" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio:false,hiddenPostOfDepartment:true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="trCanshare" style="display: none">
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text">${ctp:i18n("space.use.auth.label")}</label>
                                        </th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="canshare" value="" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio:false,hiddenPostOfDepartment:true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="trCanpush" style="display: none;">
                                        <th nowrap="nowrap" class="table_left1">
                                            <div class="common_checkbox_box margin_r_5 clearfix">
                                                <input type="checkbox" class="radio_com" id="canpush" name="canpush" value="0" />
                                            </div>
                                        </th>
                                        <td>
                                            <label for="canpush">${ctp:i18n("space.default.todefault.label")}</label>
                                            <label style="color: green;">(${ctp:i18n("space.default.msg")})</label>
                                        </td>
                                    </tr>
                                    <tr id="trCanpersonal" style="display: none;">
                                        <th nowrap="nowrap" class="table_left1">
                                            <div class="common_checkbox_box margin_r_5 clearfix">
                                                <input type="checkbox" class="radio_com" id="canpersonal" name="canpersonal" value="0" />
                                            </div>
                                        </th>
                                        <td>
                                            <label for="canpersonal">${ctp:i18n("space.customize.prompt")}</label>
                                        </td>
                                    </tr>
                                    <tr id="trSpaceState">
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text">${ctp:i18n("space.label.isEnabled")}</label>
                                        </th>
                                        <td>
                                            <div class="common_radio_box clearfix">
                                                <label for="state1" class="margin_r_10">
                                                    <input type="radio" id="state1" name="state" value="0" class="radio_com" checked="checked" />${ctp:i18n("common.state.normal.label")}
                                                </label>
                                                <label for="state2">
                                                    <input type="radio" id="state2" name="state" value="1" class="radio_com" onclick="spaceStopUseHandler()" />${ctp:i18n("common.state.invalidation.label")}
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}</label>
                                        </th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="sortId" class="validate" validate="name:'${ctp:i18n("sortnum.label")}',notNull:true,isInteger:true,min:-9999,max:9999" />
                                            </div>
                                        </td>
                                    </tr>
									<tr>
                                        <th nowrap="nowrap" class="table_left1">
                                            <label for="text">${ctp:i18n("space.label.icon")}</label>
                                        </th>
                                        <td>
                                            <div class="">
                                                <!-- <div id="iconDiv1" class="iconArea" onclick="uploadSapceIcon();"></div> -->

                                                <ul id="UploadListInit" class="UploadListInit clearfix">
                                                    <input type = "hidden" id = "spaceIcon" name = "spaceIcon">
    												<input id="spaceIconUpload" type="hidden" class="comp" comp="type:'fileupload', applicationCategory:'0',extensions:'png,jpg', isEncrypt:false,quantity:1,maxSize: 1048576,canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'iconUploadCallback'" />
                                                                                                
                                                    
                                                    <li class="hand" id="iconDiv1"><img src="/seeyon/main/login/default/images/addChangeImg.png" width="86" height="86" onclick="uploadSapceIcon();"></li>

                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="spaceDeptDes" style="display: none; color: green">
                                        <th class="table_left1">
                                            <label for="text"><b>${ctp:i18n("common.description.label")}</b></label>
                                        </th>
                                        <td>${ctp:i18n("space.dept.description")}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="two_row margin_t_10" style="padding: 10px 10px 0 10px;" id="trCanusemenu" style="display:none;">
                                <table border="0" cellspacing="0" cellpadding="0" class="moreSetting_table">
                                    <tr>
                                        <td class="font_bold font_size14 table_head table_left1">
                                            ${ctp:i18n("space.title.menu")}
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr style="${(ctp:hasPlugin('news') || ctp:hasPlugin('bulletin') || ctp:hasPlugin('bbs') || ctp:hasPlugin('inquiry')) ? '' : 'display:none'}">
                                        <td colspan="2" style="padding:10px 0 0 30px;">
                                            <div class="common_checkbox_box clearfix">
                                                <input type="checkbox" id="spacePubinfoEnable" name="spacePubinfoEnable" class="radio_com" value="1" />
                                                <label for="spacePubinfoEnable">${ctp:i18n("space.menu.pubinfo.enabled")}</label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding:10px 0 0 30px;">
                                            <div class="common_checkbox_box clearfix">
                                                <input type="checkbox" id="spaceMenuEnable" name="spaceMenuEnable" class="radio_com" value="1" />
                                                <label for="spaceMenuEnable">${ctp:i18n("space.menu.enabled")}</label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="trMenuTree" style="display:none">
                                        <td colspan="2" style="padding:10px 0 0 30px;">
                                            <div class="common_checkbox_box clearfix">
                                                <div class="border_all margin_10 bg_color_white">
                                                    <legend><b>${ctp:i18n('space.title.menu')}</b></legend>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr id="menuTR">
                                                            <td>
                                                                <font color="red">*</font>${ctp:i18n('menuManager.menuTree.root.label')}:
                                                                <font color="gray">(${ctp:i18n('menuTree.sort.descoraption.label')})</font>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div id="systemMenuTree"></div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stadic_flex" id="stadic_flex"><span class="expand zk" onClick="expandDesigner()"></span></div>
        </div>
    </div>
</body>
</html>