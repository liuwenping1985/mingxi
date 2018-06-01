;
(function () {
    $(".nav-link").click(function (e) {
        $(".nav-link").removeClass("active");
        $(e.target).addClass("active");
    });
    var $_$ = false;
    $(document).ready(function () {
      

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
                        window.location.href = "index.html"
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

        function checkLogin() {
            $.get("/seeyon/rikaze.do?method=checkLogin", function (data) {
                if (data.user == "no-body") {
                    $_$ = false;
                } else {

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
        ///seeyon/fileUpload.do?method=showRTE&fileId=-8295385800157609172&createDate=&type=image
        function getNews(){
            $.get("/seeyon/rikaze.do?method=getNews", function (data) {
            /* <a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:42px;border-top: 0px;border-bottom:0px;">
                <span>习近平会见世界经济论坛主席施瓦布</span>
                <span style="float:right">2018-05-21</span>
            </a>
            */
           //type1
                var gzdt=[];
                //type2
                var xxjb=[];
                if(!data.news){
                    return;
                }
                if(data.news.length==0){
                    return;
                }
                var max = 6;
                var imageData=[];
                $(data.news).each(function(index,item){
                    var isgzdt = false;
                    if(item.typeId==2){
                        isgzdt = false;
                    }else{
                        isgzdt = true;
                    }
                    if(item.imageId!=null&&item.iamgeId!=""){
                        imageData.push({"imgId":item.imageId,"title":item.title});
                    }
                    var htmlStr=[];
                    htmlStr.push('<a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:42px;border-top: 0px;border-bottom:0px;">');
                    htmlStr.push('<span><p class="rkz_infor_item">'+item.title+'</p></span>');
                    htmlStr.push('<span style="float:right">'+item.createDate.split(" ")[0]+'</span>');
                    if(isgzdt){
                        if(gzdt.length==max){
                            return;
                        }
                        gzdt.push(htmlStr.join(''));  
                    }else{
                        if(xxjb.length==max){
                            return;
                        }
                        xxjb.push(htmlStr.join(''));   
                    }
                });
               
                if(gzdt.length<max){
                    var left= max-gzdt.length;
                    for(var p=0;p<left;p++){
                        var htmlStr=[];
                        htmlStr.push('<a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:42px;border-top: 0px;border-bottom:0px;">');
                        htmlStr.push('<span></span>');
                        htmlStr.push('<span style="float:right"></span>');
                        gzdt.push(htmlStr.join(''));  
                    }
                }
                if(xxjb.length<max){
                    var left= max-xxjb.length;
                    for(var p=0;p<left;p++){
                        var htmlStr=[];
                        htmlStr.push('<a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:42px;border-top: 0px;border-bottom:0px;">');
                        htmlStr.push('<span></span>');
                        htmlStr.push('<span style="float:right"></span>');
                        xxjb.push(htmlStr.join(''));  
                    }
                }
                gzdt.push('<a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:40px;border-top: 0px"><span style="float:right;color:#007bff;margin-top:-5px">更多...</span></a>');
                xxjb.push('<a href="#" class="list-group-item list-group-item-action list-group-item-light" style="height:40px;border-top: 0px"><span style="float:right;color:#007bff;margin-top:-5px">更多...</span></a>');
               
                $("#gzdt").html(gzdt.join(""));

                $("#xxjb").html(xxjb.join(""));
                if(imageData.length>0){
                    //carouselExampleIndicators
                    //carousel-indicators
                    /**
                      <ol id="carousel-indicators" class="carousel-indicators">
                                        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                                        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                                        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
                                    </ol>
                     */
                    var olHtml=[];


                    //carousel-inner
                    var innerHtml=[];
                    /**
                     <div class="carousel-item active">
                                            <img class="d-block w-100" windth="540px" height="391px" src="images/1.jpg" alt="First slide">
                                            <div class="carousel-caption2 d-none d-md-block" style="width:100%;background-color: rgba(119,119,119,0.8) ">
                                                <p>国务院举行宪法宣誓</p>
                                            </div>
                                        </div>
                     */
                    $(imageData).each(function(index,item){
                        var innerHtmlStr=[];
                        if(index==0){
                            olHtml.push('<li data-target="#carouselExampleIndicators" data-slide-to="'+index+'" class="active"></li>');
                            innerHtmlStr.push(' <div class="carousel-item item active">');
                            innerHtmlStr.push('<img class="d-block w-100" windth="540px" height="330px" src="/seeyon/fileUpload.do?method=showRTE&fileId='+item.imgId+'&createDate=&type=image" alt="'+item.title+'">');
                            innerHtmlStr.push('<div class="carousel-caption2 d-none d-md-block" style="width:100%;background-color: rgba(119,119,119,0.8) ">');
                            innerHtmlStr.push(' <p class="rkz_infor_item">'+item.title+'</p>');
                            innerHtmlStr.push('</div></div>');
                            innerHtml.push(innerHtmlStr.join(''));
                        }else{
                            olHtml.push('<li data-target="#carouselExampleIndicators" data-slide-to="'+index+'"></li>'); 
                            innerHtmlStr.push('<div class="carousel-item item">');
                            innerHtmlStr.push('<img class="d-block w-100" windth="540px" height="330px" src="/seeyon/fileUpload.do?method=showRTE&fileId='+item.imgId+'&createDate=&type=image" alt="'+item.title+'">');
                            innerHtmlStr.push('<div class="carousel-caption2 d-none d-md-block" style="width:100%;background-color: rgba(119,119,119,0.8) ">');
                            innerHtmlStr.push(' <p class="rkz_infor_item">'+item.title+'</p>');
                            innerHtmlStr.push('</div></div>');
                            innerHtml.push(innerHtmlStr.join(''));
                        }
                    });

                    $("#carousel-indicators").html(olHtml.join(''));
                    $('#carousel-inner').html(innerHtml.join(""));

                }

              
            });
        }
        function getBuls(){
            $.get("/seeyon/rikaze.do?method=getBulData", function (data) {

                var message = [];
                //$("#notice").hide();
			
                if(!data.buls){
                    return;
                }
					
                if(data.buls.length==0){
                    return;
                }
                $(data.buls).each(function(index,item){
                    message.push(item.title);
                });
                $(data.buls).each(function(index,item){
                    message.push(item.title);
                });
                var htmls=[];
                $(message).each(function(index,item){
                    htmls.push('<li><a href="#">'+item+'</a></li>')
                });
                $("#notice_ul").append(htmls.join(""));

                var num = 0;
        
                function goLeft() {
                    //750是根据你给的尺寸，可变的
                    if (num == -1000) {
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
                },function () {
                        timer = setInterval(goLeft, 20);
                });
            });

        }
        checkLogin();
        getNews();
        getBuls();
    });


}());