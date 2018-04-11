<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 数据看板 ------>
<c:if test="${fn:contains(columnCodes, 'pl_board')}">
<div class="s-kb sm-til w">
	<c:set var="str" value="${pl_board.columnTitle}" />
	<c:if test="${fn:contains(pl_board.columnTitle, 'pl_')}">
		<c:set var="str" value="eip.service.${fn:replace(pl_board.columnTitle, '_', '')}" />
	</c:if>
	<h1>${ctp:i18n(str)}</h1>
	<ul class="skb-ul pr-ne" id="pl_board">
	</ul>
</div>
</c:if>
<script type="text/javascript">
//pl_board();
function pl_board(){
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_board") > -1)){
		return ;
	}
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_board";
	var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable="+isEnable+"&columnCode="+columnCode+"&portalCode="+encodeURI(encodeURI("${portalCode}"));
	$.ajax({
		url : url,
		data : '',
		type : "POST",
		async : false,
		dataType : 'text',
		success : function(result) {
			if (result) {
				result = $.parseJSON(result);
			}
			var postdetil = result;
			if(postdetil){
				
				//栏目
				var htmlL = new StringBuffer();
				var urlCol = "${pl_board.moreSetup}";
				if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
					urlCol = "return false;";
				}else{
					urlCol = "openUrl('"+urlCol+"')";
				}
				htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${ctp:i18n(str)}</a>");
				htmlL.append("<ul class=\"s-un\">");
				
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openUrl('"+url+"')";
					}
					html.append("<li><div class=\"skb-img "+postdetil[i].appIcon+"\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ></a></div><p>"+postdetil[i].appSystemName+"</p></li>");
					
					//栏目
					htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
					if(i==(postdetil.length-1)){
						htmlL.append("</ul>");
					}
					
				}
				$("#pl_board").empty();
				$("#pl_board").append(html.toString());
				//栏目
				htmlL.append("</li>");
				//htmlL.append("<div class=\"clear\"></div>");
				$("#pl_navbox").append(htmlL.toString());
				flashMI0("pl_board");
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil){
		
		//栏目
		var htmlL = new StringBuffer();
		var urlCol = "${pl_board.moreSetup}";
		if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
			urlCol = "return false;";
		}else{
			urlCol = "openUrl('"+urlCol+"')";
		}
		htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${pl_board.columnTitle}</a>");
		htmlL.append("<ul class=\"s-un\">");
		
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "return false;";
			}else{
				url = "openUrl('"+url+"')";
			}
			html.append("<li><div class=\"skb-img "+postdetil[i].appIcon+"\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ></a></div><p>"+postdetil[i].appSystemName+"</p></li>");
			
			//栏目
			htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
			if(i==(postdetil.length-1)){
				htmlL.append("</ul>");
			}
			
		}
		$("#pl_board").empty();
		$("#pl_board").append(html.toString());
		//栏目
		htmlL.append("</li>");
		//htmlL.append("<div class=\"clear\"></div>");
		$("#pl_navbox").append(htmlL.toString());
	} */
}
function flashMI0(id){
	$('#'+id).owlCarousel({
		items:8,
		pagination:false,
		navigation:true,
		navigationText:["&lt;","&gt;"],
		mouseDrag:false,
		rewindNav:false
	});
}
</script>