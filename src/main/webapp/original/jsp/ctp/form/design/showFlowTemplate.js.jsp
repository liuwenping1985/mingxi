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
$(document).ready(
	      function() {
	            	  if("${canSelect}"=='true'){
	            	  var theadarr=[
		                              {
		        	                	  display : '',
		        		                    name : 'id',
		        		                    width : '5%',
		        		                    sortable : false,
		        		                    align : 'center',
		        		                    type : 'radio'
		        	                  }
		        	                  ,{
		        	                    display : "${ctp:i18n('form.seeyontemplatename.label')}",
		        	                    name : 'name',
		        	                    width : '30%',
		        	                    sortable : false,
		        	                    align : 'left'
		        	                  },
		        	                  {
		        		                    display : "${ctp:i18n('form.base.formname.label')}",
		        		                    name : 'formname',
		        		                    width : '20%',
		        		                    sortable : false,
		        		                    align : 'left'
		        		                  },
		        		                  {
		        			                    display : "${ctp:i18n('formsection.config.template.category')}",
		        			                    name : 'category',
		        			                    width : '10%',
		        			                    sortable : false,
		        			                    align : 'left'
		        			                  },
		        			                  {
		        			                      display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
		        			                      name : 'owner',
		        			                      width : '10%',
		        			                      sortable : false,
		        			                      align : 'left'
		        			                    } ,
		        			                    {
		        			                        display : "${ctp:i18n('form.base.modifytime')}",
		        			                        name : 'modifyTime',
		        			                        width : '15%',
		        			                        sortable : true,
		        			                        align : 'left'
		        			                      }];
	            	  }else{
	            		  var theadarr=[{
      	                    display : "${ctp:i18n('form.seeyontemplatename.label')}",
    	                    name : 'name',
    	                    width : '20%',
    	                    sortable : false,
    	                    align : 'left'
    	                  },
    	                  {
    		                    display : "${ctp:i18n('form.base.formname.label')}",
    		                    name : 'formname',
    		                    width : '20%',
    		                    sortable : false,
    		                    align : 'left'
    		                  },
    		                  {
    			                    display : "${ctp:i18n('formsection.config.template.category')}",
    			                    name : 'category',
    			                    width : '14%',
    			                    sortable : false,
    			                    align : 'left'
    			                  },
    			                  {
    			                      display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
    			                      name : 'owner',
    			                      width : '10%',
    			                      sortable : false,
    			                      align : 'left'
    			                    } ,
    			                      {
    				                    display : "${ctp:i18n('form.flow.templete.auth')}",
    				                    name : 'auths',
    				                    width : '10%',
    				                    sortable : false,
    				                    align : 'left'
    				                  }, {
    				                    display : "${ctp:i18n('form.flow.templete.super')}",
    				                    name : 'watcher',
    				                    width : '10%',
    				                    sortable : false,
    				                    align : 'left'
    				                  }, 
    			                    {
    			                        display : "${ctp:i18n('form.base.modifytime')}",
    			                        name : 'modifyTime',
    			                        width : '15%',
    			                        sortable : true,
    			                        align : 'left'
    			                      }];
	            	  }
	            	  grid = $("table.flexme3").ajaxgrid({
	                  colModel : theadarr,
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
		               o.notTemplateId="${notTemplateId}";
		               o.forcheck='true';//后台过滤用,无实际意义
				  	o[ssss.condition] = ssss.value;
				  	grid.p.newp = 1;
				  	$("#mytable").ajaxgridLoad(o);
		      },
		      conditions: [{
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
				   },{
			              id: 'category',
			              name: 'category',
			              type: 'select',
			              text: "${ctp:i18n('formsection.config.template.category')}",
			              value: 'category',
			              items: category
			          }, {
			              id: 'modifyTime',
			              name: 'modifyTime',
			              type: 'datemulti',
			              text: "${ctp:i18n('form.base.modifytime')}",
			              value: 'modifyTime',
                            ifFormat:'%Y-%m-%d',
			              dateTime: false
			          }]
		  });
			//searchobj.g.setCondition('name','');
	  }
</script>