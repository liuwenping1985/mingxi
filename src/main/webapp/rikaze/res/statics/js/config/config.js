;(function(){

    $(document).ready(function(){
        var access_token = $.getCookie('access_token')
        var mac_key = $.getCookie('mac_key')
        if(!access_token||!mac_key||access_token=='null'||mac_key=='null'){
            window.location.href="/admin/login.html"
            return;
        }
        $(".nav-link").click(function(e){
            $(".nav-link").removeClass("active");
            $("#rel_panel").hide();
            $("#cmp_panel").hide();
            $(e.target).addClass("active")
            $("#"+$(e.target).attr("data-ref")).show()
        })
        $("#admin_logout").click(function(){
            $.setCookie("access_token",null,new Date().toGMTString());
            $.setCookie("mac_key",null,new Date().toGMTString());
            $.delCookie("access_token");
            $.delCookie("mac_key");
            window.location.href="/admin/login.html"
        })
        var APP_MODEL=[
            {
                name:"id",
                label:"应用标识(系统自动生成):",
                table_show:true,
                form_show:false,
                type:"text",
                required:false,
                ui_class:"td_w30"
            },{
                name:"name",
                label:"应用名称",
                table_show:true,
                form_show:true,
                type:"text",
                required:true,
                ui_class:"td_w50"
            }
        ];
        var app_binding_select_model = REPORT_ENV.getReportApi("app_list");
        app_binding_select_model.callback=function(data,pid,e_data){
            if(data&&data.items){
                var data_child = data.items;
                var parent = $("#"+pid);
                var htmls=[];
                $(data_child).each(function(index,item){
                    if(item.name== e_data){
                        htmls.push("<option selected value='"+item.id+"'>"+item.name+"</option>")
                    }else{
                        htmls.push("<option  value='"+item.id+"'>"+item.name+"</option>")
                    }
                });
                parent.html(htmls.join(""))
            }

        }
        var BINDING_MODEL=[
            {
                name:"id",
                label:"id",
                table_show:false,
                form_show:false,
                type:"text",
                required:false
            },{
                name:"app_key",
                label:"App_Key",
                table_show:true,
                form_show:true,
                type:"text",
                required:true,
                read_only:"MODIFY"
            },{
                name:"app_name",
                label:"应用名称",
                table_show:true,
                form_show:false,
                type:"text",
                required:true
            },{
                name:"app_id",
                label:"应用名称",
                table_show:false,
                form_show:true,
                type:"select",
                required:true,
                opt_select_data_type:"remote",
                opt_select_data:app_binding_select_model
            },{
                name:"platform",
                label:"平台",
                table_show:true,
                form_show:true,
                type:"select",
                required:true,
                opt_select_data_type:"local",
                opt_select_data:[{
                    key:"IOS",
                    value:"IOS"
                },{
                    key:"Android",
                    value:"Android"
                }]
            }
        ];
        var COMPONENT_MODEL=[
            {
                name:"id",
                label:"id",
                table_show:false,
                form_show:false,
                type:"text",
                required:false
            },{
                name:"biz_name",
                label:"组件标识",
                table_show:true,
                form_show:true,
                type:"text",
                required:true
            },{
                name:"name",
                label:"组件名称",
                table_show:true,
                form_show:true,
                type:"text",
                required:true
            },{
                name:"packages",
                label:"包名",
                table_show:true,
                form_show:true,
                type:"textarea",
                required:true
            },{
                name:"create_time",
                label:"创建时间",
                table_show:false,
                form_show:false,
                type:"text",
                required:true
            }
        ];
        var MODEL_REPO={
            APP:APP_MODEL,
            BINDING:BINDING_MODEL,
            COMPONENT:COMPONENT_MODEL
        }
        var MODEL_TITLE={
            ADD_APP:"创建应用",
            ADD_BINDING:"新增关联",
            ADD_COMPONENT:"新增组件",
            MODIFY_APP:"修改应用信息",
            MODIFY_BINDING:"修改关联信息",
            MODIFY_COMPONENT:"修改组件信息"
        }
        var MODEL_ACTION={
            APP_ADD:REPORT_ENV.getReportApi("create_app"),
            BINDING_ADD:REPORT_ENV.getReportApi("add_binding"),
            COMPONENT_ADD:REPORT_ENV.getReportApi("add_cmp"),
            APP_MODIFY:REPORT_ENV.getReportApi("modify_app"),
            BINDING_MODIFY:REPORT_ENV.getReportApi("modify_binding"),
            COMPONENT_MODIFY:REPORT_ENV.getReportApi("modify_cmp"),
            APP_DELETE:REPORT_ENV.getReportApi("delete_app"),
            BINDING_DELETE:REPORT_ENV.getReportApi("delete_binding"),
            COMPONENT_DELETE:REPORT_ENV.getReportApi("delete_cmp"),
        }
        var common_callback=function(pId,data,type){

            if(data&&data.items){
                var render_model = MODEL_REPO[type];
                var items = data.items;
                items.sort(function(data1,data2){
                    return data2.create_time-data1.create_time;
                })
                var htmls=[];

                $(items).each(function(index,item){
                    htmls.push("<tr>")
                    $(render_model).each(function(i,rowModel){
                        if(rowModel.table_show){
                            htmls.push("<td class='"+rowModel.ui_class+"' ><p class='overflow_default'>"+item[rowModel.name]+"</p></td>");
                        }
                    });
                    //if(type=="COMPONENT"){
                        var json_data = encodeURIComponent(JSON.stringify(item))
                        htmls.push("<td class='td_w20'   style='cursor:pointer'><a data-toggle='modal' data-operate='"+type+"' data-mode='MODIFY' data-json_data='"+json_data+"' data-target='#opModalWindow' onclick='doModify()'>修改</a><a style='margin-left:15px' onclick='doDelete(\""+item.id+"\",\""+type+"\",\""+item.biz_name+"\")'>删除</a></td>")
                    // }else{
                    //     htmls.push("<td class='td_w20' onclick='doDelete(\""+item.id+"\",\""+type+"\")'  style='cursor:pointer'><a>删除</a></td>")
                    // }

                    htmls.push("</tr>")
                })
                $(pId).html(htmls.join(","));

            }
        }
        var LOADER_MODEL={
            "APP_LOADER":function(){
                var app = REPORT_ENV.getReportApi("app_list");
                app.callback=function(data){
                    common_callback("#app_container",data,"APP");
                }
                return app;
            },
            BINDING_LOADER:function(){
                var binding = REPORT_ENV.getReportApi("binding_list");
                binding.callback=function(data){
                    common_callback("#binding_container",data,"BINDING");
                }
                return binding;
            },
            COMPONENT_LOADER:function(){
                var cmp = REPORT_ENV.getReportApi("cmp_list");
                cmp.callback=function(data){
                    common_callback("#cmp_container",data,"COMPONENT");
                }
                return cmp;
            }
        }
        $('#confirmComponent').click(function(){
            var cmp = REPORT_ENV.getReportApi("confirm_cmp");
            cmp.callback=function(data){
                data.message='操作成功'
                common_error_operate(data)
            }
            cmp.error_callback=function(data){
                if(data==''){
                    $("#error_msg_body").html('操作成功');
                    $("#error_msg_win").modal("show");
                }else{
                    var msg="",code=data.code;
                    if('QC_REPORT/QC_ADAPTER_EXISTED' == code){
                        msg="操作失败,应用已经存在绑定关系!"
                    }else{
                        msg = data.message?data.message:"操作失败";
                    }
                    $("#error_msg_body").html(msg);
                    $("#error_msg_win").modal("show");

                }

            }
            load(cmp)
        })
        $('#opModalWindow').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var recipient = button.data('operate');
            var mode = button.data('mode');
            var json_data = button.data('json_data')
            if(json_data==null||json_data==undefined){
                mode="ADD"
                json_data={}
            }

            if(mode=="MODIFY"){
                json_data = $.parseJSON(decodeURIComponent(json_data))
            }
            var model = MODEL_REPO[recipient];
            $("#opModalForm").html('');
            if(model==null){
                return
            }
            var htmls=["<input type='hidden' name='OP_TYPE' value='"+recipient+"' />","<input type='hidden' name='MODE' value='"+mode+"' />"];
            if(mode=="MODIFY"){
                htmls.push("<input type='hidden' name='id' value='"+json_data.id+"' />")
            }
            var additional_task=[];
            $(model).each(function(index,item){
                if(mode=="ADD"){
                    json_data[item["name"]]=""
                }
                if(!item.form_show){
                    return
                }
                htmls.push('<div class="form-group">');
                htmls.push('<label for="'+item["name"]+'" class="form-control-label">'+item["label"]+'</label>');
                if(item.type == "textarea"){
                    var htmlAry = json_data[item["name"]];
                    if(typeof(htmlAry)=='object'&&htmlAry.length>0){
                        htmlAry = htmlAry.join("\n")
                    }
                    if(mode=="MODIFY"&&item["read_only"]){
                        htmls.push('<textarea rows="10" readonly class="form-control" name="'+item["name"]+'" >'+htmlAry+'</textarea>');
                    }else{
                        htmls.push('<textarea rows="10" type="text" class="form-control" name="'+item["name"]+'" >'+htmlAry+'</textarea>');
                    }
                }else if(item.type=="select"){
                    if(item.opt_select_data_type=="local"){
                        htmls.push('<select  class="form-control" name="'+item["name"]+'">');
                        $(item.opt_select_data).each(function(index,n){
                            if(n.value==json_data[item["name"]]){
                                htmls.push('<option selected value="'+n.value+'">'+n.key+'</option>');
                            }else{
                                htmls.push('<option value="'+n.value+'">'+n.key+'</option>');
                            }

                        });
                        htmls.push('</select>');
                    }else if(item.opt_select_data_type=="remote"){
                        var pId = "tmp_select_node_"+new Date().getTime();
                        additional_task.push({
                            method:item.opt_select_data.method,
                            url:item.opt_select_data.url,
                            callback:item.opt_select_data.callback,
                            pId:pId,
                            mode:mode,
                            e_data:json_data[item["name"]]
                        });
                        htmls.push('<select id="'+pId+'" class="form-control" name="'+item["name"]+'"></select>');
                    }
                }else {
                    if(mode=="MODIFY"&&item["read_only"]){

                        htmls.push('<input type="text" readonly class="form-control" name="'+item["name"]+'" value="'+json_data[item["name"]]+'"/>');

                    }else{
                        htmls.push('<input type="text" class="form-control" name="'+item["name"]+'" value="'+json_data[item["name"]]+'"/>');
                    }

                }

                htmls.push('</div>');
            })
            $("#opModalForm").html(htmls.join(""));
            var modal = $(this);
            modal.find('.modal-title').text(MODEL_TITLE[mode+"_"+recipient])
            $(additional_task).each(function(index,item){
                $.ajaxJSON(item.method,item.url,function(data){
                    item.callback.call(this,data,item.pId,item.e_data);
                })
            })

        })
        function getSubmitData(){
            var params={},op_type="",mode="",id="";
            var formData = decodeURIComponent($("#opModalForm").serialize());
            formData= formData.split("&");
            if(formData.length>0){
                $(formData).each(function(index,item){
                    var pms = item.split("=");
                    if(pms.length==2){
                        if(pms[0]=="MODE"){
                            mode = pms[1];
                            return
                        }
                        if(pms[0]=="OP_TYPE"){
                            op_type = pms[1];
                            return
                        }
                        if(pms[0]=="id"){
                            id = pms[1];
                            return
                        }
                        params[pms[0]]=pms[1];
                    }
                })
            }

            return {
                op_type:op_type,
                mode:mode,
                params:params,
                id:id
            }

        }
        function common_error_operate(e){
            if(e==""){
                $("#opModalWindow").modal("hide")
            }else{
                var msg="",code=e.code;
                if('QC_REPORT/QC_ADAPTER_EXISTED' == code){
                    msg="操作失败,应用已经存在绑定关系!"
                }else{
                    msg = e.message?e.message:"操作失败";
                }
                $("#error_msg_body").html(msg);
                $("#opModalWindow").modal("hide");
                $("#error_msg_win").modal("show");

            }
        }
        $("#common_save_btn").click(function(e){
            //MODEL_ACTION
            var submitData = getSubmitData();
           // console.log(submitData)
            var action = MODEL_ACTION[submitData.op_type+"_"+submitData.mode]
            if(submitData.mode=="MODIFY"){
                var re_action={};
                re_action.method = action.method;
                re_action.url = action.url.replace("{id}",submitData.id);
                action = re_action;
            }
            if(submitData.params&&submitData.params['packages']){
                submitData.params['packages'] = submitData.params['packages'].split('\n');
            }
            $.ajaxJSON(action.method,action.url,submitData.params,function(){
                var loader = LOADER_MODEL[submitData.op_type+"_LOADER"]()
                if(submitData.op_type=="APP"){
                    load(LOADER_MODEL["BINDING_LOADER"]());
                }
                load(loader)
                $("#common_dismiss_btn").click()
            },common_error_operate);
        })
        function load(loader){
            //console.log(loader)
            var error_callback = common_error_operate;
            if(loader.error_callback){
                error_callback = loader.error_callback;
            }
            $.ajaxJSON(loader.method,loader.url,loader.callback,error_callback);
        }
        $("#delete_win_ok").click(function(){
            var id = $("#delete_win_ok").attr("data-id");
            var type = $("#delete_win_ok").attr("data-type");
            //console.log(id+","+type);
            var action = MODEL_ACTION[type+"_DELETE"];
            var real_action={};
            real_action.url=action.url.replace("{id}",id);
            real_action.method=action.method
            //console.log(real_action.url)
            real_action.callback=function(){
                $("#delete_confirm_win").modal("hide")
                load(LOADER_MODEL[type+"_LOADER"]())
            }
            real_action.error_callback=function(e){
                if(e==""){
                    $("#delete_confirm_win").modal("hide")
                    load(LOADER_MODEL[type+"_LOADER"]())
                }else{
                    //console.log(e)
                    // e = $.parseJSON(e);
                    var code = e.code,msg="";
                    if(code=="QC_REPORT/QC_ADAPTER_EXISTED"){
                      msg="删除失败，已存在绑定关系!"
                    }else if(code=="QC_REPORT/QC_COMPONENT_EXISTED"){
                      var name = $("#delete_win_ok").attr("data-name");
                      msg= name + "组件已被设置为发生组件\\责任组件,不能删除！";
                    }else{
                      msg = e.message?e.message:"操作失败";
                    }
                    $("#error_msg_body").html(msg);
                    $("#delete_confirm_win").modal("hide");
                    $("#error_msg_win").modal("show");

                }
            };
            load(real_action);
        })
        window.doDelete=function(id,type,name){

            $("#delete_win_ok").attr("data-id",id);
            $("#delete_win_ok").attr("data-type",type);
            $("#delete_win_ok").attr("data-name",name);
            $("#delete_confirm_win").modal("show");
        }
        window.doModify=function(){
            console.log(window.event)
        }
        load(LOADER_MODEL["COMPONENT_LOADER"]());
        load(LOADER_MODEL["APP_LOADER"]());
        load(LOADER_MODEL["BINDING_LOADER"]());

    })


}())
