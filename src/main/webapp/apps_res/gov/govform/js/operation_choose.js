var arg = window.dialogArguments;

function showNode(flowpermName, processName) {
	var choosedOperation_processName = null;
	var option =null;
	var opt = null;
	var temp_b = null;
	var selected = document.getElementById("selected"); //选择区
	var reserve = document.getElementById("reserve"); //备选区
	opt = arg.document.getElementById(processName);
	choosedOperation_processName = arg.document.getElementById("choosedOperation_"+processName);   //得到对应处理意见的名称
	if(choosedOperation_processName!=null && choosedOperation_processName!="") {
		for(var j = 0; j < choosedOperation_processName.length; j++) {
			var temp = choosedOperation_processName[j].text.split(",");
			if(choosedOperation_processName[j].getAttribute("itemList")){
				temp_b = choosedOperation_processName[j].getAttribute("itemList").split(",");
			}
			if(temp.length > 1) {
				for(var i=0;i<temp.length;i++) {
  	  				option=document.createElement("OPTION");
  	  				//selected.options.add(option);
  	  				$(selected).append(option);
  	  				if(choosedOperation_processName[j].getAttribute("itemList")) {
		 				option.value=temp_b[i];
		 			} else {
		 				option.value= choosedOperation_processName[j].value;
		 			}
		  			option.text= temp[i];
				}
			} else if(temp.length == 1 && choosedOperation_processName[j].value !="" && choosedOperation_processName[j].text != "") {			
				option = document.createElement("OPTION");
				//selected.options.add(option);
				$(selected).append(option);
				if(choosedOperation_processName[j].getAttribute("itemList")){
		 			option.value=temp_b[0];
		 		}else{
		 			option.value= choosedOperation_processName[j].value;
		 		}
		  		option.text=choosedOperation_processName[j].text;
		  	}
		}
	}
	
	var operation_opt = arg.document.getElementById("operation");
	var operation_str = arg.document.getElementById("operation_str");  
	if(reserve.options.length!=0) {
		reserve.options.length = 0;
		for(var j = 0; j < operation_opt.length; j++){
			var re = '('+operation_opt.options[j].value+')';
			var r =   operation_str.value.indexOf(re);
			if(r == -1) {					
  	  			option = document.createElement("OPTION");
  	  			$(reserve).append(option);
	     		//reserve.options.add(option);
		 		option.value=operation_opt[j].value;
		  		option.text=operation_opt[j].text;
		  	}  
		}
	}
}
function showNode2(flowpermName, processName) {
	var choosedOperation_processName = null;
	var option =null;
	var opt = null;
	var temp_b = null;
	var selectedStr = '';
	var selected = document.getElementById("selected"); //选择区
	var reserve = document.getElementById("reserve"); //备选区
	opt = arg.document.getElementById(processName);
	choosedOperation_processName = arg.document.getElementById("choosedOperation_"+processName);   //得到对应处理意见的名称
	if(choosedOperation_processName!=null && choosedOperation_processName!="") {
		for(var j = 0; j < choosedOperation_processName.length; j++) {
			var temp = choosedOperation_processName[j].text.split(",");
			if(choosedOperation_processName[j].getAttribute("itemList")){
				temp_b = choosedOperation_processName[j].getAttribute("itemList").split(",");
			}
			if(temp.length > 1) {
				for(var i=0;i<temp.length;i++) {
  	  				option=document.createElement("OPTION");
  	  				//selected.options.add(option);
  	  				$(selected).append(option);
  	  				if(choosedOperation_processName[j].getAttribute("itemList")) {
		 				option.value=temp_b[i];
		 			} else {
		 				option.value= choosedOperation_processName[j].value;
		 			}
		  			option.text= temp[i];
					selectedStr =  selectedStr + ',' + option.text;
				}
			} else if(temp.length == 1 && choosedOperation_processName[j].value !="" && choosedOperation_processName[j].text != "") {			
				option = document.createElement("OPTION");
				//selected.options.add(option);
				$(selected).append(option);
				if(choosedOperation_processName[j].getAttribute("itemList")){
		 			option.value=temp_b[0];
		 		}else{
		 			option.value= choosedOperation_processName[j].value;
		 		}
		  		option.text=choosedOperation_processName[j].text;
				selectedStr =  selectedStr + ',' + option.text;
		  	}
		}
	}
	var reserve2 = document.getElementById("reserve2"); //备选区
	if(reserve2.options.length!=0) {
		reserve.options.length = 0;
		for(var j = 0; j < reserve2.options.length; j++){
			var r =   selectedStr.indexOf(reserve2.options[j].text);
			if(r == -1) {					
				option = document.createElement("OPTION");
  	  			$(reserve).append(option);
	     		//reserve.options.add(option);
		 		option.value=reserve2.options[j].value;
		  		option.text=reserve2.options[j].text;
		  	}  
		}
	}
}
function moveLtoR(fObj,tObj) {
	var i;
	var opt;
	for(i=0;i<fObj.options.length;i++) {
		if(fObj.options[i].selected==true) {
  	  		for(var j=0;j<tObj.length;j++) {
  	  			if(fObj.options[i].value == tObj.options[j].value){
					break;
	  	  		}
		  	}
		  	if(j==tObj.length){
		  	     opt=document.createElement("OPTION");
	     		 //tObj.options.add(opt);
		  	     $(tObj).append(opt);
		 		 opt.value=fObj.options[i].value;
		  		 opt.text=fObj.options[i].text;  
		  		 
		  		fObj.remove(i);
		  		i--;
		 	}
		} 
	}
}

function moveRtoL(fObj,tObj) {
	var i;
	var opt;
	for(i=0;i<fObj.options.length;i++) {
		if(fObj.options[i].selected==true) {
			opt=document.createElement("OPTION");
	     	//tObj.options.add(opt);
			$(tObj).append(opt);
		 	opt.value=fObj.options[i].value;
		  	opt.text=fObj.options[i].text;
	  		fObj.remove(i);
  			i--;
		}
	}
}


/**select选择的项上移*/
function up(selObj) {
  	var i;
  	var optValue,optTxt;
  	for(i=0;i<selObj.options.length;i++) {
    	if(selObj.options[i].selected==true) {
	  		if(i==0){return;}
		  	optValue=selObj.options[i-1].value;
		  	optTxt=selObj.options[i-1].text;
		  	selObj.options[i-1].value=selObj.options[i].value;
		  	selObj.options[i-1].text=selObj.options[i].text;
		  	selObj.options[i].value=optValue;
		  	selObj.options[i].text=optTxt;
		  	selObj.options[i].selected=false;
		  	selObj.options[i-1].selected=true;
		}
  	}
}

/**select选择的项下移*/
function down(selObj) {
  	var i;
  	var optValue,optTxt;  
  	for(i=selObj.options.length-1;i>=0;i--) {
    	if(selObj.options[i].selected==true) {
	  		if(i==(selObj.options.length-1)){return;}
	  		optValue=selObj.options[i+1].value;
	  		optTxt=selObj.options[i+1].text;
	  		selObj.options[i+1].value=selObj.options[i].value;
	  		selObj.options[i+1].text=selObj.options[i].text;
	  		selObj.options[i].value=optValue;
	  		selObj.options[i].text=optTxt;
	  		selObj.options[i].selected=false;
	  		selObj.options[i+1].selected=true;
		}
  	}
}

function transformValue() {
	var obj =  document.getElementById("selected");
	var array = new Array();
	for(var i=0;i<obj.options.length;i++){	
		array[i] = new Array();
		array[i][0]= obj.options[i].value;
		array[i][1] = obj.options[i].text;
	}
	arg.reloadPermission(array, flowpermName, processName);
	arg.choosePermissionDialog.close();
}
