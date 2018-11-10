;
(function () {



    lx.mdefine("panel", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var _default_options = {

            id: "panel" + "_uuid",
            body_id: "",
            parent_id: "",
            title: "",
            class: "layui-card",
            header_class: "layui-card-header",
            body_class: "layui-card-body",
            style: "",


        }
        var util = lx.eutil;
        var $ = lx.$;

        function panel(options) {
            this.op_ = {};
            util.copyProperties(this.op_, _default_options);
            if (options) {
                util.copyProperties(this.op_, options);
                if (this.op_.id == undefined) {
                    this.op_.id = "panel_" + util.uuid();
                }
            }
            this.html = "";
            this.header = $("<div  class='" + this.op_.header_class + "'>" + this.op_.title + "</div>");
            this.body = $("<div class='" + this.op_.body_class + "'></div>");
            if (this.op_.body_id) {
                this.body.attr("id", this.op_.body_id);
            }
            this.root = $("<div style=" + this.op_.style + " class='" + this.op_.class + "'></div>");
            if (this.op_.parent_id) {
                this.parent = $("#" + this.op_.parent_id);
                this.parent.append(this.root);
            }
            this.root.append(this.header);
            this.root.append(this.body);

        }
        var prop = panel.prototype;
        prop.append = function (child) {
            if (typeof (child) == "string") {
                this.body.append($(child));
            }
            if (typeof (child) == "object") {
                this.body.append(child);
            }
        }
        prop.emptyBody = function (data) {
           this.body.html("");
        }
        prop.setTitle=function(title){
            this.header.html(title);
        }
        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new panel(options);
        }



        exports("panel", apiSet);
    })



}());