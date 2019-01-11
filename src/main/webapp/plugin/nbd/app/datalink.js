;
(function () {

    $(document).ready(function () {
        //垃圾的layui 不是双向绑定的垃圾
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
            "user": "",
            "password": "",
            "dataBaseName": "",
            "id": param.id
        };
        var app = new Vue({
            el: "#link_create",
            data: initData,
            methods: {
                goBack: function () {
                    window.location.href = "dataList.html?data_type=data_link&v=" + Math.random();
                },
                createSubmit: function () {
                    Dao.add("data_link", app.item, function (data) {
                        //console.log(data);
                        this.goBack();
                    }, function () {
                        renderForm();
                    });
                },
                updateSubmit: function () {
                    Dao.update("data_link", {
                        "id": app.item.id
                    }, function (data) {
                       this.goBack();
                    }, function (response) {
                        renderForm();
                    });
                },
                testConnection: function () {

                }
            }
        });
        //加载数据
        if (app.mode == "update") {
            //axios
            Dao.getDataById("data_link", {
                "id": app.item.id
            }, function (data) {
                //console.log(data);
                app.item = data.data;
                renderForm();
            }, function () {
                renderForm();
            });

        } else {
            renderForm();
        }


    });


}())
