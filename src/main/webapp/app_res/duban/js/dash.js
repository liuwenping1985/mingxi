;(function(){
    layui.use(["jquery","element","table","layer","form"],function(){
        var $ = layui.$,ele = layui.element,table=layui.table,layer = layui.layer,form=layui.form;
        var p_util ={};
        window.Base=p_util;
        var current_leader_op=null;
        $("#leader_op_cancel_btn").click(function(){

            if(current_leader_op){
                layer.close(current_leader_op);
            }
        })

        p_util.openSearch=function(param){

           var index = layer.open({
                type: 1,
                shade:  [0.1,'#000'] ,
                title: "查询条件设置", //不显示标题
                skin: 'layui-layer-rim', //加上边框
                area: ['642px', '488px'],
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
        function filledLeaderOpinionPanelData(data){
            console.log(data);
            $("#leader_op_name").text(data.name);
            $("#leader_op_task_source").text(data.taskSource);
            $("#leader_op_task_level").text(data.taskLevel);
            $("#leader_op_deadline").text(new Date(data.endDate).format("yyyy-MM-dd"));
            $("#leader_op_main_dept").text(data.mainDeptName+"("+data.mainLeader+")");
            if(data.taskLight){
                $("#leader_op_process").text(data.taskLight+"(已完成"+data.process+"%)");
            }else{
                $("#leader_op_process").text("已完成"+data.process+"%");
            }

            var firstName = $("#leader_first_name").val();
            $("#xad_leader_op_input").attr("placeholder","请"+firstName+"总批示");
        }
        p_util.openLeaderOpinion=function(data){
            filledLeaderOpinionPanelData(data);
            current_leader_op = layer.open({
                type: 1,
                shade:  [0.1,'#000'] ,
                title: "黄河水电工作督办领导批示", //不显示标题
                area: ['649px', '581px'],
                anim: 2,
                shadeClose: false,
                closeBtn:1,
                content: $('#leaderOpinionArea'), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
                cancel: function(){
                    // layer.msg()

                }
            });
            form.render();
            $("#leaderOpinionArea").show();

        }




    });

})();
