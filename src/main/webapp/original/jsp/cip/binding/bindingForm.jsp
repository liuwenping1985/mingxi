<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<style type="text/css">
<!--
.iconArea {
	float: left;
	border: 1px solid #CCC;
	height: 75px;
	width: 75px;
	margin-right:10px;
}
-->
</style>
<body>
    <form name="addForm" id="addForm" method="post" target="" class="validate">
    <div class="form_area" >
        <div class="one_row" style="width:50%;">
            <table border="0" cellspacing="0" cellpadding="0">
            <input type="hidden" id="id" name="id" value="-1">
                     
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n("cip.service.binding.colluser")}:</label></th>
                        <td width="100%">
                                <input type="text" id="memberLoginName" name="memberLoginName" class="w100b validate"  validate="name:'${ctp:i18n('cip.service.binding.colluser')}',notNull:true"/>
                                <input type="hidden" id="memberId" name="memberId"/>
                                <input type="hidden" id="registerId" name="registerId"/>
                        </td>
                    </tr>
                   
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n("cip.service.binding.collcode")}:</label></th>
                        <td width="100%" >
                            <input type="text" id="memberCode" name="memberCode" class="w100b">
                         </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n("cip.service.binding.thirdaccount")}:</label></th>
                   <td width="100%" >
                            <input type="text" id="thirdAccount" name="thirdAccount" class="w100b validate" validate="notNull:true,name:'${ctp:i18n('cip.service.binding.thirdaccount')}'">
                         </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("cip.service.binding.thirdcode")}:</th>
                        <td width="100%">
                                <div class="common_checkbox_box clearfix ">
                                 <input type="text" id="thirdCode" name="thirdCode" class="w100b validate">
                                </div>
                            </td>
                    </tr>
            </table>
        </div>
        </div>
    </form>
</body>
</html>