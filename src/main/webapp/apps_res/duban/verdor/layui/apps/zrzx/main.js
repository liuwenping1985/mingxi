;
(function () {
    lx.use(["jquery","layer", "carousel", "element", "portal"], function () {
        var $=lx.jquery;
        var layer = lx.layer;

        $(document).ready(function(){

            $(".lx-nav-item").click(function(e){
                var pointer = $("#triangle-pointer");

                $(".lx-nav-item").removeClass("lx-nav-this");
                $(".lx-nav-item p").removeClass("lx-nav-this");
                var e = e||window.event;
                var target = e.target;
                var link= $(target).attr("data-link");
            
               window.location.href=link; 
                $(target).append(pointer);
                $(target).addClass("lx-nav-this");
                //$("").window.open("");
               
                
              
            });
            $(".lx-changeFont-zq").click(function(e){

                $("#sTab1").show();
                $("#sTab2").show();
                $("#sTab3").show();
                $(".lx-changeFont-zq").removeClass("lx-nav-font");              
                var e = e||window.event;
                var target = e.target;
                $(target).addClass("lx-nav-font");

            });
            $(".icon_logout").click(function(){
                layer.confirm('确定退出？', {
                    btn: ['确定', '取消'] //可以无限个按钮
                }, function(index, layero){
                    //按钮【按钮一】的回调
                    window.location.href="/seeyon/main.do?method=logout"
                }, function(index){
                    //按钮【按钮二】的回调
                });

            });
          //  console.log($(".lx-btn_zq"));
            // $(".lx-btn_zq").live("click",function(e){
            //     $(".lx-btn_zq").addClass("lx-btn_zq1");
            //     $("#id").removeClass("lx-btn_zq1");
            //     var e = e||window.event;
            //     var target = e.target;
            //     $(target).addClass("lx-btn_zq2");
            //     alert(1);
            // });

            $(".lx-btn-zq").click(function(e){
               
            
            });
            
        
            });

       



    });
}());