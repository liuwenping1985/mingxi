<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit">
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/jquery-ui.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/default_model.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/icon-pic.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/portalDefaultGlobal.css${ctp:resSuffix()}"/>
<link type="text/css" href="${path}/main/common/css/portal_menuIcon.css${ctp:resSuffix()}" rel="stylesheet" />
<c:choose>
	<c:when test="${ layoutCssPath != null && layoutCssPath ne ''}">
	<link id="v5PageLayoutCss" rel="stylesheet" type="text/css" href="${path}${layoutCssPath}${ctp:resSuffix()}"/>
	</c:when>
	<c:otherwise>
		<link id="v5PageLayoutCss" rel="stylesheet" href="">
	</c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css"  href="/seeyon/main/skin/frame/default/default_common.css${ctp:resSuffix()}">
<c:choose>
	<c:when test="${ layoutSkinPath != null && layoutSkinPath ne ''}">
		<link id="v5PageSkinCss" rel="stylesheet" href="${layoutSkinPath}${ctp:resSuffix()}">
	</c:when>
	<c:otherwise>
		<link id="v5PageSkinCss" rel="stylesheet" href="">
	</c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/pageDesigner.css${ctp:resSuffix()}"/>
<!--[if lte IE 8]>
<style type="text/css">
.top_ico,.top_ico:hover{filter:none;}
.shortcut_nav_item{filter:none;}
</style>
<![endif]-->
<title>${ctp:i18n('menu.page.setting')}</title>
</head>
<body style="margin:0;padding:0;overflow:hidden;">
<input type="hidden" id="pageCode" name="pageCode" value="${pageLayoutPo.code }">
<input type="hidden" id="pageName" name="pageName" value="${pageLayoutPo.name }">
<input type="hidden" id="personHeadImgPath" name="personHeadImgPath" value="${personHeadImgPath}">
<input type="hidden" id="forwardBtn" name="forwardBtn" value="${forwardBtnHotspot.hotspotvalue}">
<input type="hidden" id="backBtn" name="backBtn" value="${backBtnHotspot.hotspotvalue}">
<input type="hidden" id="refreshBtn" name="refreshBtn" value="${refreshBtnHotspot.hotspotvalue}">
<input type="hidden" id="topBgImg" name="topBgImg" value="${topBgImgHotspot.hotspotvalue}" />
<input type="hidden" id="mainBgImg" name="mainBgImg" value="${mainBgImgHotspot.hotspotvalue}" />
<input type="hidden" id="logoImg" name="logoImg" value="${logoImgHotspot.hotspotvalue}">
<input type="hidden" id="isNotShowLogo" name="isNotShowLogo" value="${isNotShowLogo}">
<input type="hidden" id="isNotShowGroup" name="isNotShowGroup" value="${isNotShowGroup}">
<input type="hidden" id="isNotShowAccount" name="isNotShowAccount" value="${isNotShowAccount}">
<div class="bg_color_skin" style="z-index: 9999;width: 320px;">
 <div class="content">
  <ul id="bgColorContainer" class="list clearFix"></ul>
  <ul id="modelListContainer" class="model_list clearFix"></ul>
  <div id="skin_column_op_div" class="clearfix" style="height:30px;line-height:30px;font-size:12px;"><a id="clearColor" class="common_button  common_button_gray margin_t_5">${ctp:i18n('portal.design.empty')}</a> <span id="colorOpacitySpan" style="float:right">${ctp:i18n('portal.design.Opacity')}:<input id="skin_column_op_input" value="100" style="width:25px;"  type="text" maxlength="3" /><span id="skin_column_op_span">%</span></span>
  </div>
 </div>
</div>

<div id='layout' class="comp" comp="type:'layout',border:false" style="background:#C4CBCE;">
	<div class="layout_center" layout="sprit:false,border:false" style="left:20px;">
    	<div id="v5pagelayoutId" style="height: 100%;width: 100%;"></div>
    	<div style="position:relative;">
    		<iframe class="absolute" style="left:0; top:0; z-index:1; width:100% ;height:50px;border:0;"></iframe>
			<div class="common_button_action absolute" style="left:0; top:0; z-index:2; width:100%; padding: 0;">
				<input type="button" id="cancelBtn" onclick="closeDesignerParentWindow();" class="common_button right margin_t_10 common_button_gray margin_r_25" value="${ctp:i18n('link.jsp.cancle')}">
		    	<input type="button" id="submitBtn" onclick="savePageData();" class="common_button right margin_t_10 common_button_emphasize hand margin_r_10" value="${ctp:i18n('link.jsp.sure')}">
			</div>
    	</div>
    </div>

    <div class="layout_east" layout="width:406,sprit:false,border:false">
    	<div id="tabs2" class="comp" comp="type:'tab',width:366,showTabIndex:1">
		    <div id="tabs2_head" style="width:366px; clear:both;" class="common_tabs clearfix">
		        <ul class="center">
		        	<li class="left tabs_first"><a href="javascript:void(0)" tgt="tab1_div" class="hidden"><span>${ctp:i18n('portal.design.ElementProperties')}</span></a></li>
		            <li class="left current"><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n('portal.design.SkinSet')}</span></a></li>
		            <li class="left tabs_last"><a href="javascript:void(0)" tgt="tab3_div"><span>${ctp:i18n('portal.design.basic')}</span></a></li>
		        </ul>
		    </div>
		    <div id="tabs2_body" class="common_tabs_body">
		        <div id="tab1_div" class="tabs2_body_div hidden">
		        </div>
		        <div id="tab2_div" class="tabs2_body_div hidden">
		        	<div class="description"><span class="left">${ctp:i18n('portal.design.SkinSet.RecommendColor')}</span><c:if test='${changeSkin == true || changeBg== true}'><a id="reDefaultBtn" class="common_button hand" href="#" onclick="recoverToDefault();">${ctp:i18n('portal.design.SkinSet.ResetColor')}</a></c:if>
		        	</div>
		        		<c:if test="${systemProductId != '7'}"><%--A6-s不支持换肤--%>
		        			<div class="skin_list_div">
			        		<ul class="skin_list clearfix <c:if test='${changeSkin == false }'>noSkinPermissio</c:if>">
			        		<c:forEach items="${skinList}" var="skinitem">
			        			<li <c:if test='${skinitem.value.id == theme }'>class="skin_current"</c:if>>
			        				<a <c:if test='${changeSkin == true }'> href="#" onclick="javascript:showThemes('${skinitem.value.id}','${ skinitem.value.path}')"</c:if>>
			        					<c:if test='${changeSkin == false }'>
			        						<img src="${path}${ skinPathMap[skinitem.value.id]}"/>
			        					</c:if>
			        					<c:if test='${changeSkin == true }'>
			        						<img src="${path}${ skinitem.value.imagesrc}"/>
			        					</c:if>
			        					<span>${ ctp:i18n(skinitem.value.name)}</span>
			        				</a>
			        			</li>
			        		</c:forEach>
			        		</ul>
			        		</div>
			        		<div class="moreSetting hand"><span class="left hand" id="show_moreSetting"><span class="seting_arrow seting_arrow_open"></span>${ctp:i18n('portal.design.SkinSet.MoreSettings')}</span></div>
			        		<table border="0" cellspacing="0" cellpadding="0" id="moreSetting_table" class="moreSetting_table">
			        		
			        		<tr><td class="group_head">${ctp:i18n('portal.design.SkinSet.MoreSettings.head')}</td></tr>
			        		<tr><td class="group_in">${ctp:i18n('portal.design.SkinSet.MoreSettings.bgcolor')}<a href="#" class="pickColor skin_head_color"></a></td></tr>
			        		<tr><td class="group_in">${ctp:i18n('portal.design.SkinSet.MoreSettings.fontcolor')}<a href="#" class="pickColor skin_head_fontColor"></a></td></tr><!-- 新功能未做 -->
			        		<tr><td class="group_in">${ctp:i18n('portal.design.SkinSet.MoreSettings.head.bgpic')}<input onclick="setTopBgImg();" type="text" value="${ctp:i18n('portal.design.SkinSet.MoreSettings.head.uploadPic')}" id="topBgImgDisplayInput" readonly name="topBgImgDisplayInput" class="hand path_text"><span class="hidden ico16 skin_head_img_remove"></span>
			        		</td></tr>
			        		<c:if test="${pageLayoutTemplete.id != 'layout007'}">
			        		<tr><td class="group_head">${ctp:i18n('portal.design.SkinSet.MoreSettings.Navigation')}</td></tr>
			        		<tr><td class="group_in">${ctp:i18n('portal.design.SkinSet.MoreSettings.bgcolor')}<a href="#" class="pickColor skin_nav_color"></a></td></tr><!-- 原：菜单颜色设置 -->
			        		<tr><td class="group_in">${ctp:i18n('portal.design.SkinSet.MoreSettings.fontcolor')}<a href="#" class="pickColor skin_nav_fontColor"></a></td></tr><!-- 新功能未做 -->
							</c:if>
							<tr><td class="group_head">${ctp:i18n('portal.design.SkinSet.MoreSettings.column')}</td></tr>
							<tr id="spaceNavDiv"><td class="group_in"><span class="group_in_key">${ctp:i18n('portal.design.SkinSet.MoreSettings.column.color1')}</span><a href="#" class="pickColor bread_font_color"></a></td></tr><!-- 原：面包屑文字颜色设置 -->
							<tr><td class="group_in"><span class="group_in_key">${ctp:i18n('portal.design.SkinSet.MoreSettings.column.color2')}</span><a href="#" class="pickColor skin_column_color"></a></td></tr><!-- 原：栏目头部颜色设置 -->
							<tr><td class="group_in"><span class="group_in_key">${ctp:i18n('portal.design.SkinSet.MoreSettings.column.color3')}</span><a href="#" class="pickColor skin_column_bgColor"></a></td></tr><!-- 新功能未做 -->
							<tr><td class="group_in"><span class="group_in_key">${ctp:i18n('portal.design.SkinSet.MoreSettings.column.color4')}</span><a href="#" class="pickColor skin_column_fontColor"></a></td></tr><!-- 新功能未做 -->
							<tr><td class="group_in"><span class="group_in_key">${ctp:i18n('portal.design.SkinSet.MoreSettings.column.color5')}</span><a href="#" class="pickColor skin_sectionContent_color"></a></td></tr><!-- 原：栏目内容区颜色设置 -->
			        		
			        		<tr><td class="group_head">${ctp:i18n('portal.design.SkinSet.MoreSettings.bg')}</td></tr>
			        		<tr><td class="group_in"><span class="group_in_key1">${ctp:i18n('portal.design.SkinSet.MoreSettings.bg.bgPic')}</span><input onclick="setMainBgImg();" type="text" value="${ctp:i18n('portal.design.SkinSet.MoreSettings.head.uploadPic')}" id="mainBgImgDisplayInput" readonly name="mainBgImgDisplayInput" class="hand path_text2"><span class="hidden ico16 skin_mainBody_img_remove"></span><span class="common_button common_button_new hand" onclick="showOnlineMainBgImgDialog();">${ctp:i18n('portal.design.onlineimp')}</span>
			        		</td></tr>
			        		<tr><td class="group_in"><span class="group_in_key1">${ctp:i18n('portal.design.SkinSet.MoreSettings.bg.bgcolor')}</span><a href="#" class="pickColor skin_mainBody_color"></a></td></tr>
			        		</table>
		        		</c:if>
		        		<input id="hiddenLogoImg" type="hidden" />
		        		<input id="hiddenTopBgImg" type="hidden" />
		        		<input id="hiddenMainBgImg" type="hidden" />
		        </div>
		        <div id="tab3_div" class="tabs2_body_div hidden">
		        	<div class="tabs_body_div">
			        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    			<tr><td class="tabs_body_div_line">
		    			<label class="margin_t_5 hand display_block" for="spanNavControl"><input id="spanNavControl" <c:if test='${changeBg == false }'>disabled</c:if> <c:if test="${spaceNavDisplay=='true' }">checked</c:if> class="radio_com" ${allowHotSpotCustomizeDisabled}  type="checkbox" ondblclick="setSpanNavControl(this,'spaceNav');" onclick="setSpanNavControl(this,'spaceNav');">${ctp:i18n('portal.design.basic.pos')}</label>
		    			<input type="hidden" name="spaceNav" id="spaceNav" value="${spaceNavDisplay}">
		    			</td></tr>
		    			<tr><td class="tabs_body_div_line"><label class="margin_t_5 hand display_block" for="setDefault"><input id="setDefault" class="radio_com ${allowTemplateChooseFontDisabled }" ${setDefault} ${allowTemplateChooseDisabled }  type="checkbox">${ctp:i18n('portal.design.basic.setDefault')}</label></td></tr>
		    			<c:if test="${isCurrentUserGroup=='true' }">
			    			<tr><td class="tabs_body_div_line"><label class="margin_t_5 hand display_block" for="allowHotSpotChoose"><input id="allowHotSpotChoose" class="radio_com ${allowHotSpotChooseFontDisabled }" ${allowHotSpotChooseChecked } ${allowHotSpotChooseDisabled } type="checkbox">${ctp:i18n("portal.skin.allowunit.choose")}${ctp:i18n("portal.design.home.skin")}</label></td></tr>
			    			<tr><td class="tabs_body_div_line"><label class="margin_t_5 hand display_block" for="allowHotSpotCustomize"><input id="allowHotSpotCustomize" class="radio_com ${allowHotSpotCustomizeFontDisabled }" ${allowHotSpotCustomizeChecked } ${allowHotSpotCustomizeDisabled } type="checkbox">${ctp:i18n("portal.skin.allowunit.customize")}${ctp:i18n("portal.design.home.element")}</label></td></tr>
		    			</c:if>
		    			<c:if test="${isCurrentUserAdministrator=='true' }">
			    			<c:if test="${systemProductId != '7'}"><%--A6-s支持持logo图片上传 --%>
				    			<tr><td class="tabs_body_div_line"><label class="margin_t_5 hand display_block" for="allowHotSpotChoose"><input id="allowHotSpotChoose" class="radio_com ${allowHotSpotChooseFontDisabled }" ${allowHotSpotChooseChecked } ${allowHotSpotChooseDisabled } type="checkbox">${ctp:i18n("portal.skin.allowuser.choose")}${ctp:i18n("portal.design.home.skin")}</label></td></tr>
				    			<tr><td class="tabs_body_div_line"><label class="margin_t_5 hand display_block" for="allowHotSpotCustomize"><input id="allowHotSpotCustomize" class="radio_com ${allowHotSpotCustomizeFontDisabled }" ${allowHotSpotCustomizeChecked } ${allowHotSpotCustomizeDisabled } type="checkbox">${ctp:i18n("portal.skin.allowuser.customize")}${ctp:i18n("portal.design.home.element")}</label></td></tr>
				    			<tr><td class="tabs_body_div_line"><div style="margin-right:17px; margin-top:30px; padding:15px 0; border-top: 1px solid #ccc;"><label class="margin_t_5 hand display_block" for="allowTemplateChoose"><input id="allowTemplateChoose" class="radio_com ${allowTemplateChooseFontDisabled }" ${allowTemplateChooseChecked} ${allowTemplateChooseDisabled } type="checkbox">${ctp:i18n("portal.skin.allowuser.choose")}${ctp:i18n("portal.design.home.layout")}</label></div></td></tr>
				    		</c:if>
		    			</c:if>
		    			<c:if test="${isCurrentUserGroup=='true' }">
		    			<tr><td class="tabs_body_div_line"><div style="margin-right:17px; margin-top:30px; padding:15px 0; border-top: 1px solid #ccc;"><label class="margin_t_5 hand display_block" for="allowTemplateChoose"><input id="allowTemplateChoose" class="radio_com ${allowTemplateChooseFontDisabled }" ${allowTemplateChooseChecked} ${allowTemplateChooseDisabled } type="checkbox">${ctp:i18n("portal.skin.allowunit.choose")}${ctp:i18n("portal.design.home.layout")}</label></div></td></tr>
		    			</c:if>
			        	</table>
		      		</div>
		        </div>
		    </div>
		</div>
    </div>
</div>
</body>
</html>
<script type="text/javascript" src="${path}/ajax.do?managerName=sectionManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}//common/designer/js/jquery-ui.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery.json.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/uuid.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/ajax.do?managerName=portalDesignerManager,portalTemplateManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/pageDesigner.js${ctp:resSuffix()}"></script>
<!-- IE7文档模式不支持json，引用插件 -->
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/json2.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var isCanEditSpace= "${isCanEditSpace}";
var personalSpaceUrl= "${personalSpaceUrl}";
var personalSpaceDecorator = "${personalSpaceDecorator}";
var personalSpaceName= escapeStringToHTML("${personalSpaceName}");
var totalDisplayWidth= "${totalDisplayWidth}";
var totalDisplayHeight= "${totalDisplayHeight}";
portalTemplateManagerObject = new portalTemplateManager();
var isDialog= "${param.isDialog}"
var templateId= "${templateId}";
var defaultTemplateId= "${defaultTemplateId}";
var _designerComponentMap = new Object();
var myUuid = uuid.noConflict();
var currentPageId= "${pageId}";
var layout;
var portalDesignerManager= new portalDesignerManager();
var layoutTempleteId= "-1";
var pageTheme= "";
var i18n_toDefault = "${ctp:i18n('channel.button.toDefault')}";
var i18n_adminsavePrompt= "${ctp:i18n('portal.skin.adminsave.prompt')}";
var saveSuccessfully= "${ctp:i18n('common.successfully.saved.label')}";
var changeBg= "${changeBg}";
var changeSkin= "${changeSkin}";
var changeTemplate= "${changeTemplate}";
var isCurrentUserAdministrator= "${isCurrentUserAdministrator}";
var isAdmin= "${isAdmin}";
var hasChangeSkinStyle = false;
var hasChangeHotSpots = false;
var hasChangeHotSpotChoose = false;
var hasChangeHotSpotCustomize = false;
var selfSetI18N= "${ctp:i18n('hr.staffInfo.selfSet.label')}";
var currentAccountId= "${currentAccountId}";
var isChangePersonHeadImage= false;
if('en'==_locale){
	$("#mainBgImgDisplayInput").css("width","130px");
}
var isChange= true;
if( changeBg=="false" && changeSkin=="false" && changeTemplate=="false"){
	isChange= false;
}

<c:forEach items="${pageComponents}" var="item">
_designerComponentMap["${item.key }"]= {"id":"${item.value.id}","name":"${ item.value.name}","description":"${ item.value.description}","tplBeanId":"${ item.value.tplBeanId}","tplName":"${ item.value.tplName}","defaultStyle":"${ item.value.defaultStyle}","zone":"${ item.value.zone}"};
</c:forEach>

//初始化背景图片
var topBgImg = '${topBgImgHotspot.hotspotvalue}';
var logoImg = '${logoImgHotspot.hotspotvalue}';
var mainBgImg = '${mainBgImgHotspot.hotspotvalue}';
if(parent.fileUrlId && changeBg=="true"){
	mainBgImg= "fileUpload.do?method=showRTE&fileId=" + parent.fileUrlId + "&type=image";
	$("#mainBgImg").attr("value",mainBgImg);
}
//初始化颜色值
var topBgColor = {color : '${topBgColorHotspot.hotspotvalue}', colorOpacity : '${(topBgColorHotspot==null || topBgColorHotspot.ext5=="")?"100":topBgColorHotspot.ext5}', colorList : '${topBgColorHotspot.ext7}', colorIndex : '${topBgColorHotspot.ext8}'};
var lBgColor = {color : '${lBgColorHotspot.hotspotvalue}', colorOpacity : '${(lBgColorHotspot==null || lBgColorHotspot.ext5=="")?"100":lBgColorHotspot.ext5}', colorList : '${lBgColorHotspot.ext7}', colorIndex : '${lBgColorHotspot.ext8}'};
var cBgColor = {color : '${cBgColorHotspot.hotspotvalue}', colorOpacity : '${(cBgColorHotspot==null||cBgColorHotspot.ext5=="")?"100":cBgColorHotspot.ext5}', colorList : '${cBgColorHotspot.ext7}', colorIndex : '${cBgColorHotspot.ext8}'};
var mainBgColor = {color : '${mainBgColorHotspot.hotspotvalue}', colorOpacity : '${(mainBgColorHotspot==null || mainBgColorHotspot.ext5=="")?"100":mainBgColorHotspot.ext5}', colorList : '${mainBgColorHotspot.ext7}', colorIndex : '${mainBgColorHotspot.ext8}'};
var breadFontColor = {color : '${breadFontColorHotspot.hotspotvalue}', colorOpacity : '${(breadFontColorHotspot==null||breadFontColorHotspot.ext5=="")?"100":breadFontColorHotspot.ext5}', colorList : '${breadFontColorHotspot.ext7}', colorIndex : '${breadFontColorHotspot.ext8}'};
var sectionContentColor = {color : '${sectionContentColorHotspot.hotspotvalue}', colorOpacity : '${(sectionContentColorHotspot==null || sectionContentColorHotspot.ext5=="")?"100":sectionContentColorHotspot.ext5}', colorList : '${sectionContentColorHotspot.ext7}', colorIndex : '${sectionContentColorHotspot.ext8}'};
//头部区：文字颜色
var topFontColor = {color : '${topFontColorHotspot.hotspotvalue}', colorOpacity : '${ (topFontColorHotspot==null || topFontColorHotspot.ext5=="")?"100":topFontColorHotspot.ext5}', colorList : '${topFontColorHotspot.ext7}', colorIndex : '${topFontColorHotspot.ext8}'};
//头部区：头部区高度
var topHeight = {color : '${topHeightHotspot.hotspotvalue}', colorOpacity : '${topHeightHotspot.ext5}', colorList : '${topHeightHotspot.ext7}', colorIndex : '${topHeightHotspot.ext8}'};
//导航区：文字颜色
var lFontColor = {color : '${lFontColorHotspot.hotspotvalue}', colorOpacity : '${(lFontColorHotspot==null || lFontColorHotspot.ext5=="")?"100":lFontColorHotspot.ext5}', colorList : '${lFontColorHotspot.ext7}', colorIndex : '${lFontColorHotspot.ext8}'};
//栏目区：栏目头部背景颜色
var sectionHeadBgColor = {color : '${sectionHeadBgColorHotspot.hotspotvalue}', colorOpacity : '${(sectionHeadBgColorHotspot==null || sectionHeadBgColorHotspot.ext5=="")?"100":sectionHeadBgColorHotspot.ext5}', colorList : '${sectionHeadBgColorHotspot.ext7}', colorIndex : '${sectionHeadBgColorHotspot.ext8}'};
//栏目区：栏目头部文字颜色
var sectionHeadFontColor = {color : '${sectionHeadFontColorHotspot.hotspotvalue}', colorOpacity : '${(sectionHeadFontColorHotspot==null || sectionHeadFontColorHotspot.ext5=="")?"100":sectionHeadFontColorHotspot.ext5}', colorList : '${sectionHeadFontColorHotspot.ext7}', colorIndex : '${sectionHeadFontColorHotspot.ext8}'};

var systemProductId= "${systemProductId}";
var maxTopHeightValue= 50;
var maxSpaceNum= "${maxSpacesNum}";
var maxMenuNum= "${maxMenusNum}";

function mainLoadReset(){
	if(personalSpaceUrl && personalSpaceUrl.indexOf("linkSystemController.do")>=0){//关联系统空间，不执行下面的方法
		return;
	}
	var spaceWindow = $("#main")[0].contentWindow;
	if(spaceWindow && spaceWindow.$){
		<c:choose>
			<c:when test="${ layoutSkinPath != null && layoutSkinPath ne ''}">
				spaceWindow.$("#mainSkinCss").attr("href","${layoutSkinPath}${ctp:resSuffix()}&uuid="+getUUID());
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
	}
	try{
		setContentAreabgc(sectionContentColor.color, sectionContentColor.colorOpacity);
	}catch(e){}
	try{
		resetSectionTabColor(cBgColor.color, cBgColor.colorOpacity / 100);
	}catch(e){}
	try{
		resetSectionTabBgColor(sectionHeadBgColor.color, sectionHeadBgColor.colorOpacity);
	}catch(e){}
	try{
		resetSectionTabFontColor(sectionHeadFontColor.color, sectionHeadFontColor.colorOpacity);
	}catch(e){}	
	try{
		//隐藏滚动条
		hiddenSpaceContentScroll();
	}catch(e){}
}

$(function () {
	setTab1_div();
	$("#mainSkinCss").remove();
	<c:if test="${spaceNavDisplay=='false' }">
		hiddenSpaceNavDiv();
	</c:if>
	if( topHeight && topHeight.color && topHeight.color!="" && topHeight.color>50){
		maxTopHeightValue= Number(topHeight.color);
	}
    layout = $('#layout').layout();

    //重新修改布局属性
    function selfAdaption() {
    	$("#layout .layout_center").css({
	    	"left":"20px",
	    	"width":$("#layout .layout_center").width()-20
	    });
	    $("#v5pagelayoutId").css({
	    	"height":$("#east1").height()-50,
	    	"overflow":"hidden"
	    });

	    var rightNewHeight = $("#east1").height()-$("#tabs2_head").height();
	    $("#tabs2_body").height(rightNewHeight);
	    $(".tabs2_body_div").height(rightNewHeight-20);
	    $("#v5pagelayout").css({
	    	"overflow":"hidden"
	    });
    }
    selfAdaption();
	$(window).resize(function(){
		selfAdaption();
	});
    

    <c:if test="${pageLayoutTemplete ne null}">
	    var name= "${pageLayoutTemplete.name}";
	    var htmlContent= '${htmlContent}';
	    pageTheme= "${theme}";
	    
	    layoutTempleteId= "${pageLayoutTemplete.id}";
	    
	    $("#v5pagelayoutId").html(htmlContent);//布局HTML
	    
	    initV5PageLayout();
	    
	    <c:forEach items="${componentsMap}" var="item">
	    	var lastestBox= $("#${item.key}");
	    	var dragthis_id= '${item.value.id}';
	    	var s_dragthis_id= '${item.value.scid}';
	    	var res= '${item.value.htmlContent}';
	    	var cName= '${item.value.name}';
	    	var tplBeanId= '${item.value.beanId}';
	    	var cTplName= '${item.value.tplName}';
	    	var cStyle= '${item.value.defaultStyle}';
	    	addComponentToBox(lastestBox,dragthis_id,s_dragthis_id,res,cName,tplBeanId,cTplName,cStyle);
	    </c:forEach>
	    
	    countLayoutSize();
	    
    </c:if>
  	//logo可以自定义上传，在这里绑定上传事件
    dymcCreateFileUpload("hiddenLogoImg",1,"jpg,jpeg,gif,bmp,png",1,false,"logoImgUploadCallBack", "poiLogoImg",true,true,null,false,true,512000);
  	//横幅可以自定义上传，在这里绑定上传事件
    dymcCreateFileUpload("hiddenTopBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"topBgImgUploadCallBack", "poiTopBgImg",true,true,null,false,true,512000);
 	//大背景图可以自定义上传，在这里绑定上传事件
    dymcCreateFileUpload("hiddenMainBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"mainBgImgUploadCallBack", "poiMainBgImg",true,true,null,false,true,2048000);
 	
    var topBgColorIndexObj= getColorIndexArray(topBgColor.color);
    topBgColor.colorList= topBgColorIndexObj[0];
    topBgColor.colorIndex= topBgColorIndexObj[1];

    var lBgColorIndexObj= getColorIndexArray(lBgColor.color);
    lBgColor.colorList= lBgColorIndexObj[0];
    lBgColor.colorIndex= lBgColorIndexObj[1];

    var cBgColorIndexObj= getColorIndexArray(cBgColor.color);
    cBgColor.colorList= cBgColorIndexObj[0];
    cBgColor.colorIndex= cBgColorIndexObj[1];

    var mainBgColorIndexObj= getColorIndexArray(mainBgColor.color);
    mainBgColor.colorList= mainBgColorIndexObj[0];
    mainBgColor.colorIndex= mainBgColorIndexObj[1];

    var breadFontColorIndexObj= getColorIndexArray(breadFontColor.color);
    breadFontColor.colorList= breadFontColorIndexObj[0];
    breadFontColor.colorIndex= breadFontColorIndexObj[1];

    var sectionContentColorIndexObj= getColorIndexArray(sectionContentColor.color);
    sectionContentColor.colorList= sectionContentColorIndexObj[0];
    sectionContentColor.colorIndex= sectionContentColorIndexObj[1];

    var topFontColorIndexObj= getColorIndexArray(topFontColor.color);
    topFontColor.colorList= topFontColorIndexObj[0];
    topFontColor.colorIndex= topFontColorIndexObj[1];

    var lFontColorIndexObj= getColorIndexArray(lFontColor.color);
    lFontColor.colorList= lFontColorIndexObj[0];
    lFontColor.colorIndex= lFontColorIndexObj[1];

    var sectionHeadBgColorIndexObj= getColorIndexArray(sectionHeadBgColor.color);
    sectionHeadBgColor.colorList= sectionHeadBgColorIndexObj[0];
    sectionHeadBgColor.colorIndex= sectionHeadBgColorIndexObj[1];

    var sectionHeadFontColorIndexObj= getColorIndexArray(sectionHeadFontColor.color);
    sectionHeadFontColor.colorList= sectionHeadFontColorIndexObj[0];
    sectionHeadFontColor.colorIndex= sectionHeadFontColorIndexObj[1];
 	
    setTopBgColor(topBgColor.color, topBgColor.colorOpacity);
    setMainBgColor(mainBgColor.color,mainBgColor.colorOpacity);
    setNavMenuColor(lBgColor.color, lBgColor.colorOpacity);
    setBreadFontColor(breadFontColor.color,breadFontColor.colorOpacity);

    //新增
    setTopFontColor(topFontColor.color, topFontColor.colorOpacity);
    setNavMenuFontColor(lFontColor.color, lFontColor.colorOpacity);

    $("#main").load(function(){
    	mainLoadReset();
	});
    if($("#spaceNav").attr("value")=="true"){
    	$("#nowLocation").show();
    }else{
    	$("#nowLocation").hide();
    }
    if(logoImg!=""){
    	$("#logo").attr("src",_ctxPath + "/"+logoImg);
    	$("#logo").load(function(){
    		  handleLogoImg();
    	});
    }
    if(topBgImg != ""){
		$(".skin_head_img_remove").show();
		showTopBgImg(_ctxPath + "/"+topBgImg);
		$("#topBgImgDisplayInput").attr("value",_ctxPath + "/"+topBgImg);
	} else {
		$(".skin_head_img_remove").hide();
		$("#v5headerarea").css("background-image", "none");
	}
	if(mainBgImg != ""){
		$(".skin_mainBody_img_remove").show();
		$(".warp").css("background-image", "url(\'" + _ctxPath + "/" + mainBgImg + "\')");
		$("#mainBgImgDisplayInput").attr("value",_ctxPath + "/"+mainBgImg);
	} else {
		$(".skin_mainBody_img_remove").hide();
		$(".warp").css("background-image", "none");
	}

	//换肤面板 、更多设置
    $(".moreSetting").click(function() {
    	if($(this).find(".seting_arrow_open").length==0){
    		$(this).find(".seting_arrow").addClass('seting_arrow_open');
    		$("#moreSetting_table").show();
    	}else{
			$(this).find(".seting_arrow").removeClass('seting_arrow_open');
    		$("#moreSetting_table").hide();
    	}
    });

    //默认收起
    $(".moreSetting").click();

	$(".li_widget").hover(
		function(){
			var li_widget_width = $(this).width()-2;
			var li_widget_height = $(this).height()-2;
			var cid= $(".widges",this).attr("cid");
			var scid= $(".widges",this).attr("scid");
			if(!$(this).find(".li_widget_hover").length&&!$(this).find(".li_widget_click").length&&!$(this).parents("#v5body").length){
				
				if(isAdmin=="true"){
					if( scid=="PAGE_C002" || scid=="PAGE_C014" ||　scid=="PAGE_C004" || scid=="PAGE_C010"
							|| scid=="PAGE_C005" || scid=="PAGE_C011" || scid=="PAGE_C013" 
							|| scid=="PAGE_C006" || scid=="PAGE_C012" || scid=="PAGE_C008"
							|| scid=="PAGE_C015" ){//这些元件除外
						$(this).prepend('<div class="li_widget_disable" style="width:'+li_widget_width+'px;height: '+li_widget_height+'px;"></div>');
						return;
					}
				}else{
					if( scid=="PAGE_C001" ){//这些元件除外
						$(this).prepend('<div class="li_widget_disable" style="width:'+li_widget_width+'px;height: '+li_widget_height+'px;"></div>');
						return;
					}
				}
				$(this).prepend('<div class="li_widget_hover" onclick="addHoverDivClickEvent(\''+cid+'\')" style="width:'+li_widget_width+'px;height: '+li_widget_height+'px;"></div>');
			}
		},
		function(){
			$(this).find(".li_widget_hover,.li_widget_disable").remove();
		}
	);
	
	$(".space_column_content").bind({
		mouseenter:function(){
			var SimpleDialog_widget_width = $(this).width()-4;
			var SimpleDialog_widget_height = $(this).height()-4;
			if(!$(this).find(".li_widget_click").length){
				$(".li_widget_hover,.li_widget_disable").remove();
				if( isAdmin=="true" || isCanEditSpace== "false" ){
				 	$(this).prepend('<div class="li_widget_disable" style="width:'+SimpleDialog_widget_width+'px;height: '+SimpleDialog_widget_height+'px;"></div>');
				}else{
					$(this).prepend('<div class="li_widget_hover" style="width:'+SimpleDialog_widget_width+'px;height: '+SimpleDialog_widget_height+'px;"><span class="setColumnBtn">${ctp:i18n("space.Section.setting")}</span></div>');
						$(".setColumnBtn").bind('click',function(){
							var thisNew = $(this);
							showMoreColumn(thisNew);
						});
				}
			}
		},  
		mouseleave:function(){
			$(this).find(".li_widget_hover,.li_widget_disable").remove();
		}
	});
	
	$("#nowLocation .nowLocation_content").html(personalSpaceName);

	<c:if test="${spaceNavDisplay=='true' }">
		$("#v5body").css("margin-top","6px");
	</c:if>
	<c:if test="${spaceNavDisplay=='false' }">
		$("#v5body").css("margin-top","10px");
	</c:if>
});
getCtpTop().cBgColor= cBgColor;
getCtpTop().sectionHeadBgColor= sectionHeadBgColor;
getCtpTop().sectionContentColor= sectionContentColor;
getCtpTop().sectionHeadFontColor= sectionHeadFontColor;
if(isAdmin=="true"){
	getCtpTop().isCurrentUserAdmin= true;
}else{
	getCtpTop().isCurrentUserAdmin= false;
}

getCtpTop().systemProductId= systemProductId;

function disableDesignerButtons(){
	$("#cancelBtn").attr("disabled","disabled");
	$("#submitBtn").attr("disabled","disabled");
}

function enableDesignerButtons(){
	$("#cancelBtn").removeAttr("disabled");
	$("#submitBtn").removeAttr("disabled");
}
</script>
<c:choose>
	<c:when test="${ layoutSkinPath != null && layoutSkinPath ne ''}">
		<script type="text/javascript" id="v5PageLayoutJs" type="text/javascript" charset="UTF-8" src="${path}${layoutJsPath}${ctp:resSuffix()}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" id="v5PageLayoutJs" type="text/javascript" charset="UTF-8" src=""></script>
	</c:otherwise>
</c:choose>