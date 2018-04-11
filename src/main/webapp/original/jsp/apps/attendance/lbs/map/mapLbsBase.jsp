<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script language="javascript" src="https://webapi.amap.com/maps?v=1.3&key=089d59f15ad6506f4b0de55285f70222"></script>
<script type="text/javascript">
var mapObj,marker,infoWindow ;
(function(){
    namespace = function(str){
		var att = str.split("."), o=window;
		for(var i =0;i < att.length;i ++){
		var t = o[att[i]] || {};
		o[att[i]] = t;
		o =o[att[i]];
		}
	}
	var result={};
	var mapType =mapType_Gaode;
	//高德地图
	var mapType_Gaode = 2;
	namespace("m.cmp.lbs.gaode");
	m.cmp.lbs.gaode = function(params){
		mapType = mapType_Gaode;
	}
	var markerList=new Array();
	m.cmp.lbs.gaode.prototype.loadingMarker = function(params){
		if(params){
			var lng = params.lbsLongitude;
			var lat = params.lbsLatitude;
			var marker = new AMap.Marker({ //添加自定义点标记
				position:[lng,lat], //经纬度位置 
		        zIndex:0,
		      	cursor:"default",
		        offset: new AMap.Pixel(0,0), //相对于基点的偏移位置
		        extData:{
		        	id:params.lbsId //id,唯一标识
		        },
		        draggable: false,  //是否可拖动
		        visible:true,
		        content:'<div style="background:url(${path}/apps_res/hr/lbs/images/position.png) left top no-repeat; text-align:center;"><img style="border: none;  border-radius: 25px; " src="'+params.imgUrl+'" width="30" height="30" /></div>'
		    });
			//覆盖物
			mapObj.add(marker);
			//给标注绑定单击事件
			marker.on("click",function(){
				var markerTd=$("#cardContent>div[markerId='"+params.lbsId+"']");
				index=$("#cardContent>div").index(markerTd);
				removeTCardIndex();
				addTCardIndex(index); 
			})
		}
	}
	
	m.cmp.lbs.gaode.prototype.initMap=function(params){
			if(!params){
				mapObj = new AMap.Map(params.id);
				return;
			}
			checkIniteParams(params);
			 var opts = {};
			 var currentCity  = params.city;
			 opts["level"]=5;
			 opts["zoomEnable"] = params.zoomable;
			 opts["zooms"] = [params.minzoom,params.maxzoom];
			 //如果 经纬度合法，并且城市设置为空
			 if(!currentCity && !isNaN(centerX)&& !isNaN(centerY)){
				var centerX = params.lng;
				var centerY = params.lat;
				opts["center"] = new AMap.LngLat(centerX,centerY);
			 }
			mapObj = new AMap.Map(params.id,opts);
			//如果城市设置不为空  则设置城市地址
			if(currentCity){
				mapObj.setCity(currentCity);
				
			}
			mapObj.plugin(["AMap.ToolBar", "AMap.OverView", "AMap.Scale"],function() { 
			});
	}
	//检验初始化方法请求数据的合法性
	function checkIniteParams(params){
		if(!params){
			return false;
		}
		var minZoom = params.maxzoom;
		var maxZoom = params.minzoom;
		if(isNaN(minZoom)){
			params.minzoom = 3;
		}
		if(isNaN(maxZoom)){
			params.maxzoom = 18;
		}
		if (params.minzoom < params.maxzoom){
			params.minzoom = 3;
			params.maxzoom = 18;
		}
		var currentCity  =  params.city;
		var centerX = params.lng;
		var centerY = params.lat;
		var level = params.level;
		if(!level || isNaN(level)){
			params.level = 13;
		}
		var zoomable = params.zoomable;
		if(!zoomable){
			params.zoomable = true;
		} else if (zoomable==true ||zoomable=="true") {
			params.zoomable = true;
		} else {
			params.zoomable = false;
		}
		//如果城市为空时  ，再判断中心点的经纬度是否是数字
		if (!currentCity){
			if(isNaN(centerX)){
				params.lng =116.40632629394531 ;
			}
			if(isNaN(centerY)){
				params.lat=39.90394233735701;
			}
		}
		return true;
	}
})();
</script>
