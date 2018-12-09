;var URL_BASE = "http://192.168.1.98:612";
var URL_REPO = {
    "danweixinwen": URL_BASE + "/seeyon/menhu.do?method=getNewsList&typeId=1&offset=0&limit=7",
    "tupianxinwen": URL_BASE + "/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=7",

    "edoc_pending": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&offset=2&limit=8",
    "tongzhigonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&offset=0&limit=7",
    "zhongxincaidan": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-8736948720711547028&offset=0&limit=7",
    "liangxueyizuo": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8188009082124256867&offset=0&limit=7",
    "shijiuda": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7136252316133508367&offset=0&limit=7",
    "yianweijian": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2104797802172793544&offset=0&limit=7",
    "dangjiangongzuo": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=575989468633646689&offset=0&limit=7",
    "guizhangzhidu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=7",
    "guangrongbang": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=820644300868634954&offset=0&limit=7",
    "zhengwuxinxitongbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=7",
    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=7",
    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=7",
    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=7",
    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=7",
    "guizhangzhidu2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=7",
    "zhixinggongshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8922663637462369764&offset=0&limit=7",
    "guojidongtai": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=6475027635041617679&offset=0&limit=7",
    "xinxijianbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4550956951978068889&offset=0&limit=7",
    "sanchansanshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7462332795861419459&offset=0&limit=7",
    "shibada": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=5469896967953073526&offset=0&limit=7",
    "zuoriyaoqing": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-2220615473202182672&offset=0&limit=7",//昨日要请
    "wodemoban1": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=8&offset=0&limit=7",//登陆才有
    "wodemoban2": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=8&offset=5&limit=7",
    "sanhuiyike": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8503501149007790685&offset=0&limit=7",
    "gongzuodongtai": "",//工作动态
    "xinxizhuanbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4787332904735427042&offset=0&limit=7",//信息专报
    "xiazaizhuanqu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2296413374197223074&offset=0&limit=7",//下载专区
    "bangonghui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=3297213230734002184&offset=0&limit=7",
    "lingdaobanzihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-7007958826195137660&offset=0&limit=7",
    "zhurenzhutihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-3156250650104348435&offset=0&limit=7",
    "dangweihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-6730682058817912143&offset=0&limit=7",
    "zhongxinzuxuexi": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=4327169891904341638&offset=0&limit=7",
    "genzongduban": URL_BASE + "/seeyon/menhu.do?method=getSuperviseList&offset=0&limit=7",//没测试
    "yiban": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=7&offset=0&limit=7",//没测试
    "yifa": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=2&offset=0&limit=7",//没测试
    "daibangongzuo": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=3&offset=0&limit=7",
    "chaoqi": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=4&offset=0&limit=7",//typeid不对
    "wodeshoucang": URL_BASE + "/seeyon/menhu.do?method=getFavorCollection&offset=0&limit=7",//typeid不对
    "gongzuodongtai": URL_BASE + "/seeyon/menhu.do?method=getNewsByAccountAndDepartment&orgCountStr=3&deptCountStr=3"
};
(function () {

    lx.use(["jquery", "carousel", "element", "row", "col", "sTab", "mTab", "list", "lunbo", "mixed", "datepicker"], function () {
        var default_height = "height:300px"
        var default_height_value = "300px";
        var default_height_col = "height:300px";
        var Row = lx.row;
        var MTab = lx.mTab;
        var Tab = lx["sTab"];
        var Col = lx.col;
        var List = lx.list;
        var Lunbo = lx.lunbo;
        var Mixed = lx.mixed;
        var $ = lx.jquery;
        var DatePicker = lx.datepicker;
        //行
        var row1 = Row.create({
            parent_id: "root_body",
            "id": "row1119"
        });
        var row2 = Row.create({
            parent_id: "root_body",
            "id": "row1129",
            style:"margin-top:14px"
        });
        var row3 = Row.create({
            parent_id: "root_body",
            "id": "row1139",
            style:"margin-top:14px;height:200px"
        });
        var row4 = Row.create({
            parent_id: "root_body",
            "id": "row1149",
            style:"margin-top:14px;height:300px"
        });
        var row5 = Row.create({
            parent_id: "root_body",
            "id": "row1159",
            style:"margin-top:14px"
        });
        var row6 = Row.create({
            parent_id: "root_body",
            "id": "row1169",
            style:"margin-top:14px"
        });
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1179",
            style:"margin-top:14px"
        });
        //列
        var col1 = Col.create({
            size: 4,
            style: default_height_col
        });

        var col2 = Col.create({
            size: 4,
            style: default_height_col,
            id: "col2"
        });
        var col3 = Col.create({
            size: 4,
            style: default_height_col
        });
        row1.append(col1);
        row1.append(col2);
        row1.append(col3);
        var col4 = Col.create({
            size: 4,
            style: default_height_col
        });
        var col5 = Col.create({
            size: 8,
            style: default_height_col
        });
        row2.append(col4);
        row2.append(col5);
        var col6 = Col.create({
            size: 4,
            style: "height:200px"
        });
        var col7 = Col.create({
            size: 8,
            style: "height:200px"
        });
        row3.append(col6);
        row3.append(col7);
        var col8 = Col.create({
            size: 4,
            style: default_height_col
        });
        var col9 = Col.create({
            size: 2,
            style: default_height_col
        });
        var col10 = Col.create({
            size: 6,
            style: default_height_col
        });
        row4.append(col8);
        row4.append(col9);
        row4.append(col10);
        var col11 = Col.create({
            size: 6,
            style: default_height_col
        });
        var col12 = Col.create({
            size: 6,
            style: default_height_col
        });
        row5.append(col11);
        row5.append(col12);
        var col13 = Col.create({
            size: 4,
            style: default_height_col
        });
        var col14 = Col.create({
            size: 8,
            style: default_height_col
        });
        row6.append(col13);
        row6.append(col14);
        var col15 = Col.create({
            size: 12,
            style: default_height_col
        });
        row7.append(col15);
        var list1 = List.create({
            name: "通知公告",
            max: 5,
            data_url: URL_REPO.tongzhigonggao,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "updateDate",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]

        });
        var sTab1 = Tab.create({
            "title": "<span class='lx-tab-head'>通知公告</span>",
            style: default_height,
            content: list1,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        //  sTab1.append(list1);

        var lunbo2 = Lunbo.create({
            id: "lunbo2",
            change: function (res) {
                //console("changed");
            },
            size: 4,
            interval: 3000,
            width: col2.root.width() + "px",
            height:default_height_value,
            data_url: URL_REPO.tupianxinwen,
            data_prop: {
                "name": "title",
                "img": "imgUrl"
            }
        });
        var list31 = List.create({
            data_url: URL_REPO.zuoriyaoqing,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "createDate",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            },]
        });
        var list32 = List.create({
            data_url: URL_REPO.gongzuodongtai,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "updateDate",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var mTab3 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>昨日要情</span>",
                checked: true,
                contentType: "cmp",
                content: list31
            }, {
                name: "<span class='lx-tab-multi-head'>工作动态</span>",
                checked: false,
                contentType: "cmp",
                content: list32
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        col1.append(sTab1);
        col2.append(lunbo2);
        col3.append(mTab3);
        var list4 = List.create({
            data_url: URL_REPO.genzongduban,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 10
            }, {
                "name": "awake_date",
                render: function (name, data) {
                    return data.substring(5, 10);
                },
                size: 2
            }
            ]
        });
        var sTab4 = Tab.create({
            title: "<span class='lx-tab-head'>跟踪督办</span>",
            style: default_height,
            contentType: "cmp",
            content: list4,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            }
        });
        var list51 = List.create({
            data_url: URL_REPO.daibangongzuo,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 10
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
        var list52 = List.create({
            data_url: URL_REPO.yifa,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 10
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
        var list53 = List.create({
            data_url: URL_REPO.yiban,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 10
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
        var list54 = List.create({
            data_url: URL_REPO.chaoqi,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 10
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
        var mixRoot51 = Mixed.create({
            id: "mixed1",
            mode: "col",
            size: 12
        });
        var btn_htmls = ['<button style="background-color:#8693f3;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">6<span style="margin: 0 30px 0 30px">|</span>公文审批</button>'];
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#ff916e;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">3<span style="margin: 0 30px 0 30px">|</span>协同办理</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#5484ff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">2<span style="margin: 0 30px 0 30px">|</span>任务执行</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#3cbaff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">1<span style="margin: 0 30px 0 30px">|</span>会议日程</button>');


        var mix511 = Mixed.create({
            id: "mixed2",
            mode: "col",
            size: 4,
            cmps: [{
                contentType: "html",
                content: btn_htmls.join(""),
                style: "height:240px",
                size: 4
            }]
        });
        var mix512 = Mixed.create({
            id: "mixed3",
            mode: "col",
            size: 8
        });
        mix512.append(list51);
        //mix512.append();
        mixRoot51.append(mix511);
        mixRoot51.append(mix512);

        mix512.append(list51);
        //mix512.append();
        mixRoot51.append(mix511);
        mixRoot51.append(mix512);
        var mTab5 = MTab.create({
            id: "pending-main-mTab5",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>待办[5]</span>",
                checked: true,
                contentType: "cmp",
                content: mixRoot51
            }, {
                name: "<span class='lx-tab-multi-head'>已发[12]</span>",
                checked: false,
                contentType: "cmp",
                content: list52
            }, {
                name: "<span class='lx-tab-multi-head'>已办[12]</span>",
                checked: false,
                contentType: "cmp",
                content: list53
            }, {
                name: "<span class='lx-tab-multi-head'>超期[1]</span>",
                checked: false,
                contentType: "cmp",
                content: list54
            }],
            on_tab:function(item){
                console.log(item);
            },
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        col4.append(sTab4);
        col5.append(mTab5);

        var list61 = List.create({
            data_url: URL_REPO.wodemoban1,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                },
                size: 12
            }]
        });
        // var list62 = List.create({
        //     data_url: URL_REPO.wodemoban2,
        //     data_prop: [{
        //         "name": "subject",
        //         render: function (name, data) {
        //             return data;
        //         },
        //         size: 12
        //     }]
        // });
        // var mix61 = Mixed.create({
        //     id: "mixed2",
        //     mode: "col",
        //     size: 6
        // });
        // var mix62 = Mixed.create({
        //     id: "mixed3",
        //     mode: "col",
        //     size: 6
        // });
        // var mixRoot6 = Mixed.create({
        //     id: "mixed1",
        //     mode: "col",
        //     size: 12
        // });
        // mix61.append(list61);
        // mix62.append(list62);
        // mixRoot6.append(mix61);
        // mixRoot6.append(mix62);
        var sTab6 = Tab.create({
            "title": "<span class='lx-tab-head'>我的模板</span>",
            "style": "height:200px",
            contentType: "cmp",
            content: list61,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            }
        });
        var list7 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var sTab7 = Tab.create({
            "title": "<span class='lx-tab-head lx-tab-color1'>快捷通道</span>",
            "style": "height:200px",
            contentType: "cmp",
            content: list7
        });
        ;
        col6.append(sTab6);
        col7.append(sTab7);

        var list81 = List.create({
            name: "行前公示",
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
        });
        var list82 = List.create({
            name: "执行公示",
            data_url: URL_REPO.zhixinggongshi,
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
        });
        var list83 = List.create({
            name: "国际动态",
            data_url: URL_REPO.guojidongtai,
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
        });
        var mTab8 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>行前公示</span>",
                checked: true,
                contentType: "cmp",
                content: list81
            }, {
                name: "<span class='lx-tab-multi-head'>执行公示</span>",
                checked: false,
                contentType: "cmp",
                content: list82
            }, {
                name: "<span class='lx-tab-multi-head'>国际动态</span>",
                checked: false,
                contentType: "cmp",
                content: list83
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        var list9 = List.create({
            data_url: URL_REPO.wodeshoucang,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                }
            }]

        });
        var list10 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var sTab9 = Tab.create({
            "title": "<span class='lx-tab-head lx-tab-color2'>我的收藏</span>",
            "style": default_height,
            contentType: "cmp",
            content: list9,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            }
        });
        // var mixedRoot10 = Mixed.create({
        //     id: "dp_micker",
        //     mode: "col",
        //     size: 12
        // });
        // var mixedLeft = Mixed.create({
        //     id: "dp_micker_left",
        //     mode: "col",
        //     size: 12
        // });
        // var mixedRight = Mixed.create({
        //     id: "dp_micker_right",
        //     mode: "col",
        //     size: 12
        // });
        // mixedRoot10.addCmp({
        //     contentType: "cmp",
        //     content: mixedLeft,
        //     size: 6
        // });
        // mixedRoot10.addCmp({
        //     contentType: "cmp",
        //     content: mixedRight,
        //     size: 6
        // });
        // mixedRight.addCmp({
        //     content: $("#leader_calendar"),
        //     size: 12
        // })
        // DatePicker.create({
        //     height: "200px",
        //     "id": "picker",
        //     "className": "",
        //     parent: mixedLeft
        // });
        var sTab10 = Tab.create({
            "title": "<span class='lx-tab-head lx-tab-color3'>日程管理</span>",
            "style": default_height,
            contentType: "cmp",
            // content: mixedRoot10,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        ;
        col8.append(mTab8);
        col9.append(sTab9);
        col10.append(sTab10);
        var list111 = List.create({
            name: "办公会",
            data_url: URL_REPO.bangonghui,
            data_prop: [{
                "name": "field0002",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0004",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0005",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0003",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]

        });
        var list112 = List.create({
            name: "中心组学习",
            data_url: URL_REPO.zhongxinzuxuexi,
            data_prop: [{
                "name": "field0002",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0004",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0005",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0003",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var list113 = List.create({
            name: "领导班子会",
            data_url: URL_REPO.lingdaobanzihui,
            data_prop: [{
                "name": "field0002",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0004",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0005",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0003",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]

        });
        var list114 = List.create({
            name: "主任主题会",
            data_url: URL_REPO.zhurenzhutihui,
            data_prop: [{
                "name": "field0002",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0004",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0005",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0003",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var list115 = List.create({
            name: "党委会",
            data_url: URL_REPO.dangweihui,
            data_prop: [{
                "name": "field0002",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0004",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0005",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }, {
                "name": "field0003",
                size: 3,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });

        var mTab11 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>办公会</span>",
                checked: true,
                contentType: "cmp",
                content: list111
            }, {
                name: "<span class='lx-tab-multi-head'>中心组学习</span>",
                checked: false,
                contentType: "cmp",
                content: list112
            }, {
                name: "<span class='lx-tab-multi-head'>领导班子会</span>",
                checked: false,
                contentType: "cmp",
                content: list113
            }, {
                name: "<span class='lx-tab-multi-head'>主任主题会</span>",
                checked: false,
                contentType: "cmp",
                content: list114
            }, {
                name: "<span class='lx-tab-multi-head'>党委会</span>",
                checked: false,
                contentType: "cmp",
                content: list115
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        var list121 = List.create({
            data_url: URL_REPO.xinxizhuanbao,
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

        });
        var list122 = List.create({
            data_url: URL_REPO.xinxijianbao,
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
        });
        var list123 = List.create({
            name: "政务信息通报",
            data_url: URL_REPO.zhengwuxinxitongbao,
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
        });
        var mTab12 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>信息专报</span>",
                checked: true,
                contentType: "cmp",
                content: list121
            }, {
                name: "<span class='lx-tab-multi-head'>信息简报</span>",
                checked: false,
                contentType: "cmp",
                content: list122
            }, {
                name: "<span class='lx-tab-multi-head'>政务信息通报</span>",
                checked: false,
                contentType: "cmp",
                content: list123
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        col11.append(mTab11);
        col12.append(mTab12);
        var list131 = List.create({
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
        });
        var list132 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var list133 = List.create({
            data_url: URL_REPO.zhongxincaidan,
            data_prop: [{
                "name": "title",

                render: function (name, data) {
                    return data;
                },
                size: 8
            }, {
                "name": "updateDate",
                size: 4
            }]
        });
        var mTab13 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>光荣特区</span>",
                checked: true,
                contentType: "cmp",
                content: list131
            }, {
                name: "<span class='lx-tab-multi-head'>下载专区</span>",
                checked: false,
                contentType: "cmp",
                content: list132
            }, {
                name: "<span class='lx-tab-multi-head'>每周餐单</span>",
                checked: false,
                contentType: "cmp",
                content: list133
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        var list141 = List.create({
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
        var list142 = List.create({
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
        var list143 = List.create({
            data_url: URL_REPO.sanchansanshi,
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
        var list144 = List.create({
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
        var list145 = List.create({
            data_url: URL_REPO.shibada,
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
        var list146 = List.create({
            data_url: URL_REPO.sanhuiyike,
            data_prop: [{
                "name": "frName",
                render: function (name, data) {
                    return data;
                },
                size: 9
            }, {
                "name": "createTime",
                render: function (name, data) {
                    return data.substring(5, 10);
                },
                size: 3
            }]
        });
        var mTab14 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>以案为鉴</span>",
                checked: true,
                contentType: "cmp",
                content: list141
            }, {
                name: "<div class='lx-tab-multi-head'>十九大</div>",
                checked: false,
                contentType: "cmp",
                content: list142
            }, {
                name: "<span class='lx-tab-multi-head'>三严三实</span>",
                checked: false,
                contentType: "cmp",
                content: list143
            }, {
                name: "<span class='lx-tab-multi-head'>两学一做</span>",
                checked: false,
                contentType: "cmp",
                content: list144
            }, {
                name: "<span class='lx-tab-multi-head'>十八大</span>",
                checked: false,
                contentType: "cmp",
                content: list145
            }, {
                name: "<span class='lx-tab-multi-head'>三会一课</span>",
                checked: false,
                contentType: "cmp",
                content: list146
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        col13.append(mTab13);
        col14.append(mTab14);
        var list151 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var list152 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var list153 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var list154 = List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render: "",
                size: 8
            }]
        });
        var mTab15 = MTab.create({
            id: "pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>重点工作</span>",
                checked: true,
                contentType: "cmp",
                content: list151
            }, {
                name: "<span class='lx-tab-multi-head'>党建工作</span>",
                checked: false,
                contentType: "cmp",
                content: list152
            }, {
                name: "<span class='lx-tab-multi-head'>外事计划</span>",
                checked: false,
                contentType: "cmp",
                content: list153
            }, {
                name: "<span class='lx-tab-multi-head'>会议计划</span>",
                checked: false,
                contentType: "cmp",
                content: list154
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                }
            }
        });
        col15.append(mTab15);
    });
}(window));