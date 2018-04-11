<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 常用网站 pl-commonsite ------>
<c:if test="${fn:contains(columnCodes, 'pl_commonsite')}">
<div class="s-wz sm-til w">
	<h1>
		<c:set var="str" value="${pl_commonsite.columnTitle}" />
		<c:if test="${fn:contains(pl_commonsite.columnTitle, 'pl_')}">
			<c:set var="str" value="eip.service.${fn:replace(pl_commonsite.columnTitle, '_', '')}" />
		</c:if>
		<div class="n1 nn act">${ctp:i18n(str)}</div>
	</h1>
	<div class="nt-content">
		<div class="nt">
			<div class="wzt wzt pr-ne" id="pl_commonsite">
			</div>
		</div>
	</div>	
</div>
</c:if>
<script type="text/javascript">
//pl_commonsite();
function pl_commonsite(){
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_commonsite") > -1)){
		return ;
	}

	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_commonsite";
	var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&templateCode=${templateCode}&isEnable="+isEnable+"&columnCode="+columnCode+"&portalCode="+encodeURI(encodeURI("${portalCode}"));
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
				var urlCol = "${pl_commonsite.moreSetup}";
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
					html.append("<a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a>");
					
					//栏目
					htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
					if(i==(postdetil.length-1)){
						htmlL.append("</ul>");
					}
					
				}
				$("#pl_commonsite").empty();
				$("#pl_commonsite").append(html.toString());
				//栏目
				htmlL.append("</li>");
				//htmlL.append("<div class=\"clear\"></div>");
				$("#pl_navbox").append(htmlL.toString());
				flashMI2('pl_commonsite');
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil){
	
		//栏目
		var htmlL = new StringBuffer();
		var urlCol = "${pl_commonsite.moreSetup}";
		if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
			urlCol = "return false;";
		}else{
			urlCol = "openUrl('"+urlCol+"')";
		}
		htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${pl_commonsite.columnTitle}</a>");
		htmlL.append("<ul class=\"s-un\">");
		
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "return false;";
			}else{
				url = "openUrl('"+url+"')";
			}
			html.append("<a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a>");
			
			//栏目
			htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
			if(i==(postdetil.length-1)){
				htmlL.append("</ul>");
			}
			
		}
		$("#pl_commonsite").empty();
		$("#pl_commonsite").append(html.toString());
		//栏目
		htmlL.append("</li>");
		//htmlL.append("<div class=\"clear\"></div>");
		$("#pl_navbox").append(htmlL.toString());
	} */
}
function flashMI2(id){
	$('#'+id).owlCarousel({
		items:10,
		pagination:false,
		navigation:true,
		navigationText:["&lt;","&gt;"],
		mouseDrag:false,
		rewindNav:false
	});
}
</script>