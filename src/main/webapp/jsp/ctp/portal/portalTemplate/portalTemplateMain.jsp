<%--
 $Author: zhout $
 $Rev: 37524 $
 $Date:: 2014-05-23 14:19:44#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=portalTemplateManager,portalHotSpotManager,orgManager"></script>
<script>
  var currentPicChangeId = null;
  var Template_Parent_Path = null;
  var templateCreator = false;
  $(document).ready(function() {
      var msg = '${ctp:i18n("info.totally")}';
      $("#entityLevel").val("${entityLevel}");
      $("#entityId").val("${entityId}");
      
      <c:if test="${productVersion != 'a6s'}" >
	  var searchobj = $.searchCondition({
			top:2,
			right:10,
          searchHandler: function(){
        	  var retJSON = searchobj.g.getReturnValue();
        	  if(retJSON == null || retJSON.condition == "") {
        		  refreshTable();
			  } else {
				  var params = new Object();
				  if(retJSON.condition == "templateName"){
				    params.name = retJSON.value;
				  } else {
				    params.description = retJSON.value;
				  }
				  params.entityId = $("#entityId").val();
				  params.entityLevel = $("#entityLevel").val();
				  params.currentAccountId = "${currentAccountId}";
				  $("#mytable").ajaxgridLoad(params);
			  }
          },
          conditions: [{
              id: 'templateName',
              name: 'templateName',
              type: 'input',
              text: "${ctp:i18n('template.portal.name')}",
              value: 'templateName'
          },{
              id: 'templateDescription',
              name: 'templateDescription',
              type: 'input',
              text: "${ctp:i18n('template.portal.description')}",
              value: 'templateDescription'
          }]
      });
	  </c:if>
	  var toolbar = $("#toolbar2").toolbar({
          searchHtml: 'sss',
          toolbar: [
          {
              id: "import",
              name: "${ctp:i18n('template.portal.import')}",
              className: "ico16 import_16 hidden",
			  click:function(){
				  insertAttachment('uploadCallBack');
		 	  }
          },{
              id: "export",
              name: "${ctp:i18n('template.portal.export')}",
              className: "ico16 export_16 hidden",
				click:function(){
					var checkedIds = $("input:checked", $("#mytable"));
				    if (checkedIds.size() == 0) {
				      $.alert("${ctp:i18n('template.portal.homePage')}");
				    } else {
				      var portalTemplateIds = "";
				      for(var i = 0; i < checkedIds.size(); i++){
				        portalTemplateIds = portalTemplateIds + $(checkedIds[i]).val() + ",";
				      }
				      portalTemplateIds = portalTemplateIds.substr(0, portalTemplateIds.length - 1);
				      $("#downLoadIFrame").attr("src", "${path}/portal/portalTemplateController.do?method=exportPortalTemplate&portalTemplateIds=" + portalTemplateIds);
				    }
				}
          },{
        	  id: "modify",
              name: "${ctp:i18n('link.jsp.modify')}",
              className: "ico16 modify_text_16",
			  click:function(){
				  var checkedIds = $("input:checked", $("#mytable"));
				  if (checkedIds.size() == 0) {
				    $.alert("${ctp:i18n('template.portal.select')}");
				  } else if (checkedIds.size() > 1) {
				    $.alert("${ctp:i18n('template.portal.select.one')}");
				  } else {
				    var checkedId = $(checkedIds[0]).attr("value");
				    $("#id").val(checkedId);
				    showTemplateDetail(checkedId,false);
				  }					
			  }
          },{
              id: "delete",
              name: "${ctp:i18n('link.jsp.del')}",
              className: "ico16 del_16 hidden",
              click:function(){
            	var checkedIds = $("input:checked", $("#mytable"));
            	if (checkedIds.size() == 0) {
            	  $.alert("${ctp:i18n('template.select.portal')}");
            	} else {
            	  var params = new Array();
            	  for(var i = 0; i < checkedIds.size(); i++){
            	    params.push($(checkedIds[i]).val());
            	  }
            	  var confirm = $.confirm({
            	    'msg' : "${ctp:i18n('template.delete.portal')}",
            	    ok_fn : function() {
            	      new portalTemplateManager().deletePortalTemplateByIds(params, {
            	        success : function(data) {
            	          refreshTable();
            	        }
            	      });
            	    }
            	  });
            	}	
			  }
          }
          <c:if test="${productVersion != 'a6s'}" >
          ,{
            id: "setDefault",
            name: "${ctp:i18n('template.portal.settodefault')}",
            className: "ico16 setting_16",
            click:function(){
              var checkedIds = $("input:checked", $("#mytable"));
              if (checkedIds.size() == 0) {
                $.alert("${ctp:i18n('template.select.portal')}");
              } else if(checkedIds.size()>1){
                $.alert("${ctp:i18n('template.portal.select.one')}");
              }else {
                var id = $(checkedIds[0]).val();
                var confirm = $.confirm({
                  "msg": "${ctp:i18n('template.portal.istodefault')}",
                  ok_fn: function () {
                    var entityLevel = $("#entityLevel").val();
                    var entityId = $("#entityId").val();
                    new portalTemplateManager().updateTemplateDefault(id,entityLevel,entityId, {
                      success : function(data) {
                        showMask();
                        getCtpTop().onbeforunloadFlag = false;
                        getCtpTop().isOpenCloseWindow = false;
                        getCtpTop().isDirectClose = false;
                        getCtpTop().location.href = "${path}/main.do?method=changeLoginAccount&login.accountId=${currentAccountId}&isRefresh=true";
                      }
                    });
                  }
                });
              }   
            }
          }
          </c:if>
          ]
      });
	  if($("#entityLevel").val() != "super"){
	    //不是超级管理员
	    toolbar.hideBtn("import");
	    toolbar.hideBtn("export");
	    toolbar.hideBtn("delete");
	  }

	var mytable = $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '${ctp:i18n("template.portal.name")}',
        name : 'name',
        sortable : true,
        width : '20%'
      }, {
        display : '${ctp:i18n("template.portal.description")}',
        name : 'description',
        sortable : true,
        width : '20%'
      }, {
          display : '${ctp:i18n("template.portal.ispreset")}',
          name : 'preset',
          sortable : true,
          width : '20%'
      }, {
        display : '${ctp:i18n("common.sort.label")}',
        name : 'sort',
        sortable : true,
        width : '16%'
      },{
        display : '${ctp:i18n("template.portal.isdefault")}',
        name : 'sdefault',
        sortable : true,
        width : '20%'
      }],
      click : tclk,
      dblclick : dblclk,
      managerName : "portalTemplateManager",
      managerMethod : "selectPortalTemplate",
      params : {
        entityId : "${entityId}"
      },
      render : rend,
      height : 200,
      parentId : 'center',
      slideToggleBtn : true,
      vChange : true,
      vChangeParam: {
        'changeTar': 'form_area',
        overflow: "auto",
        'subHeight': 0,
        autoResize:true
       }
    });
    
    function rend(txt, data, r, c) {
      if(c == 3){
    	if(data.preset == 1){
  	      return '${ctp:i18n("template.portal.ispreset.yes")}';
		} else {
		  return '${ctp:i18n("template.portal.ispreset.no")}';
		}
      } else if(c == 5){
        if(data.sdefault == 1){
          return '${ctp:i18n("common.yes")}';
        } else {
            return '${ctp:i18n("common.no")}';
        }
      } else {
    	return $.i18n(txt) || txt;
      }
    }

    //单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
  	  $("#form_area").resetValidate();
  	  $("input:checked", $("#mytable")).attr("checked", false);
  	  $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true);
  	  showTemplateDetail(data.id,true);
    }
    
    //双击列表中一行
    function dblclk(data, r, c) {
      $("#form_area").resetValidate();
      setTimeout(function(){
        $("#modify_a").click();
      }, 300);
    }

    function showTemplateDetail(templateId,readonly){
      $("#manual").hide();
      new portalTemplateManager().selectTemplateById(templateId, {
        success : function(portalTemplate) {
          mytable.grid.resizeGridUpDown('middle');
          if(!readonly){
            $("#form_area .align_center").show();
            $("#id").val(portalTemplate.id);
          }else{
            $("#form_area .align_center").hide();
          }
          $("#form_area").show();
          $("#name").val(($.i18n(portalTemplate.name) || portalTemplate.name));
          $("#thumbnail").attr("src", "${path}/main/common/showImg.html?src=${path}/main/frames/" + portalTemplate.thumbnail);
          $("#path").val(portalTemplate.path);
          Template_Parent_Path = portalTemplate.path.substring(0, portalTemplate.path.indexOf("/"));
          $("#description").val(($.i18n(portalTemplate.description) || portalTemplate.description));
          $("#sort").val(portalTemplate.sort);
          showHotspot(templateId,readonly,false);
         }
      });
    }
    
    function showHotspot(templateId,readonly){
      var entityLevel = $("#entityLevel").val();
      var entityId = $("#entityId").val();
      new portalHotSpotManager().getHotSpotByTemplateId0(templateId, entityId, {
        success : function(portalHotspots) {
          $("#hotSpotsCount").val(portalHotspots.length);
          var html = "<div style=\"float:right;margin-right:40px\">";
          <c:if test="${productVersion != 'a6s'}" >
          html += "<a id=\"showImage\">${ctp:i18n('template.portal.hotspot.sample')}</a>";
          </c:if>
          html += "</div><div style=\"clear:both;\"></div>";  
          for(var i = 0; i < portalHotspots.length; i++){
              var split = "";
                if(i > 0){
                  split = "border_t margin_t_10 padding_t_10";
                }
                if(portalHotspots[i].entityLevel.toLowerCase().indexOf(entityLevel) == -1 && entityLevel != "super"){
                  split += " display_none";
                }
                html += "<table style=\"table-layout:fixed\" width=\"510\" align=\"center\" class=\"" + split + "\">";
                html += "<input id='hotSpotId" + i + "' type='hidden' value='" + portalHotspots[i].id + "'/>";              
                html += "<input id='hotSpotType" + i + "' type='hidden' value='" + portalHotspots[i].type + "'/>";   
                html += "<input id='templateId" + i + "' type='hidden' value='" + portalHotspots[i].templateid + "'/>";
                html += "<input id='hotspotkey" + i + "' type='hidden' value='" + portalHotspots[i].hotspotkey + "'/>"; 
                html += "<input id='description" + i + "' type='hidden' value='" + portalHotspots[i].description + "'/>";
                html += "<input id='entityId" + i + "' type='hidden' value='" + portalHotspots[i].entityId + "'/>";
                html += "<input id='entityLevel" + i + "' type='hidden' value='" + portalHotspots[i].entityLevel + "'/>"; 
                html += "<input id='hotspotName" + i + "' type='hidden' value='" + portalHotspots[i].name + "'/>"; 
                html += "<input id='hotspotModule" + i + "' type='hidden' value='" + portalHotspots[i].module + "'/>"; 
                html += "<input id='hotspotSort" + i + "' type='hidden' value='" + portalHotspots[i].ext1 + "'/>";    
                html += "<input id='hotspotRead" + i + "' type='hidden' value='" + portalHotspots[i].ext2 + "'/>"; 
                html += "<input id='showdisplay" + i + "' type='hidden' value='" + portalHotspots[i].ext3 + "'/>";
                html += "<input id='hotAccountId" + i + "' type='hidden' value='" + portalHotspots[i].ext4 + "'/>";     
                html += "<tr>";
                if(portalHotspots[i].type == 0){
                  var value = portalHotspots[i].hotspotvalue;
                  var regX = /^[$][{]\w*[}]$/g;
                  if(value == null || value=="null"){
                	  html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\" width='105px' align='right' for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                      html += "<td width=250>";
                    value = "";
                  }else if(value.match(regX)){
                    value = portalHotspots[i].hotspotvalue;
                    if(value.indexOf("accountName")>-1){
                      value = "<c:out value="${accountName}" default="null" escapeXml="true"/>";
                      html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\" title=\""+value+"\"  for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                      html += "<td>";
                    }
                    if(value.indexOf("groupName")>-1){
                      value = "<c:out value="${groupName}" default="null" escapeXml="true"/>";
                      html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\"  for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                      html += "<td>";
                    }
                  }else{
                	  html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\"  for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                      html += "<td>";
                      value = portalHotspots[i].hotspotvalue;
                  }
                  html += "<div class=\"common_txtbox_wrap\">";
                  html += "<input title=\"" + value + "\"  hotspotkey=\"" + portalHotspots[i].hotspotkey + "\" id=\"hotspotvalue" + i + "\" class=\"validate\" validate=\"type:'string',name:'${ctp:i18n("hotspot.value.label")}',maxLength:500,character:'!@#$%^*()<>'\" type=\"text\" value=\"" + value + "\" readonly = \""+(portalHotspots[i].ext2 == 1?"readonly":"")+"\"/>";
                  html += "</div>";
                  html += "</td>";
                  if(portalHotspots[i].ext3==1){
                    html += "<td nowrap=\"nowrap\">&nbsp;&nbsp;<label class=\"margin_r_10 hand\" for=\"display" + i + "\"><input id=\"display" + i + "\" type=\"checkbox\" "+(portalHotspots[i].display == 0?"checked":"")+"/>${ctp:i18n("template.portal.fontnotshow")}</label></td>";
                  } else {
                    html += "<td>&nbsp;</td>";
                  }
                } else if(portalHotspots[i].type == 1){
               	  html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\"  for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                  html += "<td>";
                  html += "<input id=\"myfile" + i + "\" type=\"hidden\"/>";
                  html += "<div class=\"common_txtbox_wrap\"><input id=\"picFileId" + i + "\" type=\"hidden\" /><input id=\"hotspotvalue" + i + "\"\" name='picture' type=\"text\" value=\"" + ((portalHotspots[i].hotspotvalue == null || portalHotspots[i].hotspotvalue == "null")? "":portalHotspots[i].hotspotvalue) + "\" onclick=\"currentPicChangeId='" + i + "';insertAttachmentPoi('poi" + i + "');\" readonly=\"readonly\" /></div>";
                  html += "</td>";
                  if(portalHotspots[i].ext3==1){
                    html += "<td nowrap=\"nowrap\">&nbsp;&nbsp;<label class=\"margin_r_10 hand\" for=\"display" + i + "\"><input id=\"display" + i + "\" type=\"checkbox\" "+(portalHotspots[i].display == 0?"checked":"")+"/>${ctp:i18n("template.portal.fontnotshow")}</label></td>";
                  } else {
                    html += "<td>&nbsp;</td>";
                  }
                } else if(portalHotspots[i].type == 2){
                  html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\" for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                  html += "<td>";
                  html += "<input id=\"hotspotvalue" + i + "\" class=\"validate\" validate=\"type:'string',notNull:true,name:'${ctp:i18n("hotspot.value.label")}',minLength:1,maxLength:20\" name='color' type=\"text\" value=\"" + ((portalHotspots[i].hotspotvalue == null || portalHotspots[i].hotspotvalue == "null")? "":portalHotspots[i].hotspotvalue) + "\" style=\"width:250px;\" readonly=\"readonly\" />";
                  html+="</td>";
                }
                if(portalHotspots[i].type == 1){
                  html += "<tr>";
                  html += "<th nowrap=\"nowrap\" valign=\"top\" width=\"120\"><label class=\"margin_r_10\" for=\"text\">${ctp:i18n("template.portal.thumbnail")}:</label></th>";
                  html += "<td width=250>";
                  if(portalHotspots[i].hotspotkey=='hbackpic'){
                  	html += "<iframe id=\"showImgIframe" + i + "\" width=\"100%\" height=\"64px\" src=\"" + "${path}/main/common/showImg.html?src=${path}/main/frames/" + portalHotspots[i].hotspotvalue + "?expand=" + portalHotspots[i].tiling + "\" scrolling=\"yes\" />";
                  }else if(portalHotspots[i].hotspotkey == 'backpic'){
                      html += "<iframe id=\"showImgIframe" + i + "\" width=\"100%\" height=\"90px\" src=\"" + "${path}/main/common/showImg.html?src=${path}/main/frames/" + portalHotspots[i].hotspotvalue + "?expand=" + portalHotspots[i].tiling + "\" scrolling=\"yes\" />"; 
                  }else if(portalHotspots[i].hotspotkey.indexOf('Logo') == -1){
                	  html += "<iframe id=\"showImgIframe" + i + "\" width=\"100%\" height=\"100%\" src=\"" + "${path}/main/common/showImg.html?src=${path}/main/frames/" + portalHotspots[i].hotspotvalue + "?expand=" + portalHotspots[i].tiling + "\" scrolling=\"yes\" />"; 
                  }else{
                	  html += "<iframe id=\"showImgIframe" + i + "\" width=\"136px\" height=\"84px\" src=\"" + "${path}/main/common/showImg.html?src=${path}/main/frames/" + portalHotspots[i].hotspotvalue + "?expand=" + portalHotspots[i].tiling + "\" scrolling=\"yes\" />"; 
                  }
                  html += "</td>";
                  html += "</tr>";
                  //如果为logo不实现平铺
                  if(portalHotspots[i].hotspotkey.indexOf('Logo')==-1){
                      html += "<tr>";
	                  html += "<th nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_10\" for=\"text\">${ctp:i18n("template.portal.tiling")}:</label></th>";
	                  html += "<td width=\"100%\"><div class=\"common_checkbox_box\">";
	                  html += "<input id=\"hotspotTiling" + i + "\" class=\"radio_com\" type=\"checkbox\" value=\"1\"" + (portalHotspots[i].tiling == 1?'checked':'unchecked') + " onclick=\"hotspotTilingOnclickHandler('" + i + "');\" />";
	                  html += "</div></td>";
	                  html += "</tr>";
                  }
                  if(portalHotspots[i].hotspotkey=='hbackpic'){
		               html += "<tr>";
		               html += "<td>&nbsp;</td>";
		               html += "<td nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.portal.hotspot.instruction1")}</label></td>";
		               html += "</tr>";
                  }else if(portalHotspots[i].hotspotkey == 'backpic'){
	                   html += "<tr>";
	                   html += "<td>&nbsp;</td>";
	                   html += "<td nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.portal.hotspot.instruction3")}</label></td>";
	                   html += "</tr>";
                  }else if(portalHotspots[i].hotspotkey.indexOf('Logo') != -1){
                       html += "<tr>";
                       html += "<td>&nbsp;</td>";
                       html += "<td nowrap=\"nowrap\" width=\"120\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.portal.hotspot.instruction2")}</label></td>";
		               html += "</tr>";
                  }
                }
//                 if(portalHotspots[i].description != null&&portalHotspots[i].description.length>0){
//                   html += "<tr>";
//                   html += "<th nowrap=\"nowrap\"><label class=\"margin_r_10\" for=\"text\">热点描述：</label></th>";
//                   html += "<td width=\"100%\">";
//                   html += ((portalHotspots[i].description == null || portalHotspots[i].description == "null")? "&nbsp;":portalHotspots[i].description);
//                   html += "</td>";
//                   html += "</tr>";
//                 }
                html += "</table>";
          }
          $("#hotspotDiv").html(html);
          for(var i = 0; i < portalHotspots.length; i++){
              if(portalHotspots[i].type == 1){
                  dymcCreateFileUpload("myfile" + i,1,"jpg,jpeg,gif,bmp,png",1,false,"uploadCallBack2", "poi" + i,true,true,null,false,true,512000);
              } else if(portalHotspots[i].type == 2){
                if(!readonly) $("#hotspotvalue" + i).colorpicker({position:false});
              }
          }
          if(readonly){
            $("input,textarea", $("#form_area")).attr("disabled", true);
          }else{
            $("input,textarea", $("#form_area")).attr("disabled", false);
            $("input[readonly=readonly]").attr("disabled", false);
            $("input[hotspotkey='groupName']").attr("disabled", true);
            $("input[hotspotkey='accountName']").attr("disabled", true);
          }
          if($("#entityLevel").val() == "member" || $("#entityLevel").val() == "account"){
            $("input,textarea", $("#templateArea")).attr("disabled", true);
          }
          if(${productVersion ne "a8group"} && $("#entityLevel").val() == "account"){
            $("input,textarea", $("#templateArea")).attr("disabled", false);
          }
          $("#path").attr("disabled", true);
        }
      });
    }
    
    
    $("#showImage").live("click",function(){
      var imgUrl = "${path}/main/common/css/images/hotspot_sample.png";
      if("${productVersion}" == "a6" || "${productVersion}" == "a6s"){
        imgUrl = "${path}/main/common/css/images/hotspot_sample_a6.jpg";
      }
	  var dialog = $.dialog({
	    url: imgUrl,
	    htmlId : 'showImage',
	    title : '${ctp:i18n("template.portal.hotspot.sample")}',
	    width:1105,
	    height:600,
	    targetWindow:window.top,
	    buttons : [ {
	      text : '${ctp:i18n("common.button.close.label")}',
	      handler : function() {
	        dialog.close();
	      }
	    }]
      });
    })
    
    $("#errorTitle1").live("mouseover",function(){
		$("#errorInfo").show();
		})

	$("#errorTitle1").live("mouseout",function(){
		$("#errorInfo").hide();
		})
		
	$("#errorTitle2").live("mouseover",function(){
		$("#errorInfo").show();
		})

	$("#errorTitle2").live("mouseout",function(){
		$("#errorInfo").hide();
		})
		
		
	function checkPicture(){
		var picture=$(":input[name=picture]");
		var bool=true;
		$.each(picture,function(n,i){
			var value=$(i).val();
			var str=value.split(" ");
			if(str.length>1){
				bool=false;
			}
		})
		return bool;
	}
    
    function checkPictureNull(){
		var picture=$(":input[name=picture]");
		var bool=true;
		$.each(picture,function(n,i){
			var value=$(i).val();
			if(value==null||value==''){
				bool=false;
			}
		})
		return bool;
    }
    
	function checkChinese(){
		var picture=$(":input[name=picture]");
		var bool=true;
		$.each(picture,function(n,i){
			var value=$(i).val();
			if(escape(value).indexOf('%u') != -1){
				bool=false;
			}
		})
		return bool;
	}
    
	function checkInteger(){
		var bool=true;
		var reg1 = [1-9];
		if($("#sort").val()<=0){
			bool=false;
		}
		return bool;
	}	
  	$("#submitbtn").click(function() {
  	  var bool=checkPicture();
  	  if(bool==false){
  		$.messageBox({
            'title':'${ctp:i18n("common.prompt")}',
            'type': 0,
            'msg': "${ctp:i18n('login.template.error.picture')}",
            'imgType':2
             }); 
  		return false;
  	  }
  	  bool=checkPictureNull();
  	  if(bool==false){
    		$.messageBox({
              'title':'${ctp:i18n("common.prompt")}',
              'type': 0,
              'msg': "${ctp:i18n('login.template.picture.null')}",
              'imgType':2
               }); 
    		return false;
    	  }
	  bool=checkChinese();
	  if (bool==false) {
	 		$.messageBox({
	            'title':'${ctp:i18n("common.prompt")}',
	            'type': 0,
	            'msg': "${ctp:i18n('path.cannot.contain.chinese')}",
	            'imgType':2
	             }); 
		  return false;
	  }
      var formobj = $("#form_area").formobj();
      if (!$._isInValid(formobj) && $("#id").val() != 0) {
    	var checkedId=$("input:checked", $("#mytable")).val();
    	showMask();
        new portalTemplateManager().transSaveTemplate($("#form_area").formobj(),{
          success : function(){
            //撤销遮蔽
            hideMask();
            $.messageBox({
              'title':'${ctp:i18n("common.prompt")}',
              'type': 0,
              'msg': "${ctp:i18n('common.successfully.saved.label')}",
              'imgType':0,
               ok_fn:function(){
                 var rows = mytable.grid.getSelectRows();
                 if(rows[0].sdefault == 0){
                     $.alert("${ctp:i18n('common.successfully.saved.label')}");
                     location.reload(true);
                 } else {
                   new portalTemplateManager().getTemplateHospot(checkedId,{
                     success : function(data){
                       top.$.ctx.template = $.parseJSON(data);
                       top.initHotspots();
                       location.reload(true);
                     }
                   });
                 }
               }
            });
          }
        });
	  }
    });
  	
  	$("#reDefaultbtn").click(function(){
      var confirm = $.confirm({
          'msg': "${ctp:i18n('channel.button.toDefault')}",
          ok_fn: function () {
            var templateId = $("#id").val();
            var entityId = $("#entityId").val();
            new portalTemplateManager().transReSetToDefault(templateId, entityId,{
              success : function(){
                getCtpTop().onbeforunloadFlag = false;
                getCtpTop().isOpenCloseWindow = false;
                getCtpTop().isDirectClose = false;
                getCtpTop().location.href = "${path}/main.do?method=changeLoginAccount&login.accountId=${currentAccountId}";
              }
            });
          }
      });
    });
  	
  	$("#form_area").hide();
  	$("#manual").show();
  	mytable.grid.resizeGridUpDown('middle');
  	$("#count").html(mytable.p.total);
  });
  
  function uploadCallBack(fileid){
	//处理文件逻辑的action
	new portalTemplateManager().transProcessUploadedFile(fileid,{
	  success : function(){
	    $.messageBox({
          'title': "${ctp:i18n('common.prompt')}",
          'type': 0,
          'msg': "${ctp:i18n('link.jsp.import.success.prompt')}",
          'imgType':0,
           ok_fn:function(){location.reload();}
        });
      }
	});
  }
  
  function uploadCallBack2(attachment){
	  if(currentPicChangeId != null){
		  $("#picFileId" + currentPicChangeId).val(attachment.instance[0].fileUrl);
		  $("#hotspotvalue" + currentPicChangeId).val(Template_Parent_Path + "/" + attachment.instance[0].fileUrl+"."+attachment.instance[0].extension);
		  var expand = 0;
		  if($("#hotspotTiling" + currentPicChangeId).attr("checked") == "checked"){
			  expand = 1;
		  }
		  $("#showImgIframe" + currentPicChangeId).attr("src", "${path}/main/common/showImg.html?src=${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&expand=" + expand + "&type=image");
	  }
  }
  
  function hotspotTilingOnclickHandler(id){
	  var checked = $("#hotspotTiling" + id).attr("checked");
	  var src = "";
	  if(checked == "checked"){
		  src = $("#showImgIframe" + id).attr("src").replace("?expand=0", "?expand=1");
	  } else {
		  src = $("#showImgIframe" + id).attr("src").replace("?expand=1", "?expand=0");
	  }
	  $("#showImgIframe" + id).attr("src", src);
  }
  
  //刷新列表
  function refreshTable(){
	window.location.reload(true);
  }
</script>
</head>
<body>
    <c:if test="${!hasBreadcrumbShow}">
	    <c:if test="${entityLevel eq 'group'}">
	        <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateListGroup'"></div>
	    </c:if>
	    <c:if test="${entityLevel eq 'super'}">
	    	 <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateList'"></div>
	    </c:if>
	    <c:if test="${entityLevel eq 'account'}">
	        <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateListAccount'"></div>
	    </c:if>
	    <c:if test="${entityLevel eq 'member'}">
	        <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateListMember'"></div>
	    </c:if>
	</c:if>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
        	<div id="toolbar2"></div>
        </div>
        <!-- 
        <div class="layout_west" id="west" layout="width:200">
            <div id="tree"></div>
        </div>
         -->
        <div class="layout_center over_hidden" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div class="form_area display_none" id="form_area">
            <div style="width:600px; margin:0 auto;">
            	<input type="hidden" id="id" value="0"/>
                <input type="hidden" id="entityLevel" value="super"/>
                <input type="hidden" id="entityId" value="0"/>
                <fieldset class="margin_t_10">
                <legend><b>${ctp:i18n("people.basic.info")}</b></legend>
                    <table border="0" cellspacing="0" cellpadding="0" width="380" style="margin-left:42px;margin-right:auto;" align="center" id="templateArea">
                        <tr>
                            <th width="120" nowarp="nowarp"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("template.portal.name")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="name" class="validate"
                                        validate="type:'string',name:'${ctp:i18n("template.portal.name")}',notNull:true,minLength:1,maxLength:85,character:'!@#$%^*()<>'" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th width="120" valign="top"><label class="margin_r_10" for="textarea">${ctp:i18n("template.portal.description")}:</label></th>
                            <td>
                            	<div class="common_txtbox clearfix">
                            		<textarea id="description" style="height:70px;" class="w100b padding_tb_10 validate"
                                        validate="type:'string',name:'${ctp:i18n("template.portal.description")}',maxLength:500,character:'!@#$%^*()<>'" ></textarea>
                            	</div>
                            </td>
                        </tr>
                        <tr>
                            <th width="120"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                            		<input type="text" id="sort" class="validate"
                                        validate="name:'${ctp:i18n("sortnum.label")}',notNull:true,isInteger:true,min:1,max:9999,errorMsg:'${ctp:i18n("sortnum.positiveInteger.prompt")}'" />
                                </div>
                            </td>
                        </tr>
                        <tr >
                            <th width="120"><label class="margin_r_10" for="text">${ctp:i18n("template.portal.path")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                            		<input type="text" id="path" readonly="readonly" />
                            	</div>
                            </td>
                        </tr>
                        <tr class="display_none">
                            <th width="120" valign="top"><label class="margin_r_10" for="text">${ctp:i18n("template.portal.thumbnail")}:</label></th>
                            <td>
                            	<iframe id="thumbnail" width="100%" height="100%" src="" scrolling="yes" ></iframe>
                            </td>
                        </tr>
                    </table>
                </fieldset>
               
                <fieldset class="margin_t_10">
                    <legend><b>${ctp:i18n("template.portal.hotspot.setting")}</b></legend>
                    <input type="hidden" id="hotSpotsCount" value="0"/>
                    <div id="hotspotDiv"></div>
                </fieldset>

                <div class="align_center padding_5">
                    <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">${ctp:i18n("common.button.ok.label")}</a>
                    <a href="javascript:void(0)" id="reDefaultbtn" class="common_button common_button_gray">${ctp:i18n("space.button.toDefault")}</a>
                    <a href="javascript:refreshTable()" class="common_button common_button_gray">${ctp:i18n("common.button.cancel.label")}</a>
                </div>
            </div>
            </div>
            <div id="manual" class="explanationh">
	            <div class="clearfix">
	                <div class="explanationh_title">${ctp:i18n('template.portal.manage')}</div>
	                <div class="explanationh_num">（${ctp:i18n('portal.count.lable')} <span id="count"></span> ${ctp:i18n('portal.unit.lable')}）</div>
	            </div>
	            <ul class="explanationh_list">
	                ${ctp:i18n('template.portal.detailinfo')}
	            </ul>
	        </div>            
        </div>
    </div>
    <input id="myfile" type="text" class="comp" style="display: none" comp="type:'fileupload',quantity:1,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'zip' " />
    <iframe id="downLoadIFrame" name="downLoadIFrame" src="" style="display: none;"/>
</body>
</html>