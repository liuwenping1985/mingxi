<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=thirdpartyUserMapperCfgManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=orgManager"></script>
<script type="text/javascript">
        $().ready(function() {
        	var tum = new thirdpartyUserMapperCfgManager();
            var mytable = $("#mytable").ajaxgrid({
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
                             name: 'memberId',
                             width: '5%',
                             sortable: true,
                             type: 'checkbox'
                           }, 
                           {
                               display: "${ctp:i18n('cip.manager.binding.v5.name')}",
                               name: 'name',
                               width: '15%',
                               sortable: true
                             }, 
                           {
                             display: "${ctp:i18n('cip.manager.binding.colluser')}",
                             name: 'memberLoginName',
                             width: '15%',
                             sortable: true
                           }, 
                {
                    display: "${ctp:i18n('cip.manager.binding.collcode')}",
                    sortable: true,
                    name: 'memberCode',
                    width: '15%'
                },
                {
                    display: "${ctp:i18n('cip.manager.binding.thirdaccount')}",
                    name: 'thirdAccount',
                    width: '15%'
                },
                {
                    display: "${ctp:i18n('cip.manager.binding.thirdcode')}",
                    sortable: true,
                    name: 'thirdCode',
                    width: '15%'
                },
                {
                    display: "${ctp:i18n('cip.manager.binding.colum.thirdemail')}",
                    name: 'thirdEmail',
                    width: '15%'
                 }, 
                 {
                     display: "${ctp:i18n('cip.manager.binding.colum.thirdemobile')}",
                     name: 'thirdMobile',
                     width: '15%'
                  }, 
                {
                    display: "${ctp:i18n('cip.manager.binding.state')}",
                    sortable: true,
                    name: 'isEnable',
                    width: '10%',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.vo.MapperEnableEnum'"
                }
                ],
                width: "auto",
                managerName: "thirdpartyUserMapperCfgManager",
                managerMethod: "listUserMapper",
                parentId:'center',
                render: rend,
                click: gridclk,
                dblclick:griddbclick
            });
            
            var searchobj = $.searchCondition({
                top: 2,
                right: 10,
                searchHandler: function() {
                  ssss = searchobj.g.getReturnValue();
                  ssss.registerId="${registerId}";
                  $("#mytable").ajaxgridLoad(ssss);
                },
                conditions: [{
                  id: 'name',
                  name: 'name',
                  type: 'input',
                  text: "${ctp:i18n('cip.manager.binding.v5.name')}",
                  value: 'name'
                },
                {
                    id: 'login_name',
                    name: 'login_name',
                    type: 'input',
                    text: "${ctp:i18n('cip.manager.binding.colluser')}",
                    value: 'login_name'
                  },
                  {
                      id: 'third_email',
                      name: 'third_email',
                      type: 'input',
                      text: "${ctp:i18n('cip.manager.binding.colum.thirdemail')}",
                      value: 'third_email'
                    },
                  {
                      id: 'third_mobile',
                      name: 'third_mobile',
                      type: 'input',
                      text: "${ctp:i18n('cip.manager.binding.colum.thirdemobile')}",
                      value: 'third_mobile'
                    },
                    {
                        id: 'is_enable',
                        name: 'is_enable',
                        type: 'select',
                        text: "${ctp:i18n('cip.manager.binding.state')}",
                        value: 'enableValue',
                        codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.vo.MapperEnableEnum'"
                      }
                ]
              });
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
              	 var detail=  tum.getThirdUserMapperVO(v[0].memberId,"${registerId}");
                $("#addForm").fillform(detail);
                $("#bindingForm").show();
                $("#bindingForm").enable();
            	$("#button").show();
            	if(detail.id==0){
            		$("#id").val("-1");
            	}
            	 $("#memberLoginName").disable();
            	 $("#memberCode").disable();
              }
       	   function rend(txt, data, r, c) {
				if (data.isEnable == 0&&c==1) {
				  return "<font color=#AAAAAA>" + txt + "</font>";
				}else{return txt;}
			  }
            var o = new Object();
            o.registerId="${registerId}";
            $("#mytable").ajaxgridLoad(o);
        	
            $("#toolbar").toolbar({
                toolbar: [{
                  id: "auto",
                  name: "${ctp:i18n('cip.manager.binding.automapper')}",
                  className: "ico16",
                  click: function() {
                      $.confirm({
                          'msg': "${ctp:i18n('cip.manager.binding.confirm.automapper')}",
                          ok_fn: function() {
                        	  var synType = $("input[name=mapper]:checked", window.parent.document).attr("id");
                        	  document.hiddenIframe.location.href = "<c:url value='/cip/userBindingController.do?method=autoMapper&autoMapperType="+synType+"&registerId="+"${registerId}"+"'/>";                   
                          }
                      });
                  }
              },
              {
                  id: "add",
                  name: "${ctp:i18n('common.toolbar.new.label')}",
                  className: "ico16 editor_16",
                  click: function() {
                    	$("#bindingForm").show();
                    	$("#button").show();
                    	$("#welcome").hide();
                    	mytable.grid.resizeGridUpDown('middle');
                    	$("#memberLoginName").enable();
                   	    $("#memberCode").enable();
                    }
              },
              {
                id: "modify",
                name: "${ctp:i18n('common.button.modify.label')}",
                className: "ico16 del_16",
                click: function() {
                	 griddbclick();
                }
            }
                ]
            });
            
            function gridclk(data, r, c) {
            	  var v = $("#mytable").formobj({
            	        gridFilter : function(data, row) {
            	          return $("input:checkbox", row)[0].checked;
            	        }
            	      });
          	  $("#addForm").clearform({clearHidden:true});
          	  $("#addForm").disable();
          	  $("#bindingForm").show();
          	  $("#button").hide();
          	  $("#welcome").hide();
          	  var detail=  tum.getThirdUserMapperVO(v[0].memberId,"${registerId}");
          	  $("#addForm").fillform(detail);
          	  mytable.grid.resizeGridUpDown('middle');
          
          }
            function selectPeople(){
          	  $.selectPeople({
                    type: 'selectPeople',
                    panels: 'Department,Post,Level,Outworker,Team,RelatePeople',
                    selectType: 'Member',
                    onlyLoginAccount:false,
                    hiddenRootAccount:false,
                    returnValueNeedType : false,
                    maxSize:1,
                    text : $("#memberLoginName").val(),
                    params: {value:$("#memberId").val()},
                    callback: function(ret) {
                    	if(ret!=null){
                    	var om=new orgManager();
                    	var member = om.getMemberById(ret.value);
                  	    $("#memberLoginName").val(ret.text);
                  	    if(member!=null){
                  	    	if(member.code!=null&&member.code!=""){
                                $("#memberCode").val(member.code);
                  	    	}
                  	    }
                        $("#memberId").val(ret.value);
                    	}
                       
                    }
              });
            }
            
            $("#memberLoginName").attr("readonly","readonly");
            $("#memberCode").attr("readonly","readonly");
            $("#memberLoginName").bind("click",function() {
          	  selectPeople();
            });
            $("#memberCode").bind("click",function() {
            	  selectPeople();
              });
            $("#btncancel").click(function() {
                location.reload();
            });
            $("#btnok").click(function() {
                if(!($("#bindingForm").validate())){		
                  return;
                }
                if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
                try{
                	  $("#registerId").val("${registerId}");
                	  tum.saveUserMapper($("#addForm").formobj(), {
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
        });
</script>
<style>
.footer_height { 
height: 65px;
}
</style>
</head>
<body> 
 
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">  
      <div id="toolbar"></div>
   </div>
    <div  class="layout_center over_hidden" id="center">
        <table id="mytable" class="flexme3" ></table>
      <div id="grid_detail"  style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="bindingForm" class="form_area" style="overflow-y:hidden;">
                     <%@include file="bindingForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height footer_height">
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
</div>
<iframe name="hiddenIframe" style="display:none"></iframe>
</body>
</html>