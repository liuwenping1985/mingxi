
/**
 * 验证当前用户是否设置邮箱
 */
function hasDefaultMailBox(){
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxWebMailManager", "hasDefaultMailBox", false);
    requestCaller.addParameter(1, "String", "currentUser");
    var ds = requestCaller.serviceRequest();
    if(ds && ds=="false"){
        getA8Top().main.location.href= _ctxPath + "/webmail.do?method=create";
        return false;
    }
    return true;
}

/**
 * 发邮件
 * @param email
 */
function sendMail(email){
    var url = _ctxPath + "/webmail.do?method=create&defaultaddr="+email;
    openCtpWindow({'url':url});
}