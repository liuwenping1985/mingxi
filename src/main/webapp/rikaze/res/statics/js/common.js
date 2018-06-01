/**
 * Created by yql on 2015/7/14.
 */
/**
 * @namespace COMMON
 */
window["COMMON"] =  {};
COMMON.string = COMMON.string || {};
COMMON.date = COMMON.date || {};
COMMON.loading = COMMON.loading || {};
/**
 * 对模板进行赋值
 */
COMMON.incRender = function(template, data, opts) {
    var h = "",
        len = "";
    if (data) {
        len = data.length
    }
    var begin = 0,
        end = len;
    if (opts) {
        begin = opts.begin || 0;
        end = opts.end || len;
        var maxNum = opts.maxNum || 0;
        if (maxNum != 0) {
            end = begin + maxNum;
        }
        if (end > len) {
            end = len;
        }
    }
    for (var i = begin; i < end; i++) {
        h += COMMON.string.format(template, data[i]);
    }
    return h;
};

/**
 * 对目标字符串进行格式化
 * @author: jlw
 * @date 2011/08/01
 * @name COMMON.string.format
 * @param {string} template 目标字符串
 * @param {Object|string...} opts 提供相应数据的对象或多个字符串
 * @returns {string} 格式化后的字符串
 */
COMMON.string.format = function(template, opts){
    var template = String(template);
    var data = Array.prototype.slice.call(arguments,1), toString = Object.prototype.toString;
    if(data.length){
        data = data.length == 1 ?
            /* ie 下 Object.prototype.toString.call(null) == '[object Object]' */
            (opts !== null && (/\[object Array\]|\[object Object\]/.test(toString.call(opts))) ? opts : data)
            : data;
        return template.replace(/\{\{(.+?)\}\}/g, function (match, key){
            var pos = key.indexOf('.');
            if(pos > 0) {
                //兼容二维数组
                var replacer = data[key.substring(0,pos)][key.substring(pos+1,key.length)];
            }else{
                var replacer = data[key];
            }
            // chrome 下 typeof /a/ == 'function'
            if('[object Function]' == toString.call(replacer)){
                replacer = replacer(key);
            }
            return ('undefined' == typeof replacer ? '' : replacer);
        });
    }
    return template;
};

/**
 * 判断字符串是否为整型
 * @param str
 * @return boolean
 */
COMMON.string.isInteger = function(str){
    return str % 1 === 0;
}

/**
 * 对目标日期格式化
 * @param date Date new Date("xxxxx");
 * @param fmt  格式化  yyyy-MM-dd hh:mm:ss
 */
COMMON.date.format = function(date, fmt){
    var o = {
        "M+" : date.getMonth()+1,                 //月份
        "d+" : date.getDate(),                    //日
        "h+" : date.getHours(),                   //小时
        "m+" : date.getMinutes(),                 //分
        "s+" : date.getSeconds(),                 //秒
        "q+" : Math.floor((date.getMonth()+3)/3), //季度
        "S"  : date.getMilliseconds()             //毫秒
    };
    if(/(y+)/.test(fmt))
        fmt=fmt.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length));
    for(var k in o)
        if(new RegExp("("+ k +")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
    return fmt;
}

/**
 * 显示正在加载
 */
COMMON.loading.show = function(){
    var imgSrc = SITE_URL + "/admin/statics/images/loading.gif";
    var loading = '<div id="loading" class="loading"><img src="'+ imgSrc +'" /></div>';
    $("body").append(loading);
}

/**
 * 关闭正在加载
 */
COMMON.loading.close = function(){
    $("#loading").remove();
}

/**
 * 根据URL获取ID
 */
COMMON.getIdByUrl = function(){
    var id = null;
    var href = window.location.href;
    var segments = href.split("/");
    if(href.substr(href.length - 1, 1) == "/"){
        id = segments[segments.length - 2];
    }else{
        id = segments[segments.length - 1];
    }
    return id;
}
