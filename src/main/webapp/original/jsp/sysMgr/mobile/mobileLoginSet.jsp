<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:message key='addressbook.set.15.label' var='clickLable' />
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='system.menuname.mobileLogin.configure' /></title>
<style>
.stadic_head_height {
    height: 40px;
}

.stadic_body_top_bottom {
    top: 40px;
    bottom: 20px;
}

.stadic_footer_height {
    height: 20px;
}
.bg_color_black{
    background-color: #4d4d4d;
    height:30px;
}
.common_button{
    margin-top: 5px;
}
.margin_with{
    width: 290px;
    margin: 15px auto;
}
</style>

<script type="text/javascript">
    var  controlScopeNullError= "<fmt:message key='system.menuname.mobileLogin.controlScope.null'/>";
    $(document).ready(function() {
        if(${bean.defaultOn}){
            if(${bean.controlScope}){
                $("#memberScope").comp({
                    value : "${bean.scopeEntity}",
                    text : "${bean.scopeName}"
                });
            }
        } else {
            $("#defaultOnDiv").disable();
        }

        $("#btnok").unbind("click").click(function() {
            if($("#defaultOn2").attr("checked") && $("#controlScope2").attr("checked")){
                if($("#memberScope").val() == ""){
                    $.error(controlScopeNullError);
                    return;
                }
            }
            $("#form").submit();
        });

        $("#btncancel").unbind("click").click(function() {
            getCtpTop().backToHome();
        });
    });

    function defaultOnRadioClick(enable_e, disable_e1) {
        $("#" + enable_e).enable();
        $("#" + disable_e1).disable();
        if(enable_e && !${bean.controlScope}){
            $("#controlScope1").attr("checked","checked");
        }
    }

    function controlScopeRadioClick(enable_e, disable_e1){
        $("#" + enable_e + "_txt").enable();
        $("#" + disable_e1 + "_txt").disable();
    }
</script>
</head>
<body class="h100b over_hidden">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_mobileLogin'"></div>
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height bg_color_gray">
            <div class="font_bold padding_l_10 padding_t_5" style="font-size: 20px; color: #919191;"><fmt:message key='system.menuname.mobileLogin.configure' /></div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom">
            <form id="form" name="form" method="post" action="mobileLogin.do?method=save" onsubmit="return true;">
                <div style="margin: 30px auto; width: 600px; height: 200px; border: 1px solid #CCC;padding-top: 40px">
                    <div class="margin_with">
                        <label for="defaultOn1" class="valign_m hand" onclick="defaultOnRadioClick('','defaultOnDiv')"> <input id="defaultOn1" name="defaultOn" type="radio" value="0"
                            ${!bean.defaultOn ? 'checked' :''} /> <span class="valign_m margin_l_5"><fmt:message key='system.menuname.mobileLogin.defaultOn.false' /></span><!-- 默认不开启短信验证码，用户可自行开启 -->
                        </label>
                    </div>
                    <div class="margin_t_20 margin_with">
                        <label for="defaultOn2" class="hand" onclick="defaultOnRadioClick('defaultOnDiv','')"> <input id="defaultOn2" name="defaultOn" type="radio" value="1"
                            ${bean.defaultOn ? 'checked' :''} /> <span class="valign_m margin_l_5"><fmt:message key='system.menuname.mobileLogin.defaultOn.true' /></span><!-- 默认开启短信验证码，用户可自行关闭 -->
                        </label>
                    </div>
                    <div id="defaultOnDiv" class="margin_with">
                        <div class="margin_t_10 margin_l_20">
                            <label for="controlScope1" class="hand"> <input id="controlScope1" name="controlScope" type="radio" value="0"
                                ${bean.defaultOn && !bean.controlScope ? 'checked' :''} /> <span class="valign_m margin_l_5"><fmt:message key='system.menuname.mobileLogin.controlScope.false' /></span><!-- 全系统所有用户账号（不含管理员） -->
                            </label>
                        </div>
                        <div class="margin_t_10 margin_l_20">
                            <label for="controlScope2" class="hand" id="controlScope_select"> <input id="controlScope2" name="controlScope" type="radio" value="1" ${bean.defaultOn && bean.controlScope ? 'checked' :''} /> <span class="valign_m margin_l_5"><fmt:message key='system.menuname.mobileLogin.controlScope.true' /></span><!-- 指定账号 -->
                                <input id="memberScope" name="memberScope" class="comp font_size12"
                                comp="type:'selectPeople',panels:'Department,Team,Post,Level,Outworker',selectType:'Account,Department,Team,Post,Level,Member',onlyLoginAccount:false,minSize:'1',text:'${clickLable}'" />
                            </label>
                        </div>
                    </div>
                </div>
                <div style="margin: 50px auto; width: 600px;"><!-- 说明 -->
                    <div class="margin_t_10 color_red"><fmt:message key='system.menuname.mobileLogin.explain' /></div>
                    <div class="margin_t_10 margin_l_20 color_red"><fmt:message key='system.menuname.mobileLogin.explain1' /></div>
                    <div class="margin_t_10 margin_l_20 color_red"><fmt:message key='system.menuname.mobileLogin.explain2' /></div>
                </div>
            </form>
        </div>
        <div class="stadic_layout_footer stadic_footer_height border_t padding_t_5 padding_b_10 align_center bg_color_black">
            <input type="button" class="common_button common_button_emphasize" id="btnok" name="btnok" value="${ctp:i18n('common.button.ok.label')}" />
            <input type="button" class="common_button common_button_gray margin_l_10" id="btncancel" name="btncancel" value="${ctp:i18n('common.button.cancel.label')}" />
        </div>
    </div>
</body>
</html>