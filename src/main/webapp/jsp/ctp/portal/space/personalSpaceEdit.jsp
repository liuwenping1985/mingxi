<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<style type="text/css">
    .stadic_layout {
        background: #C4CBCE;
    }
    
    .stadic_right {
        float: left;
        width: 100%;
        height: 100%;
        position: absolute;
        z-index: 100;
    }
    
    .stadic_right .stadic_content {
        overflow: hidden;
        margin-right: 406px;
        height: 100%;
        margin-left: 20px;
        background: #fff;
    }
    
    .stadic_left {
        overflow-x: hidden;
        overflow-y: auto;
        float: right;
        width: 366px;
        height: 100%;
        position: absolute;
        z-index: 300;
        right: 20px;
    }
    
    #tabs2 .common_tabs {
        height: 40px;
        border-bottom: none;
        margin: 0 auto;
        background: #F6F6F6;
        border-radius: 3px 3px 0 0;
    }
    
    #tabs2 .common_tabs li a {
        width: 366px;
        max-width: 366px;
        padding: 0;
        height: 40px;
        line-height: 40px;
        color: #fff;
        background: #65788F;
        font-size: 14px;
        border-radius: 3px 3px 0 0;
    }
    
    #tabs2 .common_tabs .current a {
        color: #666;
        height: 40px;
        line-height: 40px;
        border: none;
        color: #fff;
        background: #65788F;
    }
    
    #tabs2 .common_tabs_body {
        background: #F6F6F6;
        margin: 0 auto;
        padding: 0;
    }
    
    #tabs2 .common_tabs_body .show {
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
    
    .notNeed,.notNeed .stadic_layout {
        background: transparent;
    }
</style>
<script>
    $(document).ready(function() {
        $("#editSpacePage_div,#spaceSettingFrame").height($("#stadic_layout").height() - 50);
        $("#tabs2_body,#tab2_div").height($("#stadic_layout").height() - 40);
        $(window).resize(function() {
            $("#editSpacePage_div,#spaceSettingFrame").height($("#stadic_layout").height() - 50);
            $("#tabs2_body,#tab2_div").height($("#stadic_layout").height() - 40);
        });
        
        selectLayoutType("${param.decoration}");
        
        $("#submitbtn").click(function() {
        	var isUpdateSpace = $("#spaceSettingFrame")[0].contentWindow.isUpdateSpace;
        	var pagePath = $("#spaceSettingFrame")[0].contentWindow.pagePath;//操作重要属性,如果不符合要求则不提交
        	if(isUpdateSpace=="1"||isUpdateSpace==null||isUpdateSpace=='undefined'||isUpdateSpace==""||isUpdateSpace==undefined){
        		return;
        	}
        	if(pagePath!=null&&pagePath!='undefined'&&pagePath!=undefined){//防护
	            var result = $("#spaceSettingFrame")[0].contentWindow.isThisSpaceExist();
	            if (!result) {
	                return;
	            }
	            $("#spaceSettingFrame")[0].contentWindow.updateSpace();
        	}
        });
        
        $("#toDefaultBtn").click(function() {
        	var isToDefault = $("#spaceSettingFrame")[0].contentWindow.isToDefault;
			var trueSpaceType = $("#spaceSettingFrame")[0].contentWindow.trueSpaceType;//操作重要属性,如果不符合要求则不提交
        	if(isToDefault=="1"||isToDefault==null||isToDefault=='undefined'||isToDefault==""||isToDefault==undefined){
        		return;
        	}
			if(trueSpaceType!=null&&trueSpaceType!='undefined'&&trueSpaceType!=undefined){
	            $("#spaceSettingFrame")[0].contentWindow.toDefaultPersonal();
			}
        });
        
        $("#cancelbtn").click(function() {
        	if (${param.dialog eq 'true'}) {
        		parent.closeD();
        	}else{
        		parent.close();
        	}
        });
    });

    function reloadPersonalSpace(url,decoration) {
        if (${param.dialog eq 'true'}) {//从首页设计器弹出dialog
            parent.closeD(url,decoration);
        } else {
        	try{
    	    	parent.opener.getCtpTop().onbeforunloadFlag = false;
    	    	parent.opener.getCtpTop().isOpenCloseWindow = false;
    	    	parent.opener.getCtpTop().isDirectClose = false;
    		    var url = _ctxPath + "/main.do?method=changeLoginAccount&accountId=" + $.ctx.CurrentUser.loginAccount+"&isPortalTemplateSwitching=true";
    	    	parent.opener.getCtpTop().location.href = url;
    	    }catch(e){}
    		parent.close();
        }
	}

    //切换布局
    function changLayoutTypeForDD(decoration, index) {
    	var pagePath = $("#spaceSettingFrame")[0].contentWindow.pagePath;
    	if(pagePath!=null&&pagePath!='undefined'){
    		selectLayoutType(decoration);
            $("#spaceSettingFrame")[0].contentWindow.changLayoutTypeForDD(decoration, index);
    	}
    }

    //选中布局
	function selectLayoutType(decoration) {
	    $(".pure-u-1-8").removeClass("space_edit_hover");
        $("#" + decoration).addClass("space_edit_hover");
	}
</script>
</head>
<body class="h100b over_hidden ${param.dialog == 'true' ? 'notNeed' : ''}">
    <div class="stadic_layout" id="stadic_layout">
        <div class="stadic_right">
            <div class="stadic_content">
                <div id="editSpacePage_div">
                    <iframe id="spaceSettingFrame" name="spaceSettingFrame" src="${param.pagePath}?showState=personEdit" width="100%" height="434" border="0px" frameborder="0"></iframe>
                </div>
                <div class="common_button_action">
                    <span id="toDefaultBtn" class="common_button common_button_emphasize hand left margin_t_10">${ctp:i18n("space.button.toDefault")}</span>
                    <span id="submitbtn" class="common_button common_button_emphasize hand margin_l_10 margin_t_10">${ctp:i18n("common.button.ok.label")}</span>
                    <span id="cancelbtn" class="common_button common_button_gray hand margin_l_10 margin_t_10">${ctp:i18n("common.button.cancel.label")}</span>
                </div>
            </div>
        </div>
        <div class="stadic_left">
            <div id="tabs2" class="comp" comp="type:'tab',width:'366'">
                <div id="tabs2_head" class="common_tabs clearfix">
                    <ul class="left">
                        <li class="current"><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n("space.tabs.layout")}</span></a></li>
                    </ul>
                </div>
                <div id="tabs2_body" class="common_tabs_body ">
                    <div id="tab2_div">
                        <div class="padding_t_10 clearfix">
                            <c:forEach items="${allLayout}" var="layoutKey">
                                <c:forEach items="${layoutTypes[layoutKey]}" var="deco">
                                    <c:set value="${idIndex+1}" var="idIndex" />
                                    <c:set value="channel.logo.version.label${idIndex}" var="versionKey" />
                                    <c:set var="clickStr" value="changLayoutTypeForDD('${deco}', '${idIndex}')"></c:set>
                                    <c:set var="titleStr" value="channel.logo.version.title.${idIndex}"></c:set>
                                    <div id="${deco}" class="pure-u-1-8 align_center space_default_div" style="width:102px; height:82px; margin:10px 0 0 10px;  display:inline-block; float:left; padding-top:13px; " onclick="${clickStr}">
                                        <div id="layout-img-${idIndex}" class="space_edit_layout space_edit_layout_${idIndex}" title="${ctp:i18n(titleStr)}"></div>
                                        <div class="font_12 color_gray2" style="line-height:25px;">${ctp:i18n(versionKey)}</div>
                                    </div>
                                </c:forEach>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>