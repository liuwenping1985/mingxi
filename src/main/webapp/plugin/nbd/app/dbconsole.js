;(function(){

    $(document).ready(function(){
        var param = lx.eutil.getRequestParam();
        var linkId = param.linkId;
        var dbConsole  = new Vue({
            el: "#sql_console",
            data:{
                sqlInput:"",
                sqlResult:[],
                sqlColumns:[]
            },
            methods:{
                onQuery:function(){
                    var me = this;
                  //  alert(me.sqlInput);
                    Dao.dbConsole({
                        linkId: linkId,
                        sql:me.sqlInput
                    },function(data){
                        if(data.result){
                            var items = data.items;
                            if(items.length>0){
                                var sample = items[0];
                                var columns=[];
                                for(var p in sample){
                                    columns.push(p);
                                }
                                me.sqlResult=items;
                                me.sqlColumns=columns;
                            }else{
                                me.sqlResult=[];
                                me.sqlColumns =[];
                            }
                        }else{
                            layer.msg("查询出错:"+data.msg);
                            me.sqlResult=[];
                            me.sqlColumns =[];
                        }
                    },function(error){
                        me.sqlResult=[];
                        me.sqlColumns =[];
                    });
                }
            }
        });
    });
})()