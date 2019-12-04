;
(function (exportObject) {
    var $ = exportObject.$;
    var OTHER2A8 = {};
    function renderForm() {
        layui.use('form', function () {
            var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
            form.render();
        });
    }
    function transLink(linkId) {
        if (DataLink.DL) {
            for (var p = 0; p < DataLink.DL.length; p++) {
                if (linkId == DataLink.DL[p].sid) {
                    return DataLink.DL[p].name;
                }
            }
        }
        var logs = $("#a82other_affair_type option");
        //console.log(logs);
        return linkId;
    }
    function transExportType(exportType) {
        if ("mid_table" == exportType) {
            return "中间表";
        }
        if ("api" == exportType) {
            return "接口";
        }
        if ("custom" == exportType) {
            return "自定义";
        }
        if ("ws" == exportType) {
            return "WebService服务";
        }
        return exportType;
    }

    function transTriggerType(exportType) {
        if ("schedule" == exportType) {
            return "定时";
        }
        if ("api_receive" == exportType) {
            return "外部调用A8接口传入";
        }
        if ("api_get" == exportType) {
            return "A8调用外部接口获取";
        }
        return exportType;
    }

    function transTN(affairType) {
        return affairType;
    }
    function transTN2(affairType) {
        if("1"==affairType){
            return "是"
        }
        return "否";
    }
    OTHER2A8.renderList = function (ret) {

        var tb = $("#other2a8_list_body");
        tb.html("");
        var items = ret.items;
        // console.log(items);
        if (items && items.length > 0) {
            var htmls = [];
            $(items).each(function (index, item) {
                htmls.push("<tr class='other2a8_row' >");
                htmls.push("<td><input type='checkbox' value='" + item.sid + "' class='other2a8_selected' /> </td>");
                htmls.push("<td>" + decodeURIComponent(item.name) + "</td>");
                htmls.push("<td>" + transTriggerType(item.triggerType) + "</td>");
                htmls.push("<td>" + transLink(item.linkId)+ "</td>");

                htmls.push("<td>" + transExportType(item.exportType)+ "</td>");
                htmls.push("<td>" + transTN(item.affairType) + "</td>");
                htmls.push("<td>" + transTN2(item.triggerProcess) + "</td>");
                htmls.push("</tr>");

            });
            tb.append(htmls.join(""));
        }

    }
    $(document).ready(function () {
        function getFormSubmitData() {
            var str = $("#other2a8_form").serialize();
            var spp = str.split("&");
            var data = {};
            $(spp).each(function (index, item) {
                var tt = item.split("=");
                data[tt[0]] = tt[1];
            });
            return data;
        }
        $("#other2a8_btn_create").click(function () {
            $("#other2a8_update_submit").hide();
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
                                        if(name=="name"){
                                            $(item).val(decodeURIComponent(val_));
                                        }else{
                                            $(item).val(val_);
                                        }
                                        if(name=="id"){
                                            $(item).val(data["sid"]);
                                        }
                                    }
                                }
                            });
                            $(forms2).each(function (index, item) {
                                var name = $(item).attr("name");
                                if (name) {
                                    var val_ = data[name];
                                    if (val_ != undefined) {
                                        if(name=="linkId"){
                                            val_ = data["sLinkId"];

                                        }
                                        $(item).val(val_);
                                    }
                                }
                            });
                            renderFormTable(data.ftd.formTable);
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
        var form = layui.form;
        form.on('select(affairTypeSelect2)', function (data) {
            renderFieldMapping();

        });
        function renderFieldMapping() {
            var data = getFormSubmitData();
            Dao.getFormByTemplateNumber(data, function (ret) {
                var formTable = ret.data.formTable;
                renderFormTable(formTable);
            });

        }
        var trans_item = {
            'normal': "默认不转换",
            'id_2_org_code': "单位转编码",
            'id_2_org_name': "单位转名称",
            'id_2_dept_code': "部门转编码",
            'id_2_dept_name': "部门转名称",
            'id_2_person_code': "人员转编码",
            'id_2_person_name': "人员转名称",
            'enum_2_name': "枚举转名称",
            'enum_2_value': "枚举转枚举值",
            'file_2_downlaod': "附件转http下载"

        }
        function genTransferSelect(fieldName, defaultval) {
            var htmls = [];
            htmls.push("<select name='" + fieldName + "_classname' >");
            for (var p in trans_item) {
                var isSelected = false;
                if (defaultval == p) {
                    isSelected = true;
                }
                if (isSelected) {
                    htmls.push("<option value='" + p + "' selected>" + trans_item[p] + "</option>");
                } else {
                    htmls.push("<option value='" + p + "'>" + trans_item[p] + "</option>");
                }

            }

            htmls.push("</select>");
            return htmls.join("");
        }
        function genIsExport(fieldName, defaultval) {
            var htmls = [];
            htmls.push("<select name='" + fieldName + "_export' >");
            htmls.push("<option value='1'>是</option>");
            if (defaultval == "0") {
                htmls.push("<option value='0' selected>否</option>");
            } else {
                htmls.push("<option value='0'>否</option>");
            }

            htmls.push("</select>");
            return htmls.join("");
        }
        function renderFormTable(formTable) {
            $("#other2a8_field_list_body").html("");

            var fieldList = formTable.formFieldList;
            var htmls = [];
            $(fieldList).each(function (index, item) {
                htmls.push("<tr>");
                htmls.push("<td>" + item.name + "</td>");
                htmls.push("<td>" + item.display + "</td>");
                htmls.push("<td>" + item.fieldtype + "</td>");
                htmls.push("<td>主表(" + formTable.name + ")</td>");
                htmls.push("<td>" + genIsExport(item.name, item.export) + "</td>");
                htmls.push("<td>" + genTransferSelect(item.name, item.classname) + "</td>");
                htmls.push("<td><input name='" + item.name + "_ws' value='" + item.barcode + "' /></td>");
                htmls.push("</tr>")
            });
            var slt = formTable.slaveTableList;
            for (var t = 0; t < slt.length; t++) {
                var slvaeTable = slt[t];
                var slvaeTableFieldList = slvaeTable.formFieldList;
                $(slvaeTableFieldList).each(function (index, item) {
                    htmls.push("<tr style='color:rgb(253,99,71)'>");
                    htmls.push("<td>" + item.name + "</td>");
                    htmls.push("<td>" + item.display + "</td>");
                    htmls.push("<td>" + item.fieldtype + "</td>");
                    htmls.push("<td>子表(" + slvaeTable.name + ")</td>");
                    htmls.push("<td>" + genIsExport(item.name, item.export) + "</td>");
                    htmls.push("<td>" + genTransferSelect(item.name, item.classname) + "</td>");
                    htmls.push("<td><input name='" + item.name + "_ws' value='" + item.barcode + "' /></td>");
                    htmls.push("</tr>")
                });

            }
            $("#other2a8_field_list_body").html(htmls.join(""));
            renderForm();

        }
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
                //console.log(ret);
                Dao.getList("other2a8", function (data2) {
                    $(".nbd_content").hide();
                    $("#other2a8").show();
                    $("#other2a8_list_btn").click();
                    OTHER2A8.renderList(data2);
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
                    $("#other2a8").show();
                    OTHER2A8.renderList(data2);
                });
            });
            // console.log(str);

        });

    });

window.OTHER2A8 = OTHER2A8;

})(window);