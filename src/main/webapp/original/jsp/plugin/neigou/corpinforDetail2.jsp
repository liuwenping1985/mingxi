<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=neigouCorpinforManager"></script>
<style type="text/css">
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
	.title{
		padding: 6pt;
	}
</style>
<script type="text/javascript">
$().ready(function() {
    var corpinforManager=new neigouCorpinforManager();
	var corpinfor = corpinforManager.viewNeigouCorpinfor(null);
	if(corpinfor.id!=null){
		$("#addForm").fillform(corpinfor);
		$("#pointTable").show();
	}else{
		$("#pointTable").hide();
	}
	$("#orgAccountId").comp({
        value: corpinfor.orgAccountId,
        text: corpinfor.accountName
      });
	$("#btnok").click(function() {
	    if(!($("#addForm").validate())){
	      return;
	    }
	  //var reg = new RegExp("[><'\"#$%&]","i");  // 创建正则表达式对象。
        var reg = new RegExp("[<>+<;'\/,.~`&#@%$]","i");  // 创建正则表达式对象。<>+<;'\/,.~` 
    	var  r = $("#contactName").val().match(reg);
    	if(r!=null){
    		$.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.contactname')}");
    		return ;
    	}
    	var myreg = /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
        if (!myreg.test($("#contactEmail").val())) {
        	$.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.email')}");
    		return;
        }
        if(!/^1[34578][0-9]{9}$/.test($("#contactPhone").val())){ 
        	$.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.phone')}"); 
            return;
          }
	    if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
	    corpinforManager.saveNeigouCorpinfor($("#addForm").formobj(), {
	        success: function(rel) {
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				location.reload();
	        }
	    });
	});
	$("#btncancel").click(function() {
		if(corpinfor.id!=null){
			$("#addForm").fillform(corpinfor);
		}
		$("#orgAccountId").comp({
	        value: corpinfor.orgAccountId,
	        text: corpinfor.accountName
	      });
	});
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_neigou_corpinfordetail'"></div>
	<form name="addForm" id="addForm" method="post" target="addDeptFrame" style="">
	<div class="form_area" >
		<div class="one_row" style="width:700px;margin-top: 60px;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="orgAccountId"   class="comp validate" disabled="disabled" comp="type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',showMe:false,returnValueNeedType:false"
                                                validate="type:'string',notNull:true,minLength:1,maxLength:255,name:'${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}'">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('neigou.plugin.neigoucorpinfor.loginname') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountLogin" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.loginname') }"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactName') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactName" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactName') }"
									validate="notNull:true,minLength:1,maxLength:15">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactPhone')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactPhone" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactPhone')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactEmail') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactEmail" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactEmail') }"
									validate="notNull:true,minLength:1,maxLength:50">
							</div>
						</td>
						<!-- <th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>企业地址:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="address" class="validate word_break_all" name="企业地址"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td> -->
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;企业充值:</label></th>
						<td width="45%">
							<a target="_blank" href="http://hd.neigou.com/Publicize/zhiyuanV5Charge">http://hd.neigou.com/Publicize/zhiyuanV5Charge</a>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.statues') }:</label></th>
						<td width="45%">
							<div class="common_radio_box clearfix">
							    <label for="radio1" class="margin_r_10 hand">
							        <input type="radio" value="1" id="statues" name="option" class="radio_com">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.on') }</label>
							    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="radio2" class="margin_r_10 hand">
							        <input type="radio" value="0" id="statues" name="option" class="radio_com">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.off') }</label>
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.worktimelimit') }:</label></th>
						<td width="45%">
							<div class="common_radio_box clearfix">
							    <label for="isControl" class="margin_r_10 hand" >
							        <input type="radio"   value="1" id="isControl" name="isControl" checked="checked"  class="radio_com isControl1">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.on') }</label>
							    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="radio2" class="margin_r_10 hand">
							        <input type="radio" value="0" id="isControl" name="isControl" class="radio_com isControl2">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.off') }</label>
							</div>
							
						</td>
					</tr>
					<tr>
						<td align="right" colspan="4"><span style="float: right;"><font color="#008000">${ctp:i18n('neigou.plugin.neigoucorpinfor.limitremark') }</font></span>
						</td>
					</tr>
				</tbody>
			</table>
			<br>
			<br>
			<div  style="width: 90%;border: 0px; margin-left: 30px;" class="form_area" align="center">
							<table id="pointTable"  border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="35%" class="title">${ctp:i18n('neigou.plugin.neigoucorpinfor.rechargepoint') }</td>
				        		<td width="35%" class="title" >${ctp:i18n('neigou.plugin.neigoucorpinfor.assignpoint') }</td>
				        		<td width="30%" class="title" >${ctp:i18n('neigou.plugin.neigoucorpinfor.useablepoint') }</td>
				        	</tr>
				        	<tr>
				        		<td width="35%"><div class="common_txtbox_wrap">
								<input type="text" id="rechargePoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.rechargepoint') }">
								</div></td>
                                   <td width="35%"><div class="common_txtbox_wrap">
								<input type="text" id="grantPoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.assignpoint') }">
								</div></td>
								<td width="30%"><div class="common_txtbox_wrap">
								<input type="text" id="companyPoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.useablepoint') }">
								</div></td>
				        	</tr>
				        </table>
				        </div>
		</div>
		</div>
	</form>
	
	<div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
	
	</div>


</body>
</html>