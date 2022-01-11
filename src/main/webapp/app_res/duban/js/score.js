(function(){
    lx.use(["jquery","layer","laypage", "form", "element"],function(){

        var element = lx.element;
        var $ = lx.$;
        var layer = lx.layer;
        var getFormData=function(url){

            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for(var i = 0; i < strs.length; i ++) {
                    theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
                }
            }
            return theRequest;


        }
        $.get("/seeyon/duban.do?method=getDubanConfigItemDataList",function(ret){

            if(ret.items){
                var task_source=[];
                var task_level=[];
                var task_role=[];
                $.each(ret.items,function(index,item){
                    if(item.enum_group=="task_source"){
                        task_source.push(item);
                    }else if(item.enum_group=="task_level"){
                        task_level.push(item)
                    }else{

                        task_role.push(item);

                    }

                });
                task_source.sort(function(item1,item2){
                    return item1.sortnumber-item2.sortnumber;
                });
                task_level.sort(function(item1,item2){
                    return item1.sortnumber-item2.sortnumber;
                });
                task_role.sort(function(item1,item2){
                    return item1.id-item2.id;
                })
                $.each(task_source,function(index,item){

                    $("#task_source_body").append("<tr><td>"+item.showvalue+"</td><td><input name='"+item.sid+"' value='"+(item.set_value?item.set_value:"")+"'/></td></tr>")


                });
                $.each(task_level,function(index,item){
                    $("#task_level_body").append("<tr><td>"+item.showvalue+"</td><td><input name='"+item.sid+"' value='"+(item.set_value?item.set_value:"")+"'/></td></tr>")



                });
                $.each(task_role,function(index,item){
                    if(item.name=='xb_xishu'){
                        $("#task_role_body").append("<tr><td>协办</td><td><input name='"+item.name+"' value='"+(item.set_value?item.set_value:"")+"'/></td></tr>")
                    }else if(item.name=='cb_xishu'){
                        $("#task_role_body").append("<tr><td>主办</td><td><input name='"+item.name+"' value='"+(item.set_value?item.set_value:"")+"'/></td></tr>")
                    }



                });

            }






        });
        window.t_s_c_click=function(e){

            var seri = $("#task_submit_form").serialize()

            var params = getFormData("?"+seri);
            $.post("/seeyon/duban.do?method=saveDubanConfigItems",params,function(ret){
                if("exception exception"!=ret&&"ERROR"!=ret){

                    layer.alert("保存成功");


                }else{

                    layer.alert("保存失败");

                }

            })
        }




    });



})();