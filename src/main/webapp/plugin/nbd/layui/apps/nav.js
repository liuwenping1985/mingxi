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
             Dao.getList("a82other", function (data2) {
                 $(".nbd_content").hide();
                 $("#a82other").show();
                 A82OTHER.renderList(data2);
             });
        });

        $("#other2a8_list_btn").click(function () {

            show("other2a8");
             Dao.getList("other2a8", function (data2) {
                 $(".nbd_content").hide();
                 $("#other2a8").show();
                 OTHER2A8.renderList(data2);
             });
        });

        $("#log_list_btn").click(function () {

            show("log");
        });
       



    });



}())