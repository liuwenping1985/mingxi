/**
 * @author macj
 */

$(document).ready(function(){
	imgRoll(); //计算个元素初始值
	$(".scroll_radio_box_img").bind("mouseover", scrollRadioRoxMouseOver);
	$(".scroll_radio_box img").bind("mouseout", scrollRadioRoxMouseOut);
});

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

function imgRoll()	//计算个元素初始值
{
	var screenWidth =  window.screen.width;  //获取屏幕分辨率的宽度

	//判断个分辨率下 logo以及  登陆框 的位置
	if (screenWidth <= 1366 ) 
	{
		logoMarginLeft = 20;
		loginright = 130;
	}
	else if (screenWidth >= 1440 && screenWidth <= 1680) 
	{
		logoMarginLeft = 170;
		loginright = 240;
	}
	else if (screenWidth == 1920) 
	{
		logoMarginLeft = 320;
		loginright = 350;
	}
	else if (screenWidth == 2560) 
	{
		logoMarginLeft = 470;
		loginright = 450;
	}

	$(".header_logo").css("marginLeft",logoMarginLeft + "px");
	$(".login_box").css("right",loginright + "px");
	$(".fuzhu_area,.fuzhu_area_bg").css("right",loginright + "px");

	numImages = $(".scroll_div_box").length; 		//获取有滚动图片个数

	contentWidht = $(".login_content").width();		//获取内容区域宽
	rollwidth = contentWidht * numImages;			//计算滚动层总宽度
	$(".scroll_div").css("width", contentWidht + "px"); //给scroll外层div赋值
	$(".center_div").css("width", (contentWidht-2) + "px");

	var bottomBodyHeight = window.screen.height - 60 - 490 - 150;
    $(".login_footer").css("height", bottomBodyHeight + "px");



	if (numImages == 1) 
	{
		$(".scroll_div_width").css("width", rollwidth + "px");
		$(".scroll_div_box").css("width", contentWidht + "px");
		return false;
		
	}else{
		var radioBoxWidth = numImages * 20; //计算 radio 外层div宽度
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

			$(".scroll_div_width").animate({marginLeft: rollWidthNum+"px"});

		/****处理“点”****/
			num = num + 1;
			if (num >= numImages) 
			{
				num = 0;
			};

			$(".scroll_div_box").removeClass("current"); //移除所有 类名为“current”

			$(".scroll_div_box:eq(1)").addClass("current"); //给当前图片添加类名“current”
			
			var numImg = $(".current").attr("uid"); //获取当前是第几个图片

			$(".scroll_radio_box .scroll_radio_box_img img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_1.png"); //初始化实心点
			$(".scroll_radio_box .scroll_radio_box_img:eq(" + numImg +")").find("img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_2.png"); //当前图片加点

			//clearTimeout(clearTimeoutVal);
			clearTimeoutVal = setTimeout("imgRollAnimate()",3000); //每三秒切换一张图片
	}
}

clearTimeoutVal = setTimeout("imgRollAnimate()",3000); 

function scrollRadioRoxMouseOver() //鼠标移动到 “点” 时，图片自动停止滚动
{
	clearTimeout(clearTimeoutVal);

	radioNum = $(this).attr("uid");
	
	var mouseIndexNum = $(".scroll_div_box"+radioNum).index();
	
	//  0  1  2  3  4

	var animatePx = -parseInt(contentWidht*mouseIndexNum);

	$(".scroll_radio_box .scroll_radio_box_img img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_1.png"); //初始化实心点
	$(".scroll_radio_box .scroll_radio_box_img:eq(" + radioNum +")").find("img").attr("src", _ctxPath + "/main/login/scroll/css/images/radio_2.png"); //当前图片加点

	$(".scroll_div_width").animate({marginLeft: animatePx+"px"});
}

function scrollRadioRoxMouseOut()  //鼠标移动到 “点” 时，图片自动滚动
{
	clearTimeout(clearTimeoutVal);
	clearTimeoutVal = setTimeout("imgRollAnimate()",3000); //每三秒切换一张图片
}