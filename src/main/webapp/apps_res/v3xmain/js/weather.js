//城市天气预报
var cityWeather = [];
    cityWeather[0] = "0";
    cityWeather[1] = getFrameHTML("http://weather.qq.com/inc/ss125.htm", 190, 190);
    cityWeather[2] = getFrameHTML("http://weather.265.com/weather.htm", 160, 54);
    cityWeather[3] = getFrameHTML("http://news.sina.com.cn/iframe/weather/110100.html", 260, 70);

var cityWeatherName = [];
    cityWeatherName[0] = v3x.getMessage("MainLang.weather_selectWeatherWeb_city");
    cityWeatherName[1] = v3x.getMessage("MainLang.weather_cityWeatherWebName1");
    cityWeatherName[2] = v3x.getMessage("MainLang.weather_cityWeatherWebName2");
    cityWeatherName[3] = v3x.getMessage("MainLang.weather_cityWeatherWebName3");
 

//全国视图天气预报
var countrywideWeather = [];    
    countrywideWeather[0] = "0";
    countrywideWeather[1] = getFrameHTML("http://weather.qq.com/24.htm", 405, 332);

var countrywideWeatherName = [];
    countrywideWeatherName[0] = v3x.getMessage("MainLang.weather_selectWeatherWeb_countrywide");
    countrywideWeatherName[1] = v3x.getMessage("MainLang.weather_countrywideWeatherWebName1");

var message1 = "<font color='red'>" + v3x.getMessage("MainLang.weather_doesnotConfigWeb_city") + "</font>"
var message2 = "<font color='red'>" + v3x.getMessage("MainLang.weather_doesnotConfigWeb_countrywide") + "</font>";

//初始化天气 
function initWeather(configValue)
{
   var cityObj = document.getElementById("cityWeatherDIV");
   var countryObj = document.getElementById("countrywideWeatherDIV");
   
   if(configValue == ""){
      cityObj.innerHTML = message1;
      countryObj.innerHTML = message2;
   }else{
      var resultArray = configValue.split(",");
      if(resultArray[0]=="0" || resultArray[0]==0){
      	cityObj.innerHTML = message1;
      }else{
      	cityObj.innerHTML = cityWeather[resultArray[0]];      	
      }
      if(resultArray[1]=="0" || resultArray[1]==0){
      	countryObj.innerHTML = message2;
      }else{
      	countryObj.innerHTML = countrywideWeather[resultArray[1]];      	
      }
   }
}


//点击提交
function setValue()
{
	document.getElementById("submitBtn").disabled = true;
	document.all.weatherConfig.value = document.getElementById("cityWeatherSelect").selectedIndex + "," + document.getElementById("countrywideWeatherSelect").selectedIndex;
}

//点击单选按钮
function redioClicked(stateValue, radioValue)
{
	if(stateValue != radioValue){
		document.getElementById("submitBtn").disabled = false;
	}
	if(radioValue == "off"){
		document.getElementById("cityWeatherSelect").selectedIndex = 0;
		document.getElementById("cityWeatherDIV").innerHTML = message1;
		document.getElementById("countrywideWeatherSelect").selectedIndex = 0;
		document.getElementById("countrywideWeatherDIV").innerHTML = message2;
	}
}

//下拉选择框列表事件
function loadWeather(index)
{
	if(index==1){
		 var i = document.getElementById("cityWeatherSelect").selectedIndex;
		 var Obj = document.getElementById("cityWeatherDIV");
		 if(i==0)Obj.innerHTML = message1;
		 else Obj.innerHTML = cityWeather[i]; 
	}else if(index==2)
	{
		 var i = document.getElementById("countrywideWeatherSelect").selectedIndex;
		 var Obj = document.getElementById("countrywideWeatherDIV");
		 if(i==0)Obj.innerHTML = message2;
		 else Obj.innerHTML = countrywideWeather[i]; 
	}
	document.getElementById("submitBtn").disabled = false;
}

//初始化下拉选择框
function initSelect(configValue)
{
	var selectorObj1 = document.getElementById("cityWeatherSelect");
	var selectorObj2 = document.getElementById("countrywideWeatherSelect");
	if(configValue == "")
	{
      if(selectorObj1){
			for(var i = 0; i < cityWeather.length; i++) {
				var option = new Option(cityWeatherName[i], cityWeather[i]);
				selectorObj1.options.add(option);
			}
		}
		if(selectorObj2){
			for(var i = 0; i < countrywideWeather.length; i++) {
				var option = new Option(countrywideWeatherName[i], countrywideWeather[i]);
				selectorObj2.options.add(option);
			}
		}
    }else{
		var resultArray = configValue.split(",");
		if(selectorObj1){
			for(var i = 0; i < cityWeather.length; i++) {
				var option = new Option(cityWeatherName[i], cityWeather[i]);
				if(i == resultArray[0]){
					option.selected = true;
				}
				selectorObj1.options.add(option);
			}
		}
		if(selectorObj2){
			for(var i = 0; i < countrywideWeather.length; i++) {
				var option = new Option(countrywideWeatherName[i], countrywideWeather[i]);
				if(i == resultArray[1]){
					option.selected = true;
				}
				selectorObj2.options.add(option);
			}
		}
    }
}
 
function getFrameHTML(url, width, height)
{
     return "<IFRAME align='center' marginWidth='0' marginHeight='0' src='" + url + "' frameBorder='0' width='400' height='300' scrolling='yes'></IFRAME>";
}
