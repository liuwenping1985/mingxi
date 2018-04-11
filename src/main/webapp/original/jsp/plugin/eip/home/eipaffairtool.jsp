<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 
<!-------- 我的待办 我的发起  我的查询  ------>
		<div class="sml-content">
				<c:if test="${fn:contains(columnCodes, 'pl_affair')}">
			<div class="sml-menu">
			<c:set var="str" value="${pl_affair.columnTitle}" />
			<c:if test="${fn:contains(pl_affair.columnTitle, 'pl_')}">
				<c:set var="str" value="eip.service.${fn:replace(pl_affair.columnTitle, '_', '')}" />
			</c:if>
			<span class="sml-m-l">${ctp:i18n(str)}</span>
			<ul class="sml-nav pr-ne fl" id="pl_affair">
				</ul>
				
				<div class="clear"></div>
			</div>
				</c:if>
				<c:if test="${fn:contains(columnCodes, 'pl_launch')}">
			<div class="sml-menu">
				<c:set var="str" value="${pl_launch.columnTitle}" />
				<c:if test="${fn:contains(pl_launch.columnTitle, 'pl_')}">
					<c:set var="str" value="eip.service.${fn:replace(pl_launch.columnTitle, '_', '')}" />
				</c:if>
				<span class="sml-m-l">${ctp:i18n(str)}</span>
				<ul class="sml-nav pr-ne fl" id="pl_launch">
				</ul><!--url绑定 &penBoxType=0为打开新窗口/1为弹出窗口 -->
				<a href="javascript:openBoxUrl('${ctp:i18n(str)}','${pl_launch.moreSetup}')" class="fr">更多 &gt;</a>
				<div class="clear"></div>
			</div>
				</c:if>
				<c:if test="${fn:contains(columnCodes, 'pl_query')}">
			<div class="sml-menu">
				<c:set var="str" value="${pl_query.columnTitle}" />
				<c:if test="${fn:contains(pl_query.columnTitle, 'pl_')}">
					<c:set var="str" value="eip.service.${fn:replace(pl_query.columnTitle, '_', '')}" />
				</c:if>
				<span class="sml-m-l">${ctp:i18n(str)}</span>
				<ul class="sml-nav pr-ne fl" id="pl_query">
				</ul>
				<div class="clear"></div>
			</div>
				</c:if>
		</div>
		
<script type="text/javascript">

//pl_affair();
function pl_affair(){
	var columnCodes = "${columnCodes}";
	if(columnCodes.indexOf("pl_affair") == -1){
		return ;
	}
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_affair";
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
			if(postdetil){
				//内容
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
					}
					var s = postdetil[i].appSystemName.length>4?postdetil[i].appSystemName.substring(0,3)+"...":postdetil[i].appSystemName;
					html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a target=\"_blank\" onclick=\""+url+"\" style=\"cursor: pointer;\" title=\""+postdetil[i].appSystemName+"\" ></a></div><span style=\"word-break:break-all;\" title=\""+postdetil[i].appSystemName+"\">"+s+"</span></li>");
				}
				$("#pl_affair").empty();
				$("#pl_affair").append(html.toString());
				flshMI("pl_affair");
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil){
		//内容
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'){
				url = "return false;";
			}else{
				//权限判断
				var b = judgePower(url);
				if(!b){
					continue;
				} 
				url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
			}
			html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a target=\"_blank\" onclick=\""+url+"\" style=\"cursor: pointer;\" ></a></div><span>"+postdetil[i].appSystemName+"</span></li>");
		}
		$("#pl_affair").empty();
		$("#pl_affair").append(html.toString());
	} */
}

//pl_launch();
function pl_launch(){
	var columnCodes = "${columnCodes}";
	if(columnCodes.indexOf("pl_launch") == -1){
		return ;
	}
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_launch";
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
			if(postdetil && postdetil.length){
				//内容
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
					}
					var s = postdetil[i].appSystemName.length>4?postdetil[i].appSystemName.substring(0,3)+"...":postdetil[i].appSystemName;
					html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a target=\"_blank\" onclick=\""+url+"\" style=\"cursor: pointer;\"  title=\""+postdetil[i].appSystemName+"\"></a></div><span style=\"word-break:break-all;\" title=\""+postdetil[i].appSystemName+"\">"+s+"</span></li>");
				}
				$("#pl_launch").empty();
				$("#pl_launch").append(html.toString());
				flshMI("pl_launch");
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil && postdetil.length){
	
		//内容
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'){
				url = "return false;";
			}else{
				url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
			}
			html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a target=\"_blank\" onclick=\""+url+"\" style=\"cursor: pointer;\" ></a></div><span>"+postdetil[i].appSystemName+"</span></li>");
		}
		$("#pl_launch").empty();
		$("#pl_launch").append(html.toString());
		
	} */
}

//pl_query();
function pl_query(){
	var columnCodes = "${columnCodes}";
	if(columnCodes.indexOf("pl_query") == -1){
		return ;
	}
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_query";
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
			if(postdetil){
				//内容
				var html = new StringBuffer();
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
					}
					var s = postdetil[i].appSystemName.length>4?postdetil[i].appSystemName.substring(0,3)+"...":postdetil[i].appSystemName;
					html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\"  title=\""+postdetil[i].appSystemName+"\"></a></div><span style=\"word-break:break-all;\" title=\""+postdetil[i].appSystemName+"\">"+s+"</span></li>");
				}
				$("#pl_query").empty();
				$("#pl_query").append(html.toString());
				flshMI("pl_query");
			}
		}
	});
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
			
		}
	}); */
	/* var postdetil = ajaxController(url,false);
	if(postdetil){
		//内容
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'){
				url = "return false;";
			}else{
				url = "openBoxUrl('"+postdetil[i].appSystemName+"','"+url+"')";
			}
			html.append("<li><div class=\"n-q "+postdetil[i].appIcon+"\"><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" ></a></div><span>"+postdetil[i].appSystemName+"</span></li>");
		}
		$("#pl_query").empty();
		$("#pl_query").append(html.toString());
	} */
	return true;
}
/* 临时权限判断 */
var power = new Array();
function judgePower(url){
	if(power.length<1){
		var menu = window.parent.$.ctx.menu;
		var t = 0;
		for(i=0; i<menu.length; i++){
			var item = menu[i].items;
			for(j=0; j<item.length; j++){
				if(item[j].items){
					var itemz = item[j].items;
					for(m=0; m<itemz.length; m++){
						var resourceCode = itemz[m].resourceCode;
						var name = itemz[m].name;
						var url0 = itemz[m].url;
						power[t]=resourceCode+"$"+url0;t++;
						console.log("name:"+name+";resourceCode:"+resourceCode+";url:"+url0);
					}
				}else{
					var resourceCode = item[j].resourceCode;
					var name = item[j].name;
					var url0 = item[j].url;
					power[t]=resourceCode+"$"+url0;t++;
					console.log("name:"+name+";resourceCode:"+resourceCode+";url:"+url0);
				}
			}
		}
	}
	if(url && url.indexOf("&_resourceCode=")>-1){
		for(i=0; i<power.length; i++){
			var powers = power[i].split("$");
			if(url.indexOf(powers[0])>-1&&url.indexOf(powers[1])>-1){
				return true;
			}
		}
	}
	return false;
}
//
function flshMI(id){
	$('#'+id).owlCarousel({
		items:5,
		pagination:false,
		navigation:true,
		navigationText:["&lt;","&gt;"],
		mouseDrag:false,
		rewindNav:false
	});
};

</script>