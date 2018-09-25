//兼容IE 6下新增，修改 空白页面
function ferIframe(editIframe){
    var userAgent = navigator.userAgent; 
    var isOpera = userAgent.indexOf("Opera") > -1;
    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera ;
    if(isIE){
      var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
      reIE.test(userAgent);
      var fIEVersion = parseFloat(RegExp["$1"]);
      var IE6 = fIEVersion == 6.0 ;
      if(IE6){
        window.frames[editIframe].location = frames[editIframe].location.href;
      }
    }
}