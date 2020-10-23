;(function(){
    layui.use(["jquery","element","table","layer","form"],function() {
        var $ = layui.$, ele = layui.element, table = layui.table, layer = layui.layer, form = layui.form;

        var option = {
            title: {
                text: '完成率统计',
                subtext: '督办任务',
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
            series: [
                {
                    name: '督办任务',
                    type: 'pie',
                    radius: '55%',
                    center: ['50%', '60%'],
                    data: [
                        {value: 335, name: '正在进行',label:"正在进行(38%)"},
                        {value: 310, name: '已经完成',label:"已经完成(36%)"},
                        {value: 234, name: '延期完成',label:"延期完成(26%)"}
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
        var option2 = {
            title: {
                text: '正在进行',
                subtext: '共36个',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 10,
                data: ['正常', '低风险', '有风险', '高风险']
            },
            series: [
                {
                    name: '访问来源',
                    type: 'pie',
                    radius: ['50%', '70%'],
                    avoidLabelOverlap: false,
                    label: {
                        show: false,
                        position: 'center'
                    },
                    emphasis: {
                        label: {
                            show: true,
                            fontSize: '30',
                            fontWeight: 'bold'
                        }
                    },
                    labelLine: {
                        show: false
                    },
                    data: [
                        {value: 335, name: '正常'},
                        {value: 310, name: '低风险'},
                        {value: 234, name: '有风险'},
                        {value: 135, name: '高风险'}
                    ]
                }
            ]
        };


        echarts.init(document.getElementById('main')).setOption(option);
        echarts.init(document.getElementById('main2')).setOption(option2);
        //echarts.init(document.getElementById('main3')).setOption(option3);
    });
})();
