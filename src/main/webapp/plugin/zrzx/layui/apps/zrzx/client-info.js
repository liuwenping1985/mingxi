;
(function () {

    lx.define(['jquery'], function (exports) {

        var apiSet = {};

        apiSet.getDimension = function () {
            return {
                height:window.screen.availHeight,
                width: window.screen.availWidth
            }
        }


        exports("client-info", apiSet);
    })



}());