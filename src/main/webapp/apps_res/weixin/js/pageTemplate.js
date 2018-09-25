/**
 * Created by YangH on 2015/6/3 0003.
 */
var CMP = {};

(function () {
    CMP = {
        //public
        version: '1.0',
        //javascript template
        tpl: (function () {
            var cache = {};

            function tpl(str, data) {
                var fn = !/\s/.test(str) ?
                    cache[str] = cache[str] || tpl(str) :
                    new Function("obj", "var p='';p+='"
                        + str.replace(/[\r\n\t]/g, " ")
                            .split('\\').join("\\\\")
                            .split("{%").join("\t")
                            .replace(/((^|%})[^\t]*)'/g, "$1\r")
                            .replace(/\t=(.*?)%}/g, "'+$1+'")
                            .split("\t").join("';")
                            .split("%}").join("p+='")
                            .split("\r").join("\\'")
                        + "';return p;");
                return data ? fn.call(data) : fn;
            }
            return tpl;
        })()
    }
})();