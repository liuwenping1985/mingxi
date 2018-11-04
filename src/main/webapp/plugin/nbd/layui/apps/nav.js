;
(function () {

    $(document).ready(function () {
        function show(linkContent) {
            $(".nbd_content").hide();
            $("#" + linkContent).show();

        }
        window.goPage = show;
        $("#config_list_btn").click(function () {

            show("link_config");
        });
        $("#a82other_list_btn").click(function () {

            show("a82other");
        });

        $("#other2a8_list_btn").click(function () {

            show("other2a8");
        });

        $("#log_list_btn").click(function () {

            show("log");
        });
       



    });



}())