;
(function (exportObject) {
    var $ = exportObject.$;
    var data_link = {};

    function transDbType(dbType) {
        if (dbType == 0) {
            return "Mysql";
        }
        if (dbType == 1) {
            return "Oracle";
        }
        if (dbType == 2) {
            return "SQLServer";
        }
        return "Unknown"
    }
    data_link.renderList = function (ret) {

        var tb = $("#data_link_list_body");
        tb.html("");
        var items = ret.items;
        // console.log(items);
        if (items && items.length > 0) {
            /**
             * <th>连接名称</th>
             <th>地址</th>
             <th>数据类型</th>
             <th>用户名</th>
             <th>数据库名</th>
             */
            var htmls = [];
            $(items).each(function (index, item) {
                htmls.push("<tr class='data_link_row' >");
                htmls.push("<td><input type='checkbox' value='" + item.id + "' class='data_link_selected' /> </td>");
                htmls.push("<td>" + item.extString1 + "</td>");
                htmls.push("<td>" + item.host + "</td>");
                htmls.push("<td>" + item.extString2 + "</td>");

                htmls.push("<td>" + transDbType(item.dbType) + "</td>");
                htmls.push("<td>" + item.user + "</td>");
                htmls.push("<td>" + item.dataBaseName + "</td>");
                htmls.push("</tr>");

            });
            tb.append(htmls.join(""));

        }

    }
    $(document).ready(function () {
        $("#data_link_test").click(function () {
            var str = $("#data_link_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.testConnection(data, function (ret) {
                console.log(ret);
                if(ret.result){
                    layer.msg('测试成功');
                }else{
                    layer.msg('测试失败,请检查配置');
                }
            });


        });
        $("#data_link_create").click(function () {
            $("#data_link_update_submit").hide();
            $("#data_link_submit").show();
            goPage("link_create");

        });
        $("#data_link_update").click(function () {
            var items = $(".data_link_selected");
            $(items).each(function (index, item) {
                var target = $(item);
                if (target.is(':checked')) {
                    var id_ = target.val();
                    Dao.getDataById("data_link", {
                        id: id_
                    }, function (data2) {
                        if (data2.result) {
                            var data = data2.data;
                            var forms = $("#data_link_form input");
                            $(forms).each(function (index, item) {
                                var name = $(item).attr("name");
                                if (name) {
                                    var val_ = data[name];
                                    if (val_ != undefined) {
                                        $(item).val(val_);
                                    }
                                }
                            });
                            goPage("link_create");
                            $("#data_link_update_submit").show();
                            $("#data_link_submit").hide();
                        } else {
                            alert("ERROR:" + data2.msg);
                        }
                    });
                }
            });
        });
        $("#data_link_delete").click(function () {
            //show("link_create");
            var items = $(".data_link_selected");
            console.log(items);
            $(items).each(function (index, item) {
                var target = $(item);
                if (target.is(':checked')) {
                    var _id = target.val();

                    Dao.delete("data_link", {
                        id: _id
                    }, function (data2) {
                        console.log(data2);
                        if (!data2.result) {
                            alert("删除失败");
                        } else {
                            Dao.getList("data_link", function (data2) {
                                $(".nbd_content").hide();
                                $("#link_config").show();
                                DataLink.renderList(data2);
                            });
                        }
                    });
                }
            });


        });
        $("#data_link_return").click(function () {

            goPage("link_config");
        });
        $("#data_link_update_submit").click(function () {
            $("#data_link_update_submit").show();
            $("#data_link_submit").hide();
            var str = $("#data_link_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.update("data_link", data, function (ret) {
                console.log(ret);
                Dao.getList("data_link", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
        });
        $("#data_link_submit").click(function () {

            var str = $("#data_link_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.add("data_link", data, function (ret) {
                console.log(ret);
                Dao.getList("data_link", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
            // console.log(str);

        });


    });

    exportObject.DataLink = data_link;
})(window);