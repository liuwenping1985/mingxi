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
        var data_link = Dao.getCacheByKey("data_link");
        /**
         * {"items":[{"affairType":"GYSDJB","createTime":1544070931000,"exportType":"mid_table","exportUrl":"","ftdId":-6591324436286910714,"id":2563283702975316259,"linkId":515598634434511623,"name":"yyy","sLinkId":"515598634434511623","sid":"2563283702975316259","status":0,"triggerType":"process_end","updateTime":1544070931000}],"msg":"","result":true}
         */
        var initData = {
            userName: ""
        };
        if (param.id != undefined) {
            initData.mode = "update";
        } else {
            initData.mode = "create";
            param.id = "";
        }
        initData = {
            "name": "",
            "affairType": "",
            "exportType": "",
            "exportUrl": "",
            "triggerType": "",
            "extString1": "",
            "extString2": "",
            "sLinkId":"",
            "id": param.id,
            "optionalData":{
                "linkItems":Dao.getCacheByKey("data_link").items,
                "templateNo":[]
            }
        };
        var app = new Vue({
            el: "#a82other_create",
            data: initData,
            computed:{
                "linkName":{
                    get:function  () {
						return "123";
					}
                }
            },
            methods: {
                goBack: function () {
                    window.location.href = "/seeyon/nbd.do?method=goPage&page=dataList&data_type=a82other&v=" + Math.random();
                },
                createSubmit: function () {
                    var me = this;
                    Dao.add("a82other", app.item, function (data) {
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
                    Dao.update("a82other", app.item, function (data) {
                        if(data.result){
                            me.goBack();
                        }else{
                            layer.msg("更新数据失败");
                        }
                     
                    }, function (response) {
                        renderForm();
                    });
                }
            }
        });
       
        if (app.mode == "update") {
            //axios
            Dao.getDataById("a82other", {
                "id": app.item.id
            }, function (data) {
                app.item = lx.eutil.copyProperties(app.item,data.data);
                renderForm();
            }, function () {
                renderForm();
            });

        } else {
            renderForm();
        }


    });


}())
