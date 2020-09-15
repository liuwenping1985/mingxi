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
        laydate.render({
            elem: '#start'
        });
        laydate.render({
            elem: '#end'
        });
        window.onRecordClick=function(taskIds,deptId){

            window.open("/seeyon/duban.do?method=goPage&page=statDetail&taskIds="+taskIds);
        }
        function renderTable(data){
            var htmls = [];

            $(data).each(function(index,item){
                htmls.push("<tr onclick='onRecordClick(\""+item.taskParams+"\",\""+item.deptId+"\")' style='cursor:pointer'>");
                htmls.push("<td><a>"+item.deptName+"</a></td>");
                htmls.push("<td><a>"+item.renwuliang+"</a></td>");
                htmls.push("<td><a>"+item.taskCount+"("+item.taskATypeCount+")"+"</a></td>");
                htmls.push("<td><a>"+item.wancheng+"("+((parseFloat(item.wancheng)*100)/parseFloat(item.taskCount)).toFixed(2)+"%)"+"</a></td>");
                htmls.push("<td><a>"+item.taskScore+"</a></td>");
                htmls.push("</tr>");
            })
            $("#dataBody").append(htmls.join(""));


        }
        $.get("/seeyon/duban.do?method=getStatData", function (ret) {
            $("#dataBody").html("");
            if(ret.code=="200"){
                renderTable(ret.items);
            }

        });
        $("#okBtn").click(function(){
            $.post("/seeyon/duban.do?method=getStatData",{
                start_date:$("#start").val(),
                end_date:$("#end").val()
            },function(ret){
                $("#dataBody").html("");
                if(ret.code=="200"){
                    renderTable(ret.items);
                }
            })
        })

    });

})();