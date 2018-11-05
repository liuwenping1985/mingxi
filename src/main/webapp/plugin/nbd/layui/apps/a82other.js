;
(function (exportObject) {
    var $ = exportObject.$;
    var A82OTHER = {};

    function renderForm() {
        layui.use('form', function () {
            var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
            form.render();
        });
    }
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
        function getFormSubmitData() {
            var str = $("#a82other_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            return data;
        }
        function genTransferSelect(){
            var htmls=[];
            htmls.push("<select name='classname' >");
            htmls.push("<option value=''>默认不转换</option>");
            htmls.push("<option value='id_2_org'>单位转编码</option>");
            htmls.push("<option value='id_2_dept'>单位转编码</option>");
            htmls.push("<option value='enum_2_org'>枚举转名称</option>");  
            htmls.push("</select>");
            return htmls.join("");
        }
        function renderFieldMapping() {
            var data = getFormSubmitData();
            Dao.getFormByTemplateNumber(data, function (ret) {
                var formTable = ret.data.formTable;
                $("#a82other_form_table").html("主表名称:" + formTable.name);
                $("#a82other_field_list_body").html("");
                
                var fieldList = formTable.formFieldList;
                var htmls=[];
                $(fieldList).each(function(index,item){
                    htmls.push("<tr>");
                     htmls.push("<td>"+item.name+"</td>");
                     htmls.push("<td>"+item.display+"</td>");
                     htmls.push("<td>" + item.fieldtype + "</td>");
                     htmls.push("<td>" + genTransferSelect ()+ "</td>");
                     htmls.push("<td><input name='ws' /></td>");
                     
                     htmls.push("</tr>")
                   
                });
                $("#a82other_field_list_body").html(htmls.join(""));
                
            });

        }
        $("#a82other_btn_create").click(function () {
            $("#a82otherupdate_submit").hide();
            $("#a82other_submit").show();
            goPage("a82other_create");
            renderFieldMapping();

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
                // console.log(ret);
                Dao.getList("a82other", function (data2) {
                    $(".nbd_content").hide();
                    $("#link_config").show();
                    DataLink.renderList(data2);
                });
            });
        });
        var form = layui.form;
        form.on('select(affairTypeSelect)', function (data) {
            renderFieldMapping();

        });
        // $("#a82other_affair_type").change(function (e) {


        // });

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