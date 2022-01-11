;var URL_BASE = "http://192.168.1.98:612";
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
    "zhengwuxinxitongbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2101297384881669972&offset=0&limit=6",
    "hyjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8567852862769874037&offset=0&limit=6",
    "xqgs": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=3563212477215886478&offset=0&limit=6",
    "bmfzjy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7211608043895997701&offset=0&limit=6",
    "zxyy": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4678376827589578511&offset=0&limit=6",
    "guizhangzhidu2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=6",
    "zhixinggongshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8922663637462369764&offset=0&limit=6",
    "guojidongtai": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=6475027635041617679&offset=0&limit=6",
    "xinxijianbao": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4550956951978068889&offset=0&limit=6",
    "sanchansanshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7462332795861419459&offset=0&limit=6",
    "shibada": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=5469896967953073526&offset=0&limit=6",

    "zuoriyaoqing":URL_BASE+"/seeyon/menhu.do?method=getBulData&typeId=-2220615473202182672&offset=0&limit=6",//昨日要请，空的，
    "wodemoban": URL_BASE + "/seeyon/nbd.do?method=getMyCtpTemplateList&count=9",//登陆才有
    "sanhuiyike":URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8503501149007790685 &offset=0&limit=6",
    "gongzuodongtai":"",//工作动态
    "xinxizhuanbao":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=4787332904735427042&offset=0&limit=6",//信息专报
    "xiazaizhuanqu":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=2296413374197223074&offset=0&limit=6",//下载专区，空的
    "bangonghui":URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=3297213230734002184&offset=0&limit=6",
    "lingdaobanzihui":URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-7007958826195137660&offset=0&limit=6",
    "zhurenzhutihui":URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-3156250650104348435&offset=0&limit=6",
    "dangweihui":URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=-6730682058817912143&offset=0&limit=6",
    "zhongxinzuxuexi":URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=4327169891904341638&offset=0&limit=6",

};
(function () {

    lx.use(["jquery", "carousel", "element", "row","col","sTab","mTab","list","lunbo","mixed","datepicker"], function () {
        var default_height="height:330px";
        var Row = lx.row;
        var MTab = lx.mTab;
        var Tab = lx["sTab"];
        var Col = lx.col;
        var List=lx.list;
        var Lunbo=lx.lunbo;
        var Mixed=lx.mixed;
        var $ = lx.jquery;
        var DatePicker = lx.datepicker;
        //行
        var row1 = Row.create({
            parent_id: "root_body",
            "id": "row1119"
        });
        var row2 = Row.create({
            parent_id: "root_body",
            "id": "row1129"
        });
        var row3 = Row.create({
            parent_id: "root_body",
            "id": "row1139"
        });
        var row4 = Row.create({
            parent_id: "root_body",
            "id": "row1149"
        });
        var row5 = Row.create({
            parent_id: "root_body",
            "id": "row1159"
        });
        var row6 = Row.create({
            parent_id: "root_body",
            "id": "row1169"
        });
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1179"
        });
        //列
        var col1 = Col.create({
            size: 4,
            style:"height:300px"
        });

        var col2 = Col.create({
            size: 4,
            style:"height:300px"
        });
        var col3 = Col.create({
            size: 4,
            style:"height:300px"
        });
        row1.append(col1);
        row1.append(col2);
        row1.append(col3);
        var col4 = Col.create({
            size: 4,
            style:"height:300px"
        });
        var col5 = Col.create({
            size: 8,
            style:"height:300px"
        });
        row2.append(col4);
        row2.append(col5);
        var col6 = Col.create({
            size: 4,
            style:"height:300px"
        });
        var col7 = Col.create({
            size: 8,
            style:"height:300px"
        });
        row3.append(col6);
        row3.append(col7);
        var col8 = Col.create({
            size: 4,
            style:"height:300px"
        });
        var col9 = Col.create({
            size: 2,
            style:"height:300px"
        });
        var col10 = Col.create({
            size: 6,
            style:"height:300px"
        });
        row4.append(col8);
        row4.append(col9);
        row4.append(col10);
        var col11 = Col.create({
            size: 6,
            style:"height:300px"
        });
        var col12 = Col.create({
            size: 6,
            style:"height:300px"
        });
        row5.append(col11);
        row5.append(col12);
        var col13 = Col.create({
            size: 4,
            style:"height:300px"
        });
        var col14 = Col.create({
            size: 8,
            style:"height:300px"
        });
        row6.append(col13);
        row6.append(col14);
        var col15 = Col.create({
            size: 12,
            style:"height:300px"
        });
        row7.append(col15);

        var list1=List.create({
            name: "通知公告",
            max: 5,
            data_url: URL_REPO.tongzhigonggao,
            data_prop: [{
                name: "title",
                size: 7,
                render: function (name, data,cell,item) {
                    console.log(item);
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

        });
        var sTab1 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>通知公告</span>",
            style:default_height,
            more_btn:{
                class_name:"lx-tab-more-btn",
                html:"<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click:function(e){
                    //alert("click");
                }
            },
            new_btn:{
                class_name:"lx-tab-new-btn",
                html:"<span class='lx-new-btn'>+</span>",
                click:function(e){
                    //alert("click2");
                }
            }
        });
        sTab1.append(list1);
        var lunbo2=Lunbo.create({

            cmp_options: {
                id: "lunbo2",
                change: function (res) {
                    console("changed");
                },
                size: 12,
                interval: 3000
            },
            data_url: URL_REPO.tupianxinwen,
            data_prop: {
                "name": "title",
                "img": "imgUrl"
            }
        });
        var list31=List.create({
            data_url: URL_REPO.zuoriyaoqing,
            data_prop: [{
                name: "title",
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
        });
        var list32=List.create({
            data_url: URL_REPO.zuoriyaoqing,
            data_prop: [{
                name: "title",
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
        });
        var mTab3 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>昨日要情</span>",
                checked:true,
                contentType: "cmp",
                content:list31
            },{
                name:"<span style='color:black;font-size:12px'>工作动态</span>",
                checked:false,
                contentType: "cmp",
                content:list32
            }]
        });
        col1.append(sTab1);
        col2.append(lunbo2);
        col3.append(mTab3);
        var list4=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var sTab4 =Tab.create({
            title: "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>跟踪督办</span>",
            style:"height:280px",
            contentType:"cmp",
            content:list4
        });
        var list51=List.create({
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
        var list52=List.create({

        });
        var list53=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list54=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var mixRoot51 = Mixed.create({
            id:"mixed1",
            mode:"col",
            size:12
        });
        var btn_htmls = ['<button style="background-color:#8693f3;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">6<span style="margin: 0 30px 0 30px">|</span>表单审批</button>'];
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#ff916e;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">3<span style="margin: 0 30px 0 30px">|</span>重要待办</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#5484ff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">2<span style="margin: 0 30px 0 30px">|</span>待开会议</button>');
        btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#3cbaff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">1<span style="margin: 0 30px 0 30px">|</span>领导安排</button>');
        var mix511 = Mixed.create({
            id:"mixed2",
            mode:"col",
            size:4,
            cmps: [{
                contentType: "html",
                content: btn_htmls.join(""),
                style: "height:240px",
                size: 4
            }]
        });
        var mix512 = Mixed.create({
            id:"mixed3",
            mode:"col",
            size:8
        });
         mix512.append(list51);
        //mix512.append();
        mixRoot51.append(mix511);
        mixRoot51.append(mix512);
        var mTab5 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>待办[5]</span>",
                checked:true,
                contentType: "cmp",
                content:mixRoot51
            },{
                name:"<span style='color:black;font-size:12px'>已发[12]</span>",
                checked:false,
                contentType: "cmp",
                content:list52
            },{
                name:"<span style='color:black;font-size:12px'>已办[12]</span>",
                checked:true,
                contentType: "cmp",
                content:list53
            },{
                name:"<span style='color:black;font-size:12px'>超期[1]</span>",
                checked:true,
                contentType: "cmp",
                content:list54
            }]
        });
        col4.append(sTab4);
        col5.append(mTab5);
        var list6=List.create({
            data_url: URL_REPO.wodemoban,
            data_prop: [{
                "name": "subject",
                render: function (name, data) {
                    return data;
                }
            }, {
                "name": "createDate"
            }, {
                "name": "publishDepartmentName"
            }]
        });
        var sTab6 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>我的模板</span>",
            "style":"height:280px",
            contentType:"cmp",
            content:list6
        });
        var list7=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var sTab7 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>快捷通道</span>",
            "style":"height:280px",
            contentType:"cmp",
            content:list7
        });;
        col6.append(sTab6);
        col7.append(sTab7);
        var list81=List.create({
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
        var list82=List.create({
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
        var list83=List.create({
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
        var mTab8 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>行前公示</span>",
                checked:true,
                contentType: "cmp",
                content:list81
            },{
                name:"<span style='color:black;font-size:12px'>执行公示</span>",
                checked:true,
                contentType: "cmp",
                content:list82
            },{
                name:"<span style='color:black;font-size:12px'>国际动态</span>",
                checked:true,
                contentType: "cmp",
                content:list83
            }]
        });
        var list9=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list10=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var sTab9 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>我的收藏</span>",
            "style":"height:280px",
            contentType:"cmp",
            content:list9
        });;
        var mixedRoot10 = Mixed.create({
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
        mixedRoot10.addCmp({
            contentType:"cmp",
            content:mixedLeft,
            size:6
        });
        mixedRoot10.addCmp({
            contentType:"cmp",
            content:mixedRight,
            size:6
        });
        mixedRight.addCmp({
            content:$("#leader_calendar"),
            size:12
        })
        DatePicker.create({
            height:"200px",
            "id":"picker",
            "className":"",
            parent:mixedLeft
        });
        var sTab10 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>日程管理</span>",
            "style":"height:280px",
            contentType:"cmp",
            content:mixedRoot10
        });;
        col8.append(mTab8);
        col9.append(sTab9);
        col10.append(sTab10);
        var list111=List.create({
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
        var list112=List.create({
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
        var list113=List.create({
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
        var list114=List.create({
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
        var list115=List.create({
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

        var mTab11 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>办公会</span>",
                checked:true,
                contentType: "cmp",
                content:list111
            }, {
                    name:"<span style='color:black;font-size:12px'>中心组学习</span>",
                    checked:false,
                    contentType: "cmp",
                    content:list112
            },{
                name:"<span style='color:black;font-size:12px'>领导班子会</span>",
                checked:false,
                contentType: "cmp",
                content:list113
            },{
                name:"<span style='color:black;font-size:12px'>主任主题会</span>",
                checked:false,
                contentType: "cmp",
                content:list114
            },{
                name:"<span style='color:black;font-size:12px'>党委会</span>",
                checked:false,
                contentType: "cmp",
                content:list115
            }]
        });
        var list121=List.create({

        });
        var list122=List.create({
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
        var list123=List.create({
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
        var mTab12 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>信息专报</span>",
                checked:true,
                contentType: "cmp",
                content:list121
            },{
                name:"<span style='color:black;font-size:12px'>信息简报</span>",
                checked:false,
                contentType: "cmp",
                content:list122
            },{
                name:"<span style='color:black;font-size:12px'>政务信息通报</span>",
                checked:false,
                contentType: "cmp",
                content:list123
            }]
        });
        col11.append(mTab11);
        col12.append(mTab12);
        var list131=List.create({
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
        var list132=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list133=List.create({
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
        var mTab13 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>光荣特区</span>",
                checked:true,
                contentType: "cmp",
                content:list131
            },{
                name:"<span style='color:black;font-size:12px'>下载专区</span>",
                checked:false,
                contentType: "cmp",
                content:list132
            },{
                name:"<span style='color:black;font-size:12px'>每周餐单</span>",
                checked:false,
                contentType: "cmp",
                content:list133
            }]
        });
        var list141=List.create({
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
        var list142=List.create({
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
        var list143=List.create({
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
        var list144=List.create({
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
        var list145=List.create({
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
        var list146=List.create({
            data_url: URL_REPO.sanhuiyike,
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
        var mTab14 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>以案为鉴</span>",
                checked:true,
                contentType: "cmp",
                content:list141
            },{
                name:"<div style='color:black;font-size:12px'>十九大</div>",
                checked:false,
                contentType: "cmp",
                content:list142
            },{
                name:"<span style='color:black;font-size:12px'>三严三实</span>",
                checked:false,
                contentType: "cmp",
                content:list143
            },{
                name:"<span style='color:black;font-size:12px'>两学一做</span>",
                checked:false,
                contentType: "cmp",
                content:list144
            },{
                name:"<span style='color:black;font-size:12px'>十八大</span>",
                checked:false,
                contentType: "cmp",
                content:list145
            },{
                name:"<span style='color:black;font-size:12px'>三会一课</span>",
                checked:false,
                contentType: "cmp",
                content:list146
            }]
        });
        col13.append(mTab13);
        col14.append(mTab14);
        var list151=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list152=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list153=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var list154=List.create({
            data_url: "",
            data_prop: [{
                name: "subject",
                render:"",
                size: 8
            }]
        });
        var mTab15 =MTab.create({
            id:"pending-main-1",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>重点工作</span>",
                checked:true,
                contentType: "cmp",
                content:list151
            },{
                name:"<span style='color:black;font-size:12px'>党建工作</span>",
                checked:false,
                contentType: "cmp",
                content:list152
            },{
                name:"<span style='color:black;font-size:12px'>外事计划</span>",
                checked:false,
                contentType: "cmp",
                content:list153
            },{
                name:"<span style='color:black;font-size:12px'>会议计划</span>",
                checked:false,
                contentType: "cmp",
                content:list154
            }]
        });
        col15.append(mTab15);
    });
}(window));