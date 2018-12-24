<div id="v5pagelayout" class="v5pagelayout v5pagelayout_body warp" >
    <style>
        .hidehide{

            display:none !important;
        }
        .no-margin-left{

            margin-left: 0px !important;
        }
        .no-top{
            top:0px !important;
        }

    </style>
    <div class="layout_header layout_header_area hidehide" style="display:none">
        <div class="v5container area " id="v5headerarea">${pageRenderResult.bodyHtmlData.v5headerarea }</div>
    </div>
    <div class="layout_content no-top clearfix">
        <div id="v5nav" style="display:none" class=" hidehide v5container layout_left">${pageRenderResult.bodyHtmlData.v5nav }</div>
        <div class="layout_right">
            <div class="layout_content_main">
                <div id="content_layout_body_left_content" class="layout_content_main_warp">
                    <div id="nowLocation" class="v5container layout_location">
                        ${pageRenderResult.bodyHtmlData.nowLocation }
                    </div>
                    <div id="v5body" class="v5container layout_content_main_content clearfix">
                        <iframe src="" allowtransparency="true" id="main" name="main" frameborder="0"  onload="setonbeforeunload()" class="w100b h100b" style="position:absolute;"></iframe>
                        <div class="noneDiv w100b h100b"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function GetRequest() {
            var url = location.search||(window.lcaotion+"");
            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for(var i = 0; i < strs.length; i ++) {
                    theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
                }
            }
            return theRequest;
        }
        function iframSrcLocator(url){

            $("#main").attr("src",url);
            //console.log($(".layout_content_main"));
            $(".layout_content_main").addClass("no-margin-left");




        }
        $(document).ready(function(){

            var param = GetRequest();
            if(param.openType=="menhu"){
                var l_type = param.type;
                if(l_type=="shouwenduban"){

                    iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise");

                }else if(l_type=="xietongdaiban"){

                    iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise");


                }else{
                    $(".hidehide").removeClass("hidehide");
                    $(".no-margin-left").removeClass("no-margin-left");
                    $(".no-top").removeClass("no-top");
                }


            }else{

                $(".hidehide").removeClass("hidehide");
                $(".no-margin-left").removeClass("no-margin-left");
                $(".no-top").removeClass("no-top");

            }


        });

    </script>
</div>