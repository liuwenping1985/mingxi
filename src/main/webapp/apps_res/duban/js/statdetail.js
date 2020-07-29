(function(){
    lx.use(["jquery","layer","laypage", "form","laydate", "element"],function() {
        var element = lx.element,laydate = lx.laydate;
        var $ = lx.$;
        var layer = lx.layer;
        var getFormData = function (url) {
            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for (var i = 0; i < strs.length; i++) {
                    theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
                }
            }
            return theRequest;
        }
        window.onclick_td=function(){


        }
        function renderTable(data){
            var htmls = [];
            $(data).each(function(index,item){


                if(item.process==""){
                    item.process="0";
                }
                if(item.mainWeight==""){
                    item.mainWeight="--";
                }
                htmls.push("<tr>");
                htmls.push('<td class="td_no_padding"><i style="font-size: 24px; color: '+item.taskLight+'" class="layui-icon layui-icon-flag"></i></td>');
                htmls.push("<td class='td_no_padding'>"+item.name+"</td>");
                htmls.push("<td class='td_no_padding'>"+item.taskSource+"</td>");
                htmls.push("<td class='td_no_padding'>"+item.taskLevel+"</td>");
                htmls.push("<td class='td_no_padding'>"+new Date(item.endDate).format("yyyy-MM-dd hh:mm")+"</td>");
                htmls.push("<td class='td_no_padding'>"+item.period+"</td>");
                htmls.push("<td class='td_no_padding'>"+item.process+"%</td>");
                htmls.push("<td class='td_no_padding'>"+item.mainLeader+"</td>");
                htmls.push("<td class='td_no_padding'>"+item.mainDeptName+"</td>");
                htmls.push("<td>"+(item.score?item.score:"0")+"</td>");

                //最新进展
                var t_s = item["taskDescription"];
                var t_s_a_v="";
                try {
                    var str2 = t_s.replace(/\r\n/g, "$ojbk$");
                    str2 = str2.replace(/\n/g, "$ojbk$");
                    var t_s_a = str2.split("$ojbk$");
                    t_s_a_v = t_s_a[t_s_a.length-1];
                }catch(e){

                }

                htmls.push("<td class='td_no_padding' style='width:120px'>"+t_s_a_v+"</td>");

                htmls.push("<td class='td_no_padding'>"+item.supervisor+"</td>");
                htmls.push("</tr>");

            })
            $("#nakedBodyMore").append(htmls.join(""));


        }
        var params = getFormData(window.location.href+"");
        $.get("/seeyon/duban.do?method=getStatDataDetail&taskIds="+params['taskIds'], function (ret) {
            $("#nakedBodyMore").html("");
            if(ret.code=="200"){
                renderTable(ret.items);
            }

        });


    });

})();