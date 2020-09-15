(function () {
    var exportObject = window;
    lx.use(["jquery", "layer", "laypage", "form", "element"], function () {
        var element = lx.element;
        var $ = lx.$;
        var layer = lx.layer;
        var D = DB_DAO;
        var laypage = layui.laypage;
        var form = lx.form;
        form.render();
        var templateMap = {
            "DB_DONE_APPLY": "",
            "DB_DELAY_APPLY": "",
            "DB_FEEDBACK": ""
        };
        var initCache = {};
        var havingLeaderTask = "false", havingSupervisorTask = "false";
        var data_mode = "leader";
        var curState = "RUNNING";
        //tab changed
        element.on('tab(mainTab)', function (ele) {
            var attr = this.getAttribute('lay-id');
            data_mode = attr;
            $("#" + attr + "_content").append($("#mainContent"));
            $("#mainContent").show();
            form.render();
            loadPageData(data_mode, curState);

        });

        var cur_query_layer_index = "";
        var cur_query_layer_content = "";


        $.get("/seeyon/duban.do?method=getPreProcessProperties", function (ret) {

            if (ret != null && ret.templateProperties) {
                templateMap = ret.templateProperties;
            }
            havingLeaderTask = ret.havingLeaderTask;
            havingSupervisorTask = ret.havingSupervisorTask;
            var showLeaderFirst = false;
            var loaded = false;
            if (havingLeaderTask == "true") {
                $("#leader").show();
                showLeaderFirst = true;
                element.tabChange('mainTab', "leader");
                initCache["leader"] = ret.leaderTaskList;
                loaded = true;
            }
            if (havingSupervisorTask == "true") {
                $("#duban").show();
                loaded = true;
                initCache["duabn"] = ret.supervisorTaskList;
                if (!showLeaderFirst) {
                    element.tabChange('mainTab', "duban");
                }
            }
            //默认承办
            if (!loaded) {
                element.tabChange('mainTab', "cengban");
            }
        });
        var filtering = {};
        exportObject.dbcx_click = function () {
            var q_f = $("#query_field").val();
            var q_f_v = $("#query_field_value").val();
            // $("#form_home").html(cur_query_layer_content);
            // layer.close(cur_query_layer_index);
            filtering["using"] = true;
            filtering["key"] = q_f;
            filtering["value"] = q_f_v;
            loadPageData(data_mode, curState);

        };
        exportObject.db_xg_click = function (xg) {

            window.open("/seeyon/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=" + xg + "&isNew=false&formTemplateId=-5918506883714365804&formId=6785761805197068041&moduleType=37&viewId=-7358326681974652894&rightId=-3223584436465611201");
        }
        exportObject.dbps_click = function (id) {

            window.open("/seeyon/duban.do?method=showDbps&sid=" + id + "&linkToType=" + data_mode);

        };
        exportObject.db_click = function (id) {

            window.open("/seeyon/duban.do?method=showDbps&sid=" + id + "&linkToType=" + data_mode);

        };
        exportObject.dbhb_click = function (id) {
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_FEEDBACK"] + "&data_id=" + id + "&linkToType=" + data_mode);
        };
        exportObject.dbbj_click = function (id) {
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_DONE_APPLY"] + "&data_id=" + id + "&linkToType=" + data_mode);
        };
        exportObject.dbyq_click = function (id) {
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=" + templateMap["DB_DELAY_APPLY"] + "&data_id=" + id + "&linkToType=" + data_mode);
        };
        exportObject.dbfj_click = function (id) {
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=3567084323371171881&data_id=" + id + "&linkToType=" + data_mode);
        };
        exportObject.db_detail_click = function (id) {
            window.open("/seeyon/duban.do?method=showDbps&sid=" + id + "&linkToType=" + data_mode);
        };
        exportObject.l_op_o_click = function () {
            var leader_op = $("#leader_op").val() || $("#leader_op").html();
            $.post("/seeyon/duban.do?method=addLeaderOpinion", {
                "taskId": cur_l_op_id,
                "opinion": leader_op
            }, function (data) {

                // console.log(data);
                $("#form_home").html(cur_query_layer_content);
                layer.close(cur_query_layer_index)
            })

        };
        exportObject.l_op_c_click = function () {
            $("#form_home").html(cur_query_layer_content);
            layer.close(cur_query_layer_index)

        };
        var cur_l_op_id = "";
        exportObject.dbps2_click = function (id) {
            cur_l_op_id = id;
            var kkkk = $("#form_home").html();
            $("#form_home").html("");
            cur_query_layer_content = kkkk;
            cur_query_layer_index = layer.open({
                type: 1,
                skin: 'layui-layer-rim', //加上边框
                area: ['420px', '240px'], //宽高
                content: kkkk,
                end: function () {
                    $("#form_home").html(cur_query_layer_content);
                }
            });


        };

        //左边按钮点击
        $(".task_list_btn").click(function () {
            var target = $(this);
            $(".task_list_btn").each(function (index, item) {
                if ($(item).hasClass("layui-btn-normal")) {
                    $(item).removeClass("layui-btn-normal");
                    $(item).addClass("layui-btn-primary");
                }
            });
            target.removeClass("layui-btn-primary");
            target.addClass("layui-btn-normal");
            var state = target.attr("id");
            if (state == "running_task_list") {

                curState = "RUNNING";
            }
            if (state == "done_task_list") {

                curState = "DONE";
            }
            if (state == "all_task_list") {

                curState = "ALL";
            }
            loadPageData(data_mode, curState);
        });


        function loadPageData(mode, state) {
            layer.load(1, {
                shade: [0.1, '#fff'] //0.1透明度的白色背景
            });
            setTimeout(function () {
                layer.closeAll('loading');
            }, 500);
            var _mode = mode || data_mode;
            var _state = state || curState;
            D.getDataByModeAndState(_mode, _state, function (data) {
                var mode = _mode;
                var container = $("#nakedBody");
                if (mode == "duban") {
                    $("#normal_table").hide();
                    $("#supervisor_table").show();
                    container = $("#nakedBodyMore");
                } else {
                    $("#supervisor_table").hide();
                    $("#normal_table").show();
                    container = $("#nakedBody");
                }


                container.empty();

                $.each(data, function (index, item) {
                    if (filtering.using) {
                        var val_ = item[filtering["key"]];
                        var val_2 = filtering["value"];
                        if (val_ && val_2) {
                            if (val_.indexOf(val_2) >= 0) {
                                renderRow(container, item);
                            }
                        } else {
                            renderRow(container, item);
                        }

                    } else {
                        renderRow(container, item);
                    }

                });

                filtering.using = false;
                laypage.render({
                    elem: 'paging'
                    , count: data.length || 1
                    , theme: '#1E9FFF'
                });


            });
        }

        function renderRow(container, item) {
            var htmls = [];
            var mode = data_mode;
            if (item.process == "") {
                item.process = "0";
            }
            if (item.mainWeight == "") {
                item.mainWeight = "--";
            }
            htmls.push("<tr>");

            if ("正常推进" == item.taskLight) {
                item.taskLight = "green";
            } else if ("低风险" == item.taskLight) {
                item.taskLight = "blue";
            } else if ("有风险但可控" == item.taskLight) {
                item.taskLight = "yellow";
            } else if ("风险不可控，不能按期完成" == item.taskLight) {
                item.taskLight = "red";
            } else {
                item.taskLight = "red";
            }
            htmls.push('<td class="td_no_padding"><i style="font-size: 24px; color: ' + item.taskLight + '" class="layui-icon layui-icon-circle-dot"></i></td>');
            htmls.push("<td style='cursor:pointer;width:140px' onclick=\"db_detail_click('" + item.uuid + "')\" class='td_no_padding'>" + item.name + "</td>");
            htmls.push("<td class='td_no_padding'>" + item.taskSource + "</td>");
            htmls.push("<td class='td_no_padding'>" + item.taskLevel + "</td>");
            htmls.push("<td class='td_no_padding'>" + new Date(item.endDate).format("yyyy-MM-dd hh:mm") + "</td>");
            htmls.push("<td class='td_no_padding'>" + item.period + "</td>");
            htmls.push("<td class='td_no_padding'>" + item.process + "%</td>");
            htmls.push("<td class='td_no_padding'>" + item.mainLeader + "</td>");
            htmls.push("<td class='td_no_padding'>" + item.mainDeptName + "</td>");
            if (mode == "duban") {
                var score = item.kgScore + item.zgScore + item.totoalScore;
                htmls.push("<td>" + (isNaN(score) ? 0 : score) + "</td>");
            }
            //最新进展
            var t_s = item["taskDescription"];
            var t_s_a_v = "";
            try {
                var str2 = t_s.replace(/\r\n/g, "$ojbk$");
                str2 = str2.replace(/\n/g, "$ojbk$");
                var t_s_a = str2.split("$ojbk$");
                t_s_a_v = t_s_a[0];
            } catch (e) {

            }

            if(t_s_a_v&&t_s_a_v.length>100){
                t_s_a_v =  t_s_a_v.substr(0,96)+"...";

            }
            htmls.push("<td class='td_no_padding' style='width:140px;max-height:200px'>" + t_s_a_v + "</td>");

            htmls.push("<td class='td_no_padding'>" + item.supervisor + "</td>");

            if ("leader" == mode) {
                htmls.push('<td class="td_no_padding"><div class="layui-row layui-col-space10"> <div class="layui-col-md6"> <button  onclick="dbps_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm dbps">查看</button> </div> <div class="layui-col-md6"> <button  onclick="dbps2_click(\'' + item.taskId + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm dbps">督办批示</button> </div> </td>');
            } else if ("duban" == mode) {

                htmls.push('<td class="td_no_padding"><div class="layui-row layui-col-space10"> <div class="layui-col-md12"> <button  onclick="db_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm dbps">查看</button> <button  onclick="db_xg_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm">修改</button> </div> </td>');
            } else if ("xieban" == mode) {
                htmls.push('<td class="td_no_padding"><div class="layui-row layui-col-space10">');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbhb_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn dbps">任务汇报</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbbj_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm dbps">办结申请</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbyq_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-danger dbps">延期申请</button></div>');
                // htmls.push('<div class="layui-col-md3"><button  onclick="dbfj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务分解</button></div>');
                htmls.push('</div> </td>');

            } else if ("cengban" == mode) {
                htmls.push('<td class="td_no_padding"><div class="layui-row layui-col-space10">');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbhb_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn dbps">任务汇报</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbbj_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-warm dbps">办结申请</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbyq_click(\'' + item.uuid + '\')" type="button" value="' + item.uuid + '" class="layui-btn layui-btn-xs  layui-btn-danger dbps">延期申请</button></div>');
                // htmls.push('<div class="layui-col-md3"><button  onclick="dbfj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务分解</button></div>');
                htmls.push('</div> </td>');
            } else {
                htmls.push("<td class='td_no_padding'></td>");
            }
            htmls.push("</tr>");

            container.append(htmls.join(""));

        }


    });

})();