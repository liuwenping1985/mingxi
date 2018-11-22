;
(function () {
    lx.mdefine("mTab", ['jquery','element'], function (exports) {
        var element = layui.element;
        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {
            id: "mTab" + "_uuid",
            body_id: "",
            parent_id: "",
            title: "",
            size: 4,
            root_class: "layui-tab layui-tab-card",
            head_class: "layui-tab-title",
            body_class: "layui-tab-content",
            root_style: "min-height:" + default_h + "px",
            head_style: "",
            body_style: ""
        }
        var util = lx.eutil;
        var $ = lx.$;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var mTab = new Klass();
        mTab.include(LxCmp);
        mTab.include({
            init: function (options) {
                this.op_ = {};
                this.jq = $;
                util.copyProperties(this.op_, _default_options);
                if (options) {
                    util.copyProperties(this.op_, options);
                    if (this.op_.id == undefined) {
                        this.op_.id = "mTab_" + util.uuid();
                    }
                }
                this.id = this.op_.id;
                this.html = "";
                if (!this.op_.size) {
                    this.size = 4;
                } else {
                    this.size = this.op_.size;
                }
                if (!this.op_.style){
                    this.op_.style="";
                }

                this.root = $("<div style='" + this.op_.root_style + "' class='"+this.op_.root_class+"' lay-filter='"+this.id+"'></div>");
                this.head = $("<ul style='" + this.op_.head_style + "' class='"+this.op_.head_class+"'></ul>");
                this.body = $('<div id="' + this.id + '" style="'+this.op_.body_style+'"  class="'+this.op_.body_class+'" > </div>');

                if (this.op_.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }
                this.root.append(this.head);
                this.root.append(this.body);
                element.on('tab('+this.id+')', function(){

                });
                if(this.op_.tabs){
                    var me =this;
                    $(this.op_.tabs).each(function(index,item){
                        me.addTab(item);
                    })
                }
            },
            addTab:function(tab){

                var name = tab.name;
                var checked = tab.checked;
                var id = "li"+util.uuid();
                var content = tab.content;
                var contentType=  tab.contentType;
               
                if(!content){
                    contentType="html";
                    content="";
                }
                // if(tab.contentType){
                //     var ct = tab.contentType;
                //     if(ct=="cmp"){

                //     }
                // }

                var headClass = "font_size_18"
                var bodyClass= "layui-tab-item";
                var tempHead =  $('<li class="font_size_18" lay-id="li'+util.uuid()+'">'+name+'</li>');
                var tempBody = $('<div class="layui-tab-item"></div>');
                if(checked){
                    this.head.find("li").removeClass("layui-this");
                    this.body.find("div").removeClass("layui-show");
                    tempHead.addClass("layui-this");
                    tempBody.addClass("layui-show");
                }
                
                this.head.append(tempHead);
                
                this.body.append(tempBody);
                if(!contentType){
                    contentType="html";
                    
                }else{
                    if(contentType=="html"){
                        tempBody.html(content);
                    
                    }else if(contentType=="cmp"){
                        tempBody.append(content.root);
                    }


                }



            },
            changeTab:function(){

            }

        });
        apiSet.create = function (options) {
            return new mTab(options);
        }


        exports("mTab", apiSet);
    })



}());