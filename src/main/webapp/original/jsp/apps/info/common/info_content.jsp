<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
var parentWindow = window.dialogArguments;
var isSubmitOperation; //直接离开窗口做出提示的标记位
var tb;
$(document).ready(function() {
	$("#dataDiv").css("overflow","visible");
    //工具栏
    tb = $("#toolbars").toolbar({
    	isPager:false,
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
    if('${viewStateFlag}' =='true'){
    	tb.disabled("saveDialog");
    	tb.disabled("exitDialog");
    }
    if(${opFrom ne 'detail'}){
	    $.content.setContent(parentWindow.getParentContent());
    	$(window).load(function() {
    		try{getMainBodyHTMLDiv$().css("padding-top","0px");}catch(e){}
    	});
    }
});
    
function saveUpdateContent(){
    var content = replaceAll($.content.getContent(),'comp','');
	parentWindow.fillContent(content);
	//parentWindow.contentDiv.$.content.setContent(content);
	parentWindow.contentDialog.close();
}
function replaceAll(htm, a, b) {
  return htm.replace(new RegExp(a, "gm"), b);
}
function exitCancel(){
	//TODO operationObj[0].setFlagto0();
    var confirm = $.confirm({
        'msg':"${ctp:i18n('collaboration.common.confirmleave')}",
        ok_fn: function () {
        	parentWindow.contentDialog.close();
        }, 
        cancel_fn:function(){
        }
    });
}

</script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
                <div id="toolbars"></div>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom">
                <form class="h100b" method='post' id="sendForm" name="sendForm" action="collaboration.do?method=saveContent">
		            <div id="dataDiv" class="h100b content_view">
			            <c:if test="${viewStateFlag == 'true' }">
			                <ul class="view_ul align_left content_view" id='display_content_view'>
	                            <li id="cc" class="view_li">
	                                <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
	                            </li>
	                        </ul>
						</c:if>
						<c:if test="${viewStateFlag == 'false' }">
						   <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
						</c:if>
			        </div>
				</form> 
            </div>
    </div>
</body>
</html>