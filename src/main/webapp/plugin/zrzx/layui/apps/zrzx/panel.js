;
(function () {

    layex.mdefine("panel",['jquery'], function (exports) {

        var apiSet ={};

        apiSet.hello=function(){
            alert("hello");
        }


        exports("panel", apiSet);
    })



}());