<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=m3StartPageCustomManager"></script>
<!DOCTYPE html>
<html class="h100b">
<head>
  <title>启动页设置</title>
  <link rel="stylesheet" type="text/css" href="${path}/apps_res/cip/css/startPageCustom.css${ctp:resSuffix()}"/>
</head>
<body class="h100b">
  <div class="spc_wrap">
  <input id="inputStartPageBgImg" type="hidden" class="comp hidden" comp="attachmentTrId:'startPageBgImg',type:'fileupload',applicationCategory:'54',
	maxSize:5242880,quantity:1, callMethod:'uploadCallBack',extensions:'jpg,png', takeOver:false,firstSave:true" 
	attsdata='${ attachmentsJSON}'>
    <form id="form1" name="form1" method="post" action="">
      <div class="companyLogo">
        <div class="title_l">${ctp:i18n('cip.service.startpage.account.logo')}：</div>
        <div class="info_r com_t">
          <div class="showImg">
            <img id="loginPath" src=""  class="uploadLogo" name="fileImg" alt=""/>
            <i class="closeImg"></i>
          </div>
          <a href="javascript:void(0);" class="upload_btn file_click" onclick="insertAttachment()">
            <div   class="file" ></div>
            <input id="iconInput" type="hidden" class="comp" comp="type:'fileupload', applicationCategory:'39',  
							        	extensions:'png,jpg', isEncrypt:false,quantity:1,maxSize: 1048576,
							            canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'iconUploadCallback'">
          </a>
          <div class="promptInfo">
            <p>${ctp:i18n('cip.service.startpage.img.type')}</p>
            <P>${ctp:i18n('cip.service.startpage.img.size')}</P>
          </div>
        </div>
      </div>
      <div class="motto">
        <div class="title_l">${ctp:i18n('cip.service.startpage.say')}：</div>
        <div class="info_r">
          <textarea id="knowSay" onKeyDown="checkWord(this)" onKeyUp="checkWord(this)" onfocus="if(value=='${ctp:i18n('cip.service.startpage.tip.click')}'){value='';}" onblur="if (value ==''){value='${ctp:i18n('cip.service.startpage.tip.click')}';document.getElementById('knowSay').style.color='#999';}">${ctp:i18n('cip.service.startpage.tip.click')}</textarea>
          <!-- <textarea id="motto_info" placeholder="点击添加内容" onKeyDown="checkWord(this)" onKeyUp="checkWord(this)"></textarea> -->
          <p class="over">${ctp:i18n('cip.service.startpage.text.con1')}<span id="word_check">15</span>${ctp:i18n('cip.service.startpage.text.con2')}</p>
        </div>
      </div>
      <div class="company_s_page">
        <div class="title_l">${ctp:i18n('cip.service.startpage.account.start.page')}：</div>
        <div class="info_r">
          <div class="phone_img"><img src="${path}/apps_res/cip/img/phone.png" width="240"/></div>
          <div class="p_bg">
            <div class="p_bg_pos">
              <img class="logo_img" src="" width="64" id="logo_img" style="display: none;"/>
			  <div class="c_name"><span id="show_name"></span></div>
              <p class="c_motto" id="c_motto"></p>
             
            </div>
          </div>
          <div class="p_info_r">
            <h3>${ctp:i18n('cip.service.startpage.content')}</h3>
            <div class="d_logo">
              <label class="label_logo" for="dis_logo"><input id="dis_logo" value="1" class="dis_logo" type="checkbox" checked="">${ctp:i18n('m3.app.start.islogo')}</label>
            </div>
			<div class="d_name">
              <label class="label_name" for="dis_name"><input id="dis_name" value="1" class="dis_name" type="checkbox" checked="">${ctp:i18n('m3.app.start.isaccountname')}</label>
            </div>
            <div class="d_motto">
              <label class="label_motto" for="dis_motto"><input id="dis_motto" value="1" class="dis_motto" type="checkbox" disabled>${ctp:i18n('m3.app.start.isknowsay')}</label>
            </div>
       
            <h3>${ctp:i18n('cip.service.startpage.background.color.select')}</h3>
            <div class="bg_list_div">
              <ul class="bg_list clearfix " id="bcolor">
                <!--<li  bc="#61AFFF" class="bg_current">
                  <a href="javascript:void(0);">
                      -- <img src="/seeyon/startPageCustom/img/bg1.png" width="120"/> --
                  </a>
                  <span>${ctp:i18n('m3.app.start.blue')}</span>
                </li>
                <li bc="#59D984">
                  <a href="javascript:void(0);">
                      -- <img src="/seeyon/startPageCustom/img/bg2.png" width="120"/> --
                  </a>
                  <span>${ctp:i18n('m3.app.start.green')}</span>
                </li>
                <li bc="#FF806C">
                  <a href="javascript:void(0);">
                      -- <img src="/seeyon/startPageCustom/img/bg3.png" width="120"/> --
                  </a>
                  <span>${ctp:i18n('m3.app.start.red')}</span>
                </li>
                <li bc="#FFCA57">
                  <a href="javascript:void(0);">
                      -- <img src="/seeyon/startPageCustom/img/bg4.png" width="120"/> --
                  </a>
                  <span>${ctp:i18n('m3.app.start.pink')}</span>
                </li>
                <li bc="#9B65FF">
                  <a href="javascript:void(0);">
                      <img src="/seeyon/startPageCustom/img/bg5.png" width="120"/>
                  </a>
                  <span>${ctp:i18n('m3.app.start.purple')}</span>
                </li>-->
                <li bc="#CCCCCC" class="ul_li_phone_bg">
                  <a href="javascript:void(0);" m3-type="uploadFile">
					${ctp:i18n('m3.startpage.button.upload.img')}
                      <!-- <img src="/seeyon/startPageCustom/img/bg5.png" width="120"/> -->
                  </a>
                  <span></span>
                </li>
                &nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('m3.startpage.upload.bg.img.info')}
                <!-- 暂时不加该功能 -->
                <!-- <li>
                  <a href="javascript:void(0);" onclick="">
                      <img src="/seeyon/startPageCustom/img/custom.png" width="120"/>
                  </a>
                  <span>自定义</span>
                </li> -->
              </ul>
            </div>
          </div>
        </div>
      </div>
           <div class="footer_btns">
        <input class="common_button common_button_gray" id="btdefault" type="button" value="${ctp:i18n('space.button.toDefault')}">
        <input class="common_button common_button_emphasize" id="btnok" type="button" value="${ctp:i18n('common.button.ok.label')}">
        <input class="common_button common_button_gray" id="btncancel" type="button" value="${ctp:i18n('common.button.cancel.label')}">
      </div>
    </form>
  </div>
  <script type="text/javascript" src="${path}/apps_res/m3/js/startPage.js"></script>
  <script type="text/javascript">
  var MSG = {
	  UPLOAD_IMAGE_ALERT : "${ctp:i18n('m3.app.start.upload.image.alert')}"
  }
  function iconUploadCallback(obj) {
		var attList = obj.instance;
		var len = attList.length;
		for(var i = 0; i < len; i++) {
			var att = attList[i];
			var fileID = att.fileUrl;
			var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : new Date().newFormat("yyyy-MM-dd");
			var iconDownloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image&showType=nosmall";
			showImag(iconDownloadUrl);
			checkLogoValue();
		}
	}
function showImag(iconDownloadUrl){
     // 将上传的logo显示在手机模型中
     // $(".logo_img").attr("src",iconDownloadUrl);
     $(".logo_img").css("display","none");
     $("#dis_logo").removeAttr("disabled").attr("checked","checked");
     $(".showImg").css("display","inline-block");
    // 将图片显示在上传图片按钮前方
	 //$("#loginPath").attr('src',iconDownloadUrl).attr("width",80).height("height",80).css("display","inline-block");; 
 
}
  $(document).ready(function(){
	    $("#btncancel").click(function() {
	        location.reload();
	    });
	    $("#btdefault").click(function(){
	    	
	        $.confirm({
	            'msg': "${ctp:i18n('cip.service.startpage.confirm')}",
	            ok_fn: function() {
	                if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
	                try{
	                	 var rm = new m3StartPageCustomManager();
	                	 rm.transDefaultSet("${param.phoneType}","${ctp:currentUser().accountId}");
	                     getCtpTop().endProc();
	                 	 location.reload();      
	                 }catch(e){
	                	  getCtpTop().endProc();
	                 };
	            }
	        });
	    });

	    $("#btnok").click(function() {
			var accountLogo = $("#loginPath").attr("src");
			if(!accountLogo){
				accountLogo = "";
			}
			var knowSay = $("#knowSay").val();
			if("${ctp:i18n('cip.service.startpage.tip.click')}"===knowSay){
				knowSay="";
			}else{
				/*var reg=/^[\u4E00-\u9FA5]*$/g;
            if (!reg.test(knowSay)){
			  $.alert("${ctp:i18n('cip.service.startpage.say')}"+"${ctp:i18n('cip.m3.startcustom.chinesecharacters.error.tip')}");
			  return;
			  } */
			}
			var isShowLogo = $("#dis_logo").attr("checked")=="checked";
			var isShowKnowSay = $("#dis_motto").attr("checked")=="checked";
			var isShowAccountName = $("#dis_name").attr("checked")=="checked";
			var active=$("#bcolor").find(".bg_current");
			var bgc = "";
			var bgimg = "";
			var bgValue = active.attr("bc");
			if (bgValue && bgValue.substring(0, 1) == "#") {
				bgc = bgValue;
			} else {
				bgimg = bgValue;
			}
			
			if (!bgimg || bgimg == "") {
				$.alert("请上传图片!");
				return;
			}
			
	        var data = {"loginPath":accountLogo,
	        		    "knowSay":knowSay,
	        		    "showLogo":isShowLogo,
	        		    "showKnowSay":isShowKnowSay,
	        		    "showAccountName":isShowAccountName,
	        		    "backgroundColor":bgc,
						"backgroundImage":bgimg,
	        		    "phoneType":"${param.phoneType}" };
	         
	        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
	        try{
	        	 var rm = new m3StartPageCustomManager();
	             rm.saveStartPageCustom(data, {
	                 success: function(rel) {
	     				location.reload();                
	                 },
	                 error:function(returnVal){
	                   var sVal=$.parseJSON(returnVal.responseText);
	                   $.alert(sVal.message);
	               }
	             });
	           
	         }catch(e){
	        	 alert(e);
	         };
	        
	        				                                                               
	    });
    
    	
    // 鼠标移动到logo上方，出现关闭按钮
    $(".showImg").hover(function(){
      $(".closeImg").css("display","block");
    },function(){
      $(".closeImg").css("display","none");
    });

    // 点击logo上方的关闭按钮，将其logo删除
    $(".closeImg").on("click",function(){
      $(this).css("display","none");
      $(".uploadLogo").removeAttr("src").css("display","none");
      $(".showImg").css("display","none");

      // 将logo显示到手机模型的相应位置
      $(".logo_img").removeAttr("src");
      $("#loginPath").removeAttr('src');
      $("#dis_logo").attr("disabled","true").removeAttr("checked");
      checkLogoValue();
    });
    
    init("${accountName}", 
		"${custom.backgroundColor}", 
		'${custom.backgroundImage}', 
		"${custom.loginPath}", 
		"${ctp:escapeJavascript(custom.knowSay)}", "${custom.showLogo}", "${custom.showAccountName}");
  });
	
    // 将显示单位logo的复选框勾选上；
    function checkLogoValue() {
      var ele = $(".uploadLogo")[0].style.display;
      if(ele !== "none") {//true
        $("#dis_logo").removeAttr("disabled").attr("checked","checked");
      }
      else {
        $("#dis_logo").attr("disabled","true").removeAttr("checked");
      }
      // removeLogoToPhone();
    }

    //返回选取的图片的路径
    function getPath(obj) {
      if (obj) {
          // if (window.navigator.userAgent.indexOf("MSIE") >=1) {
          //     obj.select(); 
          //     return document.selection.createRange().text;
          // }
          // else if (window.navigator.userAgent.indexOf("Firefox") >=1) {
          //     if (obj.files) {
          //         return obj.files.item(0).getAsDataURL();
          //     }
          //     return obj.value;
          // }
          return obj.value;
      }
    }
    
      
    var maxstrlen = 15;//总的汉字个数
    function ele(s) { 
      return document.getElementById(s); 
    }  

    // 汉字占用两个字节，英文字母和数字占用一个字节，返回总的字节数
    function getStrleng(str) {  
        myLen = 0;  
        i = 0;  
        for (; (i < str.length) && (myLen <= maxstrlen * 2); i++) {  
            if (str.charCodeAt(i) > 0 && str.charCodeAt(i) < 128) {
              myLen++;
            } 
            else {
              myLen += 2;
            }  
        }  
        return myLen;  
    }  

    // 检查用户输入的字符个数，超过30个字符，即不可再输入
    function checkWord(c) {  
        len = maxstrlen;  
        var str = c.value;  
        myLen = getStrleng(str); 
        var wck = ele("word_check");  
        if (myLen > len * 2) {  
            c.value = str.substring(0, i - 1);  
        }  
        else {  
            wck.innerHTML = Math.floor((len * 2 - myLen) / 2);  
        }  
        // 实时监控用户填写的单位座右铭内容；
        getMottoValue();
    }  

    // 将显示单位座右铭的复选框勾选上；
    function getMottoValue() {
      info = ele("knowSay"); 
      if(info.value) {//true
        $("#dis_motto").removeAttr("disabled").attr("checked","checked");
      }
      else {
        $("#dis_motto").attr("disabled","true").removeAttr("checked");
      }
      showMottoToPhone();
    }

    // 并且将座右铭显示到手机模型的相应位置
    function showMottoToPhone() {
      $("#c_motto").css("display","block");
	  
	  var val = ele("knowSay").value;
	  val = val.replace(/</g, "&lt").replace(/>/g, "&gt");
	  
      ele("c_motto").innerHTML = val;
    }

    
    function clickCk(elem1,elem2){
      $(elem1).click(function(){
        if($(elem1).attr("checked")){
          $(elem2).css("display","block");
          $(elem1).attr("checked","checked");
        }
        else {
          $(elem2).css("display","none");
          $(elem1).removeAttr("checked");
        }
      });
    }
    // 单独手动点击显示 公司logo 复选框时，显示或隐藏手机模型中的 单位logo
    clickCk("#dis_motto",".c_motto");

    // 单独手动点击显示 单位座右铭 复选框时，显示或隐藏手机模型中的 单位座右铭
    clickCk("#dis_logo",".logo_img");

    // 单独手动点击显示 单位名称 复选框时，显示或隐藏手机模型中的 单位名称
    clickCk("#dis_name","#show_name");
   
    // 点击其中一种选择背景后，将其背景框添加绿色边框
    $(".bg_list li").each(function(){
		(function(obj){
			$(obj).click(function(){
				$(".bg_list li").removeClass("bg_current");
				$(obj).addClass("bg_current");
				changeBg(obj, true);
			});
		})(this);
    });

    // 单独手动选择其中一种背景后，改变手机模型的背景色	
	function changeBg(elem, isClick) {
		var m3Type = $(elem).find("a").attr("m3-type");
		if (m3Type && m3Type == "uploadFile" && isClick) {
			uploadBackgorundImage();
		} else {
			var bcImg = $(elem).attr("bc");
			var type = bcImg.substring(0, 1);
			if (type && type == "#") {
				/* var path = $(elem).find("a").attr("style");
				path = path.split("background:")[1].trim(); */
				$(".p_bg").css("background", bcImg);
			} else {
				try {
					bcImg = JSON.parse(bcImg);
				} catch (e) {
					bcImg = "";
				}
				var url = "url('${path}/apps_res/m3/images/startPageImg.png') no-repeat";
				if (bcImg && bcImg!="") {
					url = "url('" + getImageUrl(bcImg.fileId, bcImg.createDate) + "') no-repeat";
				}
				$(".p_bg").css("background",url);
				$(".p_bg").css("background-size","100%");
			}
		}
	}

    // 定义背景色数组，也许会从后台动态获取
    //var bgArr = ["#cfcfcf","${path}/apps_res/cip/img/bg2.png","${path}/apps_res/cip/img/bg3.png","${path}/apps_res/cip/img/bg4.png","${path}/apps_res/cip/img/bg5.png"];
var bgArr = ["#61AFFF","#59D984","#FF806C","#FFCA57","#9B65FF", "#CCCCCC"];
    
  </script>
</body>
</html>