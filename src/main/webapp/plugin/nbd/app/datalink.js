;
(function () {

    $(document).ready(function () {
        //坑爹的layui机制 form的UI变更需要render
        function renderForm() {
            layui.use('form', function () {
                var form = layui.form;
                form.render();
            });
        }

        var param = lx.eutil.getRequestParam();
        //alert(param.id);
        var initData = {
            userName: ""
        };
        if (param.id != undefined) {
            initData.mode = "update";
        } else {
            initData.mode = "create";
            param.id = "";
        }
        initData.item = {
            "name": "",
            "host": "",
            "port": "",
            "dbType": "",
            "userName": "",
            "password": "",
            "dataBaseName": "",
            "id": param.id
        };
        var app = new Vue({
            el: "#link_create",
            data: initData,
            methods: {
                goBack: function () {
                    window.location.href = "/seeyon/nbd.do?method=goPage&page=dataList&data_type=data_link&v=" + Math.random();
                },
                createSubmit: function () {
                    var me = this;
                    Dao.add("data_link", app.item, function (data) {
                        //console.log(data);
                        if(data.result){
                            me.goBack();
                        }else{
                            layer.msg('添加失败');
                        }
                       
                    }, function () {
                        renderForm();
                    });
                },
                updateSubmit: function () {
                    app.item.id=""+app.item.sid;
                    app.item.sid=null;
                    var me = this;
                    app.item.dbType = this.getDbType();
                    Dao.update("data_link", app.item, function (data) {
                        if(data.result){
                            me.goBack();
                        }else{
                            layer.msg("更新数据失败");
                        }
                     
                    }, function (response) {
                        renderForm();
                    });
                },
                testConnection: function () {
                    app.item.dbType = this.getDbType();
                    Dao.testConnection(app.item, function (ret) {
                        if(ret.result){
                            layer.msg('测试成功');
                        }else{
                            layer.msg('测试失败,请检查配置');
                        }
                    });
                },
                getDbType:function(){
                    //layui的坑，不支持双向绑定实时获取值
                    var str = $("#data_link_form").serialize();
                    var spp = str.split("&");
                    var data = {};
                    $(spp).each(function (index, item) {
                        var tt = item.split("=");
                        data[tt[0]] = tt[1];
                    });
                   return data['dbType'];

                }
            }
        });
       
        if (app.mode == "update") {
            //axios
            Dao.getDataById("data_link", {
                "id": app.item.id
            }, function (data) {
                app.item = data.data;
                $("#dbType").val(app.item.dbType)
                renderForm();
            }, function () {
                renderForm();
            });

        } else {
            renderForm();
        }


    });


}())
