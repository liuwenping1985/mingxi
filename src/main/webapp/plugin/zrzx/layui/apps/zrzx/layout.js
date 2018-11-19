var URL_BASE= "http://10.100.249.84:612";
var URL_REPO={

    "danweixinwen":URL_BASE+"/seeyon/menhu.do?method=getNewsList&typeId=1&offset=0&limit=6",
    "tupianxinwen":URL_BASE+"/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=6",
    "daibangongzuo":URL_BASE+"/seeyon/menhu.do?method=getUserCptList",
    "tongzhigonggao":URL_BASE+"/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&offset=0&limit=6",
    "zhongxincaidan":URL_BASE+"/seeyon/menhu.do?method=getBulData&typeId=-8736948720711547028"
}

var LAY_OUT_DEFINE = {
    root_id: "root_body",
    rows: [{

        cols: [{
            size: 4,
            id: "pending3",
            type: "sTab",
            name: "常用功能",
            children: [{

                cmp: "list",
                name: "常用功能",
                max: 5,
                data_url: URL_REPO.tongzhigonggao,
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "updateDate"
                }, {
                    "name": "publishDepartmentName"
                }]
            }]

        }, {
            size: 4,
            id: "col1",
            type: "common",    //默认空白
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
                data_url: URL_REPO.tupianxinwen,
                data_prop: {
                    "name": "title",
                    "img": "imgUrl"
                }

            }]
        }, {
            size: 4,
            id: "col2",
            type: "sTab",
            name: "单位新闻",

            children: [{
                name: "单位新闻",
                id: "unitNews",
                cmp: "list",
                data_url: URL_REPO.danweixinwen,
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {

                        return data;
                    },
                    "size": 9
                }, {
                    "name": "publishDate",
                    "size": 2
                }, {
                    "name": "publishDepartmentName",
                    "size": 1
                }]

            }]
        }]
    }, {
        style:"350px",
        cols: [{
            size: 12,
            id: "pending",
            type: "sTab",
            name:"待办工作",

            children: [{

                cmp: "list",
                name: "待办工作",
                max: 5,
                data_url: URL_REPO.daibangongzuo,
                data_prop: [{
                    "name": "subject",
                    render: function (name, data) {
                        return data;
                    },
                    size:9
                }, {
                    "name": "receiveTime",
                    size:3
                }]
            }]
        }]
    }, {
        cols:[{
            size: 6,
            id: "pending3",
            type: "sTab",
            name: "常用模板",
            children: [{

                cmp: "list",
                name: "常用模板",
                max: 5,
                data_url: URL_REPO.tongzhigonggao,
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "updateDate"
                }, {
                    "name": "publishDepartmentName"
                }]
            }]

        },{
            size: 6,
            id: "pending2",
            name: "日程安排",
            style:"height:400px",
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
                    dept: "办公室13"
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

    },{
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



    },{
        cols:[{
            size: 6,
            id: "col7",
            type: "sTab",
            name: "行前公示",
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
        },{
            size: 6,
            id: "col7",
            type: "sTab",
            name: "会议纪要",
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
    },{
        cols:[{
            size: 6,
            id: "col7",
            type: "sTab",
            name: "规章制度/保密法制教育",
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
        },{

            size: 6,
            id: "caidan",
            type: "list",
            name: "中心菜单（餐厅）",
            children: [{
                cmp: "list",
                name: "党建2",
                max: 5,
                data_url: URL_REPO.zhongxincaidan,
                data_prop: [{
                    "name": "title",
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "updateDate"
                }, {
                    "name": "publishDepartmentName"
                }]
            }]
        }]
    },{
        cols:[{
            size: 12,
            id: "col7",
            type: "sTab",
            name: "光荣榜、中心电影院",
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
                    }}, {
                    "name": "date"
                }, {
                    "name": "dept"
                }]
            }]
        }]
    }]
}