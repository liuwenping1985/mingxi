//不需要显示的重复人员
var excludeElements_chooseleader;
var excludeElements_chooseassisitant;
var excludeElements_choosejunior;
var excludeElements_chooseconfrere;

function getMember(elements,currentSelectName){
	//var noShow = "";
	
	 if(!elements){
		return;
	 }
	 
    //删除原有人员
    if(currentSelectName.length > 0){
    	for(var i = 0; i < currentSelectName.length; i++){
    		var result = false;
    		for(var j = 0;j<elements.length;j++){
    			if(elements[j].id==currentSelectName.options[i].id){
    				//noShow+= "Member|"+currentSelectName.options[i].id+",";
    				result = true;
    			}
    		}
    		if(!result){
     			currentSelectName.options.remove(i);
     			i--;
    		}
     	}
   }
      //添加新的人员
	  for(var i = 0; i < elements.length; i++){
	  	var result = false;
	  	for(var k = 0;k<currentSelectName.length;k++){
	  		if(elements[i].id==currentSelectName.options[k].id){
	  			result = true;
	  		}
	  	}
	  	if(!result){
	  		var oOption = document.createElement("OPTION");
	      	oOption.text = elements[i].name;
	      	oOption.value = elements[i].id;
	      	oOption.id = elements[i].id;
	  	  	currentSelectName.add(oOption);
	  	  	//noShow+="Member|"+elements[i].id+",";
	  	}
	  }
   //alert(noShow);
    if(currentSelectName.name=="confrere"){
		excludeElements_confrere = elements;
	}
}

function setData(){
   
   if(document.all.confrere.length ==0){ 		
        return ;
		//confirm(v3x.getMessage("relateLang.isLeave"))
   }
   //写入 hidden Input

   for(var i = 0; i<document.all.confrere.length; i++){
      document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='confreres' value='" + document.all.confrere.options[i].value + "'/>" + "\r";
   }
   //alert(document.getElementById("hiddenDataDiv").innerHTML);
   return true ;
}

function reSet(){
	var sel = document.all.tags("select");
	var confrereloop = sel[0].options.length;
	for(var i=0;i<confrereloop;i++){
		sel[0].options.remove(0);
	}
}


function openDetail(link, titleId) {
    var rv = getA8Top().v3x.openWindow({
        url: link,
        workSpace: 'yes'
    });

    if (rv == "true" || rv == true) {
    	if(titleId){
    		document.getElementById(titleId).click();
    	}
    }
}

function joinArrays(jionArr,arr1,arr2,arr3){
		var arr = new Array();
		excludeElements_chooseleader = new Array();
		excludeElements_chooseassisitant = new Array();
		excludeElements_choosejunior = new Array();
		excludeElements_chooseconfrere = new Array();
		if(jionArr == "leader"){
			if(arr1&&arr2&&arr3){
				arr = excludeElements_chooseleader.concat(arr1,arr2,arr3);
			}else if(arr1&&arr2){
				arr = excludeElements_chooseleader.concat(arr1,arr2);
			}else if(arr1&&arr3){
				arr = excludeElements_chooseleader.concat(arr1,arr3);
			}else if(arr2&&arr3){
				arr = excludeElements_chooseleader.concat(arr2,arr3);
			}else if(arr1){
				arr = excludeElements_chooseleader.concat(arr1);
			}else if(arr2){
				arr = excludeElements_chooseleader.concat(arr2);
			}else if(arr3){
				arr = excludeElements_chooseleader.concat(arr3);
			}
		}else if(jionArr == 'assistant'){
			if(arr1&&arr2&&arr3){
				arr = excludeElements_chooseassisitant.concat(arr1,arr2,arr3);
			}else if(arr1&&arr2){
				arr = excludeElements_chooseassisitant.concat(arr1,arr2);
			}else if(arr1&&arr3){
				arr = excludeElements_chooseassisitant.concat(arr1,arr3);
			}else if(arr2&&arr3){
				arr = excludeElements_chooseassisitant.concat(arr2,arr3);
			}else if(arr1){
				arr = excludeElements_chooseassisitant.concat(arr1);
			}else if(arr2){
				arr = excludeElements_chooseassisitant.concat(arr2);
			}else if(arr3){
				arr = excludeElements_chooseassisitant.concat(arr3);
			}
		}else if(jionArr == 'junior'){
			if(arr1&&arr2&&arr3){
				arr = excludeElements_choosejunior.concat(arr1,arr2,arr3);
			}else if(arr1&&arr2){
				arr = excludeElements_choosejunior.concat(arr1,arr2);
			}else if(arr1&&arr3){
				arr = excludeElements_choosejunior.concat(arr1,arr3);
			}else if(arr2&&arr3){
				arr = excludeElements_choosejunior.concat(arr2,arr3);
			}else if(arr1){
				arr = excludeElements_choosejunior.concat(arr1);
			}else if(arr2){
				arr = excludeElements_choosejunior.concat(arr2);
			}else if(arr3){
				arr = excludeElements_choosejunior.concat(arr3);
			}
		}else if(jionArr == 'confrere'){
			if(arr1&&arr2&&arr3){
				arr = excludeElements_chooseconfrere.concat(arr1,arr2,arr3);
			}else if(arr1&&arr2){
				arr = excludeElements_chooseconfrere.concat(arr1,arr2);
			}else if(arr1&&arr3){
				arr = excludeElements_chooseconfrere.concat(arr1,arr3);
			}else if(arr2&&arr3){
				arr = excludeElements_chooseconfrere.concat(arr2,arr3);
			}else if(arr1){
				arr = excludeElements_chooseconfrere.concat(arr1);
			}else if(arr2){
				arr = excludeElements_chooseconfrere.concat(arr2);
			}else if(arr3){
				arr = excludeElements_chooseconfrere.concat(arr3);
			}
		}
		return arr;
}