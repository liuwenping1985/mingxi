;
(function () {



    lx.mdefine("lunbo", ['jquery', "carousel"], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var _default_options = {
            id: "lunbo" + "_uuid",
            arrow: 'always',
            interval:3000,
            anim:"fade"
        }
        var carousel = lx.carousel;
        var util = lx.eutil;
        var $ = lx.$;
        var Klass = lx.getLxClass();
        var LxCmp = lx.LxComponent;
        var Lunbo = new Klass();
        Lunbo.include(LxCmp);
        Lunbo.include({
            init: function (options) {
                this.op_ = {};
                this.jq = $;
                util.copyProperties(this.op_, _default_options);
                if (options) {
                    util.copyProperties(this.op_, options);
                    if (this.op_.id == undefined) {
                        this.op_.id = "lunbo_" + util.uuid();
                    }
                }
                this.op = this.op_;
                this.html = "";
                this.root = $("<div style='margin-top:8px' id='" + this.op_.id + "' class='layui-carousel lx-layout-cell layui-col-md" + this.op_.size + "'></div>");
                this.op_.elem="#"+this.op_.id;
                this.body = $("<div carousel-item=''> </div>");
                this.root.append(this.body);
                 if (this.op_.parent_id) {
                     this.parent = $("#" + this.op_.parent_id);
                     this.parent.append(this.root);
                 }
                 if(!this.op_.data_prop){

                     this.op_.data_prop={
                         "img":"imgUrl"
                     };


                }
                if (this.op_.data) {
                    var items = this.op_.data;
                    this.render(items);
                } else {
                    if (this.op_.data_url) {
                        var me = this;
                        $.ajax({
                            url: this.op_.data_url,
                            async: true, //同步方式发送请求，true为异步发送
                            type: "GET",
                            dataType: "json",
                            success: function (data) {
                                if (data.items) {
                                    me.render(data.items);
                                }
                            },
                            error: function (res) {

                            }
                        })
                    }
                }

            },
            render: function (data) {
                var htmls=[];
                for (var p = 0; p < data.length; p++) {
                    var item= data[p];
                    //console.log(this.op.data_prop["img"]);
                    if(!this.op_.img_size) {
                        this.op_.img_size="4";
                    }
                    htmls.push("<div><img height='" + (this.op_.height)+ "' width='" + this.op_.width + "' src = '" + item[this.op.data_prop["img"]] + "'> </div>");
                }
                this.body.append($(htmls.join("")));
                carousel.render(this.op_);
                var me = this;
                 carousel.on('change('+this.op_.id+')', function (res) {
                     if(me.op_.change){
                         me.op_.change.apply(this, arguments);
                     }
                 });

            }
        });

        apiSet.hello = function () {
            alert("hello");
        }
        apiSet.create = function (options) {
            return new Lunbo(options);
        }
        exports("lunbo", apiSet);
    })



}());