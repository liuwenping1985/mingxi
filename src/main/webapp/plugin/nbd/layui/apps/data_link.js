;
(function (exportObject) {
    var $ = exportObject.$;
    var data_link = {};
    function renderForm() {
            layui.use('form', function () {
            var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
            form.render();
        });
    }
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
            DataLink.DL = items;
            /**
             * <th>连接名称</th>
             <th>地址</th>
             <th>数据类型</th>
             <th>用户名</th>
             <th>数据库名</th>
             */
            var htmls = [];
            $("#a82other_data_link").html("");
            $("#other2a8_data_link").html("");
            $(items).each(function (index, item) {
                htmls.push("<tr class='data_link_row' >");
                htmls.push("<td><input type='checkbox' value='" + item.id + "' class='data_link_selected' /> </td>");
                htmls.push("<td>" + item.name + "</td>");
                htmls.push("<td>" + item.host + "</td>");
                htmls.push("<td>" + item.port + "</td>");

                htmls.push("<td>" + transDbType(item.dbType) + "</td>");
                htmls.push("<td>" + item.user + "</td>");
                htmls.push("<td>" + item.dataBaseName + "</td>");
                htmls.push("<td><button data_value='" + item.id + "' class='sql_query_btn layui-btn layui-btn-danger layui-btn-sm'>在线查询</button></td>");
                htmls.push("</tr>");
                $("#a82other_data_link").append("<option value='" + item.id + "'>" + item.extString1 + "</option>")
                $("#other2a8_data_link").append("<option value='" + item.id + "'>" + item.extString1 + "</option>")


            });
            tb.append(htmls.join(""));
            renderForm();
            $(".sql_query_btn").click(function(e){
                var target = e.target;
                var val = $(target).attr("data_value");
                //alert(val);
                $(".sql_data_link_id").val(val);
                var layer = layui.layer;
                 /* 再弹出添加界面 */
                 layer.open({
                     type: 1,
                     title: "在线查询(当前版本只支持select)",
                     skin: "myclass",
                     area: ["100%"],
                     content: $("#sql_console").html()
                 });
                 $(".sql_btn").click(function(e){
                     var tar_ = $(e.target).parent();
                     var data_link_id = tar_.find(".sql_data_link_id").val();
                     var sql = tar_.find(".sql_input").val();
                     var retContainer = tar_.find(".sql_result");
                     retContainer.html("");
                    Dao.dbConsole({
                        linkId: data_link_id,
                        sql:sql
                    },function(data){
                        if(data.result){
                            var items = data.items;
                            if(items.length>0){
                                var sampleCol = [];
                                var example = items[0];
                                for(var p in example){
                                    sampleCol.push(p);
                                }
                                var len = sampleCol.length;
                                var htmls =[];
                                htmls.push('<table class="layui-table">');
                                htmls.push('<colgroup>');
                                for(var k=0;k<len;k++){
                                  htmls.push("<col>");
                                }
                                htmls.push('</colgroup>');
                                htmls.push('<thead><tr>');
                                for (var k = 0; k < len; k++) {
                                    htmls.push("<th>" + sampleCol[k]+ "</th>");
                                }
                                htmls.push('</tr></thead>');
                                htmls.push('<tbody>');
                                $(items).each(function(index,item){
                                    htmls.push('<tr>');
                                    for(var m=0;m<len;m++){
                                          htmls.push('<td>' + item[sampleCol[m]] + '</td>');
                                    }
                                    htmls.push('</tr>');
                                });
                                htmls.push('</tbody>');
                                
                                htmls.push('</table>');
                                retContainer.html(htmls.join(""));
                            }else{
                                retContainer.html("没有结果");
                            }
                        }else{
                            layer.msg(data.msg);
                        }
                        

                    });

                 });
                
            });
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
                            var forms2 = $("#data_link_form select");
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
            //console.log(items);
            $(items).each(function (index, item) {
                var target = $(item);
                if (target.is(':checked')) {
                    var _id = target.val();

                    Dao.delete("data_link", {
                        id: _id
                    }, function (data2) {
                      //  console.log(data2);
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
                //console.log(ret);
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
                //console.log(ret);
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