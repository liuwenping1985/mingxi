<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 轮播图 ------>
<c:if test="${fn:contains(columnCodes, 'pl_Publicity')}">
<div class="bn" id="pl_publicity">
</div>
</c:if>
<script type="text/javascript">
//pl_publicity();
function pl_publicity(){
	var columnCodes = "${columnCodes}";
	if(!(columnCodes.indexOf("pl_Publicity") > -1)){
		return ;
	}
	var columnCode = "pl_Publicity";
	var objParam = new Object();
	var isEnable = "0";
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
					if(!url||url==null||url=='null'||url=='#'){
						url = "return false;";
					}else{
						url = "openUrl('"+url+"')";
					}
					html.append("<img onclick=\""+url+"\" src=\"${path}"+postdetil[i].systemImg+"\" style=\"cursor: pointer;\" >");
				}
				$("#pl_publicity").empty();
				$("#pl_publicity").append(html.toString());
				//flashMI1('pl_publicity');
			}
		}
	}); */
	var postdetil = ajaxController(url,false);
	if(postdetil){
		var html = new StringBuffer();
		for(var i=0;i<postdetil.length;i++){
			var url = postdetil[i].columnDetailName;
			if(!url||url==null||url=='null'||url=='#'){
				url = "return false;";
			}else{
				url = "openUrl('"+url+"')";
			}
			html.append("<img onclick=\""+url+"\" src=\"${path}"+postdetil[i].systemImg+"\" style=\"cursor: pointer;\" >");
		}
		$("#pl_publicity").empty();
		$("#pl_publicity").append(html.toString());
	}
}
function flashMI1(id){
	$('#'+id).owlCarousel({
		items:1,
		autoPlay:true,
		// singleItem:true,
		slideSpeed:10,
		// rewindSpeed:10,
		// paginationSpeed:10,
		// mouseDrag:false
	});
}
</script>