;(function(){
    lx.use(["jquery","element","table"],function(){
        var $ = lx.$,ele = lx.element,table=lx.table;
        var params = lx.eutil.getRequestParam();
        var mock = true;

        var mode = params['mode']||"duban";

        var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode="+mode;
        var image_base_uri ="/seeyon/apps_res/duban/verdor/layui/images/";
        if(mock){
            baseUri = "leader.json";
            image_base_uri="../../app_res/duban/verdor/layui/images/";
        }

        table.render({
            elem: '#test'
            ,url:baseUri
            ,toolbar: '#toolbarDemo'
            ,text: {
                none: '暂无相关数据'
            },
            limit:10,
            parseData: function(res){
               var limiting = $(".layui-laypage-limits > select").val();
               if(!limiting){
                   limiting = 10;
               }
               limiting = parseInt(limiting);
               var pp = $(".layui-laypage-curr").children("em");
               var page =1;
               pp.each(function(index,item){
                   if($(item).html()){
                       page =  $(item).html();
                   }
               });
                var count = res.length;
                var start = (page-1)*limiting;
                var end = start+limiting;

                if(end>count){
                    end = count;
                }
                return {
                    "code": "0", //解析接口状态
                    "msg": "", //解析提示文本
                    "count": res.length, //解析数据长度
                    "data": res.slice(start,end) //解析数据列表
                };
               // return res;
            }
            ,done: function(res, curr, count){

            }
            ,defaultToolbar: [ {
                title: 'tips'
                ,layEvent: 'searchAll'
                ,icon: 'layui-icon-search'
            },'filter', 'exports', 'print']
            ,title: '督办事项'
            ,cols: [[
                {field:'taskLight', title:'状态', width:60, fixed: 'left', templet: function(item){
                    if ("正常推进" == item.taskLight) {
                        item.taskLight = image_base_uri+"green.jpeg";
                    } else if ("低风险" == item.taskLight) {
                        item.taskLight = image_base_uri+"blue.png";
                    } else if ("有风险但可控" == item.taskLight) {
                        item.taskLight = image_base_uri+"orange.png";
                    } else if ("风险不可控，不能按期完成" == item.taskLight) {
                        item.taskLight =image_base_uri+ "red.jpeg";
                    } else {
                        item.taskLight = image_base_uri+"red.jpeg";
                    }
                    return '<img width="24px" height="24px" src="' + item.taskLight + '">';
                }}
                ,{field:'name', title:'任务名称', width:200, fixed: 'left'}
                ,{field:'taskSource', title:'任务来源', width:103, sort: true}
                ,{field:'taskLevel', title:'任务级别', width:103, sort: true}
                ,{field:'endDate', title:'办理时限', width:110, sort: true,templet:function(item){
                    return new Date(item.endDate).format("yyyy-MM-dd");
                }}
                ,{field:'period', title:'周期', sort: true,width:80}
                ,{field:'process', title:'进度',width:80,sort: true,templet:function(item){
                    return item.process+"%";
                }}
                ,{field:'mainLeader', title:'责任领导', width:80, sort: true}
                ,{field:'mainDeptName', title:'承办部门', width:103}
                ,{field:'score', title:'分数', width:80, sort: true,templet:function(item){
                    var score = item.kgScore + item.zgScore + item.totoalScore;
                    return (isNaN(score) ? 0 : score);
                }}
                ,{field:'taskDescription', title:'最新汇报',templet:function(item){
                    var t_s = item["taskDescription"];
                    var t_s_a_v = "";
                    try {
                        var str2 = t_s.replace(/\r\n/g, "$ojbk$");
                        str2 = str2.replace(/\n/g, "$ojbk$");
                        var t_s_a = str2.split("$ojbk$");
                        t_s_a_v = t_s_a[0];
                        return t_s_a_v;
                    } catch (e) {

                    }
                    return t_s;
                }}
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo'}
            ]]
            ,page: true
        });

        //头工具栏事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'getCheckData':
                    var data = checkStatus.data;
                    layer.alert(JSON.stringify(data));
                    break;
                case 'getCheckLength':
                    var data = checkStatus.data;
                    layer.msg('选中了：'+ data.length + ' 个');
                    break;
                case 'isAll':
                    layer.msg(checkStatus.isAll ? '全选': '未全选');
                    break;
                case 'searchAll':
                    window.parent.Base.openSearch({name:"duban"});
                    break;

            };
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'del'){
                layer.confirm('真的删除行么', function(index){
                    obj.del();
                    layer.close(index);
                });
            } else if(obj.event === 'edit'){
                layer.prompt({
                    formType: 2
                    ,value: data.email
                }, function(value, index){
                    obj.update({
                        email: value
                    });
                    layer.close(index);
                });
            }
        });


    });

})();
