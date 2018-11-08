;
(function () {

    layex.mdefine("grid", ['jquery'], function (exports) {
        var apiSet = {};
        apiSet.hello = function () {
            alert("hello");
        };
        exports("grid", apiSet);
    })



}());