<%--
 $Author: daiy $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="common.js.jsp"%>
<%@ include file="../component/formFieldConditionComp.js.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
<html style="height: 100%;">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>无流程表单批量修改</title>
    <style>
        .edit_class{
            width: 190px;
        }
        .edit_class input{
            width: 190px;
        }
        .edit_class select{
            width: 190px;
        }
        .edit_class textarea{
            width: 190px;
        }
       /* .select2 {
            border:1px solid #ccc;
        }*/
    </style>
    <script type="text/javascript">
        var formId = "${param.formId}";
        var form = undefined;//OA-86279 批量修改带格式的数字提示报错
        var templateId = "${param.formTemplateId}";
        $(document).ready(function(){
            $(".edit_class").each(function(){
                $(this).find("input[type='radio']").each(function(){
                    $(this).width(20);
                });
            });
            $("input[type=checkbox]").click(function(){
                this.value=this.checked?1:0;
            });
            <c:if test="${!haveField}">
            $.alert({msg:"没有可以批量修改的字段！",ok_fn:function(){
                window.parentDialogObj['bathUpdate'].close();
            },close_fn:function(){
                window.parentDialogObj['bathUpdate'].close();
            }});
            </c:if>
        });

        function OK(){
            var obj = {};
            if ($("#data").validate({errorAlert:true,errorBg:true})){
                var data = $("#data").formobj();
                var updateType = $("input[name='updateType']:checked").val();
                obj.data=data;
                obj.updateType = updateType;
                obj.success = true;
            } else {
                obj.success = false;
            }
            return obj;
        }
    </script>
</head>
<body style="height: 100%;overflow: hidden">
<div id="data" style="height: 455px;overflow: auto" class="font_size12">
    <c:forEach items="${result}" var="item">
        <div class="clearfix">
            <div class="left" style="width: 150px;text-align: right;margin-right: 5px;margin-top: 5px;">${item.showName}：</div>
            <div class="left" style="width: 210px;margin-right: 5px;margin-top: 5px;">${item.html}</div>
        </div>
      </c:forEach>
  </div>
  <div id="updateType" style="height: 40px;margin-top: 5px;margin-left: 5px;">
    <div class="common_radio_box clearfix">
      <label for="radio5" class="margin_t_5 hand display_block">
        <input type="radio" value="0" id="radio5" name="updateType" class="radio_com" checked>${ctp:i18n('form.bind.bath.update.option.value1.label')}</label>
      <label for="radio6" class="margin_t_5 hand display_block">
        <input type="radio" value="1" id="radio6" name="updateType" class="radio_com">${ctp:i18n('form.bind.bath.update.option.value2.label')}</label>
    </div>
  </div>
</body>
</html>
