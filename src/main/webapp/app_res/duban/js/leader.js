;(function(){
    lx.use(["jquery","element","table"],function(){
        var $ = lx.$,ele = lx.element,table=lx.table;
        var params = lx.eutil.getRequestParam();
        var mock = lx.eutil.isMock();

        var mode = params['mode']||"duban";

        var baseUri = window.DB_DAO.getUrlByStateAndMode(mode,"RUNNING")
        var image_base_uri ="/seeyon/apps_res/duban/verdor/layui/images/";
        if(mock){

            image_base_uri="../../app_res/duban/vendor/layui/images/";
        }
        window.fireQuery=function(stateParam,queryParams){
            var obj = {
                event:stateParam.state
            };

            fireInTheLand(obj,queryParams);

        }
        function getCurrentLimiting(){
            var limiting = $(".layui-laypage-limits > select").val();
            if(!limiting){
                limiting = 10;
            }
            limiting = parseInt(limiting);
            return limiting;
        }
        function filterByKeyAndValue(res,key,val,old){
            var addType="new";
            var newAry=[];
            if(old){
                addType="setAdd";
                newAry = old;
            }else{
                newAry=[];
            }
            $(res).each(function(index,item){
                var isadd=false;
                var itemVal = item[key];
                if(itemVal&&(""+itemVal).indexOf(val)>=0){
                    isadd = true;
                }
                if(isadd){
                    if("setAdd"==addType){
                        var isDuplicated = false;
                        $(newAry).each(function(i,it){
                            if(it.taskId==item.taskId){
                                isDuplicated = true;
                            }
                        });
                        if(!isDuplicated){
                            newAry.push(item);
                        }
                    }else{
                        newAry.push(item);
                    }
                }

            });
            return newAry;
        }
        function filterData(res){
            var start_res = [];
            $(res).each(function(index,item){
                start_res.push(item);
            });
            if(currentParams["condition_1_input"]!=""){
                start_res =  filterByKeyAndValue(start_res,currentParams["condition_1"],currentParams["condition_1_input"],null);
            }
            if(currentParams["condition_2_input"]!=""){
                //condition_join_1
                if(currentParams["condition_join_1"]=="1"){
                    start_res = filterByKeyAndValue(start_res,currentParams["condition_2"],currentParams["condition_2_input"],null);
                }else{
                    start_res = filterByKeyAndValue(res,currentParams["condition_2"],currentParams["condition_2_input"],start_res);
                }

            }
            if(currentParams["condition_3_input"]!=""){
                if(currentParams["condition_join_2"]=="1"){
                    start_res = filterByKeyAndValue(start_res,currentParams["condition_3"],currentParams["condition_3_input"],null);
                }else{
                    start_res = filterByKeyAndValue(res,currentParams["condition_3"],currentParams["condition_3_input"],start_res);
                }
            }
            res = start_res;
            return res;
        }
        function paseData_(res){

            var limiting = $(".layui-laypage-limits > select").val();

            if(!limiting){
                limiting = 10;
            }
            if(currentParams){

                res = filterData(res);

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

        var duban_table = table.render({
            elem: '#test'
            ,url:baseUri
            ,toolbar: '#toolbarDemo'
            ,text: {
                none: '暂无相关数据'
            },
            limit:10,
            parseData: paseData_
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
                    } else if ("风险不可控,不能按期完成" == item.taskLight) {
                        item.taskLight =image_base_uri+ "red.jpeg";
                    } else {
                        item.taskLight = image_base_uri+"green.jpeg";
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
                        var tag_=0;
                        while((!t_s_a_v||t_s_a_v=="")&&(tag_<t_s_a.length)){
                            t_s_a_v = t_s_a[(++tag_)];
                        }
                        if(!t_s_a_v){
                            t_s_a_v="";
                        }
                        return t_s_a_v;
                    } catch (e) {

                    }
                    return t_s;
                }}
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo'}
            ]]
            ,page: true
        });
        function changeBtnStyle(eventName){


            $(".xad_filter_btn").each(function(index,item){
                $(item).removeClass("layui-btn-normal");
            });

            // $(".xad_filter_btn").removeClass("layui-btn-normal");
            //
            // console.log($("button[lay-event="+eventName+"]"));

            $("button[lay-event="+eventName+"]").addClass("layui-btn-normal");
        }
        //头工具栏事件
        var currentState="getRunningTask";
        var currentParams=null;
        function fireInTheLand(obj,params){
            if(params){
                currentParams = params;
            }else{
                currentParams = null;
            }
            switch(obj.event){
                case 'getRunningTask':

                    duban_table.reload({
                        url:window.DB_DAO.getUrlByStateAndMode(mode,"RUNNING"),
                        parseData: paseData_,
                        limit:getCurrentLimiting(),
                        page:true,
                        done: function(res, curr, count){
                            changeBtnStyle("getRunningTask");
                            currentState="getRunningTask";
                        }
                    });

                    break;
                case 'getApprovingTask':
                    //console.log(obj);
                    changeBtnStyle("getApprovingTask");

                    break;
                case 'getFinishedTask':
                    changeBtnStyle("getFinishedTask");
                    duban_table.reload({
                        url:window.DB_DAO.getUrlByStateAndMode(mode,"DONE"),
                        parseData: paseData_,
                        limit:getCurrentLimiting(),
                        page:true,
                        done: function(res, curr, count){
                            changeBtnStyle("getFinishedTask");
                            currentState="getFinishedTask";
                        }
                    })
                    break;
                case 'getAllTask':
                    changeBtnStyle("getAllTask");
                    duban_table.reload({
                        url:window.DB_DAO.getUrlByStateAndMode(mode,"ALL"),
                        parseData: paseData_,
                        limit:getCurrentLimiting(),
                        page:true,
                        done: function(res, curr, count){
                            changeBtnStyle("getAllTask");
                            currentState="getAllTask";
                        }
                    })
                    break;
                case 'searchAll':
                    window.parent.Base.openSearch({mode:"cengban",state: currentState});
                    break;

            };
        }
        table.on('toolbar(test)', function(obj){

            fireInTheLand(obj);
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            //console.log(obj)
            if(obj.event === 'pishi'){
                window.parent.Base.openLeaderOpinion(obj.data);
            } else if(obj.event === 'view'){

                window.parent.Base.openView(obj.data.uuid,mode);

            }
        });


    });

})();
