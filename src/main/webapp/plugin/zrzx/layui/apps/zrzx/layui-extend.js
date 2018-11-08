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
    window.layex = layex;
    window.lx = layex;

}());