;(function(){
    layui.use(["jquery","element","table","layer","form"],function(){
        var $ = layui.$,ele = layui.element,table=layui.table,layer = layui.layer,form=layui.form;
        var p_util ={},templateMap = {
            "DB_DONE_APPLY": "",
            "DB_DELAY_APPLY": "",
            "DB_FEEDBACK": ""
        };
        window.Base=p_util;
        var current_leader_op=null;
        $("#leader_op_cancel_btn").click(function(){

            if(current_leader_op){
                layer.close(current_leader_op);
            }
        });
        $("#leader_op_ok_btn").click(function(){
            var loading_index = layer.load(1, {
                shade: [0.1,'#000']
            });
            var taskId = $("#leader_task_id").val();
            DB_DAO.addLeaderOpinion({
                taskId:taskId,
                opinion:$("#xad_leader_op_input").val()||$("#xad_leader_op_input").text()
            },function (data){
                layer.close(loading_index);
                if(data.status=="0"){
                    if(current_leader_op){
                        layer.close(current_leader_op);
                    }
                    layer.msg('批示成功');

                }else{
                    layer.msg('批示失败，请联系管理员或刷新页面后重试');
                }

            });


        });

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
            $("#xad_leader_op_input").val("");
            $("#leader_op_name").text(data.name);
            $("#leader_task_id").val(data.taskId);
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
        p_util.openView=function(data_id,mode){
            window.open(DB_DAO.getUrlPrefix()+"/seeyon/duban.do?method=showDbps&sid=" + data_id + "&linkToType=" + mode);
        }
        p_util.modifyView=function(data_id){

            window.open(DB_DAO.getUrlPrefix()+"/seeyon/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId="+data_id+"&isNew=false&formTemplateId=-5918506883714365804&formId=6785761805197068041&moduleType=37&viewId=-7358326681974652894&rightId=-3223584436465611201");

        }
        p_util.feedback=function(data_id,data_mode){
            window.open(DB_DAO.getUrlPrefix()+"/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_FEEDBACK"] + "&data_id=" + data_id + "&linkToType=" + data_mode);
        }
        p_util.finish=function(data_id,data_mode){
            window.open(DB_DAO.getUrlPrefix()+"/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_DONE_APPLY"] + "&data_id=" + data_id + "&linkToType=" + data_mode);
        }
        p_util.delay=function(data_id,data_mode){
            window.open(DB_DAO.getUrlPrefix()+"/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_DELAY_APPLY"] + "&data_id=" + data_id + "&linkToType=" + data_mode);
        }
        var havingLeaderTask = "false", havingSupervisorTask = "false";
        $.get(DB_DAO.getUrlPrefix()+"/seeyon/duban.do?method=getPreProcessProperties", function (ret) {

            if (ret != null && ret.templateProperties) {
                templateMap = ret.templateProperties;
            }
            havingLeaderTask = ret.havingLeaderTask;
            havingSupervisorTask = ret.havingSupervisorTask;

            if (havingLeaderTask == "true") {
                $("#leader_content_li").show();
            }
            if (havingSupervisorTask == "true") {
                $("#supervisor_content_li").show();
            }
            //默认承办

        });




    });

})();
