var SeeyonApi = {
{foreach from=$tree item="methods" key="bean"}
    {if $bean != "application.wadl"}
    {$bean|capitalize} : {
        {foreach from=$methods item="v" key="name" name="methodLoop"}   {if $name != "apply"}  {$name} : {$v}{if !$smarty.foreach.methodLoop.last},{/if} 
        {/if}
        {/foreach}
    },{/if}{/foreach}
}

SeeyonApi.Rest ={
    token : '',
    jsessionid : '',
    post : function(url,params,body,options){
        return SeeyonApi.Rest.service(url,params,body,cmp.extend({ldelim}method:'POST'{rdelim},options));
    },
    get : function(url,params,body,options){
        return SeeyonApi.Rest.service(url,params,body,cmp.extend({ldelim}method:'GET'{rdelim},options));
    }, 
    put : function(url,params,body,options){
        return SeeyonApi.Rest.service(url,params,body,cmp.extend({ldelim}method:'PUT'{rdelim},options));
    },       
    del : function(url,params,body,options){
        return SeeyonApi.Rest.service(url,params,body,cmp.extend({ldelim}method:'DELETE'{rdelim},options));
    },     
    service : function(url,params,body,options){
        var result;
        var u = (typeof params === 'undefined')||params == '' ? url : url + '?' +{if $from == "mplus" ||  $from == "wechat"}cmp{else}${/if}.param(params);
        u = u.indexOf('?')>-1 ? u + '&' :  u+ '?';
        u = u + 'option.n_a_s=1';
        var lang = navigator.language;        
        if(typeof(lang) == 'undefind')lang = 'zh-CN';
        var settings = cmp.extend({ldelim}'Accept' : 'application/json; charset=utf-8','AcceptLanguage' : lang{rdelim},options);
        var dataType = 'json';
        if(settings.Accept.indexOf('application/xml')>-1){
        	dataType = 'xml';
        }
        var tk = {if $from == "mplus" ||  $from == "wechat"}cmp.token{else}window.localStorage.CMP_V5_TOKEN{/if};        
        tk = tk!=undefined ? tk : ''  ;        
        var header = {
                'Accept' : settings.Accept,
                'Accept-Language' : settings.AcceptLanguage,
                'Content-Type': 'application/json; charset=utf-8',
                'token' : tk{if $from != "mplus"}, 
                'Cookie' : 'JSESSIONID='+this.jsessionid {/if},
                'option.n_a_s' : '1'
        }
        {if ($from != "mplus")}
        if(this.jsessionid){
            header.Cookie = 'JSESSIONID='+this.jsessionid;
        }
        {/if}
        
        var dataBody;
        if(settings.method == 'GET'){
            if(body == ''){
                dataBody = '';
            }else{
                dataBody = JSON.stringify(body);
            }
            
        }else{
            dataBody = JSON.stringify(body);
        }
        {if $from == "mplus" ||  $from == "wechat"}cmp{else}${/if}.ajax({
            type: settings.method , 
            data: dataBody,
            url : {if $from == "mplus" || $from == "wechat"}cmp.seeyonbasepath + '/rest/'{else}'/seeyon/rest/'{/if} + u ,
            async : {$from == "mplus" ||  $from == "wechat"},
            headers: header,
            dataType : dataType,
            {if $from == "mplus" ||  $from == "wechat"}repeat: typeof(settings.repeat) !== 'undefined' ? settings.repeat : 'GET'===settings.method,{/if}
            success : function (r,textStatus,jqXHR){
            	if(dataType === 'xml'){
            		result = jqXHR.responseText;
            	}else{
                	result = r;
                }
                if(typeof(settings.success) !== 'undefined'){
                    settings.success(result,textStatus,jqXHR);
                }
            },
            error : settings.error
        });    
        return result;
    },
    authentication : function(userName,password){
        this.token = SeeyonApi.Token.getTokenByQueryParam('',{ldelim}userName:userName,password:password{rdelim}).id;
        return this.token;
    },
    setSession : function(sessionId){
        this.jsessionid = sessionId;
    }    
}
var $s = SeeyonApi;
 {if $from == "mplus" || $from == "wechat"}var jssdktagloaded = 'jssdktagloaded'; {/if}