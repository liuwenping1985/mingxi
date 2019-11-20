function shensuo() {

    var left = document.getElementsByClassName('left')[0];

    left.onclick = function () {
        var nav = document.getElementsByClassName('nav-all')[0];
        var x=document.getElementById("flex");
        console.log(nav.classList)
        if (nav.classList.contains("move-right")) {


            x.style.position="relative";
            nav.classList.remove("move-right");
            console.log(11)
            nav.classList.add("move-left");

        } else {
            x.style.position="fixed";
            nav.classList.remove("move-left");
            console.log(22)
            nav.classList.add("move-right");

        }
    }



}
