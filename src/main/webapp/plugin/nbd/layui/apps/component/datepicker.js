/**
 * < div class = "layui-inline"
 id = "test-n4" > < /div>
 */
;
(function () {

    lx.mdefine("datepicker", ['jquery', "laydate"], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var laydate = lx.laydate;
        var util = lx.eutil;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var _default_options = {

            id: "panel" + "_uuid",
            theme: "#393D49",
            parent_id: ""


        }
        var DatePicker = new Klass();
        DatePicker.include(LxCmp);
        DatePicker.include({
            init: function (options) {
                this.jq = $;
                this.op = options;
                if (!this.op.id) {
                    this.id = "datepicker_" + util.uuid();
                } else {
                    this.id = this.op.id;
                }
                this.root = $("<div id='" + this.id + "' class='layui-inline " + options.className + "'></div>");

                if (options.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }else if(options.parent){
                    this.parent = options.parent;
                    this.parent.append(this.root);
                }
                if (options.data) {
                    this.render(options.data);
                } else {
                    this.render();
                }

            },
            render: function (data) {
               
                if (!data) {
                    laydate.render({
                        elem: '#'+this.id,
                        theme: '#393D49',
                        value:data,
                        position: 'static'
                    });
                } else {
                    laydate.render({
                        elem: '#'+this.id,
                        theme: '#393D49',
                         position: 'static'
                    });
                }
                //自定义颜色


            }
        });

        apiSet.create = function (options) {

            return new DatePicker(options);
        }

        apiSet.hello = function () {
            alert("hello");
        }



        exports("datepicker", apiSet);
    })



}());