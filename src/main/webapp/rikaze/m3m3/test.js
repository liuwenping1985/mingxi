
	alert(window.location.href);

	function anaParams() {
   var name,value;
   var str=location.href; //取得整个地址栏
   var num=str.indexOf("?")
   str=str.substr(num+1); //取得所有参数   stringvar.substr(start [, length ]

   var arr=str.split("&"); //各个参数放到数组里
   var params={};
   for(var i=0;i < arr.length;i++){
        num=arr[i].indexOf("=");
        if(num>0){
             name=arr[i].substring(0,num);
             value=arr[i].substr(num+1);
             params[name]=value;
        }
   }
   return params;
}
anaParams()
	//http://220.182.9.61:29001/seeyon/main.do?method=main&fragmentId=-7771288622128478783
