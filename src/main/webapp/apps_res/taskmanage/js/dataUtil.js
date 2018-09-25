/**
* 根据名称获取地址栏参数
*/
function getUrlPara(paraName){
	var reg = new RegExp("(^|&)"+ paraName +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r!=null) {
        return unescape(r[2]);
    }
    return null;
}