;
(function () {
   
    var layex = layui;
    layex.mdefine=function(mName,requireMods,mmethod){
        layex.define(requireMods, function (exports) {
            if (mmethod){
                mmethod(exports);
            }
        });
    }
    var eutil = {};
    layex.eutil = eutil;
    layex.eutil.copyProperties = function (source, dest) {
        if(!source){
            source = {};
        }
        if(!dest){
            dest={};
        }
        for (var p in dest) {
            source[p] = dest[p];
        }

        return source;
    }
    var __index=0
    layex.eutil.uuid=function(){
        return __index++;
    }
    layex.eutil.getDimension = function () {
        return {
            height: window.screen.availHeight,
            width: window.screen.availWidth
        }
    }
    layex.eutil.getGlodenHeight=function(divide){
        if(!divide){
            divide = 3;
        }
        var h = window.screen.availHeight;
        return ((h*0.9)/3)*0.618;
    }
    window.layex = layex;
    window.lx =layex;

}());