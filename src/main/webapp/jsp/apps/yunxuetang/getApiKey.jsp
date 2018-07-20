<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
<div id="getApiForm" class="form_area">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="font_size12 margin_t_10">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="95%">
                    <tr height="40">
                        <td width="10" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="90" class="padding_t_10"><font color="red">*</font>机构名称：</td>
                        <td width="300" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="yxtOrgName" name="yxtOrgName" value="" class="validate" validate="type:'string',name:'机构名称',notNull:true,notNullWithoutTrim:'true'" />
                            </div>
                        </td>
                        <td width="10" class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr height="40">
                        <td width="10" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="90" class="padding_t_10"><font color="red">*</font>机构域名：</td>
                        <td width="300" class="padding_t_10">
                            <div class="left margin_r_5">http://</div>
                            <div class="common_txtbox_wrap left" style="width: 165px;">
                                <input type="text" id="yxtDomainName" name="yxtDomainName" value="" class="validate" validate="type:'string',name:'机构域名',notNull:true,notNullWithoutTrim:'true'" />
                            </div>
                            <div class="left margin_r_5">.yunxuetang.cn</div>
                        </td>
                        <td width="10" class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr height="40">
                        <td width="10" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="90" class="padding_t_10"><font color="red">*</font>手机号：</td>
                        <td width="300" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="yxtMobile" name="yxtMobile" value="" class="validate" validate="type:'string',name:'手机号',notNull:true,notNullWithoutTrim:'true'" />
                            </div>
                        </td>
                        <td width="10" class="padding_t_10">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
</body>
<script type="text/javascript">
  function OK(){
    var validate = $("#getApiForm").validate();
    if (!validate) {
        return false;
    }
    
    var obj={};
    obj.yxtOrgName = $("#yxtOrgName").val();
    obj.yxtDomainName = $("#yxtDomainName").val();
    obj.yxtMobile = $("#yxtMobile").val();
    return obj;
  }
</script>
</html>