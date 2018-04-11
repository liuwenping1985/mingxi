<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=neigouCorpinforManager"></script>
<script type="text/javascript">
$().ready(function() {
	var sys_isGroup = "${sys_isGroupVer}";
    var corpinforManager=new neigouCorpinforManager();
    $("#corpinforDetail").hide();
    $("#button").hide();
    function addform(){
        $("#corpinforDetail").clearform({clearHidden:true});
        $("#orgAccountId").comp({
            value: '',
            text: ''
          });
        $("#corpinforDetail").enable();
        $("#accountLogin").disable();
        if(sys_isGroup=='false'){
        	$("#accountDiv").disable();
        	$("#orgAccountId").comp({
                value: ${currentAccount.id},
                text: "${currentAccount.name}"
              });
        }
        var excludeAccountIds = corpinforManager.getExcludeAccountIds();
        $("#orgAccountId").comp({
        	excludeElements : excludeAccountIds.ids
        });
        $("#corpinforDetail").show();
        $(".isControl1").attr("checked","checked");
        $("#pointTable").hide();
        $("#button").show();
        mytable.grid.resizeGridUpDown('middle');
    }
    var toolbar =  $("#toolbar").toolbar({
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
        },{
            id: "excel2", 
            name: "${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable')}", 
            className: "ico16 editor_16", 
            subMenu: [
                        {id: "down3", name: "${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.on')}", className: "download_16", click: enable},
                        {id: "import3", name: "${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.off')}", className: "ico16 import_16", click: disable}
                    ]
         },{
             id: "excel3", 
             name: "${ctp:i18n('voucher.plugin.cfg.subject.excel.import')}", 
             className: "ico16 import_16", 
             subMenu: [
                         {id: "down3", name: "${ctp:i18n('form.formlist.downinfopath')}", className: "download_16", click: downTemplate},
                         {id: "import3", name: "${ctp:i18n('application.95.label')}", className: "ico16 import_16", click: importCorpinfor}
                     ]
          }]
    });

    
    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}",
            sortable: true,
            name: 'accountName',
            width: '28%'
        },
        {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.contactName')}",
            sortable: true,
            name: 'contactName',
            width: '12%'
        },
        {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.contactPhone')}",
            sortable: true,
            name: 'contactPhone',
            width: '18%'          
        },
        {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.contactEmail')}",
            sortable: true,
            name: 'contactEmail',
            width: '20%'          
        },
        /* {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.assignedpoint')}",
            sortable: true,
            name: 'companyPoint',
            width: '10%'          
        }, */
        {
            display: "${ctp:i18n('neigou.plugin.neigoucorpinfor.statues')}",
            sortable: true,
            name: 'statues',
            width: '10%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.StatusEnum',query:'true'"
        }],
        width: "auto",
        managerName: "neigouCorpinforManager",
        managerMethod: "showCorpinforList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    function gridclk(data, r, c) {
        $("#corpinforDetail").disable();
        $("#corpinforDetail").show();
        $("#pointTable").show();
        $("#button").hide();
        $("#corpinforDetail").clearform({clearHidden:true});
        var postdetil = corpinforManager.viewNeigouCorpinfor(data.id);
        $("#addForm").fillform(postdetil);
        $("#orgAccountId").comp({
            value: postdetil.orgAccountId,
            text: postdetil.accountName
          });
        mytable.grid.resizeGridUpDown('middle');
    }
  //搜索框
    var searchobj = $.searchCondition({
      top: 7,
      right: 10,
      searchHandler: function() {
        s = searchobj.g.getReturnValue();
        $("#mytable").ajaxgridLoad(s);       
      },
      conditions: [{
          id: 'search_type',
          name: 'search_type',
          type: 'selectPeople',
		  comp:"type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',showMe:false,returnValueNeedType:false",
          text: "${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}",
          value: 'orgAccountId',
          maxLength:100
      },{
          id: 'search_statues',
          name: 'search_type',
          type: 'select',
          text: "${ctp:i18n('neigou.plugin.neigoucorpinfor.statues')}",
          value: 'statues',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.StatusEnum'"
      }]
    }); 
    if("false"==sys_isGroup){
    	toolbar.hideBtn("excel3");
		searchobj.g.hideItem("search_type");
    }
    function griddbclick() {
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.exception.onlyone')}");
        }else{          
            mytable.grid.resizeGridUpDown('middle');
            $("#corpinforDetail").clearform({clearHidden:true});
            var corpinfordetil = corpinforManager.viewNeigouCorpinfor(v[0]["id"]);
            $("#addForm").fillform(corpinfordetil);
            $("#orgAccountId").comp({
                value: corpinfordetil.orgAccountId,
                text: corpinfordetil.accountName
              });
            $("#corpinforDetail").enable();
            $("#accountLogin").disable();
            $("#corpinforDetail").show();
            $("#pointTable").show();
            $("#pointTable").disable();
            $("#accountDiv").disable();
            $("#button").show();
            $("#corpinforDetail").resetValidate();
        } 
    }
    
    $("#btncancel").click(function() {
        location.reload();
    });
    
    $("#btnok").click(function() {
        if(!($("#corpinforDetail").validate())){ 
          return;
        }
        //var reg = new RegExp("[><'\"#$%&]","i");  // 创建正则表达式对象。
        var reg = new RegExp("[<>+<;'\/,.~`&#@%$]","i");  // 创建正则表达式对象。<>+<;'\/,.~` 
    	var  r = $("#contactName").val().match(reg);
    	if(r!=null){
    		$.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.contactname')}");
    		return ;
    	}
        var myreg = /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
        if (!myreg.test($("#contactEmail").val())) {
        	$.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.email')}");
    		return;
        }
        if(!/^1[34578][0-9]{9}$/.test($("#contactPhone").val())){ 
          $.alert("${ctp:i18n('neigou.plugin.neigoucorpinfor.format.phone')}"); 
          return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        corpinforManager.saveNeigouCorpinfor($("#addForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                location.reload();
            }
        });                                                                              
    });
        
});
function enable(){
	modifiedStatues(true);
}
function disable(){
	modifiedStatues(false);
}
function downTemplate(){
	$("#delIframe").prop("src","${path}/neigou/neigouCorpinforController.do?method=downTemplate&type=NeigouCorp");
}
function importCorpinfor(){
	insertAttachment();//批量导入
}
function importCallBk(file){
	var neigouCorpinfor=new neigouCorpinforManager();
	neigouCorpinfor.importExcel(file,{
		success : function(data){
			var dialog = getA8Top().$.dialog({
       		url:"${path}/neigou/neigouCorpinforController.do?method=showImportLogList&data="+data,
   			    width: 600,
   			    height: 300,
   			    title: "导入Excel",//导入Excel
   			    buttons: [{
   			        text: "${ctp:i18n('common.button.ok.label')}", //确定
   			        handler: function () {
		        	    dialog.close();
		        	    var o = new Object();
					    $("#mytable").ajaxgridLoad(o);
   			        }
   			    } ]
       		});
		}
	});
}
function modifiedStatues(bool){
	var corpinforManager=new neigouCorpinforManager();
	var v = $("#mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
	
    if (v.length < 1) {
        $.alert("${ctp:i18n('post.chosce.modify')}");
    }else{
    	var array = new Array();
    	for(var i=0; i<v.length; i++){
    		array[i] = v[i].id;
    	}
		corpinforManager.modifiedStatuesList(array,bool, {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                var o = new Object();
                $("#mytable").ajaxgridLoad(o);
                location.reload();
            }
        });
    }
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_neigou_corpinfor'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
            	<div class="stadic_layout_head stadic_head_height">
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="corpinforDetail" class="form_area" style="overflow-y:hidden">
                        <%@include file="corpinforDetail.jsp"%></div>
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
     <div class="comp" style="display: none;" comp="type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,quantity:1,extensions:'xls,xlsx',maxSize:1024*1024*10,callMethod:'importCallBk',takeOver:false">
 		</div>
 		<iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>