<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>空间栏目设计</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit">
<style type="text/css">
    .stadic_head_height {
        height: 50px;
        background: #464E78;
        overflow: hidden;
        border-bottom: 20px solid #C4CBCE;
    }
    
    .stadic_body_top_bottom {
        bottom: 0px;
        top: 70px;
        overflow: hidden;
    }
    
    .space_tab_ul {
        padding: 0 0 0 20px;
    }
    
    .space_tab_ul li {
        margin-top: 10px;
        float: left;
        line-height: 30px;
        padding: 0 12px;
        color: #fff;
        width: 100px;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
        text-align: center;
    }
    
    .space_tab_ul li a {
        color: #fff;
    }
    
    .space_tab_ul li.current {
        float: left;
        background: #318EC3;
    }
    .space_tab_ul li.right{
        float: right;
    }
    #scollDiv{
        float: left;
        overflow: hidden;
    }

#prevli,#nextli{
    height:50px;
    line-height:50px;
    vertical-align: top;
    width:24px;
    text-align: center;
    cursor: pointer;
    margin-top: 0;
    padding: 0 5px;
}
.prev_em{
    display: inline-block;
    width:16px;
    height:48px;
    background: url("../main/skin/frame/default/images/nav_left.png?V=V6_1_2017-04-13") center no-repeat;
}
.prev_em:hover{
    background: url("../main/skin/frame/default/images/nav_left_hover.png?V=V6_1_2017-04-13") center no-repeat;
}
.prev_em.disable:hover{
    background: url("../main/skin/frame/default/images/nav_left.png?V=V6_1_2017-04-13") center no-repeat;
}
.next_em{
    display: inline-block;
    width:16px;
    height:48px;
    background: url("../main/skin/frame/default/images/nav_right.png?V=V6_1_2017-04-13") center no-repeat;
}
.next_em:hover{
    background: url("../main/skin/frame/default/images/nav_right_hover.png?V=V6_1_2017-04-13") center  no-repeat;
}
.next_em.disable:hover{
    background: url("../main/skin/frame/default/images/nav_right.png?V=V6_1_2017-04-13") center no-repeat;
}
.disable{ cursor: default; }
</style>
<script>
function intMemu(){
    var _client_width = $("body").width();
    var space_tab_width=0;
    $("#space_tab ul li").not(".right").each(function(index, el) {
        space_tab_width = space_tab_width+124;
    });
    $(".space_tab_ul").width(space_tab_width+"px");
    var step = 100;
    if(space_tab_width>_client_width){
        $("#nextli,#prevli").show();
        $("#scollDiv").width(parseInt(_client_width-68));
       
        $("#nextli").click(function(){
            if((_client_width-68+step)<space_tab_width+100){
                $("#scollDiv").scrollLeft(step);
                step = step+100;
            }
        });

        $("#prevli").click(function(){
            if($("#scollDiv").scrollLeft()>0){
                step = $("#scollDiv").scrollLeft()-100;
                $("#scollDiv").scrollLeft(step);
            }
        });

    }else{
        $("#nextli,#prevli").hide();
        $("#scollDiv").width(parseInt(_client_width));
    }
}

    $(document).ready(function() {
        showCurrentTab("tab0", "${defaultSpacePath}", "${allowed}", "${defaultLayout}");
        if($.browser.msie && (document.documentMode =="7")){//360兼容模式  需要计算高度
            $("#personalSpaceEditIframe").height($("#stadic_body_top_bottom").height());
        }
        intMemu();
        $(document).resize(function(event) {
            intMemu();
        });

    });

    function showCurrentTab(id, pagePath, allowDefined, decoration) {
        $("#space_tab").find("li").removeClass("current");
        $("#" + id).addClass("current");
        if (allowDefined == "true") {
            var src = "${path}/portal/spaceController.do?method=personalSpaceEdit&pagePath=" + pagePath + "&decoration=" + decoration + "&d=" + (new Date().getTime());
            $("#personalSpaceEditIframe").show();
            $("#personalSpaceEditIframe").attr("src", src);
            $("#notAllowedDefineMsg").hide();
        } else {
            $("#personalSpaceEditIframe").hide();
            $("#personalSpaceEditIframe").attr("src", "");
            $("#notAllowedDefineMsg").show();
        }
    }
</script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div id="space_tab" class="stadic_layout_head stadic_head_height">
            <div id="scollDiv">
                <ul class="space_tab_ul">
                    <c:forEach items="${spaceList}" var="space" varStatus="index">
                        <li class="space_tab_ul_li ${index.index == '0' ? 'current' : ''}" id="tab${index.index}"><a href="javascript:showCurrentTab('tab${index.index}', '${space[3]}', '${space[4]}', '${space[5]}')" title="${v3x:toHTML(space[2])}">${v3x:toHTML(space[2])}</a></li>
                    </c:forEach>
                </ul>
            </div>
            <div id="nextli" class="right"><em class="next_em"></em></div>
            <div id="prevli" class="right"><em class="prev_em"></em></div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom" id="stadic_body_top_bottom">
            <iframe id="personalSpaceEditIframe" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
            <table id="notAllowedDefineMsg" align="center" style="height:90%; color:red; font-size:14px; font-weight:bolder; display:none;">
                <tr>
                    <td valign="middle" height="100%">${ctp:i18n("space.forbiddendefined.label")}</td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>