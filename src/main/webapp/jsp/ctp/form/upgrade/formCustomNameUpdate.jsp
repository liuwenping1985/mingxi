<%--
  Created by IntelliJ IDEA.
  User: 毅
  Date: 2015/7/23
  Time: 10:38
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<html>
<head>
    <title>更新表单所属客户名称</title>
    <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
    <style type="text/css">
        body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, form, fieldset, input, textarea, p, th, td, img, label, button {
            margin: 0;
            padding: 0;
            font-family: "microsoft yahei";
        }

        *:focus {
            outline: none;
        }

        .layout_shell {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            width: 100%;
            height: 100%;
            background-color: #368ABA;
        }

        .layout_center1 {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            width: 350px;
            height: 240px;
            margin: auto;
        }

        .layout_center1 div {
            padding: 0 0;
            font-size: 14px;
            color: #fff;
            margin: 15px 0;
            line-height: 24px;
            vertical-align: bottom;
        }

        .custom_name input {
            height: 22px;
            line-height: 22px;
            font-size: 14px;
            text-indent: 4px;
            border: 1px solid #e4e4e4;
        }

        .custom_name input:hover {
            border: 1px solid #57B4E7;
        }

        .layout_center1 .layout_submit_type {
            padding-left: 0;
            text-align: center;
        }

        .layout_submit_type input {
            width: 50px;
            height: 28px;
            margin: 0 15px;
            line-height: 28px;
            text-align: center;
            border: 1px solid #99948C;
            color: #111;
            background: #EAEAEA;
            border-radius: 5px;
        }

        .layout_submit_type input:hover {
            cursor: pointer;
            color: #111;
            background: #F6F6F6;
            border: solid 1px #BFBFBF;
        }
    </style>
</head>
<body>
<div class="layout_shell">
    <form>
        <div id="namediv" class="layout_center1 form">
            <div class="custom_name">
                <div class="clearfix" style="width: 350px">
                    <div class="left" style="width: 100px;">旧的客户名称：</div>
                    <div class="left" style="width: 200px;margin: 0">
                        <div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;">
                            <input type="text" id="oldName" name="oldName" class="validate" validate='avoidChar:"\\/|<>:*?\"",type:"string",name:"旧的客户名称",notNull:true,maxLength:35,notNullWithoutTrim:true'>
                        </div>
                    </div>
                </div>
            </div>
            <div class="custom_name">
                <div class="clearfix" style="width: 350px">
                    <div class="left" style="width: 100px;">新的客户名称：</div>
                    <div class="left" style="width: 200px;margin: 0">
                        <div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;">
                            <input type="text" id="newName" name="newName" class="validate" validate='avoidChar:"\\/|<>:*?\"",type:"string",name:"新的客户名称",notNull:true,maxLength:35,notNullWithoutTrim:true'>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layout_submit_type">
                <input type="button" value="查询" id="searchBtn"/>
                <input type="button" value="修改" id="modifyBtn"/>
            </div>
        </div>
    </form>
</div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp" %>
<script type="text/javascript">
    $(document).ready(function () {
        var fm = new formListManager();
        $("#searchBtn").click(function () {
            if ($("#oldName").validate({errorAlert:true,errorIcon:false})) {
                var pb = $.progressBar({text: '查询中，请稍候……'});
                fm.transUpdateCustomName({oldName: $("#oldName").val(), newName: $("#newName").val()}, false, {success:function(obj){
                    pb.close();
                    $.infor("客户名称为 " + $("#oldName").val() + " 的表单数为：" + obj.updateCount);
                }});
            }
        });
        $("#modifyBtn").click(function () {
            if ($("#namediv").validate({errorAlert:true,errorIcon:false})) {
                var pb = $.progressBar({text: '修改中，请稍候……'});
                fm.transUpdateCustomName({oldName: $("#oldName").val(), newName: $("#newName").val()}, true, {success:function(obj){
                    pb.close();

                    $.infor("成功将 " + obj.updateCount + " 个表单的客户名称由 " + $("#oldName").val() + " 更新为 " + $("#newName").val() + "<br/>欲使修改生效，请重启服务！");
                }});
            }
        });
    });
</script>
</html>
