<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
<script type="text/javascript">
function OK(param){
    return selectColumnsIFrame.getAllItenValue(null);
}

function publish(){
    getCtpTop().showMenu("${path}/portal/portalController.do?method=personalInfoFrame&path=/portal/spaceController.do?method=showSpacesSetting");
}
function cancelPublish(){
	var fsm = new formSectionManager();
	var sectionId = "${ffmyform.id}";
	fsm.doCancelPublish(sectionId,false,{success:function(data){
		if(data == "true"){
			changePublish(false);
		}else{
		  $.messageBox({
	        'type' : 0,
	        'msg' : '${ctp:i18n('formsection.infocenter.cancelconfig.error')}',
	        ok_fn : function() {
	        }
	      });
		}
	}});
}
function changePublish(display){
	if(!display){
		$("#publish").show();
		$("#cancelPublish").hide();
	}else{
		$("#cancelPublish").show();
		$("#publish").hide();
	}
}
</script>
</head>
<body style="overflow: hidden;">
    <fieldset class="margin_10" style="text-align: center;">
        <legend>${ctp:i18n('formsection.config.homepage.column') }</legend>
        <table>
        	<tr><td>
        <%@ include file="formSectionColumn.jsp" %>
        	</tr></td>
        	<tr>
        	<td colspan="4" align="left" class="bg-advance-bottom" height="22">
                 <a class="common_button common_button_gray" id="publish" href="javascript:publish()" style="display: ${(isPublish eq false) ?'':'none'}">${ctp:i18n('formsection.config.homepage.publish') }</a>
                 <a class="common_button common_button_gray" id="cancelPublish" href="javascript:cancelPublish()" style="display: ${(isPublish eq false) ?'none':''}">${ctp:i18n('formsection.config.homepage.cancel') }</a>
                </td>
        	</tr>
        </table>
    </fieldset>
</body>
</html>