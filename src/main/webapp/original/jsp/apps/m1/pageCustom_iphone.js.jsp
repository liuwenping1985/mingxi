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
var imgSrc=null;
var uptype=-1;
var uptype1=-1;
var uptype2=-1;
var uptype3=-1;
var maxSize=1024*1024;
var downloadURL = "<c:url value='/fileUpload.do?type=&applicationCategory=0&extensions=png&maxSize="+maxSize+"'/>"
		//"<html:link renderURL='/fileUpload.do?type=&applicationCategory=0&extensions=png&maxSize="+maxSize+"'/>";
var clindURL =" <c:url value='/m1/changeImgController.do'/>";
	 //"<html:link renderURL='/m1/changeImgController.do'/>";
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
	  var id=document.all.fileId1.value+","+document.all.fileId2.value+","+document.all.fileId4.value;
	  var date=document.all.fileCreateDate1.value+","+document.all.fileCreateDate2.value+","+document.all.fileCreateDate4.value;
	  var uptypes=uptype+","+uptype1+","+uptype3;
	  
	  if(document.all.fileId1.value=="-1"&&document.all.fileId2.value=="-1"&&document.all.fileId4.value=="-1")
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
			location.href =clindURL+ "?method=uploadImg&fromw=iphone&type="+uptypes+"&savaImg=true&toDefault=false&isSys=${isSys}&fileId1="+id+"&fileCreateDate1="+date;
			alert("<fmt:message key='m1.skin.save.success' bundle='${mobileManageBundle}' />");
			}
 	}
  	else
  	{
  	   location.href = clindURL+"?method=uploadImg&fromw=iphone&type="+uptypes+"&savaImg=true&toDefault=false&isSys=${isSys}&fileId1="+id+"&fileCreateDate1="+date;
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
		var url= clindURL+"?method=showImg&fromw=iphone&m1vbg="+m1vbg+"&limg="+limg+"&bgimg="+bgimg;
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
			location.href = clindURL+"?method=uploadImg&fromw=iphone&savaImg=false&toDefault=true&isSys=${isSys}";
			alert("<fmt:message key='m1.skin.save.restoresuccess' bundle='${mobileManageBundle}' />");
            location.reload();
		}
	}
	 function doCheck()
	{
		var wid=img.width;
		var hgt=img.height;
		
		switch(flage)
		{
		 case 1://bg
				if(wid==640&&hgt==920)
				{
					imgSrc = imgURL;
					document.all.fileId1.value = imgAtt.fileUrl;
					document.all.fileCreateDate1.value = imgAtt.createDate.substring(0, 10);
					document.all.loginpage.src=imgURL;
					document.all.bgpath.value=imgURL;
					document.all.bgname.value=imgAtt.filename;
					uptype=2;
					needSave=true;
				}else
				{
					if((wid==28&&hgt==30)||(wid==0&&hgt==0))
					{
						setTimeout("doCheck()",1000);
					}else
					{
					alert("<fmt:message key='m1.skin.save.imgerrorsize' bundle='${mobileManageBundle}' />"+wid+"x"+hgt+",<fmt:message key='m1.skin.save.imgtruesize' bundle='${mobileManageBundle}' />640x920！");
					}
				}
				 break;

		 case 3://blogo
				 if(wid==320&&hgt==270)
				{
					imgSrc = imgURL;
					document.all.fileId2.value = imgAtt.fileUrl;
					document.all.fileCreateDate2.value = imgAtt.createDate.substring(0, 10);
					document.all.logo.src=imgURL;
					document.all.logopath.value=imgURL;
					document.all.blogoname.value=imgAtt.filename;
					uptype1=3;
					needSave=true;
				 }else
					{
					  if((wid==28&&hgt==30)||(wid==0&&hgt==0))
						{
							setTimeout("doCheck()",1000);
						}else
						{
							alert("<fmt:message key='m1.skin.save.imgerrorsize' bundle='${mobileManageBundle}' />"+wid+"x"+hgt+",<fmt:message key='m1.skin.save.imgtruesize' bundle='${mobileManageBundle}' />320x270！");
						}
					}
				 break;
	   
		case 5://iphone5
				 if(wid==640&&hgt==1096)
				{
					imgSrc = imgURL;
					document.all.fileId4.value = imgAtt.fileUrl;
					document.all.fileCreateDate4.value = imgAtt.createDate.substring(0, 10);
					document.all.bgpath5.value=imgURL;
					document.all.bgname5.value=imgAtt.filename;
					uptype3=7;
					needSave=true;
				 }else
					{
						 if((wid==28&&hgt==30)||(wid==0&&hgt==0))
						{
							setTimeout("doCheck()",1000);
						}else
						{
							alert("<fmt:message key='m1.skin.save.imgerrorsize' bundle='${mobileManageBundle}' />"+wid+"x"+hgt+",<fmt:message key='m1.skin.save.imgtruesize' bundle='${mobileManageBundle}' />640x1096！");
						}
					}
				 break;
		}
		hideMask();
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
	//alert(wid+"x"+hgt);
}
</script>
<style type="text/css">
	#dv2{border-top:2px solid red;border-left:2px solid red;border-bottom:2px solid red;border-right:2px solid red;filter:alpha(opacity=70);background:#ffffff;position: absolute;top:70px;left:23px;width:155px;height:182px;}
	#dv1{position: relative;z-index:0;top:0%;left:18%;width:200px;height:320px;text-align:bottom;}
	#bgv{position:absolute;left:0;top:0px;width:100%;height:100%;z-Index:-1; border:1px solid white;}
	#loginpage{vertical-align:middle;width:100%;height:100%;}
	#dv5{border-top:2px solid red;border-left:2px solid red;border-bottom:2px solid red;border-right:2px solid red;filter:alpha(opacity=70);
	background:#ffffff;position: absolute;top:28%;left:29%;width:42%;height:22%;}
	#logo{vertical-align:middle;width:100%;height:100%;}
	
	
 </style>
