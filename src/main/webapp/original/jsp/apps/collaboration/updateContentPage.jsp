<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    request.setAttribute("editor.enabled","true");
%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html class="h100b over_hidden">
<head>
	<style>
	.stadic_head_height{
		height:30px;
	}
	.stadic_body_top_bottom{
		bottom: 0px;
 		top: 30px;
	}
</style>
<script type="text/javascript">
	//正文组件判断，新建页面
	var bIsContentNewPage = true;
    var isSubmitOperation; //直接离开窗口做出提示的标记位
    var operationObj;
    $(document).ready(function(){
        //debugger;
        //if($.browser.msie && ($.browser.version=='7.0' || $.browser.version=='8.0')){
            operationObj =  getA8Top().updataContentOBJ;
        //}else{
		   // operationObj = window.dialogArguments;
        //}
    	$("#dataDiv").css("overflow","visible");
    	//工具栏
        $("#toolbars").toolbar({
            toolbar: [{
                id: "saveDialog",
                name: "${ctp:i18n('collaboration.updateCopntent.saveAndExit')}",//保存并退出
                className: "ico16 save_up_16",
                click:saveUpdateContent
            },  {
                id: "exitDialog",
                name: "${ctp:i18n('permission.cancel')}",//取消
                className: "ico16 revoked_process_16",
                click:exitCancel
            }]
        });
        try{
        if(operationObj[1]){
	        //alert(window.dialogArguments[1]);
	        $.content.setContent(operationObj[1]);
        }}catch(e){}
    });
    function saveUpdateContent(){
        var content = replaceAll($.content.getContent(),'comp','');
        //operationObj[0].componentDiv.document.zwIframe.$.content.setContent(content);
        if($.browser.mozilla){
        	//fnx_zwIframe =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	    	operationObj[0].componentDiv.document.getElementById("zwIframe").contentWindow.$.content.setContent(content);

         }else{
        	 //zwIframeObj =$(window.componentDiv)[0].document.zwIframe;
        	 operationObj[0].componentDiv.document.zwIframe.$.content.setContent(content);
         }
    	operationObj[0].setFlagto1();
    	setTimeout(function(){
            window.parentDialogObj["dialogUpdate"].close();
        }, 10);
    }
    function replaceAll(htm, a, b) {
      return htm.replace(new RegExp(a, "gm"), b);
    }
    function exitCancel(){
    	operationObj[0].setFlagto0();
        var confirm = $.confirm({
            'msg':"${ctp:i18n('collaboration.common.confirmleave')}",
            ok_fn: function () {
                setTimeout(function(){
                    window.parentDialogObj["dialogUpdate"].close();
                }, 10);
            },
            cancel_fn:function(){
            }
        });
    }


</script>
</head>
<body class="h100b over_hidden">
<form class="h100b" method='post' id="sendForm" name="sendForm" action="collaboration.do?method=saveContent">
	<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height" style="background:#fafafa; padding-left: 15px;height:72px;">
            <div id="toolbars"></div>
        </div>
		<div id="dataDiv" class="stadic_layout_body stadic_body_top_bottom" style="height:0px; background-color: #fafafa;">
			<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
		</div>
	</div>
</form>	
<style>
    /*必须放后面*/
    .cke_wysiwyg_frame{
        display: block;
        margin: 0 auto;
    }
</style>
</body>
</html>