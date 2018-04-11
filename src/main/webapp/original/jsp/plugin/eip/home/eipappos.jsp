<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 应用系统 ------>
<c:if test="${fn:contains(columnCodes, 'pl_appsystem')}">
<div class="app-os w">
	<c:set var="str" value="${pl_appsystem.columnTitle}" />
	<c:if test="${fn:contains(pl_appsystem.columnTitle, 'pl_')}">
		<c:set var="str" value="eip.service.${fn:replace(pl_appsystem.columnTitle, '_', '')}" />
	</c:if>
	<h1>${ctp:i18n(str)}</h1>
	<ul class="app-os-ul pr-ne" id="pl_appsystem">
	</ul>
</div>
</c:if>
<script type="text/javascript">

function pl_appsystem(){
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_appsystem") > -1)){
		return ;
	}
	var objParam = new Object();
	var isEnable = "0";
	var columnCode = "pl_appsystem";
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
				var urlCol = "${pl_appsystem.moreSetup}";
				if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
					urlCol = "return false;";
				}else{
					urlCol = "openUrl('"+urlCol+"')";
				}
				htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${ctp:i18n(str)}</a>");
				htmlL.append("<ul class=\"s-un\">");
				
				//内容
				var html = new StringBuffer();
				html.append("<div>")
				for(var i=0;i<postdetil.length;i++){
					var url = postdetil[i].columnDetailName;
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						if(url.indexOf("&EIPTicket=")>-1){
							url += toPwd("${loginName}");
						}
						url = "openTicketUrl('"+url+"')";
					}
					html.append("<li class=\"a"+(i+1)+"\"><a onclick=\""+url+"\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
					if(i!=0 && i%14==0){
						html.append("</div><div>")
					}
					
					//栏目
					htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
					if(i==(postdetil.length-1)){
						htmlL.append("</ul>");
					}
					
				}
				html.append("</div>")
				$("#pl_appsystem").empty();
				$("#pl_appsystem").append(html.toString());
				//栏目
				htmlL.append("</li>");
				//htmlL.append("<div class=\"clear\"></div>");
				$("#pl_navbox").append(htmlL.toString());
				
				flashMI4("pl_appsystem");
			}
		}
	});
	/* var postdetil = ajaxController(url,false);
	if(postdetil){
		
		//栏目
		var htmlL = new StringBuffer();
		var urlCol = "${pl_appsystem.moreSetup}";
		if(!urlCol||urlCol==null||urlCol=='null'||urlCol=='#'){
			urlCol = "return false;";
		}else{
			urlCol = "openUrl('"+urlCol+"')";
		}
		htmlL.append("<li><a onclick=\""+urlCol+"\" target=\"_blank\" style=\"cursor: pointer;\" >${pl_appsystem.columnTitle}</a>");
		htmlL.append("<ul class=\"s-un\">");
		
		//内容
		var html = new StringBuffer();
		html.append("<div>")
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "return false;";
			}else{
				if(url.indexOf("&EIPTicket=")>-1){
					url += toPwd("${loginName}");
				}
				url = "openTicketUrl('"+url+"')";
			}
			html.append("<li class=\"a"+(i+1)+"\"><a onclick=\""+url+"\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
			if(i!=0 && i%14==0){
				html.append("</div><div>")
			}
			
			//栏目
			htmlL.append("<li><a onclick=\""+url+"\" target=\"_blank\" style=\"cursor: pointer;\" >"+postdetil[i].appSystemName+"</a></li>");
			if(i==(postdetil.length-1)){
				htmlL.append("</ul>");
			}
			
		}
		html.append("</div>")
		$("#pl_appsystem").empty();
		$("#pl_appsystem").append(html.toString());
		//栏目
		htmlL.append("</li>");
		//htmlL.append("<div class=\"clear\"></div>");
		$("#pl_navbox").append(htmlL.toString());
	} */
	return true;
}
function toArray(str){
    if(typeof str !="string"){
        return [];
    }
    var arr=[];
    for(var i=0;i<str.length;i++){
        arr.push(str.charCodeAt(i));
    }
    
    return arr;
}
function toPwd(str){
	var arr=toArray(str);
	if(arr&&arr.length>0){
		var pwd = "";
		for(var i=0;i<arr.length;i++){
			/* if(i == (arr.length-1)){
				pwd += arr[i];
			}else{
				pwd += arr[i]+"-";
			} */
			pwd += arr[i]+"-";
		}
		
		return pwd;
	}
}
//
function flashMI4(id){
	$('#'+id).owlCarousel({
		items:1,
		pagination:false,
		navigation:true,
		navigationText:["&lt;","&gt;"],
		mouseDrag:false,
		rewindNav:false
	});
}
</script>