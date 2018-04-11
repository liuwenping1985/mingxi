<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="foot" >
	<c:if test="${fn:contains(columnCodes, 'pl_copyright')}">
		<p class="foot-cr" id="pl_copyright"></p>
	</c:if>
	<c:if test="${fn:contains(columnCodes, 'pl_contactway')}">
		<ul id="pl_contactway" > </ul>
	</c:if>
</div>
<script type="text/javascript">
function pl_copyright(){
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_copyright") > -1)){
		return ;
	}
	
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_copyright";
	var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable="+isEnable+"&columnCode="+columnCode+"&portalCode="+encodeURI(encodeURI("${portalCode}"));
	$.ajax({
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
			if(postdetil&&postdetil.length>0){
				
				var html = new StringBuffer();
				//第一条是版权信息
				html.append(postdetil[0].appSystemName);
				$("#pl_copyright").empty();
				$("#pl_copyright").append(html.toString());
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil&&postdetil.length>0){
		
		var html = new StringBuffer();
		//第一条是版权信息
		html.append(postdetil[0].appSystemName);
		$("#pl_copyright").empty();
		$("#pl_copyright").append(html.toString());
	} */
}
//pl_contactway();
function pl_contactway(){
	
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_contactway") > -1)){
		return ;
	}
	
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_contactway";
	var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable="+isEnable+"&columnCode="+columnCode+"&portalCode="+encodeURI(encodeURI("${portalCode}"));
	$.ajax({
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
			if(postdetil&&postdetil.length>0){
				
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "";
					}else{
						url = " onclick=\"openUrl('"+url+"')\" style=\"cursor: pointer;\" ";
					}
					
					html.append("<li>");
					var urlImg = postdetil[i].systemImg;
					if(!(!urlImg||urlImg==null||urlImg=='null'||urlImg=="#")){
						html.append("<p><img "+url+" src=\"${path}"+urlImg+"\" /></p>");
					}
					html.append("<p "+url+">"+postdetil[i].appSystemName+"</p>");
					html.append("</li>");
					
				}
				$("#pl_contactway").empty();
				$("#pl_contactway").append(html.toString());
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil&&postdetil.length>0){
		
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "";
			}else{
				url = " onclick=\"openUrl('"+url+"')\" style=\"cursor: pointer;\" ";
			}
			
			html.append("<li>");
			var urlImg = postdetil[i].systemImg;
			if(!(!urlImg||urlImg==null||urlImg=='null'||urlImg=="#")){
				html.append("<p><img "+url+" src=\"${path}"+urlImg+"\" /></p>");
			}
			html.append("<p "+url+">"+postdetil[i].appSystemName+"</p>");
			html.append("</li>");
			
		}
		$("#pl_contactway").empty();
		$("#pl_contactway").append(html.toString());
	} */
}
</script>