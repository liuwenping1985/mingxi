<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<script type="text/javascript">
var needSave=false;
var isA8geniusAdded;
try{
  var ufa = new ActiveXObject('UFIDA_IE_Addin.Assistance');
  isA8geniusAdded = true;
}catch(e){
  isA8geniusAdded = false;
}
var geniusSurfix = '&isA8geniusAdded=' + isA8geniusAdded;
var uptype=-1;
var uptype1=-1;
var uptype2=-1;
var imgSrc1=null;
var imgSrc2=null;
var imgSrc=null;
var maxSize=1024*1024;
var downloadURL = "<c:url value='/fileUpload.do?type=&applicationCategory=0&extensions=png&maxSize="+maxSize+"'/>";
var clindURL = "<c:url value='/m1/changeImgController.do'/>";
var imgAtt;
var imgURL;
var img;
var flage;
 function cansleImage()
  {
	needSave=false;
	location.reload();
  }
function sub()
  {
	  needSave=false;
	  var id=document.all.fileId1.value+","+document.all.fileId2.value;
	  var date=document.all.fileCreateDate1.value+","+document.all.fileCreateDate2.value;
	  var uptypes=uptype+","+uptype1;
	  
	  if(document.all.fileId1.value=="-1"&&document.all.fileId2.value=="-1"&&document.all.fileId3.value=="-1")
	  {
		alert("<fmt:message key='m1.skin.save.noupload' bundle='${mobileManageBundle}' />");
		return false;
	  }
  	if("true"=="${isSys}")
  	{
  		var cfirm ="<fmt:message key='m1.skin.save.sysbackdefault' bundle='${mobileManageBundle}' />";
        if("false"=="${isGroup}") {
            cfirm ="<fmt:message key='m1.skin.save.saveornot' bundle='${mobileManageBundle}' />";
        }
        if(confirm(cfirm)){
			location.href =clindURL+ "?method=uploadImg&fromw=eben&type="+uptypes+"&savaImg=true&toDefault=false&isSys=${isSys}&fileId1="+id+"&fileCreateDate1="+date;
			alert("<fmt:message key='m1.skin.save.success' bundle='${mobileManageBundle}' />");
		}
 	}
  	else
  	{
  	   location.href = clindURL+"?method=uploadImg&fromw=eben&type="+uptypes+"&savaImg=true&toDefault=false&isSys=${isSys}&fileId1="+id+"&fileCreateDate1="+date;
		 alert("<fmt:message key='m1.skin.save.success' bundle='${mobileManageBundle}' />");
	}
 }
	
	function showimg()
	{
		var m1vbg="${bgvpath}";
		var bgimg=document.all.bgpath.value;
		var limg=document.all.logopath.value;
		if(m1vbg.indexOf("&")>0)
			m1vbg=m1vbg.replace(/&/g,",");
		if(bgimg.indexOf("&")>0)
			bgimg=bgimg.replace(/&/g,",");
		if(limg.indexOf("&")>0)
			limg=limg.replace(/&/g,",");
		var url= clindURL+"?method=showImg&fromw=eben&m1vbg="+m1vbg+"&limg="+limg+"&bgimg="+bgimg;
		window.open(url,'newwin','height=700px,width=700px,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
		//openobj.showModalDialog((url,'','dialogWidth:700px,dialogHeight:700px');
	}
	function tix()
	{
	 if(needSave==true){
		 if(confirm("<fmt:message key='m1.skin.save.saveornot' bundle='${mobileManageBundle}' />")){
			 sub();
		 }
	 }
	}

	function restore_default()
	{
		 var info="<fmt:message key='m1.skin.save.returntoup' bundle='${mobileManageBundle}' />";
		 if("true"=="${isSys}"){
	           info="<fmt:message key='m1.skin.save.returntodefault' bundle='${mobileManageBundle}' />";
	           if("false"=="${isGroup}") {
	                info ="<fmt:message key='m1.skin.save.saveornot' bundle='${mobileManageBundle}' />";
	            }
	         }
		if(confirm(info)){
			location.href = clindURL+"?method=uploadImg&fromw=eben&savaImg=false&toDefault=true&isSys=${isSys}";
			alert("<fmt:message key='m1.skin.save.restoresuccess' bundle='${mobileManageBundle}' />");
            location.reload();
		}
	}
	function changeImage(flag)
	{
		 flage=flag;
		fileUploadQuantity = 1;
		var url = downloadURL + "&quantity=" + fileUploadQuantity;
		v3x.openWindow({
		url		: url,
		width	: 400,
		height	: 250,
		resizable	: "yes"
	});
		if(fileUploadAttachments.isEmpty())
		{
		   return ;
		}
		showMask();
		imgAtt = fileUploadAttachments.values().get(0);
		imgURL = "/seeyon/fileUpload.do?method=showRTE&fileId="+imgAtt.fileUrl+"&createDate="+imgAtt.createDate.substring(0, 10) + "&type=image";
		fileUploadAttachments.clear();
		img=new Image();
		
		img.src=imgURL;
		setTimeout("doCheck()",3500);
	
}
	 function doCheck()
	{
		var wid=img.width;
		var hgt=img.height;
		
		switch(flage)
		{
		 case 1:
				if(wid==768&&hgt==979)
				{
					imgSrc = imgURL;
					document.all.fileId1.value = imgAtt.fileUrl;
					document.all.fileCreateDate1.value = imgAtt.createDate.substring(0, 10);
					document.all.loginpageimg.src=imgURL;
					document.all.bgpath.value=imgURL;
					document.all.bgname.value=imgAtt.filename;
					uptype=6;
					needSave=true;
				}else
				{
					if((wid==28&&hgt==30)||(wid==0&&hgt==0))
					{
						setTimeout("doCheck()",1000);
					}else
					{
						alert("<fmt:message key='m1.skin.save.imgerrorsize' bundle='${mobileManageBundle}' />"+wid+"x"+hgt+",<fmt:message key='m1.skin.save.imgtruesize' bundle='${mobileManageBundle}' />768x979！");
					}
				}
				 break;

		 case 2:
				 if(wid==520&&hgt==440)
				{
					imgSrc = imgURL;
					document.all.fileId2.value = imgAtt.fileUrl;
					document.all.fileCreateDate2.value = imgAtt.createDate.substring(0, 10);
					document.all.logo.src=imgURL;
					document.all.logopath.value=imgURL;
					document.all.logoname.value=imgAtt.filename;
					uptype1=10;
					needSave=true;
				 }else
					{
					 if((wid==28&&hgt==30)||(wid==0&&hgt==0))
					{
						setTimeout("doCheck()",1000);
					}else
					{
						alert("<fmt:message key='m1.skin.save.imgerrorsize' bundle='${mobileManageBundle}' />"+wid+"x"+hgt+",<fmt:message key='m1.skin.save.imgtruesize' bundle='${mobileManageBundle}' />520x440！");
					}
					}
				 break;
		}
		hideMask();
	}
	
function divhidden()
{
	document.getElementById("editwordbg").style.display="none";
	document.getElementById("editword").style.display="none";
}
function divdisplay()
{
	document.getElementById("editwordbg").style.display="block";
	document.getElementById("editword").style.display="block";
	
}
 function computwords()
 {
	 var values=document.getElementById("hellovalue").innerText;
     
    if(values.trim()!=""&&values.length>0)
	 {
		if(values.length>24){
			values=values.substring(0,24);
			document.getElementById("hellovalue").innerText="";
			document.getElementById("hellovalue").innerText=values;
		}
		var length=24-values.length;
		if(length>0){
		document.getElementById("words").innerHTML="";
		document.getElementById("words").innerHTML="还可以输入"+length+"个字";
		}else
		 {
			document.getElementById("words").innerHTML="";
			document.getElementById("words").innerHTML="<font color='red'>已输入24个字，不能再输入。</font>";
		}
	 }

 }
 function returnword()
{
	
	var txt=document.getElementById("hellovalue").innerText;
	document.getElementById("helloword").innerHTML="";
	document.getElementById("helloword").innerHTML=txt;
	
	 needSave=true;
//	 document.getElementById("wordvalue").value=txt;//点击确定 div不能隐藏。
}
</script>
<style type="text/css">
	body{border-top: 2px #CDCDCD solid; }
	#dv1{position: relative;z-index:0;top:1%;left:10%;width:290px;height:300px;text-align:center;}
	#bgv{position:absolute;left:0px;top:0px;width:100%;height:100%;z-Index:-1; border:1px solid white；}
	#dv2{border-top:2px solid red;border-left:2px solid red;border-bottom:2px solid red;border-right:2px solid red;filter:alpha(opacity=75);background:#ffffff;position: absolute;top:33px;left:36px;width:195px;height:210px;}
	#loginpageimg{vertical-align:middle;width:100%;height:100%;}
	#dv3{border-top:2px solid red;border-left:2px solid red;border-bottom:2px solid red;border-right:2px solid red;filter:alpha(opacity=75);background:#ffffff;position: absolute;top:20%;left:28%;width:34%;height:27%;}
	#logo{vertical-align:middle;width:100%;}
	
 </style>
