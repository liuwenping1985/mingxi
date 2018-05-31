/**
 * @author macj
 */



var rollWidthNum = 0;   //滚动图片 margin-left 初始值
var num = 0;			//给当前图片添加 current 类
var numImages; 			//滚动图片个数
var contentWidht;		//内容区域宽
var rollwidth;			//滚动层总宽度
var clearTimeoutVal;		//清除 setTimeout 延时方法
var radioBool = "false";//定义bool
var radioNum;
var logoMarginLeft;
var loginright;
var hasCount = false;
var radioBoxWidth = 0;
var warpMarginTop = 0;
var setTimeOutSpeedValue = 1100;	//定义图片滚动速度


$(window).resize(function() {
  imgRoll(); //计算各元素初始值
});


function imgRoll()	//计算个元素初始值
{

	var WindowWidth =  $(window).width();  //获取窗口的宽度

	//判断个分辨率下 logo以及  登陆框 的位置
	if (WindowWidth <= 1366 ) 
	{
		loginright = 130;
		warpMarginTop = 0;

	}
	else if(WindowWidth > 1366 && WindowWidth < 1440)
	{
		loginright = 180;
		warpMarginTop = 60;
		if (WindowWidth > 1366) {
		$(".overflow_login").css("overflow","hidden");
		}
	}
	else if (WindowWidth >= 1440 && WindowWidth <= 1680) 
	{
		loginright = 240;
		warpMarginTop = 90;
		if (WindowWidth > 1440) {
		$(".overflow_login").css("overflow","hidden");
		}
	}
	else if(WindowWidth > 1680 && WindowWidth < 1920)
	{
		loginright = 280;
		warpMarginTop = 120;
	}
	else if (WindowWidth >= 1920 && WindowWidth < 2560) 
	{
		loginright = 350;
		warpMarginTop = 160;
		$(".overflow_login").css("overflow","hidden");
	}
	else if (WindowWidth >= 2560) 
	{
		loginright = 450;
		warpMarginTop = 400;
		$(".overflow_login").css("overflow","hidden");
	}

	$(".login_box").css("right",loginright + "px");
	$(".login_header").css("height", (warpMarginTop + 60) + "px");
	$(".fuzhu_area,.fuzhu_area_bg").css("right",loginright + "px");

	numImages = $(".scroll_div_box").length; 		//获取有滚动图片个数


	contentWidht = $(".login_content").width();		//获取内容区域宽
	rollwidth = contentWidht * numImages;			//计算滚动层总宽度
	$(".scroll_div").css("width", contentWidht + "px"); //给scroll外层div赋值
	$(".center_div").css("width", (contentWidht-2) + "px");

	var bottomBodyHeight = $(window).height() - warpMarginTop - 490;
	//var bottomBodyHeight = window.screen.height+ 100;
    $(".login_footer").css("height", bottomBodyHeight + "px");



	if (numImages == 1) 
	{
		$(".scroll_div_width").css("width", rollwidth + "px");
		$(".scroll_div_box").css("width", contentWidht + "px");
		$(".scroll_radio_box").css("display", "none");
		return false;
		
	}else{
		if(!hasCount){
            radioBoxWidth  = numImages * 20; //计算 radio 外层div宽度
		}
		
		hasCount = true;
		$(".scroll_radio_box").css("width", radioBoxWidth + "px");

		
		var radioBoxPositionLeft = (contentWidht - radioBoxWidth) / 2; //计算 radio 位置
		$(".scroll_radio_box").css("left", radioBoxPositionLeft + "px");

		if (numImages == 2)
		{
			$(".scroll_div_width").append($(".scroll_div_width div").clone());
		}

		numImages = $(".scroll_div_box").length; 		//获取有滚动图片个数

		contentWidht = $(".login_content").width();		//获取内容区域宽
		rollwidth = contentWidht * numImages;			//计算滚动层总宽度
		$(".scroll_div").css("width", contentWidht + "px"); //给scroll外层div赋值

		$(".scroll_div_width").css("width", rollwidth + "px");
		$(".scroll_div_box").css("width", contentWidht + "px");
	}
	
	//当窗口宽度调整到960px时，登陆框固定在left：960px.(视觉给的值)
    if (contentWidht <= 960){
    	$(".login_box").css("right", "");
    	$(".login_box").css("left", "650px");
    }else if (contentWidht > 1270) {
    	$(".login_box").css("left", "");
    	$(".login_box").css("right",loginright + "px");
    }
} 

function imgRollAnimate()	//实现图片滚动
{
	if (numImages != 1) 
	{
		/****实现图片滚动****/
		rollWidthNum = parseInt(rollWidthNum - contentWidht);  //计算滚动图片 margin-left 值
			if (rollWidthNum < -contentWidht*1)
			{

				$(".scroll_div_box:last").after($(".scroll_div_box:first")); //将队列第一张图片添加插入到最后一张
	
				//$(".scroll_div_width").css("margin-left", -contentWidht*1 + "px");  
				$(".scroll_div_width").css("margin-left", "0px");  

				rollWidthNum = parseInt(-contentWidht);
				//alert("111");	
			};

			$(".scroll_div_width").animate({marginLeft: rollWidthNum+"px"},setTimeOutSpeedValue);

		/****处理“点”****/
			num = num + 1;
			if (num >= numImages) 
			{
				num = 0;
			};

			$(".scroll_div_box").removeClass("current"); //移除所有 类名为“current”

			$(".scroll_div_box:eq(1)").addClass("current"); //给当前图片添加类名“current”
			
			var numImg = $(".current").attr("uid"); //获取当前是第几个图片

			$(".scroll_radio_box .scroll_radio_box_img img").attr("src",_ctxPath + "/main/login/scroll/css/images/radio_1.png?V=5_0_5_23"); //初始化实心点
			$(".scroll_radio_box .scroll_radio_box_img:eq(" + numImg +")").find("img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_2.png?V=5_0_5_23"); //当前图片加点

			//clearTimeout(clearTimeoutVal);
			clearTimeoutVal = setTimeout("imgRollAnimate()",5000); //每三秒切换一张图片
	}
}

clearTimeoutVal = setTimeout("imgRollAnimate()",5000); 

function scrollRadioRoxMouseOver() //鼠标移动到 “点” 时，图片自动停止滚动
{
	clearTimeout(clearTimeoutVal);

	radioNum = $(this).attr("uid");
	
	var mouseIndexNum = $(".scroll_div_box"+radioNum).index();
	
	//  0  1  2  3  4

	var animatePx = -parseInt(contentWidht*mouseIndexNum);

	$(".scroll_radio_box .scroll_radio_box_img img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_1.png?V=5_0_5_23"); //初始化实心点
	$(".scroll_radio_box .scroll_radio_box_img:eq(" + radioNum +")").find("img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_2.png?V=5_0_5_23"); //当前图片加点
	$(".scroll_div_width").stop();
	$(".scroll_div_width").animate({marginLeft: animatePx+"px"},setTimeOutSpeedValue);
}

function scrollRadioRoxMouseOut()  //鼠标移动到 “点” 时，图片自动滚动
{
	clearTimeout(clearTimeoutVal);
	clearTimeoutVal = setTimeout("imgRollAnimate()",5000); //每五秒切换一张图片
}

function setTimeOutSpeed (n){
	setTimeOutSpeedValue = n;
}