;
var URL_BASE = "http://192.168.1.98:612";
var URL_REPO = {
    //公告
    "bangongshigonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=7128333900198856380&offset=0&limit=7",
    "renshichugonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=5742101819118274289&offset=0&limit=7",
    "dangbangonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=-1022266653143186280&offset=0&limit=7",
    "caiwuchugonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=-4383918711151245312&offset=0&limit=7",
    "guojichugonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=2927795034072040494&offset=0&limit=7",
    "hywygonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&deptId=5284103497562737533&deptId2=-4727617731749985652&offset=0&limit=7",

    "guizhangzhidu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=7",
//自助专区
    "renshichuzizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7551688721062838393&offset=0&limit=6",
    "bangongshizizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1458495698761632674&offset=7&limit=12",
    "bangongshizizhu1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1458495698761632674&offset=13&limit=18",
    "bangongshizizhu2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1458495698761632674&offset=19&limit=24",
    "bangongshizizhu3": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1458495698761632674&offset=25&limit=30",
    "bangongshizizhu4": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1458495698761632674&offset=31&limit=36",
    "guojichuzizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1389302385817961671&offset=0&limit=7",
    "hywyzizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2824786069427538386typeId2=9072581542398086009&offset=0&limit=7",
    "dangweibangongshizizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=5568939695218378860&offset=0&limit=7",
    "caiwuchuzizhu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1433848281352916979&offset=0&limit=7"

    
    
 

 

};
(function () {

    lx.use(["jquery", "carousel", "element", "row","col","sTab","mTab","list","lunbo","mixed","datepicker"], function () {
        var default_height = "height:300px"
        var default_height_value = "300px";
        var default_height_col = "height:300px";
        var Row = lx.row;
        var MTab = lx.mTab;
        var Tab = lx["sTab"];
        var Col = lx.col;
        var List=lx.list;
        var Lunbo=lx.lunbo;
        var Mixed=lx.mixed;
        var $ = lx.jquery;
        var row1=Row.create({
            parent_id: "root_body",
            "id": "row1119",
            style:"margin-top:14px"
        });
        var row2=Row.create({
            parent_id: "root_body",
            "id": "row1129",
            style:"margin-top:14px"
        });
        var row3=Row.create({
            parent_id: "root_body",
            "id": "row1139",
            style:"margin-top:14px"
        });
        var row4=Row.create({
            parent_id: "root_body",
            "id": "row1149",
            style:"margin-top:14px"
        });
        var row5=Row.create({
            parent_id: "root_body",
            "id": "row1159",
            style:"margin-top:14px"
        });
        var col1=Col.create({
            size: 6,
            style: default_height_col
        });
        var col2=Col.create({
            size: 6,
            style: default_height_col,
            id: "col2"  
        });
        var col3=Col.create({
            size: 12,
            style:"height:200px"
        });
        var col4=Col.create({
            size: 12,
            style:default_height_col
        });
        var col5=Col.create({
            id:"col5",
            size: 4,
            style:default_height_col
        });
        var col6=Col.create({
            id:"col6",
            size: 4,
            style: default_height_col
        });
        var col7=Col.create({
            id:"col7",
            size: 4,
            style: default_height_col
        });
        row1.append(col1);
        row1.append(col2);
        row2.append(col3);
        row3.append(col4);
        row4.append(col5);
        row4.append(col6);
        row4.append(col7);
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
        var list1=List.create({
            name: "通知公告",
            link_prop:"link",      
            data_url: URL_REPO.bangongshigonggao,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data,item) {
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
        var list2=List.create({
            name: "规章制度",
            link_prop:"link",      
            data_url: URL_REPO.guizhangzhidu,
            data_prop: [{
                name: "frName",
                size: 10,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }, {
                "name": "createTime",
                size: 2,
                render: function (name, data) {
                    return data.substring(0,10);
                }
            }]

        });
        var sTab2 = Tab.create({
            "title": "<span class='lx-tab-head'>规章制度</span>",
            style: default_height,
            content: list2,
            more_btn: {
                class_name: "lx-tab-more-btn",
                html: "<i class='layui-icon layui-icon-more lx-more-btn'></i> ",
                click: function (e) {

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
        var sTab3 =Tab.create({
            "title": "<span class='lx-tab-head'>线上办理</span>",
            style:"height:200px",
            contentType: "jq",
            content: $("#quick_enter_btns")
        });
        var list4=List.create({
            name: "自助查询",
            data_offset:6,
            link_prop:"link",      
            data_url: URL_REPO.bangongshizizhu,
            data_prop: [{
                name: "frName",
                size: 12,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }]

        });
        var list41=List.create({
            name: "自助查询",
            link_prop:"link",    
            data_offset:6,  
            data_url: URL_REPO.bangongshizizhu1,
            data_prop: [{
                name: "frName",
                size: 12,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }]

        });
        var list42=List.create({
            name: "自助查询",
            data_offset:6,
            link_prop:"link",      
            data_url: URL_REPO.bangongshizizhu2,
            data_prop: [{
                name: "frName",
                size: 12,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }]

        });
        var list43=List.create({
            name: "自助查询",
            data_offset:6,
            link_prop:"link",      
            data_url: URL_REPO.bangongshizizhu3,
            data_prop: [{
                name: "frName",
                size: 12,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }]

        });
        var list44=List.create({
            name: "自助查询",
            data_offset:6,
            link_prop:"link",      
            data_url: URL_REPO.bangongshizizhu4,
            data_prop: [{
                name: "frName",
                size: 12,
                render: function (name, data,item) {
                    return showIcon(item.readFlag,data); 
                }
            }]

        });
        var zizhu1=$("#zizhu");
        zizhu1.append(list4.root);
        var zizhu2=$("#zizhu1");
        zizhu2.append(list41.root);
        var zizhu3=$("#zizhu2");
        zizhu3.append(list42.root);
        var zizhu4=$("#zizhu3");
        zizhu4.append(list43.root);
        var zizhu5=$("#zizhu4");
        zizhu5.append(list44.root);
        var zizhu1=$("#zizhu");
        zizhu1.append(list4.root);
        var zizhu=$("#zizhu");
        var sTab4 =Tab.create({
            "title": "<span class='lx-tab-head'>自助查询</span>",
            style:default_height,
            contentType: "jq",
            content:zizhu
        });
        var sTab5 =Tab.create({
            id:"sTab1",
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>公文报表</span>",
            style: default_height,
            contentType:"html",
             content:"<iframe  style='height:250px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport1.jsp?rpx=/dangjian-baobiao/sszbtj.rpx&match=2'></iframe>"
            
        });
        var sTab6 =Tab.create({
            id:"sTab2",
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>用章报表</span>",
            style: default_height,
            contentType:"html",
             content:"<iframe  style='height:250px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport1.jsp?rpx=/dangjian-baobiao/sszbtj.rpx&match=2'></iframe>"
            
        });
        var sTab7 =Tab.create({
            id:"sTab3",
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>巡查督查</span>",
            style: default_height,
            contentType:"html",
             content:"<iframe  style='height:250px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport1.jsp?rpx=/dangjian-baobiao/sszbtj.rpx&match=2'></iframe>"
            
        });
       col1.append(sTab1);
       col2.append(sTab2);
       col3.append(sTab3);
       col4.append(sTab4);
       col5.append(sTab5);
       col6.append(sTab6);
       col7.append(sTab7);

    });
}(window));