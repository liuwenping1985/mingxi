
var description_win;
function showNodeDescription(){
	if(v3x.getBrowserFlag('OpenDivWindow')){
		var rv = v3x.openWindow({
		    url: genericControllerURL + "flowperm/node_description",
		    width: "350",
		    height: "400",
	        dialogType: "modal",
	        resizable: true
		});	
	}else{
		description_win = new MxtWindow({
	        id: 'description_win',
	        title: '',
	        url: genericControllerURL + "flowperm/node_description",
	        width: 440,
	        height: 400,
			type:'window',//类型window和panel为panel的时候title不显示
			isDrag:false
		});
	}
		
}
function showEdocNodeDescription(){
	if(v3x.getBrowserFlag('OpenDivWindow')){
		var rv = v3x.openWindow({
		    url: genericControllerURL + "flowperm/node_edoc_description",
		    width: "350",
		    height: "400",
	        dialogType: "modal",
	        resizable: true
		});		
	}else{
		description_win = new MxtWindow({
	        id: 'description_win',
	        title: '',
	        url: genericControllerURL + "flowperm/node_edoc_description",
	        width: 440,
	        height: 400,
			type:'window',//类型window和panel为panel的时候title不显示
			isDrag:false
		});
	}
}