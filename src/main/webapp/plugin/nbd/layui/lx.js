;
(function () {
    /**
     * 对layui的继承和扩展 es6有的浏览器支持不好 ，用es5吧 艹
     */

    var layex = layui;
    var $ = layui.jquery || layui.$ || layui.jQuery;
    layex.mdefine = function (mName, requireMods, mmethod) {
        layex.define(requireMods, function (exports) {
            if (mmethod) {
                exports.mName = mName;
                mmethod(exports);
            }
        });
    }
    var eutil = {};
    Date.prototype.format = function(format)
    {
        if(!format){
            format="yyyy-MM-dd hh:mm:ss";
        }
        var o = {
            "M+" : this.getMonth()+1, //month
            "d+" : this.getDate(),    //day
            "h+" : this.getHours(),   //hour
            "m+" : this.getMinutes(), //minute
            "s+" : this.getSeconds(), //second
            "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
            "S" : this.getMilliseconds() //millisecond
        }
        if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
            (this.getFullYear()+"").substr(4 - RegExp.$1.length));
        for(var k in o)if(new RegExp("("+ k +")").test(format))
            format = format.replace(RegExp.$1,
                RegExp.$1.length==1 ? o[k] :
                    ("00"+ o[k]).substr((""+ o[k]).length));
        return format;
    };
    layex.eutil = eutil;
    layex.eutil.copyProperties = function (source, dest) {
        if (!source) {
            source = {};
        }
        if (!dest) {
            dest = {};
        }
        for (var p in dest) {
            source[p] = dest[p];
        }

        return source;
    }
    var __index = 0
    layex.eutil.uuid = function () {
        return __index++;
    }
    layex.eutil.getDimension = function () {
        return {
            height: window.screen.availHeight,
            width: window.screen.availWidth
        }
    }
    layex.eutil.getGlodenHeight = function (divide) {
        if (!divide) {
            divide = 3;
        }
        var h = window.screen.availHeight;
        var h2 =  ((h * 0.9) / 3) * 0.618;
        if(h2<280){
            h2=280;
        }
        return h2;
    }
    layex.eutil.getRequestParam=function(){
        var url = location.search||window.location.href; //获取url中"?"符后的字串
        var theRequest = new Object();
        if (url.indexOf("?") != -1) {
            var str = url.substr(1);
            strs = str.split("&");
            for(var i = 0; i < strs.length; i ++) {
                theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
            }
        }
        return theRequest;


    }
    var Class_ = function () {
        var klass = function () {
            this.init.apply(this, arguments);
        };
        klass.prototype.init = function () {};
        // 定义 prototype 的别名
        klass.fn = klass.prototype;
        // 定义类的别名
        klass.fn.parent = klass;
        // 给类添加属性
        klass.extend = function (obj) {
            var extended = obj.extended;
            for (var i in obj) {
                klass[i] = obj[i];
            }
            if (extended) extended(klass)
        };
        // 给实例添加属性
        klass.include = function (obj) {
            var included = obj.included;
            for (var i in obj) {
                klass.fn[i] = obj[i];
            }
            if (included) included(klass)
        };
        return klass;
    };

    var LxComponent = new Class_();
    LxComponent.extend({
        isLxCmp: function () {
            return true;
        },
        append: function (child) {
            if (typeof (child) == "string") {
                if ($) {
                    this.getBody().append($(child));
                } else {
                    if (this.jq) {
                        this.getBody().append(this.jq(child));
                    }
                }

            }
            if (typeof (child) == "object") {
                if (child.isLxCmp) {
                    if (child.isLxCmp()) {
                        this.getBody().append(child.root);
                    }
                } else {
                    this.getBody().append(child);
                }
            }
        },
        hello: function () {
            //检查是否加载ok
            alert("hello");
        },
        init: function () {
            alert("init方法必须覆盖");
        },
        getId: function () {
            return this.id;
        },
        getRoot: function () {
            return this.root;
        },
        getBody: function () {
            if (this.body) {
                return this.body;
            } else {
                return this.root;
            }
        },
        getHeader: function () {
            if (this.header) {
                return this.header;
            } else {
                return this.getBody();
            }
        }

    });
    layex.getLxClass = function () {
        return Class_;
    };
    layex.LxComponent = LxComponent;

    window.layex = layex;
    window.lx = layex;
    layex.config({
        base: '/seeyon/apps_res/nbd/layui/apps/component/' //你存放新模块的目录，注意，不是layui的模块目录
    });

}());