
if(!window.API_VERSION){
    window.API_VERSION = "v0.1";
}
var api_version_user =  window.API_VERSION;
function alertMessage(msg,type){
    if(!type){
        type="error";
    }
    Messenger().post({
        message:"<span style='width:300px;min-height:200px;margin:auto;text-align: center;vertical-align:middle;display:inline-block'><h3>"+ msg+"</h3></span>",
        type: type,
        showCloseButton: true
    });
}
function checkParam(name,pwd){
    var msg = "";
    if (name.length < 1) {
        msg =  '账号不能为空！';
    }
    // if (name.indexOf("@") <= 0) {
    //     msg = '账号格式错误！';
    // }
    if (pwd.length < 1) {
        msg = '密码不能为空！';
    }
    if(msg==""){
        return true;
    }
    alertMessage(msg);
    return false;
}
function lockSubmit(){
    $("#submit").attr("disabled",true);
    $("#submit").val("登录中...")

}
function unlockSubmit(){
    $("#submit").removeAttr("disabled");
    $("#submit").val("登 录")

}

function login() {
    lockSubmit()
	var name = $('#login_name').val();
	var pwd = $('#userpwd').val();
    if(!checkParam(name,pwd)){
        unlockSubmit();
        return ;
    }
    if(name.indexOf("@")<0){
        name = name+"@nd"
    }
	var names = name.split("@");
	name = names[0];
	var org_name = names[1];

	var loginUrl = "/api/"+api_version_user+"/auth/login";


	var data = {login_name:name, password:pwd, org_name:org_name};
	$.ajax({
		type: "POST",
		dataType: "json",
		url: loginUrl,
		data : data,
		success: function (data) {
			$.setCookie('access_token', data.access_token);
			$.setCookie('mac_key', data.mac_key);
            unlockSubmit();
            if(window.location.search.indexOf("mainPage")>-1){
                window.location.href = "/index.html";
            }else{
                window.location.href = "/admin/index.html";
            }

		},
		error:function(XMLHttpRequest, textStatus, errorThrown){
			//   console.log(XMLHttpRequest);
			if(XMLHttpRequest.responseText){
				var respJson = $.parseJSON(XMLHttpRequest.responseText);
				if($.messager){
					var msg = respJson.message;

					if(respJson.cause){
						msg = respJson.cause.message;
					}
					//console.log(respJson.cause);
                    unlockSubmit();
                    alertMessage(msg);
				}else{
                    unlockSubmit();
					alert(respJson.code + ":" + respJson.message);
				}
			}

		}
	});
   
}

