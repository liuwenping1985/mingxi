;
(function () {



    lx.mdefine("s-tab", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        /**
         * < div class = "layui-tab layui-tab-card" >
             <
             ul class = "layui-tab-title" >
             <
             li class = "layui-this font_size_18" > 通知公告 < /li>

             <
             /ul> 
             <div class = "layui-tab-content" style = "height: 100px;" ><div class = "layui-tab-item layui-show" > 1 < /div> </div> 
             
             
             <
             /div>
         */
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {

            id: "panel" + "_uuid",
            body_id: "",
            parent_id: "",
            title: "",
            root_class: "layui-tab layui-tab-card",
            header_class: "layui-this font_size_18",
            body_class: "layui-tab-content",
            style: "min-height:"+default_h+"px"
        }
        var util = lx.eutil;
        var $ = lx.$;

        function Tab(options) {
            this.op_ = {};
            util.copyProperties(this.op_, _default_options);
            if (options) {
                util.copyProperties(this.op_, options);
                if (this.op_.id == undefined) {
                    this.op_.id = "panel_" + util.uuid();
                }
            }
            this.html = "";
            this.header = $('<ul class="layui-tab-title" ><li class = "'+this.op_.header_class+'" > '+this.op_.title+' </li></ul>');
            //<div class = "layui-tab-content" style = "height: 100px;" ><div class = "layui-tab-item layui-show" > 1 < /div> </div>
            this.body = $('<div class = "layui-tab-item layui-show" > </div> ');
            if (this.op_.body_id) {
                this.body.attr("id", this.op_.body_id);
            }
            this.root = $("<div style='" + this.op_.style + "' class='" + this.op_.root_class + "'></div>");
            if (this.op_.parent_id) {
                this.parent = $("#" + this.op_.parent_id);
                this.parent.append(this.root);
            }
            this.root.append(this.header);
            var _layerContent = $('<div class = "layui-tab-content "></div>');
             this.root.append(_layerContent);
             _layerContent.append(this.body);
           

        }
        var prop = Tab.prototype;
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
        prop.setTitle = function (title) {
            this.header.html(title);
        }
        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new Tab(options);
        }



        exports("s-tab", apiSet);
    })



}());