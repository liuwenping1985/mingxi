;
(function () {
    lx.mdefine("mixed", ['jquery', 'element', "row", "col"], function (exports) {
        var element = layui.element;
        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var Row = lx.row;
        var Col = lx.col;
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {
            id: "mTab" + "_uuid",
            body_id: "",
            parent_id: "",
            title: "",
            size: 12,
            mode: "col",
            root_class: "",
            head_class: "",
            body_class: "",
            root_style: "",
            head_style: "",
            body_style: ""
        }
        var util = lx.eutil;
        var $ = lx.$;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var mixed = new Klass();
        mixed.include(LxCmp);
        mixed.include({
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
                    this.size = 12;
                } else {
                    this.size = this.op_.size;
                }
                if (!this.op_.style) {
                    this.op_.style = "";
                }

                this.root = $("<div id='" + this.id + "' style='" + this.op_.root_style + "' class='layui-col-md" + this.size + " " + this.op_.root_class + "'></div>");
                this.head = $("<div style='" + this.op_.head_style + "' class='" + this.op_.head_class + "'></div>");
                this.root.append(this.head);
                var body_row = Row.create({
                    parentCmp: this.root
                });
                this.body = body_row;

                if (this.op_.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }



                if (this.op_.cmps) {
                    var me = this;
                    $(this.op_.cmps).each(function (index, item) {
                        me.addCmp(item);
                    })
                }
            },
            addCmp: function (cmp) {


                var id = "mixed" + util.uuid();
                var content = cmp.content;
             
                var body = this.getBody(true,cmp);
                //body.append(content);
                if (!content) {
                    contentType = "html";
                    content = "";
                }
                body.append(content);
            },
            getBody: function (isnewAdd,cmp) {
                if (isnewAdd) {
                    var mode = this.op_.mode;
                    if (mode == "col") {
                        if(!cmp.size){
                            cmp.size=4;
                        }
                        cmp.parentCmp=this.root;
                        var col = Col.create(cmp);
                        this.body.append(col);
                        return col;
                    }
                    if (mode == "row") {
                        cmp.parentCmp = this.root;
                        if(!cmp.size){
                            cmp.size=12;
                        }
                        var body_row = Row.create(cmp);
                        this.body = body_row;
                        return body_row;
                    }
                } else {
                    if (this.body) {
                        return this.body;
                    } else {
                        return this.root;
                    }
                }

            }

        });
        apiSet.create = function (options) {
            return new mixed(options);
        }


        exports("mixed", apiSet);
    })



}());