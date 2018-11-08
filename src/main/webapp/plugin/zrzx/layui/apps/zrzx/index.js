;
(function () {
    lx.use(["grid", "panel","client-info"], function () {
        var grid = lx.grid;
        grid.hello();
        var panel = lx.panel;
        panel.hello();
        var ci = lx.client-info;
        alert(ci.width);
        alert(ci.height);

    });
}());