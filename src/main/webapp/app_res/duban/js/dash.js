;(function(){
    layui.use(["jquery","element","table","layer","form"],function(){
        var $ = layui.$,ele = layui.element,table=layui.table,layer = layui.layer,form=layui.form;
        var p_util ={};

        window.Base=p_util;

        p_util.openSearch=function(param){

           var index = layer.open({
                type: 1,
                shade:  [0.3,'#000'] ,
                title: "查询条件设置", //不显示标题
                skin: 'layui-layer-rim', //加上边框
                area: ['620px', '440px'],
                anim: 2,
                shadeClose: false,
                closeBtn:1,
                content: $('#searchArea'), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
                cancel: function(){
                   // layer.msg()

                }
           });
            form.render();
            $("#searchArea").show();

        }




    });

})();
