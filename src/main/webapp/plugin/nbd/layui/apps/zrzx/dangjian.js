;var URL_BASE = "http://10.100.249.84:612";
var URL_REPO = {
    "dangbanxinwen": URL_BASE + "/seeyon/menhu.do?method=getNewList&typeId=1464919845832769560&offset=0&limit=7",
    "tupianxinwen": URL_BASE + "/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=7",
    "dangbangonggao": URL_BASE + "/seeyon/menhu.do?method=getBulData&typeId=-5359331239448328220&offset=0&limit=7",
   
    "buyouxiudangyuan": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=6285356941213060786&offset=0&limit=7",
    "zhongxinyouxiudangyuan": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=47447023049396154&offset=0&limit=7",
   
    "zhongxinzuxuexi": URL_BASE + "/seeyon/menhu.do?method=getFormmainList&typeId=4327169891904341638&offset=0&limit=7",
    "dangjiangongzuogongshi": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=575989468633646689&offset=0&limit=7",

    "yianweijian1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=6292304269503974164&offset=0&limit=6",
    "yianweijian2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=2104797802172793544&offset=0&limit=6",
    "shijiuda1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8090639548974844938&offset=0&limit=6",
    "shijiuda2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7136252316133508367&offset=0&limit=6",
    "sanyansanshi1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1385529657363679024&offset=0&limit=6",
    "sanyansanshi2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=7462332795861419459&offset=0&limit=6",
    "liangxueyizuo1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=1268478479319909049&offset=0&limit=6",
    "liangxueyizuo2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8188009082124256867&offset=0&limit=6",
    "shibada1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=4252252302003883022&offset=0&limit=6",
    "shibada2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=5469896967953073526&offset=0&limit=6",
    "sanhuiyike2": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8503501149007790685&offset=0&limit=6",
    "sanhuiyike1": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8339111925347929889&offset=0&limit=6",

    "guizhangzhidu": URL_BASE + "/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=7",

    
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
        var col1=Col.create({
            size: 4,
            style: default_height_col
        });
        var col2=Col.create({
            size: 4,
            style: default_height_col,
            id: "col2"  
        });
        var col3=Col.create({
            size: 4,
            style: default_height_col
        });
        var col4=Col.create({
            size: 4,
            style:"height:460px"
        });
        var col5=Col.create({
            size: 8,
            style:"height:460px"
        });
        var col6=Col.create({
            size: 4,
            style: default_height_col
        });
        var col7=Col.create({
            size: 8,
            style: default_height_col
        });
        var col8=Col.create({
            size: 12,
            style:"height:420px" ,
        });
        row1.append(col1);
        row1.append(col2);
        row1.append(col3);
        row2.append(col4);
        row2.append(col5);
        row3.append(col6);
        row3.append(col7);
        row4.append(col8);
        var list1=List.create({
            name: "党办公告",
            link_prop:"link",      
            data_url: URL_REPO.dangbangonggao,
            data_prop: [{
                name: "title",
                size: 10,
                render: function (name, data,item) {
                    if(item.readFlag){//有错误
                        if(item.body_type=="Pdf"){
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_pdf'></span>";                                     
                        }else if(item.body_type=="OfficeWord"){                           
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_word'></span>";                                               
                        }else if(item.body_type=="20"){
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_form_temp'></span>";
                        }else{
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";
                        }    
                    }else{
                        if(item.body_type=="Pdf"){
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_pdf'></span>";                                     
                        }else if(item.body_type=="OfficeWord"){                           
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_word'></span>";                                               
                        }else if(item.body_type=="20"){
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_form_temp'></span>";
                        }else{
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";
                        }    
                 }  
                }
            }, {
                "name": "updateDate",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]

        });
        var mTab1=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>党办公告</span>",
                checked:true,
                contentType:"cmp",
                content:list1
            }],
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
        col1.append(mTab1);
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
        col2.append(lunbo2);

        function isNumber(str){
            var re = /^([0-9]+)([.]?)([0-9]*)$/;  
            return re.test(str);
        };
        var list3=List.create({
            data_url: URL_REPO.dangbanxinwen,
            link_prop:"link",
            data_prop: [{
                name: "title",
               
                size: 10,
                render: function (name, data,item) {
                    if(item.readFlag){
                        if(item.body_type=="Pdf"){
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_pdf'></span>";                                     
                        }else if(item.body_type=="OfficeWord"){                           
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_word'></span>";                                               
                        }else if(item.body_type=="20"){
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_form_temp'></span>";
                        }else{
                                    return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";
                        }    
                    }else{
                        if(item.body_type=="Pdf"){
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_pdf'></span>";                                     
                        }else if(item.body_type=="OfficeWord"){                           
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_word'></span>";                                               
                        }else if(item.body_type=="20"){
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span><span class='lx_icon16_form_temp'></span>";
                        }else{
                                    return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";
                       }    
                 }  
                }
            }, {
                "name": "publishDate",
                size: 2,
                render: function (name,data,item) {
                    var txtDate = new Date(item);
                    if(isNumber(item)){
                        return (new Date()+"").substring(5, 10);
                    }else{
                      //  alert(data);
                         return data.substring(5,10);
                    }
                   
                }
            }]
        });
        var mTab3=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>党办新闻</span>",
                checked:true,
                contentType:"cmp",
                content:list3
            }],
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
        col3.append(mTab3);      
        var row211=Row.create({
            parent_id: "root_body",
            "id": "row211"
            
        });
        var row212=Row.create({
            parent_id: "root_body",
            "id": "row212"
        });
        var col211=Col.create({
            size: 12,
            style:"height:314px"
        });
        var col212=Col.create({
            size: 12,
            style:"height:200px"
        });
        row211.append(col211);
        row212.append(col212);
        col4.append(row211);
        col4.append(row212);
     //   var leader=$("#leader_table");
        var sTab41 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>中心党委</span>",
            style:"height:300px",
            contentType:"jq",
            content:$("#leader_table"),
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
        var sTab42 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>个人信息</span>",
            style: "height:145px",
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
        col211.append(sTab41);
        col212.append(sTab42);
        var row221=Row.create({
            parent_id: "root_body",
            "id": "row221"
        });
        var row222=Row.create({
            parent_id: "root_body",
            "id": "row222"
        });
        var col221=Col.create({
            size: 12,
            style:"height:160px"
        });
        var col222=Col.create({
            size: 6,
            style:"height:430px"
        });
        var col223=Col.create({
            size: 6,
            style:"height:430px"
        });
        row221.append(col221);
        row222.append(col222);
        row222.append(col223);
        col5.append(row221);
        col5.append(row222);
        var sTab43 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>快捷通道</span>",
            style:"height:140px",
            contentType: "jq",
            content: $("#quick_enter_btns"),
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
        var sTab44 =Tab.create({
            "title": "<span style='font-size:20px;border-left:6px solid cornflowerblue;padding: 5px'>党员结构</span>",
            style: default_height,
            contentType:"html",
             content:"<iframe  style='height:250px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/matchReport.jsp?rpx=/dangjian-baobiao/sszbtj.rpx&match=2'></iframe>",
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
        var list451 = List.create({
            name: "部优秀党员",
            data_url: URL_REPO.buyouxiudangyuan,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data,item) {
                    if(item.readFlag){                       
                        return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                    }else{
                        return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                    }              
                }
            }, {
                "name": "createTime",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var list452 = List.create({
            name: "中心优秀党员",
            data_url: URL_REPO.zhongxinyouxiudangyuan,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data,item) {
                    if(item.readFlag){                       
                        return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                    }else{
                        return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                    }              
                }
            }, {
                "name": "createTime",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var mTab45 =MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>部优秀党员</span>",
                checked:true,
                contentType:"cmp",
                content:list451
            },{
                name:"<span style='color:black;font-size:12px'>中心优秀党员</span>",
                checked:false,
                contentType:"cmp",
                content:list452
            }],
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
        col221.append(sTab43);
        col222.append(sTab44);
        col223.append(mTab45);
        var list61=List.create({
            data_url: URL_REPO.dangjiangongzuogongshi,
            data_prop: [{
                "name": "frName",
                size: 10,
                render: function (name, data,item) {
                    if(item.readFlag){                       
                        return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                    }else{
                        return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                    }              
                }
            }, {
                "name": "createTime",
                size: 2,
                render: function (name, data) {
                    return data.substring(5, 10);
                }
            }]
        });
        var list62=List.create({
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
        var mTab6=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>党建工作公示</span>",
                checked:true,
                contentType:"cmp",
                content:list61
            },{
                name:"<span style='color:black;font-size:12px'>中心组学习</span>",
                checked:false,
                contentType:"cmp",
                content:list62
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
        col6.append(mTab6);
                var list711 = List.create({
                    data_url: URL_REPO.yianweijian1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }             

                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list712 = List.create({
                    data_url: URL_REPO.yianweijian2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   //doc少readFlag
                            }       
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list721 = List.create({
                    data_url: URL_REPO.shijiuda1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }                
        
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list722 = List.create({
                    data_url: URL_REPO.shijiuda2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list731 = List.create({
                    data_url: URL_REPO.sanyansanshi1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list732 = List.create({
                    data_url: URL_REPO.sanyansanshi2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list741 = List.create({
                    data_url: URL_REPO.liangxueyizuo1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }     
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list742 = List.create({
                    data_url: URL_REPO.liangxueyizuo2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list751 = List.create({
                    data_url: URL_REPO.shibada1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list752 = List.create({
                    data_url: URL_REPO.shibada2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
                        },
                        size: 9
                    }, {
                        "name": "createTime",
                        size: 3
                    }]
                });
                var list761 = List.create({
                    data_url: URL_REPO.sanhuiyike1,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                            }   
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
                var list762 = List.create({
                    data_url: URL_REPO.sanhuiyike2,
                    data_prop: [{
                        "name": "frName",
                        render: function (name, data,item) {
                            if(item.readFlag){                       
                                return "<span class='lx_icon16_messa lx-icon-margin-zq'></span><span>"+data+"</span>";                            
                            }else{
                                return "<span class='lx_icon16_message lx-icon-margin-zq'></span><span>"+data+"</span>";   
                                }   
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
                var yian1=$("#yian1");
                yian1.append(list711.root);
                var yian2=$("#yian2");
                yian2.append(list712.root);
                var yian=$("#yian");
                

                var shijiuda1=$("#shijiuda1");
                shijiuda1.append(list721.root);
                var shijiuda2=$("#shijiuda2");
                shijiuda2.append(list722.root);
                var shijiuda=$("#shijiuda");

                var sanyan1=$("#sanyan1");
                sanyan1.append(list731.root);
                var sanyan2=$("#sanyan2");
                sanyan2.append(list732.root);
                var sanyan=$("#sanyan");

                var liangxue1=$("#liangxue1");
                liangxue1.append(list741.root);
                var liangxue2=$("#liangxue2");
                liangxue2.append(list742.root);
                var liangxue=$("#liangxue");

                var shibada1=$("#shibada1");
                shibada1.append(list751.root);
                var shibada2=$("#shibada2");
                shibada2.append(list752.root);
                var shibada=$("#shibada");

                var sanhui1=$("#sanhui1");
                sanhui1.append(list761.root);
                var sanhui2=$("#sanhui2");
                sanhui2.append(list762.root);
                var sanhui=$("#sanhui");
        var mTab7=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>以案为鉴</span>",
                checked:true,
                contentType:"jq",
                content:yian
                
            },{
                name:"<div style='color:black;font-size:12px'>十九大</div>",
                checked:false,
                contentType:"jq",
                content:shijiuda
            },{
                name:"<span style='color:black;font-size:12px'>三严三实</span>",
                checked:false,
                contentType:"jq",
                content:sanyan
            },{
                name:"<span style='color:black;font-size:12px'>两学一做</span>",
                checked:false,
                contentType:"jq",
                content:liangxue
            },{
                name:"<span style='color:black;font-size:12px'>十八大</span>",
                checked:false,
                contentType:"jq",
                content:shibada
            },{
                name:"<span style='color:black;font-size:12px'>三会一课</span>",
                checked:false,
                contentType:"jq",
                content:sanhui
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
        col7.append(mTab7);
        var mixRoot=Mixed.create({
            contentType:"",
            size:12,
            model:"col"
        });
        var row81=Row.create({
            parent_id: "root_body",
            "id": "row81",
           // style:"margin-top:14px"
        });
        var row82=Row.create({
            parent_id: "root_body",
            "id": "row82",
            style:"margin-top:14px"
        });
        var col81=Col.create({ 
            size:6,
            style:"height:300px"
        });
        var col82=Col.create({
            size: 6,
            style:"height:100px"
        });
        var col83=Col.create({
            size: 12,
            style:"height:100px"
        });
        var mTab811=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>规章制度</span>",
                checked:true,
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
        var mTab812=MTab.create({
            id:"pending-main-1",
            root_style:default_height,
            tabs:[{
                name:"<span style='color:black;font-size:12px'>部交办工作</span>",
                checked:true,
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
        var mTab813=MTab.create({
            id:"pending-main-1",
            root_style:"height:100px",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>中心工作</span>",
                checked:true,
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
        
        row81.append(col81);
        row81.append(col82);
        row82.append(col83);
        col81.append(mTab811);
        col82.append(mTab812);
        col83.append(mTab813);
        mixRoot.append(row81);
        mixRoot.append(row82);
        var mTab8=MTab.create({
            root_class:"layui-tab layui-tab-brief",
            root_style:"height:500px",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>宣传工作</span>",
                checked:true,
                contentType: "cmp",
                content:mixRoot
           
            },{
                name:"<span style='color:black;font-size:12px'>组织工作</span>",
                checked:false
                
            },{
                name:"<span style='color:black;font-size:12px'>纪检工作</span>",
                checked:false
                
            },{
                name:"<span style='color:black;font-size:12px'>工会工作</span>",
                checked:false
                
            },{
                name:"<span style='color:black;font-size:12px'>团委工作</span>",
                checked:false
                
            },{
                name:"<span style='color:black;font-size:12px'>妇委工作</span>",
                checked:false
               
            },{
                name:"<span style='color:black;font-size:12px'>全部工作</span>",
                checked:false
               
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
        col8.append(mTab8);

    });
}(window));