<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
    <title>个人设置</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=linkSystemManager,linkOptionManager"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#toolbar2").toolbar({
                searchHtml: 'sss',
                toolbar: [{
                    id: "setOptionValue",
                    name: '${ctp:i18n("link.jsp.setoption")}',
                    className: "ico16 modify_text_16",
                    click:function(){
                        var checkedIds = $("input:checked", $("#mytable"));
                        if (checkedIds.size() == 0) {
                          $.alert("${ctp:i18n('link.jsp.setoption.selectone.prompt')}");
                        } else if (checkedIds.size() > 1) {
                          $.alert("${ctp:i18n('link.jsp.setoption.selectone.prompt')}");
                        } else {
                          new linkSystemManager().selectLinkSystem($(checkedIds[0]).attr("value"), {
                            success : function(linkSystem) {
                              var linkOptions = new linkOptionManager().selectLinkOptions(linkSystem.id);
                              if(linkOptions.length>0){
                                $("#linkSystem_tab").html("${ctp:i18n('link.jsp.modify.systemLink')}");
                                mytable.grid.resizeGridUpDown('middle');
                                showDetail(linkSystem);
                                $("input,textarea,a,span,select", $("#optionTable")).attr("disabled", false);
                                $("#submitbtn").show();
                                $("#cancelbtn").show();
                              }else{
                                $.alert("${ctp:i18n('link.jsp.setoption.noparam.prompt')}");
                              }
                            } 
                          });
                        }
                    }
                },
                 {
                    id: "setSort",
                    name: '${ctp:i18n("link.jsp.sort")}',
                    className: "ico16 sort_16",
                    click:function(){
                      var dialog = $.dialog({
                        url : '${path}/portal/linkSystemController.do?method=linkSystemOrder&doType=${isKnowledge?3:0}',
                        targetWindow:window.top,
                        width : 260,
                        height : 215,
                        title : '${ctp:i18n("link.jsp.sort")}',
                        buttons : [ {
                          text : '${ctp:i18n("common.button.ok.label")}',
                          btnType : 1,
                          handler : function() {
                            var linkMembers = new Array();
                            var linkOptions = dialog.getReturnValue();
                              for(var i = 0;i < linkOptions.size();i++){
                                var linkMember = new Object();
                                linkMember.id = getUUID();
                                linkMember.linkSystemId = linkOptions[i].value;
                                linkMember.userLinkSort = i;
                                linkMembers.push(linkMember);
                              }
                              new linkSystemManager().saveLinkMember(linkMembers,{
                              success : function(linkMember){
                                var params = new Object();
                                if("${isKnowledge}"=="true"){
                                 params.categoryId = "${categoryId}";
                                 params.isKnowledge = true;
                                 params.ordered = true;
                                }
                                $("#mytable").ajaxgridLoad(params);
                                dialog.close();
                              }
                            });
                          }
                        }, {
                          text : '${ctp:i18n("common.button.cancel.label")}',
                          handler : function() {
                            dialog.close();
                          }
                        } ]
                      });
                    }
                }]
            });
            var mytable = $("#mytable").ajaxgrid({
              colModel : [ {
                display : 'id',
                name : 'id',
                width : '4%',
                sortable : false,
                align : 'center',
                type : 'checkbox'
              },{
                display : '${ctp:i18n("link.jsp.menu.name")}',
                name : 'lname',
                sortable : true,
                width : '55%'
              },{
                display : '${ctp:i18n("link.jsp.menu.category")}',
                name : 'cname',
                sortable : true,
                width : '20%'
              },{
                  display : '${ctp:i18n("link.jsp.menu.description")}',
                  name : 'ldescription',
                  sortable : true,
                  width : '20%'
              }],
              click : showDetail,
              managerName : "linkSystemManager",
              managerMethod : "selectLinkSystemByUser",
              render : mytableRend,
              height : 200,
              parentId : 'center1',
              slideToggleBtn : true,
              params : {
                isKnowledge : "${isKnowledge}",
                categoryId : "${categoryId}"
              },
              vChange : {
                'changeTar' : 'form_area',
                'subHeight' : 90
              }
            });
            
            function mytableRend(txt, data, r, c) {
              if(c == 2){
                return  $.i18n(data.cname) || txt;
              }
              return txt;
            }
            
            $("#submitbtn").click(function(){
              var formobj = $("#form_area").formobj();
              if (!$._isInValid(formobj)) {
                var linkOptions = $("input", $("#optionTable"));
                var linkOptionValue = new Array();
                if(linkOptions!=null && linkOptions.length>0){
                  for(var i = 0;i < linkOptions.length;i++){
                    var linkOption = linkOptions[i];
                    var optionValue = new Object();
                    optionValue.id = linkOption.optionValueId;
                    optionValue.value = linkOption.value;
                    optionValue.linkOptionId = linkOption.id;
                    linkOptionValue.push(optionValue);
                  }
                }
                new linkOptionManager().saveLinkOptionValue(linkOptionValue,{
                  success : function(data) {
                     $.alert("${ctp:i18n('common.successfully.saved.label')}");
                     $("#grid_detail").hide();
                     mytable.grid.resizeGridUpDown('down');
                  } 
                }
                );
              }
              });
            $("#cancelbtn").click(function(){
              $("#grid_detail").hide();
              mytable.grid.resizeGridUpDown('down');
            });
        });
        
        function check(obj){
        	if($(obj).val().length==0 || $(obj).val()==''){
        		return false;
        	}else{
        		return true;
        	};
        }
        
        function showDetail(data, r, c){
          $("#linkImage").attr("src",data.image);
          $("#optionTable").find("tr:first").nextAll("tr").remove();
          $("#grid_detail").show();
          $("#linkName").html(data.lname);
          var linkOptions = new linkOptionManager().selectLinkOptions(data.id);
          if(linkOptions.length>0){
            for(var i = 0;i<linkOptions.length;i++){
              var linkOption = linkOptions[i];
              var optionValue = linkOption.paramValue;
              var optionValueId = getUUID();
              var linkOptionValue = new linkOptionManager().selectLinkOptionValueCurrent(linkOption.id);
              if(linkOptionValue!=null){
                optionValue = linkOptionValue.value;
                optionValueId = linkOptionValue.id;
              }
              if(optionValue == null){
                optionValue = "";
              }
              var type = "text";
              if(linkOption.password){
                type = "password";
              }
              var html = "<tr>";
              html+="<th title='" + linkOption.paramName + "' nowrap><label class=margin_r_5 for=text>" + escapeStringToHTML(linkOption.paramName) + ":</label></th>";
              html+="<td><div class=common_txtbox_wrap>";
              html+="<input optionName=\"\" id="+linkOption.id+" style='width:100%' value=\""+escapeStringToHTML(optionValue)+"\" optionValueId=\""+optionValueId+"\" class=validate type="+type+" name=truename validate=\"type:'string',name:'"+escapeStringToHTML(linkOption.paramName)+"',maxLength:1000\" >";
              html+="</div></td></tr>";
              $("tbody", $("#optionTable")).append(html);
            }
            $("#detailtab_body").css("height","auto");
          }
          $("#submitbtn").hide();
          $("#cancelbtn").hide();
          $("input,textarea,a,span,select", $("#optionTable")).attr("disabled", true);
        }
        
        function getUUID(){
          var retValue = new linkSystemManager().getUUID().replace("L", "");
          return retValue;
        }
    </script>
    </head>
    <body>
        <div id='layout' class="comp" comp="type:'layout'">
            <div class="layout_north" layout="height:30,sprit:false,border:false">
                <div id="toolbar2">
                </div>
            </div>
            <div class="layout_center page_color over_hidden" layout="border:false">
                <table id="mytable" style="display: none;"></table>
                <div id="grid_detail" class="hidden">
                    <div id=detailtab class=comp comp="type:'tab',height:'180'">
                      <div id=detailtab_head class="common_tabs clearfix">
                        <ul class=left>
                            <li class=current><a class="last_tab" style="width: auto" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n("link.jsp.setsystem")}</span></a> 
                        </ul>
                      </div>
                      <div id=detailtab_body class="common_tabs_body border_all" style="min-height:180px;">
                          <div id="form_area" class="form_area align_center">
                            <table id="optionTable" border=0 cellspacing=0 cellpadding=0 width=250 align=center style="margin-top: 10px">
                              <tbody>
                                <tr>
                                    <td width="100%" height="60%" colspan='2'>
                                        <img id="linkImage" style="width: 32px; height: 32px;" src="${path}/decorations/css/images/portal/defaultLinkSystemImage.png" complete="complete"/>
                                        <label id="linkName" class=margin_r_5 for=text>公司内部协同</label>
                                    </td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                      </div>
                    </div>
                    <div class="align_center padding_t_10 padding_b_10">
                      <a id="submitbtn" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
                      <a id="cancelbtn" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>