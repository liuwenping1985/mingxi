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
            style: "min-height: 300px;max-height:800px",
            more_btn:"",
            new_btn:""
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
                if(this.op_.content){
                    this.append(this.op_.content);
                }
                if(this.op_.more_btn){

                    var m_t=$('<li class="'+this.op_.more_btn.class_name+'" style="float:right;color:black"></li>').append(this.op_.more_btn.html);

                    this.header.append(m_t)
                    if(this.op_.more_btn.click){
                        m_t.click(this.op_.more_btn.click);
                    }
                }
                if(this.op_.new_btn){
                    var n_b=$('<li class="'+this.op_.new_btn.class_name+'" style="float:right;color:black"></li>').append(this.op_.new_btn.html)
                    this.header.append(n_b);
                    if(this.op_.new_btn.click){
                        n_b.click(this.op_.new_btn.click);
                    }
                }
                if(this.op_.custom_btn){
                    var c_b=$('<li class="'+this.op_.custom_btn.class_name+'" style="float:right;color:black"></li>').append(this.op_.custom_btn.html)
                    this.header.append(c_b);
                    if(this.op_.custom_btn.click){
                        n_b.click(this.op_.custom_btn.click);
                    }
                }
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