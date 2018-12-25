;var URL_BASE = "http://10.100.249.84:612";

var URL_REPO = {
    //第一行-要情、公告、工作动态
    "tupianxinwen": URL_BASE + "/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=7",
    "tongzhigonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&offset=0&limit=7",
    "zuoriyaoqing": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-2220615473202182672&offset=0&limit=7",//昨日要请
    "gongzuodongtai": URL_BASE + "/seeyon/menhu.do?method=getNewsByAccountAndDepartment&orgCountStr=3&deptCountStr=4",
    //以案为鉴
    "liangxueyizuo1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1268478479319909049&offset=0&limit=6",
    "liangxueyizuo2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8188009082124256867&offset=0&limit=6",
    "shijiuda1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8090639548974844938&offset=0&limit=6",
    "shijiuda2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7136252316133508367&offset=0&limit=6",
    "sanyansanshi1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1385529657363679024&offset=0&limit=6",
    "sanyansanshi2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7462332795861419459&offset=0&limit=6",
    "yianweijian2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2104797802172793544&offset=0&limit=6",
    "yianweijian1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4815176891167032382&offset=0&limit=6",
    "shibada1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4252252302003883022&offset=0&limit=6",
    "shibada2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=5469896967953073526&offset=0&limit=6",
    "sanhuiyike2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8503501149007790685&offset=0&limit=6",
    "sanhuiyike1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8339111925347929889&offset=0&limit=6",
    //行前、执行、国际
    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=8",
    "zhixinggongshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8922663637462369764&offset=0&limit=8",
    "guojidongtai": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=6475027635041617679&offset=0&limit=8",
    //信息报
    "xinxizhuanbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4787332904735427042&offset=0&limit=7",//信息专报
    "zhengwuxinxitongbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=7",
    "xinxijianbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4550956951978068889&offset=0&limit=7",
    //收藏、模板、跟踪
    "wodeshoucang": URL_BASE + "/seeyon/menhu.do?method=getFavorCollection&offset=0&limit=7",
    "genzongduban": URL_BASE + "/seeyon/menhu.do?method=getSuperviseList&offset=0&limit=7",
    "wodemoban1": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&offset=0&limit=3",//登陆才有
    "wodemoban2": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&offset=4&limit=6",
    //办公室和领导班子
    "bangonghui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=3297213230734002184&offset=0&limit=7",
    "lingdaobanzihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-7007958826195137660&offset=0&limit=7",
    "zhurenzhutihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-3156250650104348435&offset=0&limit=7",
    "dangweihui": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-6730682058817912143&offset=0&limit=7",
    "zhongxinzuxuexi": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=4327169891904341638&offset=0&limit=7",
    //待办
    "yiban": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=4&offset=0&limit=6&$count=true",
    "yifa": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=2&offset=0&limit=6&$count=true",
    "daibangongzuo": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=3&offset=0&limit=6&$count=true",
    "chaoqi": URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId=3&subState=12&offset=0&limit=6&$count=true",
    //光荣、下载、菜单
    "meizhoucaidan": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-8736948720711547028&offset=0&limit=7",
    "xiazaizhuanqu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2296413374197223074&offset=0&limit=7",
    "guangrongbang": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=820644300868634954&offset=0&limit=7",
    //没用
    "guizhangzhidu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=7",
    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=7",
    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=7",
    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=7",

    "my_cal": URL_BASE + "/seeyon/datakit/get.do?method=getMyCalendar&day=",
    "s_leader_cal": URL_BASE + "/seeyon/datakit/get.do?method=getDepartmentLeaderCalendar&day=",
    "m_leader_cal": URL_BASE + "/seeyon/datakit/get.do?method=getAccountLeaderCalendar&day="


};
(function () {

    lx.use(["jquery", "carousel", "element", "row", "col", "sTab", "mTab", "list", "lunbo", "mixed", "datepicker", "laydate"], function () {
        var default_height = "height:300px"
        var default_height_value = "300px";
        var default_height_col = "height:300px";
        var laydate = lx.laydate;
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
            style: "margin-top:14px"
        });
        var row3 = Row.create({
            parent_id: "root_body",
            "id": "row1139",
            style: "margin-top:14px;height:150px"
        });
        var row4 = Row.create({
            parent_id: "root_body",
            "id": "row1149",
            style: "margin-top:14px;height:300px"
        });
        var row5 = Row.create({
            parent_id: "root_body",
            "id": "row1159",
            style: "margin-top:14px"
        });
        var row6 = Row.create({
            parent_id: "root_body",
            "id": "row1169",
            style: "margin-top:14px"
        });
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1179",
            style: "margin-top:14px"
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
            style: "height:150px"
        });
        var col7 = Col.create({
            size: 8,
            style: "height:150px"
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
            style: "height:350px"
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
        function showFont(app,data) {

            if (app) {
                var temp = "";
                if (app == "1") {
                    temp = "协同";
                } else if (app == "6") {
                    temp = "会议";
                } else if (app == "4") {
                    temp = "公文";
                } else if (app == "21") {
                    temp = "签报";
                }else if (app == "2") {
                    temp = "表单";
                }else if (app == "7") {
                    temp = "公告";
                }else if (app == "8") {
                    temp = "新闻";
                }else {
                    temp = "其他";
                }
                return "<span class='lx-type-zq'>["+temp+"]&nbsp&nbsp&nbsp</span><span >" + data + "</span>";
            }else{
                return data;
            }
        }
        function showIcon(readFlag,data,type) {
            var temp = ""
            if (readFlag) {
                temp = "lx_icon16_messa";
            } else {
                temp = "lx_icon16_message";
            }
            if (type) {
                var temp2 = "";
                if (type == "Pdf") {
                    temp2 = "lx_icon16_pdf";
                } else if (type == "OfficeWord") {
                    temp2 = "lx_icon16_word";
                } else if (type == "20") {
                    temp2 = "lx_icon16_form_temp";
                } else {
                    temp2 = "";
                }
                return "<span class='" + temp + " lx-icon-margin-zq'></span><span>" + data + "</span><span class='" + temp2 + "'></span>";
            }else{
                return "<span class='" + temp + " lx-icon-margin-zq'></span><span>" + data + "</span>";
            }
        }

        var list1 = List.create({
            name: "通知公告",
            link_prop: "link",
            data_url: URL_REPO.tongzhigonggao,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data,item.body_type);
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
                    window.open('/seeyon/bulData.do?method=bulIndex&typeId=7305481828924604761&spaceType=&spaceId=');
                    e.stopPropagation();
                    e.preventDefault();
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                    e.stopPropagation();
                    e.preventDefault();
                    window.open('/seeyon/bulData.do?method=bulEdit&spaceType=2&bulTypeId=7305481828924604761&spaceId=670869647114347&bulId=&openFlag=true');
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
            height: default_height_value,
            data_url: URL_REPO.tupianxinwen,
            data_prop: {
                "name": "title",
                "img": "imgUrl"
            }
        });
        var list31 = List.create({
            link_prop: "link",
            data_url: URL_REPO.zuoriyaoqing,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data,item.body_type);
                }
            }, {
                "name": "createDate",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });

        function isNumber(str) {
            var re = /^([0-9]+)([.]?)([0-9]*)$/;
            return re.test(str);
        }

        var list32 = List.create({
            data_url: URL_REPO.gongzuodongtai,
            link_prop:"link",
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data,item.body_type);
                }
            }, {
                "name": "updateDate",
                size: 2,
                render: function (name, data, item) {
                    //console.log(item);
                    if (isNumber(data)) {
                        var dt = new Date();
                        dt.setTime(data);
                        return dt.format().substring(5, 10);
                    } else {
                        return data.substring(5, 10);
                    }

                }
            }]
        });
        var mTab3 = MTab.create({
            id: "pending-main-1",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span id='zryq_head' class='lx-tab-multi-head'>昨日要情</span>",
                checked: true,
                contentType: "cmp",
                content: list31
            }, {
                name: "<span id='gzdt_head' class='lx-tab-multi-head'>工作动态</span>",
                checked: false,
                contentType: "cmp",
                content: list32
            }],
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                    if($("#zryq_head").hasClass("layui-this")||$("#zryq_head").parent().hasClass("layui-this")){
                        window.open("/seeyon/bulData.do?method=bulIndex&typeId=-2220615473202182672&spaceType=&spaceId=");
                    }else{
                        window.open("/seeyon/newsData.do?method=newsIndex&_resourceCode=F05_newsIndexAccount");
                    }
                    e.stopPropagation();
                    e.preventDefault();

                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                    if($("#zryq_head").hasClass("layui-this")||$("#zryq_head").parent().hasClass("layui-this")){
                        // alert("zryq");
                        window.open("/seeyon/bulData.do?method=bulEdit&spaceType=2&bulTypeId=-2220615473202182672&spaceId=670869647114347&bulId=&openFlag=true");
                    }else{
                        // alert("gzdt");
                        window.open("/seeyon/newsData.do?method=newsEdit&newsType=&newsTypeId=&newsId=&spaceType=&spaceId=&openFlag=true");
                    }
                    e.stopPropagation();
                    e.preventDefault();
                }
            }
        });
        col1.append(sTab1);
        col2.append(lunbo2);
        col3.append(mTab3);
        var list4 = List.create({
            data_url: URL_REPO.genzongduban,
            link_prop:"link",
            data_prop: [{
                "name": "subject",
                render: function (name, data, item) {

                    return showIcon(item.readFlag,data,item.body_type);
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
                    window.open("/seeyon/main.do?method=main&openType=menhu&type=xietongduban");
                    e.stopPropagation();
                    e.preventDefault();
                }
            }
        });

        var list51 = List.create({
            id: "daiban",
            link_prop: "link",
            data_url: URL_REPO.daibangongzuo,
            data_prop: [{
                "name": "subject",
                render: function (name, data,item,count) {
                    if(count!=undefined){
                        $("#pending_list_head").html("待办["+count+"]");
                    }

                    return showFont(item.app,data);

                },
                size: 8
            } ,{
                "name": "senderName",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "receiveFormatDate",
                size: 1,
                render: function (name, data) {
                    if (!data) {
                        return "11-20";
                    }
                    return data.substring(5, 10);
                }
            }]
        });
        var list52 = List.create({
            id: "yifa",
            link_prop: "link",
            data_url: URL_REPO.yifa,
            data_prop: [{
                "name": "subject",
                render: function (name, data,item,count) {
                    if(count!=undefined){
                        $("#sent_list_head").html("已发["+count+"]");
                    }

                    return showFont(item.app,data);
                },
                size: 8
            } ,{
                "name": "senderName",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "receiveFormatDate",
                size: 1,
                render: function (name, data) {
                    if (!data) {
                        return "11-20";
                    }
                    return data.substring(5, 10);
                }
            }]

        });
        var list53 = List.create({
            id: "yiban",
            link_prop: "link",
            data_url: URL_REPO.yiban,
            data_prop: [{
                "name": "subject",
                render: function (name, data,item,count) {
                    if(count!=undefined){
                        $("#done_list_head").html("已办["+count+"]");
                    }

                    return showFont(item.app,data);
                },
                size: 8
            } ,{
                "name": "senderName",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "receiveFormatDate",
                size: 1,
                render: function (name, data) {
                    if (!data) {
                        return "11-20";
                    }
                    return data.substring(5, 10);
                }
            }]
        });
        var list54 = List.create({
            id: "chaoqi",
            link_prop: "link",
            data_url: URL_REPO.chaoqi,
            data_prop: [{
                "name": "subject",
                render: function (name, data,item,count) {
                    if(count!=undefined){
                        $("#overdate_list_head").html("超期["+count+"]");
                    }

                    return showFont(item.app,data);
                },
                size: 8
            } ,{
                "name": "senderName",
                size: 3,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "receiveFormatDate",
                size: 1,
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

        var btn_htmls = ['<button  class="layui-btn layui-btn-lg layui-btn-primary lx-btn-zq" id="gongwen_button"><span id="gongwen_count" class="lx-btn-span">0</span><span style="margin: 0 30px 0 30px;line-height:44px">|</span>公文审批</button>'];
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button  class="layui-btn layui-btn-lg layui-btn-primary lx-btn-zq" id="xietong_button"><span id="xietong_count" class="lx-btn-span">0</span><span style="margin: 0 30px 0 30px">|</span>协同办理</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button  class="layui-btn layui-btn-lg layui-btn-primary lx-btn-zq" id="renwu_button"><span id="renwu_count" class="lx-btn-span" >0</span><span style="margin: 0 30px 0 30px">|</span>任务执行</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button  class="layui-btn layui-btn-lg layui-btn-primary lx-btn-zq" id="huiyi_button"><span id="huiyi_count" class="lx-btn-span">0</span><span style="margin: 0 30px 0 30px">|</span>会议日程</button>');
        //    function myButton(id){
        //         var x=document.getElementById(id);
        //          x.style.color="blue";
        //    };


        var mix511 = Mixed.create({
            id: "mixed2",
            mode: "col",

            size: 4,
            cmps: [{
                contentType: "html",
                content: btn_htmls.join(""),
                style: "height:240px;margin-left:15px;margin-top:13px",
                size: 4
            }]
        });
        var mix512 = Mixed.create({
            id: "mixed3",
            mode: "col",
            root_style:"padding-top:15px",
            size: 8
        });
        mix512.append(list51);
        //mix512.append();
        mixRoot51.append(mix511);
        mixRoot51.append(mix512);


        //mix512.append();

        var mTab5 = MTab.create({
            id: "pending-main-mTab5",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head' id='pending_list_head'>待办</span>",
                checked: true,
                contentType: "cmp",
                id: "pending-li-1",
                content: mixRoot51
            }, {

                name: "<span   class='lx-tab-multi-head' id='sent_list_head'>已发</span>",
                checked: false,
                contentType: "cmp",
                id: "pending-li-2",

            }, {
                name: "<span class='lx-tab-multi-head' id='done_list_head'>已办</span>",
                checked: false,
                contentType: "cmp",
                id: "pending-li-3",

            }, {
                name: "<span class='lx-tab-multi-head' id='overdate_list_head'>超期</span>",
                checked: false,
                contentType: "cmp",
                id: "pending-li-4",

            }],
            on_tab: function (item) {
                var curTab = $("#pending-main-mTab5").find(".layui-tab-item.layui-show");
                curTab.append(mixRoot51.root);
                var curId = $(item).attr("lay-id");
                list51.root.hide();
                list52.root.hide();
                list53.root.hide();
                list54.root.hide();
                if (curId == "pending-li-1") {
                    mix512.root.append(list51.root);
                    list51.root.show();
                }
                if (curId == "pending-li-2") {
                    mix512.root.append(list52.root);
                    list52.root.show();
                }
                if (curId == "pending-li-3") {
                    mix512.root.append(list53.root);
                    list53.root.show();
                }
                if (curId == "pending-li-4") {
                    mix512.root.append(list54.root);
                    list54.root.show();
                }

            },
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                    e.preventDefault();
                    e.stopPropagation();
                    window.open("/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl");
                }
            },
            new_btn: {
                class_name: "lx-tab-new-btn",
                html: "<span class='lx-new-btn'>+</span>",
                click: function (e) {
                    //alert("click2");
                    window.open("/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl");
                    e.preventDefault();
                    e.stopPropagation();
                }
            }
        });
        col4.append(sTab4);
        col5.append(mTab5);

        var list61 = List.create({
            data_url: URL_REPO.wodemoban1,
            data_prop: [{
                "name": "subject",
                render: function (name, data, item) {

                    if (item.bodyType == "20") {
                        return "<span class='lx_icon16_form_temp'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--政务信息审批单
                    } else if (item.bodyType == "41") {
                        return "<span  class='lx_icon16_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--工作简报/信息专报审批单
                    } else if (item.bodyType == "10") {
                        return "<span  class='lx_icon16_red_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--阅稿纸
                    } else if (item.bodyType == "45") {
                        return "<span class='lx_icon16_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--传真收文稿纸
                    } else {
                        return "<span  class='lx_icon16_message lx-icon-margin-zq'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                    }
                },
                size: 12
            }]
        });
        var list62 = List.create({
            data_url: URL_REPO.wodemoban2,
            max: 3,
            data_prop: [{
                "name": "subject",
                render: function (name, data, item) {
                    if (item.bodyType == "20") {
                        return "<span class='lx_icon16_form_temp'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--政务信息审批单
                    } else if (item.bodyType == "41") {
                        return "<span  class='lx_icon16_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--工作简报/信息专报审批单
                    } else if (item.bodyType == "10") {
                        return "<span  class='lx_icon16_red_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--阅稿纸
                    } else if (item.bodyType == "45") {
                        return "<span class='lx_icon16_text_type_template'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                        //审批单--传真收文稿纸
                    } else {
                        return "<span  class='lx_icon16_message lx-icon-margin-zq'></span><span onclick='window.open(\"/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + item.id + "\")'>" + data + "</span>";
                    }
                },
                size: 12
            }]
        });
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
        var tpl_one = $("#tpl_one");
        tpl_one.append(list61.root);
        var tpl_two = $("#tpl_two");
        tpl_two.append(list62.root);
        var tpl_all = $("#tpl_all");
        var sTab6 = Tab.create({
            "title": "<span class='lx-tab-head'>我的模板</span>",
            "style": "height:150px",
            contentType: "jq",
            content: tpl_all,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                    window.open("/seeyon/main.do?method=main&openType=menhu&type=wodemoban");
                    e.stopPropagation();
                    e.preventDefault();
                }
            }
        });

        var sTab7 = Tab.create({
            "title": "<span class='lx-tab-head lx-tab-color1'>快捷通道</span>",
            "style": "height:150px;overflow-y:auto",
            contentType: "jq",
            content: $("#quick_enter_btns")
        });
        ;
        col6.append(sTab6);
        col7.append(sTab7);

        var list81 = List.create({
            name: "行前公示",
            link_prop: "link",
            data_url: URL_REPO.xqgs,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
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
            link_prop: "link",
            data_url: URL_REPO.zhixinggongshi,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
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
            link_prop: "link",
            data_url: URL_REPO.guojidongtai,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
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
            root_style: "height:340px",
            root_class: "layui-tab layui-tab-brief",
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
                    window.open("");
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
            link_prop: "link",
            size: 12,
            data_prop: [{
                "name": "frName",
                size: 12,
                render: function (name, data, item) {
                    console.log(item);

                    if (item.pDF) {
                        return "<span class='lx_icon16_pdf lx-icon-margin-zq'></span><span>" + data + "</span>";
                    } else if (item.isFolder) {
                        return "<span class='lx_icon16_dir lx-icon-margin-zq'></span><span>" + data + "</span>";
                    } else if (item.new) {
                        return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>" + data + "</span>";
                    } else if (item.uploadOfficeOrWps) {
                        return "<span class='lx_icon16_word lx-icon-margin-zq'></span><span>" + data + "</span>";
                    } else {
                        return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>" + data + "</span>";
                    }
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
            "style": "height:340px",
            contentType: "cmp",
            content: list9,

            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {
                    //alert("click");
                    window.open('/seeyon/main.do?method=main&openType=menhu&type=wodeshoucang');
                }
            }
        });

        var sTab10 = Tab.create({
            "title": "<span class='lx-tab-head lx-tab-color3'>日程管理</span>",
            "style": "height:340px",
            contentType: "jq",
            content: $("#calendar_container"),
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
                    //http://10.100.249.84:612/seeyon/collaboration/collaboration.do?method=newColl&templateId=-5615324791397988201&from=templateNewColl
                    window.open('/seeyon/collaboration/collaboration.do?method=newColl&templateId=-5615324791397988201&from=templateNewColl');
                    e.stopPropagation();
                    e.preventDefault();
                }
            }
        });
        ;
        col8.append(mTab8);
        col9.append(sTab9);
        col10.append(sTab10);
        var list111 = List.create({
            name: "办公会",
            link_prop: "link",
            data_url: URL_REPO.bangonghui,
            data_prop: [{
                "name": "field0002",
                size: 2,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }, {
                "name": "field0004",
                size: 4,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0005",
                size: 5,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0003",
                size: 1,
                render: function (name, data) {
                    return data;
                }
            }]

        });

        var list112 = List.create({
            name: "中心组学习",
            data_url: URL_REPO.zhongxinzuxuexi,
            link_prop: "link",
            data_prop: [{
                "name": "field0002",
                size: 2,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }, {
                "name": "field0004",
                size: 4,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0005",
                size: 5,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0003",
                size: 1,
                render: function (name, data) {
                    return data;
                }
            }]
        });
        var list113 = List.create({
            name: "领导班子会",
            data_url: URL_REPO.lingdaobanzihui,
            link_prop: "link",
            data_prop: [{
                "name": "field0002",
                size: 2,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }, {
                "name": "field0004",
                size: 4,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0005",
                size: 5,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0003",
                size: 1,
                render: function (name, data) {
                    return data;
                }
            }]

        });
        var list114 = List.create({
            name: "主任主题会",
            data_url: URL_REPO.zhurenzhutihui,
            link_prop: "link",
            data_prop: [{
                "name": "field0002",
                size: 2,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }, {
                "name": "field0004",
                size: 4,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0005",
                size: 5,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0003",
                size: 1,
                render: function (name, data) {
                    return data;
                }
            }]
        });
        var list115 = List.create({
            name: "党委会",
            data_url: URL_REPO.dangweihui,
            link_prop: "link",
            data_prop: [{
                "name": "field0002",
                size: 2,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }, {
                "name": "field0004",
                size: 4,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0005",
                size: 5,
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "field0003",
                size: 1,
                render: function (name, data) {
                    return data;
                }
            }]
        });
        var bangonghui = $("#bangonghui");
        bangonghui.append(list111.root);

        var mTab11 = MTab.create({
            id: "pending-main-1",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>办公会</span>",
                checked: true,
                contentType: "jq",
                content: bangonghui
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
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                size: 12,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                }
            }]

        });
        var list122 = List.create({
            data_url: URL_REPO.xinxijianbao,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                size: 12,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                }
            }]
        });
        var list123 = List.create({
            name: "政务信息通报",
            link_prop: "link",
            data_url: URL_REPO.zhengwuxinxitongbao,
            data_prop: [{
                "name": "frName",
                size: 12,
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                }
            }]
        });

        var zhuanbao1 = $("#zhuanbao1");
        zhuanbao1.append("<iframe  style='height:250px;overflow:hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport.jsp?rpx=/%E9%A6%96%E9%A1%B5-%E6%8A%A5%E8%A1%A8/%E8%AE%A1%E5%88%92%E5%AE%8C%E6%88%90.rpx&match=2'></iframe>");
        var zhuanbao2 = $("#zhuanbao2");
        zhuanbao2.append(list121.root);
        var zhuanbao = $("#zhuanbao");

        var jianbao1 = $("#jianbao1");
        jianbao1.append("<iframe  style='height:250px;overflow:hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport.jsp?rpx=/%E9%A6%96%E9%A1%B5-%E6%8A%A5%E8%A1%A8/%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx&match=2'></iframe>");
        var jianbao2 = $("#jianbao2");
        jianbao2.append(list122.root);
        var jianbao = $("#jianbao");

        var tongbao1 = $("#tongbao1");
        tongbao1.append("<iframe  style='height:250px;overflow:hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport.jsp?rpx=/%E9%A6%96%E9%A1%B5-%E6%8A%A5%E8%A1%A8/%E5%88%8A%E5%8F%91%E9%87%87%E7%94%A8.rpx&match=2'></iframe>");
        var tongbao2 = $("#tongbao2");
        tongbao2.append(list123.root);
        var tongbao = $("#tongbao");
        var mTab12 = MTab.create({
            id: "pending-main-1",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>信息专报</span>",
                checked: true,
                contentType: "jq",
                content: zhuanbao
            }, {
                name: "<span class='lx-tab-multi-head'>信息简报</span>",
                checked: false,
                contentType: "jq",
                content: jianbao
            }, {
                name: "<span class='lx-tab-multi-head'>政务信息通报</span>",
                checked: false,
                contentType: "jq",
                content: tongbao
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
                render: function (name, data, item) {
                    //<  onclick="window.open("/seeyon/menhu.do?method=openLink&linkType=news&id="+item.id") />"
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
            data_url: URL_REPO.xiazaizhuanqu,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list133 = List.create({
            data_url: URL_REPO.meizhoucaidan,
            link_prop: "link",
            data_prop: [{
                "name": "title",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data,item.body_type);
                },
                size: 9
            }, {
                "name": "updateDate",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var mTab13 = MTab.create({
            id: "pending-main-1",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>光荣榜</span>",
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

        var list1411 = List.create({
            data_url: URL_REPO.yianweijian1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1412 = List.create({
            data_url: URL_REPO.yianweijian2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1421 = List.create({
            data_url: URL_REPO.shijiuda1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1422 = List.create({
            data_url: URL_REPO.shijiuda2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1431 = List.create({
            data_url: URL_REPO.sanyansanshi1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1432 = List.create({
            data_url: URL_REPO.sanyansanshi2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1441 = List.create({
            data_url: URL_REPO.liangxueyizuo1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1442 = List.create({
            data_url: URL_REPO.liangxueyizuo2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1451 = List.create({
            data_url: URL_REPO.shibada1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1452 = List.create({
            data_url: URL_REPO.shibada2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1461 = List.create({
            data_url: URL_REPO.sanhuiyike1,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                render: function (name, data) {
                    return data.substring(5, 10);
                },
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var list1462 = List.create({
            data_url: URL_REPO.sanhuiyike2,
            link_prop: "link",
            data_prop: [{
                "name": "frName",
                render: function (name, data, item) {
                    return showIcon(item.readFlag,data);
                },
                size: 9
            }, {
                "name": "createTime",
                render: function (name, data) {
                    return data.substring(5, 10);
                },
                size: 3,
                render: function (name, data) {
                    return data.substring(0, 10);
                }
            }]
        });
        var yian1 = $("#yian1");
        yian1.append(list1411.root);
        var yian2 = $("#yian2");
        yian2.append(list1412.root);
        var yian = $("#yian");


        var shijiuda1 = $("#shijiuda1");
        shijiuda1.append(list1421.root);
        var shijiuda2 = $("#shijiuda2");
        shijiuda2.append(list1422.root);
        var shijiuda = $("#shijiuda");

        var sanyan1 = $("#sanyan1");
        sanyan1.append(list1431.root);
        var sanyan2 = $("#sanyan2");
        sanyan2.append(list1432.root);
        var sanyan = $("#sanyan");

        var liangxue1 = $("#liangxue1");
        liangxue1.append(list1441.root);
        var liangxue2 = $("#liangxue2");
        liangxue2.append(list1442.root);
        var liangxue = $("#liangxue");

        var shibada1 = $("#shibada1");
        shibada1.append(list1451.root);
        var shibada2 = $("#shibada2");
        shibada2.append(list1452.root);
        var shibada = $("#shibada");

        var sanhui1 = $("#sanhui1");
        sanhui1.append(list1461.root);
        var sanhui2 = $("#sanhui2");
        sanhui2.append(list1462.root);
        var sanhui = $("#sanhui");
        var mTab14 = MTab.create({
            id: "pending-main-1",
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>以案为鉴</span>",
                checked: true,
                contentType: "jq",
                content: yian
            }, {
                name: "<div class='lx-tab-multi-head'>十九大</div>",
                checked: false,
                contentType: "jq",
                content: shijiuda
            }, {
                name: "<span class='lx-tab-multi-head'>三严三实</span>",
                checked: false,
                contentType: "jq",
                content: sanyan
            }, {
                name: "<span class='lx-tab-multi-head'>两学一做</span>",
                checked: false,
                contentType: "jq",
                content: liangxue
            }, {
                name: "<span class='lx-tab-multi-head'>十八大</span>",
                checked: false,
                contentType: "jq",
                content: shibada
            }, {
                name: "<span class='lx-tab-multi-head'>三会一课</span>",
                checked: false,
                contentType: "jq",
                content: sanhui
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
            root_style: default_height,
            root_class: "layui-tab layui-tab-brief",
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

        /**
         * <div class="layui-inline lx-cal-name">
         任勇勇
         </div>
         <div class="layui-inline lx-cal-bj-out">
         在京，
         </div>
         <div class="layui-inline lx-cal-bj-out">
         在家办公
         </div>
         </div>
         */
        function renderCal(item, type) {
            var htmls = [];
            var start = item.startDate;
            var endd = item.endDate;
            var userName = item.userName;
            var location = item.location;
            var reason = item.reason;
            var ext3 = item.extString3;
            //console.log(item);
            //alert(1);
            var _cls = "";
            var _location = "在京"
            var inbj = true;
            if (type == "s" || type == "m" || type == "n") {
                htmls.push("<div class='lx-cal-item'><table><tr>");
                if (userName.length == 2) {
                    userName = userName[0] + "<span style='color:white'>一</span>" + userName[1];
                }
                htmls.push('<td style="width:75px"><div class="layui-inline lx-cal-name">');
                htmls.push(userName + ":");
                htmls.push("</div></td>");
                if (ext3) {
                    if (ext3 == "中心") {
                        _cls = "layui-inline lx-cal-black";
                        _location = "中心,"
                    } else if (ext3 == "京外") {
                        _cls = "layui-inline lx-cal-bj-out";
                        _location = "京外,"
                        inbj = false;
                    } else {
                        _cls = "layui-inline lx-cal-bj-in";
                        _location = "在京,"
                    }


                } else if (location == "" && reason == "") {
                    _cls = "layui-inline lx-cal-gray";
                    _location = "在京"
                } else if (reason != "" && location == "北京") {
                    _cls = "layui-inline lx-cal-bj-in";
                    _location = "在京,"
                } else if (reason != "" && location != "北京") {
                    _cls = "layui-inline lx-cal-bj-out";
                    _location = "京外,"
                    inbj = false;
                } else {
                    _cls = "layui-inline lx-cal-gray";
                    _location = "在京,"
                }
                if (type == "s") {
                    _cls = _cls + " lx-cal-max-s";
                } else {
                    _cls = _cls + " lx-cal-max-m";
                }
                htmls.push("<td><div class='" + _cls + "'>" + _location + "</div></td>");
                htmls.push("<td><div style='padding-left:8px' class='lx-eclipse " + _cls + "'><a title='" + reason + "'>" + reason + "</a></div></td>");
                htmls.push("</tr></table></div>");

            }

            var obj = {}
            obj.html = htmls.join("");

            obj.inbj = inbj ? 1 : 0;
            return obj;
        }

        function show_cal(day) {
            /**
             "my_cal":URL_BASE+"/seeyon/datakit/get.do?method=getMyCalendar&day=",
             "s_leader_cal":URL_BASE+"/seeyon/datakit/get.do?method=getDepartmentLeaderCalendar&day=",
             "m_leader_cal":URL_BASE+"/seeyon/datakit/get.do?method=getAccountLeaderCalendar&day="
             */
            $.ajax({
                url: URL_REPO.my_cal + day,
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {

                    if (data.items) {
                        //me.render(data.items);
                        console.log(data);
                        var htmls = [];
                        var inbj = 0;
                        $(data.items).each(function (index, item) {
                            var ret = renderCal(item, "n");
                            htmls.push(ret.html);

                        })
                        var h = htmls.join("");
                        if (h == "") {
                            h = "<span class='lx-cal-gray'>无日程安排</span>";
                        }
                        $("#my_cal").html(h);
                    } else {
                        $("#my_cal").html("<span class='lx-cal-gray'>无日程安排</span>");
                    }
                },
                error: function (res) {

                }
            });
            $.ajax({
                url: URL_REPO.s_leader_cal + day,
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {
                    if (data.items) {
                        // me.render(data.items);
                        var htmls_left = [];
                        var htmls_right = [];
                        var in_bj = 0;
                        $(data.items).each(function (index, item) {
                            var ret = renderCal(item, "s");
                            if (index < 7) {
                                htmls_left.push(ret.html);
                            } else {
                                htmls_right.push(ret.html);
                            }
                            in_bj += ret.inbj;

                        });
                        //var h = htmls.join("");

                        $("#s_leader_cal_left").html(htmls_left.join(""));
                        $("#s_leader_cal_right").html(htmls_right.join(""));
                        $("#s_leader_cal_header").html("部门负责人(" + in_bj + "/" + data.items.length + ")");
                    }
                },
                error: function (res) {

                }
            });
            $.ajax({
                url: URL_REPO.m_leader_cal + day,
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {
                    if (data.items) {
                        // me.render(data.items);
                        var htmls = [];
                        var in_bj = 0;
                        $(data.items).each(function (index, item) {
                            var ret = renderCal(item, "m");
                            htmls.push(ret.html);
                            in_bj += ret.inbj;
                        })
                        var h = htmls.join("");

                        $("#m_leader_cal").html(h);
                        $("#m_leader_cal_header").html("中心领导(" + in_bj + "/" + data.items.length + ")");
                    }
                },
                error: function (res) {

                }
            });

        }

        col15.append(mTab15);

        laydate.render({
            elem: '#cal_date_picker'
            , showBottom: false
            , position: 'static'
            , format: 'yyyy-MM-dd',
            done: function (value, date) {
                show_cal(value);
            }
        });
        //cal_leader_container
        var cal_mtab = MTab.create({
            id: "cal-main-1",
            root_style: "height:265px",
            root_class: "layui-tab layui-tab-brief",
            tabs: [{
                name: "<span class='lx-tab-multi-head'>我的日程</span>",
                checked: false,
                contentType: "jq",
                content: $("#my_cal")
            }, {
                name: "<span id='m_leader_cal_header' class='lx-tab-multi-head'>中心领导</span>",
                checked: true,
                contentType: "jq",
                content: $("#m_leader_cal")
            }, {
                name: "<span id='s_leader_cal_header' class='lx-tab-multi-head'>部门负责人</span>",
                checked: false,
                contentType: "jq",
                content: $("#s_leader_cal")
            }]

        });
        $("#cal_leader_container").append(cal_mtab.root);

        var now = new Date();
        show_cal(now.format("yyyy-MM-dd"));
        $("#pending_list_head").click(function(){
            list51.refresh(URL_REPO.daibangongzuo);
            renderAllBtnCount("3");
        });
        $("#overdate_list_head").click(function(){
            list54.refresh(URL_REPO.chaoqi);
            renderAllBtnCount("3&subState=12");
        });
        $("#done_list_head").click(function(){
            list53.refresh(URL_REPO.yiban);
            renderAllBtnCount("4");
        });
        $("#sent_list_head").click(function(){
            list52.refresh(URL_REPO.yifa);
            renderAllBtnCount("2");
        });
        $("#gongwen_button").click(function(e){
            // list51.refresh(URL_REPO.daibangongzuo);
            //
            refreshList(getCollState(),4,getCollList());
            $(".lx-btn-zq").removeClass("lx-btn-zq1");
            e = e||window.event;
            var target = e.target;
            if(target.tagName=="span"||target.tagName=="SPAN"){
                target = $(target).parent();
            }
            $(target).addClass("lx-btn-zq1");
        });
        $("#xietong_button").click(function(e){
            //list54.refresh(URL_REPO.chaoqi);
            refreshList(getCollState(),1,getCollList());
            $(".lx-btn-zq").removeClass("lx-btn-zq1");
            e = e||window.event;
            var target = e.target;
            if(target.tagName=="span"||target.tagName=="SPAN"){
                target = $(target).parent();
            }
            $(target).addClass("lx-btn-zq1");
        });
        $("#renwu_button").click(function(e){
            refreshList(getCollState(),999,getCollList());
            $(".lx-btn-zq").removeClass("lx-btn-zq1");
            e = e||window.event;
            var target = e.target;
            if(target.tagName=="span"||target.tagName=="SPAN"){
                target = $(target).parent();
            }
            $(target).addClass("lx-btn-zq1");
        });
        $("#huiyi_button").click(function(e){
            refreshList(getCollState(),6,getCollList());
            $(".lx-btn-zq").removeClass("lx-btn-zq1");
            e = e||window.event;
            var target = e.target;
            if(target.tagName=="span"||target.tagName=="SPAN"){
                target = $(target).parent();
            }
            $(target).addClass("lx-btn-zq1");

        });
        function refreshList(state,type,list){
            //console.log(state);
            var url= URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId="+state+"&offset=0&limit=6&$count=true&appType="+type;
            list.refresh(url);
        }
        function getCollState(){

            if($("#pending_list_head").parent().hasClass("layui-this")){
                return "3";
            }
            if($("#sent_list_head").parent().hasClass("layui-this")){
                return "2";
            }
            if($("#done_list_head").parent().hasClass("layui-this")){
                return "4";
            }
            if($("#overdate_list_head").parent().hasClass("layui-this")){
                return "3&subState=12";
            }
            return "";

        }
        function getCollList(){

            if($("#pending_list_head").parent().hasClass("layui-this")){
                return list51;
            }
            if($("#sent_list_head").parent().hasClass("layui-this")){
                return list52;
            }
            if($("#done_list_head").parent().hasClass("layui-this")){
                return list53;
            }
            if($("#overdate_list_head").parent().hasClass("layui-this")){
                return list54;
            }
            return "";

        }

        function renderBtnCount(state,app,target){
            var url= URL_BASE + "/seeyon/menhu.do?method=getUserCptList&typeId="+state+"&offset=0&limit=1&$count=true&appType="+app;
            $.ajax({
                url: url,
                async: true, //同步方式发送请求，true为异步发送
                type: "GET",
                dataType: "json",
                success: function (data) {
                    if (data.count) {
                        // me.render(data.items);
                        $(target).html(data.count);
                    }else{
                        $(target).html(0);
                    }
                },
                error: function (res) {

                }
            });
        }
        function renderAllBtnCount(state){
            renderBtnCount(state,"1",$("#xietong_count"));
            renderBtnCount(state,"4",$("#gongwen_count"));
            renderBtnCount(state,"999",$("#renwu_count"));
            renderBtnCount(state,"6",$("#huiyi_count"));
            $(".lx-btn-zq").removeClass("lx-btn-zq1");
        }
        //最开始的初始化
        renderBtnCount("3","1",$("#xietong_count"));
        renderBtnCount("3","4",$("#gongwen_count"));
        renderBtnCount("3","999",$("#renwu_count"));
        renderBtnCount("3","6",$("#huiyi_count"));

        //--------------//
//http://10.100.249.84:612/seeyon/nbd.do?method=goPage&page=report
        // cal_date_picker
    });
}(window));