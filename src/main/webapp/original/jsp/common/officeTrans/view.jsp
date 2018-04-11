<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8</title>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
    var url = '${officeTransUrl}';
    //判断是否是ie浏览器
    var ua = navigator.userAgent;
    var _isMSIE = (navigator.appName == "Microsoft Internet Explorer")||ua.indexOf('Trident')!=-1;
    getCtpTop().officetransDialog = null;
    if(_isMSIE){
        var openobj = window;
        if(typeof(window.dialogArguments) == 'object'){
            openobj = window.dialogArguments;
        }
        var w=900;
        var h=700;
        openobj.showModalDialog(url,'','dialogWidth:'+w+'px,dialogHeight:'+h+'px');
    }else{
        if(getCtpTop() && getCtpTop().$ && getCtpTop().$.dialog){
            getCtpTop().officetransDialog = getCtpTop().$.dialog({
                title:' ',
                url:url,
                width:900,
                height:700
          });
        }else{
            var v3x = new V3X();
            v3x.openDialog({
                title:"",
                targetWindow:parent,
                url : url,
                width: 900,
                height: 700
            });
        }
    }
    
</script>
<body>
</body>
</html>