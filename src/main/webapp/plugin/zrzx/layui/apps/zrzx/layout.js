var LAY_OUT_DEFINE = {
    root_id: "root_body",
    rows: [{
        
        cols: [{
            size: 6,
            id: "col1",
            type: "common",
            name: "单位图片新闻",
            children: [{
                id: "unitImgs",
                name: "单位图片新闻",
                cmp: "lunbo",
                cmp_options: {
                    id: "lunbo2",
                    change: function (res) {
                        console("changed");
                    },
                    size: 6,
                    interval: 3000
                },
                data: [{
                    title: "eeeee3e",
                    img: "http://t2.hddhhn.com/uploads/tu/201610/198/scx30045vxd.jpg"
                }, {
                    title: "8小时超2016年全天成交额 天猫双11见证消费升级力量",
                    img: "http://himg2.huanqiu.com/attachment2010/2018/1111/20181111092257522.png"
                }, {
                    title: "eeeeee",
                    img: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1541952762201&di=53e6359c8d445b46fbbdb75222f75156&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fa044ad345982b2b723f163ab3cadcbef76099b77.jpg"
                }],
                data_prop: [{
                    "name": "title"
                }, {
                    "name": "img"
                }],

            }]
        }, {
            size: 6,
            id: "col2",
             type: "sTab",
            name: "单位新闻",
            
            children: [{
                name: "单位新闻",
                id: "unitNews",
                cmp: "list",
                data: [{
                    "title": "李克强：抓紧解决政府部门和国有企业拖欠民营企业账款问题",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "生态环境部、交通运输部联合调研组到重庆调研船舶大气污染防治工作",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "生态环境部通报2018年11月中上旬全国空气质量预报会商结果",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "生态环境部： 水源地违法项目清理不允许打折扣",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "生态环境部通报蓝天保卫战重点区域 涉气问题45个",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "环境部： 水源地整治 12 个省份未达要求",
                    date: "2018-09-09",
                    dept: "办公室"
                }, {
                    "title": "生态环境部调研沈阳第二次全国污染源普查入户工作",
                    date: "2018-09-09",
                    dept: "办公室"
                }],

                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        if (data.indexOf("李克强") >= 0) {
                            return '<a class="layui-badge">焦点</a>' + data;
                        }
                        return data;
                    },
                    "size": 9
                }, {
                    "name": "date",
                    "size": 2
                }, {
                    "name": "dept",
                    "size": 1
                }]

            }]
        }]
    }, {
        height:"330px",
        cols: [{
            size: 4,
            id: "pending",
            type: "sTab",
            name:"待办工作",
           
            children: [{
              
                cmp: "list",
                name: "待办工作",
                max: 5,
                data: [{
                    "title": "待办工作1待办工作1",
                    date: "11-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作2待办工作1",
                    date: "11-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作3待办工作1",
                    date: "11-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作4待办工作1",
                    date: "11-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作5待办工作1",
                    date: "11-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作6待办工作1",
                    date: "09-09",
                    dept: "办公室2"
                }, {
                    "title": "待办工作7待办工作1",
                    date: "09-09",
                    dept: "办公室2"
                }],
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    },
                    size:6
                }, {
                    "name": "date",
                    size:3
                }, {
                    "name": "dept",
                    size:3
                }]
            }]
        }, {
            size: 4,
            id: "pending2",
            name: "常用模板",
            style:"height:350px",
            type: "sTab",
            children: [{
                id:"datepicker2",
                cmp: "datepicker",
                name: "常用模板",
                size:6,
                max: 5,
                data: [{
                    "title": "通知公告测试",
                    date: "2018-09-09",
                    dept: "办公室2"
                }],
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "date"
                }, {
                    "name": "dept"
                }]
            },{
                id:"datepicker",
                cmp: "common",
                  name: "常用模板",
                  size: 6,
                  max: 5
            }]
        }, {
            size: 4,
            id: "pending3",
            type: "sTab",
            name: "常用功能",
            children: [{
              
                cmp: "list",
                name: "常用功能",
                max: 5,
                data: [{
                    "title": "通知公告测试",
                    date: "2018-09-09",
                    dept: "办公室2"
                }],
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "date"
                }, {
                    "name": "dept"
                }]
            }]

        }]
    }, {
        cols: [{

            size: 12,
            id: "col5",
             type: "sTab",
             name: "党建",
            children: [{
                cmp: "list",
                name: "党建",
                max: 5,
                data: [{
                    "title": "通知公告测试",
                    date: "2018-09-09",
                    dept: "办公室2"
                }],
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "date"
                }, {
                    "name": "dept"
                }]
            }]
        }]



    }, {
        cols: [{

            size: 12,
            id: "col7",
            type: "sTab",
            name: "党建2",
            children: [{
                cmp: "list",
                name: "党建2",
                max: 5,
                data: [{
                    "title": "通知公告测试",
                    date: "2018-09-09",
                    dept: "办公室2"
                }],
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "date"
                }, {
                    "name": "dept"
                }]
            }]
        }]



    }]
}