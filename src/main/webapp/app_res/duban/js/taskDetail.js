
(function(){
    lx.use(["jquery","laypage","col"],function(){
        var params = lx.eutil.getRequestParam();
        console.log(params);
        var laypage = layui.laypage;

        laypage.render({
            elem: 'paging'
            ,count: 10
            ,theme: '#1E9FFF'
        });

    });

})();