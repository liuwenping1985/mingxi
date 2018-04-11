<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=thirdpartyUserMapperCfgManager"></script>

<script type="text/javascript">
$().ready(function(){
	var tum = new thirdpartyUserMapperCfgManager();
	$("#btnok").click(function() {
        if($("#thirdAccount").val()=='' || $("#thirdPassword").val()==''){
        	$.alert("外部系统用户或密码不能为空！");
        	return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        try{
        	tum.saveUserMapper($("#addForm").formobj(), {
                 success: function(rel) {
     				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
     				location.href = "cipUserPasswordAuthController.do?method=index&registerId="+$("#registerId").val()+"&accessType="+$("#accessType").val();                
                 },
                 error:function(returnVal){
                   getCtpTop().endProc();
                   var sVal=$.parseJSON(returnVal.responseText);
                   $.alert(sVal.message);
               }
             });
         }catch(e){
        	 alert(e);
         };
        
        				                                                               
    });
	 $("#btncancel").click(function() {
		  location.reload();
	 });
});
</script>

</head>
<body> 
	<form name="addForm" id="addForm" method="post" target="delIframe" class="validate">
    <div class="form_area" >
        <div class="one_row" style="width: 550px; margin-top: 160px;">
        	<input type="hidden" id="registerId" value="${registerId}">
        	<input type="hidden" id="accessType" value="${accessType}">
        	<input type="hidden" id="id" value="-1">
            <table border="0" cellspacing="0" cellpadding="0" style="width: 550px;">
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("cip.service.binding.thirdaccount")}:</label></th>
                   <td>
                    <div class="common_txtbox_wrap">
                            <input type="text" id="thirdAccount" name="thirdAccount" class="w100b validate" validate="notNull:true,name:'${ctp:i18n('cip.service.binding.thirdaccount')}',minLength:1,maxLength:85">
                        </div>
                     </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.service.binding.userpassword')}:</label></th>
                        <td>
                                <div class="common_txtbox_wrap">
                                 <input type="password" id="thirdPassword" name="thirdPassword" class="w100b validate" validate="notNull:false,name:'${ctp:i18n('cip.service.binding.userpassword')}'">
                                </div>
                            </td>
                    </tr>
            </table>
        </div>
        </div>
    </form>
	<div class="stadic_layout_footer stadic_footer_height" style="height: 38px;" >
		<div id="button" align="center" class="page_color button_container">
			<div
				class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
				<a id="btnok" href="javascript:void(0)"
					class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
				<a id="btncancel" href="javascript:void(0)"
					class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
			</div>
		</div>
	</div>

</body>
</html>