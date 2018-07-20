<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
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
       	 	new ShowTop({'current':'right','canClick':'true','module':'auth'});
        }else{
        	new ShowTop({'current':'right','canClick':'false','module':'auth'});
       		new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/fieldDesign.do?method=baseInfo','nextStep':'../form/queryDesign.do?method=queryIndex'}});
        }
    });    

</script>