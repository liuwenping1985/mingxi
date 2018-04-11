<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>${ctp:i18n('cip.org.sync.log.title')}</title>
<script type="text/javascript"  src="${path}/ajax.do?managerName=cipSynRecordManager"></script>

<script type="text/javascript">
$().ready(function() {
    var recordManager  =  new cipSynRecordManager();

	//搜索框
	var searchobj = $.searchCondition({
		top : 10,
		right : 10,
		searchHandler : function() {
			var s = searchobj.g.getReturnValue();
			$("#mytable").ajaxgridLoad(s);
		},
		conditions : [
				{//组织
					id : 'type',
					name : 'type',
					text : "${ctp:i18n('cip.scheme.param.init.orgname')}",
					value : 'type',
					type: 'selectPeople',
					comp:"type:'selectPeople',mode:'open',panels:'Account,Department',selectType:'Account,Department',maxSize:'1',returnValueNeedType:false"
				},
				{//第三方名称
					id : 'thirdorgname',
					name : 'thirdorgname',
					type : 'input',
					text : "${ctp:i18n('cip.org.sync.record.resource')}",
					value : 'thirdorgname'
				},
				{//同步方式
				  id: 'optype',
				  name: 'optype',
				  text: "${ctp:i18n('cip.scheme.param.config.synctype')}",
				  value: 'optype',
				  type: 'select',
				  codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SyncTypeEnum',query:'auto'"
				},
				{//同步实体
				  id: 'syntype',
				  name: 'syntype',
				  text: "${ctp:i18n('cip.org.sync.record.syn')}",
				  value: 'syntype',
				  type: 'select',
				  codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynType',query:'department'"
				},
				{//发起时间查询
					id : 'dt',
					name : 'dt',
					type : 'datemulti',
					text : "${ctp:i18n('cip.org.sync.config.synctime')}",
					value : 'dt',
					ifFormat : '%Y-%m-%d',
					dateTime : false
				} ]
			});

	var o = new Object();//列表显示条件专用
	var toolbar =  $("#toolbar").toolbar({
        toolbar: [
		  { id: "all",
            name: "${ctp:i18n('cip.org.sync.record.all')}",
            className: "ico16 all_16",
            click: function() {
				o.condition ="all";
				$("#mytable").ajaxgridLoad(o);
            }
         },
	     { id: "unit",
            name: "${ctp:i18n('cip.org.sync.record.unit')}",
            className: "ico16 radio_account_16",
            click: function() {
               o.condition ="syntype";
			   o.value="0";
			   $("#mytable").ajaxgridLoad(o);
            }
         },
		 { id: "department",
            name: "${ctp:i18n('cip.org.sync.record.dep')}",
            className: "ico16 department_16",
            click: function() {
               o.condition ="syntype";
			   o.value="1";
			   $("#mytable").ajaxgridLoad(o);
            }
         },
		 { id: "post",
			name: "${ctp:i18n('cip.org.sync.record.post')}",
			className: "ico16 job_16",
			click: function() {
			   o.condition ="syntype";
			   o.value="2";
			   $("#mytable").ajaxgridLoad(o);
			}
		  },
		  { id: "lev",
	            name: "${ctp:i18n('cip.org.sync.record.lev')}",
	            className: "ico16 radio_level_16",
	            click: function() {
	               o.condition ="syntype";
				   o.value="3";
				   $("#mytable").ajaxgridLoad(o);
	            }
	         },
		  { id: "people",
            name: "${ctp:i18n('cip.org.sync.record.pers')}",
            className: "ico16 staff_16",
            click: function() {
               o.condition ="syntype";
			   o.value="4";
			   $("#mytable").ajaxgridLoad(o);
            }
         },
		{ id: "del",
			name: "${ctp:i18n('cip.base.interface.register.del')}",
			className: "ico16 del_16",
			click: function() {
				var v = $("#mytable").formobj({
				  gridFilter: function(data, row) {
					return $("input:checkbox", row)[0].checked;
				  }
				});
				
				if (v.length < 1) {
				  $.alert("${ctp:i18n('cip.portal.delete')}");
				} else {
				  $.confirm({
					'msg': "${ctp:i18n('cip.org.sync.record.delete.ok')}",
					ok_fn: function() {
					recordManager.deleteRecords(v, {
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

	//加载表单 
	var mytable = $("#mytable").ajaxgrid(
		{	vChange: true,
	        vChangeParam: {
	            overflow: "hidden",
	            autoResize:true
	        },
	        isHaveIframe:false,
	        slideToggleBtn:false,
			render: rend,
			colModel : [
					{	display : 'id',
						name : 'id',
						width : '5%',
						sortable : true,
						align : 'center',
						value : 'id',
						type : 'checkbox'
					},
					{	display : "${ctp:i18n('cip.scheme.param.init.orgname')}",
						name : 'type',
						width : '15%',
						sortable : true
					},
					{	display : "${ctp:i18n('cip.org.sync.record.resource')}",
						sortable : true,
						name : 'thirdorgname',
						width : '20%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.syn')}",
						sortable : true,
						name : 'syntype',
						codecfg:"codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynType'",
						width : '10%'
					},
					{	display : "${ctp:i18n('cip.scheme.param.config.synctype')}",
						sortable : true,
						name : 'optype',
						codecfg:"codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SyncTypeEnum'",
						width : '10%'
					},
					{	display : "${ctp:i18n('cip.org.sync.config.synctime')}",
						sortable : true,
						name : 'dt',
						value:'dt',
						width : '10%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.OKS')}",
						sortable : true,
						name : 'oknum',
						width : '5%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.fails')}",
						sortable : true,
						name : 'failnum',
						width : '5%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.memo')}",
						sortable : true,
						name : 'action',
						width : '15%'
					} ],
			width: "auto",
			managerName : "cipSynRecordManager",
			managerMethod : "showRecordInfo",
			parentId : 'center'
		});
		$("#mytable").ajaxgridLoad(o);

		function rend(txt, data, r, c) {
			if (c == 8) {
			  return '<a >' + txt + '</a>';
			} else return txt;
		  }
	
		 $("td[abbr='action']").live('click',function(){
		  var v = $("#mytable").formobj({
				gridFilter : function(data, row) {
				  return $("input:checkbox", row)[0].checked;
				}
			  });
			showLogDetail(v[0]["id"]);
		 });
		//显示日志详细
		function showLogDetail(logid){
			dialog = $.dialog({
		        id: 'url',
		        url: '${path}/cip/org/synOrgController.do?method=recordDetail&recordid='+logid,
		        width: 1000,
		        height: 400,
		        title: "${ctp:i18n('cip.org.sync.record.title')}",
		        transParams:{name:"myName"},
		        checkMax:true,
		    closeParam:{
		        'show':true,
		        autoClose:false,
		        handler:function(){
		        	dialog.close();
		        }
		    }
		   });
		}
		var  sys_isGroupVer = ${sys_isGroupVer}
		if(sys_isGroupVer==false){//企业版
			$("#unit_a").hide();
		}

	});
        
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',code:'F21_neigou_pointquery'"></div>
		<div class="layout_north" layout="height:48,sprit:false,border:false">      
			<div id="toolbar"></div>
		</div>
		 <div  class="layout_center over_hidden" id="center">
	      <table id="mytable" class="flexme3" >
	      </table>
		</div>
	</div>
</body>
</html>

