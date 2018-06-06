
function anaParams() {
    var name, value;
    var str = location.href; //取得整个地址栏
    var num = str.indexOf("?")
    str = str.substr(num + 1); //取得所有参数   stringvar.substr(start [, length ]

    var arr = str.split("&"); //各个参数放到数组里
    var params = {};
    for (var i = 0; i < arr.length; i++) {
        num = arr[i].indexOf("=");
        if (num > 0) {
            name = arr[i].substring(0, num);
            value = arr[i].substr(num + 1);
            params[name] = value;
        }
    }
    return params;
}
$(document).ready(function(){
    var params = anaParams();
    if(params.from=="menhu"&&(params.type=="banwen"||params.type=="yuewen")){
		$("#main").hide();
		var max_depth=10;
		function openLink222(){
			var funct =document.getElementById("main").contentWindow.openLink;
	 if(funct){
		 $("#main").show();
		 if(params.type=="banwen"){
			funct('/seeyon/collaboration/pending.do?method=morePending&fragmentId=-7771288622128478783&ordinal=0&currentPanel=sources&rowStr=subject,deadLine,edocMark,sendUnit,sendUser&columnsName=待办公文');
		 
		 }else{
			 funct('/seeyon/collaboration/pending.do?method=morePending&fragmentId=6704235930793100687&ordinal=1&currentPanel=sources&rowStr=subject,deadLine,edocMark,sendUnit,sendUser&columnsName=待阅公文');getCtpTop().showMainBorder();
		 }
		document.getElementById("main").contentWindow.getCtpTop().showMainBorder();
	 }else{
		 if(max_depth<0){
			 return;
		 }
		 max_depth--;
		 setTimeout(openLink222,1000);
	 }
			
		}
     
	 openLink222();
    
    }
});
	//http://220.182.9.61:29001/seeyon/main.do?method=main&fragmentId=-7771288622128478783
	