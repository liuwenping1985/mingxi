;
(function (exportObject) {
    var $ = exportObject.$;
    var OTHER2A8 = {};
    OTHER2A8.renderList = function (ret) {

        var tb = $("#other2a8_list_body");
        tb.html("");
        var items = ret.items;
        // console.log(items);
        if (items && items.length > 0) {
            var htmls = [];
            $(items).each(function (index, item) {
                htmls.push("<tr class='other2a8_row' >");
                htmls.push("<td><input type='checkbox' value='" + item.id + "' class='other2a8_selected' /> </td>");
                htmls.push("<td>" + item.extString1 + "</td>");
                htmls.push("<td>" + item.host + "</td>");
                htmls.push("<td>" + item.extString2 + "</td>");

                htmls.push("<td>" + item.dbType + "</td>");
                htmls.push("<td>" + item.user + "</td>");
                htmls.push("<td>" + item.dataBaseName + "</td>");
                htmls.push("</tr>");

            });
            tb.append(htmls.join(""));
        }

    }
    $(document).ready(function () {
        $("#other2a8_btn_create").click(function () {
            $("#other2a8update_submit").hide();
            $("#other2a8_submit").show();
            goPage("other2a8_create");

        });
        $("#other2a8_btn_update").click(function () {
            var items = $(".other2a8_selected");
            $(items).each(function (index, item) {
                var target = $(item);
                if (target.is(':checked')) {
                    var id_ = target.val();
                    Dao.getDataById("other2a8", {
                        id: id_
                    }, function (data2) {
                        if (data2.result) {
                            var data = data2.data;
                            var forms = $("#other2a8_form input");
                            var forms2 = $("#other2a8_form select");
                            $(forms).each(function (index, item) {
                                var name = $(item).attr("name");
                                if (name) {
                                    var val_ = data[name];
                                    if (val_ != undefined) {
                                        $(item).val(val_);
                                    }
                                }
                            });
                            $(forms2).each(function (index, item) {
                                var name = $(item).attr("name");
                                if (name) {
                                    var val_ = data[name];
                                    if (val_ != undefined) {
                                        $(item).val(val_);
                                    }
                                }
                            });
                            renderForm();
                            goPage("other2a8_create");
                            $("#other2a8_update_submit").show();
                            $("#other2a8_submit").hide();
                        } else {
                            alert("ERROR:" + data2.msg);
                        }
                    });
                }
            });

        });
        $("#other2a8_btn_delete").click(function () {
            $("#other2a8_update_submit").hide();
            $("#other2a8_submit").show();


        });
        $("#other2a8_return").click(function () {
            goPage("other2a8");
        });
        $("#other2a8_update_submit").click(function () {
            $("#other2a8_update_submit").show();
            $("#other2a8_submit").hide();
            var str = $("#other2a8_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.update("other2a8", data, function (ret) {
                console.log(ret);
                Dao.getList("other2a8", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
        });
        $("#other2a8_submit").click(function () {

            var str = $("#other2a8_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.add("other2a8", data, function (ret) {
                console.log(ret);
                Dao.getList("other2a8", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
            // console.log(str);

        });

    });

window.OTHER2A8 = OTHER2A8;

})(window);