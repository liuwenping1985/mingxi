<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2013-01-07 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
var grid;
$(document).ready(function() {
	var arr = new Array();
		if("${canSelect}"=='true'){
			var ob = new Object();
			ob.display = "";
			ob.name = "id";
			ob.width = "5%";
			ob.sortable = false;
			ob.align = "center";
			ob.type = "radio";
			arr.push(ob);
		}
		var ob = new Object();
		if("${moduleType}" == 401 || "${moduleType}" == 402 || "${moduleType}" == 403){
			ob.display = "${ctp:i18n('edocform.seeyontemplatename.label')}";
		}else{
			ob.display = "${ctp:i18n('form.seeyontemplatename.label')}";
		}
		ob.name = "name";
		ob.width = "30%";
		ob.sortable = false;
		ob.align = "left";
		arr.push(ob);
		var ob = new Object();
		if("${moduleType}" == 401 || "${moduleType}" == 402 || "${moduleType}" == 403){
			ob.display = "${ctp:i18n('form.base.edocformname.label')}";
		}else{
			ob.display = "${ctp:i18n('form.base.formname.label')}";
		}
		ob.name = "formname";
		ob.width = "20%";
		ob.sortable = false;
		ob.align = "left";
		arr.push(ob);
		var ob = new Object();
		ob.display = "${ctp:i18n('formsection.config.template.category')}";
		ob.name = "category";
		ob.width = "10%";
		ob.sortable = false;
		ob.align = "left";
		arr.push(ob);
		if("${moduleType}" != 401 && "${moduleType}" != 402 && "${moduleType}" != 403){
			var ob = new Object();
			ob.display = "${ctp:i18n('form.base.affiliatedsortperson.label')}";
			ob.name = "owner";
			ob.width = "10%";
			ob.sortable = false;
			ob.align = "left";
			arr.push(ob);
		}
		if("${canSelect}"!='true'){
			var ob = new Object();
				ob.display = "${ctp:i18n('form.flow.templete.auth')}";
				ob.name = "auths";
				ob.width = "15%";
				ob.sortable = false;
				ob.align = "left";
				arr.push(ob);
			var ob = new Object();
				ob.display = "${ctp:i18n('form.flow.templete.super')}";
				ob.name = "watcher";
				ob.width = "10%";
				ob.sortable = false;
				ob.align = "left";
				arr.push(ob);
		}
		var ob = new Object();
		ob.display = "${ctp:i18n('form.base.modifytime')}";
		ob.name = "modifyTime";
		ob.width = "15%";
		ob.sortable = false;
		ob.align = "left";
		arr.push(ob);
		if(arr.length==5){
			arr[1].width = "50%";
		}
	            	  grid = $("table.flexme3").ajaxgrid({
	                  colModel : arr,
	                  managerName : "formListManager",
	                  managerMethod : "getFlowTemplateList",
	                  click :clk,
	                  dblclick : dblclk,
	                  usepager : true,
	                  useRp : true,
	                  rp : 10,
	                  sortname: "name",
	                  sortorder: "asc",
	                  resizable : true,
	                  showTableToggleBtn: false,
	                        parentId:"center",
	                        vChange: true,
	    					vChangeParam: {
	    		                overflow: "hidden",
	    						autoResize:true
	    		            },
	                        slideToggleBtn: true
	                });
	                var o = new Object();
	               o.formId="${formId}";
	               o.ownerId="${ownerId}";
	               o.notTemplateId="${notTemplateId}";
	               o.moduleType="${moduleType}";
	                $("#mytable").ajaxgridLoad(o);
	                function rend(txt, data, r, c) {
	                }
	                function clk(data, r, c) {
	                    var formApp = data.formApp||"";
	                    $("#viewFrame").prop("src","${path}/workflow/designer.do?method=showDiagram&isDebugger=false&scene=2&processId="+data.workflowId+"&formApp="+formApp);
	                }
	                function dblclk(data, r, c){
	                	 $("#viewFrame").prop("src","${path}/workflow/designer.do?method=showDiagram&isDebugger=false&scene=2&processId="+data.workflowId);
	                }
	    	  if("${canSelect}"=='true'){
		    	  setSearch();
	    	  }
	      });
	  function OK()
	  {
		  if("${canSelect}"=='true'){
			  var v = new Array();
			  $("#mytable").formobj({
	              gridFilter : function(data, row) {
	              	if($("input:radio", row)[0].checked&&data.name!=null){
		              	v[v.length]= data;
	              	}
	                return false;
	              }
	            });
		 /* var v = $("#mytable").formobj({//组件问题没有选上
              gridFilter : function(data, row) {
                return $("input:checkbox", row)[0].checked;
              }
            }); */
		  if(v.length<1){
			   $.alert("${ctp:i18n('form.authDesign.chooseone')}");	 
		  }
		  else if(v.length>1){
	          $.alert("${ctp:i18n('form.authDesign.onlychooseone')}");
          }
    	  return v;
		  }
	  }
	  function setSearch()
	  {
	      var category=new Array();
	      <c:forEach items="${formTemplateCategorys}" var="category" varStatus="status">
	      category[category.length] = {'value':"${category.id }",'text':"${fn:escapeXml(category.name) }"};
	      </c:forEach>
			  var conditions = [{
				  id: 'templateName',
				  name: 'templateName',
				  type: 'input',
				  text: "${ctp:i18n('form.seeyontemplatename.label')}",
				  value: 'templateName'
			  },{
				  id: 'formname',
				  name: 'formname',
				  type: 'input',
				  text: "${ctp:i18n('form.base.formname.label')}",
				  value: 'formname'
			  },			  
			  {
				  id: 'category',
				  name: 'category',
				  type: 'select',
				  text: "${ctp:i18n('formsection.config.template.category')}",
				  value: 'category',
				  items: category
			  }, 
			  {
				  id: 'modifyTime',
				  name: 'modifyTime',
				  type: 'datemulti',
				  text: "${ctp:i18n('form.base.modifytime')}",
				  value: 'modifyTime',
				  ifFormat:'%Y-%m-%d',
				  dateTime: false
			  }];
		  if("${moduleType}" == 401 || "${moduleType}" == 402 || "${moduleType}" == 403 || "${moduleType}" == 404){
			  conditions=[{
				  id: 'templateName',
				  name: 'templateName',
				  type: 'input',
				  text: "${ctp:i18n('edocform.seeyontemplatename.label')}",
				  value: 'templateName'
			  },{
				  id: 'formname',
				  name: 'formname',
				  type: 'input',
				  text: "${ctp:i18n('form.base.edocformname.label')}",
				  value: 'formname'
			  },{
				  id: 'modifyTime',
				  name: 'modifyTime',
				  type: 'datemulti',
				  text: "${ctp:i18n('form.base.modifytime')}",
				  value: 'modifyTime',
				  ifFormat:'%Y-%m-%d',
				  dateTime: false
			  }];
		  }
		  var searchobj = $.searchCondition({
				top:20,
				right:10,
		      searchHandler: function(){
		          //alert('执行查询')
					var ssss = searchobj.g.getReturnValue();
		          if(ssss == null){
		            return;
		          }
				  	  var o = new Object();
		               o.formId="${formId}";
		               o.ownerId="${ownerId}";
		               o.moduleType="${moduleType}";
		               o.notTemplateId="${notTemplateId}";
		               o.forcheck='true';//后台过滤用,无实际意义
				  	o[ssss.condition] = ssss.value;
				  	grid.p.newp = 1;
				  	$("#mytable").ajaxgridLoad(o);
		      },
		      conditions: conditions
		  });
			//searchobj.g.setCondition('name','');
	  }
</script>