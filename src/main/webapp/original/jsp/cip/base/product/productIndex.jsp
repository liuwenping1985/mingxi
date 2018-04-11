<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.apps.cip.base.enums.ProductClassifyEnum" %>
<%@page import="com.seeyon.apps.cip.constants.CIPConstants" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=productRegisterManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipConfigManager"></script>

<%

ProductClassifyEnum[] ff = ProductClassifyEnum.values();
request.setAttribute("productClassifyList", ff);
%>
<script type="text/javascript">
//window.onbeforeunload = function(){
	//  return "${ctp:i18n('cip.base.tip')}";
	  //}

var paramCache = new Properties();
function createOption(value, text) {
	var option = document.createElement("option");
	option.value = value;
	option.text = text;
	return option;
}

function initSelect(v){
    var classify = document.getElementById("productClassify");
    	<c:if test="${not empty productClassifyList}">
         classify.options.length= 0; 
         </c:if>
    <c:forEach items="${productClassifyList}" var="data">
      var item = createOption("${data.value}", "${data.text}");
      classify.add(item);
      try{
      if(v!=null){
    	  if(v.productClassify!=undefined){
    		  
    		   if("${data.value}"==v.productClassify){
    	        	item.selected=true;
    	        }
    	  }
     
      }}catch(e){}
	</c:forEach>
}

  var autorowf = function(){
			addOrDelTr(this);
		}
  
  var delButtion = function(){
			var trId = $("#current_id").val();
			var prevTr = $("#"+trId).prev("tr");
			if(prevTr==null||prevTr.attr("id")==undefined){
				prevTr = $("#"+trId).next("tr");
				if(prevTr==null||prevTr.attr("id")==undefined){
					return;
				}else{
					var img = $("#img");
					var offset = img.offset();
					offset.top = offset.top+$("#"+trId).height()+2;
					img.offset(offset);
				}
			}
			$("#current_id").val(prevTr.attr("id"));
			$("#img").addClass("hidden").css("visibility","hidden");
			$("#"+trId).remove();
	    
  }
  
  function addOrDelTr(target){
		var imgDiv = $("#img");
	    imgDiv.removeClass("hidden").css("visibility","visible");
	    var targetId = $(target).attr("id");
	    $("#current_id").val(targetId);
	    var addImg = $("#addImg");
	    var pos = getElementPos(target);
	    pos.left = pos.left - imgDiv.width();
	    imgDiv.offset(pos);
	    addImg.css("display", "block");
	    addImg[0].title = $.i18n("form.base.addRow.label");
	    if($("#versionNO"+targetId).attr("disabled")==undefined){
	    	  var delImg = $("#delImg");
				delImg.css("display", "block");
			    delImg[0].title = $.i18n("form.base.delRow.label");
	    }else{
	    	$("#delImg").css("display", "none");
	    }
	}
  function toSonDilago(target){
	  var jsonr=paramCache.get(target);
	  if(jsonr){
		  
	      $("#sonNeed").val(JSON.stringify(jsonr));
	      
	  }else{
		  $("#sonNeed").val("");
	  }
  }
  
	function showDilago(target,isDisable){
	 var p = $(target).attr("tgt");
	toSonDilago(p);
	var o = $("#objectId").val();
	      var dialog = $.dialog({
            url:"${path}/cip/base/product.do?method=showParamDialog&objectId="+o+"&versionId="+$(target).attr("tgt"),
            targetWindow:window,
            width: 800,
            height: 450,
            title: "${ctp:i18n('cip.base.dialog.title')}",
            buttons: [{
                text: "${ctp:i18n('common.button.ok.label')}", 
                isEmphasize: true,
                handler: function () {
                   var rv = dialog.getReturnValue();
                   if(rv){
                	   if(rv.result==null||rv.result==undefined){
                		var localIndex =   rv.position;
                		var localArray =   rv.list;
                	  
                	   var params=new StringBuffer();
					   var temp = null;
					    var flag = false;
					     if(isDisable){
                		  temp =  $(target).val().split(",");
                		  if(rv.list.length<temp.length){
						   $.alert("${ctp:i18n('cip.base.product.realation.param')}");
                		   return;
						  }
						 }
                	   for(i=0;i<rv.list.length;i++){
                		   params.append(rv.list[i].paramName);
                		   if(i!=(rv.list.length-1)){
                		    params.append(",");
                		   }
                	   if(isDisable){
                		 if(i!=0&&i!=1){
							 for(var k=0; k<temp.length; k++){
								 
                			 if(temp[k]==rv.list[i].paramName){
                			     flag = true;
                				 break;
                			 }
                		 }
							 	 if(!flag){
							
                		   $.alert("${ctp:i18n('cip.base.product.realation.param')}");
						  
                		   return;
                		 }
						 }
                	   }
                	   }
					    paramCache.put(localIndex,localArray);
                	   $(target).val(params.toString());
                	   dialog.close();
                	   }
                   }else{
                	   $(target).val("${ctp:i18n('cip.base.dialog.param')}");
                       dialog.close();
                   }
                }
            }, {
                text: "${ctp:i18n('common.button.cancel.label')}",
                handler: function () {
                        	   dialog.close();
                }
            }]
    });
	}
  function createTrfn(){
		var trId = $("#current_id").val();
		  if(trId==""||trId==null){
			   trId = $("#appTable tr:last").attr("id");
		  }
		var versionid=getUUID();
		var tableS=new StringBuffer();
		tableS.append("<td>");
		tableS.append("<div class=\"common_txtbox_wrap\">");
		tableS.append("<input type=\"text\" id='versionNO"+versionid +"' class=\"validate word_break_all\" validate=\"type:'string',name:'${ctp:i18n('cip.base.form.product.version')}',maxLength:50,regExp:'^[0-9a-zA-Z_.]+$',notNull:true\">");
		tableS.append("</div>");
		tableS.append("</td>");
		tableS.append("<td>");
	    tableS.append("<div class=\"common_txtbox_wrap \">");
		tableS.append("<input type='text' id='versionMemo"+versionid + "' class='validate word_break_all' validate=\"type:'string',name:'${ctp:i18n('cip.base.form.product.version.info')}',maxLength:80\">");
		tableS.append("</div>");
		tableS.append("</td>");
		tableS.append("<td>"+"<div class=\"common_txtbox_wrap \">");
		tableS.append("<input type='text' id='paramId"+versionid + "' class='validate word_break_all' tgt='"+versionid+"'>" );
		tableS.append("</div>");
		tableS.append("</td>");
	      $("#appTable tr[id="+trId+"]").after("<tr class='autorow' id='"+versionid+"'>"+tableS.toString()+"</tr>");
	      var preVersionNO = $("#versionNO"+trId).val();
	      var preVersionMemo = $("#versionMemo"+trId).val();
	      var paramId = $("#paramId"+trId).val();
		  $(".autorow").unbind("click",autorowf).bind("click",autorowf);
		  $("#current_id").val($("#"+trId).next("tr").attr("id"));
	     $("#versionNO"+versionid).val(preVersionNO);      
	     $("#versionMemo"+versionid).val(preVersionMemo);   
	     if("${ctp:i18n('cip.base.dialog.param')}"==paramId){
	    	 $("#paramId"+versionid).val("${ctp:i18n('cip.base.dialog.param')}"); 
	     }else{
	    	 $("#paramId"+versionid).val(paramId);   
	         var needCopy = paramCache.containsKey(trId);
	    	 if(needCopy){
	    		 try{
	    		 var coy=paramCache.get(trId);
	    		 if(coy==null||coy==undefined){
	    			 $("#paramId"+versionid).val("${ctp:i18n('cip.base.dialog.param')}");
	    		 }else{
	    			  var list = [];
	    				for (var i=0;i<coy.length;i++) {
	    	    			  var jsono={"objectId":coy[i].objectId,"paramName":coy[i].paramName,"dataType":coy[i].dataType,"paramDes":coy[i].paramDes,"required":coy[i].required,"paramMemo":coy[i].paramMemo,"position":versionid};
	    	    			list.push(jsono);
	    	    		}
	    		   paramCache.put(versionid,list);
	    		 }
	    	 }catch(e){
	    		 alert(e);
	    		 $("#paramId"+versionid).val("${ctp:i18n('cip.base.dialog.param')}");
			    }
	    	 }else{
	    		var newParamList = new productRegisterManager().showParams($("#objectId").val(),trId);
	    		var newa=[];
	    		for (var i=0;i<newParamList.length;i++) {
	    			if(newParamList[i].paramName!=null&&newParamList[i].paramName!=""){
	    			newa.push(newParamList[i]);
	    			}
	    		}
	    		paramCache.put(versionid,newa);
	    	 }
		}
		 $("#paramId"+versionid).click(function(){
  		  showDilago(this,false);
  		});
	}
$().ready(function() {	
	   $("#registerForm").hide();
	   $("#addForm").disable();
	   $("#button").hide();
		
	   var rm=new productRegisterManager();
		function init(){
			$("#registerForm").enable();
	    	$("#registerForm").show();
	        $("#button").show();
	        paramCache.clear();
		}
		
		function initTalbe(detail,isDisable){
			var itemList =  detail.productItemList;
			
			var tableS=new StringBuffer();
			for (var i=0;i<itemList.length;i++) {
				var versionId =itemList[i].versionId;
				tableS.append("<tr class='autorow' id='"+versionId+"'>");
				tableS.append("<td><div class=\"common_txtbox_wrap\">");
				tableS.append( "<input type=\"text\" id=\"versionNO"+versionId+"\"" +(itemList[i].disableModify?"disabled":"")+" class=\"validate word_break_all\" value=\""+itemList[i].versionNO+"\" validate=\"type:'string',maxLength:50,name:'${ctp:i18n('cip.base.form.product.version')}',notNull:true,regExp:'^[0-9a-zA-Z_.]+$'\">");
				tableS.append("</div></td>");
				tableS.append("<td><div class=\"common_txtbox_wrap \">");
				tableS.append("<input type='text' id='versionMemo"+versionId +"' value=\""+itemList[i].versionMemo.escapeHTML()+"\" class='validate word_break_all' validate=\"type:'string',name:'${ctp:i18n('cip.base.form.product.version.info')}',maxLength:80"+"\">");
				tableS.append("</div></td>"); 
				tableS.append("<td><div class=\"common_txtbox_wrap \">");
				tableS.append("<input type='text' id='paramId"+versionId + "' value=\""+itemList[i].paramId+"\" class='validate word_break_all' tgt='"+itemList[i].versionId+"'>");
				tableS.append("</div></td>"); 
				tableS.append("</tr>"); 
			
				$("#current_id").val(versionId);
			
			 }
			$("#mobody").html(tableS.toString());
			for (var i=0;i<itemList.length;i++) {
				var versionId =itemList[i].versionId;
			    var isModify=itemList[i].disableModify;
			  $("#paramId"+versionId).click(function(){
	    		  showDilago(this,isModify);
	    		});
			}
		       
		    	
		    	
		}
	   function addform(){
		   $("#addForm").clearform({clearHidden:true});
		   $("#id").val(-1);
		   initSelect(null);
	       init();
	       var detail = new Object();
	       detail.productItemList= new Array();
	       var json={"versionId":"1","versionNO":"","versionMemo":"","paramId":"","disableModify":false};
	       detail.productItemList.push(json);
	       initTalbe(detail,false);
	       $("#paramId1").val("${ctp:i18n('cip.base.dialog.param')}");
	       mytable.grid.resizeGridUpDown('middle');
	       
	       $(".autorow").bind("click",autorowf);
		    
		    $("#addImg").click(function(){
		    	createTrfn();
			});
		    var delImg = $("#delImg");
			$("#delImg").unbind("click",delButtion).bind("click",delButtion);
			delImg.css("display", "block");
		    delImg[0].title = $.i18n("form.base.delRow.label");
	    }
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'productCodes',
          name: 'productCode',
          type: 'input',
          text: "${ctp:i18n('cip.base.form.product.code')}",
          value: 'productCode'
        },
        {
            id: 'productNames',
            name: 'productName',
            type: 'input',
            text: "${ctp:i18n('cip.base.form.product.name')}",
            value: 'productName'
          },
          {
              id: 'productClassifys',
              name: 'productClassify',
              type: 'select',
              text: "${ctp:i18n('cip.base.form.product.class')}",
              value: 'productClassify',
              codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.base.enums.ProductClassifyEnum'"
            },
            {
                id: 'productCompanys',
                name: 'productCompany',
                type: 'input',
                text: "${ctp:i18n('cip.base.form.product.company')}",
                value: 'productCompany'
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
            	for(var i=0;i<v.length;i++){
            		
            	if(v[i].id==="<%=CIPConstants.CIP_PRODUCT_DATA_NC%>"){
            		$.alert("${ctp:i18n('cip.base.data.tip1')}");
            		return;
            	}
            	}
                $.confirm({
                    'msg': "${ctp:i18n('common.isdelete.label')}",
                    ok_fn: function() {
                    	for(var i = 0; i < v.length; i++) {
                    		if(rm.checkIsExistRelation(v[i].id)){
                    			$.alert("${ctp:i18n('cip.base.product.relation.exit')}");
                    			return;
                    		}
                    	}
                      rm.deleteProductRegister(v, {
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
         display: "${ctp:i18n('cip.base.form.product.code')}",
         name: 'productCode',
         width: '25%',
         sortable: true
       }, 
       {
          display: "${ctp:i18n('cip.base.form.product.name')}",
          name: 'productName',
          width: '30%',
          sortable: true
         },   
        {
            display: "${ctp:i18n('cip.base.form.product.class')}",
            sortable: true,
            name: 'productClassify',
            width: '15%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.base.enums.ProductClassifyEnum'"
        },
        {
            display: "${ctp:i18n('cip.base.form.product.company')}",
            sortable: true,
            name: 'productCompany',
            width: '25%'
        }
        ],
        width: "auto",
        managerName: "productRegisterManager",
        managerMethod: "listProductRegister",
        parentId:'center'
    });
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('down');
    function gridclk(data, r, c) {
    	var addForm = $("#addForm");
    	addForm.clearform({clearHidden:true});
    	var detail=  rm.getProductRegister(data.id);
    	addForm.fillform(detail);
    	mytable.grid.resizeGridUpDown('middle');
    	initSelect(detail);
    	initTalbe(detail,false);
    	addForm.disable();
    	$("#registerForm").show();
    	$("#button").hide();
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
      mytable.grid.resizeGridUpDown('middle');
      $("#addForm").clearform({clearHidden:true});
      init();
      var detail=  rm.getProductRegister(v[0].id);
      $("#addForm").fillform(detail);
      initSelect(detail);
      initTalbe(detail,true);
      $("#objectId").val(detail.id);
      $(".autorow").bind("click",autorowf);
	    
	    $("#addImg").click(function(){
	    	createTrfn();
		});
	    
		$("#delImg").unbind("click",delButtion).bind("click",delButtion);
		
		if(detail.disableModify){
			$("#productCode").disable();
			$("#delImg").css("display", "none");
		}else{
			$("#productCode").enable();
			
			var delImg  = $("#delImg");
			delImg.css("display", "block");
		    delImg[0].title = $.i18n("form.base.delRow.label");
		}
    }


    $("#btncancel").click(function() {
        	  location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#registerForm").validate())){		
          return;
        }
        try{
        	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
			var id = document.getElementById("id").value;
        	var object =document.getElementById("productCode");
			var productCode = object.value;
			var properties = "productCode";
			if(productCode){
			try{
				var v ={"id":id,"properties":properties,"value":productCode};
			    var check  = rm.checkDuplicate(v);
			    if(check){
			    	try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
			    	$.alert("${ctp:i18n('cip.base.form.product.tip3')}");
    				return;
			    }
			}catch(e){
			   	 alert(e);
			    }
			}
			
			var object = document.getElementById("productName");
			var productName = object.value;
			var properties = "productName";
			if(productName){
			try{
				var v ={"id":id,"properties":properties,"value":productName};
			   var check  = rm.checkDuplicate(v);
			
			 if(check){
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				 $.alert("${ctp:i18n('cip.base.form.product.tip4')}");
 				return;
			    }
			}catch(e){
			   	 alert(e);
			    }
			}
        	
        	   var pCode = document.getElementById("productCode").value;
        	   var pName = document.getElementById("productName").value;
        	   var productCompany = document.getElementById("productCompany").value;
        	   
        	   var trList = $("#mobody").children("tr")
        	   var map = [];
               for (var i=0;i<trList.length;i++) {
                 var tdArr = trList.eq(i).find("td");
                 var no =tdArr.eq(0).find("input").val();
                 var memo =tdArr.eq(1).find("input").val();
                var param =  tdArr.eq(2).find("input");
                 var paramId =param.val();
                 var version=param.attr("tgt");
                 var json={"versionId":version,"versionNO":no,"versionMemo":memo,"paramId":paramId};
            	 for(var y=0;y<map.length;y++) {
            		 if(map[y].versionNO==no){
            				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                         	$.alert("${ctp:i18n('cip.base.param.tip6')}");
                         	return;
            		 }
            	 }
                    
                 map.push(json);
               }
               var list = [];
               var toList = paramCache.values();
               for (var i=0;i<toList.size();i++) {
            	   list.push(toList.get(i));
               }
               //alert(JSON.stringify(list));
                var classify = $("#productClassify  option:selected").val(); 
              
              var formsubmit = {"id":id,"ProductParamList":list,"productCode":pCode,"productName":pName,"productCompany":productCompany,"productClassify":classify,"productIntroduce":$("#productIntroduce").val(),"productItemList":map};
              rm.saveProductRegister(formsubmit, {
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
         }
        
        				                                                               
    });

});

/**
 *获取位置,返回位置对象，如：{left:23,top:32}
 */
function getElementPos(el) {
    var ua = navigator.userAgent.toLowerCase();
    if (el.parentNode === null || el.style.display == 'none') {
        return false;
    }
    var parent = null;
    var pos = [];
    var box;
    if (el.getBoundingClientRect) {//IE，google
        box = el.getBoundingClientRect();
        var scrollTop = document.documentElement.scrollTop;
        var scrollLeft = document.documentElement.scrollLeft;
        if(navigator.appName.toLowerCase()=="netscape"){//google
        	scrollTop = Math.max(scrollTop, document.body.scrollTop);
        	scrollLeft = Math.max(scrollLeft, document.body.scrollLeft);
        }
        return { left : box.left + scrollLeft, top : box.top + scrollTop };
    } else if (document.getBoxObjectFor) {// gecko
        box = document.getBoxObjectFor(el);
        var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth) : 0;
        var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth) : 0;
        pos = [ box.x - borderLeft, box.y - borderTop ];
    } else {// safari & opera
        pos = [ el.offsetLeft, el.offsetTop ];
        parent = el.offsetParent;
        if (parent != el) {
            while (parent) {
                pos[0] += parent.offsetLeft;
                pos[1] += parent.offsetTop;
                parent = parent.offsetParent;
            }
        }
        if (ua.indexOf('opera') != -1 || (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {
            pos[0] -= document.body.offsetLeft;
            pos[1] -= document.body.offsetTop;
        }
    }
    if (el.parentNode) {
        parent = el.parentNode;
    } else {
        parent = null;
    }
    while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled ancestors
        pos[0] -= parent.scrollLeft;
        pos[1] -= parent.scrollTop;
        if (parent.parentNode) {
            parent = parent.parentNode;
        } else {
            parent = null;
        }
    }
    return {
        left : pos[0],
        top : pos[1]
    };
}
/* function uploadCallBack(att){
$("#appFile").val(att.instance[0].fileUrl);
} */
</script>

</head>
<body> 
 
<div id='layout' class="comp" comp="type:'layout'">
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
                        <%@include file="productForm.jsp"%></div>
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