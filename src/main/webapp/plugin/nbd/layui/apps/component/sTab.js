;
(function () {



    lx.mdefine("sTab", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {
            id: "panel" + "_uuid",
            body_id: "",
            parent_id: "",
            title: "",
            root_class: "layui-tab layui-tab-card",
            header_class: "layui-this font_size_18",
            body_class: "layui-tab-content",
            style: "min-height: 300px;max-height:800px"
        }
        var util = lx.eutil;
        var $ = lx.$;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var Tab = new Klass();
        Tab.include(LxCmp);
        Tab.include({
            init: function (options) {
                this.op_ = {};
                this.jq = $;
                util.copyProperties(this.op_, _default_options);
                if (options) {
                    util.copyProperties(this.op_, options);
                    if (this.op_.id == undefined) {
                        this.op_.id = "stab_" + util.uuid();
                        this.id = this.op_.id;
                    }else{
                        this.id = options.id;
                    }
                }else{
                    this.id = "stab_" + util.uuid();
                }
                this.html = "";
                this.header = $('<ul class="layui-tab-title" ><li class = "' + this.op_.header_class + '" > <spna style="color: #1E9FFF">' + this.op_.title + '</span> </li></ul>');
                //<div class = "layui-tab-content" style = "height: 100px;" ><div class = "layui-tab-item layui-show" > 1 < /div> </div>
                this.body = $('<div class = "layui-tab-item layui-show" > </div> ');
                if (this.op_.body_id) {
                    this.body.attr("id", this.op_.body_id);
                }
                if (!this.op_.className){
                    this.className="";
                }else{
                    this.className = this.op_.className;
                }
                this.root = $("<div id='"+this.id+"' style='" + this.op_.style + "' class='" + this.op_.root_class + " "+this.className+"'></div>");
                if (this.op_.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }
                this.root.append(this.header);
                var _layerContent = $('<div class = "layui-tab-content "></div>');
                this.root.append(_layerContent);
                _layerContent.append(this.body);
            }
        });
        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new Tab(options);
        }
        exports("sTab", apiSet);
    })



}());