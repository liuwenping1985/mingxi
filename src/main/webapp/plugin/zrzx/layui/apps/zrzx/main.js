;
(function () {
    lx.use(["carousel", "element", "panel", "s-tab"], function () {

        var carousel = layui.carousel;
        //建造实例
        carousel.render({
            elem: '#test1',
            width: '100%' //设置容器宽度
                ,
            arrow: 'always' //始终显示箭头
            //,anim: 'updown' //切换动画方式
        });

        var panel = lx.panel;
        var s_tab = lx["s-tab"];
        var tzgg = s_tab.create({
            parent_id: "cell1",
            "title": "通知公告"
        });
        tzgg.append("<p>1111111</p>");
        var ddtp = s_tab.create({
            parent_id: "cell2",
            "title": "图片新闻"
        });
        ddtp.append("<p>1111111</p>");
        var dwxxw = s_tab.create({
            parent_id: "cell3",
            "title": "单位新闻",
            style: "height:300px"
        });
        dwxxw.append("<p>1111111</p>");
        var gndh = s_tab.create({
            parent_id: "cell4",
            "title": "功能导航1",
            style: "height:300px"
        });
        gndh.append("<p>1111111</p>");

        var gndh2 = s_tab.create({
            parent_id: "cell5",
            "title": "功能导航2",
            style: "height:300px"
        });
        gndh2.append("<p>1111111</p>");
        var gndh3 = s_tab.create({
            parent_id: "cell6",
            "title": "功能导航3",
            style: "height:300px"
        });
        gndh3.append("<p>1111111</p>");
        var gndh4 = s_tab.create({
            parent_id: "cell7",
            "title": "功能导航7",
            style: "height:300px"
        });
        gndh4.append("<p>1111111</p>");
        var gndh5 = s_tab.create({
            parent_id: "cell8",
            "title": "功能导航8"
        });
        gndh5.append("<p>1111111</p>");

        var gndh6 = s_tab.create({
            parent_id: "cell9",
            "title": "功能导航9",
            style: "height:300px"
        });
        gndh6.append("<p>1111111</p>");
    });
}());