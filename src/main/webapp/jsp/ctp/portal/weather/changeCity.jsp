<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>changeCity</title>
<script>
var fragmentId="${fragmentId}";
var ordinal="${ordinal}";
var c="${city}";var p="${prov}";
var x="${x}";var y="${y}";var spaceId="${spaceId}";
$(document).ready(function(){
	getCity($("#prov"));
});

function getCity(select){
	  var weatherManager=new weatherAreaInfoManager();
	  var key=$(select).val();
	  if(key==''){
		  $("#city").empty();
		  $("#city").append("<option value=''>当前城市</option>");return;
	  }
	  weatherManager.getDistrictListByProvEn(key,{
		    success : function(data){
		    	$("#city").empty();
		    	$.each(data,function(key,value){
		    		if(value==c){
		    			$("#city").append("<option selected value='"+key+"'>"+value+"</option>");
		    		}else{
		    			$("#city").append("<option value='"+key+"'>"+value+"</option>");
		    		}
		    	});
		    }
	  });
}
function saveCity(){
	var city=$("#city").find("option:selected").text();
	if(city=='当前城市'){city="";}
	var url="/seeyon/portal/weatherController.do?method=updateProperty&entityId="+fragmentId+"&x="+x+"&y="+y+"&spaceId="+spaceId+"&width=${param.width}";
	var data="{prov:'"+$("#prov").find("option:selected").text()+"',city:'"+city+"'}";
	$.ajax({
        url:url,
        data:$.parseJSON(data),
        type:'POST',
        dataType : 'json',
        success:function(obj){
        	if(obj && obj.result == "true"){
        		toWeather();
              }else{
              	 getCtpTop().refreshNavigation(spaceId);
            }
        }
      });
	
}
function toWeather(){
	location.href="/seeyon/portal/weatherController.do?method=weather&fragmentId="+fragmentId+"&ordinal="+ordinal+"&cityCode="+encodeURI(getA8Top().cityName)+"&x="+x+"&y="+y+"&spaceId="+spaceId+"&width=${param.width}";
}
</script>
<style>
.common_button{padding: 0 10px;}
</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/common/weather/css/weather.css">
</head>
<body class="bg_color_none">
<div id="weather" align="center">
	<div class="weatherRow">
	<select id="prov" name="prov" onchange="getCity(this);" style="width: auto;max-width: 70px; ">
		<option value="">当前城市</option>
		<c:forEach var="p" items="${provs}">
		   <c:choose>
			   <c:when test="${prov == p.value}">  
			   		<option selected value="${p.key}">${p.value}</option>
			   </c:when>
			   <c:otherwise> 
			   		<option value="${p.key}">${p.value}</option>
			   </c:otherwise>
		   </c:choose>
		</c:forEach>
	</select>
	<select id="city" name="city" style="width: auto;max-width: 70px;">
	</select>
	</div>
	<div class="weatherRow">
	<a href="javascript:void(0);" class="common_button common_button_emphasize" onclick="saveCity();">确定</a>
	<a href="javascript:void(0);" class="common_button common_button_gray" onclick="toWeather();">取消</a>
	</div>
</div>
</body>
</html>