<%--
 $Author: zhout $
 $Rev: 51305 $
 $Date:: 2015-09-22 15:49:46#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=loginTemplateManager,portalHotSpotManager"></script>
<script type="text/javascript" src="${path}/main/common/js/frame-ajax.js"></script>
<script>
  var currentPicChangeId = null;
  var Template_Parent_Path = null;
  var entityId = "${entityId}";
  $(document).ready(function() {
      var msg = '${ctp:i18n("info.totally")}';
      $("#entityLevel").val("${entityLevel}");
      $("#entityId").val("${entityId}");
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
			params.entityId = "${entityId}";
			params.entityLevel = "${entityLevel}";
			params.currentAccountId = "${currentAccountId}";
			$("#mytable").ajaxgridLoad(params);
		  }
        },
        conditions: [{
            id: 'templateName',
            name: 'templateName',
            type: 'input',
            text: '${ctp:i18n("template.portal.name")}',
            value: 'templateName'
        },{
            id: 'templateDescription',
            name: 'templateDescription',
            type: 'input',
            text: '${ctp:i18n("template.portal.description")}',
            value: 'templateDescription'
        }]
      });

	  var toolbar = $("#toolbar2").toolbar({
        searchHtml: 'sss',
        toolbar: [
        {
            id: "import",
            name: "${ctp:i18n('template.portal.import')}",
            className: "ico16 import_16",
			click:function(){
				insertAttachment('uploadCallBack');
		 	}
        },{
            id: "export",
            name: "${ctp:i18n('template.portal.export')}",
            className: "ico16 export_16",
			click:function(){
				var checkedIds = $("input:checked", $("#mytable"));
			    if (checkedIds.size() == 0) {
			      $.alert("${ctp:i18n('template.portal.homePage')}");
			    } else {
			      var templateIds = "";
			      for(var i = 0; i < checkedIds.size(); i++){
			    	  templateIds = templateIds + $(checkedIds[i]).val() + ",";
			      }
			      templateIds = templateIds.substr(0, templateIds.length - 1);
			      $("#downLoadIFrame").attr("src", "${path}/portal/loginTemplateController.do?method=exportTemplate&templateIds=" + templateIds);
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
			      if($("div.evo-pop").length > 0){
			        //如果打开了颜色选择面板，先等待颜色面板关闭
			        setTimeout(function(){
			          showDetail(checkedId, entityId, false);
			        }, 600);
			      } else {
			        showDetail(checkedId, entityId, false);
			      }
			      //首文件路径不可修改
			      $("#path").attr("disabled",true);
			    }				
			}
        },{
            id: "delete",
            name: "${ctp:i18n('link.jsp.del')}",
            className: "ico16 del_16",
            click:function(){
            	var checkedIds = $("input:checked", $("#mytable"));
                if (checkedIds.size() == 0) {
                  $.alert("${ctp:i18n('template.portal.homePage')}");
                } else {
                  var params = new Array();
                  for(var i = 0; i < checkedIds.size(); i++){
                    params.push($(checkedIds[i]).val());
                  }
                  var confirm = $.confirm({
                    'type' : 1,
                    'msg' : "${ctp:i18n('template.delete.portal')}",
                    ok_fn : function() {
                      new loginTemplateManager().deleteTemplateByIds(params, {
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
                  'type' : 1,
                  "msg": "${ctp:i18n('template.portal.istodefault_login')}",
                  ok_fn : function() {
                    var entityLevel = $("#entityLevel").val();
                    var entityId = $("#entityId").val();
                    new loginTemplateManager().updateTemplateDefault(id, entityLevel, entityId, {
                      success : function(data) {
                        new portalManager().getPageTitle({
                          success:function(title){
                            if(title){
                            	getCtpTop().document.title = title;
                            	self.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateMain";
                            }
                          }
                        });
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
      },{
        display : '${ctp:i18n("template.portal.name")}',
        name : 'name',
        sortable : true,
        width : '25%'
      },{
        display : '${ctp:i18n("template.portal.description")}',
        name : 'description',
        sortable : true,
        width : '25%'
      },{
          display : '${ctp:i18n("template.portal.ispreset")}',
          name : 'preset',
          sortable : true,
          width : '15%'
      },{
        display : '${ctp:i18n("common.sort.label")}',
        name : 'sort',
        sortable : true,
        width : '15%'
      },{
        display : '${ctp:i18n("template.portal.isdefault")}',
        name : 'sdefault',
        sortable : true,
        width : '15%'
      }],
      click : tclk,
      dblclick : dblclk,
      managerName : "loginTemplateManager",
      managerMethod : "selectTemplate",
      params : {
        entityId : "${entityId}"
      },
      render : rend,
      height : 200,
      parentId : 'center',
      slideToggleBtn : true,
	  vChange: true,
      vChangeParam: {
        'changeTar' : 'form_area',
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
    	}else if(c == 5){
    	  if(data.sdefault == 1){
    	    return '${ctp:i18n("common.yes")}';
          } else {
              return '${ctp:i18n("common.no")}';
          }
    	}
    	return $.i18n(txt) || txt;
    }
    
    //单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
      if($("div.evo-pop").length > 0){
        //如果打开了颜色选择面板，先等待颜色面板关闭
        setTimeout(function(){
          $("#form_area").resetValidate();
          $("input:checked", $("#mytable")).attr("checked", false);
          $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true);
          showDetail(data.id, entityId, true);
        }, 600);
      } else {
        $("#form_area").resetValidate();
        $("input:checked", $("#mytable")).attr("checked", false);
        $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true);
        showDetail(data.id, entityId, true);
      }
    }
    
    //双击列表中一行
    function dblclk(data, r, c) {
      $("#form_area").resetValidate();
      setTimeout(function(){
        $("#modify_a").click();
      }, 300);
    }
    
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
  	    $.alert("${ctp:i18n('login.template.error.picture')}");
  		return false;
  	  }
  	  bool=checkPictureNull();
  	  if(bool==false){
  	    $.alert("${ctp:i18n('login.template.picture.null')}");
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
	  var url1=$("#hotspotvalue2").val();
	  var url2=$("#hotspotvalue3").val();
	  if (escape(url1).indexOf('%u') != -1||escape(url2).indexOf('%u') != -1) {
	    $.alert("${ctp:i18n('path.cannot.contain.chinese')}");
		return false;
	  }
	  bool=checkInteger();
	  if(bool==false){
	    //$.alert("${ctp:i18n('portal.sort.val.check')}");
	    return false;
	  }
      if (!$._isInValid(formobj) && $("#id").val() != 0) {
    	//$("#form_area").jsonSubmit({action:"loginTemplateController.do?method=saveTemplate", debug:false});
    	//增加提交遮蔽
    	showMask();
    	new loginTemplateManager().transSaveTemplate($("#form_area").formobj(),{
          success : function(){
            //撤销遮蔽
            hideMask();
            new portalManager().getPageTitle({
              success:function(title){
                if(title){
                  $(top.document).attr("title", title);
                  self.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateMain";
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
            new loginTemplateManager().transReSetToDefault(templateId, entityId,{
              success : function(){
                new portalManager().getPageTitle({
                  success:function(title){
                    if(title){
                      $(top.document).attr("title", title);
                      self.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateMain";
                    }
                  }
                });
              }
            });
          }
      });
  	});
  	
    $("#form_area").hide();
    $("#manual").show();
    mytable.grid.resizeGridUpDown('down');
    $("#count").html(msg.format(mytable.p.total));
  });
  
  function showDetail(templateId,entityId,readonly){
    $("#manual").hide();
    var entityLevel = $("#entityLevel").val();
    var entityId = $("#entityId").val();
    new loginTemplateManager().selectTemplateById(templateId,{
      success : function(template) {
        mytable.grid.resizeGridUpDown('middle');
        $("#form_area").show();
        if(readonly){
          $("input,textarea", $("#form_area")).attr("disabled", true);
          $("#form_area .align_center").hide();
        }else{
          $("#form_area .align_center").show();
          if(entityLevel == "account"){
              $("#name").attr("disabled", true);
              $("#description").attr("disabled", true);
              $("#sort").attr("disabled", true);
          } else {
        	  $("#name").attr("disabled", false);
              $("#description").attr("disabled", false);
              $("#sort").attr("disabled", false);
          }
          $("a",$("#button_area")).attr("disabled", false);
          $("#id").val(template.id);
        }
        $("#name").val($.i18n(template.name) || template.name);
        $("#thumbnail").attr("src", "${path}/main/common/showImg.html?src=${path}/main/login/" + template.thumbnail);
        $("#path").val(template.path);
        Template_Parent_Path = template.path.substring(0, template.path.indexOf("/"));
        $("#description").val($.i18n(template.description) || template.description);
        $("#sort").val(template.sort);
        //热点
        new portalHotSpotManager().getHotSpotByTemplateId0(templateId, entityId, {
          success : function(portalHotspots) {
              $("#hotSpotsCount").val(portalHotspots.length);
              var html = "";
              for(var i = 0; i < portalHotspots.length; i++){
                  portalHotspots[i].hotspotvalue = escapeStringToHTML(portalHotspots[i].hotspotvalue);
                  var split = "";
                  if(i > 0){
                    split = "border_t margin_t_10 padding_t_10";
                  }
                  if(portalHotspots[i].entityLevel.toLowerCase().indexOf(entityLevel) == -1 && entityLevel != "account" && entityLevel != "super"){
                    split += " display_none";
                  }
                  if((portalHotspots[i].hotspotkey.toLowerCase() == 'note' || portalHotspots[i].hotspotkey.toLowerCase() == 'newfeature') && entityLevel == "account"){
                	//如果是开启了独立登录页的单位管理员，并且热点是"系统标题项名称"
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
                  html += "<th nowrap=\"nowrap\" width=\"160\"><label class=\"margin_r_10\" for=\"text\">" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + ":</label></th>";
                  html += "<td width=250 nowrap=\"nowrap\" >";
                  if(portalHotspots[i].type == 0){
                    if(portalHotspots[i].hotspotkey == "changebgispeed"){
                      html += "<div class=\"common_radio_box\">";
                      html += "<label for=\"hotspotvalue" + i + "1\" class=\"margin_r_10 hand\"><input type=\"radio\" value=\"800\" id=\"hotspotvalue" + i + "1\" name=\"hotspotvalue" + i + "\" class=\"radio_com\" " + (portalHotspots[i].hotspotvalue == '800'?"checked":"") + " />${ctp:i18n('hotspot.name.changebgispeed.value1')}</label>";
                      html += "<label for=\"hotspotvalue" + i + "2\" class=\"margin_r_10 hand\"><input type=\"radio\" value=\"1100\" id=\"hotspotvalue" + i + "2\" name=\"hotspotvalue" + i + "\" class=\"radio_com\" " + (portalHotspots[i].hotspotvalue == '1100'?"checked":"") + " />${ctp:i18n('hotspot.name.changebgispeed.value2')}</label>";
                      html += "<label for=\"hotspotvalue" + i + "3\" class=\"hand\"><input type=\"radio\" value=\"1800\" id=\"hotspotvalue" + i + "3\" name=\"hotspotvalue" + i + "\" class=\"radio_com\" " + (portalHotspots[i].hotspotvalue == '1800'?"checked":"") + " />${ctp:i18n('hotspot.name.changebgispeed.value3')}</label>";
                      html += "</div>";
                    } else if(portalHotspots[i].hotspotkey == "newfeature"){
                    	html += "<div class=\"common_checkbox_box\">";
                        html += "<label for=\"hotspotvalue" + i + "\" class=\"margin_r_10 hand\"><input type=\"checkbox\" value=\"show\" id=\"hotspotvalue" + i + "\" name=\"hotspotvalue" + i + "\" class=\"radio_com\" " + (portalHotspots[i].hotspotvalue == 'show'?"checked":"") + " />${ctp:i18n("common.display.show.label")}</label>";
                        html += "</div>";
                    } else {
                      html += "<div class=\"common_txtbox_wrap\"><input id=\"hotspotvalue" + i + "\" class=\"validate\" validate=\"type:'string',name:'" + ($.i18n(portalHotspots[i].name) || portalHotspots[i].name) + "',maxLength:500,avoidChar:'&@$%^*<>'\" type=\"text\" value=\"" + ($.i18n(portalHotspots[i].hotspotvalue) || portalHotspots[i].hotspotvalue) + "\"/></div>";
                    }
                  } else if(portalHotspots[i].type == 1){
                    html += "<input id=\"myfile" + i + "\" type=\"hidden\"/>";
                    html += "<div class=\"common_txtbox_wrap\"><input id=\"picFileId" + i + "\" type=\"hidden\" /><input id=\"hotspotvalue" + i + "\" name='picture' class=\"validate\" validate=\"type:'string',notNull:true,name:'${ctp:i18n("hotspot.value.label")}',minLength:1,maxLength:500\" type=\"text\" value=\"" + ((portalHotspots[i].hotspotvalue == null || portalHotspots[i].hotspotvalue == "null")? "":portalHotspots[i].hotspotvalue) + "\" onclick=\"currentPicChangeId='" + i + "';insertAttachmentPoi('poi" + i + "');\" readonly=\"readonly\" /></div>";                  
                  } else if(portalHotspots[i].type == 2){
                    html += "<input id=\"hotspotvalue" + i + "\" class=\"validate\" validate=\"type:'string',notNull:false,name:'${ctp:i18n("hotspot.value.label")}',minLength:1,maxLength:20\" type=\"text\" value=\"" + ((portalHotspots[i].hotspotvalue == null || portalHotspots[i].hotspotvalue == "null")? "":portalHotspots[i].hotspotvalue) + "\" style=\"width:200px;height:25px\" readonly=\"readonly\" />";
                  }
                  html += "</td>";
                  if(portalHotspots[i].type == 1 && portalHotspots[i].ext3==1){
                    html += "<td nowrap=\"nowrap\">&nbsp;&nbsp;<label class=\"margin_r_10 hand\" for=\"display" + i + "\"><input id=\"display" + i + "\" type=\"checkbox\" "+(portalHotspots[i].display == 0?"checked":"")+"/>${ctp:i18n("template.portal.fontnotshow")}</label></td>";
                  } else {
                    html += "<td nowrap=\"nowrap\">&nbsp;</td>";
                  }
                  if(portalHotspots[i].type == 1){
                    html += "<tr>";
                    html += "<th nowrap=\"nowrap\" valign=\"top\" width=\"160\"><label class=\"margin_r_10\" for=\"text\">${ctp:i18n("template.portal.thumbnail")}:</label></th>";
                    html += "<td width=250>";
                    var imgSrc = "";
                    if(portalHotspots[i].hotspotvalue.indexOf("fileUpload.do") != -1){
                      imgSrc = "${path}/" + portalHotspots[i].hotspotvalue + "&expand=" + portalHotspots[i].tiling;
                    } else if(portalHotspots[i].hotspotvalue && portalHotspots[i].hotspotvalue != "" &&  portalHotspots[i].hotspotvalue != "null"){
                      imgSrc = "${path}/main/login/" + portalHotspots[i].hotspotvalue+ "?expand=" + portalHotspots[i].tiling;
                    }
                    var _iframeSrc = "${path}/main/common/showImg.html?src="+imgSrc;
                    if(imgSrc == ""){
                    	_iframeSrc = "";
                    }
                    html += "<iframe id=\"showImgIframe" + i + "\" width=\"100%\" height=\"100px\" src=\"" + _iframeSrc + "\" scrolling=\"yes\" />";
                    html += "</td>";
                    html += "<td>&nbsp;</td></tr>";
                    if(portalHotspots[i].hotspotkey=='contentbgi'){
                      html += "<tr>";
                      html += "<td>"
                      html += "</td>";
                      html += "<td width=\"160\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.login.hotspot.loginpic.instruction")}</label></td>";
                      html += "</tr>";
                    }
                    if(portalHotspots[i].hotspotkey=='mainbgi'){
	                    html += "<tr>";
	                    html += "<th nowrap=\"nowrap\" width=\"160\"><label class=\"margin_r_10\" for=\"text\">${ctp:i18n("template.portal.tiling")}:</label></th>";
	                    html += "<td><div class=\"common_checkbox_box\">";
	                    html += "<input id=\"hotspotTiling" + i + "\" class=\"radio_com\" type=\"checkbox\" value=\"1\"" + (portalHotspots[i].tiling == 1?'checked':'unchecked') + " onclick=\"hotspotTilingOnclickHandler('" + i + "');\" />";
	                    html += "</div></td>";
	                    html += "</tr>";
                    }
                    if(portalHotspots[i].hotspotkey=='topbgi'){
                      html += "<tr>";
                      html += "<td>"
                      html += "</td>";
                      html += "<td width=\"160\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.login.hotspot.topbgi.instruction")}</label></td>";
                      html += "</tr>";
                    }
                    if(portalHotspots[i].hotspotkey=='changebgi5'){
                      html += "<tr>";
                      html += "<td>"
                      html += "</td>";
                      html += "<td width=\"160\"><label class=\"margin_r_0\" for=\"text\">${ctp:i18n("template.login.hotspot.changebgi5.instruction")}</label></td>";
                      html += "</tr>";
                    }
                  }
                  if(template.preset=="0"){
	                  if(portalHotspots[i].description != null&&portalHotspots[i].description.length>0){
	                    html += "<tr>";
	                    html += "<th nowrap=\"nowrap\" width=\"160\"><label class=\"margin_r_10\" for=\"text\">${ctp:i18n("hotspot.description.label")}:</label></th>";
	                    html += "<td>";
	                    html += ((portalHotspots[i].description == null || portalHotspots[i].description == "null")? "&nbsp;":portalHotspots[i].description);
	                    html += "</td>";
	                    html += "</tr>";
	                  }
                  }
                  html += "</table>";
              }
              $("#hotspotDiv").html(html);
              for(var i = 0; i < portalHotspots.length; i++){
                if(portalHotspots[i].type == 1){
                    dymcCreateFileUpload("myfile" + i,1,"jpg,jpeg,gif,bmp,png",1,false,"uploadCallBack2", "poi" + i,true,true,null,false,true,2097152);
                } else if(portalHotspots[i].type == 2){
                  if(!readonly) $("#hotspotvalue" + i).colorpicker({position:false});
                }
              }
              if(readonly){
                $("input,textarea", $("#form_area")).attr("disabled", true);
              }
           }
        });
      }
    });
  }
  
  function uploadCallBack(fileid){
    new loginTemplateManager().transUploadLoginTemplate(fileid,{
      success : function(){
        $.messageBox({
          'title':'系统提示',
          'type': 0,
          'msg': '导入成功！',
          'imgType':0,
           ok_fn:function(){location.reload(true);}
        });
      }
    });
  }
  
  function uploadCallBack2(attachment){
	  if(currentPicChangeId != null){
		  $("#picFileId" + currentPicChangeId).val(attachment.instance[0].fileUrl);
		  $("#hotspotvalue" + currentPicChangeId).val("fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
		  var expand = 0;
		  if($("#hotspotTiling" + currentPicChangeId).attr("checked") == "checked"){
			  expand = 1;
		  }
		  $("#showImgIframe" + currentPicChangeId).attr("src", "${path}/main/common/showImg.html?src=${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&expand=" + expand + "&type=image");
	  }
  }
  
  function hotspotTilingOnclickHandler(id){
	  var checked = $("#hotspotTiling" + id).attr("checked");
	  var src = $("#showImgIframe" + id).attr("src");
	  if(checked == "checked"){
		  src = src.replace("expand=0", "expand=1");
	  } else {
		  src = src.replace("expand=1", "expand=0");
	  }
	  $("#showImgIframe" + id).attr("src", src);
  }
  
  //刷新列表
  function refreshTable(){
	  self.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateMain";
  }

</script>
</head>
<body>
    <c:if test="${entityLevel eq 'system' or entityLevel eq 'account'}">
        <div class="comp" comp="type:'breadcrumb',code:'T03_loginTemplateList'"></div>
    </c:if>
    <c:if test="${entityLevel eq 'super'}">
        <div class="comp" comp="type:'breadcrumb',code:'T03_loginTemplateListAdmin'"></div>
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
            <div class="form_area" id="form_area" >
            <div style="width:600px; margin:0 auto;">
            	<input type="hidden" id="id" value="0"/>
            	<input type="hidden" id="entityLevel" value="super"/>
                <input type="hidden" id="entityId" value="0"/>
                <fieldset class="margin_t_10">
                <legend><b>${ctp:i18n("people.basic.info")}</b></legend>
                    <table border="0" cellspacing="0" cellpadding="0" width="410" style="margin-left:43px;margin-right:auto;" align="center">
                        <tr>
                            <th width="160"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("template.portal.name")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="name" class="validate"
                                        validate="type:'string',name:'${ctp:i18n("template.portal.name")}',notNull:true,minLength:1,maxLength:85,character:'!@#$%^*()<>'" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th valign="top" width="160"><label class="margin_r_10" for="text">${ctp:i18n("template.portal.description")}:</label></th>
                            <td>
                            	<div class="common_txtbox clearfix">
                            		<textarea id="description" style="height:70px;width: 248px" class="w100b validate padding_tb_10"
                                        validate="type:'string',name:'${ctp:i18n("template.portal.description")}',maxLength:500,character:'!@#$%^*()<>'" ></textarea>
                            	</div>
                            </td>
                        </tr>
                        <tr>
                            <th width="160"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                            		<input type="text" id="sort" class="validate"
                                        validate="name:'${ctp:i18n("sortnum.label")}',notNull:true,isInteger:true,min:1,max:9999,errorMsg:'${ctp:i18n("sortnum.positiveInteger.prompt")}'" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th width="160"><label class="margin_r_10" for="text">${ctp:i18n("template.portal.path")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                            		<input type="text" id="path" readonly="readonly"/>
                            	</div>
                            </td>
                        </tr>
                        <tr class="display_none">
                            <th valign="top" width="160"><label class="margin_r_10" for="text">${ctp:i18n("template.portal.thumbnail")}:</label></th>
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
                <div class="align_center padding_5" id = "button_area">
                    <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">${ctp:i18n("common.button.ok.label")}</a>
                    <a href="javascript:void(0)" id="reDefaultbtn" class="common_button common_button_gray">${ctp:i18n("space.button.toDefault")}</a>
                    <a href="javascript:refreshTable()" class="common_button common_button_gray">${ctp:i18n("common.button.cancel.label")}</a>
                </div>
            </div>
        </div>        
            <div id="manual" class="color_gray margin_l_20 display_none">
              <div class="clearfix">
                <h2 class="left">${ctp:i18n('template.login.set')}</h2>
                <div class="font_size12 left margin_t_20 margin_l_10">
                    <div class="margin_t_10 font_size14">
                        <span id="count"></span>
                    </div>
                </div>
              </div>
              <div class="line_height160 font_size14">
                  ${ctp:i18n('template.login.detailinfo')}
              </div>
            </div>
        </div>
    </div>
    <input id="myfile" type="text" class="comp" style="display: none" comp="type:'fileupload',quantity:1,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'zip' " />
    <iframe id="downLoadIFrame" name="downLoadIFrame" src="" style="display: none;"/>
</body>
</html>