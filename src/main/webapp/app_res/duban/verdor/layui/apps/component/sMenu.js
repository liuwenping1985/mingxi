;
(function () {
    lx.mdefine("mMenu", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var default_h = lx.eutil.getGlodenHeight();
        var _default_options = {
            id: "mMenu" + util.uuid()

        }
        var util = lx.eutil;
        var $ = lx.$;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var mMenu = new Klass();
        mMenu.include(LxCmp);
        mMenu.include({
            init: function (options) {
                this.op_ = {};
                this.jq = $;
                util.copyProperties(this.op_, _default_options);
                if (options) {
                    util.copyProperties(this.op_, options);
                    if (this.op_.id == undefined) {
                        this.op_.id = "cell_" + util.uuid();
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
                if(!this.op_.className){
                    this.op_.className = "";
                }
                this.root = $("<div style='" + this.op_.style + "' class='layui-col-md" + this.size + " " + this.op_.className + "'></div>");
                this.body = $('<div id="' + this.id + '" class="lx-layout-cell" > </div>');

                if (this.op_.parent_id) {
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }
                this.root.append(this.body);
            }

        });
        apiSet.create = function (options) {
            return new mMenu(options);
        }

        apiSet.addMenu=function(){

        }
        apiSet.changeMenu=function(){

        }

        exports("mTab", apiSet);
    })



}());