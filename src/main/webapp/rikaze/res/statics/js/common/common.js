var isOldPasswordRight = false;
$(document).ready(function(){
    //检查旧密码
    $("#oldPassword").blur(function(){
        checkPassword();
    });
    //检查密码
    $("#newPassword").blur(function(){
        checkNewPassword();
    });
    //检查两次密码是否一致
    $("#confirmPassword").blur(function(){
        checkConfirmPassword();
    });
    //回车事件
    $("#editPassword input").keydown(function(event){
        if(event.keyCode == 13){
            editPassword();
        }
    });
});

//登出
var logout = function(userType){

    $.commons.ajax({
        type: "POST",
        url: "/api/v0.1/user/logout",
        dataType: "json",
        success: function(data){
        	$.delCookie("access_token");
        	$.delCookie("mac_key");
        	if(userType == "te"){
        		window.location.href = "/";
        	}else{
        		window.location.href = "/admin/op/login.html";
        	}
        	
        }
    });

}

//修改密码弹窗
var showEditPassword = function(){
    $("#editPassword").show();
    $("#editPassword").dialog({
        width: 570,
        modal: true,
        shadow:false,
        title: "修改密码"
    });
}

//检查旧密码
var checkPassword = function(){
    var userId = $("#userId").val();
    var userType = $("#userType").val();
    var oldPassword = $("#oldPassword").val();
    var path = "/api/admins/checkPassword";
    var data = "adminId="+userId + "&password=" +oldPassword ;

    if (userType == "student") {
        path = "/api/user/checkPassword";
        data = "studentId="+userId + "&password=" +oldPassword ;
    }
    if($.trim(oldPassword) == ""){
        $("#editPassword .ep-pop-psw-item-tips").eq(0).find(".ep-pop-psw-tips span").html("密码不能为空");
        $("#editPassword .ep-pop-psw-item-tips").eq(0).children(".ep-pop-psw-tips").show();
        return false;
    }

    //if(userId > 0){
    //    $.ajax({
    //        type: "POST",
    //        url: path,
    //        data:data,
    //        dataType: "json",
    //        success: function(res){
    //            if(res.success){
    //                if(!res.data){
    //                    isOldPasswordRight = false;
    //                    $("#editPassword .ep-pop-psw-item-tips").eq(0).find(".ep-pop-psw-tips span").html("旧密码有误");
    //                    $("#editPassword .ep-pop-psw-item-tips").eq(0).children(".ep-pop-psw-tips").show();
    //                }else{
    //                    isOldPasswordRight = true;
    //                    $("#editPassword .ep-pop-psw-item-tips").eq(0).find(".ep-pop-psw-tips span").html("");
    //                    $("#editPassword .ep-pop-psw-item-tips").eq(0).children(".ep-pop-psw-tips").hide();
    //                }
    //            }else{
    //                $.messager.alert("失败", "请求出错，请重试或联系管理员！");
    //            }
    //        }
    //    });
    //}else{
    //    $.messager.alert("失败", "检查失败，请重新登录后重试！");
    //}
}
//检查新密码
var checkNewPassword = function(){
    var newPassword = $("#newPassword").val();
    if($.trim(newPassword) == ""){
        $("#editPassword .ep-pop-psw-item-tips").eq(1).find(".ep-pop-psw-tips span").html("密码不能为空");
        $("#editPassword .ep-pop-psw-item-tips").eq(1).children(".ep-pop-psw-tips").show();
        return false;
    }else{
        $("#editPassword .ep-pop-psw-item-tips").eq(1).find(".ep-pop-psw-tips span").html("");
        $("#editPassword .ep-pop-psw-item-tips").eq(1).children(".ep-pop-psw-tips").hide();
        return true;
    }
}
//检查两次密码是否一致
var checkConfirmPassword = function(){
    var newPassword = $("#newPassword").val();
    var confirmPassword = $("#confirmPassword").val();
    if($.trim(newPassword) != $.trim(confirmPassword)) {
        $("#editPassword .ep-pop-psw-item-tips").eq(2).find(".ep-pop-psw-tips span").html("两次输入的密码不一致");
        $("#editPassword .ep-pop-psw-item-tips").eq(2).children(".ep-pop-psw-tips").show();
        return false;
    }else{
        $("#editPassword .ep-pop-psw-item-tips").eq(1).find(".ep-pop-psw-tips span").html("");
        $("#editPassword .ep-pop-psw-item-tips").eq(1).children(".ep-pop-psw-tips").hide();
        return true;
    }
 }

//修改密码
var editPassword = function(){

    if($.trim(oldPassword) == ""){
        $("#editPassword .ep-pop-psw-item-tips").eq(0).find(".ep-pop-psw-tips span").html("密码不能为空");
        $("#editPassword .ep-pop-psw-item-tips").eq(0).children(".ep-pop-psw-tips").show();
        return false;
    }

    if(checkNewPassword() && checkConfirmPassword()){
        $.commons.ajax({
            type: "POST",
            url: "/api/v0.1/user/modify",
            data: {
                "oldPassword": $("#oldPassword").val(),
                "newPassword": $("#newPassword").val()
            },
            dataType: "json",
            success: function(res){
                if(res.success){
                    $.messager.alert("成功", "恭喜您，修改密码成功！","info", function(){
                        //window.location.href = redirect;
                        $("#editPassword").dialog('close');
                    });
                }else{
                    $.messager.alert("修改密码失败", res.message || "请求出错，请重试或联系管理员！");
                }
            }
        });
    }

    /*if(checkNewPassword() && checkConfirmPassword()){

        //var hash = CryptoJS.HmacSHA256(request_content, mac_key);
        //var mac = hash.toString(CryptoJS.enc.Base64);

        //uc地址
        var url = "http://101uccenter.beta.web.sdp.101.com/v0.93/users/" + $("#userId").val() + "/password/actions/modify";
        var macKey = $.getCookie('mac_key');
        var oldPasswordMD5 = CryptoJS.HmacMD5($("#oldPassword").val(), macKey).toString();
        var newPasswordMD5 = CryptoJS.HmacMD5($("#newPassword").val(), macKey).toString();
        $.commons.ajax({
            type: "PUT",
            url: url,
            data: {
                "old_password": oldPasswordMD5,
                "new_password": newPasswordMD5
            },
            dataType: "json",
            success: function(res){
                $.messager.alert("成功", "恭喜您，修改密码成功！","info", function(){
                    $("#editPassword").dialog('close');
                });
            },
            error: function(res, status) {
                $.messager.alert("修改密码失败", "请求出错，请重试或联系管理员！" + status);
            }
        });
    }*/
}
