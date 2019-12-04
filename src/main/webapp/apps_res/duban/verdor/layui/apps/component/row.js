;
(function () {
    lx.mdefine("row", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {
            body_id: "",
            parent_id: "",
            style: "min-height:" + default_h + "px"
        }
        var util = lx.eutil;
        var $ = lx.$;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var Row = new Klass();
        Row.include(LxCmp);
        Row.include({
            init:function (options) {
                this.op_ = {};
                this.jq = $;
                util.copyProperties(this.op_, _default_options);
                if (options) {
                    util.copyProperties(this.op_, options);
                    if (this.op_.id == undefined) {
                        this.id = "row_" + util.uuid();
                       
                    }else{
                        this.id = this.op_.id;
                    }
                }else{
                    this.id = "row_" + util.uuid();
                }
                var style = options.style;
                if(!style){
                    style="";
                }
                this.html = "";
                this.root = $("<div style='" + style + "' id='" + this.id + "' class='layui-row'></div>");
                if (this.op_.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }
                if(this.op_.parentCmp){
                    this.parent =this.op_.parentCmp;
                    this.parent.append(this.root);
                }
            }
        });
        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new Row(options);
        }
        exports("row", apiSet);
    })



}());