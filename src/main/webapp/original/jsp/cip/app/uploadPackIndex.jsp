<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=appVersionManager"></script>
<script type="text/javascript">
  
$().ready(function() {
	var registerids="${param.registerId}";
	var appIds="${param.appId}";
	$("#registerId").val(registerids);
    $("#appId").val(appIds);
});
 function OK() {
	 
	 if(!($("#appForm").validate())){		
           return false;
    }
	if($("#appFile").val()==""){
		$.alert("请先上传应用包!");
		 return false;
	}
	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();

        try{
			
			 var appManager = new appVersionManager();
             var rs = appManager.saveVersion($("#addForm").formobj());
			 	try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
			 return rs;
         }catch(e){
			
        	 alert(e);
         };
		 	try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
			
			return false;
		  
 }

function uploadCallBack(att){

	$("#appFile").val(att.instance[0].fileUrl);
}
function deleteCallBack(att){
	$("#appFile").val("");
}
function isCallBack(){
	
	if($("#appFile").val()!=""){
		$.alert("一次仅能上传一个应用包");
		return;
	}
	insertAttachmentPoi('att');
}

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">


  
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="appForm" class="form_area">
                        <%@include file="appForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                </div>
            </div>
     
   
</div>
<iframe class="hidden" id="downloadIframe" src=""></iframe>
</body>
</html>