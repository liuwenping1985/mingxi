<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
function getparamer()
{  
   var text=window.parentDialogObj["formInputChooseSortDialog"].getTransParams();
   var label=document.getElementById("sortdataname");
   label.innerText=text;      
  
}
function OK()
{
	var returnvalues;//返回的值
   var sortname=document.getElementById("sortdataname");
   if(sortname.innerText.indexOf("(") > -1)
	{
	   sortname.innerText = sortname.innerText.substring(0,sortname.innerText.indexOf("("));
	}
	else
	{
       sortname.innerText = sortname.innerText;
	}	
  var checkvalue=$(":input[name='sorttype'][checked]").val();//升序还是降序
  if(sortname.innerText==""){
  return 'false';
  }
			   if(checkvalue=="0"){		   
				   returnvalues = sortname.innerText+"↑";			  	  
				}else{
				   returnvalues = sortname.innerText+"↓";			  	  
				 }		    
	   return returnvalues;
	 
}
</script>