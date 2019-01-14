
/**
 * 
 * 逻辑已经非常简化了，简化的不能在简化了？
 * TODO:还能在简化么？？？可以的 后续在优化
 * 
 * 
 */
$(document).ready(function(){
    lx.use(["jquery", "carousel", "element", "row", "col", "sTab", "mTab", "list", "lunbo", "mixed", "datepicker", "laydate"], function () {
        var url_repo={
            "data_link":"/seeyon/nbd.do?method=goPage&page=data_link",
            "a82other":"/seeyon/nbd.do?method=goPage&page=a82other",
            "other2a8":"/seeyon/nbd.do?method=goPage&page=other2a8"
        };
      
        var page_prop={
            "data_link":{
                name:"data_link",
                dataType:"数据连接配置",
                dataName:"配置列表",
                legendName:"数据库连接配置列表",
                columns:[
                    {"name":"","width":"40"},
                    {"name":"连接名称","width":"150"},
                    {"name":"地址","width":"200"},
                    {"name":"端口","width":"150"},
                    {"name":"数据库类型","width":"150"},
                    {"name":"用户名","width":"200"},
                    {"name":"数据库名","width":""},
                    {"name":"操作","width":""}
                ],
                keys:[{"name":"id"},{"name":"name"},{"name":"host"},{
                    "name":"port"
                },{"name":"dbType",render:Dao.transDbType},{"name":"userName"},{"name":"dataBaseName"},{"name":"op"}]

            },
            "a82other":{
                name:"a82other",
                dataType:"数据转换",
                dataName:"A82Other",
                legendName:"表单对接列表",
                columns:[
                    {"name":"","width":"40"},
                    {"name":"名称","width":"150"},
                    {"name":"Other连接","width":"150"},
                    {"name":"传输方式","width":"150"},
                    {"name":"触发方式","width":"200"},
                    {"name":"表单模板编号","width":""}
                ],
                keys:[
                    {"name":"id"},
                    {"name":"name"},
                    {"name":"sLinkId",render:Dao.getLinkName},
                    {"name":"exportType",render:Dao.transExportType},
                    {"name":"triggerType",render:Dao.transTriggerType},
                    {"name":"affairType"}
                ]

            },
            "other2a8":{
                name:"other2a8",
                dataType:"数据转换",
                dataName:"Other2a8",
                legendName:"表单对接列表",
                columns:[
                    {"name":"","width":"40"},
                    {"name":"表单名称","width":"150"},
                    {"name":"触发机制","width":"200"},
                    {"name":"数据连接","width":"150"},
                    {"name":"数据获取方式","width":"150"},
                    {"name":"表单模板编号","width":"200"},
                    {"name":"是否触发流程","width":""}
                ],
                keys:[{"name":"id"},{"name":"extString1"},{"name":"host"},{
                    "name":"extString2"
                },{"name":"dbType"},{"name":"user"},{"name":"dataBaseName"},{"name":"op"}]

            },
            "log":{

            }
        };
        var param = lx.eutil.getRequestParam();
        var data_type = param["data_type"];
        var initData = page_prop[data_type];
        initData.dataChecked={};
        initData.items=[];
        //避免数据加载过程中出现{{}}等奇怪的东西，看来这是双向绑定数据及时性的一个问题，有时间改改vue的源码
        initData.style="padding:15px;display:none";
        var vueDataList=  new Vue({
            el:"#dataList",
            data:initData,
            methods:{
                getSelectedItem:function(){
                    var lens = this.items.length;
                    if(lens==0){
                        layer.msg("请选择一条数据");
                        return null;
                    }
                    var tag = 0;
                    var index = -1;
                    for(var p =0;p<lens;p++){
                        if(this.dataChecked["select"+p]){
                            tag++;
                            index=p;
                        }
                    }
                    if(tag==0){
                        layer.msg("请选择一条数据");
                        return null;
                    }
                    if(tag>1){
                        layer.msg("只能选择一条数据");
                        return null;
                    }
                    if(tag==1){
                        var data = this.items[index];
                        return data;
                    }

                },
                createItem:function(){
                    window.location.href=url_repo[data_type];
                },
                updateItem:function(){
                    var data = this.getSelectedItem();
                    if(data){
                        window.location.href=url_repo[data_type]+"&id="+data.sid;
                    }
                    
                },
                deleteItem:function(){
                    var data = this.getSelectedItem();
                    if(!data){
                        return;
                    }
                    Dao.delete(data_type,{
                        id:data.sid
                    },function(ret){
                        if(ret.result){
                            window.location.href=window.location.href;
                            window.location.reload();
                        }else{
                            layer.msg("删除失败:"+ret.msg);
                        }
                        
                    },function(ret){
                        layer.msg("删除失败");
                    });
                   // console.log(data)
                },
                onSelected:function(index,e){
                     e = e||window.event;
                    if(this.dataChecked["select"+index]){
                        this.dataChecked["select"+index]=false;
                    }else{
                        this.dataChecked["select"+index]=true;
                    }
                },
                onQuery:function(index){
                    var data = this.items[index];
                    layer.open({
                        type: 2,
                        area: ['800px', '550px'],
                        fixed: false, //不固定
                        maxmin: true,
                        content: '/seeyon/nbd.do?method=goPage&page=dbConsole&linkId='+data.sid
                      });
                }
            }
        });
        //加载数据
        Dao.getList(data_type, function (data) {
           vueDataList.items = data.items||[];
           $("#dataList").show();
        });
    });
});