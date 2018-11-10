;
(function () {
    lx.use(["grid", "panel","client-info","element"], function () {
        var grid = lx.grid;
      //  grid.hello();
        var panel = lx.panel;
        var $ = lx.jQuery||lx.jquery;
      //  panel.hello();
        var ci = lx["client-info"];
        var dimension = ci.getDimension();
        
        var el = lx.element;
        
        console.log(ci);
        $(".lx-layout-main").css("height", dimension.height-338);
      

    });
}());