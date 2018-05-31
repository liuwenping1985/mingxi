$(document).ready(function(){

    var imghtml =[];
    var backgroundColor=["#C0392B","#E74C3C","#D35400","#E67E22","#F39C12","#F1C40F","#27AE60","#2ECC71"];
    var imgUrl="/admin/statics/images/loading/LAN_Loading",imgCount=8,imgstart=1;
    for(var count=imgstart;count<=imgCount;count++){
        imghtml.push('<img class="loading_img" id="loading_img_'+count+'"src="' +imgUrl+count+ '.png" ></img>');
    }
    $("#loading-img").html(imghtml.join(""));
    $(".loading_img").hide();
    var currentImg = imgstart;
    function showLoading(){
        if(currentImg>imgCount){
            currentImg=imgstart;
        }
        if(currentImg==imgstart){
            $("#loading_img_"+imgCount).hide();
          //  $("#loading-mask").css("background-color",backgroundColor[imgCount]);
        }else{
            $("#loading_img_"+(currentImg-1)).hide();
            //  $("#loading-mask").css("background-color",backgroundColor[currentImg-1]);
        }
        $("#loading_img_"+currentImg).show();
        currentImg++;

        setTimeout(showLoading,500);
    }
    showLoading();


});