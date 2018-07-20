<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/designAuth.js${ctp:resSuffix()}"></script>
<script>
	var viewType='view';
	var RTEEditorDivHeight = 100;
	var authId='-1L';
	var _browse = '${browse}';
	var _externalwrite = '${externalwrite}';
	var _outwrite = '${outwrite}';
	var _linenumber = '${linenumber}';
	var _relationForm = '${relationForm}';
	var _isNotNull = '${isNotNull}';
	var _hide = '${hide}';
	//是否高级office插件
	var _isAdvanced = ${isAdvanced};
	var _formViewId = '${formViewId}';
	var _edit = '${edit}';
	var _add = '${add}';
	var _formType = '${formBean.formType}';
	var _formId = '${formBean.id}';
    $(document).ready(function(){
    	new MxtLayout({
            'id': 'layout',
            'northArea': {
            	'id': 'north',
            	'height':40,
            	'sprit': false,
				'border': false
            },
            'southArea': {
                'id': 'south',
                'height': 40,
                'sprit': true,
				'border': false,
				'maxHeight': 40,
                'minHeight': 40
            },
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
    	if(!${formBean.newForm }){
       	 	new ShowBottom({'show':['doSaveAll','doReturn']});
       	 	new ShowTop({'current':'auth','canClick':'true','module':'auth'});
        }else{
        	new ShowTop({'current':'auth','canClick':'false','module':'auth'});
       		new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/fieldDesign.do?method=baseInfo','nextStep':'../form/queryDesign.do?method=queryIndex'}});
        }
        
        if(${formBean.newForm } == false){
         	$("li[cando='1']").click(function(){
             	$("#saveAll").jsonSubmit({action:$("#saveAll").prop("action")+"&step="+$(this).prop("id")});
         	});
        }
        
        RTEEditorDivHeight = document.documentElement.clientHeight - 344;
        if($('#radioHeight').height()<=RTEEditorDivHeight){
        }
      	//判断允许点击高级设置
        checkHasFormAdvanced();
        
        $("td[id!='selectBox']","#authBody").click(function(){
        	authBodyFun($(this));
        });

        $(".phone").click(function(){
            designAuthPhoneView($(this));
        });

        $("#designPhoneView").click(function(){
            designPhoneView();
        });
        
        $(":checkbox",".only_table").click(function(){
        	onlyTableFun($(this));
        });
        
        $("#viewId").change(function(){
        	viewIdChangeFun($(this),_formViewId);
        });
        
        $("#authType").change(function(){
        	authTypeFun($(this));
        });
        
        $("#delAuth").click(function(){
        	delAuthFun();
        });
        
        $("#newAuth").click(function(){
        	newAuthFun();
        });
        $("#updateAuth").click(function(){
        	updateAuthFun();
        });
        
        $("#saveAuth").click(function(){
        	saveAuthFun();
        });
        
        //重发表操作
        $("#groupAuth").click(function(){
			groupAuthFun($(this));
		});
        
        //开发高级
        $("#developmentadv").click(function(){
         	developmentadvFun($(this),authId);
         });
        
        $("A","#selectAllAccess").click(function(){
        	selectAllAccessFun($(this));
		});
        
        $("input[attrType='def']","#authFieldTable").click(function(){
        	authFieldTableFun($(this));
        });
        
        $("input:radio","#authFieldTable").click(function(){
        	setNullAbledDisable($(this));
        });
        
      	//高级权限设置
        $("#highAuthDesign").bind("click",function(event){
            //阻止事件往上冒泡
            event.stopPropagation();
     	    highAuthDesignFun(viewType,authId);
        });
        $("A[attrType='conditionFieldSet']","#authFieldTable").click(
                function(){
                    fieldConditonAlertSet(this,viewType);
                }
        );
        $("#conditionCkb").click(
                function () {
                    authControllerFun(this);
                }
        );
        $("#radio5").click(
                function (){
                    uniqueAuthSet();
                }
        );
        $("#radio6").click(
                function (){
                    oneOneFieldSet();
                }
        );
    });    

</script>