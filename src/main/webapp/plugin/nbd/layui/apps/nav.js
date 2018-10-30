;(function(){

    $(document).ready(function(){
        function show(linkContent){
            $(".nbd_content").hide();
            $("#" + linkContent).show();

        }
        window.goPage = show;
        $("#config_list_btn").click(function(){

                show("link_config");
        });
         $("#a82other_list_btn").click(function () {

                show("a82other");
         });

        $("#other2a8_list_btn").click(function(){

               show("other2a8");
        });

         $("#log_list_btn").click(function () {

               show("log");
         });
         $("#data_link_create").click(function(){
                show("link_create");

         });
          $("#data_link_update").click(function () {
              var items = $(".data_link_selected");
              $(items).each(function(index,item){
                    console.log($(item).attr("checked"));
              });
          });
         $("#data_link_delete").click(function () {
              //show("link_create");
              var items = $(".data_link_selected");
              $(items).each(function (index, item) {
                  console.log($(item).attr("checked"));
              });
          });




    });



}())