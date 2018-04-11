<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 秀页面的js文件 --%>
<% 
	if (isDevelop) { //开发模式
%>
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.lazyload-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-praise-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-reply-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-common-util-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/layer-dialog-debug.js${ctp:resSuffix()}"></script>
	<!-- 新建秀圈 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/show-face-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/webuploader/webuploader-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-uploader-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showpost-edit-debug.js${ctp:resSuffix()}"></script>
	<!-- 秀吧列表 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.waterfall-showlist-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showbar-list-debug.js${ctp:resSuffix()}"></script>
	<!-- 照片墙 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.waterfall-photowall-debug.js${ctp:resSuffix()}"></script>
	<!-- 秀圈列表 -->	
	<script type="text/javascript" src="${path }/apps_res/show/js/showpost-list-debug.js${ctp:resSuffix()}"></script>
	<!-- @控件 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.caret-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.atwho-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-at-util-debug.js${ctp:resSuffix()}"></script>
	<%-- 页面头部，搜索秀吧 --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-seach-box-debug.js${ctp:resSuffix()}"></script>
	<%-- 页面头部，秀吧管理员操作 --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-auth-edit-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showpost-transfer-debug.js${ctp:resSuffix()}"></script>
<%
	} else { //产品模式
%>
	<script type="text/javascript" src="${path }/apps_res/show/webuploader/webuploader.min.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-min.js${ctp:resSuffix()}"></script>
<%		
	}
%>
<!--[if lt IE 9]>
	<script type="text/javascript" src="${path}/common/respond/respond.min.js${ctp:resSuffix()}"></script>
<![endif]-->
<%-- 获取组织机构信息 用于@ --%>
<script type="text/javascript" src="${path }/organization/orgIndexController.do?method=index&login=${loginTime}"></script>
<%-- 页头新建秀，刷新页面的js --%>
<script type="text/javascript">
$(function(){
	/* 大秀管理员权限管理 */
	$(".adminSetting").off("click").on("click",function(e){
		$Showauth.openShowauth();
	});
	
	/* 新建随意秀 */
	var  head_new_post;
	var method = getUrlPara("method");
	$(".head_new_post").off("click").on("click",function(){
		if(!head_new_post){
			head_new_post = new showposteidt({
				id:"headnewpost"
			});
		}
		if("showbar" == method && ($(this).attr("viewAll") == true || $(this).attr("viewAll") == "true")){
			//秀吧页面创建当前页面的秀
			var showbarId = $("#showbarId").val();
			head_new_post.openNewShowpost({
				initAnyShow:false,
				showbarId:showbarId,
				success:anyShowSuccess
			});
		}else{
			head_new_post.openNewShowpost({
				initAnyShow:true,
				success:anyShowSuccess
			});
			
		}
	});
	
	if("showbar" != method){
		$(".head_new_post").removeClass("hidden");
	}
	
	/* 新建随意秀后刷新  */
	function anyShowSuccess(){
		//成功后刷新当前页面
		if("showIndex" == method ){
			//秀首页
			var $li = $("#indexTab li.current");
			if($li.hasClass("showcases")){
				//大秀
				showpostList.loadWaterfall();
			}else if($li.hasClass("newest")){
				//主题
				var $lis = $("#indexTab li");
				var $Tabcontent = $("#container .Tabcontent").eq($lis.index($li)); //面板
				showbarList.loadShowbars($Tabcontent);
			}else{
				//照片墙
				$("#photosWaterfall").photowall("refresh");
			}
		}else if("myShow" == method){
			//我的秀吧
			var $li = $("#nyTab li.current");
			var $Tabcontent = $("#container .Tabcontent").eq($("#nyTab li").index($li)); //面板
			if ($li.hasClass("myPhotos")) { //相册
				showpostList.loadWaterfall();
			} else { 
				//[我参与的,我创建的]
				showbarList.loadShowbars($Tabcontent);
			}
		}else if("showbar" == method){
			//秀吧
			var $li = $('#nyTab li.current');
			if($li.hasClass("show_photolist")){
				//照片墙
				$("#containerWaterfall").photowall("refresh");
			}else{
				//秀
				var from = $('#from').val();
				//如果是消息打开，不刷新
				if(!(from == "messageSettop" || from == "messageReply" || from == "messagePraise" || from == "imageViewer" || from == "showpostAt" || from == "showcommentAt" || from == "createShowpost" || from == "showpsotTransfer" )){
					showpostList.loadWaterfall();//不是消息打开
				}else if($("#showpostAll").attr("hasClick") == "true"){
					showpostList.loadWaterfall();//或者消息打开，点击了显示全部
				}
			}
		}
	}
});
</script>
