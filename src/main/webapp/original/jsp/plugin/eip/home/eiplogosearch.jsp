<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="head w">
<c:if test="${fn:contains(columnCodes, 'pl_logo')}">
	<div class="logo fl" id="pl_logo"><a href="#"><img src="#<%-- main/frames/cipPageLayout/layout001/${templateCode}/images/logo.png --%>"></a>企业门户系统</div>
</c:if>
	<form class="h-search fr">
		<!-- <select name="class">
			<option value="volvo" selected="selected">新闻动态</option>
			<option value="saab">行业资讯</option>
			<option value="fiat">今日头条</option>
		</select> -->
		<input type="text" name="search" id="_search" class="search" placeholder="请输入您要检索的内容">
		<input type="button" value="搜 索" class="search-btn" onclick="_eipsearch('');">
	</form>
	<div class="clear"></div>
</div>
<script type="text/javascript">
var columnCodes = "${columnCodes}";
if(columnCodes.indexOf("pl_logo") > -1){
	pl_logo();
}
function pl_logo(){
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_logo";
	var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable="+isEnable+"&columnCode="+columnCode+"&portalCode="+encodeURI(encodeURI("${portalCode}"));
	/* $.ajax({
		url : url,
		data : '',
		type : "POST",
		async : true,
		dataType : 'text',
		success : function(result) {
			if (result) {
				result = $.parseJSON(result);
			}
			var postdetil = result;
			if(postdetil){
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'){
						url = "javascript:void(0)";
					}
					html.append("<a href=\""+url+"\"><img src=\"${path}"+postdetil[i].systemImg+"\"></a>"+postdetil[i].appSystemName);
					break;
				}
				$("#pl_logo").empty();
				$("#pl_logo").append(html.toString());
			}
		}
	}); */
	var postdetil = ajaxController(url,false);
	if(postdetil){
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'){
				url = "javascript:void(0)";
			}else{
				url = "javascript:openUrl('"+url+"')";
			}
			html.append("<a href=\""+url+"\"><img src=\"${path}"+postdetil[i].systemImg+"\"></a>"+postdetil[i].appSystemName);
			break;
		}
		$("#pl_logo").empty();
		$("#pl_logo").append(html.toString());
	}
}

</script>