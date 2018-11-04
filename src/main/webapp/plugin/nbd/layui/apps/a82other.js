;
(function (exportObject) {
    var $ = exportObject.$;
    var A82OTHER = {};
    A82OTHER.renderList = function (ret) {

        var tb = $("#a82other_list_body");
        tb.html("");
        var items = ret.items;
        // console.log(items);
        if (items && items.length > 0) {
            var htmls = [];
            $(items).each(function (index, item) {
                htmls.push("<tr class='a82other_row' >");
                htmls.push("<td><input type='checkbox' value='" + item.id + "' class='a82other_selected' /> </td>");
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
        function getFormSubmitData(){
            var str = $("#a82other_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            return data;
        }
        $("#a82other_btn_create").click(function () {
            $("#a82otherupdate_submit").hide();
            $("#a82other_submit").show();
            goPage("a82other_create");

        });
        $("#a82other_btn_update").click(function () {
            var items = $(".a82other_selected");
            $(items).each(function (index, item) {
                var target = $(item);
                if (target.is(':checked')) {
                    var id_ = target.val();
                    Dao.getDataById("a82other", {
                        id: id_
                    }, function (data2) {
                        if (data2.result) {
                            var data = data2.data;
                            var forms = $("#a82other_form input");
                            $(forms).each(function (index, item) {
                                var name = $(item).attr("name");
                                if (name) {
                                    var val_ = data[name];
                                    if (val_ != undefined) {
                                        $(item).val(val_);
                                    }
                                }
                            });
                            goPage("a82other_create");
                            $("#a82other_update_submit").show();
                            $("#a82other_submit").hide();
                        } else {
                            alert("ERROR:" + data2.msg);
                        }
                    });
                }
            });

        });
        $("#a82other_btn_delete").click(function () {
            $("#a82other_update_submit").hide();
            $("#a82other_submit").show();


        });
        $("#a82other_return").click(function () {
            goPage("a82other");
        });
        $("#a82other_update_submit").click(function () {
            $("#a82other_update_submit").show();
            $("#a82other_submit").hide();
            var str = $("#a82other_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.update("a82other", data, function (ret) {
                console.log(ret);
                Dao.getList("a82other", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
        });
        $("#a82other_affair_type").change(function(e){
                var data = getFormSubmitData();
                Dao.getFormByTemplateNumber(data, function (data) {
                        console.log(data);

                });

        });

        $("#a82other_submit").click(function () {

            var str = $("#a82other_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            // console.log(data);
            Dao.add("a82other", data, function (ret) {
                console.log(ret);
                Dao.getList("a82other", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
            // console.log(str);

        });

    });



})(window);