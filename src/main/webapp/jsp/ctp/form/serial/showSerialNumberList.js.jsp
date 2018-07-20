<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
	var v3x = new V3X();
	var gridObj;
	$(document).ready(
	    function() {
	    	//初始化toolbar
		    $("#toolbar").toolbar({
		    	toolbar : [{name : "${ctp:i18n('form.formlist.newform')}",click : add,className : "ico16 add"},
			    	{name : "${ctp:i18n('form.oper.update.label')}",click : edit,className : "ico16 editor_16"},
			      	{name : "${ctp:i18n('form.datamatch.del.label')}",className : "ico16 del_16",click : del}]
	        });
			//查询事件绑定
		 	setSearch();
	    	//初始化表格
	        gridObj=$("table.flexme3").ajaxgrid({
	        searchHTML : 'condition_box',
	        colModel : [ {display : 'id',name : 'id',width : '5%',sortable : false,align : 'center',type : 'checkbox',isToggleHideShow:false},
	            {display : 'stateValue',name : 'stateValue',width : '5%',sortable : false,align : 'center',hide:true,isToggleHideShow:false},
	        	{display : "${ctp:i18n('form.serailNumber.name')}",name : 'variableName',width : '34%',sortable : true,align : 'left',isToggleHideShow:false}, 
	            {display : "${ctp:i18n('form.serailNumber.view')}",name : 'dispvalue',width : '10%',sortable : true,align : 'left'}, 
	            {display : "${ctp:i18n('form.trigger.triggerSet.state.label')}",name : 'state',width : '10%',sortable : true,align : 'center'}, 
	            {display : "${ctp:i18n('common.accout.name.lable')}",name : 'accountName',width : '30%',sortable : true,align : 'left'} , 
	            {display : "${ctp:i18n('form.serialnumberlist.useform')}",name : 'formName',width : '10%',sortable : true,align : 'left'}],
			managerName : "serialNumberManager",managerMethod : "designSerialShow",
	        click :clk,
	        dblclick :dbclk,
	        usepager : true,
	        render:rend,
	        useRp : true,
	        showTableToggleBtn : true,
	        resizable : true,
			parentId:"center",
			callBackTotle:getCount,
		    vChange :true,
		    vChangeParam: {
		      	overflow: "hidden",
		        autoResize:true
		     },
			 slideToggleBtn: true
	      });    
		    //加载表格
	      var o = new Object();
	      o.accountId="${CurrentUser.loginAccount}";
	      $("#mytable").ajaxgridLoad(o);
	      function rend(txt, data, r, c) {
          if (c==1){
             return "<div class = 'grid_black'>" + txt + "</div>";
          } else {
            return txt;
          }
        }
	});
	
	//------------------------------------toolbar相关事件-----------------------------//
	//toolbar新增
	function add(){
		 $("#viewFrame").prop("src","${path }/form/serialNumber.do?method=showSerialNumberView&type=create&id=");
		 gridObj.grid.resizeGridUpDown('middle');
	}
	//toolbar修改
	function edit() {
		var selRows = gridObj.grid.getSelectRows();
		if (selRows.length == 0) {
			$.alert("${ctp:i18n('form.serialnumberlist.chooseeidtserialnumber')}");
			return;
		}else if (selRows.length > 1) {
			$.alert("${ctp:i18n('form.serialnumberlist.onlychooseonetoedit')}");
			return;
		}else if(selRows.length == 1 && selRows[0].stateValue == 1){
			$.alert(selRows[0].variableName+"${ctp:i18n('form.serialnumberlist.isusedcantedit')}");
			return;
		}
		$("#viewFrame").prop("src","${path }/form/serialNumber.do?method=showSerialNumberView&type=edit&id="+selRows[0].id);
		gridObj.grid.resizeGridUpDown('middle');
	}
	//toolbar删除
	function del() {
		var ids = new Array();
		var selRows = gridObj.grid.getSelectRows();
		if (selRows.length == 0) {
			$.alert("${ctp:i18n('form.serialnumberlist.choosedelserialnumber')}");
			return;
		}
		//组装id
		for ( var i = 0; i < selRows.length; i++) {
			if (selRows[i].stateValue === 1) {
			$.alert(selRows[i].variableName+ "${ctp:i18n('form.serialnumberlist.isusedcantdel')}");
				return;
			}
			ids[i] = selRows[i].id;
		}
		//弹出确认删除框
		var confirmDialog = $.confirm({
			'msg' : "${ctp:i18n('form.serialnumberlist.suertodel')}",
			ok_fn : function() {
				$("#delIframe").prop("src","${path}/form/serialNumber.do?method=deleteSerialNumber&id="+ ids.join());
				$("#delIframe").load(function() {
					window.location.reload();
				});
			},
			cancel_fn : function() {confirmDialog.close();}
		});
	}
	
	//------------------------------------表格相关事件----------------------------------------//
	//表格单击
	function clk(data, r, c) {
		$("#viewFrame").prop("src","${path }/form/serialNumber.do?method=showSerialNumberView&type=view&id="+ data.id);
		gridObj.grid.resizeGridUpDown('middle');
	}
	//表格双击
	function dbclk(data, r, c) {
		if (data.stateValue !== 1) {
			$("#viewFrame").prop("src","${path }/form/serialNumber.do?method=showSerialNumberView&type=edit&id="+ data.id);
		}else{
			$.alert("${ctp:i18n('form.serialnumberlist.isusedcantedit')}");
		}
	}
	//获取表格总数
	function getCount(n) {
		$("#viewFrame").prop("src","${path }/form/serialNumber.do?method=desc&total="+n);
	}
	
	//查询组件事件
	function setSearch() {
		var searchobj = $.searchCondition({
			top : 2,
			right : 10,
			searchHandler : function() {
				var ssss = searchobj.g.getReturnValue();
				var o = new Object();
				o.accountId = "${CurrentUser.loginAccount}";
				o[ssss.condition] = ssss.value;
				$("#mytable").ajaxgridLoad(o);
			},
			conditions : [ {id : 'variable_name',name : 'variable_name',type : 'input',text : "${ctp:i18n('form.trigger.triggerSet.name.label')}",value : 'variable_name'}, 
				{id : 'state',name : 'state',type : 'select',text : "${ctp:i18n('form.trigger.triggerSet.state.label')}",value : 'state',
					items : [ {text : "${ctp:i18n('form.UseSerialNumber.label')}",value : '1'}, 
					          {text : "${ctp:i18n('form.NoUseSerialNumber.label')}",value : '2'} ]} ]
		});
		searchobj.g.setCondition('name', '');
	}
</script>