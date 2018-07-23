
function getDimension(){
return {
    height:window.screen.availHeight,
    width:window.screen.availWidth
};
}

$(document).ready(function(){
   $(".ul_content").hide();
    var dimension = getDimension();
    $("#content").css("height",(dimension.height-378)+"px");
    function loadData(type){

        $.get("http://220.182.9.61:29001/seeyon/rikaze.do?method=loadData&type="+type,function(res){
                var data = res.data;
                if(!data){
                    return;
                }
                 var htmls = [];
                 $(data).each(function(index,item){
                    htmls.push("<li class='data_li'>");
                    htmls.push("<a class='li-item' onclick='openLink(\""+item.id+"\",\""+type+"\")'>");
                    htmls.push(item.title+"</a>");
                    htmls.push("<span class='li-span'>"+item.createDate+"</span>");
                    htmls.push("</li>");
                 });

            if(type=="tzgg"){
                $("#tzgg_ul").html("");
                $("#tzgg_ul").html(htmls.join(""));
            }
            if(type=="xxjb"){
                var data = res.data;
                $("#xxjb_ul").html("");
                $("#xxjb_ul").html(htmls.join(""));
             }
            if(type=="gzdt"){
                var data = res.data;
                $("#gzdt_ul").html("");
                $("#gzdt_ul").html(htmls.join(""));
            }
            if(type=="xxjl"){
                var data = res.data;
                $("#xxjl_ul").html("");
                $("#xxjl_ul").html(htmls.join(""));
            }
            if(type=="xzzx"){
                var data = res.data;
            }
            if(type=="ywzn"){
                var data = res.data;


            }
        });

    }
    function showContent(type){
        $(".ul_content").hide();
        if(type=="tzgg"){
            $("#tzgg").show();
            loadData("tzgg");
        }else if(type=="xxjb"){
            $("#xxjb").show();
             loadData("xxjb");
        }else if(type=="gzdt"){
             $("#gzdt").show();
             loadData("gzdt");
        }else if(type=="xxjl"){
            $("#xxjl").show();
            loadData("xxjl");
        }else if(type=="xzzx"){
            $("#xzzx").show();
            loadData("xzzx");
        }else if(type=="ywzn"){
            $("#ywzn").show();
            loadData("ywzn");
        }
    }
    $(".more_left_li").click(function(e){
        $(".more_left_li").removeClass("on");
        $(e.target).addClass("on");
        showContent($(e.target).attr("data-link"));
    });


});