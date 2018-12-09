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
                $(target).append(pointer);
                $(target).addClass("lx-nav-this");

            });
            $(".icon_logout").click(function(){
                layer.confirm('确定退出？', {
                    btn: ['确定', '取消'] //可以无限个按钮
                }, function(index, layero){
                    //按钮【按钮一】的回调
                }, function(index){
                    //按钮【按钮二】的回调
                });

            });



        });



    });
}());