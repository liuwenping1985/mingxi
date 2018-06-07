;
function showPersonSummary(name){

    modalWin.open();
    $("#modalWin").show();

}
var modalWin = null;
$(document).ready(function(){

    modalWin  = new Custombox.modal({
        content: {
            effect: 'fadein',
            target: '#modalWin'
        }
    });
    $(".cs-header-close").click(function(){
        $("#modalWin").hide();
        Custombox.modal.close();

    });
    $(".cs-footer-btn").click(function(){

      $("#modalWin").hide();
            Custombox.modal.close();
    })


});