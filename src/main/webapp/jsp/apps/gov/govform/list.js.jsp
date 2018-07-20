<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script>

var grid;
$(document).ready(function () {
	
	/** UE样式 */
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
    
  	//工具栏
    var toolbarArray = new Array();
    toolbarArray.push({id:"create", name:'Create', className:"ico16 forwarding_16", click:createForm });//新增
    $("#toolbars").toolbar({
    	isPager:false,
        toolbar: toolbarArray
    });
    
    //表格加载
    grid = $('#listGrid').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: 'name',//subject
            name: 'name',
            sortable : true,
            width: '32%'
        }, {
            display: 'description',//fieldName
            name: 'description',
            sortable : true,
            width: '30%'
        }, {
            display: 'content',//elementId
            name: 'content',
            sortable : true,
            width: '30%'
        }],
        click: clickRow,
        dblclick: dbclickRow,
        render : rend,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: true,
        managerName : "govformManager",
        managerMethod : "list"
    });
    $("#listGrid").ajaxgridLoad();
    
    //页面底部说明加载
    //$('#summary').attr("src", _ctxPath+"/info/infoBase.do?method=listDesc&listType=listElement&size="+grid.p.total);

});

//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    //执行延时
    /*if(!isAffairValid(data.affairId)){
        $("#listGrid").ajaxgridLoad();
        $(".spiretBarHidden3").trigger("click");
        return;
    }*/
    /*TimeFn = setTimeout(function(){
        $('#summary').attr("src", _ctxPath+"/info/infoElement.do?method=edit&listType=listElement&id="+data.id);
    },300);*/
    $('#summary').attr("src", _ctxPath+"/info/infoForm.do?method=edit&listType=listElement&id="+data.id);
}
//双击事件
function dbclickRow(data, rowIndex, colIndex){
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    var url = _ctxPath+"/info/infoElement.do?method=edit&listType=listElement&id="+data.id;
    var title = data.subject;
    //doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
}

//回调函数
function rend(txt, data, r, c) {
	if(c === 1){
		txt = "<span class='grid_black'>"+txt+"</span>";
	}
	return txt;
}    

function createForm() {
	$('#summary').attr("src", _ctxPath+"/info/infoForm.do?method=createForm&id=");
}

</script>