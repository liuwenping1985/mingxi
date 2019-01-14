<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.apps.cip.enums.AccessTypeEnum" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=registerManager"></script>
<%
AccessTypeEnum[] ff = AccessTypeEnum.values();
request.setAttribute("accessTypeList", ff);
%>
<script type="text/javascript">

	function iconUploadCallback(obj) {
		var attList = obj.instance;
		var len = attList.length;
	    var iconType = $("input[name=icontype]:checked").val();
		for(var i = 0; i < len; i++) {
			var att = attList[i];
			var fileID = att.fileUrl;
			var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : new Date().format("yyyy-MM-dd");

			var iconDownloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
			var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon"+iconType+"' src='" + iconDownloadUrl + "' width='75' height='75'>";

			var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
			//return {"iconValue":iconValue,"imageArea":imageAreaStr};
			if(iconType=="0"){
				 $("#iconPC").val(iconValue);
				 $("#iconDiv1").html(imageAreaStr);
			}else{
				   $("#iconH5").val(iconValue);
				   $("#iconDiv2").html(imageAreaStr);
			}
		}
	}
$().ready(function() {
	var tipMap = new Properties();
	var paramCache = new Properties();
	var versionCache = new Properties();
	tipMap.put("versionNO","${ctp:i18n('cip.manager.register.tip.versionno')}");
	tipMap.put("appName","${ctp:i18n('cip.manager.register.tip.appname')}");
	tipMap.put("versionIntroduction","${ctp:i18n('cip.manager.register.tip.version')}");
	tipMap.put("appProvider","${ctp:i18n('cip.manager.register.tip.appaccess')}");
	tipMap.put("servicePCURL","${ctp:i18n('cip.manager.register.tip.url')}");
	tipMap.put("serviceH5URL","${ctp:i18n('cip.manager.register.tip.url')}");
	   $("#registerForm").hide();
	   var rm=new registerManager();
	   var pr = new productRegisterManager();
	    
		function showParam(productId,productVersionId,paramObject){
			
	    	var params = pr.showParams(productId,productVersionId);
	    	var tableS=new StringBuffer();
	    	
	    	for(var i=0;i<params.length;i++){
	    		var o = params[i];
	    		if(o.paramName!=""){
	    			
	    			var dataT = o.dataType;
	    			if(dataT=="1"){
	    				dataT="string";
	    			}else{
	    				dataT="number";
	    			}
	    			tableS.append("<tr>");
					tableS.append("<td><div class=\"common_txtbox_wrap\">");
					tableS.append( "<input type=\"text\" disabled=\"disabled\" id=\"paramName"+i +"\" class=\"validate word_break_all\" value=\""+o.paramName+"\">");
					tableS.append("</div></td>");
					tableS.append("<td><div class=\"common_txtbox_wrap \">");
					tableS.append("<input type='text' disabled=\"disabled\" id='paramDes"+i+"' value=\""+escapeStringToHTML(o.paramDes)+"\" class='validate word_break_all'>");
					tableS.append("</div></td>"); 
					tableS.append("<td><div class=\"common_txtbox_wrap \">");
					if(null!=paramObject&&""!=paramObject&&"null"!=paramObject&&paramObject!= undefined){
					  var paramValueG =	paramObject[o.paramName];
					  if(""!=paramValueG&&paramValueG!= undefined){
						  paramValueG = escapeStringToHTML(unescape(paramValueG));
					  }else{
						  paramValueG = "";
					  }
					 // tableS.append("<input type='text'  id='paramValue"+i+"' value='"+paramValueG+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+o.required+"\">");
					  tableS.append("<input type='text'  id='paramValue"+i+"' value='"+paramValueG+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+false+"\">");
					}else{
					  //tableS.append("<input type='text'  id='paramValue"+i+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+o.required+"\">");
					    tableS.append("<input type='text'  id='paramValue"+i+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+false+"\">");
					}
					tableS.append("</div></td>"); 
					tableS.append("</tr>");
	    		}
	    	}
	    	
			 
			$("#mobody").html(tableS.toString());
			
		}
	   function imageShow(){
		   $("#iconDiv1").empty();
		   $("#iconDiv2").empty();
		  	var pc=$('#iconPC').val();
	    	var h5=$('#iconH5').val();
	    	if(pc!=null&&pc!=""){
	  	     $("#iconDiv1").html(createImage(pc,0));
	  	     $("input[name=icontype][value=0]").attr("checked","checked");
	    	}
	    	 if(h5!=null&&h5!=""){
		      $("#iconDiv2").html(createImage(h5,1));
		      $("input[name=icontype][value=1]").attr("checked","checked");
	    	 }
	    	 if(typeof($("input[name=icontype]").attr("checked"))=='undefined'){
	    		 $("input[name=icontype][value=0]").attr("checked","checked");
	    	 }
	   }
        function createImage(url,type){
        	return  "<img name='imgIcon' id = 'imgIcon"+type+"' src='${path}" + url + "' width='75' height='75'>";
        }
		function createOption(value, text) {
			var option = document.createElement("option");
			option.value = value;
			option.text = text;
			
			return option;
		}
		function initSelect(detail){
            var joinType = document.getElementById("accessMethod");
            $("#accessMethod").empty();
            <c:forEach items="${accessTypeList}" var="data">
              var item = createOption("${data.value}", "${data.text}");
               joinType.add(item);
               if(detail){
                if("${data.value}"==detail.accessMethod){
                	item.selected=true;
                }
            	   
               }
    		</c:forEach>
    		var product = document.getElementById("productId");
    	   	product.options.length= 0; 
    	   	var empty = createOption("", "");
    	   	product.add(empty);
    	    paramCache.clear();
    	    <c:forEach items="${productList}" var="data">
    	      var id = "${data.id}".toString();
    	      var item = createOption(id, "${data.productCode}");
    	      product.add(item);
    	      var list = new ArrayList();
    	         <c:forEach items="${data.productItemList}" var="version">
    	            list.add("<option value=\""+"${version.versionId}"+"\">"+"${version.versionNO}"+"</option>");
    	            versionCache.put(id+"${version.versionId}","${version.versionMemo}");
    	         </c:forEach>
    	        
    	         paramCache.put(id,list);
    		</c:forEach>
    		  if(detail){
 			 	 var list = paramCache.get(detail.productId);
 			 	 if(list){
 			 	 var pVersion=$("#versionNO");
 			 	pVersion.empty();
 		    	for(var i=0;i<list.size();i++){
 		    		pVersion.append(list.get(i));
 		    	}
 			 	 }
 		    	 $("#versionNO option[value='"+detail.versionNO+"']").attr("selected", true); 
 		    	 $("#productId option[value='"+detail.productId+"']").attr("selected", true); 
    		  }
		}
		   $("#productId").change(function () { 
		        var productId = $("#productId  option:selected").val();
		        if(null != productId && "" != productId){
		        	$("#versionNO").empty();
		        	var list =paramCache.get(productId);
		        	var version = $("#versionNO");
		        	version.append("<option value=\"\"></option>");
	    				for(var i=0;i<list.size();i++){
	    					version.append(list.get(i));
		        	}
		        		}
		   });
		   
		   $("#versionNO").change(function () { 
		        var productVersionVal = $("#versionNO  option:selected").text();
		        var productVersionId = $("#versionNO  option:selected").val();
		        var productName = $("#productId  option:selected").text();
		        var productId = $("#productId  option:selected").val();
		        if(productName==""){
		           $.alert("${ctp:i18n('cip.base.instance.tip')}");
		           return;
		        }
		       $("#versionIntroduction").val(versionCache.get(productId+productVersionId)); 
		        if(null != productVersionVal && "" != productVersionVal){
	   			    //var code  =ri.getInstanceCode();
		            //var sysCode = $("#systemCode");
			       // sysCode.val(productName+productVersionVal+code);
			        
			        showParam(productId,productVersionId,null);
			
					//alert(JSON.stringify(params));
		        }
		   });
		function init(){
			$("#registerForm").enable();
	    	$("#registerForm").show();
	    	$("#welcome").hide();
	        $("#button").show();
	        $("#iconPC").val("");
			 $("#iconDiv1").html("");
			 $("#iconH5").val("");
			 $("#iconDiv2").html("");
		}
		function initURL(){
			if($("input[name=joinType][value=0]").attr("checked")=="checked"){
					$(".manager").show();
					//$(".appPack").hide();
			}else{
				$(".manager").hide();
				//$(".appPack").show();
			}
		}
		function initBlur(){
			$(":text").blur(function() {
				if($(this).attr("id")=="appName"){
				var appNameValue = $(this).val();
				if(appNameValue!=null&&appNameValue!==""){
					
		        if(rm.checkSameAppName($("#id").val(),appNameValue)){
		        	$(this).val("");
		        	$(this).focus();
		        	$.alert("${ctp:i18n('cip.manager.register.tip.namesame')}");
		        }
				}else{
					$(this).val(tipMap.get($(this).attr("id")));
				}
				}else{
					
				if($(this).val()==""){
					$(this).val(tipMap.get($(this).attr("id")));
				}
				}
			    });
		}
		function initInput(){
			//$("#versionNO").val(tipMap.get("versionNO"));
	        $("input[name=appName]").val(tipMap.get("appName"));
			$("#introduction").val(tipMap.get("introduction"));
			$("#versionIntroduction").val(tipMap.get("versionIntroduction"));
			$("#appProvider").val(tipMap.get("appProvider"));
			
			 //$("input[name=serviceH5URL]").val(tipMap.get("serviceH5URL"));
			$(":text").focus(function() {
				 if($(this).val()==tipMap.get($(this).attr("id"))){
			          $(this).val("");
				 }
			    });
			initBlur();
			
		}
	   function addform(){
		   $("#addForm").clearform({clearHidden:true});
		   $("#id").val(-1);
		   $("#appCodetr").hide();
	        init();
		   initSelect();
		   initInput();
		   //initURL();
		   $("input[name=icontype][value=0]").attr("checked","checked");
	       mytable.grid.resizeGridUpDown('up');
	       initDeleteImg();
	    }
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'appName',
          name: 'appName',
          type: 'input',
          text: "${ctp:i18n('cip.manager.register.appname')}",
          value: 'appName'
        },
        {
            id: 'appCode',
            name: 'app_code',
            type: 'input',
            text: "${ctp:i18n('cip.manager.register.appcode')}",
            value: 'app_code'
          },
          {
              id: 'productCode',
              name: 'product_code',
              type: 'input',
              text: "${ctp:i18n('cip.base.register.product')}",
              value: 'product_code'
            },
          {
              id: 'accessType',
              name: 'access_method',
              type: 'select',
              text: "${ctp:i18n('cip.manager.register.access')}",
              value: 'access_method',
              codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
            },
            {
                id: 'introduction',
                name: 'introduction',
                type: 'input',
                text: "${ctp:i18n('cip.base.instance.introduce')}",
                value: 'introduction'
              }
        ]
      });
    $("#toolbar").toolbar({
        toolbar: [{
          id: "add",
          name: "${ctp:i18n('common.toolbar.new.label')}",
          className: "ico16",
          click: function() {
        	  addform();
          }
      },
      {
          id: "modify",
          name: "${ctp:i18n('common.button.modify.label')}",
          className: "ico16 editor_16",
          click: griddbclick
      },
		{
          id: "packManager",
          name: "${ctp:i18n('cip.manager.register.appPackageManager')}",
          className: "ico16 system_16",
          click: openPackPage
      },
      {
        id: "delete",
        name: "${ctp:i18n('common.button.delete.label')}",
        className: "ico16 del_16",
        click: function() {
            var v = $("#mytable").formobj({
                gridFilter : function(data, row) {
                  return $("input:checkbox", row)[0].checked;
                }
              });
            if (v.length < 1) {
                $.alert("${ctp:i18n('level.delete')}");
            } else {
            	for(var i = 0; i < v.length; i++) {
            		if(rm.checkIsExistConfig(v[i].id)){
            			$.alert("${ctp:i18n('cip.manager.register.tip.configexist')}");
            			return;
            		}
            	}

                $.confirm({
                    'msg': "${ctp:i18n('common.isdelete.label')}",
                    ok_fn: function() {
                      rm.deleteRegisterPO(v, {
                                success: function() {
                                	  location.reload();
                                }
                            });
                    }
                });
            };
        }
    }
        ]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,     
        vChange: true,
        render: rend,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        colModel: [
        {
     	 display:"id",
          name: 'id',
          width: '5%',
          sortable: true,
          type: 'checkbox'
        }, 
        {
          display: "${ctp:i18n('cip.manager.register.appname')}",
          name: 'appName',
          width: '30%',
          sortable: true
        }, 
        {
           display: "${ctp:i18n('cip.manager.register.appcode')}",
           name: 'appCode',
           width: '10%',
           sortable: true
          }, 
        {
            display: "${ctp:i18n('cip.base.register.product')}",
            sortable: true,
            name: 'productCode',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.manager.register.versionno')}",
            sortable: true,
            name: 'versionNO',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.base.instance.introduce')}",
            sortable: true,
            name: 'introduction',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.manager.register.access')}",
            sortable: true,
            name: 'accessMethod',
            width: '25%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
        },
        {
            display: "${ctp:i18n('cip.base.instance.addr')}",
            sortable: true,
            name: 'addr',
            width: '15%'
        }
        ],
        width: "auto",
        managerName: "registerManager",
        managerMethod: "listRegister",
        parentId:'center'
    });
    
    function rend(txt, data, r, c) {
		   
		if (data.addr!=null&&data.addr!=""&&c==7) {
		      return unescape(txt);
		}else{
			return txt;
			}
	  }
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);

    function gridclk(data, r, c) {
    	  $("#addForm").clearform({clearHidden:true});
    	$("#addForm").disable();
    	$("#registerForm").show();
    	$("#button").hide();
    	$("#welcome").hide();
    	var detail=  rm.getRegisterVO(data.id);
    	$("#addForm").fillform(detail);
    	mytable.grid.resizeGridUpDown('middle');
    	 imageShow();
    	 initSelect(detail);
    	 initParam(detail);
    	 $("#imgtb").disable();
    	 //initURL();
    	 //'$("input[name=joinType][value="+detail.joinType+"]").attr("checked","checked");
    }
    function initParam(detail){
        var objectParam =$.parseJSON(detail.paramValue);
        showParam(detail.productId,detail.versionNO,objectParam);
    }
    function griddbclick() {
      var v = $("#mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
      if (v.length < 1||v.length > 1) {
        $.alert("${ctp:i18n('common.choose.one.record.label')}");
        return;
    }
      mytable.grid.resizeGridUpDown('up');
      $("#addForm").clearform({clearHidden:true});
      var detail=  rm.getRegisterVO(v[0].id);
      $("#addForm").fillform(detail);
      $("#registerForm").enable();
	  $("#registerForm").show();
	  $("#welcome").hide();
	  $("#button").show();
      initBlur();
      initSelect(detail);
      initParam(detail);
  	  imageShow();
  	  if(rm.checkIsExistConfig(v[0].id)){
          $("#accessMethod").disable();
  	  }
      $("#appCodetr").disable();
  	  $("#appCode").disable();
  	  initDeleteImg();
    }
	function openPackPage(){
		var v = $("#mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
      if (v.length < 1||v.length > 1) {
        $.alert("${ctp:i18n('common.choose.one.record.label')}");
        return;
    }
    var vo=rm.getRegisterVO(v[0].id);
    if(vo.accessMethod!="2"&&vo.accessMethod!="5"){
    	$.alert("${ctp:i18n('cip.manager.register.appPackageNoUpload')}!");
        return;
    }
	var appid=  vo.appCode;
	var registerId=vo.id;
	var dialog = $.dialog({
        id: 'packIndex',
        url: '${path}/cip/appManagerController.do?method=index&appId='+appid+"&registerId="+registerId,
        width: 800,
        height: 400,
        title: "${ctp:i18n('cip.manager.register.appPackageManager')}",
		closeParam:{"show": true},
    });
	}
    function transInput(){
    	 $(":text").each(function(){
    		 if($(this).val()==tipMap.get($(this).attr("id"))){
					$(this).val("");
				}
    	  });
    }
    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {
    	transInput();
        if(!($("#registerForm").validate())){		
          return;
        }
    	var productId = $("#productId  option:selected").val();
   		if(productId==null||productId===""){
   			$.alert("${ctp:i18n('cip.base.register.product')}"+"${ctp:i18n('cip.tip.not.null')}");
   			return;
   		}
		var productVersionId = $("#versionNO  option:selected").val();
   		if(productVersionId==null||productVersionId===""){
   			$.alert("${ctp:i18n('cip.base.form.product.version')}"+"${ctp:i18n('cip.tip.not.null')}");
   			return;
   		}
    	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
		if($("input[name=joinType]:checked").val()=="1"){
			if($("#versionNO").val()==""){
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				$.alert("${ctp:i18n('cip.manager.register.tip.versionnotnull')}");
				return;
			}
		}
	  	   var trList = $("#mobody").children("tr")
	   	   var stringbuffer = new StringBuffer();
	   	   stringbuffer.append("{");
	       for (var i=0;i<trList.length;i++) {
	         var tdArr = trList.eq(i).find("td");
	         var paramName =tdArr.eq(0).find("input").val();
	        var paramValue =  tdArr.eq(2).find("input").val();
	        stringbuffer.append("\""+paramName+"\":");
	        stringbuffer.append("\""+escape(paramValue)+"\"");
	        if(i!=(trList.length-1)){
	        stringbuffer.append(",");
	        }
	       }
	       stringbuffer.append("}");
	       var json = eval('(' +stringbuffer.toString()+ ')'); 
	       var jsonString  = JSON.stringify(json);
	       $("#paramValue").val(jsonString);
        try{
             rm.saveRegister($("#addForm").formobj(), {
                 success: function(rel) {
     				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
     				location.reload();                
                 },
                 error:function(returnVal){
                	 try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                   var sVal=$.parseJSON(returnVal.responseText);
                   $.alert(sVal.message);
               }
             });
         }catch(e){
        	 alert(e);
         };
        
        				                                                               
    });
    function initDeleteImg(){

        $("#iconDiv1").live("mouseover",function(){
			
        	if($("#iconPC").val()!=""){
              $("#closeImg0").css("display","block");
        	}
          }).live("mouseout",function(){
            $("#closeImg0").css("display","none");
          });
        
        $("#iconDiv2").hover(function(){
        	
        	if($("#iconH5").val()!=""){
                $("#closeImg1").css("display","block");
          	}
          },function(){
            $("#closeImg1").css("display","none");
          });
        
        $("#closeImg0").on("mousedown",function(){
             $("#imgIcon0").removeAttr("src");
            $("#imgIcon0").css("display","none");
    	    $("#iconDiv1").html("");
    	    $("#iconPC").val("");
            $(this).css("display","none");
          });
        $("#closeImg1").on("mousedown",function(){
            $(this).css("display","none");
    		$("#iconH5").val("");
            $("#imgIcon1").css("display","none").removeAttr("src");
    		$("#iconDiv2").html("");
          });
    }

});
/* function uploadCallBack(att){
$("#appFile").val(att.instance[0].fileUrl);
} */
</script>

</head>
<body> 
 
<div id='layout' class="comp" comp="type:'layout'">
 
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'cip_register'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">  
      <div id="toolbar"></div>
       <div id="searchDiv"></div>
   </div>
 
    <div  class="layout_center over_hidden" id="center">
        <table id="mytable" class="flexme3" ></table>
      <div id="grid_detail" style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="registerForm" class="form_area" style="overflow-y:hidden;">
                        <%@include file="registerForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>