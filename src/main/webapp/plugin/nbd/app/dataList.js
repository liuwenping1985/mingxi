$(document).ready(function(){
    lx.use(["jquery", "carousel", "element", "row", "col", "sTab", "mTab", "list", "lunbo", "mixed", "datepicker", "laydate"], function () {
        var url_repo={
            "data_link":"data_link.html"
        }

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
                keys:[{"name":"id"},{"name":"extString1"},{"name":"host"},{
                    "name":"extString2"
                },{"name":"dbType"},{"name":"user"},{"name":"dataBaseName"},{"name":"op"}]

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
                    {"name":"表单模板编号","width":""},

                ],
                keys:[{"name":"id"},{"name":"name"},{
                    "name":"linkId"
                },{"name":"exportType"},{"name":"triggerType"},{"name":"affairType"}]

            },
            "other2a8":{
                name:"other2a8",
                dataType:"数据转换",
                dataName:"Other2a8",
                legendName:"表单对接列表",
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
        var vueDataList=  new Vue({
            el:"#dataList",
            data:initData,
            methods:{
                getSelectedItem:function(){
                    var lens = this.items.length;
                    if(lens==0){
                        alert("请选择一条数据");
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
                        alert("请选择一条数据");
                        return null;
                    }
                    if(tag>1){
                        alert("只能选择一条数据");
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
                    window.location.href=url_repo[data_type]+"?id="+data.id;
                },
                deleteItem:function(){
                    var data = this.getSelectedItem();
                    console.log(data)
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
                }
            }
        });
        //加载数据
        Dao.getList(data_type, function (data) {

            vueDataList.items = data.items||[];

        });

        //渲染



    });






});