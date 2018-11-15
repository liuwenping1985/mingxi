<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <style type="text/css">
	    body{
	        background-color: #f5f5f5;
	    }
	    .h55{
	        height: 55px;
	        line-height: 55px;
	    }
	    .color41{
	        color: #414141;
	        font-size: 16px;
	    }
	    .h37{
	        height: 37px;
	        line-height: 37px;
	    }
	    .bg_color_4d{
	        background-color: #4d4d4d;
	    }
	    .h200{
	        height: 400px;
	    }
	    .h235{
	        height: 35px;
	    }
	    .margin_tb_20{
	        margin-top: 20px;
	        margin-bottom: 20px;
	    }
	    .bg_color_e3{
	        background-color: #e3e3e3;
	    }
	    .one_row{
	        margin-top:20px;
	        margin-left: 30px; 
	    }
	    .margin_l_40{
	        margin-left: 40px;
	    }
	    .work_row{
	        width: 540px;
	        text-align: left;
	        margin-left: 40px;
	    }
	    .common_button{
	        padding: 2px 20px; 
	    }
	    .form_area,.common_checkbox_box{
	        font-size: 14px;
	    }
	</style>
</head>
<body class="over_hidden h100b">
    <div class="h200">
        <div class="bg_color_e3 h55 color41 padding_l_20">${ctp:i18n('everybodyWork.usernamebind') }</div>
        <!-- <iframe src="${temp }" style="border:0; width:100%; height:100%;"></iframe>
        <div class="form_area margin_tb_20">
            <div class="work_row">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <th nowrap="nowrap">
                                <label class="margin_r_10" for="text">大家社区用户名:</label></th>
                            <td width="100%">
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="text18">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap">
                                <label class="margin_r_10" for="text">大家社区密码:</label></th>
                            <td>
                                <div class="common_txtbox_wrap">
                                    <input type="password" id="text19">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div> -->
    </div>
    <div class="h235">
        <div class="bg_color_e3 h37 color41 padding_l_20">${ctp:i18n('everybodyWork.messagelabel') }</div>
        <div class="margin_tb_20">
            <div class="common_checkbox_box clearfix margin_l_40">
                <label class="margin_r_10">${ctp:i18n('everybodyWork.messagetext') }:</label>
                <label for="Checkbox1" class="margin_r_10 hand">
                    <input type="checkbox" value="0" id="Checkbox1" name="option" class="radio_com" checked="checked">${ctp:i18n('everybodyWork.seeyon') }
                </label>
                <label for="Checkbox2" class="margin_r_10 hand">
                    <input type="checkbox" value="0" id="Checkbox2" name="option" class="radio_com" checked="checked">${ctp:i18n('everybodyWork.seeyonorg') }
                </label>
            </div>
        </div>
    </div>
    <!-- <div class="align_center bg_color_4d h55">
        <a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">确定</a>
        <a href="javascript:void(0)" class="common_button common_button_gray">取消</a>
    </div> -->
</body>
</html>
