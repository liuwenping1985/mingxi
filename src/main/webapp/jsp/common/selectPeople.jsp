<%--
 $Author: maxc $
 $Rev: 853 $
 $Date:: 2012-09-10 16:05:05#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>选择人员</title>
<script text="text/javascript">
  function OK() {
    var v = {
      value : $('#spd').val(),
      text : $('#spdText').val()
    }
    window.returnValue = v;
    return v;
  }
  $(function() {

    $('#btnOk').click(function() {
      OK();
      window.close();
    });
    $('#btnCancel').click(function() {
      window.close();
    });
    var params = window.dialogArguments ? window.dialogArguments : null;
    if (params) {
      $('#spd').val(params.value);
      $('#spdText').val(params.text);
    }

  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div>


        <div class="common_txtbox_wrap1">
            选人值：<input type="text" id="spd" name="spd" size="60" /><br />

        </div>
        <div class="common_txtbox_wrap1">

            显示值：<input type="text" id="spdText" name="spdText" size="60" />
        </div>
        <hr />
        <div class="align_center">
            <a class="common_button common_button_gray" id="btnOk" href="javascript:void(0)">确定</a> <a
                class="common_button common_button_gray" id="btnCancel" href="javascript:void(0)">取消</a>
        </div>

        <hr />
        <div class="common_txtbox_wrap1" style="display: none">
            <input type="text" id="loginName" name="loginName" /><a class="common_button common_button_gray"
                href="javascript:void(0)">搜索</a>

        </div>
    </div>
</body>
</html>
