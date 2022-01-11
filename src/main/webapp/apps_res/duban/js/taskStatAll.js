;(function () {
    layui.use(["jquery", "element", "table", "transfer", "layer", "form", "laydate"], function () {

        var $ = layui.$,
            ele = layui.element,
            table = layui.table,
            layer = layui.layer,
            form = layui.form,
            laydate = layui.laydate,
            transfer = layui.transfer,
            G_CONFIG = {};
        laydate.render({
            elem: '#time_min',
            value: new Date(new Date().getTime() - 30 * 2 * 24 * 3600 * 1000).format("yyyy-MM-dd")
        });
        laydate.render({
            elem: '#time_max',
            value: new Date(new Date().getTime() + 24 * 3600 * 1000).format("yyyy-MM-dd")
        });
        $("#hideQuery").click(function () {
            $("#queryDiv").hide();
            $("#showQueryDiv").show();
        });
        $("#showQuery").click(function () {
            $("#showQueryDiv").hide();
            $("#queryDiv").show();
        });
        var dept_selected_index = "";
        $("#deptSelectedCancel").click(function () {
            layer.close(dept_selected_index);
        });
        $("#deptSelectTextArea").click(function () {

            dept_selected_index = layer.open({
                type: 1,
                shade: false,
                title: true, //不显示标题
                title: '部门选择',
                area: ['546px', '498px'],
                content: $('#deptSelectedContainer'), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
                cancel: function () {

                }
            });

        });
        //[{"sort":1,"title":"办公室","value":"3065163262181393355"},{"sort":2,"title":"商务部","value":"-2509449334167942440"},{"sort":3,"title":"开发一部","value":"6911374949904761279"}]
        $("#deptSelectedOk").click(function () {

            var datas = transfer.getData("deptSelected");
            $("#deptSelectTextArea").val("");
            $("#deptValueInput").val("");
            var showNames = [];
            var ids = [];
            $(datas).each(function (index, item) {
                showNames.push(item.title);
                ids.push(item.value);
            });

            $("#deptSelectTextArea").val(showNames.join(","));
            $("#deptValueInput").val(ids.join(","));
            //layer.alert(JSON.stringify(data));
            $("#deptSelectedCancel").click();
        });

        $("#fire").click(function () {
            loadData();
        });

        function loadPies(queryParams) {
            var params = queryParams ? queryParams : form.val('queryForm');

            $.post(DB_DAO.getUrlPrefix() + "/seeyon/stat.do?method=dataStat4Pie", params, function (res) {

                //layer.alert(JSON.stringify(res));
                if (res.status == "0") {
                    var data = res.data;
                    renderPies(data);
                } else {
                    layer.alert("加载数据失败");
                }
            });

        }

        function loadLineAndTable(queryParams) {
            var params = queryParams ? queryParams : form.val('queryForm');
            $.post(DB_DAO.getUrlPrefix() + "/seeyon/duban.do?method=getStatData", {
                "start_date": $("#time_min").val(),
                "end_date": $("#time_max").val(),
                "deptIds": params.deptValue
            }, function (res) {

                //layer.alert(JSON.stringify(res));
                if (res.code == "200") {
                    var data = res.items;
                    renderLines(data);
                } else {
                    layer.alert("工作量部门统计无数据");
                }
            });

        }

        function loadData() {
            // var index = layer.load(1, {
            //     shade: [0.1,'#fff'] //0.1透明度的白色背景
            // });
            var params = form.val('queryForm');
            loadPies(params);
            //getStatData
            loadLineAndTable(params);

        }

        function renderPies(data) {
            var option = {
                title: {
                    text: '任务完成率统计',
                    subtext: $("#time_min").val() + "至" + $("#time_max").val(),
                    left: 'center'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)'
                },
                legend: {
                    orient: 'vertical',
                    left: 'left',
                    data: ['正在进行', '已经完成', '延期完成']
                },
                color:['#009688','#1E9FFF','#FF5722'],
                series: [
                    {
                        name: '占有率',
                        type: 'pie',
                        radius: '55%',
                        center: ['50%', '60%'],
                        data: [
                            {value: data["doingNow"], name: '正在进行'},
                            {value: data["doneOntime"], name: '已经完成'},
                            {value: data["doneDelay"], name: '延期完成'}
                        ],
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    }
                ]
            };
            var chartOne = echarts.init(document.getElementById('main'));
            chartOne.setOption(option);
            chartOne.on('click', function (params) {
                console.log(params);
            });

            var option2 = {
                title: {
                    text: '任务数量统计',
                    subtext: $("#time_min").val() + "至" + $("#time_max").val(),
                    left: 'center'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)'
                },
                legend: {
                    orient: 'vertical',
                    left: 'right',
                    data: ['正常', '低风险', '有风险', '高风险']
                },
                color:['#009688','#393D49','#FFB800','#FF5722'],
                series: [
                    {
                        name: '督办任务数量',
                        type: 'pie',
                        radius: '55%',
                        center: ['50%', '60%'],
                        data: [
                            {value: data["doingNormal"], name: '正常'},
                            {value: data["doingLowRisk"], name: '低风险'},
                            {value: data["doingMediumRisk"], name: '有风险'},
                            {value: data["doingHighRisk"], name: '高风险'}
                        ],
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    }
                ]
            };
            var chartTwo = echarts.init(document.getElementById('main2'));
            chartTwo.setOption(option2);
            chartTwo.on('click', function (params) {
                console.log(params);
            });
        }

        window.onRecordClick = function (taskIds, deptId) {

            window.open("/seeyon/duban.do?method=goPage&page=statDetail&taskIds=" + taskIds);
        }
        function renderTable(data) {
            var htmls = [];
            $("#dataBody").html("");
            $(data).each(function (index, item) {
                htmls.push("<tr onclick='onRecordClick(\"" + item.taskParams + "\",\"" + item.deptId + "\")' style='cursor:pointer'>");
                htmls.push("<td><a>" + item.deptName + "</a></td>");
                htmls.push("<td><a>" + item.renwuliang + "</a></td>");
                htmls.push("<td><a>" + item.taskCount + "(" + item.taskATypeCount + ")" + "</a></td>");
                htmls.push("<td><a>" + item.wancheng + "(" + ((parseFloat(item.wancheng) * 100) / parseFloat(item.taskCount)).toFixed(2) + "%)" + "</a></td>");
                htmls.push("<td><a>" + item.taskScore + "</a></td>");
                htmls.push("</tr>");
            });
            $("#dataBody").append(htmls.join(""));


        }

        var currentTitle = "工作量";
        form.on('radio(statForm)', function (data) {
            // layer.msg('开关checked：'+ (this.checked ? 'true' : 'false'), {
            //     offset: '6px'
            // });
            currentTitle = this.title;
            loadLineAndTable();

        });
        function renderLines(data) {
            renderTable(data);
            var tasklevel = G_CONFIG.task_level;

            var legends = [];
            var statType = form.val('statForm').statType;
            var yAxis_value = [];
            /**
             [{
                        name: '直接访问',
                        type: 'bar',
                        stack: '总量',
                        label: {
                            show: true,
                            position: 'insideRight'
                        },
                        data: [部门1, 部门2, 部门3, 部门4, 部门5, 部门6, 部门7]
                    }]
             * @type {Array}
             */
            var lineData = [];
            var dataBinder = {};
            $(tasklevel).each(function (index, item) {
                legends.push(item.showvalue);
                dataBinder[item.showvalue] = {
                    name: item.showvalue,
                    type: 'bar',
                    stack: currentTitle,
                    label: {
                        show: true,
                        position: 'insideRight'
                    },
                    data: []
                };
            });
            //这个index就是数组下表的数据
            $(data).each(function (index, item) {
                yAxis_value.push(item.deptName);
                var lineDatas = item.lineDatas;
                $(lineDatas).each(function (index2, linedot) {

                    var ld = dataBinder[linedot.taskLevelName];
                    var val = 0;
                    if (statType == "taskAmount") {
                        val = linedot.keGuanScore;

                    } else if (statType == "taskCount") {
                        val=1;
                    } else if (statType == "taskFinished") {
                        val = linedot.finished?0:1;
                    } else if (statType == "taskScore") {

                        val = linedot.keGuanScore;
                    }
                    var cur = ld.data[index];
                    if(!cur){
                        cur=0;
                    }
                    ld.data[index]= (cur+parseInt(val));
                });

            });
            $(tasklevel).each(function (index, item) {
                lineData.push(dataBinder[item.showvalue]);
            });

            var option3 = {
                title: {
                    text: currentTitle + '部门统计',
                    subtext: $("#time_min").val() + "至" + $("#time_max").val(),
                    left: 'center'
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                        type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                    }
                },
                legend: {
                    data: legends,
                    left: 'right'
                },
                color:['#FF5722','#FFB800','#393D49','#009688','lightgray'],
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'value'
                },
                yAxis: {
                    type: 'category',
                    data: yAxis_value
                },
                series: lineData
            };


            var chartThree = echarts.init(document.getElementById('main3'));
            chartThree.setOption(option3);
            chartThree.on('click', function (params) {
               console.log(params);
            });


        }

        function renderDeptSeleced() {

            $.get(DB_DAO.getUrlPrefix() + "/seeyon/duban.do?method=getDeptSimpleDataList", function (res) {
                G_CONFIG.DEPT_DATA = res;
                transfer.render({
                    elem: '#deptSelected'
                    , data: res
                    , title: ['部门', '所选部门']
                    , showSearch: true
                    , id: 'deptSelected'
                });
                //到这所有前置数据才算加载完
                //加载数据
                $("#fire").click();
            });
            //显示搜索框


        }

        function renderFormQueryCondition(task_source, task_level) {
            $.each(task_source, function (index, item) {
                $("#taskSource").append('<input checked="" value="' + item.sid + '" type="checkbox" name="taskSource.' + item.sid + '" title="' + item.showvalue + '">');
            });
            $.each(task_level, function (index, item) {
                $("#taskLevel").append('<input checked="" value="' + item.sid + '" type="checkbox" name="taskLevel.' + item.sid + '" title="' + item.showvalue + '">');
            });
            form.render();
            renderDeptSeleced();
        }

        function fire(items) {

            var task_source = [];
            var task_level = [];
            $.each(items, function (index, item) {
                if (item.enum_group == "task_source") {
                    task_source.push(item);
                } else if (item.enum_group == "task_level") {
                    task_level.push(item)
                }
            });
            task_source.sort(function (item1, item2) {
                return item1.sortnumber - item2.sortnumber;
            });
            task_level.sort(function (item1, item2) {
                return item1.sortnumber - item2.sortnumber;
            });
            G_CONFIG.task_source = task_source;
            G_CONFIG.task_level = task_level;
            renderFormQueryCondition(task_source, task_level);

        }

        //这里开启页面初始化
        $.get(DB_DAO.getUrlPrefix() + "/seeyon/duban.do?method=getDubanConfigItemDataList", function (res) {

            fire(res.items);
        });


    });
})();
