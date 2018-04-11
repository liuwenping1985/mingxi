<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 专题 ------>
<c:if test="${fn:contains(columnCodes, 'pl_special')}">
	<c:set var="str" value="${pl_special.columnTitle}" />
	<c:if test="${fn:contains(pl_special.columnTitle, 'pl_')}">
		<c:set var="str" value="eip.service.${fn:replace(pl_special.columnTitle, '_', '')}" />
	</c:if>
<div class="s-dz w" id="pl_special"></div>
</c:if>
<script type="text/javascript">
function pl_special(){
	
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_special") > -1)){
		return ;
	}
	
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_special";
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
				//内容
				var html = new StringBuffer();
				//栏目
				var htmlL = new StringBuffer();
				var urlCol = "${pl_special.moreSetup}";
				if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
					urlCol = "return false;";
				}else{
					urlCol = "openUrl('"+urlCol+"')";
				}
				htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${pl_special.columnTitle}</a>");
				htmlL.append("<ul class=\"s-un\">");
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openUrl('"+url+"')";
					}
					if(i==0){
						html.append("<div class=\"sdz-l sm-til fl\">");
						html.append("<h1>"+postdetil[i].appSystemName+"</h1>");
						html.append("<div class=\"sdz-img\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ><img src=\"${path}"+postdetil[i].systemImg+"\"></a></div></div>");
						
					}else if(i==1){
						html.append("<div class=\"sdz-r sm-til fr\">");
						html.append("<h1>"+postdetil[i].appSystemName+"</h1>");
						html.append("<div class=\"sdz-img\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ><img src=\"${path}"+postdetil[i].systemImg+"\"></a></div></div>");
						//break;
					}
					
					//栏目
					htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
					if(i==(postdetil.length-1)){
						htmlL.append("</ul>");
					}
					
				}
				html.append("<div class=\"clear\"></div>");
				$("#pl_special").empty();
				$("#pl_special").append(html.toString());
				//栏目
				htmlL.append("</li>");
				$("#pl_navbox").append(htmlL.toString());
			}
		}
	}); */
	var postdetil = ajaxController(url,false);
	if(postdetil){
		//内容
		var html = new StringBuffer();
		//栏目
		var htmlL = new StringBuffer();
		var urlCol = "${pl_special.moreSetup}";
		if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
			urlCol = "return false;";
		}else{
			urlCol = "openUrl('"+urlCol+"')";
		}
		htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${ctp:i18n(str)}</a>");
		htmlL.append("<ul class=\"s-un\">");
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "return false;";
			}else{
				url = "openUrl('"+url+"')";
			}
			if(i==0){
				html.append("<div class=\"sdz-l sm-til fl\" style=\"width: 588px;\">");
				html.append("<h1>"+postdetil[i].appSystemName+"</h1>");
				html.append("<div class=\"sdz-img\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ><img src=\"${path}"+postdetil[i].systemImg+"\"></a></div></div>");
				
			}else if(i==1){
				html.append("<div class=\"sdz-r sm-til fr\" style=\"width: 588px;\">");
				html.append("<h1>"+postdetil[i].appSystemName+"</h1>");
				html.append("<div class=\"sdz-img\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ><img src=\"${path}"+postdetil[i].systemImg+"\"></a></div></div>");
				//break;
			}
			
			//栏目
			htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
			if(i==(postdetil.length-1)){
				htmlL.append("</ul>");
			}
			
		}
		html.append("<div class=\"clear\"></div>");
		$("#pl_special").empty();
		$("#pl_special").append(html.toString());
		//栏目
		htmlL.append("</li>");
		$("#pl_navbox").append(htmlL.toString());
	}
}
</script>