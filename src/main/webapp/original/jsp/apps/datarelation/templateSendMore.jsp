<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:toHTML(param.subject)}</title>
<script type="text/javascript">
  $(function() {
  	
    var t = $("#sendTemplateData").ajaxgrid({
      click : clk,//单击事件
      dblclick : dblclk,//双击事件
      render : rend,
      "vresize" : false,
      "isHaveIframe" : true,
      "usepager" : true,// 是有翻页条
      "showTableToggleBtn" : false,
      "customize":false,
      "vChange" : false,
      "slideToggleBtn" : false,// 上下伸缩按钮是否显示
      "parentId" : $('.layout_center').eq(0).attr('id'),// grid占据div空间的id
      "resizable" : false,// 明细页面的分隔条
      colModel: [{
          display: 'id',
          name: 'affairId',
          width: '4%',
          type: 'radio',
          isToggleHideShow:false
      },{
        display : "${ctp:i18n('cannel.display.column.subject.label')}",
        name : 'subject',
        width : '60%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('datarelation.tab.sTime.js')}",
        name : 'createDate',
        width : '34%',
        sortable : true,
        align : 'center'
       
      } ],
      managerName : "colDataRelationHandler",
      managerMethod : "getDataBySendTemplate",
      onSuccess : function(){
          //给radio添加click事件
          setTimeout(function(){
              $("input[type='radio']").unbind("click", _inputClick);
              $("input[type='radio']").bind("click", _inputClick);
          }, 500);
      }
    });
    
    //补全grid的radio事件
    function _inputClick(){
        var target = this;
        var td = $(target).parents("td").eq(0);
        var tr = td.parent();
        if (tr.hasClass("graytr")) return; //如果该行置灰状态，单行事件不可用
        var col = $('td', tr).index(td);
        var row = $('tr', $("#sendTemplateData")).index(tr);
        if (row == -1) row = 0;
        clearTimeout(window.timer);
        window.timer = setTimeout(function() {
            clk(t.p.datas.rows[row], row, col);
        }, 200);
    }
    
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
          /*   if(data.state != null && data.state !="" && data.state != "0"){
                txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
            } */
            //如果设置了处理期限(节点期限),添加超期图标
            if(data.deadLineName != null && data.deadLineName !=$.i18n('collaboration.project.nothing.label')){
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
    
    var _formRecordid = null;
    function clk(data, r, c) {
    	if(formAppid != "-1" && data.affair && (data.affair.templeteId == templateId || data.affair.formAppId == formAppid)){
    		toolbar.enabled("copyData");
    		_formRecordid = data.affair.formRecordid;
		} else {
			_formRecordid = null;
			toolbar.disabled("copyData");
		}
	}

	function dblclk(data, r, c) {
		openWin(data.affairId);
	}

		var toolbarArray = new Array();
		//by wuxiaoju 表单模板后台设置不允许相关数据一键复制时，屏蔽复制到当前模板按钮
		if ("${param.openFrom}" == "newColl" && !("${param.bodyType}" == "20" && "${param.canCopy}" == "false")) {
			//复制到当前模板按钮
			toolbarArray.push({
				id : "copyData",
				name : "${ctp:i18n('datarelation.tab.copy.node.js')}",
				className : "ico16 forwarding_16",
				click : function() {
					if (_formRecordid) {
						opener.copyForm(_formRecordid);
						window.close();
					}
				}
			});
		}

		//工具栏
		var toolbar = $("#toolbars").toolbar({
			toolbar : toolbarArray
		});

		var topSearchSize = 7;
		if ($.browser.msie && $.browser.version == '6.0') {
			topSearchSize = 5;
		}

		var searchobj = $.searchCondition({
			top : topSearchSize,
			right : 10,
			searchHandler : function() {
				var val = searchobj.g.getReturnValue();
				if (val != null) {
					o.subject = null;
					o.startMemberName = null;
					o.createDate = null;
					o.receiveDate = null;
					var choose = $('#' + searchobj.p.id).find("option:selected").val();
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
					$("#sendTemplateData").ajaxgridLoad(o);
					_formRecordid = null;
					toolbar.disabled("copyData");
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
				id : 'datetime',
				name : 'datetime',
				type : 'datemulti',
				text : $.i18n("datarelation.tab.sTime.js"),//发起时间
				value : 'createDate',
				ifFormat : '%Y-%m-%d',
				dateTime : false
			} ]
		});

		
		searchobj.g.setCondition('title', '');
		
		var o = new Object();
	  	o.id = "${param.pid}";//配置文件id
	  	o.templateId = "${param.templateId}";//模板id
	  	o.openFrom = "more";
	  	o.affairId = "${param.affairId}";
	  	o.summaryId = "${param.summaryId}";
	  	
		var v = $("#sendTemplateData").ajaxgridLoad(o);
		var formAppid = "${param.formAppid}";
		var templateId = "${param.templateId}";
		if (formAppid == "0" || formAppid == "" || formAppid == "-1") {
			formAppid = "-1";
		}

		toolbar.disabled("copyData");
	});
  
  function openWin(affairId){
	  var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=glwd&affairId="+ affairId;
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
    <div class="layout_north" layout="height:40,sprit:false,border:false">
      <div id="toolbars"></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="sendTemplateData" class="flexme3" style="display: none;">
      </table>
    </div>
  </div>
</body>
</html>