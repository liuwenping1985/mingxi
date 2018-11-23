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
    "changyongmoban": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=6",
    "zwxxtb": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=6",
    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=6",
    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=6",
    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=6",
    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=6"
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
                var sTab = layex.sTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var DatePicker = layex.datepicker;
                var $ = layex.jquery;
                var pdm = $("#pending_main_area");
                parent.append(pdm);
                var root = $("#pending_main_body");
                var mixed = Mixed.create({
                    id: "mixed-pending",
                    mode: "col",
                    size: 12
                });
                root.append(mixed.root);
                var pdList = sTab.create({
                    "title": "协同管理"
                });
                var jbList = sTab.create({
                    "title": "任务&督办"
                });
                mixed.addCmp({
                    contentType: "cmp",
                    content: pdList,
                    size: 6
                });
                mixed.addCmp({
                    contentType: "cmp",
                    content: jbList,
                    size: 6
                });
                var pending_list = List.create({
                    data_url: window.URL_REPO.col_pending,
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
                            if (!data) {
                                return "";
                            }
                            return data.substring(5, 10);
                        },
                        size: 2
                    }]
                });
                var pending_list_2 = List.create({
                    data_url: window.URL_REPO.col_pending,
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
                            if (!data) {
                                return "";
                            }
                            return data.substring(5, 10);
                        },
                        size: 2
                    }]
                });
                var mt = mTab.create({
                    id: "pending-list-body-01",
                    root_class: "layui-tab",
                    tabs: [{
                        "name": "<span style='color: #009688'>待处理(6)</span>",
                        checked: true,
                        contentType: "cmp",
                        content: pending_list
                    }, {
                        "name": "<span style='color: #000'>超期(0)</span>",
                        checked: false,
                        contentType: "html",
                        content: "超期（0）"
                    }, {
                        "name": "<span style='color: #000'>暂存(0)</span>",
                        checked: false,
                        contentType: "html",
                        content: "暂存（0）"
                    }, {
                        "name": "<span style='color: #000'>已发(1)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #000'>已办(1)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #000'>会议(1)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }]
                });
                var mt2 = mTab.create({
                    id: "pending-list-body-01",
                    root_class: "layui-tab",
                    tabs: [{
                        "name": "<span style='color: #009688'>待办任务(6)</span>",
                        checked: true,
                        contentType: "cmp",
                        content: pending_list_2
                    }, {
                        "name": "<span style='color: #000'>督办任务(0)</span>",
                        checked: false,
                        contentType: "html",
                        content: "超期（0）"
                    }, {
                        "name": "<span style='color: #000'>已完成(0)</span>",
                        checked: false,
                        contentType: "html",
                        content: "暂存（0）"
                    }, {
                        "name": "<span style='color: #000'>已超期(1)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }, {
                        "name": "<span style='color: #000'>关注(1)</span>",
                        checked: false,
                        contentType: "html",
                        content: ""
                    }]
                });
                pdList.append(mt);

                jbList.append(mt2); var URL_BASE = "";
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
                    "changyongmoban": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=6",
                    "zwxxtb": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=6",
                    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=6",
                    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=6",
                    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=6",
                    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=6"
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
                                var sTab = layex.sTab;
                                var List = layex.list;
                                var Mixed = layex.mixed;

                                var $ = layex.jquery;
                                var pdm = $("#pending_main_area");
                                parent.append(pdm);
                                var root = $("#pending_main_body");
                                var mixed = Mixed.create({
                                    id: "mixed-pending",
                                    mode: "col",
                                    size: 12
                                });
                                root.append(mixed.root);
                                var pdList = sTab.create({
                                    "title": "协同管理"
                                });
                                var jbList = sTab.create({
                                    "title": "任务&督办"
                                });
                                mixed.addCmp({
                                    contentType: "cmp",
                                    content: pdList,
                                    size: 6
                                });
                                mixed.addCmp({
                                    contentType: "cmp",
                                    content: jbList,
                                    size: 6
                                });
                                var pending_list = List.create({
                                    data_url: window.URL_REPO.col_pending,
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
                                            if (!data) {
                                                return "";
                                            }
                                            return data.substring(5, 10);
                                        },
                                        size: 2
                                    }]
                                });
                                var pending_list_2 = List.create({
                                    data_url: window.URL_REPO.col_pending,
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
                                            if (!data) {
                                                return "";
                                            }
                                            return data.substring(5, 10);
                                        },
                                        size: 2
                                    }]
                                });
                                var mt = mTab.create({
                                    id: "pending-list-body-01",
                                    root_class: "layui-tab",
                                    tabs: [{
                                        "name": "<span style='color: #009688'>待处理(6)</span>",
                                        checked: true,
                                        contentType: "cmp",
                                        content: pending_list
                                    }, {
                                        "name": "<span style='color: #000'>超期(0)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: "超期（0）"
                                    }, {
                                        "name": "<span style='color: #000'>暂存(0)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: "暂存（0）"
                                    }, {
                                        "name": "<span style='color: #000'>已发(1)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: ""
                                    }, {
                                        "name": "<span style='color: #000'>已办(1)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: ""
                                    }, {
                                        "name": "<span style='color: #000'>会议(1)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: ""
                                    }]
                                });
                                var mt2 = mTab.create({
                                    id: "pending-list-body-01",
                                    root_class: "layui-tab",
                                    tabs: [{
                                        "name": "<span style='color: #009688'>待办任务(6)</span>",
                                        checked: true,
                                        contentType: "cmp",
                                        content: pending_list_2
                                    }, {
                                        "name": "<span style='color: #000'>督办任务(0)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: "超期（0）"
                                    }, {
                                        "name": "<span style='color: #000'>已完成(0)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: "暂存（0）"
                                    }, {
                                        "name": "<span style='color: #000'>已超期(1)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: ""
                                    }, {
                                        "name": "<span style='color: #000'>关注(1)</span>",
                                        checked: false,
                                        contentType: "html",
                                        content: ""
                                    }]
                                });
                                pdList.append(mt);

                                jbList.append(mt2);


                            }
                        }]
                    }, {
                        cols: [{
                            size: 6,
                            id: "pending3",
                            type: "sTab",
                            name: "常用模版",
                            children: [{

                                cmp: "list",
                                name: "常用模板",
                                max: 5,
                                data_url: URL_REPO.changyongmoban,
                                data_prop: [{
                                    "name": "subject",
                                    render: function (name, data) {
                                        return data;
                                    }

                                }]
                            }]

                        }, {
                            size: 6,
                            id: "rcgl",
                            name: "日程管理",
                            type: "custom",
                            render:function(parent,col,layex){

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
                                    }]
                                });
                                var list5 = List.create({
                                    data_url: URL_REPO.zwxxtb,
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
                                var list6 = List.create({
                                    data_url: URL_REPO.zwxxtb,
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
                                var list7 = List.create({
                                    data_url: URL_REPO.zwxxtb,
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
                                var mt2 = mTab.create({
                                    id: "pending-main-2",
                                    tabs: [{
                                        "name": "<span style='color: #1E9FFF'>政务信息通报</span>",
                                        checked: true,
                                        contentType: "cmp",
                                        content: list5
                                    }, {
                                        "name": "<span style='color: #1E9FFF'>信息专报</span>",
                                        checked: false,
                                        contentType: "cmp",
                                        content: list6
                                    }, {
                                        "name": "<span style='color: #1E9FFF'>工作简报</span>",
                                        checked: false,
                                        contentType: "cmp",
                                        content: list7
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

                            },
                            children: [{
                                cmp: "list",
                                name: "党建",
                                max: 5,
                                data_url: URL_REPO.dangjiangongzuo,
                                data_prop: [{
                                    "name": "frName",
                                    render: function (name, data) {
                                        console.log(name);
                                        return data;
                                    },
                                    size: 10
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


            }
        }]
    }, {
        cols: [{
            size: 6,
            id: "pending3",
            type: "sTab",
            name: "常用模版",
            children: [{

                cmp: "list",
                name: "常用模板",
                max: 5,
                data_url: URL_REPO.changyongmoban,
                data_prop: [{
                    "name": "subject",
                    render: function (name, data) {
                        return data;
                    }

                }]
            }]

        }, {
            size: 6,
            id: "pending2",
            name: "日程安排",
            type: "sTab",
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
                    }]
                });
                var list5 = List.create({
                    data_url: URL_REPO.zwxxtb,
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
                var list6 = List.create({
                    data_url: URL_REPO.zwxxtb,
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
                var list7 = List.create({
                    data_url: URL_REPO.zwxxtb,
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
                var mt2 = mTab.create({
                    id: "pending-main-2",
                    tabs: [{
                        "name": "<span style='color: #1E9FFF'>政务信息通报</span>",
                        checked: true,
                        contentType: "cmp",
                        content: list5
                    }, {
                        "name": "<span style='color: #1E9FFF'>信息专报</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list6
                    }, {
                        "name": "<span style='color: #1E9FFF'>工作简报</span>",
                        checked: false,
                        contentType: "cmp",
                        content: list7
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

            },
            children: [{
                cmp: "list",
                name: "党建",
                max: 5,
                data_url: URL_REPO.dangjiangongzuo,
                data_prop: [{
                    "name": "frName",
                    render: function (name, data) {
                        console.log(name);
                        return data;
                    },
                    size: 10
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