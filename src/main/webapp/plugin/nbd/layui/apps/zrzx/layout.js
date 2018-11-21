var URL_BASE= "";
var URL_REPO={

    "danweixinwen":URL_BASE+"/seeyon/menhu.do?method=getNewsList&typeId=1&offset=0&limit=6",
    "tupianxinwen":URL_BASE+"/seeyon/menhu.do?method=getImgNewList&typeId=1&offset=0&limit=6",
    "daibangongzuo":URL_BASE+"/seeyon/menhu.do?method=getUserCptList&offset=0&limit=6",
    "col_pending":URL_BASE+"/seeyon/menhu.do?method=getUserCptList&offset=3&limit=9",
    "edoc_pending":URL_BASE+"/seeyon/menhu.do?method=getUserCptList&offset=2&limit=8",
    "tongzhigonggao":URL_BASE+"/seeyon/menhu.do?method=getBulData&typeId=7305481828924604761&offset=0&limit=6",
    "zhongxincaidan":URL_BASE+"/seeyon/menhu.do?method=getBulData&typeId=-8736948720711547028&offset=0&limit=6",
    "liangxueyizuo":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=8188009082124256867&offset=0&limit=6",
    "shijiuda":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=7136252316133508367&offset=0&limit=6",
    "yianweijian":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=2104797802172793544&offset=0&limit=6",
    "dangjiangongzuo":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=575989468633646689&offset=0&limit=6",
    "guizhangzhidu":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=8314899268065577424&offset=0&limit=6",
    "guangrongbang":URL_BASE+"/seeyon/menhu.do?method=getDocList&typeId=820644300868634954&offset=0&limit=6",
    "changyongmoban":URL_BASE+"/seeyon/nbd.do?method=getMyCtpTemplateList&count=6"
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
                    size:7,
                    render: function (name, data) {
                        return data;
                    }
                }, {
                    "name": "updateDate",
                    size:2,
                    render:function(name,data){
                        return data.substring(5,10);
                    }
                }, {
                    "name": "publishDepartmentName",
                    size:3
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
                    render: function (name, data,item,index) {
                        if(index<2){
                            return '<span><span style="font-size:16px"  class="layui-badge">焦点</span><span style="margin-left:3px">'+data+"</span></span>";
                        }else{
                            return data;
                        }
                      
                    },
                    "size": 7
                }, {
                    "name": "publishDate",
                    render:function(name,data){
                        return data.substring(5,10);
                    },
                    "size": 2
                }, {
                    "name": "publishDepartmentName",
                    "size": 3
                }]

            }]
        }]
    },{
        cols:[{
            size: 12,
            id: "tools",
            type: "custom",
            name:"门户链接",
            render:function(parent,col,layex){
                var Mixed = layex.mixed;
                var mixRoot = Mixed.create({
                    id:"mixed1",
                    mode:"row",
                    size:12
                });
                var mix1 = Mixed.create({
                    id:"mixed2",
                    mode:"col",
                    size:12
                });
                var mix2 = Mixed.create({
                    id:"mixed2",
                    mode:"col",
                    size:12
                });
                var btn_htmls = ['<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color: #64d0c6;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">发起公文</button></div>'];
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#1f85ec;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">我要请假</button></div>');
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#5246c5;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">我的日程</button></div>');
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#ff6d68;display:inline-block;text-align:center;min-width:92px" class="layui-btn layui-btn-warm">停车单</button></div>');
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#26a3ed;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">外事公示</button></div>');
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#f9b954;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">我的工资</button></div>');
                
                for(var p =0;p<btn_htmls.length;p++){
                    mix1.addCmp({
                        size:2,
                        style:"height:40px",
                        content:btn_htmls[p]
                    });
                }
                btn_htmls = ['<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#1f85ec;display:inline-block;text-align:center" class="layui-btn layui-btn-warm">发起协同</button></div>','<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color: #64d0c6;display:inline-block" class="layui-btn layui-btn-warm">发起公文</button></div>'];
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#26a3ed;display:inline-block;min-width:92px;text-align:center" class="layui-btn layui-btn-warm">办公室</button></div>');
                
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#f9b954;display:inline-block;min-width:92px;text-align:center" class="layui-btn layui-btn-warm">人事</button></div>');
               
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#5246c5;display:inline-block;min-width:92px;text-align:center" class="layui-btn layui-btn-warm">此物</button></div>');
               
                btn_htmls.push('<div style="width:100%;margin:0 auto;text-align:center"><button style="background-color:#ff6d68;display:inline-block;min-width:92px;text-align:center" class="layui-btn layui-btn-warm">国际处</button></div>');
                
                for(var p =0;p<btn_htmls.length;p++){
                    mix2.addCmp({
                        size:2,
                        style:"height:40px",
                        content:btn_htmls[p]
                    });
                }

                mixRoot.addCmp({
                    size:12,
                    style:"height:45px",
                    content:mix1
                });
                mixRoot.addCmp({
                    size:12,
                    style:"height:45px",
                    content:mix2
                })
                parent.append(mixRoot);
                
            }
        }]
    }, {
        style:"350px",
        cols: [{
            size: 12,
            id: "pending",
            type: "custom",
            name:"待办工作",
            render:function(parent,col,layex){
                var mTab = layex.mTab;
                var List = layex.list;
                var Mixed = layex.mixed;
                var btn_htmls = ['<button style="background-color:#8693f3;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">6<span style="margin: 0 30px 0 30px">|</span>表单审批</button>'];
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#ff916e;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">3<span style="margin: 0 30px 0 30px">|</span>重要待办</button>');
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#5484ff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">2<span style="margin: 0 30px 0 30px">|</span>待开会议</button>');
                btn_htmls.push('<br><div style="width:1px;height:10px"></div><button style="background-color:#3cbaff;color:white" class="layui-btn layui-btn-lg layui-btn-primary layui-btn-radius">1<span style="margin: 0 30px 0 30px">|</span>领导安排</button>');
               
                var mix1 = Mixed.create({
                        id:"mixed1",
                        mode:"col",
                        cmps:[{
                            contentType:"html",
                            content:btn_htmls.join(""),
                            style:"height:240px",
                            size:2
                        }]
                });
                var list1 = List.create({
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
                });
                mix1.addCmp({
                    content:list1,
                    size:10,
                    style:"height:240px"
                });
                var list2 = List.create({
                    data_url: URL_REPO.col_pending,
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
                });
                var list3 = List.create({
                    data_url: URL_REPO.edoc_pending,
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
                });
                var mt = mTab.create({
                    id:"pending-main",
                    tabs:[{
                        "name":"<span style='color: #1E9FFF'>全部待办</span>",
                        checked:true,
                        contentType:"cmp",
                        content:mix1
                    },{
                        "name":"<span style='color: #1E9FFF'>协同待办(8)</span>",
                        checked:false,
                        contentType:"cmp",
                        content:list2
                    },{
                        "name":"<span style='color: #1E9FFF'>公文待办(6)</span>",
                        checked:false,
                        contentType:"cmp",
                        content:list3
                    }]
                });
                parent.append(mt);


            }
        }]
    }, {
        cols:[{
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

        },{
            size: 6,
            id: "pending2",
            name: "日程安排",
            type: "sTab",
            children: [{
                id:"datepicker2",
                cmp: "common",
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
            name: "党建工作",
            children: [{
                cmp: "list",
                name: "党建",
                max: 5,
                data_url:URL_REPO.dangjiangongzuo,
                data_prop: [{
                    "name": "frName",
                    render: function (name, data) {
                        return data;
                    },
                    size:10
                }, {
                    "name": "createTime",
                    size:2,
                    render:function(name,data){
                        return data.substring(5,10);
                    }
                }]
            }]
        }]
    },
        {
            cols: [{

                size: 12,
                id: "col7",
                type: "sTab",
                name: "两学一做",
                children: [{
                    cmp: "list",
                    name: "党建2",
                    max: 5,
                    data_url:URL_REPO.liangxueyizuo,
                    data_prop: [{
                        "name": "frName",
                        size:10,
                        render: function (name, data) {
                            return data;
                        }
                    }, {
                        "name": "createTime",
                        size:2,
                        render:function(name,data){
                            return data.substring(5,10);
                        }
                    }]
                }]
            }]



        },{
            cols:[{
                size: 6,
                id: "col7",
                type: "sTab",
                name: "以案为鉴",
                children: [{
                    cmp: "list",
                    name: "党建2",
                    max: 5,
                    data_url:URL_REPO.yianweijian,
                    data_prop: [{
                        "name": "frName",
                        size:10,
                        render: function (name, data) {
                            return data;
                        }
                    }, {
                        "name": "createTime",
                        size:2,
                        render:function(name,data){
                            return data.substring(5,10);
                        }
                    }]
                }]
            },{
                size: 6,
                id: "col7",
                type: "sTab",
                name: "十九大",
                children: [{
                    cmp: "list",
                    name: "党建2",
                    max: 5,
                    data_url:URL_REPO.shijiuda,
                    data_prop: [{
                        "name": "frName",
                        size:10,
                        render: function (name, data) {
                            return data;
                        }
                    }, {
                        "name": "createTime",
                        size:2,
                        render:function(name,data){
                            return data.substring(5,10);
                        }
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
                    data_url:URL_REPO.guizhangzhidu,
                    data_prop: [{
                        "name": "frName",
                        size:10,
                        render: function (name, data) {
                            return data;
                        }
                    }, {
                        "name": "createTime",
                        size:2,
                        render:function(name,data){
                            return data.substring(5,10);
                        }
                    }]
                }]
            },{

                size: 6,
                id: "caidan",
                type: "sTab",
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
                    data_url:URL_REPO.guangrongbang,
                    data_prop: [{
                        "name": "frName",
                        size:10,
                        render: function (name, data) {
                            return data;
                        }}, {
                        "name": "createTime",
                        size:2,
                        render:function(name,data){
                            return data.substring(5,10);
                        }
                    }]
                }]
            }]
        }]
}