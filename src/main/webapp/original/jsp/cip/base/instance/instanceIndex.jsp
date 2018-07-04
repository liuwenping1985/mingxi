<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.apps.cip.constants.CIPConstants" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=registerInstanceManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=productRegisterManager"></script>
<script type="text/javascript">
var paramCache = new Properties();
function createOption(value, text) {
	var option = document.createElement("option");
	option.value = value;
	option.text = text;
	
	return option;
}
$().ready(function() {	
	    $("#registerForm").hide();
	    $("#button").hide();
	    var ri = new registerInstanceManager();
	    var pr = new productRegisterManager();
	    var product = document.getElementById("productId");
	   	product.options.length= 0; 
	   	var empty = createOption("", "");
	   	product.add(empty);
	    <c:forEach items="${productList}" var="data">
	      var id = "${data.id}".toString();
	      var item = createOption(id, "${data.productCode}");
	      product.add(item);
	      var list = new ArrayList();
	         <c:forEach items="${data.productItemList}" var="version">
	            list.add("<option value=\""+"${version.versionId}"+"\">"+"${version.versionNO}"+"</option>");
	         </c:forEach>
	         paramCache.put(id,list);
		</c:forEach>
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
					  tableS.append("<input type='text'  id='paramValue"+i+"' value='"+paramValueG+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+o.required+"\">");
					}else{
					  tableS.append("<input type='text'  id='paramValue"+i+"' class='validate word_break_all' validate=\"type:'"+dataT+"',name:'${ctp:i18n('cip.base.product.param8')}',maxLength:80,notNull:"+o.required+"\">");
					}
					tableS.append("</div></td>"); 
					tableS.append("</tr>");
	    		}
	    	}
	    	
			 
			$("#mobody").html(tableS.toString());
			
		}
	   $("#productId").change(function () { 
	        var productId = $("#productId  option:selected").val();
	        if(null != productId && "" != productId){
	        	$("#productVersionId").empty();
	        	var list =paramCache.get(productId);
	        	var version = $("#productVersionId");
	        	version.append("<option value=\"\"></option>");
    				for(var i=0;i<list.size();i++){
    					version.append(list.get(i));
	        	}
	        		}
	   });
	   $("#productVersionId").change(function () { 
	        var productVersionVal = $("#productVersionId  option:selected").text();
	        var productVersionId = $("#productVersionId  option:selected").val();
	        var productName = $("#productId  option:selected").text();
	        var productId = $("#productId  option:selected").val();
	        if(productName==""){
	           $.alert("${ctp:i18n('cip.base.instance.tip')}");
	           return;
	        }
	        if(null != productVersionVal && "" != productVersionVal){
   			    var code  =ri.getInstanceCode();
	            var sysCode = $("#systemCode");
		        sysCode.val(productName+productVersionVal+code);
		        
		        showParam(productId,productVersionId,null);
		
				//alert(JSON.stringify(params));
	        }
	   });
	   
		function init(){
			$("#registerForm").enable();
	    	$("#registerForm").show();
	        $("#button").show();
	        $("#systemCode").disable();
	        //paramCache.clear();
		}
		

	   function addform(){
		   $("#addForm").clearform({clearHidden:true});
		   $("#id").val(-1);
		
	       init();
	       $("#mobody").html("");
	       $("#productVersionId").empty();
	       mytable.grid.resizeGridUpDown('middle');
	      // initSelect(v);
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
          text: "${ctp:i18n('cip.base.register.product')}",
          value: 'productCode'
        },
        {
            id: 'systemCodes',
            name: 'systemCode',
            type: 'input',
            text: "${ctp:i18n('cip.base.instance.code')}",
            value: 'systemCode'
          },
            {
                id: 'instanceIntroduces',
                name: 'instanceIntroduce',
                type: 'input',
                text: "${ctp:i18n('cip.base.instance.introduce')}",
                value: 'instanceIntroduce'
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
                $.confirm({
                    'msg': "${ctp:i18n('common.isdelete.label')}",
                    ok_fn: function() {
                        for(var i = 0; i < v.length; i++) {
                    		if(ri.checkIsExistRelation(v[i].id)){
                    			$.alert("${ctp:i18n('cip.base.instance.relation.exit')}");
                    			return;
                    		}
                    	}
                      ri.deleteInstance(v, {
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
         display: "${ctp:i18n('cip.base.instance.code')}",
         name: 'systemCode',
         width: '10%',
         sortable: true
       }, 
         {
             display: "${ctp:i18n('cip.base.register.product')}",
             name: 'productCode',
             width: '10%',
             sortable: true
            }, 
            {
                display: "${ctp:i18n('cip.base.form.product.version')}",
                sortable: true,
                name: 'productVersion',
                width: '10%'
            },
        {
            display: "${ctp:i18n('cip.base.instance.introduce')}",
            sortable: true,
            name: 'instanceIntroduce',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.base.instance.addr')}",
            sortable: true,
            name: 'addr',
            width: '15%'
        }
        ],
        width: "auto",
        managerName: "registerInstanceManager",
        managerMethod: "listRegisterInstance",
        parentId:'center',
        render: rend
    });
    
	   function rend(txt, data, r, c) {
		   
			if (data.addr!=""&&c==5) {
			  return escapeStringToHTML(unescape(txt));
			}else{return txt;}
		  }
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
   function initSelect(detail){
	 	 var list = paramCache.get(detail.productId);
	 	 var pVersion=$("#productVersionId");
	 	 pVersion.disable();
    	 $("#productId").disable();
    	for(var i=0;i<list.size();i++){
    		pVersion.append(list.get(i));
    	}
    	 $("#productVersionId option[value='"+detail.productVersionId+"']").attr("selected", true); 
   }
    function gridclk(data, r, c) {
    	//$("#addForm").clearform({clearHidden:true});
    	var detail=  ri.getRegisterInstance(data.id);
    	$("#addForm").fillform(detail);
    	 $("#productVersionId").empty();
    	
    	initSelect(detail);
        var objectParam =JSON.parse(detail.paramValue);
        showParam(detail.productId,detail.productVersionId,objectParam);
        
        $("#addForm").disable();
    	$("#registerForm").show();
    	$("#button").hide();
    	mytable.grid.resizeGridUpDown('middle');
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
      var addForm = $("#addForm");
      //addForm.clearform({clearHidden:true});
      init();
      var detail=  ri.getRegisterInstance(v[0].id);
      addForm.fillform(detail);
      initSelect(detail);      
      var objectParam =JSON.parse(detail.paramValue);
      showParam(detail.productId,detail.productVersionId,objectParam);
      
      mytable.grid.resizeGridUpDown('middle');
    }

    $("#btncancel").click(function() {
            	  location.reload();
    });
    
    $("#btnok").click(function() {
   		var productId = $("#productId  option:selected").val();
   		if(productId==null||productId===""){
   			try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
   			$.alert("${ctp:i18n('cip.base.register.product')}"+"${ctp:i18n('cip.tip.not.null')}");
   			return;
   		}
   		var id = $("#id").val();
   		var productVersionId = $("#productVersionId  option:selected").val();
   		if(productVersionId==null||productVersionId===""){
   			try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
   			$.alert("${ctp:i18n('cip.base.form.product.version')}"+"${ctp:i18n('cip.tip.not.null')}");
   			return;
   		}
        if(!($("#registerForm").validate())){		
          return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
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
		var v ={"id":id,"productId":productId,"productVersionId":productVersionId,"paramValue":jsonString};
	    var check  = ri.checkDuplicate(v);
	    if(check){
	    	try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
	    	$.alert("${ctp:i18n('cip.base.instance.tip1')}");
			return;
	    }
	}catch(e){
	   	 alert(e);
	   	 return;
	    }
        ri.saveRegister($("#registerForm").formobj(), {
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
    });
});

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
                        <%@include file="instanceForm.jsp"%></div>
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