<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>协同驾驶舱</title>
    <script>
        function changeImgUrl(option) {
            var productTop = getCtpTop();
            var obj = $(option.t);
            switch (obj.attr("alt")) {
                case "回总导图":
                    location.href = "portalController.do?method=showProductView";
                    break;
                case "关闭按钮":
                    productTop.productView_Obj.close();
                    productTop.productView_Obj = null;
                    break;
                case "进入主题":
                    if("${ctp:hasResourceCode('T03_performance_analysis')}" == "true"){
                        getCtpTop().gotoDefaultPortal();
                        productTop.showMenu("${path}/portal/spaceController.do?method=showThemSpace&themType=23");
                        productTop.productView_Obj.close();
                        productTop.productView_Obj = null;
                    }else{
                        $.alert("${ctp:i18n('system.productView.error')}");
                    }
                    break;
                default:
                    alert("Error!");
            }
        }
    </script>
    <style>
        .cbox_area { position: absolute; left: 810px; top: 14px; font-size: 14px; line-height: 100%; }
        .cbox_area input { margin-top: -4px; }
    </style>
</head>
<body class="over_hidden">
    <img id="map" usemap="#map" src="${path}/skin/${CurrentUser.skin}/images/productView/xtjsc.jpg">
    <map id="map_link" name="map">
        <area shape="rect" coords="697,60,805,90" href="###" onclick="changeImgUrl({t:this})" alt="回总导图" />
        <area shape="rect" coords="815,60,923,90" href="###" onclick="changeImgUrl({t:this})" alt="进入主题" />
        <area shape="rect" coords="934,60,962,90" href="###" onclick="changeImgUrl({t:this})" alt="关闭按钮" />
    </map>
</body>
</html>
