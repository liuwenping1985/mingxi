<!DOCTYPE html>
<html>
	<head id='linkList'>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>print</title>
	    <script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
		<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
		<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.print-debug.js"></script>
		<style>
			@media print{
 				
  			}
		</style>
		<script>
	    //onload="printLoad();disabled($('context'));showOrDisableButton();loadSign();" style="overflow:hidden;" onbeforeunload="releaseISignatureHtmlObj();" id="bg"
		
function thisclose(){
     if(!window.close()){
     //如不能正常关闭，则调用IE的关闭命令
     	printIt(45);
     }
}
function printIt(n){
	if(n==1){
		window.print()
	}else{
		document.all.WebBrowser.ExecWB(n,1);
	}
}
function doChangeSize(changeType){
  var content = document.getElementById("context") ;
  if(content && content.style.zoom) {	
	    if(changeType == "bigger") {
	       thisMoreBig(content);
	    }else if(changeType == "smaller"){
	    	thisSmaller(content);
	    }else if(changeType == "self"){
	        thisToSelf(content);
	    }else if(changeType == "customize"){
	      thisCustomize(content) ;
	    }
  }
}
function thisMoreBig(content,size){
  if(!size){
    size = 0.01 ;
  }
  if(content){
    content.style.zoom = parseFloat(content.style.zoom) + size ;
    clearnText() ;
  }
}

function thisSmaller(content,size){
  if(!size){
    size = 0.01 ;
  }
  if(content){
    content.style.zoom = parseFloat(content.style.zoom) - size ;
    clearnText() ;
  }
}
function thisToSelf(content){
  if(content){
    content.style.zoom = 1 ;
    clearnText() ;
  }
}

function thisCustomize(content){
  var print8 = document.getElementById("print8") ;
  
  if(content && print8 && print8.value != "" ){
	  if(isNaN(print8.value)){
	    alert("缩放的大小必须是数字！") ;
	     return ;
	  }
     content.style.zoom = parseFloat(print8.value / 100) ;
  }
}	
function clearnText(){
	var print8 = document.getElementById("print8") ;
	var context = document.getElementById("context") ;
	if(print8 &&  context){
	  var size = context.style.zoom ;
	  print8.value = parseInt(size * 100) ;
	}
}	
		</script>
	</head>
	<body onload="printLoad()">
		<div id="header" class="header">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<OBJECT id=WebBrowser classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2 height=0 width=0></OBJECT>	  
						<input type=button id="print1" class="button buttonSmall"  value="打印" onclick="printIt(1)" />
						<input type=button id="print2" class="button"  value="打印设置" onclick="printIt(8)" /> 
						<input type=button id="print3" class="button"  value="打印预览"  onclick="printIt(7)" />
						<input type=button id="print4" class="button buttonSmall"  value="关闭" onclick="thisclose()" />
						<div class="hidden" id="_showOrDisableButton">
						<input type=button id="print5" class="button buttonSmall"  value="放大" onclick="doChangeSize('bigger')" />
						<input type=button id="print6" class="button buttonSmall"  value="缩小" onclick="doChangeSize('smaller')" />
						<input type=button id="print7" class="button buttonSmall"  value="还原" onclick="doChangeSize('self')" />
						<span style="font:12px;color:#1039b2;">自定义比例:</span><input type=text id="print8" class="input-date"    value="100"  onblur ="doChangeSize('customize')" />%
					    </div>
					</td>
					<td>
						<div id="checkOption"></div> 
					</td>
				</tr>
			</table>
		</div>	
		<div class="content" id="context" style="zoom:1;">
		</div>
	</body>
</html>
