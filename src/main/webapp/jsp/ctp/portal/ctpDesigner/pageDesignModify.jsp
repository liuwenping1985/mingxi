<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/jquery-ui.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/default_model.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/icon-pic.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/portalDefaultGlobal.css${ctp:resSuffix()}"/>
<c:choose>
	<c:when test="${ layoutCssPath != null && layoutCssPath ne ''}">
	<link id="v5PageLayoutCss" rel="stylesheet" type="text/css" href="${path}${layoutCssPath}${ctp:resSuffix()}"/>
	</c:when>
	<c:otherwise>
		<link id="v5PageLayoutCss" rel="stylesheet" href="">
	</c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/widgetDefault.css${ctp:resSuffix()}"/>
<c:choose>
	<c:when test="${ layoutSkinPath != null && layoutSkinPath ne ''}">
		<link id="v5PageSkinCss" rel="stylesheet" href="${layoutSkinPath}${ctp:resSuffix()}">
	</c:when>
	<c:otherwise>
		<link id="v5PageSkinCss" rel="stylesheet" href="">
	</c:otherwise>
</c:choose>
<style type="text/css">
    ul.imglist{ margin: 10px; width:320px; overflow:hidden} 
    ul.imglist li{ float:left; padding:4px 8px; width:80px} 
    ul.imglist li img{ display:block; width:80px; height:50px} 
    ul.imglist li span{ display:block; width:100%; height:30px; line-height:30px; background:#F6F6F6;text-align:center} 
</style>
<title>首页设计</title>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_east" layout="width:334,minWidth:334,maxWidth:334,sprit:false,border:false">
    	<div id="tabs2" class="comp" comp="type:'tab',width:330,height:400,showTabIndex:1">
		    <div id="tabs2_head" class="common_tabs clearfix">
		        <ul class="center">
		        	<li><a href="javascript:void(0)" tgt="tab1_div" class="hidden"><span>属性设置</span></a></li>
		            <li class="current"><a href="javascript:void(0)" tgt="tab2_div"><span>风格设置</span></a></li>
		            <li><a href="javascript:void(0)" tgt="tab3_div"><span>基本信息</span></a></li>
		        </ul>
		    </div>
		    <div id="tabs2_body" class="common_tabs_body ">
		        <div id="tab1_div" class="hidden"></div>
		        <div id="tab2_div">
		        	<c:if test="${param.method=='pageDesignModify' }">
		        		<p><a id="reDefaultBtn" href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">恢复默认</a></p>
		        		<ul class="imglist">
		        		<c:forEach items="${skinList}" var="skinitem">
		        			<li>
		        				<a href="#" onclick="javascript:showThemes('${skinitem.value.id}','${ skinitem.value.path}')">
		        					<img src="${path}${ skinitem.value.imagesrc}"/>
		        					<span>${ skinitem.value.name}</span>
		        				</a>
		        			</li>
		        		</c:forEach>
		        		</ul>
		        		<table border="0" style="margin-left: 20px;">
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">头部背景图设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">头部颜色设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">菜单颜色设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">导航字体颜色设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">栏目头部颜色设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">栏目内容区颜色设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">页面背景图设置</a></td></tr>
		        		<tr><td><a href="#" class="common_button common_button_gray right hand" style="margin-top:12px;" onclick="javascript:showThemes('${skinDefault.id}','${ skinDefault.path}')">工作区背景色设置</a></td></tr>
		        		</table>
		        	</c:if>
		        </div>
		        <div id="tab3_div" class="hidden">
		        	<table border="0" style="margin-left: 20px;margin-top:20px;">
		        	<tr><td>页面编号:<input type="text" id="pageCode" name="pageCode" value="${pageLayoutPo.code }"></td></tr>
	    			<tr><td>页面名称:<input type="text" id="pageName" name="pageName" value="${pageLayoutPo.name }"></td></tr>
	    			<tr><td><label style="font-family: none; font-size: 12px;" class="margin_t_5 hand display_block" for="allowTemplateChoose"><input id="allowTemplateChoose" class="radio_com" ${allowTemplateChooseChecked} type="checkbox">允许单位选择布局框架</label></td></tr>
	    			<tr><td><label class="margin_t_5 hand display_block" for="allowHotSpotChoose"><input id="allowHotSpotChoose" class="radio_com" ${allowHotSpotChooseChecked } type="checkbox">允许单位选择皮肤</label></td></tr>
	    			<tr><td><label class="margin_t_5 hand display_block" for="allowHotSpotCustomize"><input id="allowHotSpotCustomize" class="radio_com" ${allowHotSpotCustomizeChecked } type="checkbox">允许单位自定义界面设置</label></td></tr>
	    			<!-- <tr><td><div id="dyncid" style="display: none"></div>
	    			<a href="javascript:void(0)" onclick="importPageLayout();" class="common_button common_button_icon"><em class="ico16 affix_16"></em>上传布局</a></td></tr>-->
		        	</table>
		        </div>
		    </div>
		</div>
    </div>
    <div class="layout_center" layout="sprit:false,border:false" id="v5pagelayoutId">
        
    </div>
    <c:if test="${param.method=='pageDesignNew' }">
    <div class="layout_west" layout="width:150,minWidth:150,maxWidth:150,sprit:false,border:false">
    	<div id="accordion" style="font-size: 12px;">
	    	<c:if test='${ pageLayouts !=null }'>
		    	<h2>首页布局 </h2>
		    	<div>
		    		<c:forEach items="${pageLayouts}" var="item">
		    			<p id="${item.key }" title="单击添加该布局" onclick="addPageLayout('${item.key }');">${ item.value.name} </p>
		    		</c:forEach>
		    	</div>
	    	</c:if>
	    	<h2>首页元件</h2>
	    	<div>
	    		<c:forEach items="${pageComponents}" var="item">
	    			<p id="${item.key }" class="droggable">${ item.value.name}</p>
	    		</c:forEach>
	    	</div>
    	</div>
    </div>
    </c:if>
    <div class="layout_south" layout="height:50,maxHeight:50,minHeight:50,sprit:false,border:false">
		<div style="vertical-align: middle;line-height: 50px;text-align: center;">
	    	<!-- <a href="javascript:void(0)" onclick="previewPageResult();" class="common_button common_button_gray">预览</a> -->
	    	<a href="javascript:void(0)" onclick="savePageData();" class="common_button common_button_gray">确定</a>
	    	<a href="javascript:void(0)" onclick="recoverToDefault();" class="common_button common_button_gray">恢复默认</a>
	    	<a href="javascript:void(0)" onclick="closeDesignerWindow();" class="common_button common_button_gray">取消</a>
    	</div>
    </div>
</div>
</body>
</html>
<script type="text/javascript" charset="UTF-8" src="${path}//common/designer/js/jquery-ui.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery.json.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/uuid.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/ajax.do?managerName=portalDesignerManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/pageDesigner.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var _designerComponentMap = new Object();
var myUuid = uuid.noConflict();
var currentPageId= "${pageId}";
var layout;
var pageId= "${pageId}"
var portalDesignerManager= new portalDesignerManager();
var layoutTempleteId= "-1";
var pageTheme= "";
if(pageId==""){
	currentPageId= myUuid.v4();
}
var templateId= "";
var changeBg= "true";
<c:forEach items="${pageComponents}" var="item">
_designerComponentMap["${item.key }"]= {"id":"${item.value.id}","name":"${ item.value.name}","description":"${ item.value.description}","tplBeanId":"${ item.value.tplBeanId}","tplName":"${ item.value.tplName}","defaultStyle":"${ item.value.defaultStyle}","zone":"${ item.value.zone}"};
</c:forEach>
 $(function () {
	 	//初始化左边导航
	 	$("#accordion").accordion({heightStyle: "content", collapsible: true});
		
	    //dymcCreateFileUpload('dyncid', 0,'zip',1,false,"savePageLayoutAttachment", 'dync99',true,true,null,true,true,51200000);
	    layout = $('#layout').layout();
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
});

</script>
<c:choose>
	<c:when test="${ layoutSkinPath != null && layoutSkinPath ne ''}">
		<script type="text/javascript" id="v5PageLayoutJs" type="text/javascript" charset="UTF-8" src="${path}${layoutJsPath}${ctp:resSuffix()}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" id="v5PageLayoutJs" type="text/javascript" charset="UTF-8" src=""></script>
	</c:otherwise>
</c:choose>