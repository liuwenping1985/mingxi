var URL_BASE = "";
var URL_REPO = {

    "danweixinwen": URL_BASE + "/seeyon/menhu.do?method=getNewsList&typeId=1&offset=0&limit=6",
    "tupianxinwen": URL_BASE + "/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=6",
    "daibangongzuo": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&offset=0&limit=6",
    "col_pending": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&offset=0&limit=8",
    "edoc_pending": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&offset=2&limit=8",
    "tongzhigonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&offset=0&limit=6",
    "zhongxincaidan": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-8736948720711547028&offset=0&limit=6",
    "liangxueyizuo": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8188009082124256867&offset=0&limit=6",
    "shijiuda": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7136252316133508367&offset=0&limit=6",
    "yianweijian": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2104797802172793544&offset=0&limit=6",
    "dangjiangongzuo": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=575989468633646689&offset=0&limit=6",
    "guizhangzhidu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=6",
    "guangrongbang": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=820644300868634954&offset=0&limit=6",
    "changyongmoban": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=9",
    "zwxxtb": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=6",
    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=6",
    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=6",
    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=6",
    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=6",
    "guizhangzhidu2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=8",
}

var LAY_OUT_DEFINE = {
    root_id: "root_body",
    rows: [{

        cols: [{
            size: 4,
            id: "pending3",
            type: "sTab",
            name: "通知公告",
            children: [{

                cmp: "list",
                name: "常用功能",
                max: 5,
                data_url: URL_REPO.tongzhigonggao,
                data_prop: [{
                    "name": "title",
                    size: 7,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "updateDate",
                    size: 2,
                    render: function (name, data) {
                        return data.substring(5, 10);
                    }
                }, {
                    "name": "publishDepartmentName",
                    size: 3
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
                    render: function (name, data, item, index) {
                        if (index < 2) {
                            return '<span><span style="font-size:16px"  class="layui-badge">焦点</span><span style="margin-left:3px">' + data + "</span></span>";
                        } else {
                            return data;
                        }

                    },
                    "size": 7
                }, {
                    "name": "publishDate",
                    render: function (name, data) {
                        return data.substring(5, 10);
                    },
                    "size": 2
                }, {
                    "name": "publishDepartmentName",
                    "size": 3
                }]

            }]
        }]
    }, {
        cols: [{
            size: 12,
            id: "tools",
            type: "custom",
            name: "门户链接",
            render: function (parent, col, layex) {
                var Mixed = layex.mixed;
                var $ = layex.jquery;
                var mixParent = Mixed.create({
                    id: "mixed0",
                    mode: "col",
                    size: 12,
                    style: "height:80px"
                });
                var mixRoot = Mixed.create({
                    id: "mixed1",
                    mode: "row",
                    size: 12
                });
                var mix1 = Mixed.create({
                    id: "mixed2",
                    mode: "col",
                    size: 12
                });
                var mix2 = Mixed.create({
                    id: "mixed2",
                    mode: "col",
                    size: 12
                });
                // var btn_htmls = ['<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color: #64d0c6;display:inline-block;text-align:center" class="layui-btn layui-btn-warm layui-btn-radius">发起公文</button></div>'];
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#1f85ec;display:inline-block;text-align:center" class="layui-btn layui-btn-warm layui-btn-radius">我要请假</button></div>');
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#5246c5;display:inline-block;text-align:center" class="layui-btn layui-btn-warm layui-btn-radius">我的日程</button></div>');
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#ff6d68;display:inline-block;text-align:center;min-width:92px" class="layui-btn layui-btn-warm layui-btn-radius">停车单</button></div>');
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#26a3ed;display:inline-block;text-align:center" class="layui-btn layui-btn-warm layui-btn-radius">外事公示</button></div>');
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#f9b954;display:inline-block;text-align:center" class="layui-btn layui-btn-warm layui-btn-radius">我的工资</button></div>');

                // for (var p = 0; p < btn_htmls.length; p++) {
                //     mix1.addCmp({
                //         size: 2,
                //         style: "height:40px",
                //         content: btn_htmls[p]
                //     });
                // }
                mix1.addCmp({
                    size: 12,
                    content: $("#btn_groups")
                })
                // btn_htmls = ['<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#1f85ec;display:inline-block;text-align:center" class="layui-btn-radius layui-btn layui-btn-warm">发起协同</button></div>', '<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color: #64d0c6;display:inline-block" class="layui-btn-radius layui-btn layui-btn-warm">发起公文</button></div>'];
                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#26a3ed;display:inline-block;min-width:92px;text-align:center" class="layui-btn-radius layui-btn layui-btn-warm">办公室</button></div>');

                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#f9b954;display:inline-block;min-width:92px;text-align:center" class="layui-btn-radius layui-btn layui-btn-warm">人事</button></div>');

                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#5246c5;display:inline-block;min-width:92px;text-align:center" class="layui-btn-radius layui-btn layui-btn-warm">此物</button></div>');

                // btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#ff6d68;display:inline-block;min-width:92px;text-align:center" class="layui-btn-radius layui-btn layui-btn-warm">国际处</button></div>');

                // for (var p = 0; p < btn_htmls.length; p++) {
                //     mix2.addCmp({
                //         size: 12,
                //         style: "height:95px",
                //         content: btn_htmls[p]
                //     });
                // }

                mixRoot.addCmp({
                    size: 12,
                    style: "height:136px",
                    content: mix1
                });
                // mixRoot.addCmp({
                //     size: 12,
                //     style: "height:45px",
                //     content: mix2
                // })
                mixParent.addCmp({
                    size: 3,
                    content: $(".zr_search"),
                    contentType: "html",
                    style: "height:136px"
                })
                mixParent.addCmp({
                    size: 9,
                    content: mixRoot,
                    contentType: "cmp",
                    style: "height:136px"
                })
                parent.append(mixParent);

            }
        }]
    }, {
        style: "350px",
        cols: [{
            size: 12,
            id: "pending",
            type: "custom",
            name: "待办工作",
            render: function (parent, col, layex) {
                var mTab = layex.mTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var $ = layex.jquery;
                var btn_htmls = ['<button style="background-color:#8693f3;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">6<span style="margin: 0 30px 0 30px">|</span>表单审批</button>'];
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#ff916e;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">3<span style="margin: 0 30px 0 30px">|</span>重要待办</button>');
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#5484ff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">2<span style="margin: 0 30px 0 30px">|</span>待开会议</button>');
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#3cbaff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">1<span style="margin: 0 30px 0 30px">|</span>领导安排</button>');

                var mix1 = Mixed.create({
                    id: "mixed1",
                    mode: "col",
                    cmps: [{
                        contentType: "html",
                        content: btn_htmls.join(""),
                        style: "height:240px",
                        size: 2
                    }]
                });
                var list1 = List.create({
                    data_url: URL_REPO.daibangongzuo,
                    data_prop: [{
                        "name": "subject",
                        render: function (name, data) {
                            return data;
                        },
                        size: 8
                    }, {
                        "name": "senderName",
                        size: 2,
                        render: function (name, data) {
                            if (!data) {
                                return "艾志";
                            }
                            return data.substring(5, 10);
                        }
                    }, {
                        "name": "receiveFormatDate",
                        size: 2,
                        render: function (name, data) {
                            if (!data) {
                                return "11-20";
                            }
                            return data.substring(5, 10);
                        }
                    }]
                });
                mix1.addCmp({
                    content: list1,
                    size: 10,
                    style: "height:240px"
                });
                var list2 = List.create({
                    data_url: URL_REPO.col_pending,
                    data_prop: [{
                        "name": "subject",
                        render: function (name, data) {
                            return data;
                        },
                        size: 8
                    }, {
                        "name": "senderName",
                        size: 2
                    }, {
                        "name": "receiveFormatDate",
                        render: function (name, data) {

                        },
                        size: 2
                    }]
                });
                var list3 = List.create({
                    data_url: URL_REPO.edoc_pending,
                    data_prop: [{
                        "name": "subject",
                        render: function (name, data) {
                            return data;
                        },
                        size: 8
                    }, {
                        "name": "senderName",
                        size: 2
                    }, {
                        "name": "receiveFormatDate",
                        size: 2
                    }]
                });
                var mt = mTab.create({
                    id: "pending-main",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>待处理(10)</span>",
                        checked: true,
                        contentType: "cmp",
                        content: mix1
                    }, {
                        "name": "<span style='color: #1E9FFF'>超期(8)</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list2
                    }, {
                        "name": "<span style='color: #1E9FFF'>暂存(6)</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list3
                    }, {
                        "name": "<span style='color: #1E9FFF'>已发(9)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>已办(10)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>会议(5)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>待办任务(6)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>已完成任务(5)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>已超期任务(7)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>关注任务(8)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }]
                });
                // console.log($("#work_area"));

                parent.append($("#work_area"));
                $("#work_area_body").append(mt.root);


            }
        }]
    }, {
        cols: [{
            size: 6,
            id: "pending3",
            type: "custom",
            name: "常用模版",
            render:function(parent,col,layex){
                var $ = layex.jquery;
                var mTab = layex.mTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var listLeft = List.create({
                    data_url: URL_REPO.changyongmoban,
                    data_prop: [{
                        "name": "subject",
                        render: function (name, data) {
                            return data;
                        },
                        size: 12
                    }]
                });
                var listRight = List.create({
                    data_url: URL_REPO.changyongmoban,
                    data_prop: [{
                        "name": "subject",
                        render: function (name, data) {
                            return data;
                        },
                        size: 12
                    }]
                });
                var mixRoot = Mixed.create({
                    mode:"col",
                    size:12
                });
                var mixLeft = Mixed.create({
                    mode:"col",
                    size:12
                });
                mixLeft.addCmp({
                    contentType:"cmp",
                    content:listLeft,
                    size:12
                });
                var mixRight = Mixed.create({
                    mode:"col",
                    size:12
                });
                mixRight.addCmp({
                    contentType:"cmp",
                    content:listRight,
                    size:12
                });
                mixRoot.addCmp({
                    contentType:"cmp",
                    content:mixLeft,
                    size:6
                });
                mixRoot.addCmp({
                    contentType:"cmp",
                    content:mixRight,
                    size:6
                });
                var mt = mTab.create({
                    id: "pending-template",
                    root_style:"height:380px",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>常用模板</span>",
                        checked: true,
                        contentType: "cmp",
                        content: mixRoot
                    }]
                });
                parent.append(mt);
            }

        }, {
            size: 6,
            id: "pending2",
            name: "日程安排",
            type: "custom",
            render:function(parent,col,lx){
                var $ = lx.jquery;
                var DatePicker = lx.datepicker;
                var Mixed = lx.mixed;
                var mTab = lx.mTab;
                var mixedRoot = Mixed.create({
                    id:"dp_micker",
                    mode:"col",
                    size:12
                });
                var mixedLeft = Mixed.create({
                    id:"dp_micker_left",
                    mode:"col",
                    size:12
                });
                var mixedRight = Mixed.create({
                    id:"dp_micker_right",
                    mode:"col",
                    size:12
                });
                mixedRoot.addCmp({
                    contentType:"cmp",
                    content:mixedLeft,
                    size:6
                });
                mixedRoot.addCmp({
                    contentType:"cmp",
                    content:mixedRight,
                    size:6
                });
                mixedRight.addCmp({
                    content:$("#leader_calendar"),
                    size:12
                })
                var mt = mTab.create({
                    id: "pending-template",
                    root_style:"height:380px",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>日程管理</span>",
                        checked: true,
                        contentType: "cmp",
                        content: mixedRoot
                    }]
                });
                parent.append(mt);
                DatePicker.create({
                    "id":"picker",
                    "className":"",
                    parent:mixedLeft
                });


            },
            children: [{
                id: "datepicker2",
                cmp: "common",
                name: "常用模板",
                size: 6,
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
        cols:[{
            size: 12,
            id: "col5",
            type: "custom",
            name: "横幅图片",
            render:function(parent,col,layex){
                var $ = layex.jquery;
                parent.append($("#banner"));
            }
        }]


    }, {
        cols: [{

            size: 12,
            id: "col5",
            type: "custom",
            name: "党建工作",
            render: function (parent, col, layex) {
                var mTab = layex.mTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var mixedRoot = Mixed.create({
                    id: "mixed2",
                    mode: "col"
                });
                parent.append(mixedRoot);
                var mixed1 = Mixed.create({
                    id: "mixed3",
                    mode: "col",
                    size: 12
                });
                mixedRoot.addCmp({
                    contentType: "cmp",
                    content: mixed1,
                    size: 12
                });
                // var mixed2 = Mixed.create({
                //     id: "mixed4",
                //     mode: "col",
                //     size: 12
                // });
                // mixedRoot.addCmp({
                //     contentType: "cmp",
                //     content: mixed2,
                //     size: 6
                // });
                var list = List.create({
                    data_url: URL_REPO.dangjiangongzuo,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {
                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list3 = List.create({
                    data_url: URL_REPO.yianweijian,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {
                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list4 = List.create({
                    data_url: URL_REPO.shijiuda,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {
                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list2 = List.create({
                    data_url: URL_REPO.liangxueyizuo,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {

                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });

                var mt = mTab.create({
                    id: "pending-main-1",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>以案为鉴专项治理</span>",
                        checked: true,
                        contentType: "cmp",
                        content: list3
                    }, {
                        "name": "<span style='color: #1E9FFF'>党建工作公示</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list
                    }, {
                        "name": "<span style='color: #1E9FFF'>十九大专题</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list4
                    }, {
                        "name": "<span style='color: #1E9FFF'>两学一做专题</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list2
                    }, {
                        "name": "<span style='color: #1E9FFF'>党建工作公示</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #1E9FFF'>十八大文档</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }]
                });
               
                mixed1.addCmp({
                    contentType: "cmp",
                    content: mt,
                    size: 12
                });
               

            }
        }]
    },{
        cols:[{
            size:12,
            type:"custom",
            name:"党建任务",
            render:function(parent,colm,lx){
                var $ = lx.jquery;
                var mTab = lx.mTab;
                var List = lx.list;
                var mt = mTab.create({
                    id: "pending-dj",
                    root_style:"height:455px",
                    body_class:"layui-tab-content lx_no_height",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>党委办公室</span>",
                        checked: true,
                        contentType: "jq",
                        content: $("#danjianrenwu")
                    }]
                });
                parent.append(mt);
               var listP= $("#guizhangzhidu");
               var gzzd = List.create({
                data_url: URL_REPO.guizhangzhidu2,
                mode:"table",
                data_prop: [{
                    "name": "frName",
                    render: function (name, data) {

                        return data;
                    },
                    size: 12
                }]
            });
            listP.append(gzzd.root);
            //bjbgz
            var listP2= $("#bjbgz");
            var gzzd2 = List.create({
             data_url: URL_REPO.guizhangzhidu2,
             mode:"table",
             data_prop: [{
                 "name": "frName",
                 render: function (name, data) {

                     return data;
                 },
                 size: 12
             }]
         });
         listP2.append(gzzd2.root);
               
            }
        }]
    },{
        cols:[{
            size:12,
            type:"custom",
            name:"排名",
            render:function(parent,colm,lx){
                var $ = lx.jquery;
                parent.append($("#paiming"));
            }
        }]
    },{
        cols:[{
            size:12,
            type:"custom",
            name:"连接",
            render:function(parent,colm,lx){
                var $ = lx.jquery;
                parent.append($("#other_link"));
            }
        }]
    },{
        cols:[{
            size:12,
            type:"custom",
            name:"任务计划",
            render:function(parent,colm,lx){
                var $ = lx.jquery;
                var mTab = lx.mTab;
                parent.append($("#plan_main"));
                var mt = mTab.create({
                    id: "pending-dj-jh",
                    root_style:"height:660px",
                    body_class:"layui-tab-content lx_no_height",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>年度计划</span>",
                        checked: true,
                        contentType: "jq",
                        content: $("#plan_main")
                    }]
                });
                parent.append(mt);
            }
        }]
    }, {
        cols: [{
            size: 6,
            id: "col7",
            type: "sTab",
            name: "行前公示",
            children: [{
                cmp: "list",
                name: "行前公示",
                max: 5,
                data_url: URL_REPO.xqgs,
                data_prop: [{
                    "name": "frName",
                    size: 10,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "createTime",
                    size: 2,
                    render: function (name, data) {
                        return data.substring(5, 10);
                    }
                }]
            }]
        }, {
            size: 6,
            id: "col7",
            type: "sTab",
            name: "会议纪要",
            children: [{
                cmp: "list",
                name: "会议纪要",
                max: 5,
                data_url: URL_REPO.hyjy,
                data_prop: [{
                    "name": "frName",
                    size: 10,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "createTime",
                    size: 2,
                    render: function (name, data) {
                        return data.substring(5, 10);
                    }
                }]
            }]
        }]
    }, {
        cols: [{
            size: 12,
            id: "123",
            name: "",
            type: "custom",
            render: function (parent, col, layex) {

                var html = [];

                parent.append(html.join(""));

            }


        }]




    }, {
        cols: [{
            size: 12,
            id: "col7",
            type: "custom",
            name: "规章制度/保密法制教育",
            render: function (parent, col, layex) {
                var mTab = layex.mTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var mixedRoot = Mixed.create({
                    id: "mixed2",
                    mode: "col"
                });
                parent.append(mixedRoot);
                var mixed1 = Mixed.create({
                    id: "mixed3",
                    mode: "col",
                    size: 12
                });
                mixedRoot.addCmp({
                    contentType: "cmp",
                    content: mixed1,
                    size: 6
                });
                var mixed2 = Mixed.create({
                    id: "mixed4",
                    mode: "col",
                    size: 12
                });
                mixedRoot.addCmp({
                    contentType: "cmp",
                    content: mixed2,
                    size: 6
                });
                var gzzd = List.create({
                    data_url: URL_REPO.guizhangzhidu,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {

                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var bmfzjy = List.create({
                    data_url: URL_REPO.bmfzjy,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data) {

                            return data;
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var zxcd = List.create({
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
                });
                var mt = mTab.create({
                    id: "pending-main-3",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>规章制度</span>",
                        checked: true,
                        contentType: "cmp",
                        content: gzzd
                    }, {
                        "name": "<span style='color: #1E9FFF'>保密法制教育</span>",
                        checked: false,
                        contentType: "cmp",
                        content: bmfzjy
                    }]
                });
                var mt2 = mTab.create({
                    id: "pending-main-4",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>中心菜单</span>",
                        checked: true,
                        contentType: "cmp",
                        content: zxcd
                    }]
                });
                mixed1.addCmp({
                    contentType: "cmp",
                    content: mt,
                    size: 12
                });
                mixed2.addCmp({
                    contentType: "cmp",
                    content: mt2,
                    size: 12
                });
            }
        }]
    }, {
        cols: [{
            size: 6,
            id: "col7",
            type: "sTab",
            name: "光荣榜",
            children: [{
                cmp: "list",
                name: "光荣榜",
                max: 5,
                data_url: URL_REPO.guangrongbang,
                data_prop: [{
                    "name": "frName",
                    size: 10,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "createTime",
                    size: 2,
                    render: function (name, data) {
                        return data.substring(5, 10);
                    }
                }]
            }]
        }, {
            size: 6,
            id: "col7",
            type: "sTab",
            name: "中心影院",
            children: [{
                cmp: "list",
                name: "中心影院",
                max: 5,
                data_url: URL_REPO.zxyy,
                data_prop: [{
                    "name": "frName",
                    size: 10,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "createTime",
                    size: 2,
                    render: function (name, data) {
                        return data.substring(5, 10);
                    }
                }]
            }]
        }]
    }]
}