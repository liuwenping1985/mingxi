<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
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
<script type="text/javascript" src="${path}/ajax.do?managerName=appVersionManager"></script>
<script type="text/javascript">
$().ready(function() {
	
    var appManager = new appVersionManager();
    $("#appForm").hide();
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "上传新版本",
            className: "ico16",
            click: function() {
                openPackPage();
            }
        },
        {
            id: "delete",
            name: "删除",
            className: "ico16 del_16",
            click: function() {
                var v = $("#mytable").formobj({
                    gridFilter : function(data, row) {
                      return $("input:checkbox", row)[0].checked;
                    }
                  });
                if (v.length < 1) {
                    $.alert("请选择要删除的版本!");
                } else {
                    $.confirm({
                        'msg': "确定要删除此版本?",
                        ok_fn: function() {
                           //删除
						   appManager.deleteVersion(v, {
                                success: function() {
                                    $("#mytable").ajaxgridLoad(o);
                                }
                            });
                        }
                    });
                };
            }
        },{
            id: "download",
            name: "下载",
            className: "ico16",
            click: function() {
                 var v = $("#mytable").formobj({
                    gridFilter : function(data, row) {
                      return $("input:checkbox", row)[0].checked;
                    }
                  });
                if (v.length < 1) {
                    $.alert("请选择要下载的版本!");
					return;
                } 
				if(v.length > 1){
					$.alert("每次只能下载一个版本!");
					return;
				}
				var url="${path}/cip/appManagerController.do?method=downloadApp&pk="+v[0].id;
				$("#downloadIframe").attr("src",url);
            }
        }]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,
        isHaveIframe:true,
        dblclick:griddbclick,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '50',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "版本号",
            sortable: true,
            name: 'version',
            width: '100'
        },
        {
            display: "版本说明",
            sortable: true,
            name: 'releaseNote',
            width: '150'
        },
        {
            display: "上传时间",
            sortable: true,
            name: 'createDate',
            width: '100'
        },
       {
            display: "CMP壳版本",
            sortable: true,
            name: 'cmpShellVersion',
            width: '100'
        },{
            display: "操作系统",
            sortable: true,
            name: 'supportedPlatforms',
            width: '100'
        }],
        managerName: "appVersionManager",
        managerMethod: "findByPage",
        parentId:'center',
		width : 800,
        vChangeParam: {
            autoResize:true
        }
		});
    //加载列表
    var o = new Object();
	o.registerId="${registerId}";
	o.appId="${appId}";
    $("#mytable").ajaxgridLoad(o);

    function gridclk(data, r, c) {
       
    }
    function griddbclick() {
        
    }

});
function openPackPage(){
	
var	dialog = $.dialog({
        id: 'packupload',
        url: '${path}/cip/appManagerController.do?method=uploadPackIndex&appId='+encodeURIComponent("${appId}")+'&registerId='+encodeURIComponent("${registerId}"),
        width: 600,
        height: 200,
        title: '新版本上传',
			buttons: [{
				text: "${ctp:i18n('common.button.ok.label')}",
				isEmphasize: true,
				handler: function() {
					  var rv = dialog.getReturnValue();
					  if(rv){
						  if(rv.length==2){
							     if(rv[0]=="0"){
                			 $.alert(rv[1]);
                		 }else{  
							dialog.close();
							location.reload();
						 }
						  }
					  }
				}
			},
			{
				text: "${ctp:i18n('common.button.cancel.label')}",
				handler: function() {
					dialog.close();
				}
			}]
    });
}
function uploadNewVersion(){
	if(!($("#appForm").validate())){		
          return;
    }
	if($("#appFile").val()==""){
		$.alert("请先上传应用包!");
		return;
	}
	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        try{
             new appVersionManager().saveVersion($("#addForm").formobj(), {
                 success: function(rel) {
                	 if(rel!=null){
                		 if(rel[0]=="0"){
                			 try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                			 $.alert(rel[1]);
                			 return;
                		 }
                	 }
                	try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
       				location.reload(); 
                 },
                 error:function(msg){
                	 try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
               }
             });
         }catch(e){
        	 alert(e);
         };
}
function uploadCallBack(att){
	$("#appFile").val(att.instance[0].fileUrl);
}
function deleteCallBack(att){
	$("#appFile").val("");
}
function isCallBack(){
	
	if($("#appFile").val()!=""){
		$.alert("一次仅能上传一个应用包");
		return;
	}
	insertAttachmentPoi('att');
}

</script>
</head>
<body>
应用编号:${appId }
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'cip_register'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>


<div  class="layout_center over_hidden" id="center">
        <table id="mytable" class="flexme3" ></table>
     
</div>
<iframe class="hidden" id="downloadIframe" src=""></iframe>
</body>
</html>