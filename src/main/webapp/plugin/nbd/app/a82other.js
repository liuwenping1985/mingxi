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
            userName: "",
            "name": "",
            "affairType": "",
            "exportType": "",
            "exportUrl": "",
            "triggerType": "",
            "extString1": "",
            "extString2": "",
            "extString3":"",
            "extString4":"",
            "extString5":"",
            "sLinkId":"",
            "id": "",
            "linkItems":[],
            "pmmp":{"mmp":[
                {name:"1"},{name:"2"}
            ]}
        };
        if (param.id != undefined) {
            initData.mode = "update";
            initData.id = param.id;
        } else {
            initData.mode = "create";
          
        }
        var links = Dao.getCacheByKey("data_link").items;
        //vue的 v-for在这失灵了 草
        
        for(var p in links){
            var item = links[p];
            $("#a82other_data_link").append("<option value='"+item.sid+"'>"+item.name+"</option>");
        }
        
        var templates = Dao.getCacheByKey("TemplateNumber").items;
     //   console.log(templates);
        $(templates).each(function (index, item) {
            var nno = item.templete_number;
            if (nno) {
                $("#a82other_affair_type").append("<option value='" + nno + "'>" +
                    nno + "(" + item.subject + ")</option>");
            }
            layui.use('form', function () {
                var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
                form.render();
            });
        });
      
      //  initData.linkItems = links;
        // for(var kkk in links){
        //     initData.linkItems.push(links[kkk]); 
        // }
      //  console.log(initData);
        var app = new Vue({
            el: "#a82other_create",
            data: initData,
            methods: {
                goBack: function () {
                    window.location.href = "/seeyon/nbd.do?method=goPage&page=dataList&data_type=a82other&v=" + Math.random();
                },
                createSubmit: function () {
                    var me = this;
                    Dao.add("a82other", getFormSubmitData(), function (data) {
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
                    var dt= getFormSubmitData();
                    dt.id = param.id;
                    var me = this;
                    Dao.update("a82other", dt, function (data) {
                        if(data.result){
                            me.goBack();
                        }else{
                            layer.msg("更新数据失败");
                        }
                     
                    }, function (response) {
                       // me.goBack();
                        renderForm();
                    });
                }
            }
        });
       
        if (app.mode == "update") {
            //axios
            Dao.getDataById("a82other", {
                "id": app.id
            }, function (data) {
                app = lx.eutil.copyProperties(app,data.data);
               // console.log(data.data);
                //console.log(app);
                $("#a82other_affair_type").val(app.affairType);
                //renderForm();
                $("#a82other_data_link").val(app.sLinkId);
                //renderForm();
                renderFormTable(data.data.ftd.formTable);
                //renderForm();
                setTimeout(renderForm,100);
            }, function () {
                renderForm();
            });

        } else {
            renderForm();
        }
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
            // htmls.push("<option value='normal'>默认不转换</option>");
            // htmls.push("<option value='id_2_org_code'>单位转编码</option>");
            // htmls.push("<option value='id_2_org_name'>单位转名称</option>");
            // htmls.push("<option value='id_2_dept_code'>部门转编码</option>");
            // htmls.push("<option value='id_2_dept_name'>部门转名称</option>");
            // htmls.push("<option value='id_2_person_code'>人员转编码</option>");
            // htmls.push("<option value='id_2_person_name'>人员转名称</option>");
            // htmls.push("<option value='enum_2_name'>枚举转名称</option>");
            // htmls.push("<option value='enum_2_value'>枚举转枚举值</option>");
            // htmls.push("<option value='file_2_downlaod'>附件转http下载</option>");
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
            $("#a82other_field_list_body").html("");

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
            $("#a82other_field_list_body").html(htmls.join(""));
            renderForm();

        }

        function renderFieldMapping() {
            var data = getFormSubmitData();
            Dao.getFormByTemplateNumber(data, function (ret) {
                var formTable = ret.data.formTable;
                renderFormTable(formTable);
            });

        }
        layui.use('form', function () {
            var form = layui.form;
            form.on('select', function(data,data2){
               var filter =  $(data.elem).attr("lay-filter");
             //  console.log("select");
               app[filter]=data.value;
                if(filter=="affairType"){
                    renderFieldMapping();
                }
                renderForm();
                setTimeout(renderForm,3000);
               // console.log(data2);
            });
        });


    });


}())
