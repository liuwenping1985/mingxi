<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit">
<title>${ctp:i18n("system.menuname.designer.login")}</title>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/pageDesigner.css${ctp:resSuffix()}"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
    .stadic_layout{
        background:#C4CBCE;
    }
    .stadic_head_height {
    	height: 78px;
        background:#EDEDED;
    }
    .stadic_body_top_bottom {
    	bottom: 0px;
    	top: 78px;
    	overflow: hidden;
    }
</style>
<script>
	var entityLevel = "${entityLevel}";
    var entityId = "${entityId}";
    var imgId="${imgId}";//url添加登录页背景图参数
    $(document).ready(function() {
        var _client_height = document.documentElement.clientHeight;
        //360兼容模式需要算高度
        $("#templateIframe").css("height", _client_height-$(".stadic_layout_head").height());
	    showDetail("${templateId}");
    });

    function showDetail(templateId) {
        $("#templateTab li").removeClass('currentTemplate');
        $("#templateTab li[templateId='" + templateId + "']").addClass('currentTemplate');
	    var url = "${path}/portal/loginTemplateController.do?method=loginTemplateEdit&templateId=" + templateId + "&entityLevel=" + entityLevel + "&entityId=" + entityId;
	    $("#templateIframe").attr("src", url);
    }
    function replaceDefaultTemplate(templateId){
    	$("#templateTab li").removeClass("defaultTemplate");
    	$("#templateTab li[templateId='" + templateId + "']").addClass('defaultTemplate');
    }
</script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <h2 class="loginDesignLogo"></h2>
            <ul id="templateTab" class="pageDesignNav">
                <c:forEach items="${templateList}" var="templete">
                    <li class="nav ${templete.id == templateId ? 'defaultTemplate' : ''}" templateId="${templete.id}">
                        <a href="javascript:void(0)" onclick="showDetail('${templete.id}')">
                            <img src="${path}/main/login/${templete.thumbnail}" width="70" height="40" />
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom">
            <iframe id="templateIframe" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
        </div>
    </div>
</body>
</html>