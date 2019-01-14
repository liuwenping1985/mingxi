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
                var mode = $(target).attr("data-mode");
                var height=$(target).attr("data-height");
                //window.location.href=link; 
                if(mode=="new"){
                        window.open(link);
                }else{
                     $("#pageLocator").attr("src",link);
                     $("#pageLocator").attr("height",height);
                    $(target).append(pointer);
                    $(target).addClass("lx-nav-this");
                }
               
                //$("").window.open("");
               
                
              
            });
            
             function getOnlineMemberSize(){

                 $.ajax({
                url: "/seeyon/menhu.do?method=getOnLineMemberNum",
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {
                    if(data.data<10||data.data.length<2){
                        $("#onlineNumSpan").html("&nbsp;&nbsp;"+data.data+"人");
                    }else{
                        $("#onlineNumSpan").html(data.data+"人"); 
                    }
                       
                
                },
                error: function (res) {

                }
            });
             }

             $("#modify_pwd").click(function(){

                  // alert("修改密码");
                   window.open("/seeyon/portal/portalController.do?method=personalInfoFrame&path=/individualManager.do?method=managerFrame&openType=menhu","修改密码","left=30%,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=500,height=400");
             });
             $("#to_top").click(function(){
                document.documentElement.scrollTop=document.body.scrollTop=0;
             });
             $("#keyWordSearch").click(function(){
                var  txt = encodeURIComponent($("#keyWordSearchInput").val());
                //alert(txt);
                var url = "/seeyon/main.do?method=main&openType=menhu&type=searchAll&keyword="+txt;
                window.open(url);
                ///seeyon/index/indexController.do?keyword=222&AdvanceOption=&method=searchAll

             });
             $("#keyWordSearchInput").keydown(function(event){
                var e = event || window.event || arguments.callee.caller.arguments[0];
                if(e && e.keyCode==13){ // 按 F2

                    $("#keyWordSearch").click();

                }


                
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

            function setHeartBeats(){
                    //Math.random()
                    ///seeyon/getAJAXMessageServlet?V=0.20373802510573413
               $.ajax({
                url: "/seeyon/getAJAXMessageServlet?V="+Math.random(),
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {
                  //  alert(data.N);
                   //console.log("test:suc");
                       // console.log(data);
                      getOnlineMemberSize();
                },
                error: function (data) {
                    //console.log("test:error");
                    //console.log(data.responseText);
                    if(data.responseText){
                        if(data.responseText.indexOf("[LOGOUT]")>=0){
                            var txt = (data.responseText+"").substring(data.responseText.indexOf("[LOGOUT]")+8);
                                layer.confirm(txt, {
                        btn: ['确定'] //可以无限个按钮
                     }, function(index, layero){
                    //按钮【按钮一】的回调
                         window.location.href="/seeyon/main.do?method=logout"
                      });
                                return;
                        }
                    }
                    setTimeout(setHeartBeats,30000);
                    getOnlineMemberSize();
                }
                });
               
            }
            setHeartBeats();
            $(".lx-btn-zq").click(function(e){
               
            
            });
            
        
            });

       



    });
}());