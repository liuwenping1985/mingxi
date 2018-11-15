<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>layout</title>
    <script>
        $(document).ready(function(){
            if("false" == getCtpTop().productView_check){
                $("#cbox").attr("checked",false);
            }else{
                $("#cbox").attr("checked",true);
            }
        });
        function productViewClose(){
            var isHide = $("#cbox").attr("checked") == "checked" ? "true" : "false";
            getCtpTop().productView_check = isHide;
            AjaxDataLoader.load("${path}/portal/portalController.do?method=saveUserProductViewSet&isHide="+isHide, null, function(str){});
        }
        function changeImgUrl(option) {
            var productTop = getCtpTop();
            var obj = $(option.t);
            switch (obj.attr("alt")) {
                case "二维码":
                    var _src1 = "${path}/skin/${CurrentUser.skin}/images/productView/index.jpg";
                    var _src2 = "${path}/skin/${CurrentUser.skin}/images/productView/index2.jpg";
                    var _imgObj = $("#map");
                    if (_imgObj.attr("data-QRcode") == undefined) {
                        _imgObj.attr("data-QRcode", true);
                        _imgObj.attr("src", _src2);
                    } else {
                        switch(_imgObj.attr("data-QRcode")){
                            case "true":
                                _imgObj.attr("data-QRcode", false);
                                _imgObj.attr("src", _src1);
                                break;
                            case "false":
                                _imgObj.attr("data-QRcode", true);
                                _imgObj.attr("src", _src2);
                                break;
                        }
                    }
                    break;
                case "UC中心":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=uc";
                    break;
                case "协同门户":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=xtmh";
                    break;
                case "移动互联":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=ydhl";
                    break;
                case "组织模型":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=zzmx";
                    break;
                case "知识社区":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=zssq";
                    break;
                case "文化建设":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=whjs";
                    break;
                case "目标管理":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=mbgl";
                    break;
                case "协同工作":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=xtgz";
                    break;
                case "会议管理":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=hygl";
                    break;
                case "业务管理":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=ywgl";
                    break;
                case "公文管理":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=gwgl";
                    break;
                case "业务集成":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=ywjc";
                    break;
                case "协同驾驶舱":
                    location.href = "${path}/portal/portalController.do?method=showProductSencendView&pageName=xtjsc";
                    break;

                case "关闭按钮":
                    productTop.productView_Obj.close();
                    productTop.productView_Obj = null;
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
    <img id="map" usemap="#map" src="${path}/skin/${CurrentUser.skin}/images/productView/index.jpg">
    <map id="map_link" name="map">
        <!--
        <area shape="rect" coords="0,0,182,182" href="###" onclick="changeImgUrl({t:this})" onfocus= "this.blur()" alt="二维码" />
         -->
        <area shape="rect" coords="968,10,990,35" href="###" onclick="changeImgUrl({t:this})" alt="关闭按钮" />

        <area shape="rect" coords="290,35,405,100" href="###" onclick="changeImgUrl({t:this})" alt="UC中心" />
        <area shape="rect" coords="470,50,600,110" href="###" onclick="changeImgUrl({t:this})" alt="协同门户" />
        <area shape="rect" coords="650,40,780,100" href="###" onclick="changeImgUrl({t:this})" alt="移动互联" />

        <area shape="rect" coords="66,253,268,298" href="###" onclick="changeImgUrl({t:this})" alt="组织模型" />
        <area shape="rect" coords="66,317,268,365" href="###" onclick="changeImgUrl({t:this})" alt="知识社区" />
        <area shape="rect" coords="66,385,268,432" href="###" onclick="changeImgUrl({t:this})" alt="文化建设" />

        <area shape="rect" coords="408,253,610,298" href="###" onclick="changeImgUrl({t:this})" alt="目标管理" />
        <area shape="rect" coords="408,317,610,365" href="###" onclick="changeImgUrl({t:this})" alt="协同工作" />
        <area shape="rect" coords="408,385,610,432" href="###" onclick="changeImgUrl({t:this})" alt="会议管理" />

        <area shape="rect" coords="741,253,944,298" href="###" onclick="changeImgUrl({t:this})" alt="业务管理" />
        <area shape="rect" coords="741,317,944,365" href="###" onclick="changeImgUrl({t:this})" alt="公文管理" />
        <area shape="rect" coords="741,385,944,432" href="###" onclick="changeImgUrl({t:this})" alt="业务集成" />

        <area shape="rect" coords="425,590,575,630" href="###" onclick="changeImgUrl({t:this})" alt="协同驾驶舱" />
    </map>
    <div style="display:none" id="cbox_area" class="cbox_area">
        <input id="cbox" type="checkbox" name="name" onclick="javascript:productViewClose()"/>
        <label for="cbox">启动时显示此对话框</label>
    </div>
</body>
</html>
