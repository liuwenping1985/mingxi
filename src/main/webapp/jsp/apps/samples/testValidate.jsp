<%--
 $Author: wuym $
 $Rev: 4714 $
 $Date:: 2013-03-04 11:25:53#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>表单校验测试</title>
<script type="text/javascript">
  $(function() {
    // 表单JSON无分区无分组提交事件
    $("#json").click(function() {
      $("#validDomain").jsonSubmit({
        debug : true,
        validate : $("#validate").is(":checked"),
        errorIcon : false
      });
    });

    $("#ajax").click(function() {
      var obj = $("#validDomain").formobj({
        validate : $("#validate").is(":checked")
      });
      alert("Invalid:" + $._isInValid(obj));
    });

  });

  function testCustomFunc(input) {
    if (input.value == "aaa") {
      return true;
    }
    return false;
  }
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div class="align_center">
        <a href="javascript:void(0)" class="common_button common_button_gray" id="json">Json提交</a> <a
            href="javascript:void(0)" class="common_button common_button_gray" id="ajax">Ajax取数</a> <input id="validate"
            type="checkbox" checked>是否验证
    </div>

    <div class="classification">
        <div class="list">
            <div class="form_area">
                <div class="one_row">
                    <form id="validDomain" action="test.do?method=testValidate">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <th><label class="margin_r_10" for="text">姓名:</label></th>
                                <td><div class="common_txtbox_wrap"><!-- 单引号要加反斜线转义，双引号要使用&quot;转义 -->
                                        <input id="name" type="text" name="username" class="validate"
                                            validate="type:'string',name:'姓名',notNull:true,minLength:4,maxLength:20,avoidChar:'-!@#$%^&*()_+\'&quot;'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">密码:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="password" name="password" class="validate"
                                            validate="fieldName:'密码',notNullWithoutTrim:true" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">电子邮件:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="email" class="validate"
                                            validate="type:'email',name:'电子邮件'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">电话号码:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="telephone" class="validate"
                                            validate="name:'电话号码',type:'telephone'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">手机号码:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="mobilePhone" class="validate"
                                            validate="name:'手机号码',type:'mobilePhone'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">年龄:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="age" class="validate"
                                            validate="name:'年龄',isInteger:true, maxValue:150,minValue:0" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">出生日期:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="age1" class="validate" validate="name:'出生日期',type:'3'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">出生时间:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="age2" class="validate"
                                            validate="name:'出生日期+时间',type:'4'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">携带现金:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="xianjin" class="validate"
                                            validate="name:'携带现金', type:'number', dotNumber:2, integerDigits:4, notNull:true" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">其他:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="qita" class="validate"
                                            validate="name:'其他',isDeaultValue:true,deaultValue:'不能是默认值'" />
                                    </div></td>
                            </tr>

                            <tr>
                                <th><label class="margin_r_10" for="text">goodText:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="goodText" id="goodText1" class="validate"
                                            validate="name:'goodTextGoogText',regExp:/\d+/,errorMsg:'goodTextGoogText必须输入数字！'" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">自定义:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" name="goodText" id="goodText2" class="validate"
                                            validate="name:'goodTextGoogText',func:testCustomFunc,errorMsg:'自定义函数校验必须等于aaa！'" />
                                    </div></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
