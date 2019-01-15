/**
 *
 *
 * layui和vue 一起用的时候会有一些冲突 导致代码写法比较冗余
 * 主页用纯粹js居多，样式和vue的绑定不适配，时间关系就不写Vue的组件了
 *
 * 没有webpack就是渣，还是react舒服
 */
;
(function () {

    $(document).ready(function () {
        var app = new Vue({
            el:"#pageHeader",
            data:{
                userName:"配置管理员"
            }
        });
        function show(linkContent) {

            $("#pageLayout").attr("src","/seeyon/nbd.do?method=goPage&page=dataList&data_type="+linkContent+"&v="+Math.random());

        }

        $("#config_list_btn").click(function () {
            show("data_link");
        });
        $("#a82other_list_btn").click(function () {
            show("a82other");
        });

        $("#other2a8_list_btn").click(function () {
            show("other2a8");
        });

        $("#log_list_btn").click(function () {

            show("log");
        });




    });



}())



// var pageNav = new Vue({
//     el:"#pageNav",
//     data:{
//
//     },
//     methods:{
//         changePage:function(e){
//             console.log(e);
//         }
//     }
//
//
//
//
// })