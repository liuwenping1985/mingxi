<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${param.subject}</title>
<script  type="text/javascript">
  $(function() {
  	
    var t = $("#dealTemplateData").ajaxgrid({
      dblclick : dblclk,//双击事件
      render : rend,
      "vresize" : false,
      "usepager" : true,// 是有翻页条
      "showTableToggleBtn" : false,
      "vChange" : false,
      "slideToggleBtn" : false,// 上下伸缩按钮是否显示
      "resizable" : false,// 明细页面的分隔条
      "customize":false,
      "parentId" : $('.layout_center').eq(0).attr('id'),// grid占据div空间的id
      colModel: [{
          display: 'id',
          name: 'affairId',
          width: '4%',
          type: 'checkbox',
          hide:true,//默认显示与否,
          isToggleHideShow:false
      },{
        display : "${ctp:i18n('cannel.display.column.subject.label')}",
        name : 'subject',
        width : '30%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('datarelation.tab.sTime.js')}",
        name : 'startDate',
        width : '20%',
        sortable : true,
        align : 'center'
       
      } , {
          display : "${ctp:i18n('datarelation.tab.sender.js')}",
          name : 'startMemberName',
          width : '20%',
          sortable : true,
          align : 'left'
         
      }, {
            display : "${ctp:i18n('datarelation.tab.reTime.js')}",
            name : 'receiveTime',
            width : '16%',
            sortable : true,
            align : 'center'
           
       } ],
      managerName : "colDataRelationHandler",
      managerMethod : "getDataByDealTemplate"
    });
    
    function rend(txt,data, r, c) {
    	if(c == 1){
        	//标题列加深
    	    txt="<span class='grid_black'>"+txt+"</span>";
            //如果是代理 ，颜色变成蓝色
            if(data.proxy){
                txt = "<span class='color_blue'>"+txt+"</span>";
            }
            //加图标
            //重要程度
            if(data.importantLevel !=""&& data.importantLevel != 1){
                txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt;
            }
            //附件
            if(data.hasAttsFlag == true){
                txt = txt + "<span class='ico16 affix_16'></span>" ;
            }
            //协同类型
            if(data.bodyType!=""&&data.bodyType!=null&&data.bodyType!="10"&&data.bodyType!="30"){
                txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
            }
            //流程状态
           /*  if(data.state != null && data.state !="" && data.state != "0"){
                txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
            } */
            //如果设置了处理期限(节点期限),添加超期图标
            if(data.deadLineName != null && data.deadLineName != $.i18n('collaboration.project.nothing.label')){
                if(data.isCoverTime){
                    //超期图标
                    txt = txt + "<span class='ico16 extended_red_16'></span>" ;
                }else{
                    //未超期图标
                    txt = txt + "<span class='ico16 extended_blue_16'></span>" ;
                }
            }
            txt = "<span onclick='openWin(\""+data.affairId+"\");'>" + txt+"</span>";
        }
        return txt;
    }

	function dblclk(data, r, c) {
		openWin(data.affairId);
	}

		var topSearchSize = 2;
		if ($.browser.msie && $.browser.version == '6.0') {
			topSearchSize = 5;
		}
		var searchobj = $.searchCondition({
			top : topSearchSize,
			right : 10,
			searchHandler : function() {
				var val = searchobj.g.getReturnValue();
				if (val != null) {
					var choose = $('#' + searchobj.p.id).find("option:selected")
							.val();
					o.subject = null;
					o.startMemberName = null;
					o.createDate = null;
					o.receiveDate = null;
					if (choose == 'subject') {
						o.subject = $('#title').val();
					} else if (choose == 'startMemberName') {
						o.startMemberName = $('#spender').val();
					} else if (choose == 'createDate') {
						var fromDate = $('#from_datetime').val();
						var toDate = $('#to_datetime').val();
						var date = fromDate + '#' + toDate;
						o.createDate = date;
					} else if (choose == 'receiveDate') {
						var fromDate = $('#from_receivetime').val();
						var toDate = $('#to_receivetime').val();
						var date = fromDate + '#' + toDate;
						o.receiveDate = date;
					}
					$("#dealTemplateData").ajaxgridLoad(o);
				}
			},
			conditions : [ {
				id : 'title',
				name : 'title',
				type : 'input',
				text : $.i18n("cannel.display.column.subject.label"),//标题
				value : 'subject',
				maxLength : 100
			}, {
				id : 'spender',
				name : 'spender',
				type : 'input',
				text : $.i18n("cannel.display.column.sendUser.label"),//发起人
				value : 'startMemberName'
			}, {
				id : 'datetime',
				name : 'datetime',
				type : 'datemulti',
				text : $.i18n("datarelation.tab.sTime.js"),//发起时间
				value : 'createDate',
				ifFormat : '%Y-%m-%d',
				dateTime : false
			}, {
				id : 'receivetime',
				name : 'receivetime',
				type : 'datemulti',
				text : $.i18n("cannel.display.column.receiveTime.label"),//接受时间
				value : 'receiveDate',
				ifFormat : '%Y-%m-%d',
				dateTime : false
			} ]
		});
		
		var o = new Object();
	  	o.id = "${param.pid}";//配置文件id
	  	o.affairId = "${param.affairId}";
	  	o.templateId = "${param.templateId}";//模板id
	  	o.openFrom = "more";
		
		
	   o.memberId = "${param.memberId}";//模板id
	   o.objectId = "${param.summaryId}";//模板id
	   o.senderId = "${param.senderId}";//模板id
	   o.nodePolicy = "${param.nodePolicy}";//模板id
	
		
		
	  	searchobj.g.setCondition('title', '');
		$("#dealTemplateData").ajaxgridLoad(o);
	});
  
  	function openWin(affairId) {
		var url = _ctxPath+"/collaboration/collaboration.do?method=summary&openFrom=glwd&affairId="+affairId;
		var id = getMultyWindowId("id", url);
		var win = openCtpWindow({
			"url" : url,
			"id" : id
		});
		if(win.focus){
		  if(self.blur){
			  self.blur();
		  }
		  win.focus();
		}
	}
</script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="toolbars"></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="dealTemplateData" class="flexme3" style="display: none;">
      </table>
    </div>
  </div>
</body>
</html>