
(function(){
    var exportObject = window;
    lx.use(["jquery","laypage","col"],function(){
        var params = lx.eutil.getRequestParam();

        var mode = params['mode']||"duban";

        var  baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode="+mode;

        exportObject.dbps_click=function(id){

            window.open("/seeyon/duban.do?method=showDbps&sid="+id+"&linkToType="+mode);

        };
        exportObject.db_click=function(id){

            window.open("/seeyon/duban.do?method=showDbps&sid="+id+"&linkToType="+mode);

        };
        exportObject.dbhb_click=function(id){
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=401681311018863784&data_id="+id+"&linkToType="+mode);
        };
        exportObject.dbbj_click=function(id){
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=3567084323371171881&data_id="+id+"&linkToType="+mode);
        };
        exportObject.dbyq_click=function(id){
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=2612221832994047529&data_id="+id+"&linkToType="+mode);
        };
        exportObject.dbfj_click=function(id){
            window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=3567084323371171881&data_id="+id+"&linkToType="+mode);
        };
        /**
         *  <tr>
         <td><i style="font-size: 30px; color: green" class="layui-icon layui-icon-flag"></i></td>
         <td>关于做好学习xxxx精神的督办任务</td>
         <td>领导布置</td>
         <td>重要</td>
         <td>test</td>
         <td>2周</td>
         <td>90%</td>
         <td>李四</td>
         <td>信息技术部</td>
         <td>50%</td>
         <td>张三</td>
         <td>
         <div class="layui-row layui-col-space10">
         <div class="layui-col-md3">
         <button type="button" class="layui-btn layui-btn-xs  layui-btn-warm">汇报</button>
         </div>

         <div class="layui-col-md3">
         <button type="button" class="layui-btn layui-btn-xs  layui-btn-warm">办结</button>
         </div>
         <div class="layui-col-md3">
         <button type="button" class="layui-btn layui-btn-xs  layui-btn-warm">延期</button>
         </div>
         <div class="layui-col-md3">
         <button type="button" class="layui-btn layui-btn-xs  layui-btn-warm">分解</button>
         </div>

         </div>
         </td>
         </tr>
         * @param container
         * @param item
         */
        function renderRow(container,item){
            var htmls = [];
            if(item.process==""){
                item.process="0";
            }
            if(item.mainWeight==""){
                item.mainWeight="--";
            }
            htmls.push("<tr>");
            htmls.push('<td><i style="font-size: 30px; color: green" class="layui-icon layui-icon-flag"></i></td>');
            htmls.push("<td>"+item.name+"</td>");
            htmls.push("<td>"+item.taskSource+"</td>");
            htmls.push("<td>"+item.taskLevel+"</td>");
            htmls.push("<td>"+new Date(item.endDate).format("yyyy-MM-dd hh:mm")+"</td>");
            htmls.push("<td>"+item.period+"</td>");
            htmls.push("<td>"+item.process+"%</td>");
            htmls.push("<td>"+item.mainLeader+"</td>");
            htmls.push("<td>"+item.mainDeptName+"</td>");
            htmls.push("<td>"+item.mainWeight+"%</td>");
            htmls.push("<td>"+item.supervisor+"</td>");
            if("leader"==mode){
                htmls.push('<td><div class="layui-row layui-col-space10"> <div class="layui-col-md12"> <button  onclick="dbps_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">督办批示</button> </div> </td>');
            }else if("duban"==mode){

                htmls.push('<td><div class="layui-row layui-col-space10"> <div class="layui-col-md12"> <button  onclick="db_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">查看</button> </div> </td>');
            }else if("xieban"==mode){
                htmls.push('<td><div class="layui-row layui-col-space10">');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbhb_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务汇报</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbbj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">办结申请</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbyq_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">延期申请</button></div>');
                // htmls.push('<div class="layui-col-md3"><button  onclick="dbfj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务分解</button></div>');
                htmls.push('</div> </td>');

            }else if("cengban"==mode){
                htmls.push('<td><div class="layui-row layui-col-space10">');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbhb_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务汇报</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbbj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">办结申请</button></div>');
                htmls.push('<div class="layui-col-md4"><button  onclick="dbyq_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">延期申请</button></div>');
               // htmls.push('<div class="layui-col-md3"><button  onclick="dbfj_click(\''+item.uuid+'\')" type="button" value="'+item.uuid+'" class="layui-btn layui-btn-xs  layui-btn-warm dbps">任务分解</button></div>');
                htmls.push('</div> </td>');

            }else{
                htmls.push("<td></td>");
            }
            htmls.push("</tr>");

            container.append(htmls.join(""));

        }
        var $ = lx.$;
        $("#myduban").click(function(){
            mode="duban";
            baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=duban";
            loadData();
        });
        $("#mycengban").click(function(){
            mode="cengban";
            baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=cengban";
            loadData();
        });
        $("#myxieban").click(function(){
            mode="xieban";
            baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=xieban";
            loadData();
        });

        function loadData(newList){
            lx.$.get(baseUri,{},function(data){
                var container= $("#nakedBody");
                if(!newList){
                    container.empty();
                }
                $.each(data,function(index,item){
                    renderRow(container,item);
                });
                var laypage = layui.laypage;

                laypage.render({
                    elem: 'paging'
                    ,count: data.length||1
                    ,theme: '#1E9FFF'
                });

            });

        }
        loadData();
        var hvt=$("#havingLeaderTask");
        if(hvt.val()=="true"){
            mode="leader";
            loadData(false);
        }

    });
})();