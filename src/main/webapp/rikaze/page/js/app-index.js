;
(function () {
    $(".nav-link").click(function(e){
        $(".nav-link").removeClass("active");
        $(e.target).addClass("active");
    });
    var $_$ = false;
    $(document).ready(function () {
        var message = ["习近平会见世界经济论坛主席施瓦布", "习近平这些“金句”告诉你，中国开放的大门越开越大", "新一届国务院举行宪法宣誓仪式 李克强总理监誓", "国务院新组建部门第二批挂牌分别举行 韩正出席应急管理部挂牌仪式", "《习近平关于总体国家安全观论述摘编》出版发行"];
        //$("#notice").hide();
        var num = 0;

        function goLeft() {
            //750是根据你给的尺寸，可变的
            if (num == -750) {
                num = 0;
            }
            num -= 1;
            $(".scroll").css({
                left: num
            })
        }
        //设置滚动速度
        var timer = setInterval(goLeft, 20);
        //设置鼠标经过时滚动停止
        $(".box").hover(function () {
                clearInterval(timer);
            },
            function () {
                timer = setInterval(goLeft, 20);
            })

        $("#login-btn").click(function () {
            $('.theme-popover-mask').fadeIn(100);
            $('.theme-popover').slideDown(200);

        });
        $("#login-btn-2").click(function () {
            $('.theme-popover-mask').fadeIn(100);
            $('.theme-popover').slideDown(200);
            var userName = $("#inputUserName").val();
            var password = $("#inputPassword").val();
            $("#login_username").val(userName);
            $("#login_password").val(password);
            // $('#login-form').submit();
            var options = {
                success: function (data) {
                    $("#login_info").html("欢迎您," + userName);
                    $("#login-btn").hide();
                    $_$ = true;
                    $("#login_info").show();
                    $('.theme-popover-mask').fadeOut(100);
                    $('.theme-popover').slideUp(200);
                    $("#logout-btn").show();

                },
                error: function (errorInfo) {
                    console.log(errorInfo);
                    alert("登录失败");
                }
            };
            $('#login-form').ajaxSubmit(options);

        });
        $("#logout-btn").click(function () {
            if (confirm("您确定要退出吗？")) {
                $("#logout-btn").hide();
                //window.location.href = "/seeyon/main.do?method=logout";
                $("#logout-form").ajaxSubmit({
                    success: function (data) {
                        $("#login_info").hide();
                        $("#login-btn").show();
                        $_$ = false;
                        $("#logout-btn").hide();

                    },
                    error: function (errorInfo) {
                       window.location.href="index.html"
                    }
                });
            }
        });

        $('.theme-poptit .close').click(function () {
            $('.theme-popover-mask').fadeOut(100);
            $('.theme-popover').slideUp(200);
        })

        $("#btn-fawen").click(function () {
            if (!$_$) {
                alert("请先登录");
                return;
            }
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=6589483643434978648&app=4&sub_app=1");
        });
        $("#btn-banwen").click(function () {
            if (!$_$) {
                alert("请先登录");
                return;
            }
            ///seeyon/collaboration/pending.do?method=morePending&fragmentId=-7771288622128478783&ordinal=0&currentPanel=sources&rowStr=subject,deadLine,edocMark,sendUnit,sendUser&columnsName=待办公文
            window.open("/seeyon/main.do?method=main&fragmentId=-7771288622128478783&from=menhu&type=banwen");
        });
        $("#btn-shouwen").click(function () {
            if (!$_$) {
                alert("请先登录");
            }
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=-2592679227520888888&app=4&sub_app=2");
            ///seeyon/govDoc/govDocController.do?method=govDocSend&amp;_resourceCode=F20_govDocSendManage

        });
        $("#btn-yuewen").click(function () {
            if (!$_$) {
                alert("请先登录");
                return;
            }
            window.open("/seeyon/main.do?method=main&fragmentId=-7771288622128478783&from=menhu&type=yuewen");
        });

        function checkLogin(){
        $.get("/seeyon/rikaze.do?method=checkLogin",function(data){

        console.log(data);
		if(data.user=="no-body"){
			$_$=false;
		}else{

                     $("#login_info").html("欢迎您," + data.user);
                                        $("#login-btn").hide();
                                        $_$ = true;
                                        $("#login_info").show();
                                        $('.theme-popover-mask').fadeOut(100);
                                        $('.theme-popover').slideUp(200);
                                        $("#logout-btn").show();
		}

        });





        }
        checkLogin();
    });


}());