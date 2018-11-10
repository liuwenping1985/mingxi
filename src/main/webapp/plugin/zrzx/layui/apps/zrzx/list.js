;
(function () {
    
    lx.mdefine("list", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;

        function List(options) {



        }

        apiSet.create = function (options) {

            return new List(options);
        }

        apiSet.cmpName = function () {
            return "list";
        }




        exports("list", apiSet);
    })



}());