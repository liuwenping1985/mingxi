<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<style>
<!--

-->
.nav-box ul li a{
	cursor: pointer;
	text-overflow:ellipsis;
	white-space:nowrap;
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
}
</style>
<!--------  导航二级菜单 ------>
<div class="nav-box">
	<ul class="nav pr-ne w" id="pl_navbox">
	</ul>
	<div class="clear"></div>
</div>
<script type="text/javascript">
//pl_navbox();
function pl_navbox(){
		//栏目
		var htmlL = new StringBuffer();
		
		htmlL.append("<li class=\"act nav-h1\"><a href=\"javascript:refresh()\" id=\"_EIPMain\">门户首页</a></li>");
		htmlL.append("<li><a href=\"javascript:openUrl('/seeyon/newsData.do?method=newsIndex&spaceType=&spaceId=&boardId=')\" >新闻动态</a></li>");
		htmlL.append("<li><a href=\"javascript:openUrl('/seeyon/bulData.do?method=bulIndex&typeId=&spaceType=&spaceId=')\" >通知公告</a></li>");
		htmlL.append("<li><a href=\"#\">经营动态</a></li>");
		
		$("#pl_navbox").empty();
		$("#pl_navbox").append(htmlL.toString());
}

//点击按钮调用的方法
function refresh(){
    window.location.reload();//刷新当前页面.
     
    //或者下方刷新方法
    //parent.location.reload()刷新父亲对象（用于框架）--需在iframe框架内使用
    // opener.location.reload()刷新父窗口对象（用于单开窗口
  	//top.location.reload()刷新最顶端对象（用于多开窗口）
}
</script>