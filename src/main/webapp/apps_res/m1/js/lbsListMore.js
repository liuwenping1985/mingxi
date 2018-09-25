$(function(){
	initToolBar();
	initGridData("");
})

function initToolBar(){
	$("#lbsToolBar").toolbar({
        toolbar: [{
            id: "new",
            name: $.i18n("lbs.sign.mobile.label"),
            className: "ico16 mobile_checkin_16",
			click:function(){
					var dialogObj=$.dialog({
			          id : 'url',
			          url: _ctxPath+'/m1/lbsRecordController.do?method=lbsPortalSearch',
			          width : 400,
			          height : 270,
			          title : $.i18n("lbs.sign.search.label"),
			          targetWindow : getCtpTop(),
			          buttons : [{
							id : "ok",
							text : $.i18n('lbs.sign.ok.label'),
							handler : function() {
								var retValue = dialogObj.getReturnValue();
								var searchCondition=retValue[0].join(",");
								$("#searchCondition").val(searchCondition);
								var o=new Object();
								var list=searchCondition.split(",");
								for(var i=0;i<list.length;i++){
									var st=list[i].split("=");
									if(st[1]){
										o[st[0]]=st[1];
									}
								}
								$("#listStatistic").ajaxgridLoad(o);
								dialogObj.close();
							}
						}, {
							id : "cancelButton",
							text : $.i18n('lbs.sign.cancle.label'),
							handler : function() {
								dialogObj.close();
							}
						}]
			      });
			}
        },{
            id: "modify",
            name: $.i18n("lbs.sign.export.label"),
            className: "ico16 export_excel_16",
			click:function(){
				$("#execlToExport").jsonSubmit({});
			}
        }]
    });
}
var result=[];
var pageTotle;
function initGridData(searchCondition){
	var	grid = $('#listStatistic').ajaxgrid({
            colModel:[ {
    				display : '姓名',
			        name : 'userName',
			        width : '20%',
			        sortable : false,
			        align : 'center',
 				}, {
			        display : '所属部门',
			        name : 'dptName',
			        width : '20%',
			        sortable : false,
			        align : 'center'
	      		}, {
			        display : '定位时间',
			        name : 'createDate',
			        width : '20%',
			        sortable : false,
			        align : 'center'
	      		}, {
			        display : '定位地址',
			        name : 'lbsAddr',
			        width : '39%',
			        sortable : false,
			        align : 'center'
	      		} ],
            render:rend,
            showTableToggleBtn: true,
            parentId: 'center',
            resizable:false,
            vChange: true,
            vChangeParam: {
                overflow: "hidden",
				autoResize:true
            },
            isHaveIframe:true,
            slideToggleBtn:true,
            managerName : "mLbsRecordManager",
            managerMethod : "getLbsInfoList"
        });
        var o=new Object();
        $("#listStatistic").ajaxgridLoad(o);
}

 function rend(txt, data, r, c) {
        return "<span class='grid_black'>"+txt+"</span>";
 }
	
function buildTbody(result){
	var tbody="";
	var column=['userName','dptName','createDate','lbsAddr'];
	for(var i=0;i<result.length;i++){
		tbody+="<tr>";
		for(var j=0;j<column.length;j++){
			var disVal=result[i][column[j]];
			tbody+="<td align='center' nowrap='nowrap' style='min-width:58px;' title='"+disVal+"'>"+disVal+"</td>";
		}
		tbody+="</tr>"
	}
	$("#lbsContent").html(tbody);
}