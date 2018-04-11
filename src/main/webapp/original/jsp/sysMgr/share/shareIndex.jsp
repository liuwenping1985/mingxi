<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
        window.localStorage.clear();
        
        var url = "${url}";
        var param = {};
        var str = "";
        if (url.indexOf("?") != -1) {
            str = url.split("?");
            strs = str[1].split("&");
            for (var i = 0; i < strs.length; i++) {
                param[strs[i].split("=")[0]] = strs[i].split("=")[1];
            }
        }

        var _html = str[0];
        
        var _reg = /^http:\/\/|^https:\/\//i;
        if(!_reg.test(_html)){
           //相对路径要拼接成绝对路径
           var newHTML = location.protocol + "//" + location.host;
           if(/^\//.test(_html)){
               newHTML += _html;
           }else{
               newHTML = _html;
           }
           _html = newHTML;
        }
        
        var backURL = "";
        var thash = "";
        if(_html.indexOf("?") == -1){
        	//尝试加一个时间戳，防止页面缓存
            backURL = "?fromShare=true&backURL=weixin&buildversion=" + new Date().getTime();
        }else{
           if(_html.indexOf("backURL=") == -1){
              backURL = "#backURL=weixin";
           }
        }
        if(_html.indexOf("#") != -1){
           var tIndex = _html.indexOf("#");
           thash = _html.substring(tIndex);
           _html = _html.substring(0, tIndex);
        }
        
        _html = _html + backURL + thash;
        
        var token = param['token'];
        
        var historyParams = {};
        historyParams["data"] = param;
        historyParams["url"] = _html;
        
        window.localStorage.setItem("CMP_V5_TOKEN", token);
        var historyStack = [];
        historyStack.push(historyParams);
        window.sessionStorage.setItem("cmp-href-history", JSON.stringify(historyStack));
            
        window.location.href = _html;
    </script>
</head>
<body class="h100b over_hidden">
</body>
</html>