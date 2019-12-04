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
        var Klass = lx.getLxClass();
        var LxCmp = lx.LxComponent;
        var Panel = new Klass();
        Panel.include(LxCmp);
        Panel.include({
            init:function(options){
                 this.op_ = {};
                 this.jq = $;
                 util.copyProperties(this.op_, _default_options);
                 if (options) {
                     util.copyProperties(this.op_, options);
                     if (this.op_.id == undefined) {
                         this.op_.id = "panel_" + util.uuid();
                     }
                 }else{
                     this.op_.id = "panel_" + util.uuid();
                 }
                 this.id = this.op_.id;
                 this.html = "";
                 this.header = $("<div  class='" + this.op_.header_class + "'><spna style='color:#1E9FFF'>" + this.op_.title + "</span></div>");
                 this.body = $("<div class='" + this.op_.body_class + "'></div>");
                 if (this.op_.body_id) {
                     this.body.attr("id", this.op_.body_id);
                 }
                 this.root = $("<div id='"+this.id+"' style=" + this.op_.style + " class='" + this.op_.class + " "+this.className+"'></div>");
                 if (this.op_.parent_id) {
                     this.parent = $("#" + this.op_.parent_id);
                     this.parent.append(this.root);
                 }
                 this.root.append(this.header);
                 this.root.append(this.body);
            }
        });
        
        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new Panel(options);
        }
        exports("panel", apiSet);
    })



}());