/*
 * jQuery JavaScript Library v1.8.3
 * http://jquery.com/
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: Tue Nov 13 2012 08:20:33 GMT-0500 (Eastern Standard Time)
 */
(function(window,undefined){var rootjQuery,readyList,document=window.document,location=window.location,navigator=window.navigator,_jQuery=window.jQuery,_$=window.$,core_push=Array.prototype.push,core_slice=Array.prototype.slice,core_indexOf=Array.prototype.indexOf,core_toString=Object.prototype.toString,core_hasOwn=Object.prototype.hasOwnProperty,core_trim=String.prototype.trim,jQuery=function(selector,context){return new jQuery.fn.init(selector,context,rootjQuery)},core_pnum=/[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)/.source,core_rnotwhite=/\S/,core_rspace=/\s+/,rtrim=/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,rquickExpr=/^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/,rsingleTag=/^<(\w+)\s*\/?>(?:<\/\1>|)$/,rvalidchars=/^[\],:{}\s]*$/,rvalidbraces=/(?:^|:|,)(?:\s*\[)+/g,rvalidescape=/\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,rvalidtokens=/"[^"\\\r\n]*"|true|false|null|-?(?:\d\d*\.|)\d+(?:[eE][\-+]?\d+|)/g,rmsPrefix=/^-ms-/,rdashAlpha=/-([\da-z])/gi,fcamelCase=function(all,letter){return(letter+"").toUpperCase()},DOMContentLoaded=function(){if(document.addEventListener){document.removeEventListener("DOMContentLoaded",DOMContentLoaded,false);jQuery.ready()}else{if(document.readyState==="complete"){document.detachEvent("onreadystatechange",DOMContentLoaded);jQuery.ready()}}},class2type={};jQuery.fn=jQuery.prototype={constructor:jQuery,init:function(selector,context,rootjQuery){var match,elem,ret,doc;if(!selector){return this}if(selector.nodeType){this.context=this[0]=selector;this.length=1;return this}if(typeof selector==="string"){if(selector.charAt(0)==="<"&&selector.charAt(selector.length-1)===">"&&selector.length>=3){match=[null,selector,null]}else{match=rquickExpr.exec(selector)}if(match&&(match[1]||!context)){if(match[1]){context=context instanceof jQuery?context[0]:context;doc=(context&&context.nodeType?context.ownerDocument||context:document);selector=jQuery.parseHTML(match[1],doc,true);if(rsingleTag.test(match[1])&&jQuery.isPlainObject(context)){this.attr.call(selector,context,true)}return jQuery.merge(this,selector)}else{elem=document.getElementById(match[2]);if(elem&&elem.parentNode){if(elem.id!==match[2]){return rootjQuery.find(selector)}this.length=1;this[0]=elem}this.context=document;this.selector=selector;return this}}else{if(!context||context.jquery){return(context||rootjQuery).find(selector)}else{return this.constructor(context).find(selector)}}}else{if(jQuery.isFunction(selector)){return rootjQuery.ready(selector)}}if(selector.selector!==undefined){this.selector=selector.selector;this.context=selector.context}return jQuery.makeArray(selector,this)},selector:"",jquery:"1.8.3",length:0,size:function(){return this.length},toArray:function(){return core_slice.call(this)},get:function(num){return num==null?this.toArray():(num<0?this[this.length+num]:this[num])},pushStack:function(elems,name,selector){var ret=jQuery.merge(this.constructor(),elems);ret.prevObject=this;ret.context=this.context;if(name==="find"){ret.selector=this.selector+(this.selector?" ":"")+selector}else{if(name){ret.selector=this.selector+"."+name+"("+selector+")"}}return ret},each:function(callback,args){return jQuery.each(this,callback,args)},ready:function(fn){jQuery.ready.promise().done(fn);return this},eq:function(i){i=+i;return i===-1?this.slice(i):this.slice(i,i+1)},first:function(){return this.eq(0)},last:function(){return this.eq(-1)},slice:function(){return this.pushStack(core_slice.apply(this,arguments),"slice",core_slice.call(arguments).join(","))},map:function(callback){return this.pushStack(jQuery.map(this,function(elem,i){return callback.call(elem,i,elem)}))},end:function(){return this.prevObject||this.constructor(null)},push:core_push,sort:[].sort,splice:[].splice};jQuery.fn.init.prototype=jQuery.fn;jQuery.extend=jQuery.fn.extend=function(){var options,name,src,copy,copyIsArray,clone,target=arguments[0]||{},i=1,length=arguments.length,deep=false;if(typeof target==="boolean"){deep=target;target=arguments[1]||{};i=2}if(typeof target!=="object"&&!jQuery.isFunction(target)){target={}}if(length===i){target=this;--i}for(;i<length;i++){if((options=arguments[i])!=null){for(name in options){src=target[name];copy=options[name];if(target===copy){continue}if(deep&&copy&&(jQuery.isPlainObject(copy)||(copyIsArray=jQuery.isArray(copy)))){if(copyIsArray){copyIsArray=false;clone=src&&jQuery.isArray(src)?src:[]}else{clone=src&&jQuery.isPlainObject(src)?src:{}}target[name]=jQuery.extend(deep,clone,copy)}else{if(copy!==undefined){target[name]=copy}}}}}return target};jQuery.extend({noConflict:function(deep){if(window.$===jQuery){window.$=_$}if(deep&&window.jQuery===jQuery){window.jQuery=_jQuery}return jQuery},isReady:false,readyWait:1,holdReady:function(hold){if(hold){jQuery.readyWait++}else{jQuery.ready(true)}},ready:function(wait){if(wait===true?--jQuery.readyWait:jQuery.isReady){return }if(!document.body){return setTimeout(jQuery.ready,1)}jQuery.isReady=true;if(wait!==true&&--jQuery.readyWait>0){return }readyList.resolveWith(document,[jQuery]);if(jQuery.fn.trigger){jQuery(document).trigger("ready").off("ready")}},isFunction:function(obj){return jQuery.type(obj)==="function"},isArray:Array.isArray||function(obj){return jQuery.type(obj)==="array"},isWindow:function(obj){return obj!=null&&obj==obj.window},isNumeric:function(obj){return !isNaN(parseFloat(obj))&&isFinite(obj)},type:function(obj){return obj==null?"null":class2type[core_toString.call(obj)]||"object"},isPlainObject:function(obj){if(!obj||jQuery.type(obj)!=="object"||obj.nodeType||jQuery.isWindow(obj)){return false}try{if(obj.constructor&&!core_hasOwn.call(obj,"constructor")&&!core_hasOwn.call(obj.constructor.prototype,"isPrototypeOf")){return false}}catch(e){return false}var key;for(key in obj){}return key===undefined||core_hasOwn.call(obj,key)},isEmptyObject:function(obj){var name;for(name in obj){return false}return true},error:function(msg){throw new Error(msg)},parseHTML:function(data,context,scripts){var parsed;if(!data||typeof data!=="string"){return null}if(typeof context==="boolean"){scripts=context;context=0}context=context||document;if((parsed=rsingleTag.exec(data))){return[context.createElement(parsed[1])]}parsed=jQuery.buildFragment([data],context,scripts?null:[]);return jQuery.merge([],(parsed.cacheable?jQuery.clone(parsed.fragment):parsed.fragment).childNodes)},parseJSON:function(data){if(!data||typeof data!=="string"){return null}data=jQuery.trim(data);if(window.JSON&&window.JSON.parse){return window.JSON.parse(data)}if(rvalidchars.test(data.replace(rvalidescape,"@").replace(rvalidtokens,"]").replace(rvalidbraces,""))){return(new Function("return "+data))()}jQuery.error("Invalid JSON: "+data)},parseXML:function(data){var xml,tmp;if(!data||typeof data!=="string"){return null}try{if(window.DOMParser){tmp=new DOMParser();xml=tmp.parseFromString(data,"text/xml")}else{xml=new ActiveXObject("Microsoft.XMLDOM");xml.async="false";xml.loadXML(data)}}catch(e){xml=undefined}if(!xml||!xml.documentElement||xml.getElementsByTagName("parsererror").length){jQuery.error("Invalid XML: "+data)}return xml},noop:function(){},globalEval:function(data){if(data&&core_rnotwhite.test(data)){(window.execScript||function(data){window["eval"].call(window,data)})(data)}},camelCase:function(string){return string.replace(rmsPrefix,"ms-").replace(rdashAlpha,fcamelCase)},nodeName:function(elem,name){return elem.nodeName&&elem.nodeName.toLowerCase()===name.toLowerCase()},each:function(obj,callback,args){var name,i=0,length=obj.length,isObj=length===undefined||jQuery.isFunction(obj);if(args){if(isObj){for(name in obj){if(callback.apply(obj[name],args)===false){break}}}else{for(;i<length;){if(callback.apply(obj[i++],args)===false){break}}}}else{if(isObj){for(name in obj){if(callback.call(obj[name],name,obj[name])===false){break}}}else{for(;i<length;){if(callback.call(obj[i],i,obj[i++])===false){break}}}}return obj},trim:core_trim&&!core_trim.call("\uFEFF\xA0")?function(text){return text==null?"":core_trim.call(text)}:function(text){return text==null?"":(text+"").replace(rtrim,"")},makeArray:function(arr,results){var type,ret=results||[];if(arr!=null){type=jQuery.type(arr);if(arr.length==null||type==="string"||type==="function"||type==="regexp"||jQuery.isWindow(arr)){core_push.call(ret,arr)}else{jQuery.merge(ret,arr)}}return ret},inArray:function(elem,arr,i){var len;if(arr){if(core_indexOf){return core_indexOf.call(arr,elem,i)}len=arr.length;i=i?i<0?Math.max(0,len+i):i:0;for(;i<len;i++){if(i in arr&&arr[i]===elem){return i}}}return -1},merge:function(first,second){var l=second.length,i=first.length,j=0;if(typeof l==="number"){for(;j<l;j++){first[i++]=second[j]}}else{while(second[j]!==undefined){first[i++]=second[j++]}}first.length=i;return first},grep:function(elems,callback,inv){var retVal,ret=[],i=0,length=elems.length;inv=!!inv;for(;i<length;i++){retVal=!!callback(elems[i],i);if(inv!==retVal){ret.push(elems[i])}}return ret},map:function(elems,callback,arg){var value,key,ret=[],i=0,length=elems.length,isArray=elems instanceof jQuery||length!==undefined&&typeof length==="number"&&((length>0&&elems[0]&&elems[length-1])||length===0||jQuery.isArray(elems));if(isArray){for(;i<length;i++){value=callback(elems[i],i,arg);if(value!=null){ret[ret.length]=value}}}else{for(key in elems){value=callback(elems[key],key,arg);if(value!=null){ret[ret.length]=value}}}return ret.concat.apply([],ret)},guid:1,proxy:function(fn,context){var tmp,args,proxy;if(typeof context==="string"){tmp=fn[context];context=fn;fn=tmp}if(!jQuery.isFunction(fn)){return undefined}args=core_slice.call(arguments,2);proxy=function(){return fn.apply(context,args.concat(core_slice.call(arguments)))};proxy.guid=fn.guid=fn.guid||jQuery.guid++;return proxy},access:function(elems,fn,key,value,chainable,emptyGet,pass){var exec,bulk=key==null,i=0,length=elems.length;if(key&&typeof key==="object"){for(i in key){jQuery.access(elems,fn,i,key[i],1,emptyGet,value)}chainable=1}else{if(value!==undefined){exec=pass===undefined&&jQuery.isFunction(value);if(bulk){if(exec){exec=fn;fn=function(elem,key,value){return exec.call(jQuery(elem),value)}}else{fn.call(elems,value);fn=null}}if(fn){for(;i<length;i++){fn(elems[i],key,exec?value.call(elems[i],i,fn(elems[i],key)):value,pass)}}chainable=1}}return chainable?elems:bulk?fn.call(elems):length?fn(elems[0],key):emptyGet},now:function(){return(new Date()).getTime()}});jQuery.ready.promise=function(obj){if(!readyList){readyList=jQuery.Deferred();if(document.readyState==="complete"){setTimeout(jQuery.ready,1)}else{if(document.addEventListener){document.addEventListener("DOMContentLoaded",DOMContentLoaded,false);window.addEventListener("load",jQuery.ready,false)}else{document.attachEvent("onreadystatechange",DOMContentLoaded);window.attachEvent("onload",jQuery.ready);var top=false;try{top=window.frameElement==null&&document.documentElement}catch(e){}if(top&&top.doScroll){(function doScrollCheck(){if(!jQuery.isReady){try{top.doScroll("left")}catch(e){return setTimeout(doScrollCheck,50)}jQuery.ready()}})()}}}}return readyList.promise(obj)};jQuery.each("Boolean Number String Function Array Date RegExp Object".split(" "),function(i,name){class2type["[object "+name+"]"]=name.toLowerCase()});rootjQuery=jQuery(document);var optionsCache={};function createOptions(options){var object=optionsCache[options]={};jQuery.each(options.split(core_rspace),function(_,flag){object[flag]=true});return object}jQuery.Callbacks=function(options){options=typeof options==="string"?(optionsCache[options]||createOptions(options)):jQuery.extend({},options);var memory,fired,firing,firingStart,firingLength,firingIndex,list=[],stack=!options.once&&[],fire=function(data){memory=options.memory&&data;fired=true;firingIndex=firingStart||0;firingStart=0;firingLength=list.length;firing=true;for(;list&&firingIndex<firingLength;firingIndex++){if(list[firingIndex].apply(data[0],data[1])===false&&options.stopOnFalse){memory=false;break}}firing=false;if(list){if(stack){if(stack.length){fire(stack.shift())}}else{if(memory){list=[]}else{self.disable()}}}},self={add:function(){if(list){var start=list.length;(function add(args){jQuery.each(args,function(_,arg){var type=jQuery.type(arg);if(type==="function"){if(!options.unique||!self.has(arg)){list.push(arg)}}else{if(arg&&arg.length&&type!=="string"){add(arg)}}})})(arguments);if(firing){firingLength=list.length}else{if(memory){firingStart=start;fire(memory)}}}return this},remove:function(){if(list){jQuery.each(arguments,function(_,arg){var index;while((index=jQuery.inArray(arg,list,index))>-1){list.splice(index,1);if(firing){if(index<=firingLength){firingLength--}if(index<=firingIndex){firingIndex--}}}})}return this},has:function(fn){return jQuery.inArray(fn,list)>-1},empty:function(){list=[];return this},disable:function(){list=stack=memory=undefined;return this},disabled:function(){return !list},lock:function(){stack=undefined;if(!memory){self.disable()}return this},locked:function(){return !stack},fireWith:function(context,args){args=args||[];args=[context,args.slice?args.slice():args];if(list&&(!fired||stack)){if(firing){stack.push(args)}else{fire(args)}}return this},fire:function(){self.fireWith(this,arguments);return this},fired:function(){return !!fired}};return self};jQuery.extend({Deferred:function(func){var tuples=[["resolve","done",jQuery.Callbacks("once memory"),"resolved"],["reject","fail",jQuery.Callbacks("once memory"),"rejected"],["notify","progress",jQuery.Callbacks("memory")]],state="pending",promise={state:function(){return state},always:function(){deferred.done(arguments).fail(arguments);return this},then:function(){var fns=arguments;return jQuery.Deferred(function(newDefer){jQuery.each(tuples,function(i,tuple){var action=tuple[0],fn=fns[i];deferred[tuple[1]](jQuery.isFunction(fn)?function(){var returned=fn.apply(this,arguments);if(returned&&jQuery.isFunction(returned.promise)){returned.promise().done(newDefer.resolve).fail(newDefer.reject).progress(newDefer.notify)}else{newDefer[action+"With"](this===deferred?newDefer:this,[returned])}}:newDefer[action])});fns=null}).promise()},promise:function(obj){return obj!=null?jQuery.extend(obj,promise):promise}},deferred={};promise.pipe=promise.then;jQuery.each(tuples,function(i,tuple){var list=tuple[2],stateString=tuple[3];promise[tuple[1]]=list.add;if(stateString){list.add(function(){state=stateString},tuples[i^1][2].disable,tuples[2][2].lock)}deferred[tuple[0]]=list.fire;deferred[tuple[0]+"With"]=list.fireWith});promise.promise(deferred);if(func){func.call(deferred,deferred)}return deferred},when:function(subordinate){var i=0,resolveValues=core_slice.call(arguments),length=resolveValues.length,remaining=length!==1||(subordinate&&jQuery.isFunction(subordinate.promise))?length:0,deferred=remaining===1?subordinate:jQuery.Deferred(),updateFunc=function(i,contexts,values){return function(value){contexts[i]=this;values[i]=arguments.length>1?core_slice.call(arguments):value;if(values===progressValues){deferred.notifyWith(contexts,values)}else{if(!(--remaining)){deferred.resolveWith(contexts,values)}}}},progressValues,progressContexts,resolveContexts;if(length>1){progressValues=new Array(length);progressContexts=new Array(length);resolveContexts=new Array(length);for(;i<length;i++){if(resolveValues[i]&&jQuery.isFunction(resolveValues[i].promise)){resolveValues[i].promise().done(updateFunc(i,resolveContexts,resolveValues)).fail(deferred.reject).progress(updateFunc(i,progressContexts,progressValues))}else{--remaining}}}if(!remaining){deferred.resolveWith(resolveContexts,resolveValues)}return deferred.promise()}});jQuery.support=(function(){var support,all,a,select,opt,input,fragment,eventName,i,isSupported,clickFn,div=document.createElement("div");div.setAttribute("className","t");div.innerHTML="  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>";all=div.getElementsByTagName("*");a=div.getElementsByTagName("a")[0];if(!all||!a||!all.length){return{}}select=document.createElement("select");opt=select.appendChild(document.createElement("option"));input=div.getElementsByTagName("input")[0];a.style.cssText="top:1px;float:left;opacity:.5";support={leadingWhitespace:(div.firstChild.nodeType===3),tbody:!div.getElementsByTagName("tbody").length,htmlSerialize:!!div.getElementsByTagName("link").length,style:/top/.test(a.getAttribute("style")),hrefNormalized:(a.getAttribute("href")==="/a"),opacity:/^0.5/.test(a.style.opacity),cssFloat:!!a.style.cssFloat,checkOn:(input.value==="on"),optSelected:opt.selected,getSetAttribute:div.className!=="t",enctype:!!document.createElement("form").enctype,html5Clone:document.createElement("nav").cloneNode(true).outerHTML!=="<:nav></:nav>",boxModel:(document.compatMode==="CSS1Compat"),submitBubbles:true,changeBubbles:true,focusinBubbles:false,deleteExpando:true,noCloneEvent:true,inlineBlockNeedsLayout:false,shrinkWrapBlocks:false,reliableMarginRight:true,boxSizingReliable:true,pixelPosition:false};input.checked=true;support.noCloneChecked=input.cloneNode(true).checked;select.disabled=true;support.optDisabled=!opt.disabled;try{delete div.test}catch(e){support.deleteExpando=false}if(!div.addEventListener&&div.attachEvent&&div.fireEvent){div.attachEvent("onclick",clickFn=function(){support.noCloneEvent=false});div.cloneNode(true).fireEvent("onclick");div.detachEvent("onclick",clickFn)}input=document.createElement("input");input.value="t";input.setAttribute("type","radio");support.radioValue=input.value==="t";input.setAttribute("checked","checked");input.setAttribute("name","t");div.appendChild(input);fragment=document.createDocumentFragment();fragment.appendChild(div.lastChild);support.checkClone=fragment.cloneNode(true).cloneNode(true).lastChild.checked;support.appendChecked=input.checked;fragment.removeChild(input);fragment.appendChild(div);if(div.attachEvent){for(i in {submit:true,change:true,focusin:true}){eventName="on"+i;isSupported=(eventName in div);if(!isSupported){div.setAttribute(eventName,"return;");isSupported=(typeof div[eventName]==="function")}support[i+"Bubbles"]=isSupported}}jQuery(function(){var container,div,tds,marginDiv,divReset="padding:0;margin:0;border:0;display:block;overflow:hidden;",body=document.getElementsByTagName("body")[0];if(!body){return }container=document.createElement("div");container.style.cssText="visibility:hidden;border:0;width:0;height:0;position:static;top:0;margin-top:1px";body.insertBefore(container,body.firstChild);div=document.createElement("div");container.appendChild(div);div.innerHTML="<table><tr><td></td><td>t</td></tr></table>";tds=div.getElementsByTagName("td");tds[0].style.cssText="padding:0;margin:0;border:0;display:none";isSupported=(tds[0].offsetHeight===0);tds[0].style.display="";tds[1].style.display="none";support.reliableHiddenOffsets=isSupported&&(tds[0].offsetHeight===0);div.innerHTML="";div.style.cssText="box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;";support.boxSizing=(div.offsetWidth===4);support.doesNotIncludeMarginInBodyOffset=(body.offsetTop!==1);if(window.getComputedStyle){support.pixelPosition=(window.getComputedStyle(div,null)||{}).top!=="1%";support.boxSizingReliable=(window.getComputedStyle(div,null)||{width:"4px"}).width==="4px";marginDiv=document.createElement("div");marginDiv.style.cssText=div.style.cssText=divReset;marginDiv.style.marginRight=marginDiv.style.width="0";div.style.width="1px";div.appendChild(marginDiv);support.reliableMarginRight=!parseFloat((window.getComputedStyle(marginDiv,null)||{}).marginRight)}if(typeof div.style.zoom!=="undefined"){div.innerHTML="";div.style.cssText=divReset+"width:1px;padding:1px;display:inline;zoom:1";support.inlineBlockNeedsLayout=(div.offsetWidth===3);div.style.display="block";div.style.overflow="visible";div.innerHTML="<div></div>";div.firstChild.style.width="5px";support.shrinkWrapBlocks=(div.offsetWidth!==3);container.style.zoom=1}body.removeChild(container);container=div=tds=marginDiv=null});fragment.removeChild(div);all=a=select=opt=input=fragment=div=null;return support})();var rbrace=/(?:\{[\s\S]*\}|\[[\s\S]*\])$/,rmultiDash=/([A-Z])/g;jQuery.extend({cache:{},deletedIds:[],uuid:0,expando:"jQuery"+(jQuery.fn.jquery+Math.random()).replace(/\D/g,""),noData:{embed:true,object:"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",applet:true},hasData:function(elem){elem=elem.nodeType?jQuery.cache[elem[jQuery.expando]]:elem[jQuery.expando];return !!elem&&!isEmptyDataObject(elem)},data:function(elem,name,data,pvt){if(!jQuery.acceptData(elem)){return }var thisCache,ret,internalKey=jQuery.expando,getByName=typeof name==="string",isNode=elem.nodeType,cache=isNode?jQuery.cache:elem,id=isNode?elem[internalKey]:elem[internalKey]&&internalKey;if((!id||!cache[id]||(!pvt&&!cache[id].data))&&getByName&&data===undefined){return }if(!id){if(isNode){elem[internalKey]=id=jQuery.deletedIds.pop()||jQuery.guid++}else{id=internalKey}}if(!cache[id]){cache[id]={};if(!isNode){cache[id].toJSON=jQuery.noop}}if(typeof name==="object"||typeof name==="function"){if(pvt){cache[id]=jQuery.extend(cache[id],name)}else{cache[id].data=jQuery.extend(cache[id].data,name)}}thisCache=cache[id];if(!pvt){if(!thisCache.data){thisCache.data={}}thisCache=thisCache.data}if(data!==undefined){thisCache[jQuery.camelCase(name)]=data}if(getByName){ret=thisCache[name];if(ret==null){ret=thisCache[jQuery.camelCase(name)]}}else{ret=thisCache}return ret},removeData:function(elem,name,pvt){if(!jQuery.acceptData(elem)){return }var thisCache,i,l,isNode=elem.nodeType,cache=isNode?jQuery.cache:elem,id=isNode?elem[jQuery.expando]:jQuery.expando;if(!cache[id]){return }if(name){thisCache=pvt?cache[id]:cache[id].data;if(thisCache){if(!jQuery.isArray(name)){if(name in thisCache){name=[name]}else{name=jQuery.camelCase(name);if(name in thisCache){name=[name]}else{name=name.split(" ")}}}for(i=0,l=name.length;i<l;i++){delete thisCache[name[i]]}if(!(pvt?isEmptyDataObject:jQuery.isEmptyObject)(thisCache)){return }}}if(!pvt){delete cache[id].data;if(!isEmptyDataObject(cache[id])){return }}if(isNode){jQuery.cleanData([elem],true)}else{if(jQuery.support.deleteExpando||cache!=cache.window){delete cache[id]}else{cache[id]=null}}},_data:function(elem,name,data){return jQuery.data(elem,name,data,true)},acceptData:function(elem){var noData=elem.nodeName&&jQuery.noData[elem.nodeName.toLowerCase()];return !noData||noData!==true&&elem.getAttribute("classid")===noData}});jQuery.fn.extend({data:function(key,value){var parts,part,attr,name,l,elem=this[0],i=0,data=null;if(key===undefined){if(this.length){data=jQuery.data(elem);if(elem.nodeType===1&&!jQuery._data(elem,"parsedAttrs")){attr=elem.attributes;for(l=attr.length;i<l;i++){name=attr[i].name;if(!name.indexOf("data-")){name=jQuery.camelCase(name.substring(5));dataAttr(elem,name,data[name])}}jQuery._data(elem,"parsedAttrs",true)}}return data}if(typeof key==="object"){return this.each(function(){jQuery.data(this,key)})}parts=key.split(".",2);parts[1]=parts[1]?"."+parts[1]:"";part=parts[1]+"!";return jQuery.access(this,function(value){if(value===undefined){data=this.triggerHandler("getData"+part,[parts[0]]);if(data===undefined&&elem){data=jQuery.data(elem,key);data=dataAttr(elem,key,data)}return data===undefined&&parts[1]?this.data(parts[0]):data}parts[1]=value;this.each(function(){var self=jQuery(this);self.triggerHandler("setData"+part,parts);jQuery.data(this,key,value);self.triggerHandler("changeData"+part,parts)})},null,value,arguments.length>1,null,false)},removeData:function(key){return this.each(function(){jQuery.removeData(this,key)})}});function dataAttr(elem,key,data){if(data===undefined&&elem.nodeType===1){var name="data-"+key.replace(rmultiDash,"-$1").toLowerCase();data=elem.getAttribute(name);if(typeof data==="string"){try{data=data==="true"?true:data==="false"?false:data==="null"?null:+data+""===data?+data:rbrace.test(data)?jQuery.parseJSON(data):data}catch(e){}jQuery.data(elem,key,data)}else{data=undefined}}return data}function isEmptyDataObject(obj){var name;for(name in obj){if(name==="data"&&jQuery.isEmptyObject(obj[name])){continue}if(name!=="toJSON"){return false}}return true}jQuery.extend({queue:function(elem,type,data){var queue;if(elem){type=(type||"fx")+"queue";queue=jQuery._data(elem,type);if(data){if(!queue||jQuery.isArray(data)){queue=jQuery._data(elem,type,jQuery.makeArray(data))}else{queue.push(data)}}return queue||[]}},dequeue:function(elem,type){type=type||"fx";var queue=jQuery.queue(elem,type),startLength=queue.length,fn=queue.shift(),hooks=jQuery._queueHooks(elem,type),next=function(){jQuery.dequeue(elem,type)};if(fn==="inprogress"){fn=queue.shift();startLength--}if(fn){if(type==="fx"){queue.unshift("inprogress")}delete hooks.stop;fn.call(elem,next,hooks)}if(!startLength&&hooks){hooks.empty.fire()}},_queueHooks:function(elem,type){var key=type+"queueHooks";return jQuery._data(elem,key)||jQuery._data(elem,key,{empty:jQuery.Callbacks("once memory").add(function(){jQuery.removeData(elem,type+"queue",true);jQuery.removeData(elem,key,true)})})}});jQuery.fn.extend({queue:function(type,data){var setter=2;if(typeof type!=="string"){data=type;type="fx";setter--}if(arguments.length<setter){return jQuery.queue(this[0],type)}return data===undefined?this:this.each(function(){var queue=jQuery.queue(this,type,data);jQuery._queueHooks(this,type);if(type==="fx"&&queue[0]!=="inprogress"){jQuery.dequeue(this,type)}})},dequeue:function(type){return this.each(function(){jQuery.dequeue(this,type)})},delay:function(time,type){time=jQuery.fx?jQuery.fx.speeds[time]||time:time;type=type||"fx";return this.queue(type,function(next,hooks){var timeout=setTimeout(next,time);hooks.stop=function(){clearTimeout(timeout)}})},clearQueue:function(type){return this.queue(type||"fx",[])},promise:function(type,obj){var tmp,count=1,defer=jQuery.Deferred(),elements=this,i=this.length,resolve=function(){if(!(--count)){defer.resolveWith(elements,[elements])}};if(typeof type!=="string"){obj=type;type=undefined}type=type||"fx";while(i--){tmp=jQuery._data(elements[i],type+"queueHooks");if(tmp&&tmp.empty){count++;tmp.empty.add(resolve)}}resolve();return defer.promise(obj)}});var nodeHook,boolHook,fixSpecified,rclass=/[\t\r\n]/g,rreturn=/\r/g,rtype=/^(?:button|input)$/i,rfocusable=/^(?:button|input|object|select|textarea)$/i,rclickable=/^a(?:rea|)$/i,rboolean=/^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,getSetAttribute=jQuery.support.getSetAttribute;jQuery.fn.extend({attr:function(name,value){return jQuery.access(this,jQuery.attr,name,value,arguments.length>1)},removeAttr:function(name){return this.each(function(){jQuery.removeAttr(this,name)})},prop:function(name,value){return jQuery.access(this,jQuery.prop,name,value,arguments.length>1)},removeProp:function(name){name=jQuery.propFix[name]||name;return this.each(function(){try{this[name]=undefined;delete this[name]}catch(e){}})},addClass:function(value){var classNames,i,l,elem,setClass,c,cl;if(jQuery.isFunction(value)){return this.each(function(j){jQuery(this).addClass(value.call(this,j,this.className))})}if(value&&typeof value==="string"){classNames=value.split(core_rspace);for(i=0,l=this.length;i<l;i++){elem=this[i];if(elem.nodeType===1){if(!elem.className&&classNames.length===1){elem.className=value}else{setClass=" "+elem.className+" ";for(c=0,cl=classNames.length;c<cl;c++){if(setClass.indexOf(" "+classNames[c]+" ")<0){setClass+=classNames[c]+" "}}elem.className=jQuery.trim(setClass)}}}}return this},removeClass:function(value){var removes,className,elem,c,cl,i,l;if(jQuery.isFunction(value)){return this.each(function(j){jQuery(this).removeClass(value.call(this,j,this.className))})}if((value&&typeof value==="string")||value===undefined){removes=(value||"").split(core_rspace);for(i=0,l=this.length;i<l;i++){elem=this[i];if(elem.nodeType===1&&elem.className){className=(" "+elem.className+" ").replace(rclass," ");for(c=0,cl=removes.length;c<cl;c++){while(className.indexOf(" "+removes[c]+" ")>=0){className=className.replace(" "+removes[c]+" "," ")}}elem.className=value?jQuery.trim(className):""}}}return this},toggleClass:function(value,stateVal){var type=typeof value,isBool=typeof stateVal==="boolean";if(jQuery.isFunction(value)){return this.each(function(i){jQuery(this).toggleClass(value.call(this,i,this.className,stateVal),stateVal)})}return this.each(function(){if(type==="string"){var className,i=0,self=jQuery(this),state=stateVal,classNames=value.split(core_rspace);while((className=classNames[i++])){state=isBool?state:!self.hasClass(className);self[state?"addClass":"removeClass"](className)}}else{if(type==="undefined"||type==="boolean"){if(this.className){jQuery._data(this,"__className__",this.className)}this.className=this.className||value===false?"":jQuery._data(this,"__className__")||""}}})},hasClass:function(selector){var className=" "+selector+" ",i=0,l=this.length;for(;i<l;i++){if(this[i].nodeType===1&&(" "+this[i].className+" ").replace(rclass," ").indexOf(className)>=0){return true}}return false},val:function(value){var hooks,ret,isFunction,elem=this[0];if(!arguments.length){if(elem){hooks=jQuery.valHooks[elem.type]||jQuery.valHooks[elem.nodeName.toLowerCase()];if(hooks&&"get" in hooks&&(ret=hooks.get(elem,"value"))!==undefined){return ret}ret=elem.value;return typeof ret==="string"?ret.replace(rreturn,""):ret==null?"":ret}return }isFunction=jQuery.isFunction(value);return this.each(function(i){var val,self=jQuery(this);if(this.nodeType!==1){return }if(isFunction){val=value.call(this,i,self.val())}else{val=value}if(val==null){val=""}else{if(typeof val==="number"){val+=""}else{if(jQuery.isArray(val)){val=jQuery.map(val,function(value){return value==null?"":value+""})}}}hooks=jQuery.valHooks[this.type]||jQuery.valHooks[this.nodeName.toLowerCase()];if(!hooks||!("set" in hooks)||hooks.set(this,val,"value")===undefined){this.value=val}})}});jQuery.extend({valHooks:{option:{get:function(elem){var val=elem.attributes.value;return !val||val.specified?elem.value:elem.text}},select:{get:function(elem){var value,option,options=elem.options,index=elem.selectedIndex,one=elem.type==="select-one"||index<0,values=one?null:[],max=one?index+1:options.length,i=index<0?max:one?index:0;for(;i<max;i++){option=options[i];if((option.selected||i===index)&&(jQuery.support.optDisabled?!option.disabled:option.getAttribute("disabled")===null)&&(!option.parentNode.disabled||!jQuery.nodeName(option.parentNode,"optgroup"))){value=jQuery(option).val();if(one){return value}values.push(value)}}return values},set:function(elem,value){var values=jQuery.makeArray(value);jQuery(elem).find("option").each(function(){this.selected=jQuery.inArray(jQuery(this).val(),values)>=0});if(!values.length){elem.selectedIndex=-1}return values}}},attrFn:{},attr:function(elem,name,value,pass){var ret,hooks,notxml,nType=elem.nodeType;if(!elem||nType===3||nType===8||nType===2){return }if(pass&&jQuery.isFunction(jQuery.fn[name])){return jQuery(elem)[name](value)}if(typeof elem.getAttribute==="undefined"){return jQuery.prop(elem,name,value)}notxml=nType!==1||!jQuery.isXMLDoc(elem);if(notxml){name=name.toLowerCase();hooks=jQuery.attrHooks[name]||(rboolean.test(name)?boolHook:nodeHook)}if(value!==undefined){if(value===null){jQuery.removeAttr(elem,name);return }else{if(hooks&&"set" in hooks&&notxml&&(ret=hooks.set(elem,value,name))!==undefined){return ret}else{elem.setAttribute(name,value+"");return value}}}else{if(hooks&&"get" in hooks&&notxml&&(ret=hooks.get(elem,name))!==null){return ret}else{ret=elem.getAttribute(name);return ret===null?undefined:ret}}},removeAttr:function(elem,value){var propName,attrNames,name,isBool,i=0;if(value&&elem.nodeType===1){attrNames=value.split(core_rspace);for(;i<attrNames.length;i++){name=attrNames[i];if(name){propName=jQuery.propFix[name]||name;isBool=rboolean.test(name);if(!isBool){jQuery.attr(elem,name,"")}elem.removeAttribute(getSetAttribute?name:propName);if(isBool&&propName in elem){elem[propName]=false}}}}},attrHooks:{type:{set:function(elem,value){if(rtype.test(elem.nodeName)&&elem.parentNode){jQuery.error("type property can't be changed")}else{if(!jQuery.support.radioValue&&value==="radio"&&jQuery.nodeName(elem,"input")){var val=elem.value;elem.setAttribute("type",value);if(val){elem.value=val}return value}}}},value:{get:function(elem,name){if(nodeHook&&jQuery.nodeName(elem,"button")){return nodeHook.get(elem,name)}return name in elem?elem.value:null},set:function(elem,value,name){if(nodeHook&&jQuery.nodeName(elem,"button")){return nodeHook.set(elem,value,name)}elem.value=value}}},propFix:{tabindex:"tabIndex",readonly:"readOnly","for":"htmlFor","class":"className",maxlength:"maxLength",cellspacing:"cellSpacing",cellpadding:"cellPadding",rowspan:"rowSpan",colspan:"colSpan",usemap:"useMap",frameborder:"frameBorder",contenteditable:"contentEditable"},prop:function(elem,name,value){var ret,hooks,notxml,nType=elem.nodeType;if(!elem||nType===3||nType===8||nType===2){return }notxml=nType!==1||!jQuery.isXMLDoc(elem);if(notxml){name=jQuery.propFix[name]||name;hooks=jQuery.propHooks[name]}if(value!==undefined){if(hooks&&"set" in hooks&&(ret=hooks.set(elem,value,name))!==undefined){return ret}else{return(elem[name]=value)}}else{if(hooks&&"get" in hooks&&(ret=hooks.get(elem,name))!==null){return ret}else{return elem[name]}}},propHooks:{tabIndex:{get:function(elem){var attributeNode=elem.getAttributeNode("tabindex");return attributeNode&&attributeNode.specified?parseInt(attributeNode.value,10):rfocusable.test(elem.nodeName)||rclickable.test(elem.nodeName)&&elem.href?0:undefined}}}});boolHook={get:function(elem,name){var attrNode,property=jQuery.prop(elem,name);return property===true||typeof property!=="boolean"&&(attrNode=elem.getAttributeNode(name))&&attrNode.nodeValue!==false?name.toLowerCase():undefined},set:function(elem,value,name){var propName;if(value===false){jQuery.removeAttr(elem,name)}else{propName=jQuery.propFix[name]||name;if(propName in elem){elem[propName]=true}elem.setAttribute(name,name.toLowerCase())}return name}};if(!getSetAttribute){fixSpecified={name:true,id:true,coords:true};nodeHook=jQuery.valHooks.button={get:function(elem,name){var ret;ret=elem.getAttributeNode(name);return ret&&(fixSpecified[name]?ret.value!=="":ret.specified)?ret.value:undefined},set:function(elem,value,name){var ret=elem.getAttributeNode(name);if(!ret){ret=document.createAttribute(name);elem.setAttributeNode(ret)}return(ret.value=value+"")}};jQuery.each(["width","height"],function(i,name){jQuery.attrHooks[name]=jQuery.extend(jQuery.attrHooks[name],{set:function(elem,value){if(value===""){elem.setAttribute(name,"auto");return value}}})});jQuery.attrHooks.contenteditable={get:nodeHook.get,set:function(elem,value,name){if(value===""){value="false"}nodeHook.set(elem,value,name)}}}if(!jQuery.support.hrefNormalized){jQuery.each(["href","src","width","height"],function(i,name){jQuery.attrHooks[name]=jQuery.extend(jQuery.attrHooks[name],{get:function(elem){var ret=elem.getAttribute(name,2);return ret===null?undefined:ret}})})}if(!jQuery.support.style){jQuery.attrHooks.style={get:function(elem){return elem.style.cssText.toLowerCase()||undefined},set:function(elem,value){return(elem.style.cssText=value+"")}}}if(!jQuery.support.optSelected){jQuery.propHooks.selected=jQuery.extend(jQuery.propHooks.selected,{get:function(elem){var parent=elem.parentNode;if(parent){parent.selectedIndex;if(parent.parentNode){parent.parentNode.selectedIndex}}return null}})}if(!jQuery.support.enctype){jQuery.propFix.enctype="encoding"}if(!jQuery.support.checkOn){jQuery.each(["radio","checkbox"],function(){jQuery.valHooks[this]={get:function(elem){return elem.getAttribute("value")===null?"on":elem.value}}})}jQuery.each(["radio","checkbox"],function(){jQuery.valHooks[this]=jQuery.extend(jQuery.valHooks[this],{set:function(elem,value){if(jQuery.isArray(value)){return(elem.checked=jQuery.inArray(jQuery(elem).val(),value)>=0)}}})});var rformElems=/^(?:textarea|input|select)$/i,rtypenamespace=/^([^\.]*|)(?:\.(.+)|)$/,rhoverHack=/(?:^|\s)hover(\.\S+|)\b/,rkeyEvent=/^key/,rmouseEvent=/^(?:mouse|contextmenu)|click/,rfocusMorph=/^(?:focusinfocus|focusoutblur)$/,hoverHack=function(events){return jQuery.event.special.hover?events:events.replace(rhoverHack,"mouseenter$1 mouseleave$1")};jQuery.event={add:function(elem,types,handler,data,selector){var elemData,eventHandle,events,t,tns,type,namespaces,handleObj,handleObjIn,handlers,special;if(elem.nodeType===3||elem.nodeType===8||!types||!handler||!(elemData=jQuery._data(elem))){return }if(handler.handler){handleObjIn=handler;handler=handleObjIn.handler;selector=handleObjIn.selector}if(!handler.guid){handler.guid=jQuery.guid++}events=elemData.events;if(!events){elemData.events=events={}}eventHandle=elemData.handle;if(!eventHandle){elemData.handle=eventHandle=function(e){return typeof jQuery!=="undefined"&&(!e||jQuery.event.triggered!==e.type)?jQuery.event.dispatch.apply(eventHandle.elem,arguments):undefined};eventHandle.elem=elem}types=jQuery.trim(hoverHack(types)).split(" ");for(t=0;t<types.length;t++){tns=rtypenamespace.exec(types[t])||[];type=tns[1];namespaces=(tns[2]||"").split(".").sort();special=jQuery.event.special[type]||{};type=(selector?special.delegateType:special.bindType)||type;special=jQuery.event.special[type]||{};handleObj=jQuery.extend({type:type,origType:tns[1],data:data,handler:handler,guid:handler.guid,selector:selector,needsContext:selector&&jQuery.expr.match.needsContext.test(selector),namespace:namespaces.join(".")},handleObjIn);handlers=events[type];if(!handlers){handlers=events[type]=[];handlers.delegateCount=0;if(!special.setup||special.setup.call(elem,data,namespaces,eventHandle)===false){if(elem.addEventListener){elem.addEventListener(type,eventHandle,false)}else{if(elem.attachEvent){elem.attachEvent("on"+type,eventHandle)}}}}if(special.add){special.add.call(elem,handleObj);if(!handleObj.handler.guid){handleObj.handler.guid=handler.guid}}if(selector){handlers.splice(handlers.delegateCount++,0,handleObj)}else{handlers.push(handleObj)}jQuery.event.global[type]=true}elem=null},global:{},remove:function(elem,types,handler,selector,mappedTypes){var t,tns,type,origType,namespaces,origCount,j,events,special,eventType,handleObj,elemData=jQuery.hasData(elem)&&jQuery._data(elem);if(!elemData||!(events=elemData.events)){return }types=jQuery.trim(hoverHack(types||"")).split(" ");for(t=0;t<types.length;t++){tns=rtypenamespace.exec(types[t])||[];type=origType=tns[1];namespaces=tns[2];if(!type){for(type in events){jQuery.event.remove(elem,type+types[t],handler,selector,true)}continue}special=jQuery.event.special[type]||{};type=(selector?special.delegateType:special.bindType)||type;eventType=events[type]||[];origCount=eventType.length;namespaces=namespaces?new RegExp("(^|\\.)"+namespaces.split(".").sort().join("\\.(?:.*\\.|)")+"(\\.|$)"):null;for(j=0;j<eventType.length;j++){handleObj=eventType[j];if((mappedTypes||origType===handleObj.origType)&&(!handler||handler.guid===handleObj.guid)&&(!namespaces||namespaces.test(handleObj.namespace))&&(!selector||selector===handleObj.selector||selector==="**"&&handleObj.selector)){eventType.splice(j--,1);if(handleObj.selector){eventType.delegateCount--}if(special.remove){special.remove.call(elem,handleObj)}}}if(eventType.length===0&&origCount!==eventType.length){if(!special.teardown||special.teardown.call(elem,namespaces,elemData.handle)===false){jQuery.removeEvent(elem,type,elemData.handle)}delete events[type]}}if(jQuery.isEmptyObject(events)){delete elemData.handle;jQuery.removeData(elem,"events",true)}},customEvent:{getData:true,setData:true,changeData:true},trigger:function(event,data,elem,onlyHandlers){if(elem&&(elem.nodeType===3||elem.nodeType===8)){return }var cache,exclusive,i,cur,old,ontype,special,handle,eventPath,bubbleType,type=event.type||event,namespaces=[];if(rfocusMorph.test(type+jQuery.event.triggered)){return }if(type.indexOf("!")>=0){type=type.slice(0,-1);exclusive=true}if(type.indexOf(".")>=0){namespaces=type.split(".");type=namespaces.shift();namespaces.sort()}if((!elem||jQuery.event.customEvent[type])&&!jQuery.event.global[type]){return }event=typeof event==="object"?event[jQuery.expando]?event:new jQuery.Event(type,event):new jQuery.Event(type);event.type=type;event.isTrigger=true;event.exclusive=exclusive;event.namespace=namespaces.join(".");event.namespace_re=event.namespace?new RegExp("(^|\\.)"+namespaces.join("\\.(?:.*\\.|)")+"(\\.|$)"):null;ontype=type.indexOf(":")<0?"on"+type:"";if(!elem){cache=jQuery.cache;for(i in cache){if(cache[i].events&&cache[i].events[type]){jQuery.event.trigger(event,data,cache[i].handle.elem,true)}}return }event.result=undefined;if(!event.target){event.target=elem}data=data!=null?jQuery.makeArray(data):[];data.unshift(event);special=jQuery.event.special[type]||{};if(special.trigger&&special.trigger.apply(elem,data)===false){return }eventPath=[[elem,special.bindType||type]];if(!onlyHandlers&&!special.noBubble&&!jQuery.isWindow(elem)){bubbleType=special.delegateType||type;cur=rfocusMorph.test(bubbleType+type)?elem:elem.parentNode;for(old=elem;cur;cur=cur.parentNode){eventPath.push([cur,bubbleType]);old=cur}if(old===(elem.ownerDocument||document)){eventPath.push([old.defaultView||old.parentWindow||window,bubbleType])}}for(i=0;i<eventPath.length&&!event.isPropagationStopped();i++){cur=eventPath[i][0];event.type=eventPath[i][1];handle=(jQuery._data(cur,"events")||{})[event.type]&&jQuery._data(cur,"handle");if(handle){handle.apply(cur,data)}handle=ontype&&cur[ontype];if(handle&&jQuery.acceptData(cur)&&handle.apply&&handle.apply(cur,data)===false){event.preventDefault()}}event.type=type;if(!onlyHandlers&&!event.isDefaultPrevented()){if((!special._default||special._default.apply(elem.ownerDocument,data)===false)&&!(type==="click"&&jQuery.nodeName(elem,"a"))&&jQuery.acceptData(elem)){if(ontype&&elem[type]&&((type!=="focus"&&type!=="blur")||event.target.offsetWidth!==0)&&!jQuery.isWindow(elem)){old=elem[ontype];if(old){elem[ontype]=null}jQuery.event.triggered=type;elem[type]();jQuery.event.triggered=undefined;if(old){elem[ontype]=old}}}}return event.result},dispatch:function(event){event=jQuery.event.fix(event||window.event);var i,j,cur,ret,selMatch,matched,matches,handleObj,sel,related,handlers=((jQuery._data(this,"events")||{})[event.type]||[]),delegateCount=handlers.delegateCount,args=core_slice.call(arguments),run_all=!event.exclusive&&!event.namespace,special=jQuery.event.special[event.type]||{},handlerQueue=[];args[0]=event;event.delegateTarget=this;if(special.preDispatch&&special.preDispatch.call(this,event)===false){return }if(delegateCount&&!(event.button&&event.type==="click")){for(cur=event.target;cur!=this;cur=cur.parentNode||this){if(cur.disabled!==true||event.type!=="click"){selMatch={};matches=[];for(i=0;i<delegateCount;i++){handleObj=handlers[i];sel=handleObj.selector;if(selMatch[sel]===undefined){selMatch[sel]=handleObj.needsContext?jQuery(sel,this).index(cur)>=0:jQuery.find(sel,this,null,[cur]).length}if(selMatch[sel]){matches.push(handleObj)}}if(matches.length){handlerQueue.push({elem:cur,matches:matches})}}}}if(handlers.length>delegateCount){handlerQueue.push({elem:this,matches:handlers.slice(delegateCount)})}for(i=0;i<handlerQueue.length&&!event.isPropagationStopped();i++){matched=handlerQueue[i];event.currentTarget=matched.elem;for(j=0;j<matched.matches.length&&!event.isImmediatePropagationStopped();j++){handleObj=matched.matches[j];if(run_all||(!event.namespace&&!handleObj.namespace)||event.namespace_re&&event.namespace_re.test(handleObj.namespace)){event.data=handleObj.data;event.handleObj=handleObj;ret=((jQuery.event.special[handleObj.origType]||{}).handle||handleObj.handler).apply(matched.elem,args);if(ret!==undefined){event.result=ret;if(ret===false){event.preventDefault();event.stopPropagation()}}}}}if(special.postDispatch){special.postDispatch.call(this,event)}return event.result},props:"attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),fixHooks:{},keyHooks:{props:"char charCode key keyCode".split(" "),filter:function(event,original){if(event.which==null){event.which=original.charCode!=null?original.charCode:original.keyCode}return event}},mouseHooks:{props:"button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),filter:function(event,original){var eventDoc,doc,body,button=original.button,fromElement=original.fromElement;if(event.pageX==null&&original.clientX!=null){eventDoc=event.target.ownerDocument||document;doc=eventDoc.documentElement;body=eventDoc.body;event.pageX=original.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc&&doc.clientLeft||body&&body.clientLeft||0);event.pageY=original.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc&&doc.clientTop||body&&body.clientTop||0)}if(!event.relatedTarget&&fromElement){event.relatedTarget=fromElement===event.target?original.toElement:fromElement}if(!event.which&&button!==undefined){event.which=(button&1?1:(button&2?3:(button&4?2:0)))}return event}},fix:function(event){if(event[jQuery.expando]){return event}var i,prop,originalEvent=event,fixHook=jQuery.event.fixHooks[event.type]||{},copy=fixHook.props?this.props.concat(fixHook.props):this.props;event=jQuery.Event(originalEvent);for(i=copy.length;i;){prop=copy[--i];event[prop]=originalEvent[prop]}if(!event.target){event.target=originalEvent.srcElement||document}if(event.target.nodeType===3){event.target=event.target.parentNode}event.metaKey=!!event.metaKey;return fixHook.filter?fixHook.filter(event,originalEvent):event},special:{load:{noBubble:true},focus:{delegateType:"focusin"},blur:{delegateType:"focusout"},beforeunload:{setup:function(data,namespaces,eventHandle){if(jQuery.isWindow(this)){this.onbeforeunload=eventHandle}},teardown:function(namespaces,eventHandle){if(this.onbeforeunload===eventHandle){this.onbeforeunload=null}}}},simulate:function(type,elem,event,bubble){var e=jQuery.extend(new jQuery.Event(),event,{type:type,isSimulated:true,originalEvent:{}});if(bubble){jQuery.event.trigger(e,null,elem)}else{jQuery.event.dispatch.call(elem,e)}if(e.isDefaultPrevented()){event.preventDefault()}}};jQuery.event.handle=jQuery.event.dispatch;jQuery.removeEvent=document.removeEventListener?function(elem,type,handle){if(elem.removeEventListener){elem.removeEventListener(type,handle,false)}}:function(elem,type,handle){var name="on"+type;if(elem.detachEvent){if(typeof elem[name]==="undefined"){elem[name]=null}elem.detachEvent(name,handle)}};jQuery.Event=function(src,props){if(!(this instanceof jQuery.Event)){return new jQuery.Event(src,props)}if(src&&src.type){this.originalEvent=src;this.type=src.type;this.isDefaultPrevented=(src.defaultPrevented||src.returnValue===false||src.getPreventDefault&&src.getPreventDefault())?returnTrue:returnFalse}else{this.type=src}if(props){jQuery.extend(this,props)}this.timeStamp=src&&src.timeStamp||jQuery.now();this[jQuery.expando]=true};function returnFalse(){return false}function returnTrue(){return true}jQuery.Event.prototype={preventDefault:function(){this.isDefaultPrevented=returnTrue;var e=this.originalEvent;if(!e){return }if(e.preventDefault){e.preventDefault()}else{e.returnValue=false}},stopPropagation:function(){this.isPropagationStopped=returnTrue;var e=this.originalEvent;if(!e){return }if(e.stopPropagation){e.stopPropagation()}e.cancelBubble=true},stopImmediatePropagation:function(){this.isImmediatePropagationStopped=returnTrue;this.stopPropagation()},isDefaultPrevented:returnFalse,isPropagationStopped:returnFalse,isImmediatePropagationStopped:returnFalse};jQuery.each({mouseenter:"mouseover",mouseleave:"mouseout"},function(orig,fix){jQuery.event.special[orig]={delegateType:fix,bindType:fix,handle:function(event){var ret,target=this,related=event.relatedTarget,handleObj=event.handleObj,selector=handleObj.selector;if(!related||(related!==target&&!jQuery.contains(target,related))){event.type=handleObj.origType;ret=handleObj.handler.apply(this,arguments);event.type=fix}return ret}}});if(!jQuery.support.submitBubbles){jQuery.event.special.submit={setup:function(){if(jQuery.nodeName(this,"form")){return false}jQuery.event.add(this,"click._submit keypress._submit",function(e){var elem=e.target,form=jQuery.nodeName(elem,"input")||jQuery.nodeName(elem,"button")?elem.form:undefined;if(form&&!jQuery._data(form,"_submit_attached")){jQuery.event.add(form,"submit._submit",function(event){event._submit_bubble=true});jQuery._data(form,"_submit_attached",true)}})},postDispatch:function(event){if(event._submit_bubble){delete event._submit_bubble;if(this.parentNode&&!event.isTrigger){jQuery.event.simulate("submit",this.parentNode,event,true)}}},teardown:function(){if(jQuery.nodeName(this,"form")){return false}jQuery.event.remove(this,"._submit")}}}if(!jQuery.support.changeBubbles){jQuery.event.special.change={setup:function(){if(rformElems.test(this.nodeName)){if(this.type==="checkbox"||this.type==="radio"){jQuery.event.add(this,"propertychange._change",function(event){if(event.originalEvent.propertyName==="checked"){this._just_changed=true}});jQuery.event.add(this,"click._change",function(event){if(this._just_changed&&!event.isTrigger){this._just_changed=false}jQuery.event.simulate("change",this,event,true)})}return false}jQuery.event.add(this,"beforeactivate._change",function(e){var elem=e.target;if(rformElems.test(elem.nodeName)&&!jQuery._data(elem,"_change_attached")){jQuery.event.add(elem,"change._change",function(event){if(this.parentNode&&!event.isSimulated&&!event.isTrigger){jQuery.event.simulate("change",this.parentNode,event,true)}});jQuery._data(elem,"_change_attached",true)}})},handle:function(event){var elem=event.target;if(this!==elem||event.isSimulated||event.isTrigger||(elem.type!=="radio"&&elem.type!=="checkbox")){return event.handleObj.handler.apply(this,arguments)}},teardown:function(){jQuery.event.remove(this,"._change");return !rformElems.test(this.nodeName)}}}if(!jQuery.support.focusinBubbles){jQuery.each({focus:"focusin",blur:"focusout"},function(orig,fix){var attaches=0,handler=function(event){jQuery.event.simulate(fix,event.target,jQuery.event.fix(event),true)};jQuery.event.special[fix]={setup:function(){if(attaches++===0){document.addEventListener(orig,handler,true)}},teardown:function(){if(--attaches===0){document.removeEventListener(orig,handler,true)}}}})}jQuery.fn.extend({on:function(types,selector,data,fn,one){var origFn,type;if(typeof types==="object"){if(typeof selector!=="string"){data=data||selector;selector=undefined}for(type in types){this.on(type,selector,data,types[type],one)}return this}if(data==null&&fn==null){fn=selector;data=selector=undefined}else{if(fn==null){if(typeof selector==="string"){fn=data;data=undefined}else{fn=data;data=selector;selector=undefined}}}if(fn===false){fn=returnFalse}else{if(!fn){return this}}if(one===1){origFn=fn;fn=function(event){jQuery().off(event);return origFn.apply(this,arguments)};fn.guid=origFn.guid||(origFn.guid=jQuery.guid++)}return this.each(function(){jQuery.event.add(this,types,fn,data,selector)})},one:function(types,selector,data,fn){return this.on(types,selector,data,fn,1)},off:function(types,selector,fn){var handleObj,type;if(types&&types.preventDefault&&types.handleObj){handleObj=types.handleObj;jQuery(types.delegateTarget).off(handleObj.namespace?handleObj.origType+"."+handleObj.namespace:handleObj.origType,handleObj.selector,handleObj.handler);return this}if(typeof types==="object"){for(type in types){this.off(type,selector,types[type])}return this}if(selector===false||typeof selector==="function"){fn=selector;selector=undefined}if(fn===false){fn=returnFalse}return this.each(function(){jQuery.event.remove(this,types,fn,selector)})},bind:function(types,data,fn){return this.on(types,null,data,fn)},unbind:function(types,fn){return this.off(types,null,fn)},live:function(types,data,fn){jQuery(this.context).on(types,this.selector,data,fn);return this},die:function(types,fn){jQuery(this.context).off(types,this.selector||"**",fn);return this},delegate:function(selector,types,data,fn){return this.on(types,selector,data,fn)},undelegate:function(selector,types,fn){return arguments.length===1?this.off(selector,"**"):this.off(types,selector||"**",fn)},trigger:function(type,data){return this.each(function(){jQuery.event.trigger(type,data,this)})},triggerHandler:function(type,data){if(this[0]){return jQuery.event.trigger(type,data,this[0],true)}},toggle:function(fn){var args=arguments,guid=fn.guid||jQuery.guid++,i=0,toggler=function(event){var lastToggle=(jQuery._data(this,"lastToggle"+fn.guid)||0)%i;jQuery._data(this,"lastToggle"+fn.guid,lastToggle+1);event.preventDefault();return args[lastToggle].apply(this,arguments)||false};toggler.guid=guid;while(i<args.length){args[i++].guid=guid}return this.click(toggler)},hover:function(fnOver,fnOut){return this.mouseenter(fnOver).mouseleave(fnOut||fnOver)}});jQuery.each(("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu").split(" "),function(i,name){jQuery.fn[name]=function(data,fn){if(fn==null){fn=data;data=null}return arguments.length>0?this.on(name,null,data,fn):this.trigger(name)};if(rkeyEvent.test(name)){jQuery.event.fixHooks[name]=jQuery.event.keyHooks}if(rmouseEvent.test(name)){jQuery.event.fixHooks[name]=jQuery.event.mouseHooks}});
/*
 * Sizzle CSS Selector Engine
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license
 * http://sizzlejs.com/
 */
(function(window,undefined){var cachedruns,assertGetIdNotName,Expr,getText,isXML,contains,compile,sortOrder,hasDuplicate,outermostContext,baseHasDuplicate=true,strundefined="undefined",expando=("sizcache"+Math.random()).replace(".",""),Token=String,document=window.document,docElem=document.documentElement,dirruns=0,done=0,pop=[].pop,push=[].push,slice=[].slice,indexOf=[].indexOf||function(elem){var i=0,len=this.length;for(;i<len;i++){if(this[i]===elem){return i}}return -1},markFunction=function(fn,value){fn[expando]=value==null||value;return fn},createCache=function(){var cache={},keys=[];return markFunction(function(key,value){if(keys.push(key)>Expr.cacheLength){delete cache[keys.shift()]}return(cache[key+" "]=value)},cache)},classCache=createCache(),tokenCache=createCache(),compilerCache=createCache(),whitespace="[\\x20\\t\\r\\n\\f]",characterEncoding="(?:\\\\.|[-\\w]|[^\\x00-\\xa0])+",identifier=characterEncoding.replace("w","w#"),operators="([*^$|!~]?=)",attributes="\\["+whitespace+"*("+characterEncoding+")"+whitespace+"*(?:"+operators+whitespace+"*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|("+identifier+")|)|)"+whitespace+"*\\]",pseudos=":("+characterEncoding+")(?:\\((?:(['\"])((?:\\\\.|[^\\\\])*?)\\2|([^()[\\]]*|(?:(?:"+attributes+")|[^:]|\\\\.)*|.*))\\)|)",pos=":(even|odd|eq|gt|lt|nth|first|last)(?:\\("+whitespace+"*((?:-\\d)?\\d*)"+whitespace+"*\\)|)(?=[^-]|$)",rtrim=new RegExp("^"+whitespace+"+|((?:^|[^\\\\])(?:\\\\.)*)"+whitespace+"+$","g"),rcomma=new RegExp("^"+whitespace+"*,"+whitespace+"*"),rcombinators=new RegExp("^"+whitespace+"*([\\x20\\t\\r\\n\\f>+~])"+whitespace+"*"),rpseudo=new RegExp(pseudos),rquickExpr=/^(?:#([\w\-]+)|(\w+)|\.([\w\-]+))$/,rnot=/^:not/,rsibling=/[\x20\t\r\n\f]*[+~]/,rendsWithNot=/:not\($/,rheader=/h\d/i,rinputs=/input|select|textarea|button/i,rbackslash=/\\(?!\\)/g,matchExpr={ID:new RegExp("^#("+characterEncoding+")"),CLASS:new RegExp("^\\.("+characterEncoding+")"),NAME:new RegExp("^\\[name=['\"]?("+characterEncoding+")['\"]?\\]"),TAG:new RegExp("^("+characterEncoding.replace("w","w*")+")"),ATTR:new RegExp("^"+attributes),PSEUDO:new RegExp("^"+pseudos),POS:new RegExp(pos,"i"),CHILD:new RegExp("^:(only|nth|first|last)-child(?:\\("+whitespace+"*(even|odd|(([+-]|)(\\d*)n|)"+whitespace+"*(?:([+-]|)"+whitespace+"*(\\d+)|))"+whitespace+"*\\)|)","i"),needsContext:new RegExp("^"+whitespace+"*[>+~]|"+pos,"i")},assert=function(fn){var div=document.createElement("div");try{return fn(div)}catch(e){return false}finally{div=null}},assertTagNameNoComments=assert(function(div){div.appendChild(document.createComment(""));return !div.getElementsByTagName("*").length}),assertHrefNotNormalized=assert(function(div){div.innerHTML="<a href='#'></a>";return div.firstChild&&typeof div.firstChild.getAttribute!==strundefined&&div.firstChild.getAttribute("href")==="#"}),assertAttributes=assert(function(div){div.innerHTML="<select></select>";var type=typeof div.lastChild.getAttribute("multiple");return type!=="boolean"&&type!=="string"}),assertUsableClassName=assert(function(div){div.innerHTML="<div class='hidden e'></div><div class='hidden'></div>";if(!div.getElementsByClassName||!div.getElementsByClassName("e").length){return false}div.lastChild.className="e";return div.getElementsByClassName("e").length===2}),assertUsableName=assert(function(div){div.id=expando+0;div.innerHTML="<a name='"+expando+"'></a><div name='"+expando+"'></div>";docElem.insertBefore(div,docElem.firstChild);var pass=document.getElementsByName&&document.getElementsByName(expando).length===2+document.getElementsByName(expando+0).length;assertGetIdNotName=!document.getElementById(expando);docElem.removeChild(div);return pass});try{slice.call(docElem.childNodes,0)[0].nodeType}catch(e){slice=function(i){var elem,results=[];for(;(elem=this[i]);i++){results.push(elem)}return results}}function Sizzle(selector,context,results,seed){results=results||[];context=context||document;var match,elem,xml,m,nodeType=context.nodeType;if(!selector||typeof selector!=="string"){return results}if(nodeType!==1&&nodeType!==9){return[]}xml=isXML(context);if(!xml&&!seed){if((match=rquickExpr.exec(selector))){if((m=match[1])){if(nodeType===9){elem=context.getElementById(m);if(elem&&elem.parentNode){if(elem.id===m){results.push(elem);return results}}else{return results}}else{if(context.ownerDocument&&(elem=context.ownerDocument.getElementById(m))&&contains(context,elem)&&elem.id===m){results.push(elem);return results}}}else{if(match[2]){push.apply(results,slice.call(context.getElementsByTagName(selector),0));return results}else{if((m=match[3])&&assertUsableClassName&&context.getElementsByClassName){push.apply(results,slice.call(context.getElementsByClassName(m),0));return results}}}}}return select(selector.replace(rtrim,"$1"),context,results,seed,xml)}Sizzle.matches=function(expr,elements){return Sizzle(expr,null,null,elements)};Sizzle.matchesSelector=function(elem,expr){return Sizzle(expr,null,null,[elem]).length>0};function createInputPseudo(type){return function(elem){var name=elem.nodeName.toLowerCase();return name==="input"&&elem.type===type}}function createButtonPseudo(type){return function(elem){var name=elem.nodeName.toLowerCase();return(name==="input"||name==="button")&&elem.type===type}}function createPositionalPseudo(fn){return markFunction(function(argument){argument=+argument;return markFunction(function(seed,matches){var j,matchIndexes=fn([],seed.length,argument),i=matchIndexes.length;while(i--){if(seed[(j=matchIndexes[i])]){seed[j]=!(matches[j]=seed[j])}}})})}getText=Sizzle.getText=function(elem){var node,ret="",i=0,nodeType=elem.nodeType;if(nodeType){if(nodeType===1||nodeType===9||nodeType===11){if(typeof elem.textContent==="string"){return elem.textContent}else{for(elem=elem.firstChild;elem;elem=elem.nextSibling){ret+=getText(elem)}}}else{if(nodeType===3||nodeType===4){return elem.nodeValue}}}else{for(;(node=elem[i]);i++){ret+=getText(node)}}return ret};isXML=Sizzle.isXML=function(elem){var documentElement=elem&&(elem.ownerDocument||elem).documentElement;return documentElement?documentElement.nodeName!=="HTML":false};contains=Sizzle.contains=docElem.contains?function(a,b){var adown=a.nodeType===9?a.documentElement:a,bup=b&&b.parentNode;return a===bup||!!(bup&&bup.nodeType===1&&adown.contains&&adown.contains(bup))}:docElem.compareDocumentPosition?function(a,b){return b&&!!(a.compareDocumentPosition(b)&16)}:function(a,b){while((b=b.parentNode)){if(b===a){return true}}return false};Sizzle.attr=function(elem,name){var val,xml=isXML(elem);if(!xml){name=name.toLowerCase()}if((val=Expr.attrHandle[name])){return val(elem)}if(xml||assertAttributes){return elem.getAttribute(name)}val=elem.getAttributeNode(name);return val?typeof elem[name]==="boolean"?elem[name]?name:null:val.specified?val.value:null:null};Expr=Sizzle.selectors={cacheLength:50,createPseudo:markFunction,match:matchExpr,attrHandle:assertHrefNotNormalized?{}:{href:function(elem){return elem.getAttribute("href",2)},type:function(elem){return elem.getAttribute("type")}},find:{ID:assertGetIdNotName?function(id,context,xml){if(typeof context.getElementById!==strundefined&&!xml){var m=context.getElementById(id);return m&&m.parentNode?[m]:[]}}:function(id,context,xml){if(typeof context.getElementById!==strundefined&&!xml){var m=context.getElementById(id);return m?m.id===id||typeof m.getAttributeNode!==strundefined&&m.getAttributeNode("id").value===id?[m]:undefined:[]}},TAG:assertTagNameNoComments?function(tag,context){if(typeof context.getElementsByTagName!==strundefined){return context.getElementsByTagName(tag)}}:function(tag,context){var results=context.getElementsByTagName(tag);if(tag==="*"){var elem,tmp=[],i=0;for(;(elem=results[i]);i++){if(elem.nodeType===1){tmp.push(elem)}}return tmp}return results},NAME:assertUsableName&&function(tag,context){if(typeof context.getElementsByName!==strundefined){return context.getElementsByName(name)}},CLASS:assertUsableClassName&&function(className,context,xml){if(typeof context.getElementsByClassName!==strundefined&&!xml){return context.getElementsByClassName(className)}}},relative:{">":{dir:"parentNode",first:true}," ":{dir:"parentNode"},"+":{dir:"previousSibling",first:true},"~":{dir:"previousSibling"}},preFilter:{ATTR:function(match){match[1]=match[1].replace(rbackslash,"");match[3]=(match[4]||match[5]||"").replace(rbackslash,"");if(match[2]==="~="){match[3]=" "+match[3]+" "}return match.slice(0,4)},CHILD:function(match){match[1]=match[1].toLowerCase();if(match[1]==="nth"){if(!match[2]){Sizzle.error(match[0])}match[3]=+(match[3]?match[4]+(match[5]||1):2*(match[2]==="even"||match[2]==="odd"));match[4]=+((match[6]+match[7])||match[2]==="odd")}else{if(match[2]){Sizzle.error(match[0])}}return match},PSEUDO:function(match){var unquoted,excess;if(matchExpr.CHILD.test(match[0])){return null}if(match[3]){match[2]=match[3]}else{if((unquoted=match[4])){if(rpseudo.test(unquoted)&&(excess=tokenize(unquoted,true))&&(excess=unquoted.indexOf(")",unquoted.length-excess)-unquoted.length)){unquoted=unquoted.slice(0,excess);match[0]=match[0].slice(0,excess)}match[2]=unquoted}}return match.slice(0,3)}},filter:{ID:assertGetIdNotName?function(id){id=id.replace(rbackslash,"");return function(elem){return elem.getAttribute("id")===id}}:function(id){id=id.replace(rbackslash,"");return function(elem){var node=typeof elem.getAttributeNode!==strundefined&&elem.getAttributeNode("id");return node&&node.value===id}},TAG:function(nodeName){if(nodeName==="*"){return function(){return true}}nodeName=nodeName.replace(rbackslash,"").toLowerCase();return function(elem){return elem.nodeName&&elem.nodeName.toLowerCase()===nodeName}},CLASS:function(className){var pattern=classCache[expando][className+" "];return pattern||(pattern=new RegExp("(^|"+whitespace+")"+className+"("+whitespace+"|$)"))&&classCache(className,function(elem){return pattern.test(elem.className||(typeof elem.getAttribute!==strundefined&&elem.getAttribute("class"))||"")})},ATTR:function(name,operator,check){return function(elem,context){var result=Sizzle.attr(elem,name);if(result==null){return operator==="!="}if(!operator){return true}result+="";return operator==="="?result===check:operator==="!="?result!==check:operator==="^="?check&&result.indexOf(check)===0:operator==="*="?check&&result.indexOf(check)>-1:operator==="$="?check&&result.substr(result.length-check.length)===check:operator==="~="?(" "+result+" ").indexOf(check)>-1:operator==="|="?result===check||result.substr(0,check.length+1)===check+"-":false}},CHILD:function(type,argument,first,last){if(type==="nth"){return function(elem){var node,diff,parent=elem.parentNode;if(first===1&&last===0){return true}if(parent){diff=0;for(node=parent.firstChild;node;node=node.nextSibling){if(node.nodeType===1){diff++;if(elem===node){break}}}}diff-=last;return diff===first||(diff%first===0&&diff/first>=0)}}return function(elem){var node=elem;switch(type){case"only":case"first":while((node=node.previousSibling)){if(node.nodeType===1){return false}}if(type==="first"){return true}node=elem;case"last":while((node=node.nextSibling)){if(node.nodeType===1){return false}}return true}}},PSEUDO:function(pseudo,argument){var args,fn=Expr.pseudos[pseudo]||Expr.setFilters[pseudo.toLowerCase()]||Sizzle.error("unsupported pseudo: "+pseudo);if(fn[expando]){return fn(argument)}if(fn.length>1){args=[pseudo,pseudo,"",argument];return Expr.setFilters.hasOwnProperty(pseudo.toLowerCase())?markFunction(function(seed,matches){var idx,matched=fn(seed,argument),i=matched.length;while(i--){idx=indexOf.call(seed,matched[i]);seed[idx]=!(matches[idx]=matched[i])}}):function(elem){return fn(elem,0,args)}}return fn}},pseudos:{not:markFunction(function(selector){var input=[],results=[],matcher=compile(selector.replace(rtrim,"$1"));return matcher[expando]?markFunction(function(seed,matches,context,xml){var elem,unmatched=matcher(seed,null,xml,[]),i=seed.length;while(i--){if((elem=unmatched[i])){seed[i]=!(matches[i]=elem)}}}):function(elem,context,xml){input[0]=elem;matcher(input,null,xml,results);return !results.pop()}}),has:markFunction(function(selector){return function(elem){return Sizzle(selector,elem).length>0}}),contains:markFunction(function(text){return function(elem){return(elem.textContent||elem.innerText||getText(elem)).indexOf(text)>-1}}),enabled:function(elem){return elem.disabled===false},disabled:function(elem){return elem.disabled===true},checked:function(elem){var nodeName=elem.nodeName.toLowerCase();return(nodeName==="input"&&!!elem.checked)||(nodeName==="option"&&!!elem.selected)},selected:function(elem){if(elem.parentNode){elem.parentNode.selectedIndex}return elem.selected===true},parent:function(elem){return !Expr.pseudos.empty(elem)},empty:function(elem){var nodeType;elem=elem.firstChild;while(elem){if(elem.nodeName>"@"||(nodeType=elem.nodeType)===3||nodeType===4){return false}elem=elem.nextSibling}return true},header:function(elem){return rheader.test(elem.nodeName)},text:function(elem){var type,attr;return elem.nodeName.toLowerCase()==="input"&&(type=elem.type)==="text"&&((attr=elem.getAttribute("type"))==null||attr.toLowerCase()===type)},radio:createInputPseudo("radio"),checkbox:createInputPseudo("checkbox"),file:createInputPseudo("file"),password:createInputPseudo("password"),image:createInputPseudo("image"),submit:createButtonPseudo("submit"),reset:createButtonPseudo("reset"),button:function(elem){var name=elem.nodeName.toLowerCase();return name==="input"&&elem.type==="button"||name==="button"},input:function(elem){return rinputs.test(elem.nodeName)},focus:function(elem){var doc=elem.ownerDocument;return elem===doc.activeElement&&(!doc.hasFocus||doc.hasFocus())&&!!(elem.type||elem.href||~elem.tabIndex)},active:function(elem){return elem===elem.ownerDocument.activeElement},first:createPositionalPseudo(function(){return[0]}),last:createPositionalPseudo(function(matchIndexes,length){return[length-1]}),eq:createPositionalPseudo(function(matchIndexes,length,argument){return[argument<0?argument+length:argument]}),even:createPositionalPseudo(function(matchIndexes,length){for(var i=0;i<length;i+=2){matchIndexes.push(i)}return matchIndexes}),odd:createPositionalPseudo(function(matchIndexes,length){for(var i=1;i<length;i+=2){matchIndexes.push(i)}return matchIndexes}),lt:createPositionalPseudo(function(matchIndexes,length,argument){for(var i=argument<0?argument+length:argument;--i>=0;){matchIndexes.push(i)}return matchIndexes}),gt:createPositionalPseudo(function(matchIndexes,length,argument){for(var i=argument<0?argument+length:argument;++i<length;){matchIndexes.push(i)}return matchIndexes})}};function siblingCheck(a,b,ret){if(a===b){return ret}var cur=a.nextSibling;while(cur){if(cur===b){return -1}cur=cur.nextSibling}return 1}sortOrder=docElem.compareDocumentPosition?function(a,b){if(a===b){hasDuplicate=true;return 0}return(!a.compareDocumentPosition||!b.compareDocumentPosition?a.compareDocumentPosition:a.compareDocumentPosition(b)&4)?-1:1}:function(a,b){if(a===b){hasDuplicate=true;return 0}else{if(a.sourceIndex&&b.sourceIndex){return a.sourceIndex-b.sourceIndex}}var al,bl,ap=[],bp=[],aup=a.parentNode,bup=b.parentNode,cur=aup;if(aup===bup){return siblingCheck(a,b)}else{if(!aup){return -1}else{if(!bup){return 1}}}while(cur){ap.unshift(cur);cur=cur.parentNode}cur=bup;while(cur){bp.unshift(cur);cur=cur.parentNode}al=ap.length;bl=bp.length;for(var i=0;i<al&&i<bl;i++){if(ap[i]!==bp[i]){return siblingCheck(ap[i],bp[i])}}return i===al?siblingCheck(a,bp[i],-1):siblingCheck(ap[i],b,1)};[0,0].sort(sortOrder);baseHasDuplicate=!hasDuplicate;Sizzle.uniqueSort=function(results){var elem,duplicates=[],i=1,j=0;hasDuplicate=baseHasDuplicate;results.sort(sortOrder);if(hasDuplicate){for(;(elem=results[i]);i++){if(elem===results[i-1]){j=duplicates.push(i)}}while(j--){results.splice(duplicates[j],1)}}return results};Sizzle.error=function(msg){throw new Error("Syntax error, unrecognized expression: "+msg)};function tokenize(selector,parseOnly){var matched,match,tokens,type,soFar,groups,preFilters,cached=tokenCache[expando][selector+" "];if(cached){return parseOnly?0:cached.slice(0)}soFar=selector;groups=[];preFilters=Expr.preFilter;while(soFar){if(!matched||(match=rcomma.exec(soFar))){if(match){soFar=soFar.slice(match[0].length)||soFar}groups.push(tokens=[])}matched=false;if((match=rcombinators.exec(soFar))){tokens.push(matched=new Token(match.shift()));soFar=soFar.slice(matched.length);matched.type=match[0].replace(rtrim," ")}for(type in Expr.filter){if((match=matchExpr[type].exec(soFar))&&(!preFilters[type]||(match=preFilters[type](match)))){tokens.push(matched=new Token(match.shift()));soFar=soFar.slice(matched.length);matched.type=type;matched.matches=match}}if(!matched){break}}return parseOnly?soFar.length:soFar?Sizzle.error(selector):tokenCache(selector,groups).slice(0)}function addCombinator(matcher,combinator,base){var dir=combinator.dir,checkNonElements=base&&combinator.dir==="parentNode",doneName=done++;return combinator.first?function(elem,context,xml){while((elem=elem[dir])){if(checkNonElements||elem.nodeType===1){return matcher(elem,context,xml)}}}:function(elem,context,xml){if(!xml){var cache,dirkey=dirruns+" "+doneName+" ",cachedkey=dirkey+cachedruns;while((elem=elem[dir])){if(checkNonElements||elem.nodeType===1){if((cache=elem[expando])===cachedkey){return elem.sizset}else{if(typeof cache==="string"&&cache.indexOf(dirkey)===0){if(elem.sizset){return elem}}else{elem[expando]=cachedkey;if(matcher(elem,context,xml)){elem.sizset=true;return elem}elem.sizset=false}}}}}else{while((elem=elem[dir])){if(checkNonElements||elem.nodeType===1){if(matcher(elem,context,xml)){return elem}}}}}}function elementMatcher(matchers){return matchers.length>1?function(elem,context,xml){var i=matchers.length;while(i--){if(!matchers[i](elem,context,xml)){return false}}return true}:matchers[0]}function condense(unmatched,map,filter,context,xml){var elem,newUnmatched=[],i=0,len=unmatched.length,mapped=map!=null;for(;i<len;i++){if((elem=unmatched[i])){if(!filter||filter(elem,context,xml)){newUnmatched.push(elem);if(mapped){map.push(i)}}}}return newUnmatched}function setMatcher(preFilter,selector,matcher,postFilter,postFinder,postSelector){if(postFilter&&!postFilter[expando]){postFilter=setMatcher(postFilter)}if(postFinder&&!postFinder[expando]){postFinder=setMatcher(postFinder,postSelector)}return markFunction(function(seed,results,context,xml){var temp,i,elem,preMap=[],postMap=[],preexisting=results.length,elems=seed||multipleContexts(selector||"*",context.nodeType?[context]:context,[]),matcherIn=preFilter&&(seed||!selector)?condense(elems,preMap,preFilter,context,xml):elems,matcherOut=matcher?postFinder||(seed?preFilter:preexisting||postFilter)?[]:results:matcherIn;if(matcher){matcher(matcherIn,matcherOut,context,xml)}if(postFilter){temp=condense(matcherOut,postMap);postFilter(temp,[],context,xml);i=temp.length;while(i--){if((elem=temp[i])){matcherOut[postMap[i]]=!(matcherIn[postMap[i]]=elem)}}}if(seed){if(postFinder||preFilter){if(postFinder){temp=[];i=matcherOut.length;while(i--){if((elem=matcherOut[i])){temp.push((matcherIn[i]=elem))}}postFinder(null,(matcherOut=[]),temp,xml)}i=matcherOut.length;while(i--){if((elem=matcherOut[i])&&(temp=postFinder?indexOf.call(seed,elem):preMap[i])>-1){seed[temp]=!(results[temp]=elem)}}}}else{matcherOut=condense(matcherOut===results?matcherOut.splice(preexisting,matcherOut.length):matcherOut);if(postFinder){postFinder(null,results,matcherOut,xml)}else{push.apply(results,matcherOut)}}})}function matcherFromTokens(tokens){var checkContext,matcher,j,len=tokens.length,leadingRelative=Expr.relative[tokens[0].type],implicitRelative=leadingRelative||Expr.relative[" "],i=leadingRelative?1:0,matchContext=addCombinator(function(elem){return elem===checkContext},implicitRelative,true),matchAnyContext=addCombinator(function(elem){return indexOf.call(checkContext,elem)>-1},implicitRelative,true),matchers=[function(elem,context,xml){return(!leadingRelative&&(xml||context!==outermostContext))||((checkContext=context).nodeType?matchContext(elem,context,xml):matchAnyContext(elem,context,xml))}];for(;i<len;i++){if((matcher=Expr.relative[tokens[i].type])){matchers=[addCombinator(elementMatcher(matchers),matcher)]}else{matcher=Expr.filter[tokens[i].type].apply(null,tokens[i].matches);if(matcher[expando]){j=++i;for(;j<len;j++){if(Expr.relative[tokens[j].type]){break}}return setMatcher(i>1&&elementMatcher(matchers),i>1&&tokens.slice(0,i-1).join("").replace(rtrim,"$1"),matcher,i<j&&matcherFromTokens(tokens.slice(i,j)),j<len&&matcherFromTokens((tokens=tokens.slice(j))),j<len&&tokens.join(""))}matchers.push(matcher)}}return elementMatcher(matchers)}function matcherFromGroupMatchers(elementMatchers,setMatchers){var bySet=setMatchers.length>0,byElement=elementMatchers.length>0,superMatcher=function(seed,context,xml,results,expandContext){var elem,j,matcher,setMatched=[],matchedCount=0,i="0",unmatched=seed&&[],outermost=expandContext!=null,contextBackup=outermostContext,elems=seed||byElement&&Expr.find.TAG("*",expandContext&&context.parentNode||context),dirrunsUnique=(dirruns+=contextBackup==null?1:Math.E);if(outermost){outermostContext=context!==document&&context;cachedruns=superMatcher.el}for(;(elem=elems[i])!=null;i++){if(byElement&&elem){for(j=0;(matcher=elementMatchers[j]);j++){if(matcher(elem,context,xml)){results.push(elem);break}}if(outermost){dirruns=dirrunsUnique;cachedruns=++superMatcher.el}}if(bySet){if((elem=!matcher&&elem)){matchedCount--}if(seed){unmatched.push(elem)}}}matchedCount+=i;if(bySet&&i!==matchedCount){for(j=0;(matcher=setMatchers[j]);j++){matcher(unmatched,setMatched,context,xml)}if(seed){if(matchedCount>0){while(i--){if(!(unmatched[i]||setMatched[i])){setMatched[i]=pop.call(results)}}}setMatched=condense(setMatched)}push.apply(results,setMatched);if(outermost&&!seed&&setMatched.length>0&&(matchedCount+setMatchers.length)>1){Sizzle.uniqueSort(results)}}if(outermost){dirruns=dirrunsUnique;outermostContext=contextBackup}return unmatched};superMatcher.el=0;return bySet?markFunction(superMatcher):superMatcher}compile=Sizzle.compile=function(selector,group){var i,setMatchers=[],elementMatchers=[],cached=compilerCache[expando][selector+" "];if(!cached){if(!group){group=tokenize(selector)}i=group.length;while(i--){cached=matcherFromTokens(group[i]);if(cached[expando]){setMatchers.push(cached)}else{elementMatchers.push(cached)}}cached=compilerCache(selector,matcherFromGroupMatchers(elementMatchers,setMatchers))}return cached};function multipleContexts(selector,contexts,results){var i=0,len=contexts.length;for(;i<len;i++){Sizzle(selector,contexts[i],results)}return results}function select(selector,context,results,seed,xml){var i,tokens,token,type,find,match=tokenize(selector),j=match.length;if(!seed){if(match.length===1){tokens=match[0]=match[0].slice(0);if(tokens.length>2&&(token=tokens[0]).type==="ID"&&context.nodeType===9&&!xml&&Expr.relative[tokens[1].type]){context=Expr.find.ID(token.matches[0].replace(rbackslash,""),context,xml)[0];if(!context){return results}selector=selector.slice(tokens.shift().length)}for(i=matchExpr.POS.test(selector)?-1:tokens.length-1;i>=0;i--){token=tokens[i];if(Expr.relative[(type=token.type)]){break}if((find=Expr.find[type])){if((seed=find(token.matches[0].replace(rbackslash,""),rsibling.test(tokens[0].type)&&context.parentNode||context,xml))){tokens.splice(i,1);selector=seed.length&&tokens.join("");if(!selector){push.apply(results,slice.call(seed,0));return results}break}}}}}compile(selector,match)(seed,context,xml,results,rsibling.test(selector));return results}if(document.querySelectorAll){(function(){var disconnectedMatch,oldSelect=select,rescape=/'|\\/g,rattributeQuotes=/\=[\x20\t\r\n\f]*([^'"\]]*)[\x20\t\r\n\f]*\]/g,rbuggyQSA=[":focus"],rbuggyMatches=[":active"],matches=docElem.matchesSelector||docElem.mozMatchesSelector||docElem.webkitMatchesSelector||docElem.oMatchesSelector||docElem.msMatchesSelector;assert(function(div){div.innerHTML="<select><option selected=''></option></select>";if(!div.querySelectorAll("[selected]").length){rbuggyQSA.push("\\["+whitespace+"*(?:checked|disabled|ismap|multiple|readonly|selected|value)")}if(!div.querySelectorAll(":checked").length){rbuggyQSA.push(":checked")}});assert(function(div){div.innerHTML="<p test=''></p>";if(div.querySelectorAll("[test^='']").length){rbuggyQSA.push("[*^$]="+whitespace+"*(?:\"\"|'')")}div.innerHTML="<input type='hidden'/>";if(!div.querySelectorAll(":enabled").length){rbuggyQSA.push(":enabled",":disabled")}});rbuggyQSA=new RegExp(rbuggyQSA.join("|"));select=function(selector,context,results,seed,xml){if(!seed&&!xml&&!rbuggyQSA.test(selector)){var groups,i,old=true,nid=expando,newContext=context,newSelector=context.nodeType===9&&selector;if(context.nodeType===1&&context.nodeName.toLowerCase()!=="object"){groups=tokenize(selector);if((old=context.getAttribute("id"))){nid=old.replace(rescape,"\\$&")}else{context.setAttribute("id",nid)}nid="[id='"+nid+"'] ";i=groups.length;while(i--){groups[i]=nid+groups[i].join("")}newContext=rsibling.test(selector)&&context.parentNode||context;newSelector=groups.join(",")}if(newSelector){try{push.apply(results,slice.call(newContext.querySelectorAll(newSelector),0));return results}catch(qsaError){}finally{if(!old){context.removeAttribute("id")}}}}return oldSelect(selector,context,results,seed,xml)};if(matches){assert(function(div){disconnectedMatch=matches.call(div,"div");try{matches.call(div,"[test!='']:sizzle");rbuggyMatches.push("!=",pseudos)}catch(e){}});rbuggyMatches=new RegExp(rbuggyMatches.join("|"));Sizzle.matchesSelector=function(elem,expr){expr=expr.replace(rattributeQuotes,"='$1']");if(!isXML(elem)&&!rbuggyMatches.test(expr)&&!rbuggyQSA.test(expr)){try{var ret=matches.call(elem,expr);if(ret||disconnectedMatch||elem.document&&elem.document.nodeType!==11){return ret}}catch(e){}}return Sizzle(expr,null,null,[elem]).length>0}}})()}Expr.pseudos.nth=Expr.pseudos.eq;function setFilters(){}Expr.filters=setFilters.prototype=Expr.pseudos;Expr.setFilters=new setFilters();Sizzle.attr=jQuery.attr;jQuery.find=Sizzle;jQuery.expr=Sizzle.selectors;jQuery.expr[":"]=jQuery.expr.pseudos;jQuery.unique=Sizzle.uniqueSort;jQuery.text=Sizzle.getText;jQuery.isXMLDoc=Sizzle.isXML;jQuery.contains=Sizzle.contains})(window);var runtil=/Until$/,rparentsprev=/^(?:parents|prev(?:Until|All))/,isSimple=/^.[^:#\[\.,]*$/,rneedsContext=jQuery.expr.match.needsContext,guaranteedUnique={children:true,contents:true,next:true,prev:true};jQuery.fn.extend({find:function(selector){var i,l,length,n,r,ret,self=this;if(typeof selector!=="string"){return jQuery(selector).filter(function(){for(i=0,l=self.length;i<l;i++){if(jQuery.contains(self[i],this)){return true}}})}ret=this.pushStack("","find",selector);for(i=0,l=this.length;i<l;i++){length=ret.length;jQuery.find(selector,this[i],ret);if(i>0){for(n=length;n<ret.length;n++){for(r=0;r<length;r++){if(ret[r]===ret[n]){ret.splice(n--,1);break}}}}}return ret},has:function(target){var i,targets=jQuery(target,this),len=targets.length;return this.filter(function(){for(i=0;i<len;i++){if(jQuery.contains(this,targets[i])){return true}}})},not:function(selector){return this.pushStack(winnow(this,selector,false),"not",selector)},filter:function(selector){return this.pushStack(winnow(this,selector,true),"filter",selector)},is:function(selector){return !!selector&&(typeof selector==="string"?rneedsContext.test(selector)?jQuery(selector,this.context).index(this[0])>=0:jQuery.filter(selector,this).length>0:this.filter(selector).length>0)},closest:function(selectors,context){var cur,i=0,l=this.length,ret=[],pos=rneedsContext.test(selectors)||typeof selectors!=="string"?jQuery(selectors,context||this.context):0;for(;i<l;i++){cur=this[i];while(cur&&cur.ownerDocument&&cur!==context&&cur.nodeType!==11){if(pos?pos.index(cur)>-1:jQuery.find.matchesSelector(cur,selectors)){ret.push(cur);break}cur=cur.parentNode}}ret=ret.length>1?jQuery.unique(ret):ret;return this.pushStack(ret,"closest",selectors)},index:function(elem){if(!elem){return(this[0]&&this[0].parentNode)?this.prevAll().length:-1}if(typeof elem==="string"){return jQuery.inArray(this[0],jQuery(elem))}return jQuery.inArray(elem.jquery?elem[0]:elem,this)},add:function(selector,context){var set=typeof selector==="string"?jQuery(selector,context):jQuery.makeArray(selector&&selector.nodeType?[selector]:selector),all=jQuery.merge(this.get(),set);return this.pushStack(isDisconnected(set[0])||isDisconnected(all[0])?all:jQuery.unique(all))},addBack:function(selector){return this.add(selector==null?this.prevObject:this.prevObject.filter(selector))}});jQuery.fn.andSelf=jQuery.fn.addBack;function isDisconnected(node){return !node||!node.parentNode||node.parentNode.nodeType===11}function sibling(cur,dir){do{cur=cur[dir]}while(cur&&cur.nodeType!==1);return cur}jQuery.each({parent:function(elem){var parent=elem.parentNode;return parent&&parent.nodeType!==11?parent:null},parents:function(elem){return jQuery.dir(elem,"parentNode")},parentsUntil:function(elem,i,until){return jQuery.dir(elem,"parentNode",until)},next:function(elem){return sibling(elem,"nextSibling")},prev:function(elem){return sibling(elem,"previousSibling")},nextAll:function(elem){return jQuery.dir(elem,"nextSibling")},prevAll:function(elem){return jQuery.dir(elem,"previousSibling")},nextUntil:function(elem,i,until){return jQuery.dir(elem,"nextSibling",until)},prevUntil:function(elem,i,until){return jQuery.dir(elem,"previousSibling",until)},siblings:function(elem){return jQuery.sibling((elem.parentNode||{}).firstChild,elem)},children:function(elem){return jQuery.sibling(elem.firstChild)},contents:function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.merge([],elem.childNodes)}},function(name,fn){jQuery.fn[name]=function(until,selector){var ret=jQuery.map(this,fn,until);if(!runtil.test(name)){selector=until}if(selector&&typeof selector==="string"){ret=jQuery.filter(selector,ret)}ret=this.length>1&&!guaranteedUnique[name]?jQuery.unique(ret):ret;if(this.length>1&&rparentsprev.test(name)){ret=ret.reverse()}return this.pushStack(ret,name,core_slice.call(arguments).join(","))}});jQuery.extend({filter:function(expr,elems,not){if(not){expr=":not("+expr+")"}return elems.length===1?jQuery.find.matchesSelector(elems[0],expr)?[elems[0]]:[]:jQuery.find.matches(expr,elems)},dir:function(elem,dir,until){var matched=[],cur=elem[dir];while(cur&&cur.nodeType!==9&&(until===undefined||cur.nodeType!==1||!jQuery(cur).is(until))){if(cur.nodeType===1){matched.push(cur)}cur=cur[dir]}return matched},sibling:function(n,elem){var r=[];for(;n;n=n.nextSibling){if(n.nodeType===1&&n!==elem){r.push(n)}}return r}});function winnow(elements,qualifier,keep){qualifier=qualifier||0;if(jQuery.isFunction(qualifier)){return jQuery.grep(elements,function(elem,i){var retVal=!!qualifier.call(elem,i,elem);return retVal===keep})}else{if(qualifier.nodeType){return jQuery.grep(elements,function(elem,i){return(elem===qualifier)===keep})}else{if(typeof qualifier==="string"){var filtered=jQuery.grep(elements,function(elem){return elem.nodeType===1});if(isSimple.test(qualifier)){return jQuery.filter(qualifier,filtered,!keep)}else{qualifier=jQuery.filter(qualifier,filtered)}}}}return jQuery.grep(elements,function(elem,i){return(jQuery.inArray(elem,qualifier)>=0)===keep})}function createSafeFragment(document){var list=nodeNames.split("|"),safeFrag=document.createDocumentFragment();if(safeFrag.createElement){while(list.length){safeFrag.createElement(list.pop())}}return safeFrag}var nodeNames="abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",rinlinejQuery=/ jQuery\d+="(?:null|\d+)"/g,rleadingWhitespace=/^\s+/,rxhtmlTag=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,rtagName=/<([\w:]+)/,rtbody=/<tbody/i,rhtml=/<|&#?\w+;/,rnoInnerhtml=/<(?:script|style|link)/i,rnocache=/<(?:script|object|embed|option|style)/i,rnoshimcache=new RegExp("<(?:"+nodeNames+")[\\s/>]","i"),rcheckableType=/^(?:checkbox|radio)$/,rchecked=/checked\s*(?:[^=]|=\s*.checked.)/i,rscriptType=/\/(java|ecma)script/i,rcleanScript=/^\s*<!(?:\[CDATA\[|\-\-)|[\]\-]{2}>\s*$/g,wrapMap={option:[1,"<select multiple='multiple'>","</select>"],legend:[1,"<fieldset>","</fieldset>"],thead:[1,"<table>","</table>"],tr:[2,"<table><tbody>","</tbody></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],col:[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"],area:[1,"<map>","</map>"],_default:[0,"",""]},safeFragment=createSafeFragment(document),fragmentDiv=safeFragment.appendChild(document.createElement("div"));wrapMap.optgroup=wrapMap.option;wrapMap.tbody=wrapMap.tfoot=wrapMap.colgroup=wrapMap.caption=wrapMap.thead;wrapMap.th=wrapMap.td;if(!jQuery.support.htmlSerialize){wrapMap._default=[1,"X<div>","</div>"]}jQuery.fn.extend({text:function(value){return jQuery.access(this,function(value){return value===undefined?jQuery.text(this):this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(value))},null,value,arguments.length)},wrapAll:function(html){if(jQuery.isFunction(html)){return this.each(function(i){jQuery(this).wrapAll(html.call(this,i))})}if(this[0]){var wrap=jQuery(html,this[0].ownerDocument).eq(0).clone(true);if(this[0].parentNode){wrap.insertBefore(this[0])}wrap.map(function(){var elem=this;while(elem.firstChild&&elem.firstChild.nodeType===1){elem=elem.firstChild}return elem}).append(this)}return this},wrapInner:function(html){if(jQuery.isFunction(html)){return this.each(function(i){jQuery(this).wrapInner(html.call(this,i))})}return this.each(function(){var self=jQuery(this),contents=self.contents();if(contents.length){contents.wrapAll(html)}else{self.append(html)}})},wrap:function(html){var isFunction=jQuery.isFunction(html);return this.each(function(i){jQuery(this).wrapAll(isFunction?html.call(this,i):html)})},unwrap:function(){return this.parent().each(function(){if(!jQuery.nodeName(this,"body")){jQuery(this).replaceWith(this.childNodes)}}).end()},append:function(){return this.domManip(arguments,true,function(elem){if(this.nodeType===1||this.nodeType===11){this.appendChild(elem)}})},prepend:function(){return this.domManip(arguments,true,function(elem){if(this.nodeType===1||this.nodeType===11){this.insertBefore(elem,this.firstChild)}})},before:function(){if(!isDisconnected(this[0])){return this.domManip(arguments,false,function(elem){this.parentNode.insertBefore(elem,this)})}if(arguments.length){var set=jQuery.clean(arguments);return this.pushStack(jQuery.merge(set,this),"before",this.selector)}},after:function(){if(!isDisconnected(this[0])){return this.domManip(arguments,false,function(elem){this.parentNode.insertBefore(elem,this.nextSibling)})}if(arguments.length){var set=jQuery.clean(arguments);return this.pushStack(jQuery.merge(this,set),"after",this.selector)}},remove:function(selector,keepData){var elem,i=0;for(;(elem=this[i])!=null;i++){if(!selector||jQuery.filter(selector,[elem]).length){if(!keepData&&elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"));jQuery.cleanData([elem])}if(elem.parentNode){elem.parentNode.removeChild(elem)}}}return this},empty:function(){var elem,i=0;for(;(elem=this[i])!=null;i++){if(elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"))}while(elem.firstChild){elem.removeChild(elem.firstChild)}}return this},clone:function(dataAndEvents,deepDataAndEvents){dataAndEvents=dataAndEvents==null?false:dataAndEvents;deepDataAndEvents=deepDataAndEvents==null?dataAndEvents:deepDataAndEvents;return this.map(function(){return jQuery.clone(this,dataAndEvents,deepDataAndEvents)})},html:function(value){return jQuery.access(this,function(value){var elem=this[0]||{},i=0,l=this.length;if(value===undefined){return elem.nodeType===1?elem.innerHTML.replace(rinlinejQuery,""):undefined}if(typeof value==="string"&&!rnoInnerhtml.test(value)&&(jQuery.support.htmlSerialize||!rnoshimcache.test(value))&&(jQuery.support.leadingWhitespace||!rleadingWhitespace.test(value))&&!wrapMap[(rtagName.exec(value)||["",""])[1].toLowerCase()]){value=value.replace(rxhtmlTag,"<$1></$2>");try{for(;i<l;i++){elem=this[i]||{};if(elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"));elem.innerHTML=value}}elem=0}catch(e){}}if(elem){this.empty().append(value)}},null,value,arguments.length)},replaceWith:function(value){if(!isDisconnected(this[0])){if(jQuery.isFunction(value)){return this.each(function(i){var self=jQuery(this),old=self.html();self.replaceWith(value.call(this,i,old))})}if(typeof value!=="string"){value=jQuery(value).detach()}return this.each(function(){var next=this.nextSibling,parent=this.parentNode;jQuery(this).remove();if(next){jQuery(next).before(value)}else{jQuery(parent).append(value)}})}return this.length?this.pushStack(jQuery(jQuery.isFunction(value)?value():value),"replaceWith",value):this},detach:function(selector){return this.remove(selector,true)},domManip:function(args,table,callback){args=[].concat.apply([],args);var results,first,fragment,iNoClone,i=0,value=args[0],scripts=[],l=this.length;if(!jQuery.support.checkClone&&l>1&&typeof value==="string"&&rchecked.test(value)){return this.each(function(){jQuery(this).domManip(args,table,callback)})}if(jQuery.isFunction(value)){return this.each(function(i){var self=jQuery(this);args[0]=value.call(this,i,table?self.html():undefined);self.domManip(args,table,callback)})}if(this[0]){results=jQuery.buildFragment(args,this,scripts);fragment=results.fragment;first=fragment.firstChild;if(fragment.childNodes.length===1){fragment=first}if(first){table=table&&jQuery.nodeName(first,"tr");for(iNoClone=results.cacheable||l-1;i<l;i++){callback.call(table&&jQuery.nodeName(this[i],"table")?findOrAppend(this[i],"tbody"):this[i],i===iNoClone?fragment:jQuery.clone(fragment,true,true))}}fragment=first=null;if(scripts.length){jQuery.each(scripts,function(i,elem){if(elem.src){if(jQuery.ajax){jQuery.ajax({url:elem.src,type:"GET",dataType:"script",async:false,global:false,"throws":true})}else{jQuery.error("no ajax")}}else{jQuery.globalEval((elem.text||elem.textContent||elem.innerHTML||"").replace(rcleanScript,""))}if(elem.parentNode){elem.parentNode.removeChild(elem)}})}}return this}});function findOrAppend(elem,tag){return elem.getElementsByTagName(tag)[0]||elem.appendChild(elem.ownerDocument.createElement(tag))}function cloneCopyEvent(src,dest){if(dest.nodeType!==1||!jQuery.hasData(src)){return }var type,i,l,oldData=jQuery._data(src),curData=jQuery._data(dest,oldData),events=oldData.events;if(events){delete curData.handle;curData.events={};for(type in events){for(i=0,l=events[type].length;i<l;i++){jQuery.event.add(dest,type,events[type][i])}}}if(curData.data){curData.data=jQuery.extend({},curData.data)}}function cloneFixAttributes(src,dest){var nodeName;if(dest.nodeType!==1){return }try{if(dest.clearAttributes){dest.clearAttributes()}if(dest.mergeAttributes){dest.mergeAttributes(src)}}catch(err){}nodeName=dest.nodeName.toLowerCase();if(nodeName==="object"){if(dest.parentNode){dest.outerHTML=src.outerHTML}if(jQuery.support.html5Clone&&(src.innerHTML&&!jQuery.trim(dest.innerHTML))){dest.innerHTML=src.innerHTML}}else{if(nodeName==="input"&&rcheckableType.test(src.type)){dest.defaultChecked=dest.checked=src.checked;if(dest.value!==src.value){dest.value=src.value}}else{if(nodeName==="option"){dest.selected=src.defaultSelected}else{if(nodeName==="input"||nodeName==="textarea"){dest.defaultValue=src.defaultValue}else{if(nodeName==="script"&&dest.text!==src.text){dest.text=src.text}}}}}dest.removeAttribute(jQuery.expando)}jQuery.buildFragment=function(args,context,scripts){var fragment,cacheable,cachehit,first=args[0];context=context||document;context=!context.nodeType&&context[0]||context;context=context.ownerDocument||context;if(args.length===1&&typeof first==="string"&&first.length<512&&context===document&&first.charAt(0)==="<"&&!rnocache.test(first)&&(jQuery.support.checkClone||!rchecked.test(first))&&(jQuery.support.html5Clone||!rnoshimcache.test(first))){cacheable=true;fragment=jQuery.fragments[first];cachehit=fragment!==undefined}if(!fragment){fragment=context.createDocumentFragment();jQuery.clean(args,context,fragment,scripts);if(cacheable){jQuery.fragments[first]=cachehit&&fragment}}return{fragment:fragment,cacheable:cacheable}};jQuery.fragments={};jQuery.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,original){jQuery.fn[name]=function(selector){var elems,i=0,ret=[],insert=jQuery(selector),l=insert.length,parent=this.length===1&&this[0].parentNode;if((parent==null||parent&&parent.nodeType===11&&parent.childNodes.length===1)&&l===1){insert[original](this[0]);return this}else{for(;i<l;i++){elems=(i>0?this.clone(true):this).get();jQuery(insert[i])[original](elems);ret=ret.concat(elems)}return this.pushStack(ret,name,insert.selector)}}});function getAll(elem){if(typeof elem.getElementsByTagName!=="undefined"){return elem.getElementsByTagName("*")}else{if(typeof elem.querySelectorAll!=="undefined"){return elem.querySelectorAll("*")}else{return[]}}}function fixDefaultChecked(elem){if(rcheckableType.test(elem.type)){elem.defaultChecked=elem.checked}}jQuery.extend({clone:function(elem,dataAndEvents,deepDataAndEvents){var srcElements,destElements,i,clone;if(jQuery.support.html5Clone||jQuery.isXMLDoc(elem)||!rnoshimcache.test("<"+elem.nodeName+">")){clone=elem.cloneNode(true)}else{fragmentDiv.innerHTML=elem.outerHTML;fragmentDiv.removeChild(clone=fragmentDiv.firstChild)}if((!jQuery.support.noCloneEvent||!jQuery.support.noCloneChecked)&&(elem.nodeType===1||elem.nodeType===11)&&!jQuery.isXMLDoc(elem)){cloneFixAttributes(elem,clone);srcElements=getAll(elem);destElements=getAll(clone);for(i=0;srcElements[i];++i){if(destElements[i]){cloneFixAttributes(srcElements[i],destElements[i])}}}if(dataAndEvents){cloneCopyEvent(elem,clone);if(deepDataAndEvents){srcElements=getAll(elem);destElements=getAll(clone);for(i=0;srcElements[i];++i){cloneCopyEvent(srcElements[i],destElements[i])}}}srcElements=destElements=null;return clone},clean:function(elems,context,fragment,scripts){var i,j,elem,tag,wrap,depth,div,hasBody,tbody,len,handleScript,jsTags,safe=context===document&&safeFragment,ret=[];if(!context||typeof context.createDocumentFragment==="undefined"){context=document}for(i=0;(elem=elems[i])!=null;i++){if(typeof elem==="number"){elem+=""}if(!elem){continue}if(typeof elem==="string"){if(!rhtml.test(elem)){elem=context.createTextNode(elem)}else{safe=safe||createSafeFragment(context);div=context.createElement("div");safe.appendChild(div);elem=elem.replace(rxhtmlTag,"<$1></$2>");tag=(rtagName.exec(elem)||["",""])[1].toLowerCase();wrap=wrapMap[tag]||wrapMap._default;depth=wrap[0];div.innerHTML=wrap[1]+elem+wrap[2];while(depth--){div=div.lastChild}if(!jQuery.support.tbody){hasBody=rtbody.test(elem);tbody=tag==="table"&&!hasBody?div.firstChild&&div.firstChild.childNodes:wrap[1]==="<table>"&&!hasBody?div.childNodes:[];for(j=tbody.length-1;j>=0;--j){if(jQuery.nodeName(tbody[j],"tbody")&&!tbody[j].childNodes.length){tbody[j].parentNode.removeChild(tbody[j])}}}if(!jQuery.support.leadingWhitespace&&rleadingWhitespace.test(elem)){div.insertBefore(context.createTextNode(rleadingWhitespace.exec(elem)[0]),div.firstChild)}elem=div.childNodes;div.parentNode.removeChild(div)}}if(elem.nodeType){ret.push(elem)}else{jQuery.merge(ret,elem)}}if(div){elem=div=safe=null}if(!jQuery.support.appendChecked){for(i=0;(elem=ret[i])!=null;i++){if(jQuery.nodeName(elem,"input")){fixDefaultChecked(elem)}else{if(typeof elem.getElementsByTagName!=="undefined"){jQuery.grep(elem.getElementsByTagName("input"),fixDefaultChecked)}}}}if(fragment){handleScript=function(elem){if(!elem.type||rscriptType.test(elem.type)){return scripts?scripts.push(elem.parentNode?elem.parentNode.removeChild(elem):elem):fragment.appendChild(elem)}};for(i=0;(elem=ret[i])!=null;i++){if(!(jQuery.nodeName(elem,"script")&&handleScript(elem))){fragment.appendChild(elem);if(typeof elem.getElementsByTagName!=="undefined"){jsTags=jQuery.grep(jQuery.merge([],elem.getElementsByTagName("script")),handleScript);ret.splice.apply(ret,[i+1,0].concat(jsTags));i+=jsTags.length}}}}return ret},cleanData:function(elems,acceptData){var data,id,elem,type,i=0,internalKey=jQuery.expando,cache=jQuery.cache,deleteExpando=jQuery.support.deleteExpando,special=jQuery.event.special;for(;(elem=elems[i])!=null;i++){if(acceptData||jQuery.acceptData(elem)){id=elem[internalKey];data=id&&cache[id];if(data){if(data.events){for(type in data.events){if(special[type]){jQuery.event.remove(elem,type)}else{jQuery.removeEvent(elem,type,data.handle)}}}if(cache[id]){delete cache[id];if(deleteExpando){delete elem[internalKey]}else{if(elem.removeAttribute){elem.removeAttribute(internalKey)}else{elem[internalKey]=null}}jQuery.deletedIds.push(id)}}}}}});(function(){var matched,browser;jQuery.uaMatch=function(ua){ua=ua.toLowerCase();var match=/(chrome)[ \/]([\w.]+)/.exec(ua)||/(webkit)[ \/]([\w.]+)/.exec(ua)||/(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua)||/(msie) ([\w.]+)/.exec(ua)||/(trident)[ \/](?:.*? rv:([\w.]+)|)/.exec(ua)||ua.indexOf("compatible")<0&&/(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua)||[];if(match[1]=="trident"){match[1]="msie"}return{browser:match[1]||"",version:match[2]||"0"}};matched=jQuery.uaMatch(navigator.userAgent);browser={};if(matched.browser){browser[matched.browser]=true;browser.version=matched.version}if(browser.chrome){browser.webkit=true}else{if(browser.webkit){browser.safari=true}}jQuery.browser=browser;jQuery.sub=function(){function jQuerySub(selector,context){return new jQuerySub.fn.init(selector,context)}jQuery.extend(true,jQuerySub,this);jQuerySub.superclass=this;jQuerySub.fn=jQuerySub.prototype=this();jQuerySub.fn.constructor=jQuerySub;jQuerySub.sub=this.sub;jQuerySub.fn.init=function init(selector,context){if(context&&context instanceof jQuery&&!(context instanceof jQuerySub)){context=jQuerySub(context)}return jQuery.fn.init.call(this,selector,context,rootjQuerySub)};jQuerySub.fn.init.prototype=jQuerySub.fn;var rootjQuerySub=jQuerySub(document);return jQuerySub}})();var curCSS,iframe,iframeDoc,ralpha=/alpha\([^)]*\)/i,ropacity=/opacity=([^)]*)/,rposition=/^(top|right|bottom|left)$/,rdisplayswap=/^(none|table(?!-c[ea]).+)/,rmargin=/^margin/,rnumsplit=new RegExp("^("+core_pnum+")(.*)$","i"),rnumnonpx=new RegExp("^("+core_pnum+")(?!px)[a-z%]+$","i"),rrelNum=new RegExp("^([-+])=("+core_pnum+")","i"),elemdisplay={BODY:"block"},cssShow={position:"absolute",visibility:"hidden",display:"block"},cssNormalTransform={letterSpacing:0,fontWeight:400},cssExpand=["Top","Right","Bottom","Left"],cssPrefixes=["Webkit","O","Moz","ms"],eventsToggle=jQuery.fn.toggle;function vendorPropName(style,name){if(name in style){return name}var capName=name.charAt(0).toUpperCase()+name.slice(1),origName=name,i=cssPrefixes.length;while(i--){name=cssPrefixes[i]+capName;if(name in style){return name}}return origName}function isHidden(elem,el){elem=el||elem;return jQuery.css(elem,"display")==="none"||!jQuery.contains(elem.ownerDocument,elem)}function showHide(elements,show){var elem,display,values=[],index=0,length=elements.length;for(;index<length;index++){elem=elements[index];if(!elem.style){continue}values[index]=jQuery._data(elem,"olddisplay");if(show){if(!values[index]&&elem.style.display==="none"){elem.style.display=""}if(elem.style.display===""&&isHidden(elem)){values[index]=jQuery._data(elem,"olddisplay",css_defaultDisplay(elem.nodeName))}}else{display=curCSS(elem,"display");if(!values[index]&&display!=="none"){jQuery._data(elem,"olddisplay",display)}}}for(index=0;index<length;index++){elem=elements[index];if(!elem.style){continue}if(!show||elem.style.display==="none"||elem.style.display===""){elem.style.display=show?values[index]||"":"none"}}return elements}jQuery.fn.extend({css:function(name,value){return jQuery.access(this,function(elem,name,value){return value!==undefined?jQuery.style(elem,name,value):jQuery.css(elem,name)},name,value,arguments.length>1)},show:function(){return showHide(this,true)},hide:function(){return showHide(this)},toggle:function(state,fn2){var bool=typeof state==="boolean";if(jQuery.isFunction(state)&&jQuery.isFunction(fn2)){return eventsToggle.apply(this,arguments)}return this.each(function(){if(bool?state:isHidden(this)){jQuery(this).show()}else{jQuery(this).hide()}})}});jQuery.extend({cssHooks:{opacity:{get:function(elem,computed){if(computed){var ret=curCSS(elem,"opacity");return ret===""?"1":ret}}}},cssNumber:{fillOpacity:true,fontWeight:true,lineHeight:true,opacity:true,orphans:true,widows:true,zIndex:true,zoom:true},cssProps:{"float":jQuery.support.cssFloat?"cssFloat":"styleFloat"},style:function(elem,name,value,extra){if(!elem||elem.nodeType===3||elem.nodeType===8||!elem.style){return }var ret,type,hooks,origName=jQuery.camelCase(name),style=elem.style;name=jQuery.cssProps[origName]||(jQuery.cssProps[origName]=vendorPropName(style,origName));hooks=jQuery.cssHooks[name]||jQuery.cssHooks[origName];if(value!==undefined){type=typeof value;if(type==="string"&&(ret=rrelNum.exec(value))){value=(ret[1]+1)*ret[2]+parseFloat(jQuery.css(elem,name));type="number"}if(value==null||type==="number"&&isNaN(value)){return }if(type==="number"&&!jQuery.cssNumber[origName]){value+="px"}if(!hooks||!("set" in hooks)||(value=hooks.set(elem,value,extra))!==undefined){try{style[name]=value}catch(e){}}}else{if(hooks&&"get" in hooks&&(ret=hooks.get(elem,false,extra))!==undefined){return ret}return style[name]}},css:function(elem,name,numeric,extra){var val,num,hooks,origName=jQuery.camelCase(name);name=jQuery.cssProps[origName]||(jQuery.cssProps[origName]=vendorPropName(elem.style,origName));hooks=jQuery.cssHooks[name]||jQuery.cssHooks[origName];if(hooks&&"get" in hooks){val=hooks.get(elem,true,extra)}if(val===undefined){val=curCSS(elem,name)}if(val==="normal"&&name in cssNormalTransform){val=cssNormalTransform[name]}if(numeric||extra!==undefined){num=parseFloat(val);return numeric||jQuery.isNumeric(num)?num||0:val}return val},swap:function(elem,options,callback){var ret,name,old={};for(name in options){old[name]=elem.style[name];elem.style[name]=options[name]}ret=callback.call(elem);for(name in options){elem.style[name]=old[name]}return ret}});if(window.getComputedStyle){curCSS=function(elem,name){var ret,width,minWidth,maxWidth,computed=window.getComputedStyle(elem,null),style=elem.style;if(computed){ret=computed.getPropertyValue(name)||computed[name];if(ret===""&&!jQuery.contains(elem.ownerDocument,elem)){ret=jQuery.style(elem,name)}if(rnumnonpx.test(ret)&&rmargin.test(name)){width=style.width;minWidth=style.minWidth;maxWidth=style.maxWidth;style.minWidth=style.maxWidth=style.width=ret;ret=computed.width;style.width=width;style.minWidth=minWidth;style.maxWidth=maxWidth}}return ret}}else{if(document.documentElement.currentStyle){curCSS=function(elem,name){var left,rsLeft,ret=elem.currentStyle&&elem.currentStyle[name],style=elem.style;if(ret==null&&style&&style[name]){ret=style[name]}if(rnumnonpx.test(ret)&&!rposition.test(name)){left=style.left;rsLeft=elem.runtimeStyle&&elem.runtimeStyle.left;if(rsLeft){elem.runtimeStyle.left=elem.currentStyle.left}style.left=name==="fontSize"?"1em":ret;ret=style.pixelLeft+"px";style.left=left;if(rsLeft){elem.runtimeStyle.left=rsLeft}}return ret===""?"auto":ret}}}function setPositiveNumber(elem,value,subtract){var matches=rnumsplit.exec(value);return matches?Math.max(0,matches[1]-(subtract||0))+(matches[2]||"px"):value}function augmentWidthOrHeight(elem,name,extra,isBorderBox){var i=extra===(isBorderBox?"border":"content")?4:name==="width"?1:0,val=0;for(;i<4;i+=2){if(extra==="margin"){val+=jQuery.css(elem,extra+cssExpand[i],true)}if(isBorderBox){if(extra==="content"){val-=parseFloat(curCSS(elem,"padding"+cssExpand[i]))||0}if(extra!=="margin"){val-=parseFloat(curCSS(elem,"border"+cssExpand[i]+"Width"))||0}}else{val+=parseFloat(curCSS(elem,"padding"+cssExpand[i]))||0;if(extra!=="padding"){val+=parseFloat(curCSS(elem,"border"+cssExpand[i]+"Width"))||0}}}return val}function getWidthOrHeight(elem,name,extra){var val=name==="width"?elem.offsetWidth:elem.offsetHeight,valueIsBorderBox=true,isBorderBox=jQuery.support.boxSizing&&jQuery.css(elem,"boxSizing")==="border-box";if(val<=0||val==null){val=curCSS(elem,name);if(val<0||val==null){val=elem.style[name]}if(rnumnonpx.test(val)){return val}valueIsBorderBox=isBorderBox&&(jQuery.support.boxSizingReliable||val===elem.style[name]);val=parseFloat(val)||0}return(val+augmentWidthOrHeight(elem,name,extra||(isBorderBox?"border":"content"),valueIsBorderBox))+"px"}function css_defaultDisplay(nodeName){if(elemdisplay[nodeName]){return elemdisplay[nodeName]}var elem=jQuery("<"+nodeName+">").appendTo(document.body),display=elem.css("display");elem.remove();if(display==="none"||display===""){iframe=document.body.appendChild(iframe||jQuery.extend(document.createElement("iframe"),{frameBorder:0,width:0,height:0}));if(!iframeDoc||!iframe.createElement){iframeDoc=(iframe.contentWindow||iframe.contentDocument).document;iframeDoc.write("<!doctype html><html><body>");iframeDoc.close()}elem=iframeDoc.body.appendChild(iframeDoc.createElement(nodeName));display=curCSS(elem,"display");document.body.removeChild(iframe)}elemdisplay[nodeName]=display;return display}jQuery.each(["height","width"],function(i,name){jQuery.cssHooks[name]={get:function(elem,computed,extra){if(computed){if(elem.offsetWidth===0&&rdisplayswap.test(curCSS(elem,"display"))){return jQuery.swap(elem,cssShow,function(){return getWidthOrHeight(elem,name,extra)})}else{return getWidthOrHeight(elem,name,extra)}}},set:function(elem,value,extra){return setPositiveNumber(elem,value,extra?augmentWidthOrHeight(elem,name,extra,jQuery.support.boxSizing&&jQuery.css(elem,"boxSizing")==="border-box"):0)}}});if(!jQuery.support.opacity){jQuery.cssHooks.opacity={get:function(elem,computed){return ropacity.test((computed&&elem.currentStyle?elem.currentStyle.filter:elem.style.filter)||"")?(0.01*parseFloat(RegExp.$1))+"":computed?"1":""},set:function(elem,value){var style=elem.style,currentStyle=elem.currentStyle,opacity=jQuery.isNumeric(value)?"alpha(opacity="+value*100+")":"",filter=currentStyle&&currentStyle.filter||style.filter||"";style.zoom=1;if(value>=1&&jQuery.trim(filter.replace(ralpha,""))===""&&style.removeAttribute){style.removeAttribute("filter");if(currentStyle&&!currentStyle.filter){return }}style.filter=ralpha.test(filter)?filter.replace(ralpha,opacity):filter+" "+opacity}}}jQuery(function(){if(!jQuery.support.reliableMarginRight){jQuery.cssHooks.marginRight={get:function(elem,computed){return jQuery.swap(elem,{display:"inline-block"},function(){if(computed){return curCSS(elem,"marginRight")}})}}}if(!jQuery.support.pixelPosition&&jQuery.fn.position){jQuery.each(["top","left"],function(i,prop){jQuery.cssHooks[prop]={get:function(elem,computed){if(computed){var ret=curCSS(elem,prop);return rnumnonpx.test(ret)?jQuery(elem).position()[prop]+"px":ret}}}})}});if(jQuery.expr&&jQuery.expr.filters){jQuery.expr.filters.hidden=function(elem){return(elem.offsetWidth===0&&elem.offsetHeight===0)||(!jQuery.support.reliableHiddenOffsets&&((elem.style&&elem.style.display)||curCSS(elem,"display"))==="none")};jQuery.expr.filters.visible=function(elem){return !jQuery.expr.filters.hidden(elem)}}jQuery.each({margin:"",padding:"",border:"Width"},function(prefix,suffix){jQuery.cssHooks[prefix+suffix]={expand:function(value){var i,parts=typeof value==="string"?value.split(" "):[value],expanded={};for(i=0;i<4;i++){expanded[prefix+cssExpand[i]+suffix]=parts[i]||parts[i-2]||parts[0]}return expanded}};if(!rmargin.test(prefix)){jQuery.cssHooks[prefix+suffix].set=setPositiveNumber}});var r20=/%20/g,rbracket=/\[\]$/,rCRLF=/\r?\n/g,rinput=/^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,rselectTextarea=/^(?:select|textarea)/i;jQuery.fn.extend({serialize:function(){return jQuery.param(this.serializeArray())},serializeArray:function(){return this.map(function(){return this.elements?jQuery.makeArray(this.elements):this}).filter(function(){return this.name&&!this.disabled&&(this.checked||rselectTextarea.test(this.nodeName)||rinput.test(this.type))}).map(function(i,elem){var val=jQuery(this).val();return val==null?null:jQuery.isArray(val)?jQuery.map(val,function(val,i){return{name:elem.name,value:val.replace(rCRLF,"\r\n")}}):{name:elem.name,value:val.replace(rCRLF,"\r\n")}}).get()}});jQuery.param=function(a,traditional){var prefix,s=[],add=function(key,value){value=jQuery.isFunction(value)?value():(value==null?"":value);s[s.length]=encodeURIComponent(key)+"="+encodeURIComponent(value)};if(traditional===undefined){traditional=jQuery.ajaxSettings&&jQuery.ajaxSettings.traditional}if(jQuery.isArray(a)||(a.jquery&&!jQuery.isPlainObject(a))){jQuery.each(a,function(){add(this.name,this.value)})}else{for(prefix in a){buildParams(prefix,a[prefix],traditional,add)}}return s.join("&").replace(r20,"+")};function buildParams(prefix,obj,traditional,add){var name;if(jQuery.isArray(obj)){jQuery.each(obj,function(i,v){if(traditional||rbracket.test(prefix)){add(prefix,v)}else{buildParams(prefix+"["+(typeof v==="object"?i:"")+"]",v,traditional,add)}})}else{if(!traditional&&jQuery.type(obj)==="object"){for(name in obj){buildParams(prefix+"["+name+"]",obj[name],traditional,add)}}else{add(prefix,obj)}}}var ajaxLocParts,ajaxLocation,rhash=/#.*$/,rheaders=/^(.*?):[ \t]*([^\r\n]*)\r?$/mg,rlocalProtocol=/^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/,rnoContent=/^(?:GET|HEAD)$/,rprotocol=/^\/\//,rquery=/\?/,rscript=/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,rts=/([?&])_=[^&]*/,rurl=/^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,_load=jQuery.fn.load,prefilters={},transports={},allTypes=["*/"]+["*"];try{ajaxLocation=location.href}catch(e){ajaxLocation=document.createElement("a");ajaxLocation.href="";ajaxLocation=ajaxLocation.href}ajaxLocParts=rurl.exec(ajaxLocation.toLowerCase())||[];function addToPrefiltersOrTransports(structure){return function(dataTypeExpression,func){if(typeof dataTypeExpression!=="string"){func=dataTypeExpression;dataTypeExpression="*"}var dataType,list,placeBefore,dataTypes=dataTypeExpression.toLowerCase().split(core_rspace),i=0,length=dataTypes.length;if(jQuery.isFunction(func)){for(;i<length;i++){dataType=dataTypes[i];placeBefore=/^\+/.test(dataType);if(placeBefore){dataType=dataType.substr(1)||"*"}list=structure[dataType]=structure[dataType]||[];list[placeBefore?"unshift":"push"](func)}}}}function inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,dataType,inspected){dataType=dataType||options.dataTypes[0];inspected=inspected||{};inspected[dataType]=true;var selection,list=structure[dataType],i=0,length=list?list.length:0,executeOnly=(structure===prefilters);for(;i<length&&(executeOnly||!selection);i++){selection=list[i](options,originalOptions,jqXHR);if(typeof selection==="string"){if(!executeOnly||inspected[selection]){selection=undefined}else{options.dataTypes.unshift(selection);selection=inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,selection,inspected)}}}if((executeOnly||!selection)&&!inspected["*"]){selection=inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,"*",inspected)}return selection}function ajaxExtend(target,src){var key,deep,flatOptions=jQuery.ajaxSettings.flatOptions||{};for(key in src){if(src[key]!==undefined){(flatOptions[key]?target:(deep||(deep={})))[key]=src[key]}}if(deep){jQuery.extend(true,target,deep)}}jQuery.fn.load=function(url,params,callback){if(typeof url!=="string"&&_load){return _load.apply(this,arguments)}if(!this.length){return this}var selector,type,response,self=this,off=url.indexOf(" ");if(off>=0){selector=url.slice(off,url.length);url=url.slice(0,off)}if(jQuery.isFunction(params)){callback=params;params=undefined}else{if(params&&typeof params==="object"){type="POST"}}jQuery.ajax({url:url,type:type,dataType:"html",data:params,complete:function(jqXHR,status){if(callback){self.each(callback,response||[jqXHR.responseText,status,jqXHR])}}}).done(function(responseText){response=arguments;self.html(selector?jQuery("<div>").append(responseText.replace(rscript,"")).find(selector):responseText)});return this};jQuery.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "),function(i,o){jQuery.fn[o]=function(f){return this.on(o,f)}});jQuery.each(["get","post"],function(i,method){jQuery[method]=function(url,data,callback,type){if(jQuery.isFunction(data)){type=type||callback;callback=data;data=undefined}return jQuery.ajax({type:method,url:url,data:data,success:callback,dataType:type})}});jQuery.extend({getScript:function(url,callback){return jQuery.get(url,undefined,callback,"script")},getJSON:function(url,data,callback){return jQuery.get(url,data,callback,"json")},ajaxSetup:function(target,settings){if(settings){ajaxExtend(target,jQuery.ajaxSettings)}else{settings=target;target=jQuery.ajaxSettings}ajaxExtend(target,settings);return target},ajaxSettings:{url:ajaxLocation,isLocal:rlocalProtocol.test(ajaxLocParts[1]),global:true,type:"GET",contentType:"application/x-www-form-urlencoded; charset=UTF-8",processData:true,async:true,accepts:{xml:"application/xml, text/xml",html:"text/html",text:"text/plain",json:"application/json, text/javascript","*":allTypes},contents:{xml:/xml/,html:/html/,json:/json/},responseFields:{xml:"responseXML",text:"responseText"},converters:{"* text":window.String,"text html":true,"text json":jQuery.parseJSON,"text xml":jQuery.parseXML},flatOptions:{context:true,url:true}},ajaxPrefilter:addToPrefiltersOrTransports(prefilters),ajaxTransport:addToPrefiltersOrTransports(transports),ajax:function(url,options){if(typeof url==="object"){options=url;url=undefined}options=options||{};var ifModifiedKey,responseHeadersString,responseHeaders,transport,timeoutTimer,parts,fireGlobals,i,s=jQuery.ajaxSetup({},options),callbackContext=s.context||s,globalEventContext=callbackContext!==s&&(callbackContext.nodeType||callbackContext instanceof jQuery)?jQuery(callbackContext):jQuery.event,deferred=jQuery.Deferred(),completeDeferred=jQuery.Callbacks("once memory"),statusCode=s.statusCode||{},requestHeaders={},requestHeadersNames={},state=0,strAbort="canceled",jqXHR={readyState:0,setRequestHeader:function(name,value){if(!state){var lname=name.toLowerCase();name=requestHeadersNames[lname]=requestHeadersNames[lname]||name;requestHeaders[name]=value}return this},getAllResponseHeaders:function(){return state===2?responseHeadersString:null},getResponseHeader:function(key){var match;if(state===2){if(!responseHeaders){responseHeaders={};while((match=rheaders.exec(responseHeadersString))){responseHeaders[match[1].toLowerCase()]=match[2]}}match=responseHeaders[key.toLowerCase()]}return match===undefined?null:match},overrideMimeType:function(type){if(!state){s.mimeType=type}return this},abort:function(statusText){statusText=statusText||strAbort;if(transport){transport.abort(statusText)}done(0,statusText);return this}};function done(status,nativeStatusText,responses,headers){var isSuccess,success,error,response,modified,statusText=nativeStatusText;if(state===2){return }state=2;if(timeoutTimer){clearTimeout(timeoutTimer)}transport=undefined;responseHeadersString=headers||"";jqXHR.readyState=status>0?4:0;if(responses){response=ajaxHandleResponses(s,jqXHR,responses)}if(status>=200&&status<300||status===304){if(s.ifModified){modified=jqXHR.getResponseHeader("Last-Modified");if(modified){jQuery.lastModified[ifModifiedKey]=modified}modified=jqXHR.getResponseHeader("Etag");if(modified){jQuery.etag[ifModifiedKey]=modified}}if(status===304){statusText="notmodified";isSuccess=true}else{isSuccess=ajaxConvert(s,response);statusText=isSuccess.state;success=isSuccess.data;error=isSuccess.error;isSuccess=!error}}else{error=statusText;if(!statusText||status){statusText="error";if(status<0){status=0}}}jqXHR.status=status;jqXHR.statusText=(nativeStatusText||statusText)+"";if(isSuccess){deferred.resolveWith(callbackContext,[success,statusText,jqXHR])}else{deferred.rejectWith(callbackContext,[jqXHR,statusText,error])}jqXHR.statusCode(statusCode);statusCode=undefined;if(fireGlobals){globalEventContext.trigger("ajax"+(isSuccess?"Success":"Error"),[jqXHR,s,isSuccess?success:error])}completeDeferred.fireWith(callbackContext,[jqXHR,statusText]);if(fireGlobals){globalEventContext.trigger("ajaxComplete",[jqXHR,s]);if(!(--jQuery.active)){jQuery.event.trigger("ajaxStop")}}}deferred.promise(jqXHR);jqXHR.success=jqXHR.done;jqXHR.error=jqXHR.fail;jqXHR.complete=completeDeferred.add;jqXHR.statusCode=function(map){if(map){var tmp;if(state<2){for(tmp in map){statusCode[tmp]=[statusCode[tmp],map[tmp]]}}else{tmp=map[jqXHR.status];jqXHR.always(tmp)}}return this};s.url=((url||s.url)+"").replace(rhash,"").replace(rprotocol,ajaxLocParts[1]+"//");s.dataTypes=jQuery.trim(s.dataType||"*").toLowerCase().split(core_rspace);if(s.crossDomain==null){parts=rurl.exec(s.url.toLowerCase());s.crossDomain=!!(parts&&(parts[1]!==ajaxLocParts[1]||parts[2]!==ajaxLocParts[2]||(parts[3]||(parts[1]==="http:"?80:443))!=(ajaxLocParts[3]||(ajaxLocParts[1]==="http:"?80:443))))}if(s.data&&s.processData&&typeof s.data!=="string"){s.data=jQuery.param(s.data,s.traditional)}inspectPrefiltersOrTransports(prefilters,s,options,jqXHR);if(state===2){return jqXHR}fireGlobals=s.global;s.type=s.type.toUpperCase();s.hasContent=!rnoContent.test(s.type);if(fireGlobals&&jQuery.active++===0){jQuery.event.trigger("ajaxStart")}if(!s.hasContent){if(s.data){s.url+=(rquery.test(s.url)?"&":"?")+s.data;delete s.data}ifModifiedKey=s.url;if(s.cache===false){var ts=jQuery.now(),ret=s.url.replace(rts,"$1_="+ts);s.url=ret+((ret===s.url)?(rquery.test(s.url)?"&":"?")+"_="+ts:"")}}if(s.data&&s.hasContent&&s.contentType!==false||options.contentType){jqXHR.setRequestHeader("Content-Type",s.contentType)}if(s.ifModified){ifModifiedKey=ifModifiedKey||s.url;if(jQuery.lastModified[ifModifiedKey]){jqXHR.setRequestHeader("If-Modified-Since",jQuery.lastModified[ifModifiedKey])}if(jQuery.etag[ifModifiedKey]){jqXHR.setRequestHeader("If-None-Match",jQuery.etag[ifModifiedKey])}}jqXHR.setRequestHeader("Accept",s.dataTypes[0]&&s.accepts[s.dataTypes[0]]?s.accepts[s.dataTypes[0]]+(s.dataTypes[0]!=="*"?", "+allTypes+"; q=0.01":""):s.accepts["*"]);for(i in s.headers){jqXHR.setRequestHeader(i,s.headers[i])}if(s.beforeSend&&(s.beforeSend.call(callbackContext,jqXHR,s)===false||state===2)){return jqXHR.abort()}strAbort="abort";for(i in {success:1,error:1,complete:1}){jqXHR[i](s[i])}transport=inspectPrefiltersOrTransports(transports,s,options,jqXHR);if(!transport){done(-1,"No Transport")}else{jqXHR.readyState=1;if(fireGlobals){globalEventContext.trigger("ajaxSend",[jqXHR,s])}if(s.async&&s.timeout>0){timeoutTimer=setTimeout(function(){jqXHR.abort("timeout")},s.timeout)}try{state=1;transport.send(requestHeaders,done)}catch(e){if(state<2){done(-1,e)}else{throw e}}}return jqXHR},active:0,lastModified:{},etag:{}});function ajaxHandleResponses(s,jqXHR,responses){var ct,type,finalDataType,firstDataType,contents=s.contents,dataTypes=s.dataTypes,responseFields=s.responseFields;for(type in responseFields){if(type in responses){jqXHR[responseFields[type]]=responses[type]}}while(dataTypes[0]==="*"){dataTypes.shift();if(ct===undefined){ct=s.mimeType||jqXHR.getResponseHeader("content-type")}}if(ct){for(type in contents){if(contents[type]&&contents[type].test(ct)){dataTypes.unshift(type);break}}}if(dataTypes[0] in responses){finalDataType=dataTypes[0]}else{for(type in responses){if(!dataTypes[0]||s.converters[type+" "+dataTypes[0]]){finalDataType=type;break}if(!firstDataType){firstDataType=type}}finalDataType=finalDataType||firstDataType}if(finalDataType){if(finalDataType!==dataTypes[0]){dataTypes.unshift(finalDataType)}return responses[finalDataType]}}function ajaxConvert(s,response){var conv,conv2,current,tmp,dataTypes=s.dataTypes.slice(),prev=dataTypes[0],converters={},i=0;if(s.dataFilter){response=s.dataFilter(response,s.dataType)}if(dataTypes[1]){for(conv in s.converters){converters[conv.toLowerCase()]=s.converters[conv]}}for(;(current=dataTypes[++i]);){if(current!=="*"){if(prev!=="*"&&prev!==current){conv=converters[prev+" "+current]||converters["* "+current];if(!conv){for(conv2 in converters){tmp=conv2.split(" ");if(tmp[1]===current){conv=converters[prev+" "+tmp[0]]||converters["* "+tmp[0]];if(conv){if(conv===true){conv=converters[conv2]}else{if(converters[conv2]!==true){current=tmp[0];dataTypes.splice(i--,0,current)}}break}}}}if(conv!==true){if(conv&&s["throws"]){response=conv(response)}else{try{response=conv(response)}catch(e){return{state:"parsererror",error:conv?e:"No conversion from "+prev+" to "+current}}}}}prev=current}}return{state:"success",data:response}}var oldCallbacks=[],rquestion=/\?/,rjsonp=/(=)\?(?=&|$)|\?\?/,nonce=jQuery.now();jQuery.ajaxSetup({jsonp:"callback",jsonpCallback:function(){var callback=oldCallbacks.pop()||(jQuery.expando+"_"+(nonce++));this[callback]=true;return callback}});jQuery.ajaxPrefilter("json jsonp",function(s,originalSettings,jqXHR){var callbackName,overwritten,responseContainer,data=s.data,url=s.url,hasCallback=s.jsonp!==false,replaceInUrl=hasCallback&&rjsonp.test(url),replaceInData=hasCallback&&!replaceInUrl&&typeof data==="string"&&!(s.contentType||"").indexOf("application/x-www-form-urlencoded")&&rjsonp.test(data);if(s.dataTypes[0]==="jsonp"||replaceInUrl||replaceInData){callbackName=s.jsonpCallback=jQuery.isFunction(s.jsonpCallback)?s.jsonpCallback():s.jsonpCallback;overwritten=window[callbackName];if(replaceInUrl){s.url=url.replace(rjsonp,"$1"+callbackName)}else{if(replaceInData){s.data=data.replace(rjsonp,"$1"+callbackName)}else{if(hasCallback){s.url+=(rquestion.test(url)?"&":"?")+s.jsonp+"="+callbackName}}}s.converters["script json"]=function(){if(!responseContainer){jQuery.error(callbackName+" was not called")}return responseContainer[0]};s.dataTypes[0]="json";window[callbackName]=function(){responseContainer=arguments};jqXHR.always(function(){window[callbackName]=overwritten;if(s[callbackName]){s.jsonpCallback=originalSettings.jsonpCallback;oldCallbacks.push(callbackName)}if(responseContainer&&jQuery.isFunction(overwritten)){overwritten(responseContainer[0])}responseContainer=overwritten=undefined});return"script"}});jQuery.ajaxSetup({accepts:{script:"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"},contents:{script:/javascript|ecmascript/},converters:{"text script":function(text){jQuery.globalEval(text);return text}}});jQuery.ajaxPrefilter("script",function(s){if(s.cache===undefined){s.cache=false}if(s.crossDomain){s.type="GET";s.global=false}});jQuery.ajaxTransport("script",function(s){if(s.crossDomain){var script,head=document.head||document.getElementsByTagName("head")[0]||document.documentElement;return{send:function(_,callback){script=document.createElement("script");script.async="async";if(s.scriptCharset){script.charset=s.scriptCharset}script.src=s.url;script.onload=script.onreadystatechange=function(_,isAbort){if(isAbort||!script.readyState||/loaded|complete/.test(script.readyState)){script.onload=script.onreadystatechange=null;if(head&&script.parentNode){head.removeChild(script)}script=undefined;if(!isAbort){callback(200,"success")}}};head.insertBefore(script,head.firstChild)},abort:function(){if(script){script.onload(0,1)}}}}});var xhrCallbacks,xhrOnUnloadAbort=window.ActiveXObject?function(){for(var key in xhrCallbacks){xhrCallbacks[key](0,1)}}:false,xhrId=0;function createStandardXHR(){try{return new window.XMLHttpRequest()}catch(e){}}function createActiveXHR(){try{return new window.ActiveXObject("Microsoft.XMLHTTP")}catch(e){}}jQuery.ajaxSettings.xhr=window.ActiveXObject?function(){return !this.isLocal&&createStandardXHR()||createActiveXHR()}:createStandardXHR;(function(xhr){jQuery.extend(jQuery.support,{ajax:!!xhr,cors:!!xhr&&("withCredentials" in xhr)})})(jQuery.ajaxSettings.xhr());if(jQuery.support.ajax){jQuery.ajaxTransport(function(s){if(!s.crossDomain||jQuery.support.cors){var callback;return{send:function(headers,complete){var handle,i,xhr=s.xhr();if(s.username){xhr.open(s.type,s.url,s.async,s.username,s.password)}else{xhr.open(s.type,s.url,s.async)}if(s.xhrFields){for(i in s.xhrFields){xhr[i]=s.xhrFields[i]}}if(s.mimeType&&xhr.overrideMimeType){xhr.overrideMimeType(s.mimeType)}if(!s.crossDomain&&!headers["X-Requested-With"]){headers["X-Requested-With"]="XMLHttpRequest"}try{for(i in headers){xhr.setRequestHeader(i,headers[i])}}catch(_){}xhr.send((s.hasContent&&s.data)||null);callback=function(_,isAbort){var status,statusText,responseHeaders,responses,xml;try{if(callback&&(isAbort||xhr.readyState===4)){callback=undefined;if(handle){xhr.onreadystatechange=jQuery.noop;if(xhrOnUnloadAbort){delete xhrCallbacks[handle]}}if(isAbort){if(xhr.readyState!==4){xhr.abort()}}else{status=xhr.status;responseHeaders=xhr.getAllResponseHeaders();responses={};xml=xhr.responseXML;if(xml&&xml.documentElement){responses.xml=xml}try{responses.text=xhr.responseText}catch(e){}try{statusText=xhr.statusText}catch(e){statusText=""}if(!status&&s.isLocal&&!s.crossDomain){status=responses.text?200:404}else{if(status===1223){status=204}}}}}catch(firefoxAccessException){if(!isAbort){complete(-1,firefoxAccessException)}}if(responses){complete(status,statusText,responses,responseHeaders)}};if(!s.async){callback()}else{if(xhr.readyState===4){setTimeout(callback,0)}else{handle=++xhrId;if(xhrOnUnloadAbort){if(!xhrCallbacks){xhrCallbacks={};jQuery(window).unload(xhrOnUnloadAbort)}xhrCallbacks[handle]=callback}xhr.onreadystatechange=callback}}},abort:function(){if(callback){callback(0,1)}}}}})}var fxNow,timerId,rfxtypes=/^(?:toggle|show|hide)$/,rfxnum=new RegExp("^(?:([-+])=|)("+core_pnum+")([a-z%]*)$","i"),rrun=/queueHooks$/,animationPrefilters=[defaultPrefilter],tweeners={"*":[function(prop,value){var end,unit,tween=this.createTween(prop,value),parts=rfxnum.exec(value),target=tween.cur(),start=+target||0,scale=1,maxIterations=20;if(parts){end=+parts[2];unit=parts[3]||(jQuery.cssNumber[prop]?"":"px");if(unit!=="px"&&start){start=jQuery.css(tween.elem,prop,true)||end||1;do{scale=scale||".5";start=start/scale;jQuery.style(tween.elem,prop,start+unit)}while(scale!==(scale=tween.cur()/target)&&scale!==1&&--maxIterations)}tween.unit=unit;tween.start=start;tween.end=parts[1]?start+(parts[1]+1)*end:end}return tween}]};function createFxNow(){setTimeout(function(){fxNow=undefined},0);return(fxNow=jQuery.now())}function createTweens(animation,props){jQuery.each(props,function(prop,value){var collection=(tweeners[prop]||[]).concat(tweeners["*"]),index=0,length=collection.length;for(;index<length;index++){if(collection[index].call(animation,prop,value)){return }}})}function Animation(elem,properties,options){var result,index=0,tweenerIndex=0,length=animationPrefilters.length,deferred=jQuery.Deferred().always(function(){delete tick.elem}),tick=function(){var currentTime=fxNow||createFxNow(),remaining=Math.max(0,animation.startTime+animation.duration-currentTime),temp=remaining/animation.duration||0,percent=1-temp,index=0,length=animation.tweens.length;for(;index<length;index++){animation.tweens[index].run(percent)}deferred.notifyWith(elem,[animation,percent,remaining]);if(percent<1&&length){return remaining}else{deferred.resolveWith(elem,[animation]);return false}},animation=deferred.promise({elem:elem,props:jQuery.extend({},properties),opts:jQuery.extend(true,{specialEasing:{}},options),originalProperties:properties,originalOptions:options,startTime:fxNow||createFxNow(),duration:options.duration,tweens:[],createTween:function(prop,end,easing){var tween=jQuery.Tween(elem,animation.opts,prop,end,animation.opts.specialEasing[prop]||animation.opts.easing);animation.tweens.push(tween);return tween},stop:function(gotoEnd){var index=0,length=gotoEnd?animation.tweens.length:0;for(;index<length;index++){animation.tweens[index].run(1)}if(gotoEnd){deferred.resolveWith(elem,[animation,gotoEnd])}else{deferred.rejectWith(elem,[animation,gotoEnd])}return this}}),props=animation.props;propFilter(props,animation.opts.specialEasing);for(;index<length;index++){result=animationPrefilters[index].call(animation,elem,props,animation.opts);if(result){return result}}createTweens(animation,props);if(jQuery.isFunction(animation.opts.start)){animation.opts.start.call(elem,animation)}jQuery.fx.timer(jQuery.extend(tick,{anim:animation,queue:animation.opts.queue,elem:elem}));return animation.progress(animation.opts.progress).done(animation.opts.done,animation.opts.complete).fail(animation.opts.fail).always(animation.opts.always)}function propFilter(props,specialEasing){var index,name,easing,value,hooks;for(index in props){name=jQuery.camelCase(index);easing=specialEasing[name];value=props[index];if(jQuery.isArray(value)){easing=value[1];value=props[index]=value[0]}if(index!==name){props[name]=value;delete props[index]}hooks=jQuery.cssHooks[name];if(hooks&&"expand" in hooks){value=hooks.expand(value);delete props[name];for(index in value){if(!(index in props)){props[index]=value[index];specialEasing[index]=easing}}}else{specialEasing[name]=easing}}}jQuery.Animation=jQuery.extend(Animation,{tweener:function(props,callback){if(jQuery.isFunction(props)){callback=props;props=["*"]}else{props=props.split(" ")}var prop,index=0,length=props.length;for(;index<length;index++){prop=props[index];tweeners[prop]=tweeners[prop]||[];tweeners[prop].unshift(callback)}},prefilter:function(callback,prepend){if(prepend){animationPrefilters.unshift(callback)}else{animationPrefilters.push(callback)}}});function defaultPrefilter(elem,props,opts){var index,prop,value,length,dataShow,toggle,tween,hooks,oldfire,anim=this,style=elem.style,orig={},handled=[],hidden=elem.nodeType&&isHidden(elem);if(!opts.queue){hooks=jQuery._queueHooks(elem,"fx");if(hooks.unqueued==null){hooks.unqueued=0;oldfire=hooks.empty.fire;hooks.empty.fire=function(){if(!hooks.unqueued){oldfire()}}}hooks.unqueued++;anim.always(function(){anim.always(function(){hooks.unqueued--;if(!jQuery.queue(elem,"fx").length){hooks.empty.fire()}})})}if(elem.nodeType===1&&("height" in props||"width" in props)){opts.overflow=[style.overflow,style.overflowX,style.overflowY];if(jQuery.css(elem,"display")==="inline"&&jQuery.css(elem,"float")==="none"){if(!jQuery.support.inlineBlockNeedsLayout||css_defaultDisplay(elem.nodeName)==="inline"){style.display="inline-block"}else{style.zoom=1}}}if(opts.overflow){style.overflow="hidden";if(!jQuery.support.shrinkWrapBlocks){anim.done(function(){style.overflow=opts.overflow[0];style.overflowX=opts.overflow[1];style.overflowY=opts.overflow[2]})}}for(index in props){value=props[index];if(rfxtypes.exec(value)){delete props[index];toggle=toggle||value==="toggle";if(value===(hidden?"hide":"show")){continue}handled.push(index)}}length=handled.length;if(length){dataShow=jQuery._data(elem,"fxshow")||jQuery._data(elem,"fxshow",{});if("hidden" in dataShow){hidden=dataShow.hidden}if(toggle){dataShow.hidden=!hidden}if(hidden){jQuery(elem).show()}else{anim.done(function(){jQuery(elem).hide()})}anim.done(function(){var prop;jQuery.removeData(elem,"fxshow",true);for(prop in orig){jQuery.style(elem,prop,orig[prop])}});for(index=0;index<length;index++){prop=handled[index];tween=anim.createTween(prop,hidden?dataShow[prop]:0);orig[prop]=dataShow[prop]||jQuery.style(elem,prop);if(!(prop in dataShow)){dataShow[prop]=tween.start;if(hidden){tween.end=tween.start;tween.start=prop==="width"||prop==="height"?1:0}}}}}function Tween(elem,options,prop,end,easing){return new Tween.prototype.init(elem,options,prop,end,easing)}jQuery.Tween=Tween;Tween.prototype={constructor:Tween,init:function(elem,options,prop,end,easing,unit){this.elem=elem;this.prop=prop;this.easing=easing||"swing";this.options=options;this.start=this.now=this.cur();this.end=end;this.unit=unit||(jQuery.cssNumber[prop]?"":"px")},cur:function(){var hooks=Tween.propHooks[this.prop];return hooks&&hooks.get?hooks.get(this):Tween.propHooks._default.get(this)},run:function(percent){var eased,hooks=Tween.propHooks[this.prop];if(this.options.duration){this.pos=eased=jQuery.easing[this.easing](percent,this.options.duration*percent,0,1,this.options.duration)}else{this.pos=eased=percent}this.now=(this.end-this.start)*eased+this.start;if(this.options.step){this.options.step.call(this.elem,this.now,this)}if(hooks&&hooks.set){hooks.set(this)}else{Tween.propHooks._default.set(this)}return this}};Tween.prototype.init.prototype=Tween.prototype;Tween.propHooks={_default:{get:function(tween){var result;if(tween.elem[tween.prop]!=null&&(!tween.elem.style||tween.elem.style[tween.prop]==null)){return tween.elem[tween.prop]}result=jQuery.css(tween.elem,tween.prop,false,"");return !result||result==="auto"?0:result},set:function(tween){if(jQuery.fx.step[tween.prop]){jQuery.fx.step[tween.prop](tween)}else{if(tween.elem.style&&(tween.elem.style[jQuery.cssProps[tween.prop]]!=null||jQuery.cssHooks[tween.prop])){jQuery.style(tween.elem,tween.prop,tween.now+tween.unit)}else{tween.elem[tween.prop]=tween.now}}}}};Tween.propHooks.scrollTop=Tween.propHooks.scrollLeft={set:function(tween){if(tween.elem.nodeType&&tween.elem.parentNode){tween.elem[tween.prop]=tween.now}}};jQuery.each(["toggle","show","hide"],function(i,name){var cssFn=jQuery.fn[name];jQuery.fn[name]=function(speed,easing,callback){return speed==null||typeof speed==="boolean"||(!i&&jQuery.isFunction(speed)&&jQuery.isFunction(easing))?cssFn.apply(this,arguments):this.animate(genFx(name,true),speed,easing,callback)}});jQuery.fn.extend({fadeTo:function(speed,to,easing,callback){return this.filter(isHidden).css("opacity",0).show().end().animate({opacity:to},speed,easing,callback)},animate:function(prop,speed,easing,callback){var empty=jQuery.isEmptyObject(prop),optall=jQuery.speed(speed,easing,callback),doAnimation=function(){var anim=Animation(this,jQuery.extend({},prop),optall);if(empty){anim.stop(true)}};return empty||optall.queue===false?this.each(doAnimation):this.queue(optall.queue,doAnimation)},stop:function(type,clearQueue,gotoEnd){var stopQueue=function(hooks){var stop=hooks.stop;delete hooks.stop;stop(gotoEnd)};if(typeof type!=="string"){gotoEnd=clearQueue;clearQueue=type;type=undefined}if(clearQueue&&type!==false){this.queue(type||"fx",[])}return this.each(function(){var dequeue=true,index=type!=null&&type+"queueHooks",timers=jQuery.timers,data=jQuery._data(this);if(index){if(data[index]&&data[index].stop){stopQueue(data[index])}}else{for(index in data){if(data[index]&&data[index].stop&&rrun.test(index)){stopQueue(data[index])}}}for(index=timers.length;index--;){if(timers[index].elem===this&&(type==null||timers[index].queue===type)){timers[index].anim.stop(gotoEnd);dequeue=false;timers.splice(index,1)}}if(dequeue||!gotoEnd){jQuery.dequeue(this,type)}})}});function genFx(type,includeWidth){var which,attrs={height:type},i=0;includeWidth=includeWidth?1:0;for(;i<4;i+=2-includeWidth){which=cssExpand[i];attrs["margin"+which]=attrs["padding"+which]=type}if(includeWidth){attrs.opacity=attrs.width=type}return attrs}jQuery.each({slideDown:genFx("show"),slideUp:genFx("hide"),slideToggle:genFx("toggle"),fadeIn:{opacity:"show"},fadeOut:{opacity:"hide"},fadeToggle:{opacity:"toggle"}},function(name,props){jQuery.fn[name]=function(speed,easing,callback){return this.animate(props,speed,easing,callback)}});jQuery.speed=function(speed,easing,fn){var opt=speed&&typeof speed==="object"?jQuery.extend({},speed):{complete:fn||!fn&&easing||jQuery.isFunction(speed)&&speed,duration:speed,easing:fn&&easing||easing&&!jQuery.isFunction(easing)&&easing};opt.duration=jQuery.fx.off?0:typeof opt.duration==="number"?opt.duration:opt.duration in jQuery.fx.speeds?jQuery.fx.speeds[opt.duration]:jQuery.fx.speeds._default;if(opt.queue==null||opt.queue===true){opt.queue="fx"}opt.old=opt.complete;opt.complete=function(){if(jQuery.isFunction(opt.old)){opt.old.call(this)}if(opt.queue){jQuery.dequeue(this,opt.queue)}};return opt};jQuery.easing={linear:function(p){return p},swing:function(p){return 0.5-Math.cos(p*Math.PI)/2}};jQuery.timers=[];jQuery.fx=Tween.prototype.init;jQuery.fx.tick=function(){var timer,timers=jQuery.timers,i=0;fxNow=jQuery.now();for(;i<timers.length;i++){timer=timers[i];if(!timer()&&timers[i]===timer){timers.splice(i--,1)}}if(!timers.length){jQuery.fx.stop()}fxNow=undefined};jQuery.fx.timer=function(timer){if(timer()&&jQuery.timers.push(timer)&&!timerId){timerId=setInterval(jQuery.fx.tick,jQuery.fx.interval)}};jQuery.fx.interval=13;jQuery.fx.stop=function(){clearInterval(timerId);timerId=null};jQuery.fx.speeds={slow:600,fast:200,_default:400};jQuery.fx.step={};if(jQuery.expr&&jQuery.expr.filters){jQuery.expr.filters.animated=function(elem){return jQuery.grep(jQuery.timers,function(fn){return elem===fn.elem}).length}}var rroot=/^(?:body|html)$/i;jQuery.fn.offset=function(options){if(arguments.length){return options===undefined?this:this.each(function(i){jQuery.offset.setOffset(this,options,i)})}var docElem,body,win,clientTop,clientLeft,scrollTop,scrollLeft,box={top:0,left:0},elem=this[0],doc=elem&&elem.ownerDocument;if(!doc){return }if((body=doc.body)===elem){return jQuery.offset.bodyOffset(elem)}docElem=doc.documentElement;if(!jQuery.contains(docElem,elem)){return box}if(typeof elem.getBoundingClientRect!=="undefined"){box=elem.getBoundingClientRect()}win=getWindow(doc);clientTop=docElem.clientTop||body.clientTop||0;clientLeft=docElem.clientLeft||body.clientLeft||0;scrollTop=win.pageYOffset||docElem.scrollTop;scrollLeft=win.pageXOffset||docElem.scrollLeft;return{top:box.top+scrollTop-clientTop,left:box.left+scrollLeft-clientLeft}};jQuery.offset={bodyOffset:function(body){var top=body.offsetTop,left=body.offsetLeft;if(jQuery.support.doesNotIncludeMarginInBodyOffset){top+=parseFloat(jQuery.css(body,"marginTop"))||0;left+=parseFloat(jQuery.css(body,"marginLeft"))||0}return{top:top,left:left}},setOffset:function(elem,options,i){var position=jQuery.css(elem,"position");if(position==="static"){elem.style.position="relative"}var curElem=jQuery(elem),curOffset=curElem.offset(),curCSSTop=jQuery.css(elem,"top"),curCSSLeft=jQuery.css(elem,"left"),calculatePosition=(position==="absolute"||position==="fixed")&&jQuery.inArray("auto",[curCSSTop,curCSSLeft])>-1,props={},curPosition={},curTop,curLeft;if(calculatePosition){curPosition=curElem.position();curTop=curPosition.top;curLeft=curPosition.left}else{curTop=parseFloat(curCSSTop)||0;curLeft=parseFloat(curCSSLeft)||0}if(jQuery.isFunction(options)){options=options.call(elem,i,curOffset)}if(options.top!=null){props.top=(options.top-curOffset.top)+curTop}if(options.left!=null){props.left=(options.left-curOffset.left)+curLeft}if("using" in options){options.using.call(elem,props)}else{curElem.css(props)}}};jQuery.fn.extend({position:function(){if(!this[0]){return }var elem=this[0],offsetParent=this.offsetParent(),offset=this.offset(),parentOffset=rroot.test(offsetParent[0].nodeName)?{top:0,left:0}:offsetParent.offset();offset.top-=parseFloat(jQuery.css(elem,"marginTop"))||0;offset.left-=parseFloat(jQuery.css(elem,"marginLeft"))||0;parentOffset.top+=parseFloat(jQuery.css(offsetParent[0],"borderTopWidth"))||0;parentOffset.left+=parseFloat(jQuery.css(offsetParent[0],"borderLeftWidth"))||0;return{top:offset.top-parentOffset.top,left:offset.left-parentOffset.left}},offsetParent:function(){return this.map(function(){var offsetParent=this.offsetParent||document.body;while(offsetParent&&(!rroot.test(offsetParent.nodeName)&&jQuery.css(offsetParent,"position")==="static")){offsetParent=offsetParent.offsetParent}return offsetParent||document.body})}});jQuery.each({scrollLeft:"pageXOffset",scrollTop:"pageYOffset"},function(method,prop){var top=/Y/.test(prop);jQuery.fn[method]=function(val){return jQuery.access(this,function(elem,method,val){var win=getWindow(elem);if(val===undefined){return win?(prop in win)?win[prop]:win.document.documentElement[method]:elem[method]}if(win){win.scrollTo(!top?val:jQuery(win).scrollLeft(),top?val:jQuery(win).scrollTop())}else{elem[method]=val}},method,val,arguments.length,null)}});function getWindow(elem){return jQuery.isWindow(elem)?elem:elem.nodeType===9?elem.defaultView||elem.parentWindow:false}jQuery.each({Height:"height",Width:"width"},function(name,type){jQuery.each({padding:"inner"+name,content:type,"":"outer"+name},function(defaultExtra,funcName){jQuery.fn[funcName]=function(margin,value){var chainable=arguments.length&&(defaultExtra||typeof margin!=="boolean"),extra=defaultExtra||(margin===true||value===true?"margin":"border");return jQuery.access(this,function(elem,type,value){var doc;if(jQuery.isWindow(elem)){return elem.document.documentElement["client"+name]}if(elem.nodeType===9){doc=elem.documentElement;return Math.max(elem.body["scroll"+name],doc["scroll"+name],elem.body["offset"+name],doc["offset"+name],doc["client"+name])}return value===undefined?jQuery.css(elem,type,value,extra):jQuery.style(elem,type,value,extra)},type,chainable?margin:undefined,chainable,null)}})});window.jQuery=window.$=jQuery;if(typeof define==="function"&&define.amd&&define.amd.jQuery){define("jquery",[],function(){return jQuery})}})(window);
/*
Script: Moo.js
	My Object Oriented javascript.

Author:
	Valerio Proietti, <http://mad4milk.net>

License:
	MIT-style license.

Mootools Credits:
	- Class is slightly based on Base.js <http://dean.edwards.name/weblog/2006/03/base/> (c) 2006 Dean Edwards, License <http://creativecommons.org/licenses/LGPL/2.1/>
	- Some functions are based on those found in prototype.js <http://prototype.conio.net/> (c) 2005 Sam Stephenson sam [at] conio [dot] net, MIT-style license
	- Documentation by Aaron Newton (aaron.newton [at] cnet [dot] com) and Valerio Proietti.
*/

/*
Class: Class
	The base class object of the <http://mootools.net> framework.

Arguments:
	properties - the collection of properties that apply to the class. Creates a new class, its initialize method will fire upon class instantiation.

Example:
	(start code)
	var Cat = new Class({
		initialize: function(name){
			this.name = name;
		}
	});
	var myCat = new Cat('Micia');
	alert(myCat.name); //alerts 'Micia'
	(end)
*/

var Class = function(properties){
	var klass = function(){
		if (this.initialize && arguments[0] != 'noinit') return this.initialize.apply(this, arguments);
		else return this;
	};
	for (var property in this) klass[property] = this[property];
	klass.prototype = properties;
	return klass;
};

/*
Property: empty
	Returns an empty function
*/

Class.empty = function(){};

Class.prototype = {

	/*
	Property: extend
		Returns the copy of the Class extended with the passed in properties.

	Arguments:
		properties - the properties to add to the base class in this new Class.

	Example:
		(start code)
		var Animal = new Class({
			initialize: function(age){
				this.age = age;
			}
		});
		var Cat = Animal.extend({
			initialize: function(name, age){
				this.parent(age); //will call the previous initialize;
				this.name = name;
			}
		});
		var myCat = new Cat('Micia', 20);
		alert(myCat.name); //alerts 'Micia'
		alert(myCat.age); //alerts 20
		(end)
	*/

	extend: function(properties){
		var pr0t0typ3 = new this('noinit');

		var parentize = function(previous, current){
			if (!previous.apply || !current.apply) return false;
			return function(){
				this.parent = previous;
				return current.apply(this, arguments);
			};
		};

		for (var property in properties){
			var previous = pr0t0typ3[property];
			var current = properties[property];
			if (previous && previous != current) current = parentize(previous, current) || current;
			pr0t0typ3[property] = current;
		}
		return new Class(pr0t0typ3);
	},

	/*
	Property: implement
		Implements the passed in properties to the base Class prototypes, altering the base class, unlike <Class.extend>.

	Arguments:
		properties - the properties to add to the base class.

	Example:
		(start code)
		var Animal = new Class({
			initialize: function(age){
				this.age = age;
			}
		});
		Animal.implement({
			setName: function(name){
				this.name = name
			}
		});
		var myAnimal = new Animal(20);
		myAnimal.setName('Micia');
		alert(myAnimal.name); //alerts 'Micia'
		(end)
	*/

	implement: function(properties){
		for (var property in properties) this.prototype[property] = properties[property];
	}

};

/* Section: Object related Functions */

/*
Function: Object.extend
	Copies all the properties from the second passed object to the first passed Object.
	If you do myWhatever.extend = Object.extend the first parameter will become myWhatever, and your extend function will only need one parameter.

Example:
	(start code)
	var firstOb = {
		'name': 'John',
		'lastName': 'Doe'
	};
	var secondOb = {
		'age': '20',
		'sex': 'male',
		'lastName': 'Dorian'
	};
	Object.extend(firstOb, secondOb);
	//firstOb will become: 
	{
		'name': 'John',
		'lastName': 'Dorian',
		'age': '20',
		'sex': 'male'
	};
	(end)

Returns:
	The first object, extended.
*/

Object.extend = function(){
	var args = arguments;
	args = (args[1]) ? [args[0], args[1]] : [this, args[0]];
	for (var property in args[1]) args[0][property] = args[1][property];
	return args[0];
};

/*
Function: Object.Native
	Will add a .extend method to the objects passed as a parameter, equivalent to <Class.implement>

Arguments:
	a number of classes/native javascript objects

*/

Object.Native = function(){
	for (var i = 0; i < arguments.length; i++) arguments[i].extend = Class.prototype.implement;
};

new Object.Native(Function, Array, String, Number, Class);
var CallerResponder=new Class({debug:false,context:new Object(),error:function(C,B,D){if(C.status==500){var A=jQuery.parseJSON(C.responseText)}if(this.debug){alert("ajax error: "+C.responseText);alert(D)}},complete:function(B,A){if(this.debug){alert("ajax complete")}},beforeSend:function(A){if(this.debug){alert("ajax beforeSend:"+A)}}});var ajaxCallFunc=function(G,B){var H=null;if(G.length>=1){var D=G[G.length-1];if(D!=null&&typeof (D.success)!="undefined"&&$.isFunction(D.success)){H=D;Array.prototype.splice.apply(G,[G.length-1,1])}}var C=new Array();for(var F=0;F<G.length;F++){C[F]=G[F];if($._isInValid(C[F])){return null}}var E=new Object();E.managerMethod=B;E.arguments=$.toJSON(C);var I=null;if(H&&H.success){this.async=true;H=$.extend(new CallerResponder(),H)}else{this.async=false;H=new CallerResponder();H.success=function(K){if(typeof K==="string"){try{I=$.parseJSON(K);if(typeof I==="number"){I=K}}catch(J){I=K}}else{I=K}}}var A=typeof (this.m)==="undefined"?this.jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName="+this.m;jQuery.ajax({type:"POST",url:A+"&rnd="+parseInt(Math.random()*100000),data:E,dataType:"json",async:this.async,success:H.success,error:H.error,complete:H.complete});return I};var RemoteJsonService=new Class({jsonGateway:"/json/",async:true,ajaxCall:ajaxCallFunc,c:ajaxCallFunc});var RJS=RemoteJsonService;
(function($){var m={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},s={array:function(x){var a=["["],b,f,i,l=x.length,v;for(var i=0;i<l;i+=1){v=x[i];f=s[typeof v];if(f){v=f(v);if(typeof v=="string"){if(b){a[a.length]=","}a[a.length]=v;b=true}}}a[a.length]="]";return a.join("")},date:function(x){return s.string(x.dateFormat("Y-m-d"))},"boolean":function(x){return String(x)},"null":function(x){return"null"},number:function(x){return isFinite(x)?String(x):"null"},object:function(x){if(!(typeof (x)==="object")){return"null"}if(x){if($.isArray(x)){return s.array(x)}else{if(x instanceof Date){return s.date(x)}}var a=["{"],b,f,i,v;for(var i in x){v=x[i];f=s[typeof v];if(f){v=f(v);if(typeof v=="string"){if(b){a[a.length]=","}a.push(s.string(i),":",v);b=true}}}a[a.length]="}";return a.join("")}return"null"},string:function(x){if(/["\\\x00-\x1f]/.test(x)){x=x.replace(/([\x00-\x1f\\"])/g,function(a,b){var c=m[b];if(c){return c}c=b.charCodeAt();return"\\u00"+Math.floor(c/16).toString(16)+(c%16).toString(16)})}return'"'+x+'"'},"function":function(x){return x.toString().match(/function\s+([^\s\(]+)/)[1]}};jQuery.toJSON=function(v){var f;if(isNaN(v)){f=s[typeof v]}else{f=($.isArray(v))?s.array:s.number}if(f){return f(v)}};jQuery.parseJSON=function(v,safe){if(safe===undefined){safe=jQuery.parseJSON.safe}if(safe&&!/^("(\\.|[^"\\\n\r])*?"|[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t])+?$/.test(v)){return undefined}return eval("("+v+")")};jQuery.parseJSON.safe=false})(jQuery);
(function(A){A._autofill=new Object();A.autofillform=function(B){var C={};B=A.extend(C,B);var D=B.fillmaps?B.fillmaps:new Object();A._autofill.filllists=D;for(var E in D){A("#"+E).fillform(D[E])}};A.fn.clearform=function(B){var C={clearHidden:false};this.resetValidate();B=A.extend(C,B);this.find(":input").each(function(){switch(this.type){case"passsword":case"select-multiple":case"select-one":case"text":case"textarea":A(this).val("");case"hidden":if(B.clearHidden){A(this).val("")}break;case"checkbox":case"radio":this.checked=false}})};A.fn.fillform=function(B){if(this[0]==null){return }this.each(function(D){var E=A(this);E.resetValidate();for(var F in B){A("#"+F,E).each(function(G){A(this).fill(B[F],F,E)})}E=null});try{this.find("input[type=text]:first").focus()}catch(C){}};A.fn.fill=function(H,G,P){var C=this[0],Q=A(C),R=C.tagName.toLowerCase();if(H&&typeof H=="string"){H=H.replace(/<\/\/script>/gi,"<\/script>")}var I=C.type,S=C.value;switch(R){case"input":switch(I){case"text":Q.val(H);break;case"hidden":var E=Q.attrObj("_comp"),O;if(E){O=E.attr("compType");if(O==="selectPeople"){var J="",L="";if(H&&H.startsWith("{")){H=A.parseJSON(H);E.comp(H);J=H.value;L=H.text}E.val(L);Q.val(J);break}}Q.val(H);break;case"checkbox":if(H==S){C.checked=true}else{C.checked=false}break;case"radio":if(P){A("input[type=radio]",P).each(function(){if((this.id==G||this.name==G)&&H==this.value&&!this.checked){this.checked=true}})}else{if(H==C.value&&!C.checked){C.checked=true}}}break;case"textarea":Q.val(H);break;case"select":switch(I){case"select-one":Q.val(H);break;case"select-multiple":var D=C.options;var K=H.split(",");for(var N=0;N<D.length;N++){var F=D[N];var B=A.browser.msie&&!(F.attributes.value.specified)?F.text:F.value;for(var M=0;M<K.length;M++){if(B==K[M]){F.selected=true}}}}break;default:if(!((!H||H=="")&&A(this)[0].innerHTML.indexOf("&nbsp;")!=-1)){if(H&&Q.parent(".text_overflow").length==1){Q.attr("title",H)}if(H&&typeof H=="string"){H=H.replace(/\n/g,"<br/>")}C.innerHTML=H}}if(this.attr("validate")){this.validate()}};A.fn.fillgrid=function(B){this.each(function(D){var C=this.tagName.toLowerCase(),E=A(this);switch(C){case"table":elem.grid.addData(B);break}})}})(jQuery);
(function(A){A.fn.jsonSubmit=function(L){var J="_js_frm"+new Date().getTime();var F={isMask:true,validate:true,ajax:false,async:false};L=A.extend(F,L);if(L.isMask){showMask&&showMask()}var K=this.formobj(L);if(L.paramObj){if(A.isArray(K)){K={}}for(var B in L.paramObj){K[B]=L.paramObj[B]}}var G=L.action||this.attr("action");if(G==null||A.trim(G)==""){alert("you don't set action attribute!");hideMask&&hideMask();return }if(L.validate&&A._isInValid(K)){hideMask&&hideMask();if(typeof L.collbackError=="function"){L.collbackError()}return }if(L.beforeSubmit&&L.beforeSubmit(K,this,L)===false){hideMask&&hideMask();return }var E=A.toJSON(K);if(L.ajax==true){A.ajax({async:L.async,type:"post",url:G,data:{_json_params:E},error:function(){alert("error\uff0cform submit fail!");if(typeof L.collbackError=="function"){L.collbackError()}},success:function(M){if(typeof L.callback=="function"){L.callback(M)}}})}else{var D=window;if(L.targetWindow){D=L.targetWindow}var H=A('<form method="post" action="'+G+'"><input type="hidden" id="_json_params" name="_json_params" value=""/></form>',D.document);A(D.document.body).append(H);D=null;if(typeof L.callback=="function"){var C=A('<iframe id="'+J+'" name="'+J+'" style="display:none;"></iframe>',H[0].ownerDocument);A("body",H[0].ownerDocument).append(C);C.load(function(){var M=A(this).contents().find("body").html();if(M){M=M.replace(/<\s*\/?\s*(embed|pre)[^<>]*>/g,"")}else{M=""}L.callback(M);try{A(this).remove()}catch(N){}});C=null;H.attr("target",J)}else{if(L.target){H.attr("target",L.target)}}H.find("#_json_params").val(E);if(L.debug&&_isDevelop){alert("JSON data format:\n"+E)}A.confirmClose(false);H.submit();H.remove();H=null}try{if(L.isMask){hideMask&&hideMask()}}catch(I){}};A.fn.formobj=function(M){if(this[0]==null){return{}}var F={gridFilter:null,validate:true,errorIcon:true,errorAlert:false,errorBg:false,includeDisabled:true};M=A.extend(F,M);var N=M.domains;if(N&&N.length>0){var G={};if(A("#attachmentArea").length>0){var K=A("<div></div>");K.attr("id","attachmentInputs");K.attr("style","display:none;");K.attr("isGrid","true");this.append(K);saveAttachment();N.push("attachmentInputs")}for(var J=0;J<N.length;J++){var B=N[J],L=B==this.attr("id")?this:A("#"+B,this),E;var I=A("."+B),D=I.length;if(D>0&&M.matchClass){E=[];var C=[];for(var H=0;H<N.length;H++){if(H!=J){C.push(N[H])}}I.each(function(Q){L=A(this);var R=A.jsonDomain(L,M);if(A._isInValid(R)&&!A._isInValid(E)){A._invalidObj(E)}E.push(R);for(var O=0;O<C.length;O++){var P=A.jsonDomain(A("#"+C[O],L),M);if(A._isInValid(P)&&!A._isInValid(E)){A._invalidObj(E)}R[C[O]]=P}});if(M.isGrid){G=E}else{if(E.length==1){G=E[0]}}break}else{E=A.jsonDomain(L,M);G[B]=E;if(A._isInValid(E)&&!A._isInValid(G)){A._invalidObj(G)}}}return G}else{return A.jsonDomain(this,M)}};A.jsonDomain=function(I,O){O=O||{};var M=[],H=null,K=O.gridFilter,D=I.attr("isGrid")?I.attr("isGrid"):false,E=true,F,J=[],C=O.domains,L=O.includeDisabled;if(C){for(var G=0;G<C.length;G++){var N=C[G];if(I[0]&&N!=I[0].id&&A("#"+N,I).length>0){J.push(N)}}}A("table,input,textarea,select",I).add(I).filter(function(V){if(!this.id&&!this.name){return false}for(var S=0;S<J.length;S++){var W=J[S];if(A(this).parents("#"+W).length>0){return false}}var P=this,X=P.tagName.toLowerCase(),Q=P.id?P.id:P.name;if(X&&Q&&(L||!P.disabled)&&!P.ignore){switch(X){case"table":if(P.grid&&P.p.datas){var R=P.p.datas.rows;A(R).each(function(Y){if(K&&!K(R[Y],A("tbody tr",A(P)).get(Y))){return }M.push(R[Y])});D=true}break;case"input":var U=P.type;if(U=="button"||U=="reset"||U=="submit"||U=="image"||Q=="_json_params"){break}case"textarea":if(X=="textarea"){var T=A(P).attr("comp");if(T&&A.parseJSON("{"+T+"}").type=="editor"){A(P).val(A(P).getEditorContent());break}}case"select":if(H&&Q in H){if(P.type!="radio"){H={};M.push(H)}}var W=A.ctpFieldValue(P,true,L);if(!H){H=new Object();M.push(H)}if(!H[Q]){H[Q]=W}}}return false});if(O.validate){E=A(I).validate({errorIcon:O.errorIcon,errorAlert:O.errorAlert,errorBg:O.errorBg})}if(M.length==1&&!D){F=M[0]}else{if(K){var B=[];for(var G=0;G<M.length;G++){if(!K(M[G])){continue}B.push(M[G])}M=B}F=M}if(!E){A._invalidObj(F)}return F};A.ctpFieldValue=function(C,H,L){var D=C.id?C.id:C.dataIndex?C.dataIndex:C.name,N=C.type,O=C.tagName.toLowerCase();if(typeof H=="undefined"){H=true}if(H&&(!D||(!L&&C.disabled)||N=="reset"||N=="button"||(N=="checkbox"||N=="radio")&&!C.checked||(N=="submit"||N=="image")&&C.form&&C.form.clk!=C||O=="select"&&C.selectedIndex==-1)){return null}if(O=="select"){var I=C.selectedIndex;if(I<0){return null}var K=[],B=C.options;var F=(N=="select-one");var J=(F?I+1:B.length);for(var E=(F?I:0);E<J;E++){var G=B[E];if(G.selected){var M=G.value;if(F){return M}K.push(M)}}return K}return C.value}})(jQuery);
(function(C){C.hotkeys={version:"0.8",specialKeys:{8:"backspace",9:"tab",13:"return",16:"shift",17:"ctrl",18:"alt",19:"pause",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"insert",46:"del",96:"0",97:"1",98:"2",99:"3",100:"4",101:"5",102:"6",103:"7",104:"8",105:"9",106:"*",107:"+",109:"-",110:".",111:"/",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12",144:"numlock",145:"scroll",191:"/",224:"meta"},shiftNums:{"`":"~","1":"!","2":"@","3":"#","4":"$","5":"%","6":"^","7":"&","8":"*","9":"(","0":")","-":"_","=":"+",";":": ","'":'"',",":"<",".":">","/":"?","\\":"|"},returnKeys:[],cancelKeys:[]};function B(E){if(typeof E.data!=="string"){return }var D=E.handler,F=E.data.toLowerCase().split(" ");E.handler=function(G){if(this!==G.target&&(/textarea|select/i.test(G.target.nodeName)||G.target.type==="text")){return }var N=G.type!=="keypress"&&C.hotkeys.specialKeys[G.which],L,O,I="",J={};try{L=String.fromCharCode(G.which).toLowerCase()}catch(M){L=G.which}if(G.altKey&&N!=="alt"){I+="alt+"}if(G.ctrlKey&&N!=="ctrl"){I+="ctrl+"}if(G.metaKey&&!G.ctrlKey&&N!=="meta"){I+="meta+"}if(G.shiftKey&&N!=="shift"){I+="shift+"}if(N){J[I+N]=true}else{J[I+L]=true;J[I+C.hotkeys.shiftNums[L]]=true;if(I==="shift+"){J[C.hotkeys.shiftNums[L]]=true}}for(var K=0,H=F.length;K<H;K++){if(J[F[K]]){return D.apply(this,arguments)}}}}$.each(["keydown","keyup","keypress"],function(){C.event.special[this]={add:B}});$(document).bind("keydown","esc",function(D){C._fireKeydown_esc(D);return false}).bind("keydown","return",function(D){C._fireKeydown_return(D);return true});function A(D){if(!D||D.length==0||D.hasClass("common_button_disable")||D.css("display")=="none"||D.css("visibility")=="hidden"||D.parents(".button_container").css("display")=="none"||D.parents(".button_container").css("visibility")=="hidden"){return false}return true}$._fireKeydown_return=function(D){var E=false;$($.hotkeys.returnKeys).each(function(G,H){var F=$("#"+H);if(A(F)){F.click();E=true;return false}});if(E){return }if($("#ok_msg_btn_first").size()>0){if(A($("#ok_msg_btn_first"))){$("#ok_msg_btn_first").click()}}else{if($("#btnsave").size()>0){if(A($("#btnsave"))){$("#btnsave").click()}}else{if($("#btnok").size()>0){if(A($("#btnok"))){$("#btnok").click()}}else{if($("#btnsubmit").size()>0){if(A($("#btnsubmit"))){$("#btnsubmit").click()}}else{if($("#btnsearch").size()>0){if(A($("#btnsearch"))){$("#btnsearch").click()}}else{if($("#btnreset").size()>0){if(A($("#btnreset"))){$("#btnreset").click()}}else{if($("#btnmodify").size()>0){if(A($("#btnmodify"))){$("#btnmodify").click()}}else{if($("#ok_msg_btn").size()>0){if(A($("#ok_msg_btn"))){$("#ok_msg_btn").click()}}else{if($("#yes_msg_btn").size()>0){if(A($("#yes_msg_btn"))){$("#yes_msg_btn").click()}}else{if($("#retry_msg_btn").size()>0){if(A($("#retry_msg_btn"))){$("#retry_msg_btn").click()}}else{if(parent&&parent!=window){if(parent.jQuery&&parent.jQuery._fireKeydown_return){parent.jQuery._fireKeydown_return(D)}}}}}}}}}}}}};$._fireKeydown_esc=function(D){var E=false;$($.hotkeys.cancelKeys).each(function(G,H){var F=$("#"+H);if(A(F)){F.click();E=true;return false}});if(E){return }if($("#btncancel").size()>0){$("#btncancel").click()}else{if($("#btnclose").size()>0){$("#btnclose").click()}else{if(parent&&parent!=window){parent.jQuery._fireKeydown_esc(D)}}}}})(jQuery);$(function(){$("input,select").bind("keydown","esc",function(A){$._fireKeydown_esc(A);return false}).bind("keydown","return",function(A){$._fireKeydown_return(A);return false})});
(function(B){var A=1;B.fn.codeoption=function(D){var E={};D=B.extend(E,D);var C=new Array;B(".codecfg",this).add(this).each(function(H){var F=this.tagName;if(!F){return }F=F.toLowerCase();var I=D.codecfg?D.codecfg:B(this).attr("codecfg");if(I){var G=B.codecfgobj(this,I);if(D.tags&&!D.tags.contains(F)&&!G.render){return }C.push(G)}});B.genoption(C,D)};B.codeoption=function(C){var D={tags:["select"]};C=B.extend(D,C);B(document).codeoption(C)};B.fn.codetext=function(D){var E={};D=B.extend(E,D);var C=new Array;B(".codecfg",this).add(this).each(function(H){if(!B(this).attr("codecfg")){return }var F=this.tagName.toLowerCase();if(F!="select"){var I=D.codecfg?D.codecfg:B(this).attr("codecfg");if(I){var G=B.codecfgobj(this,I);if(G.render){return }var J=F=="input"?B(this).val():B(this).text();if(J){C.push(G)}}}});B.genoption(C,D)};B.codetext=function(C){B(document).codetext(C)};B.codecfgobj=function(G,F){if(F){var C=F.indexOf("{");var D=B.parseJSON(C==0?F:("{"+F+"}"));var E=G.id?G.id:G.name;if(!E||E.indexOf("coi_")==0){E="coi_"+A;B(G).attr("id",E);A++}D.eleid=E;return D}else{return{}}};B.genoption=function(D,F){if(D.length>0){var E=new ctpCodeManager();var C=B.toJSON(D);B.fillOption(E.selectCode(C))}};B.fillOption=function(E){if(E){for(var C=0;C<E.length;C++){var G=B.findTag(E[C]);var D=E[C].options;var F=E[C]["defaultValue"];if(G){G.each(function(){var R=this.tagName.toLowerCase(),Q=B(this);var P=E[C].render;if(P=="radioh"){H(Q,D)}else{if(P=="radiov"){H(Q,D,true)}else{if(R=="select"){B("option[tmp]",Q).remove();for(var I in D){var N=new Option(D[I],I);N.tmp="tmp";this.options[this.options.length]=N;if(F&&F==I){N.selected=true}}if(E[C].codeId=="collaboration_deadline"){try{var J=this.options;if(J[16]&&J[17]){var M=J[16];J.insertBefore(J[16],J[17]);J.insertBefore(J[17],M)}}catch(O){}}if(P=="new"){var L=B.dropdown({id:this.id});if(F){L.setValue(F)}}}else{if(R=="input"){B(this).val(D[B(this).val()])}else{var K=D[B(this).text()];B(this).text(K);if(B(this).attr("title")){B(this).attr("title",K)}}}}}function H(V,W,Y){var Z=V.attr("id"),S=V;V.attr("id",Z+"_hid");for(var U in W){var T=B('<label class="margin_r_10 hand"></label>');T.text(W[U]);if(Y){T.addClass("display_block")}var X=B('<input class="radio_com" type="radio" name="'+Z+'">');X.attr("id",Z);X.val(U);T.prepend(X);S.after(T);S=T;if(F&&F==U){X.attr("checked",true)}}V.remove()}})}}}};B.findTag=function(D){var C;if(D.eleid){C=B("#"+D.eleid).length==0?B("[name='"+D.eleid+"']"):B("#"+D.eleid)}if(!C){B(".codecfg").each(function(F){var E=this.codecfg;if(E){if(E.indexOf("codeType")!=-1&&E.indexOf(D.codeType)!=-1){C=B(this)}if(E.indexOf("codeType")==-1&&E.indexOf(D.tableName)!=-1){C=B(this)}}})}return C}})(jQuery);
$.ctx={};var isFormSubmit=true;$.extend(Function.prototype,{defer:function(A){var D,C=this,B=function(){var F=this,E=arguments;window.clearTimeout(D);D=window.setTimeout(function(){C.apply(F,E)},A)};B();return 0}});$.extendParam=function(C,A){for(var B in A){if(!(A[B] instanceof Array)){C[B]=A[B]}}return C};var isPDFReaderInited=false;function isPDFReaderEnabled(){try{if(isPDFReaderInited==false){isPDFReaderInited=true;new ActiveXObject("iWebPDF.PDFReader")}}catch(A){return false}return true}$.ctx.isOfficeEnabled=function(D){var A=D,B=true;if(!$.browser.msie){return true}try{if(!$.ctx._mainbodyOcxObj&&(A==".doc"||A==".xls"||A==".wps"||A==".et"||(A>40&&A<45))){$.ctx._mainbodyOcxObj=new ActiveXObject("HandWrite.HandWriteCtrl")}if(A==".doc"||A==41){B=$.ctx._mainbodyOcxObj.WebApplication(".doc")}else{if(A==".xls"||A==42){B=$.ctx._mainbodyOcxObj.WebApplication(".xls")}else{if(A==".wps"||A==43){B=$.ctx._mainbodyOcxObj.WebApplication(".wps")}else{if(A==".et"||A==44){B=$.ctx._mainbodyOcxObj.WebApplication(".et")}else{if(A==".pdf"||A==45){return isPDFReaderEnabled()}}}}}}catch(C){B=false}return B};$.ctx._hasPrivJudge=function(C,B){var A=false,E;if(C&&(B?$.ctx.plugins:$.ctx.resources)){if(C.indexOf("&")!=-1){A=true;E=C.split("&");for(var D=0;D<E.length;D++){if(B?!$.ctx.plugins.contains(E[D].trim()):!$.ctx.resources.contains(E[D].trim())){A=false;break}}}else{if(C.indexOf("|")!=-1){E=C.split("|");for(var D=0;D<E.length;D++){if(B?$.ctx.plugins.contains(E[D].trim()):$.ctx.resources.contains(E[D].trim())){A=true;break}}}else{A=B?$.ctx.plugins.contains(C.trim()):$.ctx.resources.contains(C.trim())}}}return A};$.ctx.hasPlugin=function(A){return $.ctx._hasPrivJudge(A,true)};$.ctx.hasResource=function(A){return $.ctx._hasPrivJudge(A,false)};$.privCheck=function(A,C,D,B){if(!D){D=function(){}}if(!B){B=function(){}}if(_isDevelop){D()}else{if(C&&$.ctx.hasPlugin(C)){if(A&&$.ctx.hasResource(A)){D()}else{if(!A){D()}else{B()}}}else{if(!C&&A){if($.ctx.hasResource(A)){D()}else{B()}}else{if(!C&&!A){D()}else{B()}}}}};var _safriDoubleKeyIgnoreKeys=[32,192,186,187,188,189,190,191,219,220,221,222,13];$.handleModalDialogInputKeyEvent=function(){var C=navigator.vendor,A=navigator.platform;if(C&&C.indexOf("Apple")!=-1&&A&&A.indexOf("Win")!=-1){var B=false;$(":input").keyup(function(E){D(this,E)}).keydown(function(E){if(E.keyCode==229){B=true}else{B=false}});function D(J,E){if(B){return }var H=E.keyCode;if(((H<48||H>111)&&!_safriDoubleKeyIgnoreKeys.contains(H))||E.ctrlKey||E.altKey){return }if(H==13&&J.type!=="textarea"){return }var G=J.selectionStart,I=J.value,F;if(G>0){F=I.substring(0,G-1);if(G<I.length){F+=I.substring(G)}}J.value=F;J.setSelectionRange(G-1,G-1)}}};$().ready(function(){$(".comp").each(function(A){$(this).compThis()});$.codeoption();$.autofillform({fillmaps:$.ctx.fillmaps});$.codetext();$(".resCode").each(function(B){var A=$(this),C=A.attr("resCode"),D=A.attr("pluginId");$.privCheck(C,D,function(){A.show()},function(){A.hide()})});CallerResponder.prototype={error:function(E,D,F){try{var B=$.parseJSON(E.responseText);if(!B.details){$.alert({msg:B.message,close_fn:function(){try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(G){}},ok_fn:function(){try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(G){}}})}else{$("body").append('<div id="errorDiv" style="display: none" width="600"><div id="errMsg"></div><br><textarea id="errDetails" rows="15" style="width: 500; font-size: 10pt" readonly="readonly"></textarea></div>');$("#errMsg").text("Error message("+B.code+"):"+B.message);$("#errDetails").text(B.details);var C=$.dialog({title:"Error!",htmlId:"errorDiv",width:520,height:300,targetWindow:getCtpTop(),buttons:[{text:"Close",handler:function(){$("#errorDiv").remove();var G=C.getObjectById("errorDiv");if(G){G.remove()}C.close();hideMask()}}]})}}catch(A){}}};(function(){try{if(_isModalDialog){$.handleModalDialogInputKeyEvent();var A=setInterval(function(){$.ajax({url:_ctxPath+"/main.do?method=hangup&t="+Math.random()*100000000,async:true})},30000)}}catch(B){}$("input:reset").each(function(){$("input:text,select,input:checkbox,input:password",$(this).parents("form")).each(function(){if(this.type=="checkbox"){$(this).attr("coriginValue",this.checked)}$(this).attr("originValue",$(this).val())});var D=$(this);var E=$("<input type='button' />");E.attr("id",D.attr("id"));E.attr("className",D.attr("className")+" button_3");E.attr("style",D.attr("style"));E.attr("name",D.attr("name"));E.onmuseover=this["onmuseover"];E.val(D.val());D.after(E);D.remove();E.click(function(){$("input:text,select,input:checkbox,input:password",$(this).parents("form")).each(function(){if($(this).attr("originValue")){$(this).val($(this).attr("originValue"))}else{$(this).val("")}if(this.tagName.toUpperCase()=="SELECT"){for(var F=0;F<this.options.length;F++){if(this.options[F].value==$(this).attr("originValue")){this.options[F].selected=true}}}if(this.type=="checkbox"){if($(this).attr("coriginValue")!="true"){this.checked=false}else{this.checked=true}}})})});function C(D){if(typeof D=="string"&&D.length>10){return D.substring(0,10)}return D}if(document.all){$("a[href='javascript:void(0)']").live("click",function(D){D.preventDefault()})}}).defer(0,this)});Date.prototype.isBefore=function(C){var B=parseInt(this.format("Ymd")),A=parseInt(C.format("Ymd"));return B>A?-1:(B<A?1:0)};Date.prototype.before=function(C,G){if(!C||!G){return 0}var D=0,F,A=true,E=this,B=G;if(this.isBefore(G)==-1){A=false;E=G;B=this}F=E.clone();switch(C.toLowerCase()){case Date.MONTH:while(true){if(F.getYear()==B.getYear()&&F.getMonth()==B.getMonth()){break}else{D++;F=F.add(Date.MONTH,1)}}break;case Date.YEAR:while(true){if(F.getYear()==B.getYear()){break}else{D++;F=F.add(Date.YEAR,1)}}break}if(!A){D*=-1}return D};Date.prototype.roundBefore=function(D,I){var J,A=this,C=I,F=true;if(this.isBefore(I)==-1){F=false;bdate=I;adate=this}J=A.before(D,C);var E=A.getDate(),H=C.getDate();switch(D.toLowerCase()){case Date.MONTH:if(H<E){J--}break;case Date.YEAR:var G=A.getMonth(),B=C.getMonth();if(B<G){J--}else{if(B==G){if(H<E){J--}}}break}if(!F){J*=-1}return J};function isBefore(B,C){var A=Date.parseDate(B,"Y-m-d");var D=Date.parseDate(C,"Y-m-d");return A.isBefore(D)}function before(A,C,D){var B=Date.parseDate(C,"Y-m-d");var E=Date.parseDate(D,"Y-m-d");return B.before(A,E)}function roundBefore(A,C,D){var B=Date.parseDate(C,"Y-m-d");var E=Date.parseDate(D,"Y-m-d");return B.roundBefore(A,E)}(function($){$.fn.switchClone=function(da,hc){var t=this;if(!t.attr("_isclone")){var tc=t.attrObj("tmpclone");if(!tc){tc=t.clone();if(hc){hc(t[0].tagName.toLowerCase(),tc)}tc.attr("_isclone",1);t.attrObj("tmpclone",tc);t.after(tc)}if(t.attr("_hide")==1){if(!da){t.show();t.attr("_hide",0);tc.hide()}}else{if(da){t.hide();t.attr("_hide",1);tc.show()}}}};$.fn.disable=function(){this.each(function(i){$(this).find(":input,a.common_button").add(this).each(function(){var id=this.id,t=$(this),c=t.attrObj("_rel");switch(this.tagName.toLowerCase()){case"textarea":case"select":var dd=t.attrObj("_dropdown");if(dd){dd.disabled="true"}case"input":t.attr("disabled","yes");t.attr("_da",true);if(c){c.switchClone(true,function(tn,sc){if(tn=="a"){sc.addClass("common_button_disable")}else{sc.attr("disabled","yes")}})}break;case"a":if(!t.attr("_isrel")){t.switchClone(true,function(tn,sc){sc.addClass("common_button_disable")});t.attr("_da",true)}break}})})};$.fn.enable=function(){this.each(function(i){$(this).find(":input,a.common_button").add(this).each(function(){var id=this.id,t=$(this),c=t.attrObj("_rel");if(t.attr("_da")){switch(this.tagName.toLowerCase()){case"textarea":case"select":var dd=t.attrObj("_dropdown");if(dd){dd.disabled=null}case"input":t.removeAttr("disabled");t.attr("_da",false);if(c){c.switchClone(false)}break;case"a":if(!t.attr("_isrel")){t.switchClone(false);t.attr("_da",false)}break}}})})};var attrObjs=[];$.fn.attrObj=function(name,value){var obj;for(var i=0;i<attrObjs.length;i++){if(attrObjs[i].o==this[0]){obj=attrObjs[i];break}}if(!obj){obj=new Object();obj.o=this[0];obj.v=new Object();attrObjs.push(obj)}if(value){obj.v[name]=value}else{return obj.v[name]}};$.fn.removeAttrObj=function(name){for(var i=0;i<attrObjs.length;i++){if(attrObjs[i].o==this[0]){var obj=attrObjs[i];obj.v[name]=null;break}}};$.confirmClose=function(){var mute=arguments.length>0;var ua=navigator.userAgent;var isMSIE=(navigator.appName=="Microsoft Internet Explorer")||ua.indexOf("Trident")!=-1;if(isMSIE){document.body.onbeforeunload=function(){if(removeCtpWindow){removeCtpWindow(null,2)}if(!mute&&isFormSubmit){window.event.returnValue=""}}}else{if(navigator.userAgent.indexOf("Firefox")!=-1){window.onbeforeunload=function(e){if(removeCtpWindow){removeCtpWindow(null,2)}if(!mute&&isFormSubmit){return""}}}else{if(navigator.userAgent.indexOf("Safari")!=-1){window.addEventListener("onbeforeunload",function(){if(removeCtpWindow){removeCtpWindow(null,2)}if(!mute&&isFormSubmit){return""}},false)}else{window.addEventListener("beforeunload",function(){if(removeCtpWindow){removeCtpWindow(null,2)}if(!mute&&isFormSubmit){return""}},false)}}}};$.i18n=function(key){try{var lang=CTPLang[_locale];if(!lang){return key}var msg=lang[key+_editionI18nSuffix.toUpperCase()];if(!msg){msg=lang[key+_editionI18nSuffix.toLowerCase()]}if(!msg){msg=lang[key]}if(msg&&arguments.length>1){var messageRegEx_0=/\{0\}/g;var messageRegEx_1=/\{1\}/g;var messageRegEx_2=/\{2\}/g;var messageRegEx_3=/\{3\}/g;var messageRegEx_4=/\{4\}/g;var messageRegEx_5=/\{5\}/g;var messageRegEx_6=/\{6\}/g;var messageRegEx_7=/\{7\}/g;var messageRegEx_8=/\{8\}/g;var messageRegEx_9=/\{9\}/g;var messageRegEx_10=/\{10\}/g;var messageRegEx_11=/\{11\}/g;var messageRegEx_12=/\{12\}/g;var messageRegEx_13=/\{13\}/g;var messageRegEx_14=/\{14\}/g;var messageRegEx_15=/\{15\}/g;for(var i=0;i<arguments.length-1;i++){var regEx=eval("messageRegEx_"+i);var repMe=""+arguments[i+1];if(repMe.indexOf("$_")!=-1){repMe=repMe.replace("$_","$$_")}msg=msg.replace(regEx,repMe)}}return msg}catch(e){}return""}})(jQuery);var ctpCodeManager=RemoteJsonService.extend({jsonGateway:_ctxPath+"/ajax.do?method=ajaxAction&managerName=ctpCodeManager",selectCode:function(){return this.ajaxCall(arguments,"selectCode")}});var ctpUserPreferenceManager=RemoteJsonService.extend({jsonGateway:_ctxPath+"/ajax.do?method=ajaxAction&managerName=ctpUserPreferenceManager",saveGridPreference:function(){return this.ajaxCall(arguments,"saveGridPreference")}});var AjaxDataLoader={load:function(A,B,C){jQuery.ajax({type:"POST",url:A,cache:false,data:B,async:true,success:function(D){if($.isFunction(C)){C(D)}}})}};Array.prototype.contains=function(B){for(var A=0;A<this.length;A++){if(this[A]==B){return true}}return false};String.prototype.format=function(){var A=arguments;return this.replace(/\{(\d+)\}/g,function(){return A[arguments[1]]})};function showMask(){try{if(getCtpTop()&&getCtpTop().startProc){getCtpTop().startProc()}}catch(A){}}function hideMask(){try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(A){}}function getCtpTop(){try{var A=getCtpParentWindow(window);if(A){return A}else{return top}}catch(B){return top}}function getCtpParentWindow(C){var A=C;for(var B=0;B<20;B++){if(typeof A.isCtpTop!="undefined"&&A.isCtpTop){return A}else{A=A.parent}}}function getCtpTopFromOpener(D){var A=D.getCtpTop();for(var B=0;B<10;B++){if(typeof A.isCtpTop!="undefined"&&A.isCtpTop){return A}else{try{A=A.opener.getCtpTop()}catch(C){return A}}}}function closeOpenMultyWindow(C,E){if(C==undefined){C=window.location+"";var D=C.indexOf("/seeyon/");if(D!=-1){C=C.substring(D)}}var B=getCtpTop()._windowsMap;if(B){var A=B.get(C);if(A){if(E!=undefined&&A.isFormSubmit){A.isFormSubmit=E}A.close()}B.remove(C)}}function addAnotherKey(B,D,I,G,A){if(B&&D){var L=getCtpTop();if(I==2){if(getCtpTop().opener){L=getCtpTop().opener}}var E=L._windowsMap;if(E){var J=E.get(B);if(J){E.putRef(D,J)}else{if(G){if(E.keys().size()==0){E.putRef(D,A)}else{var F=E.keys().size();var K;for(var C=0;C<F;C++){var H=E.keys().get(C);if(H.indexOf(G)){K=E.get(H);break}}E.putRef(D,K)}}}}}}function getMultyWindowId(B,C){if(C==undefined||B==undefined){return }var D;var E=C.indexOf(B);var A=C.indexOf("&",E);if(A==-1){D=C.substring(E+B.length+1)}else{D=C.substring(E+B.length+1,A)}return D}function removeCtpWindow(F,B){try{var E=getCtpTop();if(F==null||F==undefined){F=E.location+"";var D=F.indexOf("/seeyon/");if(D!=-1){F=F.substring(D)}}if(B==2){if(getCtpTop().isCtpTop){return }if(getCtpTop().opener){E=getCtpTop().opener}}var A=E._windowsMap;if(A){A.remove(F)}}catch(C){}}function openCtpWindow(D){var O,T,R,M,L,J,Y,H,B;this.windowArgs=D;T=D.width||parseInt(screen.width)-20;R=D.height||parseInt(screen.height)-80;this.settings={dialog_type:"open",resizable:"yes",scrollbars:"yes"};O=D.html;H=D.url;if(H.indexOf("seeyon")==0){H=_ctxPath+H}B=D.dialogType||this.settings.dialog_type;J=D.resizable||this.settings.resizable;Y=D.scrollbars||this.settings.scrollbars;var K=null;var W=(J=="yes")?"no":"yes";var E=D.id;if(E==undefined){E=H}var U=getCtpTop()._windowsMap;if(U){try{var Q=U.keys()}catch(X){getCtpTop()._windowsMap=new Properties();U=getCtpTop()._windowsMap}for(var S=0;S<U.keys().size();S++){var P=U.keys().get(S);try{var C=U.get(P);var N=C.document;if(N){var Z=parseInt(N.body.clientHeight);if(Z==0){if($.browser.msie){N.write("")}C.close();C=null;U.remove(P);S--}}else{C=null;U.remove(P);S--}}catch(X){C=null;U.remove(P);S--}}if(U.size()==10){alert($.i18n("window.max.length.js"));return }var V=U.get(E);if(V){try{var G=V.location.href;var I="";var A=G.indexOf("/seeyon/");if(A!=-1){I=G.substring(A)}if(I==H){var N=V.document;alert($.i18n("window.already.exit.js"));V.focus();return }}catch(X){V=null;U.remove(E)}}}R-=25;var F=window.open(H,"ctpPopup"+new Date().getTime(),"top=0,left=0,scrollbars=yes,dialog=yes,minimizable=yes,modal=open,width="+T+",height="+R+",resizable=yes");if(F==null){return }F.focus();if(U){U.putRef(E,F)}return F}function removeAllDialog(){try{getCtpTop().$(".mask").remove();var D=getCtpTop().$(".dialog_box");if(D.size()>0){var B=getCtpTop().$(".dialog_box .dialog_main_content iframe");if(B.size()>0){for(var A=0;A<B.size();A++){B[A].contentWindow.document.write("");B[A].contentWindow.close()}B.remove()}D.remove()}getCtpTop().$(".shield").remove();getCtpTop().$(".mxt-window").remove()}catch(C){}};
var messageRegEx_0=/\{0\}/g;var messageRegEx_1=/\{1\}/g;var messageRegEx_2=/\{2\}/g;var messageRegEx_3=/\{3\}/g;var messageRegEx_4=/\{4\}/g;var messageRegEx_5=/\{5\}/g;var messageRegEx_6=/\{6\}/g;var messageRegEx_7=/\{7\}/g;var messageRegEx_8=/\{8\}/g;var messageRegEx_9=/\{9\}/g;var messageRegEx_10=/\{10\}/g;var messageRegEx_11=/\{11\}/g;var messageRegEx_12=/\{12\}/g;var messageRegEx_13=/\{13\}/g;var messageRegEx_14=/\{14\}/g;var messageRegEx_15=/\{15\}/g;var portalOfA8IframeStr="top.frames['frame_A8']";if(!window.ActiveXObject){if(typeof (HTMLElement)!="undefined"){HTMLElement.prototype.__defineSetter__("outerHTML",function(A){var B=this.ownerDocument.createRange();B.setStartBefore(this);var D=B.createContextualFragment(A);this.parentNode.replaceChild(D,this);return A});HTMLElement.prototype.__defineGetter__("outerHTML",function(){var A=this.attributes,D="<"+this.tagName,B=0;for(;B<A.length;B++){if(A[B].specified){D+=" "+A[B].name+'="'+A[B].value+'"'}}if(!this.canHaveChildren){return D+" />"}return D+">"+this.innerHTML+"</"+this.tagName+">"});HTMLElement.prototype.__defineGetter__("canHaveChildren",function(){return !/^(area|base|basefont|col|frame|hr|img|br|input|isindex|link|meta|param)$/.test(this.tagName.toLowerCase())})}}if(!window.ActiveXObject){if(!!document.getBoxObjectFor||window.mozInnerScreenX!=null){HTMLElement.prototype.__defineSetter__("innerText",function(B){var A=document.createTextNode(B);this.innerHTML="";this.appendChild(A);return A});HTMLElement.prototype.__defineGetter__("innerText",function(){var A=this.ownerDocument.createRange();A.selectNodeContents(this);return A.toString()})}if(!!document.getBoxObjectFor||window.mozInnerScreenX!=null){HTMLElement.prototype.__defineSetter__("outerText",function(B){var A=document.createTextNode(B);this.parentNode.replaceChild(A,this);return A});HTMLElement.prototype.__defineGetter__("outerText",function(){var A=this.ownerDocument.createRange();A.selectNodeContents(this);return A.toString()})}}String.prototype.getBytesLength=function(){var A=this.match(/[^\x00-\xff]/ig);return this.length+(A==null?0:A.length)};String.prototype.getLimitLength=function(D,G){if(!D||D<0){return this}var A=this.getBytesLength();if(A<=D){return this}G=G==null?"..":G;D=D-G.length;var B=0;var E="";for(var F=0;F<this.length;F++){B++;E+=this.charAt(F);if(B>=D){return E+G}}return this};String.prototype.escapeHTML=function(A){try{return escapeStringToHTML(this,A)}catch(B){}return this};String.prototype.escapeUrl=function(A){try{return escapeStringToHTML(this.replace(/\n/g,""),A)}catch(B){}return this};String.prototype.escapeJavascript=function(){return escapeStringToJavascript(this)};String.prototype.escapeSpace=function(){return this.replace(/ /g,"&nbsp;")};String.prototype.escapeSameWidthSpace=function(){return this.replace(/ /g,"&nbsp;&nbsp;")};String.prototype.escapeXML=function(){return this.replace(/\&/g,"&amp;").replace(/\</g,"&lt;").replace(/\>/g,"&gt;").replace(/\"/g,"&quot;")};String.prototype.escapeQuot=function(){return this.replace(/\'/g,"&#039;").replace(/"/g,"&#034;")};String.prototype.startsWith=function(A){return this.indexOf(A)==0};String.prototype.endsWith=function(A){var B=this.indexOf(A);return B>-1&&B==this.length-A.length};String.prototype.trim=function(){var D=this.toCharArray();var A=0;var E=D.length;for(var B=0;B<D.length;B++){var F=D[B];if(F==" "){A++}else{break}}if(A==this.length){return""}for(var B=D.length;B>0;B--){var F=D[B-1];if(F==" "){E--}else{break}}return this.substring(A,E)};String.prototype.toCharArray=function(){var B=[];for(var A=0;A<this.length;A++){B[A]=this.charAt(A)}return B};Array.prototype.indexOf=function(A){for(var B=0;B<this.length;B++){if(this[B]==A){return B}}return -1};var log={rootLogger:"info",debugLevel:{debug:true,info:true,warn:true,error:true},infoLevel:{debug:false,info:true,warn:true,error:true},warnLevel:{debug:false,info:false,warn:true,error:true},errorLevel:{debug:false,info:false,warn:false,error:true},debug:function(A){if(this.isDebugEnabled()){alert("Debug : "+A)}},info:function(A){if(this.isInfoEnabled()){alert("Info : "+A)}},warn:function(A){if(this.isWarnEnabled()){alert("Warn : "+A)}},error:function(B,A){if(this.isErrorEnabled()){alert("Error : "+B+"\n\n"+A.message)}},isDebugEnabled:function(){return eval("this."+this.rootLogger+"Level.debug")},isInfoEnabled:function(){return eval("this."+this.rootLogger+"Level.info")},isWarnEnabled:function(){return eval("this."+this.rootLogger+"Level.warn")},isErrorEnabled:function(){return eval("this."+this.rootLogger+"Level.error")}};var UUID_seqence=0;function getUUID(){var A=new Date().getTime()+""+(UUID_seqence++);if(UUID_seqence>=100000){UUID_seqence=0}return A}var EmptyArrayList=new ArrayList();function ArrayList(){this.instance=new Array()}ArrayList.prototype.size=function(){return this.instance.length};ArrayList.prototype.add=function(A){this.instance[this.instance.length]=A};ArrayList.prototype.addSingle=function(A){if(!this.contains(A)){this.instance[this.instance.length]=A}};ArrayList.prototype.addAt=function(A,B){if(A>=this.size()||A<0||this.isEmpty()){this.add(B);return }this.instance.splice(A,0,B)};ArrayList.prototype.addAll=function(A){if(!A||A.length<1){return }this.instance=this.instance.concat(A)};ArrayList.prototype.addList=function(A){if(A&&A instanceof ArrayList&&!A.isEmpty()){this.instance=this.instance.concat(A.instance)}};ArrayList.prototype.get=function(A){if(this.isEmpty()){return null}if(A>this.size()){return null}return this.instance[A]};ArrayList.prototype.getLast=function(){if(this.size()<1){return null}return this.instance[this.size()-1]};ArrayList.prototype.set=function(B,D){if(B>=this.size()){throw"IndexOutOfBoundException : Index "+B+", Size "+this.size()}var A=this.instance[B];this.instance[B]=D;return A};ArrayList.prototype.removeElementAt=function(A){if(A>this.size()||A<0){return }this.instance.splice(A,1)};ArrayList.prototype.remove=function(B){var A=this.indexOf(B);this.removeElementAt(A)};ArrayList.prototype.contains=function(A,B){return this.indexOf(A,B)>-1};ArrayList.prototype.indexOf=function(D,E){for(var A=0;A<this.size();A++){var B=this.instance[A];if(B==D){return A}else{if(E!=null&&B!=null&&D!=null&&B[E]==D[E]){return A}}}return -1};ArrayList.prototype.lastIndexOf=function(D,E){for(var A=this.size()-1;A>=0;A--){var B=this.instance[A];if(B==D){return A}else{if(E!=null&&B!=null&&D!=null&&B[E]==D[E]){return A}}}return -1};ArrayList.prototype.subList=function(B,E){if(B<0){B=0}if(E>this.size()){E=this.size()}var D=this.instance.slice(B,E);var A=new ArrayList();A.addAll(D);return A};ArrayList.prototype.toArray=function(){return this.instance};ArrayList.prototype.isEmpty=function(){return this.size()==0};ArrayList.prototype.clear=function(){this.instance=new Array()};ArrayList.prototype.toString=function(A){A=A||", ";return this.instance.join(A)};function QuickSortArrayList(A,B){QuickSortArray(A.toArray(),B)}function QuickSortArray(A,B){if(B){A.sort(function(E,D){return E[B]<D[B]?-1:(E[B]==D[B]?0:1)})}else{A.sort()}}var EmptyProperties=new Properties();function Properties(A){this.instanceKeys=new ArrayList();this.instance={};if(A){this.instance=A;for(var B in A){this.instanceKeys.add(B)}}}Properties.prototype.size=function(){return this.instanceKeys.size()};Properties.prototype.get=function(B,A){if(B==null){return null}var D=this.instance[B];if(D==null&&A!=null){return A}return D};Properties.prototype.remove=function(A){if(A==null){return null}this.instanceKeys.remove(A);delete this.instance[A]};Properties.prototype.put=function(A,B){if(A==null){return null}if(this.instance[A]==null){this.instanceKeys.add(A)}this.instance[A]=B};Properties.prototype.putRef=function(A,B){if(A==null){return null}this.instanceKeys.add(A);this.instance[A]=B};Properties.prototype.getMultilevel=function(E,B){if(E==null){return null}var D=E.split(".");function A(J,H,G){try{if(J==null||(typeof J!="object")){return null}var K=J.get(H[G]);if(G<H.length-1){K=A(K,H,G+1)}return K}catch(I){}return null}var F=A(this,D,0);return F==null?B:F};Properties.prototype.containsKey=function(A){if(A==null){return false}return this.instance[A]!=null};Properties.prototype.keys=function(){return this.instanceKeys};Properties.prototype.values=function(){var E=new ArrayList();for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);if(A){var D=this.instance[A];E.add(D)}}return E};Properties.prototype.isEmpty=function(){return this.instanceKeys.isEmpty()};Properties.prototype.clear=function(){this.instanceKeys.clear();this.instance={}};Properties.prototype.swap=function(D,B){if(!D||!B||D==B){return }var F=-1;var E=-1;for(var A=0;A<this.instanceKeys.instance.length;A++){if(this.instanceKeys.instance[A]==D){F=A}else{if(this.instanceKeys.instance[A]==B){E=A}}}this.instanceKeys.instance[F]=B;this.instanceKeys.instance[E]=D};Properties.prototype.entrySet=function(){var A=[];for(var D=0;D<this.instanceKeys.size();D++){var B=this.instanceKeys.get(D);var E=this.instance[B];if(!B){continue}var F=new Object();F.key=B;F.value=E;A[A.length]=F}return A};Properties.prototype.toString=function(){var D="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);D+=A+"="+this.instance[A]+"\n"}return D};Properties.prototype.toStringTokenizer=function(F,E){F=F==null?";":F;E=E==null?"=":E;var G="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);var D=this.instance[A];if(!A){continue}if(B>0){G+=F}G+=A+E+D}return G};Properties.prototype.toQueryString=function(){if(this.size()<1){return""}var E="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);var D=this.instance[A];if(!A){continue}if(B>0){E+="&"}if(typeof D=="object"){}else{E+=A+"="+encodeURIat(D)}}return E};function encodeURIat(A){if((typeof A)!=="string"){return""}A=encodeURI(A);var B=/&|\/|\+|\?|\s|%|#|=/g;if(B.test(A)){A=A.replace(/(\/)/g,"%2F");A=A.replace(/(&)/g,"%26");A=A.replace(/(\+)/g,"%2B");A=A.replace(/(\?)/g,"%3F");A=A.replace(/(#)/g,"%23");A=A.replace(/(=)/g,"%3D")}return A}Properties.prototype.toInputString=function(){if(this.size()<1){return""}var E="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);var D=this.instance[A];if(!A){continue}if(typeof D=="object"){}else{E+="<input type='hidden' name=\""+A+'" value="'+encodeURI(D)+">"}}return E};function Set(){this.instance=new Array();this.key={}}Set.prototype.add=function(){if(arguments==null||arguments.length<1){throw"arguments is null"}for(var B=0;B<arguments.length;B++){var A=arguments[B];if(!this.contains(A)){this.instance[this.size()]=A;this.key[A]="A8"}}};Set.prototype.size=function(){return this.instance.length};Set.prototype.contains=function(A){return this.key[A]!=null};Set.prototype.isEmpty=function(){return this.size()==0};Set.prototype.clear=function(){this.instance=new Array();this.key={}};Set.prototype.get=function(A){if(this.isEmpty()){return null}if(A>this.size()){return null}return this.instance[A]};Set.prototype.toArray=function(){return this.instance};Set.prototype.toString=function(){return this.instance.join(", ")};function StringBuffer(){this._strings_=new Array()}StringBuffer.prototype.append=function(A){if(A){if(A instanceof Array){this._strings_=this._strings_.concat(A)}else{this._strings_[this._strings_.length]=A}}return this};StringBuffer.prototype.reset=function(A){this.clear();this.append(A)};StringBuffer.prototype.clear=function(){this._strings_=new Array()};StringBuffer.prototype.isBlank=function(){return this._strings_.length==0};StringBuffer.prototype.toString=function(A){A=A==null?"":A;if(this._strings_.length==0){return""}return this._strings_.join(A)};function V3X(){this.windowArgs=new Array();this.lastWindow=null;var A=navigator.userAgent;this.isMSIE=(navigator.appName=="Microsoft Internet Explorer")||A.indexOf("Trident")!=-1;this.isMSIE5=this.isMSIE&&(A.indexOf("MSIE 5")!=-1);this.isMSIE5_0=this.isMSIE&&(A.indexOf("MSIE 5.0")!=-1);this.isMSIE6=this.isMSIE&&(A.indexOf("MSIE 6")!=-1);this.isMSIE7=this.isMSIE&&(A.indexOf("MSIE 7")!=-1);this.isMSIE8=this.isMSIE&&(A.indexOf("MSIE 8")!=-1);this.isMSIE9=this.isMSIE&&(A.indexOf("MSIE 9")!=-1);this.isGecko=A.indexOf("Gecko")!=-1;this.isGecko18=A.indexOf("Gecko")!=-1&&A.indexOf("rv:1.8")!=-1;this.isSafari=A.indexOf("Safari")!=-1;this.isOpera=A.indexOf("Opera")!=-1;this.isFirefox=A.indexOf("Firefox")!=-1;this.isMac=A.indexOf("Mac")!=-1;this.isNS7=A.indexOf("Netscape/7")!=-1;this.isNS71=A.indexOf("Netscape/7.1")!=-1;this.isIpad=A.indexOf("iPad")!=-1;this.isChrome=A.indexOf("Chrome")!=-1;this.currentBrowser="";this.isMSIE10=this.isMSIE&&(A.indexOf("MSIE 10")!=-1);this.isMSIE11=this.isMSIE&&(A.indexOf("rv:11")!=-1);this.useFckEditor=this.isMSIE6;this.browserFlag={openWindow:[true,true,true,false,false,false,false],sectionOpenDetail:[true,true,true,false,true,true,false],selectPeople:[true,true,true,false,true,true,false],htmlEditer:[true,true,true,false,true,true,false],hideMenu:[true,true,true,false,true,true,false],newFlash:[true,true,true,false,true,false,false],signature:[true,true,false,false,false,false,false],createProcess:[true,true,true,false,true,true,false],flash:[true,true,true,false,true,true,false],downLoad:[true,true,true,false,true,true,false],print:[true,true,true,false,true,true,false],exportExcel:[true,true,true,false,true,true,false],pageBreak:[true,true,true,false,true,true,false],menuPosition:[false,false,false,true,false,false,false],officeMenu:[true,true,true,false,true,false,false],selectPeopleShowType:[true,true,true,false,true,true,false],OpenDivWindow:[true,true,true,false,true,true,false],selectDivType:[true,true,true,false,true,true,false],onDbClick:[true,true,true,false,true,true,true],needModalWindow:[true,true,true,false,true,true,false],onlyIe:[true,true,false,false,false,false,false]};this.isOfficeSupport=function(){return this.getBrowserFlag("officeMenu")==true};this.dialogCounter=0;this.defaultLanguage="en";this.currentLanguage="";this.baseURL="";this.loadedFiles=new Array();this.workSpaceTop=130;if(this.isMSIE8){this.workSpaceTop=140}if(!this.isMSIE7&&!this.isMSIE8){this.workSpaceTop=130}this.workSpaceLeft=0;this.workSpaceWidth=screen.width-this.workSpaceLeft;this.workSpaceheight=screen.height-this.workSpaceTop-20-(this.isMSIE7?35:0);if(this.isOpera){this.isMSIE=true;this.isGecko=false;this.isSafari=false}this.settings={dialog_type:"modal",resizable:"yes",scrollbars:"yes"}}V3X.prototype.init=function(A,B){if(A){this.baseURL=A}this.currentLanguage=B;this.loadLanguage("/common/js/i18n");this.loadScriptFile(this.baseURL+"/common/office/license.js?V=3_50_2_29");this.getCurrentBrowser()};V3X.prototype.getCurrentBrowser=function(){if(this.isMSIE||this.isMSIE5||this.isMSIE5_0||this.isMSIE7||this.isMSIE8){this.currentBrowser="MSIE"}if(this.isMSIE9){this.currentBrowser="MSIE9"}if(this.isFirefox){this.currentBrowser="FIREFOX"}if(this.isSafari){this.currentBrowser="SAFARI"}if(this.isChrome){this.currentBrowser="CHROME"}if(this.isIpad){this.currentBrowser="IPAD"}if(this.isOpera){this.currentBrowser="OPERA"}};V3X.prototype.getBrowserFlag=function(A){if(A!=null&&A!=""){var B=0;if(this.currentBrowser=="MSIE"){B=0}if(this.currentBrowser=="MSIE9"){B=1}if(this.currentBrowser=="FIREFOX"){B=2}if(this.currentBrowser=="IPAD"){B=3}if(this.currentBrowser=="CHROME"){B=4}if(this.currentBrowser=="SAFARI"){B=5}if(this.currentBrowser=="OPERA"){B=6}return this.browserFlag[A][B]}};V3X.prototype.openDialog=function(A){return new MxtWindow(A)};function commonDialogClose(winName,callBack){if(typeof (winName)=="string"){var strWinName="getA8Top()."+winName+".close()";eval(strWinName)}if(typeof (callBack)=="string"){eval(callBack)}}V3X.prototype.getEvent=function(){if(this.isMSIE){return window.event}func=v3x.getEvent.caller;while(func!=null){var A=func.arguments[0];if(A){if((A.constructor==Event||A.constructor==MouseEvent)||(typeof (A)=="object"&&A.preventDefault&&A.stopPropagation)){return A}}func=func.caller}return null};V3X.prototype.openWindow=function(B){var L,O,N,K,J,H,S,F;this.windowArgs=B;L=B.html;if(B.FullScrean){O=this.workSpaceWidth;N=this.workSpaceheight+this.workSpaceTop;K=0;J=0}else{if(B.workSpace){O=this.workSpaceWidth;N=this.workSpaceheight;K=this.workSpaceLeft;J=this.workSpaceTop;if(this.isSafari){J=J-40}}else{if(B.workSpaceRight){O=this.workSpaceWidth-155;N=this.workSpaceheight;if(this.isMSIE8){N=this.workSpaceheight-48}if(!this.isMSIE7&&!this.isMSIE8){O=this.workSpaceWidth-165;N=this.workSpaceheight-35}K=140;J=this.workSpaceTop}else{O=B.width||320;N=B.height||200;O=parseInt(O);N=parseInt(N);if(this.isMSIE){if(this.isMSIE7||this.isMSIE8){N-=6}else{N+=20}}K=B.left||parseInt(screen.width/2)-(O/2);J=B.top||parseInt(screen.height/2)-(N/2)}}}H=B.resizable||this.settings.resizable;S=B.scrollbars||this.settings.scrollbars;F=B.url;if(L){var E=window.open("","v3xPopup"+new Date().getTime(),"top="+J+",left="+K+",scrollbars="+S+",dialog=yes,minimizable="+H+",modal=yes,width="+O+",height="+N+",resizable="+H);if(E==null){return }E.document.write(L);E.document.close();E.resizeTo(O,N);E.focus();return E}else{var A=B.dialogType||this.settings.dialog_type;if(A=="modal"){var G="resizable:"+H+";scroll:"+S+";status:no;help:no;dialogWidth:"+O+"px;dialogHeight:"+N+"px;";if(B.workSpace||B.workSpaceRight||(B.left&&B.top)){G+="dialogTop:"+J+"px;dialogLeft:"+K+"px;"}else{var D=(parseInt(getA8Top().document.body.offsetWidth)-O)/2;var M=(parseInt(getA8Top().document.body.offsetHeight)-N)/2;if(D==null||M==null||D<0||M<0){D=200;M=200}G+=this.isMSIE?"center:yes;":"dialogTop:"+M+"px;dialogLeft:"+D+"px;"}var I=window.showModalDialog(F,window,G);var R=null;if(this.ModalDialogResultValue==undefined){R=I}else{R=this.ModalDialogResultValue;this.ModalDialogResultValue=undefined}return R}else{var I=null;var Q=(H=="yes")?"no":"yes";if(this.isGecko&&this.isMac){Q="no"}if(B.closePrevious!="no"){try{this.lastWindow.close()}catch(P){}}if(window.dialogArguments&&B.workSpace){J-=5;N-=25}var E=window.open(F,"v3xPopup"+new Date().getTime(),"top="+J+",left="+K+",scrollbars="+S+",dialog="+Q+",minimizable="+H+",modal="+Q+",width="+O+",height="+N+",resizable="+H);if(E==null){return }if(B.closePrevious!="no"){this.lastWindow=E}if(this.isGecko&&!this.isMSIE){if(E.document.defaultView.statusbar.visible){E.resizeBy(0,this.isMac?10:24)}}E.focus();return E}}};V3X.prototype.setResultValue=function(A){this.getParentWindow().v3x.ModalDialogResultValue=A};V3X.prototype.closeWindow=function(A){A.close()};V3X.prototype.getParentWindow=function(A){A=A||window;if(A.dialogArguments){return A.dialogArguments}else{return A.opener||A}};V3X.prototype.loadLanguage=function(A){this.loadScriptFile(this.baseURL+A+"/"+this.currentLanguage+".js?V=3_50_2_29")};V3X.prototype.isWidescreen=function(){return window.screen.width>1200};V3X.prototype.getMessage=function(key){try{var msg=eval(""+key);if(msg&&arguments.length>1){for(var i=0;i<arguments.length-1;i++){var regEx=eval("messageRegEx_"+i);var repMe=""+arguments[i+1];if(repMe.indexOf("$_")!=-1){repMe=repMe.replace("$_","$$_")}msg=msg.replace(regEx,repMe)}}return msg}catch(e){}return""};V3X.prototype.loadScriptFile=function(A){for(var B=0;B<this.loadedFiles.length;B++){if(this.loadedFiles[B]==A){return }}document.write('<script language="javascript" type="text/javascript" charset="UTF-8" src="'+A+'"><\/script>');this.loadedFiles[this.loadedFiles.length]=A};V3X.prototype.getElementPosition=function(E){var A=navigator.userAgent.toLowerCase();var B=(A.indexOf("opera")!=-1);var F=(A.indexOf("msie")!=-1&&!B);if(E.parentNode===null||E.style.display=="none"){return false}var L=null;var K=[];var I;if(E.getBoundingClientRect){I=E.getBoundingClientRect();var D=Math.max(document.documentElement.scrollTop,document.body.scrollTop);var G=Math.max(document.documentElement.scrollLeft,document.body.scrollLeft);return{x:I.left+G,y:I.top+D}}else{if(document.getBoxObjectFor){I=document.getBoxObjectFor(E);var J=(E.style.borderLeftWidth)?parseInt(E.style.borderLeftWidth):0;var H=(E.style.borderTopWidth)?parseInt(E.style.borderTopWidth):0;K=[I.x-J,I.y-H]}else{K=[E.offsetLeft,E.offsetTop];L=E.offsetParent;if(L!=E){while(L){K[0]+=L.offsetLeft;K[1]+=L.offsetTop;L=L.offsetParent}}if(A.indexOf("opera")!=-1||(A.indexOf("safari")!=-1&&E.style.position=="absolute")){K[0]-=document.body.offsetLeft;K[1]-=document.body.offsetTop}}}if(E.parentNode){L=E.parentNode}else{L=null}while(L&&L.tagName!="BODY"&&L.tagName!="HTML"){K[0]-=L.scrollLeft;K[1]-=L.scrollTop;if(L.parentNode){L=L.parentNode}else{L=null}}return{x:K[0],y:K[1]}};function disableButton(D,A){A=A||"100%";if(!D){return false}var E=null;if(typeof D=="string"){E=document.getElementById(D)}else{E=D}if(!E){return false}if(document.readyState!="complete"){if(typeof D=="string"){window.setTimeout("disableButton('"+D+"')",2500)}else{window.setTimeout("disableButton("+D+")",2500)}return }var B=E.cDisabled;B=(B!=null);if(!B){E.cDisabled=true;if(document.getElementsByTagName){var F="<span style='background: buttonshadow; filter: chroma(color=white) dropshadow(color=buttonhighlight, offx=1, offy=1); height: "+A+";'>";F+="  <span style='filter: mask(color=white); height: "+A+"'>";F+=E.innerHTML;F+="  </span>";F+="</span>";E.innerHTML=F}else{E.innerHTML='<span style="background: buttonshadow; width: 100%; height: 100%; text-align: center;"><span style="filter:Mask(Color=buttonface) DropShadow(Color=buttonhighlight, OffX=1, OffY=1, Positive=0); height: 100%; width: 100%; text-align: center;">'+E.innerHTML+"</span></span>"}if(E.onclick!=null){E.cDisabled_onclick=E.onclick;E.onclick=null}if(E.onmouseover!=null){E.cDisabled_onmouseover=E.onmouseover;E.onmouseover=null}if(E.onmouseout!=null){E.cDisabled_onmouseout=E.onmouseout;E.onmouseout=null}}}function enableButton(B){if(!B){return false}var D=null;if(typeof B=="string"){D=document.getElementById(B)}else{D=B}if(!D){return false}var A=D.cDisabled;A=(A!=null);if(A){D.cDisabled=null;D.innerHTML=D.children[0].children[0].innerHTML;if(D.cDisabled_onclick!=null){D.onclick=D.cDisabled_onclick;D.cDisabled_onclick=null}if(D.cDisabled_onmouseover!=null){D.onmouseover=D.cDisabled_onmouseover;D.cDisabled_onmouseover=null}if(D.cDisabled_onmouseout!=null){D.onmouseout=D.cDisabled_onmouseout;D.cDisabled_onmouseout=null}}}var attachmentConstants={height:18};function downloadAttachment(A,E,B){var D=v3x.baseURL;var G=document.forms.downloadFileForm;if(!G){var F=document.createElement("<form name='downloadFileForm' action='"+D+"/fileUpload.do' method='get' target='downloadFileFrame' style='margin:0px;padding:0px'></form>");document.body.appendChild(F);F.appendChild(document.createElement("<input type='hidden' name='method' value='download'>"));F.appendChild(document.createElement("<input type='hidden' name='viewMode' value='download'>"));F.appendChild(document.createElement("<input type='hidden' name='fileId' value=''>"));F.appendChild(document.createElement("<input type='hidden' name='createDate' value=''>"));F.appendChild(document.createElement("<input type='hidden' name='filename' value=''>"));G=document.forms.downloadFileForm}G.fileId.value=A;G.createDate.value=E;G.filename.value=B;G.submit()}function Attachment(D,G,Q,F,I,B,E,O,R,P,N,H,M,K,J,A,L){this.id=D;this.reference=G;this.subReference=Q;this.category=F;this.type=I;this.filename=B;this.mimeType=E;this.createDate=O;this.size=R;this.fileUrl=P;this.description=N||"";this.needClone=H;this.extension=M;this.icon=K;this.isCanTransform=A=="true"?true:false;this.onlineView=J==null?true:J;this.extReference="";this.extSubReference="";this.showArea="";this.v=L}Attachment.prototype.show=function(D,B,A){document.write(this.toString(D,B,A))};var allowTransType=["doc","docx","xls","xlsx","ppt","pptx","rtf","eio"];Attachment.prototype.allowTrans=function(){if(this.type!=0&&this.type!=3){return false}if(parseInt(this.size)>5242880){return false}var A=this.filename.toLowerCase();for(var B=0;B<allowTransType.length;B++){if(A.endsWith("."+allowTransType[B])){return true}}return false};var imgType=["jpg","gif","jpeg","png","bmp"];Attachment.prototype.isImg=function(){if(this.type!=0&&this.type!=3){return false}var A=this.filename.toLowerCase();for(var B=0;B<imgType.length;B++){if(A.endsWith("."+imgType[B])){return true}}return false};var pdfType=["pdf"];Attachment.prototype.isPdf=function(){if(this.type!=0&&this.type!=3){return false}var A=this.filename.toLowerCase();for(var B=0;B<pdfType.length;B++){if(A.endsWith("."+pdfType[B])){return true}}return false};Attachment.prototype.toString=function(B,H,I,A){var D=v3x.baseURL;var G="";G+="<div id='attachmentDiv_"+this.fileUrl+"' class='attachment_block' style='font-size:12px; float: left;height: "+attachmentConstants.height+"px; line-height: 14px;' noWrap>";if(this.type!=1){G+="<img src='"+D+"/common/images/attachmentICON/"+this.icon+"' border='0' height='16' width='16' align='absmiddle' style='margin-right: 3px;'>"}if(B&&(this.type==0||this.type==3||this.type==5)){if(this.type==3){G+="<a onclick='downloadAttachment(\""+this.fileUrl+'","'+this.createDate.substring(0,10)+'","'+escapeStringToHTML(this.filename)+'")\' title="'+escapeStringToHTML(this.filename)+"\" target='downloadFileFrame' style='font-size:12px;color:#007CD2;' class='like-a'>"}else{G+='<a href="'+D+"/file"+(this.v?"Download":"Upload")+".do?method=download&fileId="+this.fileUrl+(this.v?("&v="+this.v):"")+"&createDate="+this.createDate.substring(0,10)+"&filename="+encodeURIComponent(this.filename)+'" title="'+escapeStringToHTML(this.filename)+"\" target='downloadFileFrame' style='font-size:12px;color:#007CD2;'>"}}if(I){G+="<a onclick=\"editOfficeOnline('"+this.id+'\')" title="'+escapeStringToHTML(this.filename)+"\" target='downloadFileFrame' style='font-size:12px;color:#007CD2;' class='like-a'>";B=true}if((this.type==2||this.type==4)&&this.description&&(I!=false)){var K="";var J="";if(this.type==4){try{if(parent.parent.openerSummaryId&&parent.parent.openerSummaryId!=this.reference){J="&openerSummaryId="+parent.parent.openerSummaryId}else{if(noFlowRecordId){J="&noFlowRecordId="+noFlowRecordId}}}catch(F){}}if(this.mimeType=="collaboration"){K="openDetailURL('"+colURL+"?method=summary&openFrom=glwd&affairId="+this.description+"&baseObjectId="+this.reference+"&baseApp="+this.category+J+"')"}if(this.mimeType=="edoc"){K="openDetailURL('"+edocDetailURL+"?method=detailIFrame&from=Done&openFrom=glwd&affairId="+this.description+"&isQuote=true&baseObjectId="+this.reference+"&baseApp="+this.category+"')"}else{if(this.mimeType=="km"){K="openDetailURL('"+docURL+"?method=docOpenIframeOnlyId&openFrom=glwd&docResId="+this.description+"&baseObjectId="+this.reference+"&baseApp="+this.category+J+"')"}else{if(this.mimeType=="meeting"){K="openDetailURL('"+mtMeetingUrl+"?method=myDetailFrame&id="+this.description+"&isQuote=true&baseObjectId="+this.reference+"&baseApp="+this.category+"&state=10');"}}}G+='<a class="like-a" onclick="'+K+'" title="'+escapeStringToHTML(this.filename)+"\" style='font-size:12px;color:#007CD2;'>";B=true}if(this.type!=1){var E=17;G+=this.filename.getLimitLength(E).escapeHTML()}if(this.size&&this.type==0){G+="("+(parseInt(this.size/1024)+1)+"KB)"}if(B){G+="</a>"}if(B&&this.onlineView==true&&this.allowTrans()&&this.isCanTransform){G+='<a href="'+D+"/officeTrans.do?method=view&fileId="+this.fileUrl+"&createDate="+this.createDate.substring(0,10)+"&filename="+encodeURIComponent(this.filename)+"\" target='downloadFileFrame' style='font-size:12px;color:#007CD2;' title='"+v3x.getMessage("V3XLang.OfficeTrans_view")+'\'><span class="ico16 view_attachments_16"></span></a>'}else{if(this.hasSaved&&this.isImg()){G+='<a onclick=preViewDialog("'+D+"/fileUpload.do?method=showRTE&type=image&fileId="+this.fileUrl2+"&createDate="+this.createDate.substring(0,10)+"&filename="+encodeURIComponent(this.filename)+"\")  style='font-size:12px;color:#007CD2;' title='"+v3x.getMessage("V3XLang.OfficeTrans_view")+'\'><span class="ico16 view_attachments_16"></span></a>'}else{if(this.hasSaved&&this.isPdf()){G+='<a onclick=preViewDialog("'+D+"/fileDownload.do?method=doDownload4Office&type=Pdf&isOpenFile=true&fileId="+this.fileUrl2+"&createDate="+this.createDate.substring(0,10)+"&filename="+encodeURIComponent(this.filename)+"&v="+this.v+"\")   style='font-size:12px;color:#007CD2;' title='"+v3x.getMessage("V3XLang.OfficeTrans_view")+'\'><span class="ico16 view_attachments_16"></span></a>'}}}if(H){if(this.type==4||this.type==3){G+="<img src='"+D+"/common/images/attachmentICON/delete.gif' onclick='deleteAtt4Form(this)' fileName=\""+this.filename+'" fileUrl="'+this.fileUrl+"\" class='cursor-hand' title='"+v3x.getMessage("V3XLang.attachment_delete")+"' height='11' align='absmiddle'>"}else{if(this.type==5){G+="<img src='"+D+"/common/images/attachmentICON/delete.gif' onclick='deleteAttachmentForImage(\""+this.fileUrl+"\")' class='cursor-hand' title='"+v3x.getMessage("V3XLang.attachment_delete")+"' height='11' align='absmiddle'>"}else{G+="<img src='"+D+"/common/images/attachmentICON/delete.gif' onclick='deleteAttachment(\""+this.fileUrl+"\")' class='cursor-hand' title='"+v3x.getMessage("V3XLang.attachment_delete")+"' height='16' align='absmiddle'>"}}}G+='&nbsp;<input type="hidden" name="input_file_id"   value="'+this.fileUrl+'" / >&nbsp;';G+="&nbsp;</div>";return G};function deleteAtt4Form(B){var A=B.getAttribute?B.getAttribute("fileUrl"):B.fileUrl;var D=B.getAttribute?B.getAttribute("fileName"):B.fileName;deleteAttachmentForForm(A,D)}function openDetailURL(A){var B=v3x.openWindow({url:A,dialogType:"open",workSpace:"yes"})}Attachment.prototype.toInput=function(){var A="";A+="<input type='hidden' name='attachment_id' value='"+this.id+"'>";A+="<input type='hidden' name='attachment_reference' value='"+this.reference+"'>";A+="<input type='hidden' name='attachment_subReference' value='"+this.subReference+"'>";A+="<input type='hidden' name='attachment_category' value='"+this.category+"'>";A+="<input type='hidden' name='attachment_type' value='"+this.type+"'>";A+="<input type='hidden' name='attachment_filename' value='"+escapeStringToHTML(this.filename)+"'>";A+="<input type='hidden' name='attachment_mimeType' value='"+this.mimeType+"'>";A+="<input type='hidden' name='attachment_createDate' value='"+this.createDate+"'>";A+="<input type='hidden' name='attachment_size' value='"+this.size+"'>";A+="<input type='hidden' name='attachment_fileUrl' value='"+this.fileUrl+"'>";A+="<input type='hidden' name='attachment_description' value='"+this.description+"'>";A+="<input type='hidden' name='attachment_needClone' value='"+this.needClone+"'>";A+="<input type='hidden' name='attachment_extReference' value='"+this.extReference+"'>";A+="<input type='hidden' name='attachment_extSubReference' value='"+this.extSubReference+"'>";return A};Attachment.prototype.toContentInput=function(){var A="";A+="<input type='hidden' name='content_attachment_id' value='"+this.id+"'>";A+="<input type='hidden' name='content_attachment_reference' value='"+this.reference+"'>";A+="<input type='hidden' name='content_attachment_subReference' value='"+this.subReference+"'>";A+="<input type='hidden' name='content_attachment_category' value='"+this.category+"'>";A+="<input type='hidden' name='content_attachment_type' value='"+this.type+"'>";A+="<input type='hidden' name='content_attachment_filename' value='"+escapeStringToHTML(this.filename)+"'>";A+="<input type='hidden' name='content_attachment_mimeType' value='"+this.mimeType+"'>";A+="<input type='hidden' name='content_attachment_createDate' value='"+this.createDate+"'>";A+="<input type='hidden' name='content_attachment_size' value='"+this.size+"'>";A+="<input type='hidden' name='content_attachment_fileUrl' value='"+this.fileUrl+"'>";A+="<input type='hidden' name='content_attachment_description' value='"+this.description+"'>";A+="<input type='hidden' name='content_attachment_needClone' value='"+this.needClone+"'>";return A};Attachment.prototype.toJson=function(){return'{id:"'+this.id+'", reference:"'+this.reference+'", subReference:"'+this.subReference+'", category:"'+this.category+'", type:"'+this.type+'", filename:"'+escapeStringToHTML(this.filename)+'", mimeType:"'+this.mimeType+'", createDate:"'+this.createDate+'", size:"'+this.size+'", fileUrl:"'+this.fileUrl+'", description:"'+this.description+'", needClone:"'+this.needClone+'",extension:"'+this.extension+'",icon:"'+this.icon+'",extReference:"'+this.extReference+'",extSubReference:"'+this.extSubReference+'"}'};function showAttachment(L,K,B,A,E){try{if(!theToShowAttachments){return }var D=0;var J="";for(var F=0;F<theToShowAttachments.size();F++){var I=theToShowAttachments.get(F);if(I.subReference==L&&I.type==K){J+=I.toString(true,false);D++}}if(!E){document.write(J);document.close()}else{var N=document.getElementById(E);N.innerHTML=J}if(D>0){if(B){var M=document.getElementById(B);if(M){M.style.display=""}}if(A){var G=document.getElementById(A);if(G){G.innerHTML=""+D}}}else{if(B){var M=document.getElementById(B);if(M){M.style.display="none"}}}if(A){var G=document.getElementById(A);if(G){G.innerHTML=""+D}}}catch(H){}}function exportAttachment(D){if(D.getAttribute("expand")){return }var B=D.className;D.className="div-float";var A=D.scrollHeight;if(A>=(attachmentConstants.height*2)){D.className="attachment-all-80"}else{D.className=B}D.setAttribute("expand","yes")}var fileUploadAttachments=new Properties();var fileUploadAttachment=null;var fileUploadQuantity=5;var attachObject="";var atttachTr="";var attachDelete;var attachCount=true;var theHasDeleteAtt=new Properties();var attFileType=new Properties();function isUploadAttachment(){return !fileUploadAttachments.isEmpty()}function resetAttachment(E,B,D,A){attachObject=E;atttachTr=B;attachDelete=D;attachCount=A;fileUploadAttachment=new Properties()}function clearUploadAttachments(){attachObject="";atttachTr="";attachDelete=null;attachCount=true;fileUploadAttachment.clear();fileUploadAttachment=null}function saveAttachment(B,F){var G=null;if(fileUploadAttachment!=null){G=fileUploadAttachment.values()}else{G=fileUploadAttachments.values()}var E=B||document.getElementById("attachmentInputs")||document.getElementById("attachmentEditInputs");if(!F||F!="false"){if(!G||G.size()<=0){if(E&&attActionLog){E.innerHTML=attActionLog.toInput()}return true}}var A="";for(var D=0;D<G.size();D++){A+=G.get(D).toInput()}if(E){E.innerHTML=A;if(!F||F!="false"){if(attActionLog){E.innerHTML+=attActionLog.toInput()}}}else{alert("Warn: Save attachments unsuccessful");return false}return true}function saveContentAttachment(B){var F=null;if(fileUploadAttachment!=null){F=fileUploadAttachment.values()}else{F=fileUploadAttachments.values()}var A="";for(var D=0;D<F.size();D++){A+=F.get(D).toContentInput()}var E=B||parent.detailRightFrame.document.getElementById("contentAttachmentInputs");if(E){E.innerHTML=A;E.innerHTML+="<input type='hidden' name='isContentAttchmentChanged' value='1'>"}else{alert("Warn: Save attachments unsuccessful");return false}return true}function getAttachmentsToMap(){var D=fileUploadAttachments.values();if(!D||D.isEmpty()){return true}var A="";for(var B=0;B<D.size();B++){A+=D.get(B).toMap()}if(A!=null){return A}}Attachment.prototype.toMap=function(){var A="#attachment_id="+this.id+";";A+="attachment_reference"+this.reference+";";A+="attachment_subReference="+this.subReference+";";A+="attachment_category="+this.category+";";A+="attachment_type="+this.type+";";A+="attachment_filename="+escapeStringToHTML(this.filename)+";";A+="attachment_mimeType="+this.mimeType+";";A+="attachment_createDate="+this.createDate+";";A+="attachment_size="+this.size+";";A+="attachment_fileUrl="+this.fileUrl+";";A+="attachment_description="+this.description+";";A+="attachment_needClone="+this.needClone+";";return A};function cloneAllAttachments(){var B=fileUploadAttachments.values();for(var A=0;A<B.size();A++){B.get(A).needClone=true}}function deleteAttachment(A,F){var D=fileUploadAttachments.get(A);if(D==null){return }if(F!=false){if(D.type=="2"){if(!confirm(v3x.getMessage("V3XLang.attachent_delete_relation_alert",D.filename))){return 1}}else{if(!confirm(v3x.getMessage("V3XLang.attachment_delete_alert",D.filename))){return 1}}}fileUploadAttachments.remove(A);document.getElementById("attachmentDiv_"+A).parentNode.removeChild(document.getElementById("attachmentDiv_"+A));showAttachmentNumber(D.type);var B=getFileAttachmentNumber(D.type);if(B<1){if(!(typeof (_updateAttachmentState)!="undefined"&&_updateAttachmentState)){showAtachmentTR(D.type,"none")}}var G=document.getElementById("attachmentInputs");var E=document.getElementById("canUpdateAttachmentFromSended");if(E&&E.value=="submit"){updateAttachment("del",G)}if(typeof (removeChanged)!="undefined"){removeChanged=true}if(typeof (deletAttrCallBackFun)!="undefined"){deletAttrCallBackFun()}resizeFckeditor()}function deleteAttachmentForImage(A,E){var D=deleteAttachment(A,E);var B=document.getElementById("imageId");if(B&&D!=1){B.value=""}}function insertAttachment(){var A=downloadURL+"&quantity="+fileUploadQuantity;if(arguments&&arguments[0]){A+="&selectRepeatSkipOrCover="+arguments[0];if(arguments[1]){A+=arguments[1]}}if(arguments&&arguments[2]){A+="&callMethod="+arguments[2]}if(arguments&&arguments[3]){A+="&takeOver="+arguments[3]}getA8Top().addattachDialog=null;if(getA8Top().isCtpTop||getA8Top()._ctxPath){getA8Top().addattachDialog=getA8Top().$.dialog({title:v3x.getMessage("V3XLang.attachent_title"),transParams:{parentWin:window},url:A,width:400,height:300,resizable:"yes"})}else{getA8Top().addattachDialog=getA8Top().v3x.openDialog({title:v3x.getMessage("V3XLang.attachent_title"),transParams:{parentWin:window},url:A,width:400,height:300,resizable:"yes"})}resizeFckeditor()}function preViewDialog(A){getA8Top().addattachDialog=null;if(getA8Top().isCtpTop||getA8Top()._ctxPath){getA8Top().addattachDialog=getA8Top().$.dialog({title:v3x.getMessage("V3XLang.OfficeTrans_view"),transParams:{parentWin:window},url:A,width:1280,height:800,resizable:"yes"})}else{getA8Top().addattachDialog=getA8Top().v3x.openDialog({title:v3x.getMessage("V3XLang.OfficeTrans_view"),transParams:{parentWin:window},url:A,width:1280,height:800,resizable:"yes"})}}function insertCorrelationFile(){getA8Top().addassDialog=null;assUrl=v3x.baseURL+"/ctp/common/associateddoc/assdocFrame.do?isBind=1,3";if(arguments&&arguments[0]){assUrl+="&callMethod="+arguments[0]}if(getA8Top().isCtpTop){getA8Top().addassDialog=getA8Top().$.dialog({title:v3x.getMessage("V3XLang.assdoc_title"),transParams:{parentWin:window},url:assUrl,width:1000,height:600})}else{getA8Top().addassDialog=getA8Top().v3x.openDialog({title:v3x.getMessage("V3XLang.assdoc_title"),transParams:{parentWin:window},url:assUrl,width:1000,height:600})}}function quoteDocumentCallback(E){try{activeOcx()}catch(D){}if(E){deleteAllAttachment(2);for(var B=0;B<E.length;B++){var A=E[B];addAttachment(A.type,A.filename,A.mimeType,A.createDate,A.size,A.fileUrl,true,false,A.description,null,A.mimeType+".gif")}}}function insertRelFile4Project(){var D=v3x.openWindow({url:v3x.baseURL+"/ctp/common/associateddoc/assdocFrame.do?isBind=1,3",height:600,width:800});activeOcx();if(D){deleteAllAttachment(2);for(var B=0;B<D.length;B++){var A=D[B];addAttachment(A.type,A.filename,A.mimeType,A.createDate,A.size,A.fileUrl,true,false,A.description,null,A.mimeType+".gif")}}resizeFckeditor()}function addAttachment(E,Q,G,F,N,M,S,D,R,I,T,H,P,A,O,B,K,L){S=S==null?true:S;D=D==null?false:D;R=R==null?"":R;if(attachDelete!=null){S=attachDelete}if(!H){H=""}if(!P){P=""}var J=new Attachment("",H,"",P,E,Q,G,F,N,M,R,D,I,T,A,B,L);J.showArea="";if(fileUploadAttachment!=null){if(fileUploadAttachment.containsKey(M)){return }fileUploadAttachment.put(M,J)}else{if(fileUploadAttachments.containsKey(M)){return }fileUploadAttachments.put(M,J)}showAtachmentObject(J,S,O);showAtachmentTR(E);if(attachCount){showAttachmentNumber(E)}if(typeof (currentPage)!="undefined"&&currentPage=="newColl"){addScrollForDocument()}resizeFckeditor()}function AttActionLog(A,E,B,D){this.reference=A;this.subReference=E;this.logs=B;this.editAtt=D}AttActionLog.prototype.toInput=function(){var A="";if(this.logs&&!this.logs.isEmpty()){A+="<input type='hidden' name='reference' value='"+this.reference+"'>";A+="<input type='hidden' name='subReference' value='"+this.subReference+"'>";A+="<input type='hidden' name='isEditAttachment' value='1'/>";A+="<input type='hidden' name='editAttachmentSize' value='"+this.editAtt.size()+"'/>";for(var B=0;B<this.logs.size();B++){A+=this.logs.get(B).toInput()}for(var B=0;B<this.editAtt.size();B++){A+=this.editAtt.get(B).toInput()}}return A};function ActionLog(D,A,B){this.action=D;this.createDate=A;this.des=B}ActionLog.prototype.toInput=function(){var A="";A+="<input type='hidden' name='logAction' value='"+this.action+"'>";A+="<input type='hidden' name='logCreateDate' value='"+this.createDate+"'>";A+="<input type='hidden' name='logDesc' value='"+this.des+"'>";return A};function copyActionLog(B){var A=new ActionLog(B.action,B.createDate,B.des);return A}function copyAttachment(B){var A=new Attachment(B.id,B.reference,B.subReference,B.category,B.type,B.filename,B.mimeType,B.createDate,B.size,B.fileUrl,B.description,B.needClone,B.extension,B.icon);A.onlineView=B.onlineView;A.extReference=B.extReference;A.extSubReference=B.extSubReference;A.v=B.v;return A}var attActionLog=null;var editAttachmentsCallbackParam={};function editAttachments(H,B,G,E,F){if(attActionLog==null){attActionLog=new AttActionLog(B,G,null,H)}B=B||"";G=G||"";editAttachmentsCallbackParam={};editAttachmentsCallbackParam.callbackFn=F;var D=getA8Top().v3x.baseURL+"/genericController.do?ViewPage=apps/collaboration/fileUpload/attEdit&category="+E+"&reference="+B+"&subReference="+G+"&_isModalDialog=true&isEdocAtt=true";if(getA8Top().$&&getA8Top().$.dialog){window.v3x_editAttachments_win=getA8Top().$.dialog({title:"\u4fee\u6539\u9644\u4ef6",transParams:{parentWin:window,popWinName:"v3x_editAttachments_win",popCallbackFn:editAttachmentsCallback},url:D,targetWindow:getA8Top(),width:"550",height:"430"})}else{if(getA8Top().v3x&&getA8Top().v3x.openDialog){window.v3x_editAttachments_win=getA8Top().v3x.openDialog({title:"\u4fee\u6539\u9644\u4ef6",transParams:{parentWin:window,popWinName:"v3x_editAttachments_win",popCallbackFn:editAttachmentsCallback},url:D,targetWindow:getA8Top(),width:"550",height:"430"})}else{var A=v3x.openWindow({url:D,width:550,height:430,resizable:"yes"});editAttachmentsCallback(A)}}}function editAttachmentsCallback(J){var G=editAttachmentsCallbackParam.callbackFn;var E=null;if(J){var A=new ArrayList();var D=J[0].instance;for(var B=0;B<D.length;B++){var H=copyAttachment(D[B]);H.onlineView=false;A.add(H)}var I=new ArrayList();D=J[1].instance;if(D.length==0){E=false}else{for(var B=0;B<D.length;B++){var H=copyActionLog(D[B]);I.add(H)}var F=saveEditAttachments(I,A);if(!F){E=null}else{E=attActionLog.editAtt}}}if(G){G(E)}}function saveEditAttachments(B,A){if(!attActionLog||B.size()==0){return false}if(attActionLog.logs){attActionLog.logs.addList(B)}else{attActionLog.logs=B}attActionLog.editAtt=A;return true}function getAttachment(B,G,F){var A=new ArrayList();for(var E=0;E<theToShowAttachments.size();E++){var D=theToShowAttachments.get(E);if(((B&&D.reference==B)||!B)&&((G&&D.subReference==G)||!G)&&((F&&D.type==F)||!F)){A.add(D)}}return A}function updateAttachmentMemory(D,A,H,F){var G=getAttachment(A,H,F);for(var E=0;E<G.size();E++){var B=G.get(E);theToShowAttachments.remove(B)}for(var E=0;E<D.size();E++){theToShowAttachments.add(D.get(E))}}function updateAttachment(A,B){saveContentAttachment(B);updateAttachmentOnly(A)}function updateAttachmentOnly(A){$("#attchmentForm").ajaxSubmit({url:genericURL+"?method=updateAttachment&edocSummaryId="+edocSummaryId+"&affairId="+affairId,type:"POST",success:function(B){}})}function deleteAllAttachment(B){var E=fileUploadAttachments.keys();for(var D=0;D<E.size();D++){var A=fileUploadAttachments.get(E.get(D));if(A.type==B){fileUploadAttachments.remove(E.get(D));D-=1}}var H="attachmentArea";if(B!=0){H="attachment"+B+"Area"}var G=document.getElementById(H);if(G){G.style.display="";G.innerHTML=""}var H="attachmentTR";if(B!=0){H="attachment"+B+"TR"}var F=document.getElementById(H);if(F){F.style.display="none"}}function showUpdateAttachment(K){if(_updateAttachmentState){return }var M=document.getElementById("attachmentTr");if(M){M.style.display=""}var H=document.getElementById("normalText");if(H){H.style.display="none"}var E=document.getElementById("uploadAttachmentTR");if(E){E.style.display=""}if(!theToShowAttachments){return }var F=document.getElementById("attachmentArea");var A=document.getElementById("attachment2Area");var D=v3x.baseURL;for(var G=0;G<theToShowAttachments.size();G++){var J=theToShowAttachments.get(G);if(J.type==0&&J.type==K){var I=document.getElementById("attachmentDiv_"+J.fileUrl);if(I){var L=I.getElementsByTagName("a");if(L){var B="<img src='"+D+"/common/images/attachmentICON/delete.gif' onclick='deleteAttachment(\""+J.fileUrl+"\")' class='cursor-hand' title='"+v3x.getMessage("V3XLang.attachment_delete")+"' height='16' align='absmiddle'>";L[0].insertAdjacentHTML("afterEnd",B)}}}else{if(J.type==2&&J.type==K){var I=document.getElementById("attachmentDiv_"+J.fileUrl);if(I){var L=I.getElementsByTagName("a");if(L){var B="<img src='"+D+"/common/images/attachmentICON/delete.gif' onclick='deleteAttachment(\""+J.fileUrl+"\")' class='cursor-hand' title='"+v3x.getMessage("V3XLang.attachment_delete")+"' height='16' align='absmiddle'>";L[0].insertAdjacentHTML("afterEnd",B)}}}}}_updateAttachmentState=true}function showAtachmentObject(E,A,B){if(!E){return }var F="attachmentArea";if(E.type!=0){F="attachment"+E.type+"Area"}if(attachObject){F=attachObject}var D=document.getElementById(F);if(D){D.style.display="";D.innerHTML+=E.toString(true,A,undefined,B)}}function showAtachmentTR(B,A){var E="attachmentTR";if(B!=0){E="attachment"+B+"TR"}if(atttachTr){E=atttachTr}var D=document.getElementById(E);if(D){A=A||"";D.style.display=A}}function showAttachmentNumber(A){var E="attachmentNumberDiv";if(A!=0){E="attachment"+A+"NumberDiv"}var B=document.getElementById(E);if(B){try{B.innerText=getFileAttachmentNumber(A)}catch(D){}}}function getFileAttachmentNumber(B){var E=0;var D=fileUploadAttachments.values();if(!D){return E}for(var A=0;A<D.size();A++){if(D.get(A).type==B){E++}}return E}function getFileAttachmentName(D){var F=fileUploadAttachments.values();if(!F){return""}var E="";for(var B=0;B<F.size();B++){var A=F.get(B);if(A.type==D){E+="<div id='attachmentDiv_"+A.fileUrl+"' style='float: left;height: "+attachmentConstants.height+"px; line-height: 14px;' noWrap>";E+="<img src='"+v3x.baseURL+"/common/images/attachmentICON/"+A.icon+"' border='0' height='16' width='16'                                                    align='absmiddle' style='margin-right: 3px;'/>";E+=A.filename;E+="&nbsp;</div>"}}return E}function getSenderAttachmentName(A,E){var G=parent.theToShowAttachments;if(!G){return""}var F="";for(var D=0;D<G.size();D++){var B=G.get(D);if(B.type==E&&B.subReference==A){F+="<div id='attachmentDiv_"+B.fileUrl+"' style='float: left;height: "+attachmentConstants.height+"px; line-height: 14px;' noWrap>";F+="<img src='"+v3x.baseURL+"/common/images/attachmentICON/"+B.icon+"' border='0' height='16' width='16'                                                    align='absmiddle' style='margin-right: 3px;'/>";F+=B.filename;F+="&nbsp;</div>"}}return F}function Element(E,H,D,B,G,A,F){this.type=E;this.id=H;this.name=D;this.typeName=B;this.accountId=G||"";this.accountShortname=A||"";this.description=F;this.entity=null;this.isEnabled=true;this.excludeChildDepartment=false}Element.prototype.copy=function(A){this.type=A.type;this.id=A.id;this.name=A.name;this.typeName=A.typeName;this.accountId=A.accountId;this.accountShortname=A.accountShortname;this.description=A.description;this.isEnabled=A.isEnabled;this.excludeChildDepartment=A.excludeChildDepartment};Element.prototype.toString=function(){return this.type+"\t"+this.id+"\t"+this.name+"\t"+this.typeName+"\t"+this.accountId+"\t"+this.accountShortname};function getNamesString(F,B){if(!F){return""}var E=v3x.getMessage("V3XLang.common_separator_label")||B;var H=[];for(var D=0;D<F.length;D++){var G=F[D];var A=null;if(G.accountShortname){A=G.name+"("+G.accountShortname+")"}else{A=G.name}H[H.length]=A}return H.join(E)}function getFullNamesString(A){if(!A){return""}var B=v3x.getMessage("V3XLang.common_separator_label");var N=[];var L="";for(var G=0;G<A.length;G++){if(A[G].type=="Department"){L+=A[G].id+","}}if(L!=""){L=L.substring(0,L.length-1);var E=document.getElementById("orgAccountId");var J=new XMLHttpRequestCaller(this,"ajaxOrgManager","getParentDepartmentFullName",false);J.addParameter(1,"String",L);J.addParameter(2,"long",E.value);var F=J.serviceRequest();if(F!=null){N=F.split(",")}}var D=0;var K=[];for(var G=0;G<A.length;G++){var H=A[G];var M=null;if(H.type=="Department"){M=N[D];D++}else{if(H.accountShortname){var I=document.getElementById("appName");if(I&&I.value=="4"){if(H.type=="Account"||(E&&E.value==H.accountId)){M=H.name}else{M=H.accountShortname+H.name}}else{M=H.name+"("+H.accountShortname+")"}}else{M=H.name}}K[K.length]=M}return K.join(B)}function getIdsString(D,F){if(!D){return""}if(F==null){F=true}var E=[];for(var B=0;B<D.length;B++){var A=null;if(F){A=D[B].type+"|"+D[B].id}else{A=D[B].id}E[E.length]=A+(D[B].excludeChildDepartment?"|1":"")}return E.join(",")}function parseElements(G){if(!G||G=="null"){return null}var E=[];var A=G.split(",");for(var D=0;D<A.length;D++){if(!A[D]){continue}var F=A[D].split("|");if(F.length>3){var B=new Element(F[0],F[1],F[2],null,F[3],null,"");if(F.length>4){B.isEnabled=(F[4]=="true")}E[E.length]=B}}return E}function parseElements4Exclude(H,E){if(!H||H=="null"){return null}var F=[];var A=H.split(",");for(var D=0;D<A.length;D++){if(!A[D]){continue}if(E){F[F.length]=new Element(E,A[D])}else{var G=A[D].split("|");if(G.length==2){var B=new Element(G[0],G[1]);F[F.length]=B}}}return F}function getIdsInput(D,A,F){if(!D){return""}if(F==null){F=true}var E="";for(var B=0;B<D.length;B++){if(F){E+="<input type='hidden' name='"+A+"' value=\""+D[B].type+"|"+D[B].id+'">'}else{E+="<input type='hidden' name='"+A+"' value=\""+D[B].id+'">'}}return E}var AJAX_XMLHttpRequest_DEFAULT_METHOD="POST";var AJAX_XMLHttpRequest_DEFAULT_async=true;var AJAX_RESPONSE_XML_TAG_BEAN="B";var AJAX_RESPONSE_XML_TAG_LIST="L";var AJAX_RESPONSE_XML_TAG_Value="V";var AJAX_RESPONSE_XML_TAG_Property="P";var AJAX_RESPONSE_XML_TAG_Name="n";function AjaxParameter(){this.instance=[]}AjaxParameter.prototype.put=function(B,D,E){var A=D.indexOf("[]")>-1;this.instance[this.instance.length]={index:B,type:A?D.substring(0,D.length-2):D,value:E,isArray:A}};AjaxParameter.prototype.toAjaxParameter=function(G,J,I,B){I=I==null?"false":I;if(!G||!J){return null}var H="";H+="S="+G;H+="&M="+J;H+="&CL="+I;H+="&RVT="+B;if(this.instance!=null&&this.instance.length>0){for(var E=0;E<this.instance.length;E++){var D=this.instance[E];var F="P_"+D.index+"_"+D.type;if(D.isArray){if(D.value==null||D.value.length==0){H+="&"+F+"_A_N="}else{if(D.value instanceof Array){for(var A=0;A<D.value.length;A++){H+="&"+F+"_A="+encodeURIComponent(D.value[A])}}}}else{var K=D.value==null?"":D.value;H+="&"+F+"="+encodeURIComponent(K)}}}return H};function XMLHttpRequestCaller(F,D,A,B,H,G,E){if((!D||!A)&&!E){alert("AJAX Service name or method, actionUrl is not null.");throw new Error(3,"AJAX Service name or method is not null.")}this.params=new AjaxParameter();this.serviceName=D;this.methodName=A;this.needCheckLogin=G==null?"true":G;this.returnValueType="XML";this.method=H||AJAX_XMLHttpRequest_DEFAULT_METHOD;this.async=(B==null?AJAX_XMLHttpRequest_DEFAULT_async:B);this._caller=F;this.actionUrl=E;this.filterLogoutMessage=true;this.closeConnection=false}XMLHttpRequestCaller.prototype.addParameter=function(A,B,D){this.params.put(A,B,D)};XMLHttpRequestCaller.prototype.serviceRequest=function(){var A=null;var D=null;if(this.actionUrl){A=getBaseURL()+this.actionUrl;D=this.sendData}else{var B=getBaseURL()+"/getAjaxDataServlet";var F=this.params.toAjaxParameter(this.serviceName,this.methodName,this.needCheckLogin,this.returnValueType);if(!F){throw new Error(5,"\u6ca1\u6709\u4efb\u4f55\u53c2\u6570")}if(F.length<500){this.method="GET"}if(this.method.toUpperCase()=="POST"){A=B;D=F}else{if(this.method.toUpperCase()=="GET"){A=B+"?"+F}}}var G=getHTTPObject();var H=this._caller;var E=this.filterLogoutMessage;if(!G){throw new Error(2,"\u5f53\u524d\u6d4f\u89c8\u5668\u4e0d\u652f\u6301XMLHttpRequest")}if(this.async){G.onreadystatechange=function(){if(G.readyState==4){if(G.status==200){var I=getXMLHttpRequestData(G,E);H.invoke(I)}else{if(H&&H.showAjaxError){H.showAjaxError(G.status)}else{H.invoke(null)}}}}}G.open(this.method,A,this.async);G.setRequestHeader("Content-Type","application/x-www-form-urlencoded");G.setRequestHeader("RequestType","AJAX");if(this.closeConnection){G.setRequestHeader("Connection","close")}G.send(D);if(!this.async){if(G.readyState==4){if(G.status==200){return getXMLHttpRequestData(G,E)}else{}}}};function getXMLHttpRequestData(E,A){var B=E.getResponseHeader("content-type");var F=B&&B.indexOf("xml")>=0;var D=F?E.responseXML:E.responseText;if(F){D=xmlHandle(D)||E.responseText}if(A==true&&D!=null&&D.toString().indexOf("[LOGOUT]")==0){return null}return D}function xmlHandle(E){if(!E){return null}try{var A=E.documentElement;if(null!=A){var B=A.nodeName;if(B==AJAX_RESPONSE_XML_TAG_BEAN){return beanXmlHandle(A)}else{if(B==AJAX_RESPONSE_XML_TAG_LIST){return listXmlHandle(A)}else{if(B==AJAX_RESPONSE_XML_TAG_Value){return A.firstChild.nodeValue}}}}}catch(D){throw D.message}return null}function beanXmlHandle(F){if(!F){return null}var E=new Properties();E.type="";var I=F.childNodes;if(I!=null&&I.length>0){for(var D=0;D<I.length;D++){var B=I[D].attributes.getNamedItem(AJAX_RESPONSE_XML_TAG_Name).nodeValue;var H="";var A=I[D].firstChild;if(A!=null){if(A.childNodes!=null&&A.childNodes.length>0){var G=A.nodeName;if(G==AJAX_RESPONSE_XML_TAG_BEAN){H=beanXmlHandle(A)}else{if(G==AJAX_RESPONSE_XML_TAG_LIST){H=listXmlHandle(A)}else{if(G==AJAX_RESPONSE_XML_TAG_Value){H=A.firstChild.nodeValue}}}}else{H=A.nodeValue}}E.putRef(B,(H))}}return E}function listXmlHandle(E){var H=new Array();if(E!=null){var D=new Properties();var A=E.childNodes;if(A!=null&&A.length>0){for(var B=0;B<A.length;B++){var G=A[B].nodeName;var F="";if(G==AJAX_RESPONSE_XML_TAG_BEAN){F=beanXmlHandle(A[B])}else{if(G==AJAX_RESPONSE_XML_TAG_LIST){F=listXmlHandle(A[B])}else{if(G==AJAX_RESPONSE_XML_TAG_Value){F=A[B].firstChild.nodeValue}}}H[B]=F}}}return H}function getHTTPObject(){var xmlhttp;
/*@cc_on
  @if (@_jscript_version >= 5)
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch (e) {
      try {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } 
      catch (E) {
        xmlhttp = false;
      }
    }
  @else
  xmlhttp = false;
  @end @*/
if(!xmlhttp&&typeof XMLHttpRequest!="undefined"){try{xmlhttp=new XMLHttpRequest()}catch(e){xmlhttp=false}}return xmlhttp}function getBaseURL(){try{if(v3x){return v3x.baseURL}else{if(parent.v3x){return parent.v3x.baseURL}else{if(getA8Top().v3x){return getA8Top().v3x.baseURL}else{if(getA8Top().conextPath){return getA8Top().conextPath}}}}}catch(A){}return"/seeyon"}function ajaxFormSubmit(A){var D=new AjaxParameter();var F=getHTTPObject();var E=D.FormToAjaxParameter(A);F.open("post",A.action,false);F.setRequestHeader("Content-Type","application/x-www-form-urlencoded");F.send(E);if(F.readyState==4){if(F.status==200){var B=xmlHandle(F.responseXML);if(B==null){B=F.responseText;if(B.search("<")>0){B=B.substr(B.search("<"));B=getXMLDoc(B);B=xmlHandle(B)}else{return B}}if(!B){B=F.responseTEXT}return B}else{return false}}return false}function getXMLDoc(D){var F=null;var E=navigator.userAgent;var A=(navigator.appName=="Microsoft Internet Explorer")||E.indexOf("Trident")!=-1;if(A){F=new ActiveXObject("MSXML2.DOMDocument");F.async=false;if(D!=null){F.loadXML(D)}}else{if(document.implementation&&document.implementation.createDocument){F=document.implementation.createDocument("","",null);var B=new DOMParser();F.async=false;if(D!=null){F=B.parseFromString(D,"text/xml")}}}return F}function getXSLDoc(E,G){var D=navigator.userAgent;var A=(navigator.appName=="Microsoft Internet Explorer")||D.indexOf("Trident")!=-1;if(A){return E.transformNode(G)}else{var F=new XSLTProcessor();F.importStylesheet(G);var B=F.transformToFragment(E,document);return new XMLSerializer().serializeToString(B)}}function getXmlString(A){if(window.ActiveXObject){return A.xml}else{var B=document.createElement("div");B.appendChild(A.cloneNode(true));return B.innerHTML}}AjaxParameter.prototype.FormToAjaxParameter=function(B){var E="";var H=new Properties();var F;var I,D;var G;var A;for(F=0;F<B.elements.length;F++){I=B.elements[F];A=I.getAttribute("canSubmit");if(I.disabled||(I.readOnly&&A!="true")){continue}if(I.type=="select-one"||I.type=="hidden"||I.type=="password"||I.type=="text"||I.type=="textarea"){H.put(I.name,I.value)}else{if(I.type=="select-multiple"||I.type=="checkbox"||I.type=="radio"){D=H.get(I.name);G=getFormInputValue(I);if(G!=""){if(D!=null&&D!=""){D+=","}else{D=G}}if(D==null){D=""}H.put(I.name,D)}}}E=H.toQueryString();return E};function getFormInputValue(A){var D="";var B;var E;if(A.type=="select-multiple"){for(B=0;B<A.options.length;B++){if(A.options[B].selected==true){if(D!=""){D+=","}D+=A.options[B].value}}}else{if(A.type=="checkbox"||A.type=="radio"){E=document.getElementsByName(A.name);for(B=0;B<E.length;B++){if(E[B].checked==true){if(D!=""){D+=","}D+=E[B].value}}}}return D}var dom=(document.getElementsByTagName)?true:false;var ie5=(document.getElementsByTagName&&document.all)?true:false;var arrowUp,arrowDown;if(ie5||dom){initSortTable()}function initSortTable(){arrowUp=document.createElement("SPAN");arrowUp.className="arrowAsc";arrowUp.innerHTML="&nbsp;&nbsp;";arrowDown=document.createElement("SPAN");arrowDown.className="arrowDesc";arrowDown.innerHTML="&nbsp;&nbsp;"}function getNextSibByClass(B,A){if(B==null){return null}else{if(B.nodeType==1&&B.className==A){return B}else{return getNextSibByClass(B.nextSibling,A)}}}function getParentByClass(B,A){if(B==null){return null}else{if(B.nodeType==1&&B.className==A){return B}else{return getParentByClass(B.parentNode,A)}}}function sortTable(N,I,F,A,J){var M;if(J){var D=getParentByClass(N,"hDiv");var O=getNextSibByClass(D,"bDiv");M=O.childNodes[0].childNodes[0]}else{M=N.tBodies[0]}var H=M.rows;var L=new Array();var K=new Array();for(var G=0;G<H.length;G++){var B=H[G];for(var E=0;E<B.cells.length;E++){B.cells[E].className="sort"}B.childNodes[I].className="sort sorted";if(B.id.indexOf("off")!=-1){K[K.length]=H[G]}else{L[L.length]=H[G]}}L.sort(compareByColumn(I,F,A));K.sort(compareByColumn(I,F,A));for(var G=0;G<L.length;G++){if(G%2==0){L[G].className="erow"}else{L[G].className=""}M.appendChild(L[G])}for(var G=0;G<K.length;G++){M.appendChild(K[G])}}function CaseInsensitiveString(A){return String(A).toLocaleString()}function parseDate(A){return Date.parse(A.replace(/\-/g,"/"))}function toNumber(A){return Number(A.replace(/[^0-9\.]/g,""))}function compareByColumn(G,A,F){var E=G;var D=A;var B=String;if(F=="Number"){B=parseInt}else{if(F=="Date"){B=compareMyDate}else{if(F=="CaseInsensitiveString"){B=CaseInsensitiveString}else{if(F=="Size"){B=compareSize}else{if(F=="Percent"){B=comparePercent}else{if(F=="Month"){B=compareMonth}else{if(F=="Number"){B=compareNumber}}}}}}}return function(I,H){if(B==String||B==CaseInsensitiveString){var J=B(getInnerText(I.cells[E])).localeCompare(B(getInnerText(H.cells[E])));if(D){return J*-1}else{return J}}else{if(B==compareMyDate){var J=B(getInnerText(I.cells[E]),getInnerText(H.cells[E]));if(D){return J*-1}else{return J}}else{if(B==compareSize){var J=B(getInnerText(I.cells[E]),getInnerText(H.cells[E]));if(D){return J*-1}else{return J}}else{if(B==comparePercent){var J=B(getInnerText(I.cells[E]),getInnerText(H.cells[E]));if(D){return J*-1}else{return J}}else{if(B==compareMonth){var J=B(getInnerText(I.cells[E]),getInnerText(H.cells[E]));if(D){return J*-1}else{return J}}else{if(B==compareNumber){var J=B(getInnerText(I.cells[E]),getInnerText(H.cells[E]));if(D){return J*-1}else{return J}}else{if(B(getInnerText(I.cells[E]))>B(getInnerText(H.cells[E]))){return D?-1:+1}if(B(getInnerText(I.cells[E]))<B(getInnerText(H.cells[E]))){return D?+1:-1}return 0}}}}}}}}function compareNumber(B,A){if((B==null||B=="  ")&&(A!=null&&A!="  ")){return -1}if((A==null||A=="  ")&&(B!=null&&B!="  ")){return 1}if((B==null||B=="  ")&&(A==null||A=="  ")){return 0}var E=parseFloat(B);var D=parseFloat(A);if(E>D){return 1}else{if(E<D){return -1}else{return 0}}}function compareMonth(E,D){if((E==null||E=="  ")&&(D!=null&&D!="  ")){return -1}if((D==null||D=="  ")&&(E!=null&&E!="  ")){return 1}if((E==null||E=="  ")&&(D==null||D=="  ")){return 0}var B=E.split("-");var A=D.split("-");var I=B[0];var G=A[0];var H=parseInt(parseFloat(B[1]));var F=parseInt(parseFloat(A[1]));if(I>G){return 1}if(I<G){return -1}if(I==G){if(H>F){return 1}else{if(H<F){return -1}else{return 0}}}}function compareSize(B,A){if((B==null||B=="  ")&&(A!=null&&A!="  ")){return -1}if((A==null||A=="  ")&&(B!=null&&B!="  ")){return 1}if((B==null||B=="  ")&&(A==null||A=="  ")){return 0}var E=F(B);var D=F(A);if(E-D>0){return 1}else{if(E-D<0){return -1}else{return 0}}function F(G){if(G.indexOf("MB")>-1){return parseFloat(G)*1000}else{if(G.indexOf("KB")>-1){return parseFloat(G)}}}}function comparePercent(B,A){if((B==null||B=="  ")&&(A!=null&&A!="  ")){return -1}if((A==null||A=="  ")&&(B!=null&&B!="  ")){return 1}if((B==null||B=="  ")&&(A==null||A=="  ")){return 0}var E=F(B);var D=F(A);if(E-D>0){return 1}else{if(E-D<0){return -1}else{return 0}}function F(G){if(G.indexOf("%")>-1){return parseFloat(G)*10000}return 0}}function compareMyDate(D,A){if((D==null||D=="  "||D==" ")&&(A!=null&&A!="  "&&A!=" ")){return -1}if((A==null||A=="  "||A==" ")&&(D!=null&&D!="  "&&D!=" ")){return 1}if((D==null||D=="  "||D==" ")&&(A==null||A=="  "||A==" ")){return 0}var E=initDate(D);var B=initDate(A);if(E-B>0){return 1}else{if(E-B<0){return -1}else{return 0}}}function initDate(G){if(G.indexOf("/")>-1&&G.indexOf(":")>-1){var A=parseFloat(G.substr(0,2));var K=parseFloat(G.substr(3,2));var I=parseFloat(G.substr(6,2));var L=parseFloat(G.substr(9,2));var N=parseFloat(G.substr(12,2));var H=0;return new Date(A,K,I,L,N,H)}else{if(G.indexOf("-")>-1&&G.indexOf(":")>-1){G=G.trim();var B=G.split(" ");var J=B[0].split("-");var D=B[1].split(":");var M=parseInt(J[1]);if(J[1].length==2&&J[1].substr(0,1)=="0"){M=parseInt(J[1].substr(1,1))}var F=parseInt(J[2]);if(J[2].length==2&&J[2].substr(0,1)=="0"){F=parseInt(J[2].substr(1,1))}var L=parseInt(D[0]);if(D[0].length==2&&D[0].substr(0,1)=="0"){L=parseInt(D[0].substr(1,1))}var E=parseInt(D[1]);if(D[1].length==2&&D[1].substr(0,1)=="0"){E=parseInt(D[1].substr(1,1))}var H=0;if(D.length==3&&D[2].length>0){H=parseInt(D[2]);if(D[2].length==2&&D[2].substr(0,1)=="0"){H=parseInt(D[2].substr(1,1))}}return new Date(parseInt(J[0]),M-1,F,L,E,H)}else{if(G.indexOf("-")>-1&&G.indexOf(":")==-1){var B=G.split("-");var M=parseInt(B[1]);if(B[1].length==2&&B[1].substr(0,1)=="0"){M=parseInt(B[1].substr(1,1))}var F=parseInt(B[2]);if(B[2].length==2&&B[2].substr(0,1)=="0"){F=parseInt(B[2].substr(1,1))}return new Date(parseInt(B[0]),M-1,F,0,0,0)}else{if(isChina(G)){var A=G.substr(0,4);var K=null;var I=null;if(isChina(G.substr(6,1))&&isChina(G.substr(8,1))){K=G.substr(5,1);I=G.substr(7,1)}else{if(isChina(G.substr(6,1))&&isChina(G.substr(9,1))){K=G.substr(5,1);I=G.substr(7,2)}else{if(isChina(G.substr(7,1))&&isChina(G.substr(9,1))){K=G.substr(5,2);I=G.substr(8,1)}else{if(isChina(G.substr(7,1))&&isChina(G.substr(10,1))){K=G.substr(5,2);I=G.substr(8,2)}}}}return new Date(parseInt(A),parseInt(K)-1,parseInt(I),0,0,0)}}}}}function isChina(B){var A=/[\u4E00-\u9FA5]|[\uFE30-\uFFA0]/gi;if(!A.exec(B)){return false}else{return true}}function sortColumn(G,A,F){try{var D,E;if(ie5){D=G.srcElement}else{if(dom){D=G.target}}if(F){E=getParent(D,"TH")}else{E=getParent(D,"TD")}var B=E.orderBy;if(E==null||B==null||B==""){sortColumnCurrentPage(G,A,F)}else{sortColumnAll(E,B,F)}}catch(G){}}function sortColumnAll(F,D,G){if(!E){var E=new Properties()}var B=E.get("orderByColumn");var A=E.get("orderByDESC");if(A==null){A="ASC"}else{if(D!=B){A="ASC";E.put("page",1)}else{A=A=="DESC"?"ASC":"DESC"}}E.put("orderByColumn",D);E.put("orderByDESC",A);getPageAction(F)}function sortColumnCurrentPage(J,E,L){var I,D,N,L,G;if(ie5){I=J.srcElement}else{if(dom){I=J.target}}G=getParent(I,"TABLE");N=getParent(I,"THEAD");if(L){D=getParent(I,"TH")}else{var K=getParent(I,"TFOOT");if(I.tagName=="TD"&&K==null&&N==null&&E==true){selectRow(I)}D=getParent(I,"TD")}if(D==null||D.getAttribute("type")==null||D.getAttribute("type")==""){return }if(N==null){return }if(!F){var F=new Properties()}var Q=F.get("orderByColumn");if(Q){var M=document.getElementById("OrderByColumn_"+Q);if(M){M.parentNode.removeChild(M)}}if(D!=null){var A=D.parentNode;var H;if(D._descending){D._descending=false}else{D._descending=true}if(N.arrow!=null){if(L){N.arrow.className=""}else{if(N.arrow.parentNode==null){N.arrow=null}else{if(N.arrow.parentNode!=D){N.arrow.parentNode._descending=null}N.arrow.parentNode.removeChild(N.arrow)}}}var B=D.firstChild;if(L){if(D._descending){B.className="sdesc"}else{B.className="sasc"}N.arrow=B}else{if(D._descending){N.arrow=arrowDown.cloneNode(true)}else{N.arrow=arrowUp.cloneNode(true)}D.appendChild(N.arrow)}for(H=0;H<A.cells.length;H++){A.cells[H].className=" ";if(A.cells[H]==D&&A.cells[H].childNodes.type!="checkbox"){A.cells[H].className="sorted";var O=H}}var P=getParent(D,"TABLE");sortTable(P,O,D._descending,D.getAttribute("type"),L)}}function getInnerText(B){if(ie5){return B.innerText}var D="";for(var A=0;A<B.childNodes.length;A++){switch(B.childNodes.item(A).nodeType){case 1:D+=getInnerText(B.childNodes.item(A));break;case 3:D+=B.childNodes.item(A).nodeValue;break}}return D}function getParent(B,A){if(B==null){return null}else{if(B.nodeType==1&&B.tagName.toLowerCase()==A.toLowerCase()){return B}else{return getParent(B.parentNode,A)}}}var currentSelectTr=null;function clearSiblingStyle(A){var E=A.parentNode.childNodes;if(E!=null){for(var B=0;B<E.length;B++){var D=E[B];redoStyle(D)}}}function redoStyle(){var I=currentSelectTr;if(!I){return }var A=I.className;var B=I.className2;if(B!=null&&A!=B){I.className=B}var K=getCheckboxFromTr(I);if(K&&K.disabled!=true){K.checked=false}var D=I.cells;for(var J=0;J<D.length;J++){var G=D.item(J);var L=G.className;var E=L.split(" ");var F="";for(var H=0;H<E.length;H++){if(E[H]!="no-read"){F+=E[H]+" "}}G.className=F}}function changeSelectedStyle(D){if(D==null){return }var A=D.className;var B=D.className2;if(B==null){D.className2=A;if(D.id.indexOf("off")!=-1){D.className="tr-select-offline"}else{D.className="sort-select"}}else{if(A==B){if(D.id.indexOf("off")!=-1){D.className="tr-select-offline"}else{D.className="sort-select"}}else{D.className=B}}}function selectRow(A){if(A.tagName=="INPUT"){unselectAll();return }var G=getParent(A,"TR");var B=getParent(G,"tbody");var F=v3x.getEvent();var E;if(ie5){E=F.srcElement}else{if(dom){E=F.target}}if(E.tagName=="INPUT"||E.tagName=="SELECT"){return }if(G!=null&&B!=null){redoStyle();changeSelectedStyle(G);currentSelectTr=G;var D=getCheckboxFromTr(G);if(D!=undefined&&D!=null){noSelected(D.name);if(D.disabled!=true){D.checked=true}unselectAll()}}}function getCheckboxFromTr(E){if(E==null||E.childNodes.length==0){return null}else{for(var D=0;D<E.childNodes.length;D++){var B=E.childNodes[D];if(B.type=="checkbox"||B.type=="radio"){return B}else{var A=getCheckboxFromTr(B);if(A!=null){return A}}}}}function selectAll(B,E){var A=document.getElementsByName(E);if(A!=null){for(var D=0;D<A.length;D++){if(A[D].disabled==true){continue}A[D].checked=B.checked}}}function noSelected(A){var D=document.getElementsByName(A);if(D){for(var B=0;B<D.length;B++){if(D[B].disabled==true){continue}D[B].checked=false}}}function unselectAll(){var A=document.getElementById("allCheckbox");if(A&&A.disabled!=true){if(A.checked){A.click();A.checked=false}}}var canDoAction=true;function getPageAction(E){var M=pageFormMethod||"get";var A=getForm(E);var B=A.attributes.getNamedItem("ACTION");var D=B?(B.nodeValue):""||"";var K=document.createElement("form");K.setAttribute("action",D);K.setAttribute("target","_self");K.setAttribute("method",M);if(!canDoAction){return }var L=pageQueryMap.keys();for(var F=0;F<L.size();F++){var J=L.get(F);var H=pageQueryMap.get(J);if(!J||J=="pageSize"){continue}if(H instanceof Array){for(var I=0;I<H.length;I++){var G=document.createElement("input");G.setAttribute("type","hidden");G.setAttribute("name",J);G.value=H[I];K.appendChild(G)}}else{var G=document.createElement("input");G.setAttribute("type","hidden");G.setAttribute("name",J);G.value=H;K.appendChild(G)}}var I=A.pageSize.value||20;var G=document.createElement("input");G.setAttribute("type","hidden");G.setAttribute("name","pageSize");G.setAttribute("value",I);K.appendChild(G);if(!new RegExp("^-?[0-9]*$").test(I)||parseInt(I,10)<1){}document.body.appendChild(K);K.submit();canDoAction=false}function enterSubmit(B,A){if(v3x.getEvent().keyCode==13){if(A=="pageSize"){pagesizeChange(B)}else{if(A=="intpage"){pageChange(B)}}}}function getForm(A){return document.getElementsByName("pageSize")[0].form}function pageGo(A){getPageAction(A)}function first(A){pageQueryMap.put("page",1);getPageAction(A)}function pageChange(B){if(!new RegExp("^-?[0-9]*$").test(B.value)){return }var A=B.getAttribute("pageCount");if(B.value>parseInt(A,10)){B.value=A}pageQueryMap.put("page",B.value);getPageAction(B)}function last(B,A){pageQueryMap.put("page",A);getPageAction(B)}function next(B){var A=parseInt(pageQueryMap.get("page"));pageQueryMap.put("page",A+1);getPageAction(B)}function pagesizeChange(B){var A=B.value;if(!new RegExp("^-?[0-9]*$").test(A)||parseInt(A,10)<1){return }pageQueryMap.put("pageSize",A);pageQueryMap.put("page",1);getPageAction(B)}function prev(B){var A=parseInt(pageQueryMap.get("page"));pageQueryMap.put("page",A-1);getPageAction(B)}var formValidate={unCharactor:"\"\\/|><:*?'&%$",integerDigits:"10",decimalDigits:"0"};V3X.prototype.checkFormAdvanceAttribute="";function checkForm(formObj){var elements=formObj.elements;var clearValueElements=[];if(elements!=null){for(var i=0;i<elements.length;i++){var e=elements[i];var clearValue=e.getAttribute("clearValue");if(clearValue=="true"){clearValueElements[clearValueElements.length]=e;continue}V3X.checkFormAdvanceAttribute=e.getAttribute("advance");var validateAtt=e.getAttribute("validate");if(validateAtt!=null&&validateAtt!=""&&validateAtt!="undefined"){var validateFuns=validateAtt.split(",");for(var f=0;f<validateFuns.length;f++){var fun=validateFuns[f];if(fun){var result=eval(fun+"(e)");if(!result){return false}}}}}}for(var j=0;j<clearValueElements.length;j++){clearDefaultValueWhenSubmit(clearValueElements[j])}return true}function testRegExp(B,A){return new RegExp(A).test(B)}function clearDefaultValueWhenSubmit(D){var A=getDefaultValue(D);var B=D.value;if(B==A){D.value=""}}function writeValidateInfo(element,message){alert(message);var onAfterAlert=element.getAttribute("onAfterAlert");if(onAfterAlert){try{eval(onAfterAlert)}catch(e){}}else{try{element.focus();element.select()}catch(e){}}}function notSpecChar(B){var D=B.value;var A=B.getAttribute("inputName");if(D==_("V3XLang.default_subject_value")){D=""}if(/^[^\|\\"'<>]*$/.test(D)){return true}else{writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_specialCharacter",A));return false}}function notSpecCharWithoutApos(B){var D=B.value;var A=B.getAttribute("inputName");if(/^[^\|\\\/"<>]*$/.test(D)){return true}else{writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_specialCharacter_withoutApos",A));return false}}function notNull(D){var E=D.value;E=E.replace(/[\r\n]/g,"");var B=D.getAttribute("inputName");if(E==null||E==""||E.trim()==""){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_notNull",B));return false}var A=D.getAttribute("maxSize");if(A&&E.length>A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_maxLength",B,A,E.length));return false}return true}function maxLength(D){var E=D.value;if(!E){return true}var B=D.getAttribute("inputName");var A=D.getAttribute("maxSize");if(A&&E.length>A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_maxLength",B,A,E.length));return false}return true}function minLength(D){var E=D.value;if(!E){return true}var B=D.getAttribute("inputName");var A=D.getAttribute("minLength");if(A&&E.length<A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_minLength",B,A,E.length));return false}return true}function isNumber(B){var E=B.value;var A=B.getAttribute("inputName");var H=B.getAttribute("integerDigits")||formValidate.integerDigits;var G=B.getAttribute("decimalDigits")||formValidate.decimalDigits;var D=B.getAttribute("integerMax");var F=B.getAttribute("integerMin");if(E=="0"){return true}if(E=="."){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isNumber",A));return false}if(!testRegExp(E,"^-?[0-9]{0,"+H+"}\\.?[0-9]{0,"+G+"}$")){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isNumber",A));return false}if(D&&parseInt(E)>D){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_too_max",A,D,E));return false}if(F&&parseInt(E)<F){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_too_min",A,F,E));return false}return true}function positive(B){var E=B.value.trim();if(E!=""){var D=parseFloat(B.value.trim());var A=B.getAttribute("inputName");if(D<=0){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_positive",A));return false}}return true}function percent(B){var E=B.value.trim();if(E!=""){var D=parseFloat(B.value.trim());var A=B.getAttribute("inputName");if(D<0||D>100){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_percent",A,E));return false}}return true}function notNum(B){var D=B.value;var A=B.getAttribute("inputName");var F=B.getAttribute("integerDigits")||formValidate.integerDigits;var E=B.getAttribute("decimalDigits")||formValidate.decimalDigits;if(D=="0"){return true}if(testRegExp(D,"^-?[0-9]{0,"+F+"}\\.?[0-9]{0,"+E+"}$")){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isNotNumber",A));return false}return true}function isEmail(B){var D=B.value;if(!D){return true}var A=B.getAttribute("inputName");if(D.indexOf("@")==-1||D.indexOf(".")==-1){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isEmail",A));return false}return true}function notNullWithoutTrim(D){var E=D.value;var B=D.getAttribute("inputName");if(E==null||E==""){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_notNull",B));return false}var A=D.getAttribute("maxLength");if(A&&E.length>A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_maxLength",B,A));return false}return true}function isInteger(E){var F=E.value;var B=E.getAttribute("inputName");var A=E.getAttribute("max");var D=E.getAttribute("min");if(F!="0"&&(isNaN(F)||F.indexOf("0")==0||!testRegExp(F,"^-?[0-9]*$"))){writeValidateInfo(E,v3x.getMessage("V3XLang.formValidate_isInteger",B));return false}if(A!=null&&A!=""&&parseInt(F)>parseInt(A)){writeValidateInfo(E,v3x.getMessage("V3XLang.formValidate_isInteger_max",B,A));return false}if(D!=null&&D!=""&&parseInt(F)<parseInt(D)){writeValidateInfo(E,v3x.getMessage("V3XLang.formValidate_isInteger_min",B,D));return false}return true}function isWord(E){var G=E.value;var B=E.getAttribute("inputName");var F=E.getAttribute("character")||formValidate.unCharactor;var A="";for(var D=0;D<F.length;D++){if(G.indexOf(F.charAt(D))>-1){A+=F.charAt(D)}}if(A.length>0){writeValidateInfo(E,v3x.getMessage("V3XLang.formValidate_isWord",B,A,F));return false}return true}function isCriterionWord(B){var D=B.value;var A=B.getAttribute("inputName");if(!testRegExp(D,"^[\\w-]+$")){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isCriterionWord",A));return false}return true}function isUrl(B){var D=B.value;if(!D){return true}var A=B.getAttribute("inputName");if(!testRegExp(D,"^http://{1}([\\w-]+.)+[\\w-]+")){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isUrl",A));return false}return true}function startsWith(B){if(typeof (B)=="object"){var E=B.value;var A=B.getAttribute("inputName");var D=B.getAttribute("prefix");if(E.indexOf(D)!=0){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_startsWith",A,D));return false}}return true}function isDeaultValue(D){var E=D.value;var B=D.getAttribute("inputName");var A=getDefaultValue(D);if(E==A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_notNull",B));return false}return true}function isDefaultValue(D){var E=D.value;var B=D.getAttribute("inputName");var A=getDefaultValue(D);if(E==A){writeValidateInfo(D,v3x.getMessage("V3XLang.formValidate_notNull",B));return false}return true}var __addDataEventObject=null;function whenstart(D,N,G,I,H,E,A,L,M){H=H||"date";if(E==null){E=true}__addDataEventObject=N;var J=v3x.getEvent();if(v3x.getBrowserFlag("openWindow")==false){var K=J.currentTarget;var F={id:"date_win",title:v3x.getMessage("V3XLang.calendar_page_title"),url:D+"/common/js/addDate/date.jsp?type="+H+"&allowEmpty="+E+"&showButton=true",height:L+5||320,width:A+5||320,transParams:{parentWin:window,paramsItem:M,clickTarget:__addDataEventObject},targetWindow:getA8Top(),isDrag:false};if(getA8Top().isCtpTop||getA8Top()._ctxPath){getA8Top().date_win=getA8Top().$.dialog(F)}else{getA8Top().date_win=getA8Top().v3x.openDialog(F)}}else{var B=v3x.openWindow({url:D+"/common/js/addDate/date.jsp?type="+H+"&allowEmpty="+E+"&showButton=true",height:230,width:250,top:J.screenY+20,left:J.screenX-50});if(B==null){B=""}if(!N&&B){return B}return B}}Date.prototype.isDate=function(D,B){var K,E;var I,A,F,H;var G;var J=new String(D);if(J.length<8||J.length>10){return false}E="^([0-9]){4}(-|/)([0-9]){1,2}(-|/)([0-9]){1,2}$";K=new RegExp(E);if(J.search(K)==-1){return false}I=J.charAt(4);G=J.split(I);if(G.length!=3){return false}A=parseInt(G[0],10);F=parseInt(G[1],10);H=parseInt(G[2],10);if(A<1900||A>2500){return false}if(F<1||F>12){return false}if(H<1||H>31){return false}switch(F){case 4:case 6:case 9:case 11:if(H>30){return false}break;case 2:if((A%4==0&&A%100!=0)||A%400==0){if(H>29){return false}}else{if(H>28){return false}}break;default:break}if(B){this.setDate(H);this.setMonth(F-1);this.setYear(A)}return true};function parseDate(B){var D=B.split("-");var F=parseInt(D[0],10);var A=parseInt(D[1],10)-1;var E=parseInt(D[2],10);return new Date(F,A,E)}Date.prototype.dateAdd=function(J,I){var M;var H=J;var G,A,E;var D;var F=false;var K;var B;var L;if(this.isDate(J,true)==false){return J}L=new String(J);K=L.charAt(4);B=L.split(K);G=parseInt(B[0],10);A=parseInt(B[1],10);E=parseInt(B[2],10);while(I!=0){if(I>0){E++}else{E--}if(E<=0||E>31){F=true;if(E<=0){E=31}else{E=1}}else{F=false}if(F){if(I>0){A++}else{A--}if(A<=0||A>12){F=true;if(A<=0){A=12}else{A=1}}else{F=false}}if(F){if(I>0){G++}else{G--}}H=G+"-"+A+"-"+E;if(this.isDate(H,false)){if(I>0){I--}else{I++}}}return H};Date.prototype.getWeekStart=function(A){this.isDate(A,true);var B=this.getDay();var D=B;if(D!=0){D=-D}return formatDate(this.dateAdd(A,D))};Date.prototype.getWeekEnd=function(A){this.isDate(A,true);var B=this.getDay();var D=6-B;return formatDate(this.dateAdd(A,D))};Date.prototype.getMonthStart=function(A){this.isDate(A,true);A=this.getFullYear()+"-"+(this.getMonth()+1)+"-1";return formatDate(A)};Date.prototype.getMonthEnd=function(D){this.isDate(D,true);var A=[31,28,31,30,31,30,31,31,30,31,30,31];var E=this.getFullYear();var F=this.getMonth()+1;var B=A[this.getMonth()];if(E%4==0&&F==2){B++}D=E+"-"+F+"-"+B;return formatDate(D)};Date.prototype.getSeasonStart=function(B){var A=[1,1,1,4,4,4,7,7,7,10,10,10];this.isDate(B,true);B=this.getFullYear()+"-"+A[this.getMonth()]+"-1";return formatDate(B)};Date.prototype.getSeasonEnd=function(D){this.isDate(D,true);var B=[3,3,3,6,6,6,9,9,9,12,12,12];var A=[31,31,31,30,30,30,30,30,30,31,31,31];this.isDate(D,true);D=this.getFullYear()+"-"+B[this.getMonth()]+"-"+A[this.getMonth()];return formatDate(D)};Date.prototype.getWeekOfMonth=function(){var A=this.getDay();var B=this.getDate();return Math.ceil((B+6-A)/7)};function formatDate(A){var E=A.split("-");var D=parseInt(E[1],10);var B=parseInt(E[2],10);return E[0]+"-"+(D<10?"0"+D:D)+"-"+(B<10?"0"+B:B)}Date.prototype.format=function(D){var A=this.getHours();var E={"M+":this.getMonth()+1,"d+":this.getDate(),"H+":A,"h+":(A>12?A-12:A),"m+":this.getMinutes(),"s+":this.getSeconds(),"q+":Math.floor((this.getMonth()+3)/3),S:this.getMilliseconds()};if(/(y+)/.test(D)){D=D.replace(RegExp.$1,(this.getFullYear()+"").substr(4-RegExp.$1.length))}for(var B in E){if(new RegExp("("+B+")").test(D)){D=D.replace(RegExp.$1,RegExp.$1.length==1?E[B]:("00"+E[B]).substr((""+E[B]).length))}}return D};function compareDate(B,A){return Date.parse(B.replace(/\-/g,"/"))-Date.parse(A.replace(/\-/g,"/"))}var chinese=["\u96f6","\u4e00","\u4e8c","\u4e09","\u56db","\u4e94","\u516d","\u4e03","\u516b","\u4e5d"];var len=["\u5341"];var ydm=["\u5e74","\u6708","\u65e5"];function num2chinese(D){D=""+D;slen=D.length;var A="";for(var B=0;B<slen;B++){A+=chinese[D.charAt(B)]}return A}function n2c(B){B=""+B;var A="";if(B.length==2){if(B.charAt(0)=="1"){if(B.charAt(1)=="0"){return len[0]}return len[0]+chinese[B.charAt(1)]}if(B.charAt(1)=="0"){return chinese[B.charAt(0)]+len[0]}return chinese[B.charAt(0)]+len[0]+chinese[B.charAt(1)]}return num2chinese(B)}function date2chinese0(B){var A=date2chinese(B);A=A.replace(/\u96f6/g,"\u3007");return A}function date2chinese1(B){var D;var A=B.split("-");if(A.length!=3){A=B.split("/")}if(A.length!=3){return B}if(A[1].charAt(0)=="0"){A[1]=A[1].substr(1)}if(A[2].charAt(0)=="0"){A[2]=A[2].substr(1)}D=A[0]+"\u5e74"+A[1]+"\u6708"+A[2]+"\u65e5";return D}function date2chinese(D){var F=/^(\d{2}|\d{4})(\/|-)(\d{1,2})(\2)(\d{1,2})$/;var E=D.match(F);var B="";if(E==null){return false}for(var A=1;A<E.length;A=A+2){B+=n2c(E[A]-0)+ydm[(A-1)/2]}return B}var plist=null;var styleData=null;var printDefaultSelect=null;var notPrintDefaultSelect=null;function printList(A,B){if(!A){return }plist=A;styleData=B;if(arguments[2]!=null){printDefaultSelect=arguments[2]}else{printDefaultSelect=null}if(arguments[3]!=null){notPrintDefaultSelect=arguments[3]}else{notPrintDefaultSelect=null}printButton()}function printButton(){var A="";try{A=v3x.baseURL+"/apps_res/print/print.jsp?isReportPerfermance="+isReportPerfermance}catch(B){A=v3x.baseURL+"/apps_res/print/print.jsp"}v3x.openWindow({url:A,dialogType:"1",workSpace:true,resizable:true,scrollbars:false})}function printLoad(){try{var G=v3x.getParentWindow();var D=document.getElementById("context");var J=G.plist;var E=J.size();for(var H=0;H<E;H++){var N=J.get(H);D.innerHTML+="<p>"+N.dataHtml+"</p>"}var F=G.styleData;setStyle(F);var I=document.getElementById("checkOption");var A=G.plist;var M=J.size();var L=0;if(M<=1){disabledLink();return }for(var H=0;H<M;H++){var N=A.get(H);if(N.dataName!=null&&N.dataName!=""){I.innerHTML+="<label for='dataNameBox"+H+"'><input type=checkbox checked name='dataNameBoxes' id=dataNameBox"+H+" onclick='printMain(this)'><font style='font-size:12px' color='black'>"+N.dataName+"</font></label>&nbsp;&nbsp;";L++}}if(L>0){I.innerHTML+="<font style='font-size:12px' color='black'><label for='printall'><input type=checkbox id ='printall' checked name=cboxs onclick=printAll(this)>"+_("printLang.print_all")+"</label></font>"}if(G.notPrintDefaultSelect!=null){for(var H=0;H<G.notPrintDefaultSelect.length;H++){if(document.getElementById("dataNameBox"+G.notPrintDefaultSelect[H])!=null){document.getElementById("dataNameBox"+G.notPrintDefaultSelect[H]).checked=false}}}document.close();var D=document.getElementById("context");creatDataHtml(J,D);var B=document.getElementById("iSignatureHtmlDiv");if(!B){disabledLink()}}catch(K){}}function printMain(D){var B=v3x.getParentWindow();var E=B.plist;var A=document.getElementById("context");creatDataHtml(E,A);checkCount(D,E);disabledLink()}function cleanSpecial(F){var A=F.indexOf("<DIV>");if(A==-1){return F}var D=F.substr(0,A-1);var E=F.substr(A);var B=E.indexOf("</DIV>");var G=E.substr(B+6);return cleanSpecial(D+G)}function creatDataHtml(I,G){var F=I.size();var E=new StringBuffer();E.append("");for(var D=0;D<F;D++){var H=I.get(D);if(H.dataName!=null&&H.dataName!=""){var A=document.getElementById("dataNameBox"+D);if(A.checked){E.append("<p>"+H.dataHtml+"</p>")}else{var B=document.getElementById("printall");B.checked=false}}if(H.dataName==""){E.append("<p>"+H.dataHtml+"</p>")}}G.innerHTML=E.toString()}function checkCount(H,I){var B=I.size();if(H.checked==false){var F=0;for(var D=0;D<B;D++){var E=I.get(D);if(E.dataName!=null&&E.dataName!=""){var A=document.getElementById("dataNameBox"+D);if(A.checked==false){F++}}}if(F==B){alert(_("printLang.print_least_select_one"));if(H.id=="printall"){var G=parent.v3x.getParentWindow();if(G.printDefaultSelect!=null){if(document.getElementById("dataNameBox"+G.printDefaultSelect[0])!=null){document.getElementById("dataNameBox"+G.printDefaultSelect[0]).checked=true}else{document.getElementById("dataNameBox0").checked=true}}else{document.getElementById("dataNameBox0").checked=true}}else{H.checked=true}printMain(H);return false}}}function PrintFragment(A,B){this.dataName=A;this.dataHtml=B}function disabledLink(){var L=document.body.getElementsByTagName("a");var T=document.body.getElementsByTagName("span");var B=document.body.getElementsByTagName("u");var H=document.body.getElementsByTagName("table");var D=document.body.getElementsByTagName("INPUT");var K=document.body.getElementsByTagName("img");var X=document.body.getElementsByTagName("select");var I=document.body.getElementsByTagName("TEXTAREA");var O=document.body.getElementsByTagName("td");var A=document.body.getElementsByTagName("OBJECT");var S="border-left:0px;border-top:0px;border-right:0px;border-bottom:0px solid #ff0000";for(var P=0;P<L.length;P++){L[P].target="_self";L[P].style.color="#000000";L[P].onclick="";L[P].href="###";L[P].style.textDecoration="none";L[P].style.cursor="default"}for(var P=0;P<T.length;P++){var Q=T[P].style.cssText;T[P].style.cssText=Q;T[P].onmouseout="";T[P].onmouseover="";T[P].onclick=""}for(var P=0;P<B.length;P++){B[P].onclick=function(){}}for(var P=0;P<H.length;P++){H[P].onclick=""}for(var P=D.length-1;P>=0;P--){if(D[P].type=="checkbox"){if(D[P].parentNode.parentNode.id=="checkOption"||D[P].id=="printall"){continue}}else{if(D[P].type=="text"){if(D[P].id!="print8"&&D[P].style.display!="none"){var Q=D[P].style.cssText;var F="WORD-WRAP: break-word;TABLE-LAYOUT: fixed;word-break:break-all";if(Q==""){Q=F}else{Q=Q+";"+F}D[P].outerHTML='<span id="'+D[P].id+'" class="'+D[P].className+'" style="'+Q+'">'+D[P].value.escapeSameWidthSpace()+"</span>";continue}}}var V="print1 print2 print3 print4 print5 print6 print7 print8 dataNameBox0 dataNameBox1 dataNameBox2 dataNameBox3 dataNameBox4 dataNameBox5 printall";if(V.indexOf(D[P].id)==-1){D[P].disabled="";D[P].onkeypress="";D[P].onchange="";D[P].onclick="";D[P].onmouseout="";D[P].onmouseover="";D[P].onfocus="";D[P].onblur="";if(!v3x.isMSIE){D[P].disabled="disabled"}}}for(var P=0;P<K.length;P++){K[P].onkeypress="";K[P].onchange="";K[P].onclick="";K[P].style.cursor="default";K[P].alt="";K[P].title="";var N=K[P].src.toString();if(N.indexOf("form/image/selecetUser.gif")!=-1||N.indexOf("form/image/date.gif")!=-1||N.indexOf("form/image/add.gif")!=-1||N.indexOf("form/image/addEmpty.gif")!=-1||N.indexOf("form/image/delete.gif")!=-1||N.indexOf("handwrite.gif")!=-1||N.indexOf("seeyon/apps_res/v3xmain/images/message/16/attachment.gif")!=-1||N.indexOf("seeyon/apps_res/form/image/quoteform.gif")!=-1||N.indexOf("form/image/deeSelect.png")!=-1||N.indexOf("form/image/deeSearch.png")!=-1){K[P].outerHTML="&nbsp;&nbsp;&nbsp;";P--}if(N.indexOf("handwrite.gif")!=-1){for(var W=0;W<A.length;W++){if(A[W].innerHTML.indexOf("Enabled")!=-1){A[W].Enabled=false}}}}for(var M=X.length-1;M>=0;M--){var Q=X[M].style.cssText;try{var E=X[M].parentNode.childNodes;for(var U=0;U<E.length;U++){if(E[U].id==X[M].id+"_autocomplete"){Q=E[U].style.cssText;break}}}catch(R){}X[M].parentNode.outerHTML='<span class="'+X[M].className+'" style="'+Q+'">'+X[M].options[X[M].selectedIndex].text+"</span>"}for(var P=0;P<I.length;P++){try{var G="overflow-y:visible;overflow-x:visible;";var Q=I[P].style.cssText;if(Q==""){Q=G}else{Q=Q+";"+G}var J=parseInt(I[P].clientWidth);if(J-35>0){Q+="width:"+(J-35)+"px;"}I[P].style.cssText=Q;I[P].onclick="";I[P].onkeypress="";I[P].onchange="";I[P].onmouseout="";I[P].onmouseover="";I[P].onfocus="";I[P].onblur=""}catch(R){}I[P].readOnly="readOnly"}for(var P=0;P<O.length;P++){O[P].onclick=""}}function printInnerLoad(){var E=document.getElementById("context");var G=parent.v3x.getParentWindow();var H=G.plist;var D=H.size();for(var B=0;B<D;B++){var F=H.get(B);E.innerHTML+="<p>"+F.dataHtml+"</p>"}var A=G.styleData;if(!A){setStyle(A)}}function setStyle(A){if(A.size()>0){var B=document.getElementById("linkList");for(var D=0;D<A.size();D++){var E=document.createElement("link");E.setAttribute("rel","stylesheet");E.setAttribute("href",A.get(D));E.setAttribute("type","text/css");B.appendChild(E)}}}function printAll(D){var A=document.getElementsByName("dataNameBoxes");if(D.checked){for(var B=0;B<A.length;B++){A[B].checked=true}printMain(D)}else{for(var B=0;B<A.length;B++){A[B].checked=false}printMain(D)}}function onbeforeprint(){document.getElementById("checkOption").style.display="none"}function onafterprint(){document.getElementById("checkOption").style.display=""}function chanageBodyType(J,D){var H=document.getElementById("bodyType");if(H&&H.value==J){return true}if(myBar){if(J=="HTML"){if(clearOfficeFlag){clearOfficeFlag()}myBar.enabled("preview")}else{myBar.disabled("preview")}}var I=document.getElementById("appName");if(I&&I.value=="4"&&J=="HTML"){var G=document.getElementById("content");if(G){G.value=""}}if(confirm(v3x.getMessage("V3XLang.common_confirmChangBodyType"))){var B=document.getElementById("changePdf");if(B){if(J=="OfficeWord"||J=="WpsWord"){B.style.display=""}else{B.style.display="none"}}var F=document.getElementById("share_weixin_1");var E=document.getElementById("share_weixin_2");if(F&&E){if(J=="HTML"){F.style.display="";E.style.display=""}else{F.style.display="none";E.style.display="none"}}showEditor(J,true);if(I&&I.value=="4"){if(J=="OfficeWord"||J=="WpsWord"){if(typeof (resetTaohongList)!="undefined"){resetTaohongList();var A=document.getElementById("fileUrl");if(A){A.disabled=false}}}else{var A=document.getElementById("fileUrl");if(A){A.disabled=true}}}if(typeof (changeBodyTypeCallBack)!="undefined"){changeBodyTypeCallBack()}return true}return false}function getA8Top(){try{var A=getA8ParentWindow(window);if(A){return A}else{return top}}catch(B){return top}}function getA8ParentWindow(D){var A=D;for(var B=0;B<20;B++){if(typeof A.isCtpTop!="undefined"&&A.isCtpTop){return A}else{A=A.parent}}}function initCkEditor(){var A=null;if(document.readyState!="complete"){A=setTimeout("initCkEditor()",5);return }if(A!=null){clearTimeout(A)}var F=document.getElementById("content").parentElement;var B=F.style.display=="none";B=B?B:F.parentElement.style.display=="none";var E=(typeof (editorStartupFocus)=="undefined")?false:editorStartupFocus;var D=(typeof (editorDontResize)=="undefined")?false:editorDontResize;CKEDITOR.replace("content",{toolbar:oFCKeditor.ToolbarSet,height:"100%",startupFocus:!B&&E,on:{instanceReady:function(I){var G=document.getElementById("content");function J(K){var L=K.offsetTop;if(K.offsetParent!=null){L+=J(K.offsetParent)}return L}function H(){var N=CKEDITOR.instances.content;if(!N){return }var O=N.ui.space("contents");if(O==null){return }var K=document.documentElement.clientHeight-J(O.$)-5;K=K<0?0:K;if(document.getElementById("editerDiv")){var L=document.getElementById("editerDiv").style.height;L=L.replace("px","");if(L==""){L=K}CKEDITOR.instances.content.ui.space("contents").setStyle("height",L+"px")}else{O.setStyle("height",K+"px")}document.getElementById("RTEEditorDiv").style.display="block";var M=N.window.getFrame();if(M.$.style.width!="786px"){M.$.style.width="786px"}}H();window.onresize=function(K){if(D){return }H()};if(v3x&&v3x.isMSIE){I.editor.on("dialogShow",function(L){var K=L.data._.element.$.getElementsByTagName("a");for(var N=0;N<K.length;N++){var M=K[N].getAttribute("href");if(M&&M.indexOf("void(0)")>-1){K[N].removeAttribute("href")}}})}}}})}function showEditor(B,A){if(A==null||A==undefined){A=true}function D(){if(CKEDITOR.instances.content){CKEDITOR.instances.content.destroy();document.getElementById("content").style.height="0px";document.getElementById("RTEEditorDiv").style.display="none"}}if(!v3x.useFckEditor){D();if(B!="HTML"){document.getElementById("content").style.height="0px";document.getElementById("RTEEditorDiv").style.display="none"}}if(B=="HTML"){removeOfficeDiv(A);if(v3x.useFckEditor){oFCKeditor.ReplaceTextarea()}else{initCkEditor()}}else{if(B=="OfficeWord"){if(v3x.useFckEditor){oFCKeditor.remove()}showOfficeDiv("doc")}else{if(B=="OfficeExcel"){if(v3x.useFckEditor){oFCKeditor.remove()}showOfficeDiv("xls")}else{if(B=="WpsWord"){if(v3x.useFckEditor){oFCKeditor.remove()}showOfficeDiv("wps")}else{if(B=="WpsExcel"){if(v3x.useFckEditor){oFCKeditor.remove()}showOfficeDiv("et")}else{if(B=="Pdf"){if(v3x.useFckEditor){oFCKeditor.remove()}showPdfDiv("pdf")}else{if(B=="gd"){if(v3x.useFckEditor){oFCKeditor.remove()}showSursenDiv("gd")}}}}}}}var E=document.getElementById("bodyType");if(E){setContentTypeState(E.value,B);E.value=B}try{var F=document.getElementById("bulBottPre").value;if(F&&F=="1"){if(B=="HTML"){myBar.enabled("preview")}else{myBar.disabled("preview")}var I=document.getElementById("changePdf");var G=document.getElementById("bodyType");if(I&&G&&G.value=="WpsWord"){I.style.display="none"}}}catch(H){}}function initContentTypeState(){try{bodyType=document.getElementById("bodyType").value;bodyTypeSelector.disabled("menu_bodytype_"+bodyType)}catch(A){}}function setContentTypeState(A,B){try{if(A==B){bodyTypeSelector.disabled("menu_bodytype_"+B)}else{bodyTypeSelector.disabled("menu_bodytype_"+B);bodyTypeSelector.enabled("menu_bodytype_"+A)}}catch(D){}}function showNextCondition(A){if(!A){return }var B=A.options;for(var D=0;D<B.length;D++){var E=document.getElementById(B[D].value+"Div");if(E){E.style.display="none"}}if(!document.getElementById(A.value+"Div")){return }document.getElementById(A.value+"Div").style.display="block"}function showCondition(conditionValue,textfieldValue,textfield1Value){if(!conditionValue){return }var conditionObj=document.getElementById("condition");selectUtil(conditionObj,conditionValue);showNextCondition(conditionObj);var theDiv=document.getElementById(conditionValue+"Div");if(theDiv){var nodes=theDiv.childNodes;if(nodes){for(var j=0;j<nodes.length;j++){var node=nodes.item(j);if(node.tagName=="INPUT"){eval("node.value = "+node.name+"Value;")}else{if(node.tagName=="SELECT"){eval("selectUtil(node, "+node.name+"Value)")}}}}}}function selectUtil(E,B){if(!E){return false}var D=E.options;for(var A=D.length-1;A>=0;A--){if(D[A].value==B){E.selectedIndex=A;return true}}return false}function dateCheck(){var B=document.getElementById("startdate").value;var A=document.getElementById("enddate").value;if(compareDate(B,A)>0){window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));return false}doSearch()}var SearchEnter={submitCount:0};function doSearch(){var L=document.getElementsByName("searchForm")[0];var F=document.getElementById("createDateDiv");if(L){if(SearchEnter.submitCount>2){return }var R=L.condition.options;for(var I=0;I<R.length;I++){if(L.condition.value==R[I].value){var M=true;if("createDate"==L.condition.value){var G=document.getElementById(R[I].value+"Div");var D;if(G!=null){D=G.childNodes}var Q=new Array();if(D!=null){D=F.childNodes;for(var H=0;H<D.length;H++){var K=D[H];if(K.type=="text"){Q.push(K)}}}if((Q.length>0)&&(Q.length<3)){var B=Q[0].value;var A=B.split("-");var O=new Date();O.setFullYear(A[0],A[1]-1,A[2]);var P=Q[1].value;var J=P.split("-");var E=new Date();E.setFullYear(J[0],J[1]-1,J[2]);if(E<O){M=false}}}if(M){continue}else{window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));return }}var N=document.getElementById(R[I].value+"Div");if(N){N.innerHTML=""}}L.target=L.target||"_self";SearchEnter.submitCount++;L.submit()}}function doSearchEnter(){var A=v3x.getEvent();if(A.keyCode==13){doSearch()}}function listenerKeyESC(){var A=v3x.getEvent();if(A.keyCode==27){window.close()}}function validateCheckbox(B){B=B||"id";var F=document.getElementsByName(B);if(!F){return 0}var D=0;var A=F.length;for(var E=0;E<A;E++){if(F[E].checked){D++}}return D}function getCheckboxSingleValue(A){var B=getCheckboxSingleObject(A);return B==null?null:B.value}function getCheckboxSingleObject(B){B=B||"id";var F=document.getElementsByName(B);if(!F){return 0}var D=0;var A=F.length;for(var E=0;E<A;E++){if(F[E].checked){return F[E]}}return null}var currentOpinionId="";function hiddenReplyDiv(){var A=document.getElementById("replyDiv"+currentOpinionId);if(A){A.innerHTML="";A.style.display="none"}fileUploadAttachments.clear()}function reply(S,T,F,N,D,M,J,T){var P=document.getElementById("replyDiv"+currentOpinionId);if(P&&P.innerHTML!=""){return }hiddenReplyDiv();opinionId5=S;var B=document.getElementById("uploadAttachmentSpan");if(B!=null){B.style.display=(F==true?"":"none")}var K=document.getElementById("myDocumentSpan");if(K){K.style.display=(N==true?"":"none")}var I=document.getElementById("replyDiv"+S);if(I){I.innerHTML=document.getElementById("replyCommentHTML").innerHTML;I.style.display="";var L=document.getElementById("reply-table");if(L!=null){L.style.display=""}var R=document.getElementsByName("repform")[0];R.isHidden.id="isHidden";try{R.isSendMessage.id="isSendMessage"}catch(Q){}if(D){document.getElementById("isHiddenDiv").style.display="none"}if(R.b11){R.b11.focus()}R.content.focus();R.opinionId.value=S;if(T){R.memberId.value=T}var G=document.getElementById("affairMemberId");var H=document.getElementById("sendMessagePeopleSpan");if(G){if(M){var O=document.getElementById("pushMessageMemberNames");if(O&&currentUserId!=T){O.value=M}if(O&&currentUserId==T){R.isSendMessage.checked=false;H.style.display="none"}}if(J){var A=document.getElementById("pushMessageMemberIds");if(A){A.value=J+","+T}var E=document.getElementById("replyedAffairId");if(E){E.value=J}}}else{if(R.isSendMessage){R.isSendMessage.checked=false}if(H){H.style.display="none"}}}currentOpinionId=S}function checkReplyForm(A){if(checkForm(A)){return true}return false}function checkDefSubject(B,D){var A=getDefaultValue(B);if(D&&B.value==A){B.value=""}else{if(!B.value){B.value=A}}}function getDefaultValue(B){if(!B){return null}var A=B.attributes.getNamedItem("defaultValue");if(!A){A=B.attributes.getNamedItem("deaultValue")}if(A){return A.nodeValue}return null}function Panel(D,B,A){this.id=D;this.label=B;this.onclick=A||""}Panel.prototype.toString=function(){return"<div id='button-L"+this.id+"' class=\"sign-button-L\"></div><div id='button"+this.id+"' onClick=\"changeLocation('"+this.id+"');"+this.onclick+'" class="sign-button-M">'+this.label+"</div><div id='button-R"+this.id+'\' class="sign-button-R"></div><div class="sign-button-line"></div>'};Panel.prototype.toMinString=function(){return'<div class="sign-min-label" onclick="changeLocation(\''+this.id+"');"+this.onclick+'" title="'+this.label+'">'+this.label+'</div><div class="separatorDIV"></div>'};function showPanels(B){if(B!=false){document.write('<div id="hiddenPrecessAreaDiv" onclick="hiddenPrecessArea()" title="'+v3x.getMessage("V3XLang.common_hiddenPrecessArea")+'"></div>')}for(var A=0;A<panels.size();A++){document.write(panels.get(A).toString())}document.close()}function showMinPanels(){for(var A=0;A<panels.size();A++){document.write(panels.get(A).toMinString())}document.close();setNoOrResize(true)}function setNoOrResize(B){try{var A=parent.document.getElementById("detailRightFrame");if(A){A.noResize=B}else{return }}catch(D){}}function changeLocation(G){for(var B=0;B<panels.size();B++){var A=panels.get(B).id;if(A==G){continue}document.getElementById("button-L"+A).className="sign-button-L";document.getElementById("button"+A).className="sign-button-M";document.getElementById("button-R"+A).className="sign-button-R";var F=document.getElementById(A+"TR");if(F){F.style.display="none"}}var E=document.getElementById("button"+G);if(E){document.getElementById("button-L"+G).className="sign-button-L-sel";E.className="sign-button-M-sel";document.getElementById("button-R"+G).className="sign-button-R-sel"}var D=document.getElementById(G+"TR");if(D){D.style.display=""}setNoOrResize(false)}function showPrecessArea(B){try{parent.detailMainFrame.contentIframe.SeeyonForm_HideArrow()}catch(E){}B=B||"32%";try{parent.document.getElementById("zy").cols="*,"+B}catch(E){}var D=document.getElementById("signAreaTable");if(D){D.style.display=""}var A=document.getElementById("signMinDiv");if(A){A.style.display="none";A.style.height="0px"}}function hiddenPrecessArea(){try{parent.detailMainFrame.contentIframe.SeeyonForm_HideArrow()}catch(D){}try{parent.document.getElementById("zy").cols="*,45"}catch(D){}var B=document.getElementById("signAreaTable");if(B){B.style.display="none"}var A=document.getElementById("signMinDiv");if(A){A.style.display="";A.style.height="100%"}setNoOrResize(true)}function refreshIt(){location.reload(true)}function refreshWorkSpace(){var A=getA8Top().reFlesh()}function locationBack(){history.back()}function escapeStringToHTML(B,A){if(!B){return""}B=B.replace(/&/g,"&amp;");B=B.replace(/</g,"&lt;");B=B.replace(/>/g,"&gt;");B=B.replace(/\r/g,"");B=B.replace(/\n/g,"<br/>");B=B.replace(/\'/g,"&#039;");B=B.replace(/"/g,"&#034;");if(typeof (A)!="undefined"&&(A==true||A=="true")){B=B.replace(/ /g,"&nbsp;")}return B}function escapeStringToJavascript(A){if(!A){return A}A=A.replace(/\\/g,"\\\\");A=A.replace(/\r/g,"");A=A.replace(/\n/g,"");A=A.replace(/\'/g,"\\'");A=A.replace(/"/g,'\\"');return A}function getParameter(D){var F=document.location.search;if(F){F=F.substring(1);var E=F.split("&");for(var B=0;B<E.length;B++){var A=E[B].split("=");if(D==A[0]){return A[1]}}}}function setSelectValue(D,F){var A=document.getElementById(D);if(!A){return }var E=A.options;if(!E){return }for(var B=0;B<E.length;B++){var G=E[B];if(G.value==F){G.selected=true;break}}}var sxUpConstants={status_0:"0,*",status_1:"35%,*"};var sxDownConstants={status_0:"*,9",status_1:"35%,*"};var sxMiddleConstants={status_0:"35%,*",status_1:"35%,*"};var indexFlag=0;function previewFrame(direction){if(!direction){return }var obj=parent.parent.document.getElementById("sx");if(obj==null){obj=parent.document.getElementById("sx")}if(obj==null){return }if(indexFlag>1){indexFlag=0}var status=eval("sx"+direction+"Constants.status_"+indexFlag);obj.rows=status;if(direction!="Middle"){indexFlag++}}function checkImageSize(A){if(A.width>540){A.width=540}}function getDetailPageBreak(F,E){var A=true;if(F!=true&&(getA8Top().window.dialogArguments||window.opener)){A=false}var D="";try{D=v3x==null?"":v3x.baseURL+"/common/"}catch(B){}document.write('<table id=\'pagebreakspare\' border="0" cellpadding="0" cellspacing="0" width="100%" align="center">');document.write('<tr align="center">');document.write("<td style='overflow:hidden;' class=\"detail-top\" valign='top'>");if(A){document.write('<table border="0" cellpadding="0" cellspacing="0" width="100%">');document.write("<tr>");document.write("<td valign='top'>");document.write("<div class='break-up' onclick=\"previewFrame('Up')\"></div>");document.write("</td>");document.write("<td valign='top'>");document.write("<div class='break-down' onclick=\"previewFrame('Down')\"></div>");document.write("</td>");document.write("</tr>");document.write("</table>")}else{document.write("&nbsp;")}document.write("</td>");document.write("</tr>");document.write("</table>");document.close();if(E=="Down"){previewFrame("Down")}else{previewFrame("Middle")}}function getLimitLength(D,A,B){return D.getLimitLength(A,B)}function changeMenuTab(D){var G=document.getElementById("menuTabDiv");var F=D.className;if(F=="tab-tag-middel-sel"){return }var E=G.getElementsByTagName("div");var B;for(B=0;B<E.length;B++){F=E[B].className;if(F.substr(F.length-4)=="-sel"){E[B].className=F.substr(0,F.length-4)}}for(B=0;B<E.length;B++){if(D==E[B]){E[B-1].className=E[B-1].className+"-sel";E[B].className=E[B].className+"-sel";E[B+1].className=E[B+1].className+"-sel"}}var A=document.getElementById("detailIframe").contentWindow;A.location.href=D.getAttribute("url")}function setDefaultTab(E){var D=document.getElementById("menuTabDiv");var B=D.getElementsByTagName("div");B[E*4].className=B[E*4].className+"-sel";B[E*4+1].className=B[E*4+1].className+"-sel";B[E*4+2].className=B[E*4+2].className+"-sel";var A=document.getElementById("detailIframe").contentWindow;A.location.href=B[E*4+1].getAttribute("url")}function getRadioValue(B){var D=document.getElementsByName(B);if(!D){return null}for(var A=0;A<D.length;A++){if(D[A].checked){return D[A].value}}return null}var sx_variable={detailFrameName:"",title:"",imgSrc:"",count:0,description:"",isShow:false};function showDetailPageBaseInfo(A,F,B,E,D){parent.sx_variable.detailFrameName=A;parent.sx_variable.title=F;parent.sx_variable.imgSrc=B;parent.sx_variable.count=E;parent.sx_variable.description=D;parent.doDetailPageBaseInfo()}function doDetailPageBaseInfo(){if(!sx_variable.detailFrameName){return }var detailDocument=null;try{detailDocument=eval(sx_variable.detailFrameName)}catch(e){}if(detailDocument&&detailDocument.document.readyState=="complete"){var flag=eval("detailDocument.detailPageBaseInfoFlag");if(!flag){detailDocument.location.href=v3x.baseURL+"/common/detail.jsp";window.setTimeout("doDetailPageBaseInfo()",500);return }detailDocument.document.getElementById("titlePlace").innerHTML=sx_variable.title;if(sx_variable.count!=null&&sx_variable.count>=0){detailDocument.document.getElementById("countPlace").innerHTML=v3x.getMessage("V3XLang.common_detailPage_count_label","<span class='countNumber'>"+sx_variable.count+"</span>")}detailDocument.document.getElementById("descriptionPlace").innerHTML=sx_variable.description||"";detailDocument.document.getElementById("allDiv").style.display=""}else{window.setTimeout("doDetailPageBaseInfo()",500)}}function reloadDetailPageBaseInfo(){try{parent.doDetailPageBaseInfo()}catch(A){}}function changeTabUnSelected(A){if(A){document.getElementById("l-"+A).className="tab-tag-left";document.getElementById("m-"+A).className="tab-tag-middel cursor-hand";document.getElementById("r-"+A).className="tab-tag-right"}}function changeTabSelected(A){if(A){document.getElementById("l-"+A).className="tab-tag-left-sel";document.getElementById("m-"+A).className="tab-tag-middel-sel";document.getElementById("r-"+A).className="tab-tag-right-sel"}}var newIdes;var pigeonholeItem={};function pigeonhole(B,E,H,F,D,A){pigeonholeItem.collBackFuns=A;newIdes=E;if(typeof (D)=="undefined"){D=""}if(typeof (A)!="undefined"){getA8Top().pigeonholeWin=getA8Top().$.dialog({title:v3x.getMessage("V3XLang.doc_v3x_pigeonhole_title"),transParams:{parentWin:window},url:v3x.baseURL+"/doc.do?method=docPigeonhole&appName="+B+"&atts="+H+"&validAcl="+F+"&pigeonholeType="+D,width:500,height:500,isDrag:false,closeParam:{show:true,autoClose:false,handler:function(){if(typeof (A)=="string"&&window[A]){window[A]("cancel")}getA8Top().pigeonholeWin.close()}}})}else{var G=v3x.openWindow({url:v3x.baseURL+"/doc.do?method=docPigeonhole&appName="+B+"&atts="+H+"&validAcl="+F+"&pigeonholeType="+D,width:"500",height:"500",resizable:"true",scrollbars:"true"});if(G==undefined){G="cancel"}return G}}function pigeonholeChromeCollBack(A){getA8Top().pigeonholeWin.close();var B=new Function(pigeonholeItem.collBackFuns+"('"+A+"');");B()}function projectPigeonhole(A,D,B,F){var E=v3x.openWindow({url:v3x.baseURL+"/doc.do?method=docTreeProjectIframe&appName="+A+"&ids="+D+"&projectId="+B+"&atts="+F,width:"500",height:"500",resizable:"true",scrollbars:"true"});if(E==undefined){E="cancel"}return E}function isPhoneNumber(B){var E=B.value;var A=B.getAttribute("inputName");var D=/^([\d-]*)$/;if(!D.test(E)){writeValidateInfo(B,v3x.getMessage("V3XLang.formValidate_isNumber",A));return false}return true}function Avacount(A){var D=A.value;var B=document.getElementById("Avacount").value;if(parseInt(D)>parseInt(B)){alertAvacount();return false}return true}function setScrollPosition(A,E,D){var B=(D!=null)?document.getElementById(D):document.body;B.scrollLeft=A;B.scrollTop=E}function resizeBody(D,A,B,G){try{B=(B=="min")?"min":"max";G=(G=="left")?"left":"right";var F=parent.document.getElementById(A);if(F==null){F=parent.parent.document.getElementById(A)}if(B=="max"){if(document.body.clientWidth>D){if(G=="left"){F.cols=""+D+",*"}else{F.cols="*,"+D+""}}}else{if(document.body.clientWidth<D){if(G=="left"){F.cols=""+D+",*"}else{F.cols="*,"+D+""}}}}catch(E){}}function resizeRightBody(D,A,B){try{var F=parent.document.getElementById(A);if(F==null){F=parent.parent.document.getElementById(A)}if(document.body.clientWidth<D){F.cols="*,"+B+""}}catch(E){}}function cancelOk(){try{var E=arguments[0];if(E!=null){if(E.page!=null&&E.page=="new"){window.location.href=v3x.baseURL+"/common/detail.jsp"}else{if(E.page!=null&&E.page=="edit"){var H=document.forms;for(var D=0;D<H.length;D++){for(var A=0;A<H[D].length;A++){if(E.enable!=null){for(var B=0;B<E.enable.length;B++){if(H[D][A].id==E.enable[B]){break}else{H[D][A].disabled=true}}}else{H[D][A].disabled=true}}}if(E.hidden!=null){for(var F=0;F<E.hidden.length;F++){document.getElementById(E.hidden[F]).style.display="none"}}}else{window.close()}}}else{window.location.href=v3x.baseURL+"/common/detail.jsp"}}catch(G){}}function showV3XMemberCard(A,D){var B=new MxtWindow({id:"member_view_win",title:"",url:getBaseURL()+"/organization/peopleCard.do?method=showPeoPleCard&type=withbutton&memberId="+A,width:500,height:450,type:"window",targetWindow:D==undefined?getA8Top():D,isDrag:true,buttons:[{text:v3x.getMessage("V3XLang.close"),handler:function(){B.close()}}]})}function showV3XMemberCardWithOutButton(A,D){var B=new MxtWindow({id:"member_view_win",title:"",url:getBaseURL()+"/organization/peopleCard.do?method=showPeoPleCard&type=withoutbutton&memberId="+A,width:500,height:450,type:"window",targetWindow:D==undefined?getA8Top():D,isDrag:true,buttons:[{text:v3x.getMessage("V3XLang.close"),handler:function(){B.close()}}]})}function ajaxCheckAccountExchangePendingAffair(D,F){try{var A=new XMLHttpRequestCaller(this,"ajaxEdocExchangeManager","checkEdocExchangeHasPendingAffair",false);A.addParameter(1,"Long",D);var B=A.serviceRequest();if(B!="0"){if(F!=""){alert(v3x.getMessage("MainLang.edoc_alert_hasExchangePendingAffair",F))}else{alert(v3x.getMessage("MainLang.edoc_alert_notdelteAllExchanger"))}return true}return false}catch(E){alert("Exception : "+E);return false}}function isOpenFromGenius(){var B=false;try{B=getA8Top().location.href.indexOf("a8genius.do")>-1}catch(A){alert(A)}return B}if(navigator.userAgent.indexOf("iPad")!=-1){window.addEventListener("load",function(){getA8Top().document.body.style.height="690px"})}function setFFGrid(A,B){if(A==""||B==false){return }if(document.all){window.attachEvent("onload",function(){mxtgrid(A)});window.attachEvent("onresize",function(){resizeGrid(A,B)})}else{mxtgrid(A);window.addEventListener("resize",function(){resizeGrid(A,B)},false)}}function mxtgrid(H){try{var D={id:"",srollLeft:0,_srollLeft:0,dragLeft:0,xStart:0,xEnd:0,eStart:0,oMove:null,iIndex:0,_drag:0,stopDrag:false,dragFlag:false,scroll:function(){D.hDiv.scrollLeft=D.bDiv.scrollLeft},setPosition:function(){var I=parseInt(D.hDiv.scrollLeft);var L=D.srollLeft-I;D.cDrag.style.display="none";var N=D.cDrag.childNodes;for(var K=0;K<N.length;K++){var M=N[K];if(typeof M=="object"&&M.nodeType!=3){var J=parseInt(M.style.left)+L;M.style.left=J+"px"}}D.srollLeft=I;D.cDrag.style.display=""},setDragPosition:function(){var I=parseInt(D.hDiv.scrollLeft);var K=D.srollLeft-I;D.cDrag.style.display="none";var N=D.cDrag.childNodes;for(var J=0;J<N.length;J++){var M=N[J];if(typeof M=="object"&&M.nodeType!=3){var L=parseInt(M.style.left)+K;M.style.left=L+"px"}}D.srollLeft=I;D.cDrag.style.display=""},attEvt:function(){var K=D.cDrag.childNodes;for(var I=0;I<K.length;I++){var J=K[I];if(typeof J=="object"&&J.nodeType!=3){J.onmousedown=D.dragStart}}},getIndex:function(){if(D.oMove!=null&&D.cDrag!=null){var J=D.cDrag.childNodes;for(var I=0;I<J.length;I++){if(J[I]==D.oMove){D.iIndex=I}}}},dragStart:function(){D.oMove=this;D.moveOrigintLeft=parseInt(D.oMove.style.left);D.getIndex();document.onmousedown=D.mousedown;document.onmousemove=D.mousemove;document.onmouseup=D.mouseup;document.onselectstart=function(){return false};document.onselect=function(){document.selection.empty()}},mousedown:function(J){D.bDiv.style.overflowY="auto";D.bDiv.style.overflowX="auto";D.dragFlag=true;var I=D.getEvent();D.eStart=D.xStart=document.all?I.x:I.pageX;document.body.style.cursor="col-resize"},mousemove:function(N){if(!D.dragFlag){return }var M=D.getEvent();var J=document.all?M.x:M.pageX;var I=J-D.eStart;var L=D.oMove.previousSibling;var K=parseInt(D.oMove.style.left)+I;if(K>D.clientWidth||K<50){D.xEnd=D.eStart;D.oMove.style.left=D.moveOrigintLeft+"px";document.body.style.cursor="default";D.dragFlag=false;D.stopDrag=false;D.oMove=null;document.onmousedown=null;document.onmousemove=null;document.onmouseup=null;document.onselectstart=null;document.onselect=null}else{if(L!=null){if(K>(parseInt(L.style.left)+50)){D.oMove.style.left=K+"px";D.eStart=J}else{D.stopDrag=true}}else{if(K>50){D.oMove.style.left=K+"px";D.eStart=J}else{D.stopDrag=true}}}},mouseup:function(J){if(!D.dragFlag){return }var I=D.getEvent();D.xEnd=document.all?I.x:I.pageX;if(D.stopDrag){D.xEnd=D.eStart}D.setDragPosition();D.setHeadWidth();D.setListWidth();if(D._drag<0&&D.hDiv.scrollLeft==0){D.bDiv.scrollLeft=0}else{D.hDiv.scrollLeft=D.bDiv.scrollLeft}D.setPosition();document.body.style.cursor="default";D.dragFlag=false;D.stopDrag=false;D.oMove=null;document.onmousedown=null;document.onmousemove=null;document.onmouseup=null;document.onselectstart=null;document.onselect=null;if(!document.all){}},setHeadWidth:function(){var I=D.oHead.childNodes[D.iIndex];var J=I.childNodes[0];var K=parseInt(J.style.width)+D._drag;J.style.width=K+"px";I.setAttribute("width",K);D.globalWidth=D.bTable.clientWidth;D.hTable.setAttribute("width",D.globalWidth+D._drag);if(D.noBody==true){D.bDiv.innerHTML="<div style='width:"+(D.holeWidth+D._drag)+"px'>&nbsp;</div>"}},setListWidth:function(){var J=D.oBody.childNodes;for(var M=0;M<J.length;M++){var L=J[M].childNodes[D.iIndex];var I=L.childNodes[0];var K=parseInt(I.style.width)+D._drag;I.style.width=K+"px";L.setAttribute("width",K)}D.bTable.setAttribute("width",D.globalWidth+D._drag)},setDragPosition:function(){D._srollLeft=parseInt(D.hDiv.scrollLeft);D._drag=D.xEnd-D.xStart;var L=D.cDrag.childNodes;for(var J=(D.iIndex+1);J<L.length;J++){var K=L[J];if(typeof K=="object"&&K.nodeType!=3){var I=parseInt(K.style.left)+D._drag;K.style.left=I+"px"}}},getEvent:function(){if(document.all){return window.event}func=D.getEvent.caller;while(func!=null){var I=func.arguments[0];if(I){if((I.constructor==Event||I.constructor==MouseEvent)||(typeof (I)=="object"&&I.preventDefault&&I.stopPropagation)){return I}}func=func.caller}return null},removeTextNode:function(J){var L=J.childNodes;for(var I=0;I<L.length;++I){var K=L[I];if(K.nodeType!=1){K.parentNode.removeChild(K)}}},aa:function(){alert(1)},setWidth:function(){var O=new ArrayList();var T=D.oHead.childNodes;var K=D.subHeight==0?Math.floor(D.clientWidth-T.length*12-2):Math.floor(D.clientWidth-T.length*12-20);var Y=27;D.cDrag.style.display="none";var X=0;var P=0;for(var N=0;N<T.length;++N){var I=T[N];var S=I.childNodes[0];var R=D.cDrag.childNodes[N];var L=I.getAttribute("width");if(L==null||L==undefined||L==""){L="5%"}var W;if(L.indexOf("%")!=-1){W=Math.floor(K*(parseInt(L))/100)}else{W=Math.floor(L)}X+=W+10;O.add(W);P+=W;I.setAttribute("width","");S.style.width=W+"px";I.onmouseover=function(){if(this.className!="sorted"){this.className="thOver"}};I.onmouseout=function(){if(this.className!="sorted"){this.className=""}};R.style.left=(X)+"px";R.style.height=Y+"px"}D.holeWidth=P+T.length*12+2;D.cDrag.style.display="";var U=D.oBody.childNodes;if(U.length!=0){for(var M=0;M<U.length;++M){var V=U[M].childNodes;for(var J=0;J<V.length;++J){var Q=V[J];I.onmouseover=function(){this.parentNode.className="thOver"};Q.childNodes[0].style.width=O.get(J)+"px";if(v3x.isMSIE7&&!v3x.isMSIE8&&!v3x.isMSIE9){Q.setAttribute("width",(O.get(J)+10))}}}}else{D.noBody=true;D.bDiv.innerHTML="<div style='width:"+D.holeWidth+"px'>&nbsp;</div>"}},setTitle:function(){var M=D.oHead.childNodes;for(var I=0;I<M.length;++I){var L=M[I];var K=L.childNodes[0];if(K){var J=K.innerHTML.toUpperCase();if(J.indexOf("<INPUT")!=-1||J.indexOf("<IMG")!=-1||J.indexOf("<FONT")!=-1||J.indexOf("<SPAN")!=-1){J=""}if(J=="&nbsp;"){J=""}J=J.replace(/\&AMP;/g,"&");K.setAttribute("title",J)}}}};D.id=H;D.layoutdiv=document.getElementById("scrollListDiv");if(D.layoutdiv==null){D.layoutdiv=document.body}else{D.layoutdiv.style.overflow="hidden"}D.clientWidth=parseInt(D.layoutdiv.clientWidth);D.clientHeight=parseInt(D.layoutdiv.clientHeight);if(D.clientHeight<=0||D.clientWidth<=0){setTimeout(function(){mxtgrid(D.id)},100)}D.mxtgrid=document.getElementById("mxtgrid_"+H);D.mxtgrid.style.display="none";D.hTable=document.getElementById("hTable"+H);D.bTable=document.getElementById("bTable"+H);D.bDiv=document.getElementById("bDiv"+H);D.hDiv=document.getElementById("hDiv"+H);D.cDrag=document.getElementById("cDrag"+H);D.oHead=document.getElementById("headID"+H);D.oBody=document.getElementById("bodyID"+H);D.subHeight=parseInt(D.mxtgrid.getAttribute("subHeight"));if(D.subHeight!=0){D.mxtgrid.style.width=D.clientWidth+"px"}if(D.clientHeight-56-D.subHeight<=0){return }var F=v3x.isMSIE6&&!v3x.isMSIE7&&!v3x.isMSIE8&&!v3x.isMSIE9;if((D.oBody.childNodes.length*28+56)>D.clientHeight){D.clientWidth=D.clientWidth-17}D.bDivHeight=D.clientHeight-60-D.subHeight;D.bDiv.style.height=D.bDivHeight+"px";if(F){D.layoutdivParent=D.layoutdiv.parentNode;D.bDiv.style.height=(D.bDivHeight-parseInt(D.layoutdivParent.currentStyle.paddingTop))+"px";D.bDiv.style.width=D.clientWidth+"px";D.hDiv.style.width=D.clientWidth+"px"}D.removeTextNode(D.cDrag);D.removeTextNode(D.oHead);D.removeTextNode(D.oBody);var B=D.oBody.childNodes;for(var A=0;A<B.length;++A){D.removeTextNode(B[A])}D.setTitle();D.setWidth();D.attEvt();D.bDiv.onscroll=function(){D.scroll();D.setPosition()};if(D.bTable.clientWidth<D.bDiv.clientWidth){D.bDiv.style.overflowY="auto";D.bDiv.style.overflowX="hidden"}D.mxtgrid.style.display=""}catch(E){var G=document.getElementById("mxtgrid_"+H);if(G){G.style.display=""}}}function setTablePosition(A,B){if(B==null){if(A!=null&&A.document!=null&&A.document.rowPositionObj){A.document.rowPositionObj.focus()}else{return }}else{A.target.focus()}}function setPositionObj(A){document.rowPositionObj=A}function resizeGrid(N,H){try{var M=N;var O=document.getElementById("scrollListDiv");if(O==null||O.clientHeight<=0){O=document.body}var Q=Math.floor(O.clientWidth);var I=Math.floor(O.clientHeight);if(I<=0){return }var R=document.getElementById("mxtgrid_"+M);var S=document.getElementById("hTable"+M);var A=document.getElementById("bTable"+M);R.style.display="none";var K=document.getElementById("bDiv"+M);var J=document.getElementById("hDiv"+M);var D=document.getElementById("cDrag"+M);var W=document.getElementById("headID"+M);var F=document.getElementById("bodyID"+M);var V=parseInt(R.getAttribute("subHeight"));if(V!=0){R.style.width=Q+"px"}if(I-56-V<=0){return }var L=v3x.isMSIE6&&!v3x.isMSIE7&&!v3x.isMSIE8&&!v3x.isMSIE9;if(L){Q=Q-15}var E=I-56-V;K.style.height=E+"px";if(L){layoutdivParent=O.parentNode;K.style.height=(E-parseInt(layoutdivParent.currentStyle.paddingTop))+"px"}D.style.display="none";var U=D.childNodes;for(var P=0;P<U.length;++P){var G=U[P];G.style.height=27+"px"}D.style.display="";R.style.display=""}catch(T){var B=document.getElementById("mxtgrid_"+M);B.style.display=""}}function MxtWindow(D){if(D==null){return }this.id=D.id?D.id:Math.floor(Math.random()*100000000);this.title=D.title?D.title:"";this.url=D.url;this.height=D.height==null?250:D.height;this.width=D.width==null?300:D.width;this.titleHeight=32;this.footerHeight=40;this.top=D.top;this.left=D.left;this.model=D.model==null?true:false;this.className=D.calssName==null?"mxt-window":D.classNam;this.element=D.obj;this.relativeElement=D.relativeElement;this.isCeate=true;this.buttons=D.buttons;this.isSynchronization=D.isSynchronization==null?false:true;this.userAgent=navigator.userAgent.toLowerCase();this.isOpera=this.userAgent.indexOf("opera")>-1;this.isIE=this.userAgent.indexOf("msie")>-1&&!this.isOpera;this.isNS=this.userAgent.indexOf("netscape")>-1;this.dragDiv=null;this.isIframe=false;this.iframe=null;this.iframeId=null;this.html=D.html;this.offsetTop=0;this.offsetLeft=0;this.discription=D.discription==undefined?"":D.discription;this.closeParam=D.closeParam;this.closeHidden=D.closeHidden==undefined?false:D.closeHidden;this.maskIndex=1000;this.transParams=D.transParams==undefined?null:D.transParams;this.targetWindow=D.targetWindow==undefined?window:D.targetWindow;this.setIndex();var F=parseInt(this.targetWindow.document.documentElement.clientWidth);var E=parseInt(this.targetWindow.document.body.clientWidth);if(E>F){F=E}if(F<this.width){this.width=F}var A=parseInt(this.targetWindow.document.documentElement.clientHeight);var B=parseInt(this.targetWindow.document.body.clientHeight);if(B>A){A=B}if(A<this.height){this.height=A}this.type=D.type==null?"window":D.type;this.isDrag=D.isDrag==null?true:D.isDrag;this.initWindow();this.isModel();this.showWindow();this.addEffect();this.showWindow()}MxtWindow.prototype.setTitle=function(B){var A=this.targetWindow.document.getElementById(this.id+"-mxtwindow-title");if(A){A.innerHTML=B}};MxtWindow.prototype.setIndex=function(){var D=this.getClass("div","shield");if(D&&D.length>0){if(D.length==1){this.maskIndex=1002}if(D.length>1){for(var A=0;A<D.length;A++){var B=D[A];var E=parseInt(B.style.zIndex);if(E>this.maskIndex){this.maskIndex=E}}this.maskIndex=this.maskIndex+2}}};MxtWindow.prototype.getClass=function(D,B){try{if(this.targetWindow.document.getElementsByClassName){return this.targetWindow.document.getElementsByClassName(B)}else{var D=this.targetWindow.document.getElementsByTagName(D);var F=[];for(var A=0;A<D.length;A++){if(D[A].className==B){F[F.length]=D[A]}}return F}}catch(E){var D=this.targetWindow.document.getElementsByTagName(D);var F=[];for(var A=0;A<D.length;A++){if(D[A].className==B){F[F.length]=D[A]}}return F}};MxtWindow.prototype.getReturnValue=function(){var D=null;var B=this.targetWindow;var G=null;if(this.isIE){try{G=B.document.frames(this.iframeId)}catch(F){G=B.frames[this.iframeId]}}else{G=B.frames[this.iframeId]}if(G==null){try{for(var E=0;E<B.frames.length;E++){if(B.frames[E].name==this.iframeId){D=E;break}}if(D!=null){G=B.frames[D]}}catch(F){G=B.document.getElementById(this.iframeId)}}if(G==null){G=document.getElementById(this.iframeId)}if(G!=null){var A=null;if(G.contentWindow){A=G.contentWindow.OK()}else{A=G.OK()}return A}else{return null}};MxtWindow.prototype.initWindow=function(){var A=this.getElement(this.id);if(A!=null){this.removeElement(A)}if(this.url==null){this.isIframe=false}else{this.isIframe=true}if(this.relativeElement!=null){var E=this.relativeElement.offsetLeft;var D=this.relativeElement.offsetTop;var B=this.relativeElement;do{B=B.offsetParent;E+=B.offsetLeft;D+=B.offsetTop}while(B.tagName!="BODY");this.offsetLeft=E;this.offsetTop=D}if(this.buttons==null||this.buttons==undefined){this.footerHeight=0}if(this.type=="window"){this.getWindow()}else{this.getPanel()}};MxtWindow.prototype.addEffect=function(){if(this.isDrag){new this.targetWindow.MxtWindow.divDrag([this.dragDiv,this.element])}};MxtWindow.prototype.officeAction=function(A){var E=["officeFrameDiv","zwIframe","mainbodyFrame","officeDivInner"];for(var B=0;B<E.length;B++){var D=E[B];var F=document.getElementById(D);if(F){this.officeIframe=F;break}}if(!A){if(this.officeIframe){this.officeIframe.style.visibility="hidden"}if(hideOfficeObj){hideOfficeObj()}}else{if(this.officeIframe){this.officeIframe.style.visibility="visible"}if(showOfficeObj){showOfficeObj()}}};MxtWindow.prototype.showWindow=function(){if(this.targetWindow.document.getElementById(this.id)!=null){return }if(this.isSynchronization){if(this.targetWindow.document.getElementById("_isSynchronization")!=null){return }}this.targetWindow.document.body.appendChild(this.element);if(this.transParams!=null){try{this.iframe.contentWindow.transParams=this.transParams}catch(A){this.iframe.contentWindow.transParams=this.transParams}}this.officeAction(false)};MxtWindow.prototype.isModel=function(){if(this.model){if(this.targetWindow.document.getElementById(this.id+"_oMxtMask")!=null){return }var D=this.targetWindow.document.createElement("div");D.id=this.id+"_oMxtMask";D.className="shield black25";var B=parseInt(this.targetWindow.document.body.scrollWidth);var A=parseInt(this.targetWindow.document.body.scrollHeight);var E="top:0px;left:0px;position:absolute;z-index:"+this.maskIndex+";width:"+B+"px;height:"+A+"px;";D.style.cssText=E;this.targetWindow.document.body.appendChild(D)}else{return }};MxtWindow.prototype.close=function(A){try{this.targetWindow.document.getElementById(this.iframeId).contentWindow.document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("officeEditorFrame").contentWindow.pdfOcxUnLoad()}catch(A){}try{this.targetWindow.document.getElementById(this.iframeId).contentWindow.document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("officeEditorFrame").contentWindow.OcxUnLoad()}catch(A){}this.targetWindow.document.getElementById(this.iframeId).src="";this.removeElement(this.targetWindow.document.getElementById(this.id));if(this.model){if(this.targetWindow.document.getElementById(this.id+"_oMxtMask")!=null){this.removeElement(this.targetWindow.document.getElementById(this.id+"_oMxtMask"))}}this.officeAction(true)};MxtWindow.prototype.getPanel=function(){this.element=this.createObj("div");this.element.className=this.className;this.element.id=this.id;if(this.isIE){this.element.style.width=this.width+2+"px";this.element.style.height=this.height+"px"}else{this.element.style.width=this.width+"px";this.element.style.height=this.height+"px"}if(this.relativeElement!=null){this.top=parseInt(this.offsetTop)+parseInt(this.relativeElement.offsetHeight)+"px";this.left=parseInt(this.offsetLeft)+"px";if(parseInt(this.offsetLeft)+parseInt(this.relativeElement.offsetWidth)+parseInt(this.width)>parseInt(this.targetWindow.document.body.clientWidth)){this.left=parseInt(this.offsetLeft)-this.width+"px"}}if(this.top==null){this.top=(parseInt(this.targetWindow.document.body.clientHeight)-this.height)/2+"px";this.left=(parseInt(this.targetWindow.document.body.clientWidth)-this.width)/2+"px"}this.element.style.top=this.top;this.element.style.left=this.left;var J=this.createObj("div");J.className="mxt-panel-head";J.style.height="20px";J.onselectstart=function(){return false};this.dragDiv=J;var L=this.createObj("span");L.className="mxt-panel-head-close";var M=this;MxtWindow.addEvent(L,"click",function(O){return M.close(O)},false);J.appendChild(L);var E=this.createObj("div");E.className="mxt-panel-body";E.style.height=this.height-this.footerHeight-10+"px";E.appendChild(J);if(this.isIframe){this.iframeId=parseInt(Math.random()*10000)+"-iframe";var F=this.targetWindow.document.createElement("iframe");F.setAttribute("src",this.url);F.id=this.iframeId;F.name=this.iframeId;F.setAttribute("frameborder","0");F.className="mxt-window-body-iframe";F.style.height=parseInt(E.style.height)-20+"px";F.style.width=this.width-10+"px";this.iframe=F;E.appendChild(this.iframe)}else{var G=this.createObj("div");G.className="mxt-panel-body-content";G.style.height=parseInt(E.style.height)-10+"px";if(this.html){G.innerHTML=this.html}E.appendChild(G)}this.element.appendChild(E);var K=this.createObj("div");K.className="mxt-panel-footer";K.style.height=this.footerHeight+"px";if(this.discription!=null){var D=this.createObj("div");D.className="discriptionDiv";D.innerHTML=this.discription;K.appendChild(D)}if(this.buttons!=null&&this.buttons.length>0){var I=this.createObj("div");I.className="buttonsDiv";for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];var N=this.createObj("input");N.setAttribute("type","button");N.className="button-default-2 margin_r_5";if(A.emphasize){N.className="button-default_emphasize margin_r_5"}if(A.text){N.setAttribute("value",A.text)}if(A.id){N.setAttribute("id",A.id)}if(A.disabled){N.setAttribute("disabled",A.disabled)}if(A.handler){MxtWindow.addEvent(N,"click",A.handler,false)}I.appendChild(N)}K.appendChild(I)}this.element.appendChild(K);if(this.isSynchronization){var H=this.createObj("input");H.setAttribute("type","hidden");H.setAttribute("id","_isSynchronization");this.element.appendChild(H)}};MxtWindow.prototype.getWindow=function(){this.element=this.createObj("div");this.element.className=this.className;this.element.id=this.id;this.element.style.width=this.width+"px";this.element.style.height=this.height+"px";this.element.style.zIndex=this.maskIndex+1;this.elementContent=this.createObj("div");this.elementContent.style.position="absolute";this.elementContent.style.zIndex="10";this.element.appendChild(this.elementContent);this.iframeMask=this.targetWindow.document.createElement("iframe");this.iframeMask.style.position="absolute";this.iframeMask.style.zIndex="1";this.iframeMask.id=this.iframeId+"_iframeMask";this.iframeMask.setAttribute("frameBorder","0");this.iframeMask.style.width=(this.width)+"px";this.iframeMask.style.height=this.height+"px";this.element.appendChild(this.iframeMask);if(this.relativeElement!=null){this.top=parseInt(this.offsetTop)+parseInt(this.relativeElement.offsetHeight)+"px";this.left=parseInt(this.offsetLeft)+"px";if(parseInt(this.offsetLeft)+parseInt(this.relativeElement.offsetWidth)/2+parseInt(this.width)>parseInt(this.targetWindow.document.body.clientWidth)){this.left=parseInt(this.offsetLeft)-this.width+"px"}}if(this.top==null){if(parseInt(this.targetWindow.document.body.clientHeight)-this.height<0){this.top="10px"}else{this.top=(parseInt(this.targetWindow.document.body.clientHeight)-this.height)/2+"px"}this.left=(parseInt(this.targetWindow.document.body.clientWidth)-this.width)/2+"px"}this.element.style.top=this.top;this.element.style.left=this.left;var J=this.createObj("div");J.className="mxt-window-head";J.style.height=this.titleHeight+"px";J.onselectstart=function(){return false};this.dragDiv=J;var K=this.createObj("span");K.id=this.id+"-mxtwindow-title";K.className="mxt-window-head-title";K.innerHTML=this.title;var M=this.createObj("span");M.className="mxt-window-head-close";var N=this;if(this.closeParam&&this.closeParam.handler){MxtWindow.addEvent(M,"click",this.closeParam.handler,false)}else{MxtWindow.addEvent(M,"click",function(P){return N.close(P)},false)}if(this.closeHidden){M.style.display="none"}J.appendChild(K);J.appendChild(M);var E=this.createObj("div");E.className="mxt-window-body";E.style.height=this.height-this.titleHeight-this.footerHeight+"px";if(this.isIframe){this.iframeId=parseInt(Math.random()*10000)+"-iframe";var F=this.targetWindow.document.createElement("iframe");F.setAttribute("src",this.url);F.id=this.iframeId;F.name=this.iframeId;F.setAttribute("frameBorder","0");F.className="mxt-window-body-iframe";F.style.height=parseInt(E.style.height)+"px";F.style.width=this.width+"px";this.iframe=F;E.appendChild(this.iframe)}else{var G=this.createObj("div");G.className="mxt-window-body-content";G.style.height=parseInt(E.style.height)+"px";if(this.html){G.innerHTML=this.html}E.appendChild(G)}this.elementContent.appendChild(J);this.elementContent.appendChild(E);var L=this.createObj("div");L.className="mxt-window-footer";L.style.height=this.footerHeight+"px";L.style.background="#4D4D4D";if(this.discription!=null||this.discription!=""){var D=this.createObj("div");D.className="discriptionDiv";D.innerHTML=this.discription;L.appendChild(D)}if(this.buttons!=null&&this.buttons.length>0){var I=this.createObj("div");I.className="buttonsDiv";for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];var O=this.createObj("input");O.setAttribute("type","button");O.className="button-default-2 margin_r_5";if(A.emphasize){O.className="button-default_emphasize margin_r_5"}if(A.text){O.setAttribute("value",A.text)}if(A.id){O.setAttribute("id",A.id)}if(A.disabled){O.setAttribute("disabled",A.disabled)}if(A.handler){MxtWindow.addEvent(O,"click",A.handler,false)}I.appendChild(O)}L.appendChild(I);this.elementContent.appendChild(L)}if(this.isSynchronization){var H=this.createObj("input");H.setAttribute("type","hidden");H.setAttribute("id","_isSynchronization");this.element.appendChild(H)}};MxtWindow.prototype.reloadUrl=function(A){var B=A;B?null:B=this.url;var D=this.targetWindow.document.getElementById(this.iframeId);D.setAttribute("src",B)};MxtWindow.addEvent=function(D,B,E,A){try{if(D.addEventListener){D.addEventListener(B,E,A)}else{if(D.attachEvent){D.attachEvent("on"+B,E)}}}catch(F){}};MxtWindow.prototype.removeElement=function(A){A.parentNode.removeChild(A)};MxtWindow.prototype.createObj=function(A,D){var B=this.targetWindow.document.createElement(A);B.id=D==null?"":D;return B};MxtWindow.prototype.getElement=function(A){if(A==null){return null}else{return document.getElementById(A)}};Array.prototype.extend=function(E){for(var F=0,D=E.length;F<D;F++){this.push(E[F])}return this};MxtWindow.divDrag=function(){var D,G,E;var F=2000;this.dragStart=function(A){A=A||window.event;if((A.which&&(A.which!=1))||(A.button&&(A.button!=1))){return }var B=this.$pos;E=this.parent||this;if(document.defaultView){_top=document.defaultView.getComputedStyle(E,null).getPropertyValue("top");_left=document.defaultView.getComputedStyle(E,null).getPropertyValue("left")}else{if(E.currentStyle){_top=E.currentStyle.top;_left=E.currentStyle.left}}B.ox=(A.pageX||(A.clientX+document.documentElement.scrollLeft))-parseInt(_left);B.oy=(A.pageY||(A.clientY+document.documentElement.scrollTop))-parseInt(_top);if(!!D){if(document.removeEventListener){document.removeEventListener("mousemove",D,false);document.removeEventListener("mouseup",G,false);document.onselectstart=function(){return true}}else{document.detachEvent("onmousemove",D);document.detachEvent("onmouseup",G)}}D=this.dragMove.create(this);G=this.dragEnd.create(this);if(document.addEventListener){document.addEventListener("mousemove",D,false);document.addEventListener("mouseup",G,false)}else{document.attachEvent("onmousemove",D);document.attachEvent("onmouseup",G)}this.stop(A)};this.dragMove=function(A){A=A||window.event;var B=this.$pos;E=this.parent||this;E.style.top=(A.pageY||(A.clientY+document.documentElement.scrollTop))-parseInt(B.oy)+"px";E.style.left=(A.pageX||(A.clientX+document.documentElement.scrollLeft))-parseInt(B.ox)+"px";this.stop(A)};this.dragEnd=function(A){var B=this.$pos;A=A||window.event;if((A.which&&(A.which!=1))||(A.button&&(A.button!=1))){return }E=this.parent||this;if(!!(this.parent)){this.style.backgroundColor=B.color}if(document.removeEventListener){document.removeEventListener("mousemove",D,false);document.removeEventListener("mouseup",G,false)}else{document.detachEvent("onmousemove",D);document.detachEvent("onmouseup",G)}D=null;G=null;this.stop(A)};this.shiftColor=function(){};this.position=function(H){var B=H.offsetTop;var A=H.offsetLeft;while(H=H.offsetParent){B+=H.offsetTop;A+=H.offsetLeft}return{x:A,y:B,ox:0,oy:0,color:null}};this.stop=function(A){if(A.stopPropagation){A.stopPropagation()}else{A.cancelBubble=true}if(A.preventDefault){A.preventDefault()}else{A.returnValue=false}};this.stop1=function(A){A=A||window.event;if(A.stopPropagation){A.stopPropagation()}else{A.cancelBubble=true}};this.create=function(J){var I=this;var H=J;return function(A){return I.apply(H,[A])}};this.dragStart.create=this.create;this.dragMove.create=this.create;this.dragEnd.create=this.create;this.shiftColor.create=this.create;this.initialize=function(){for(var H=0,I=arguments.length;H<I;H++){C=arguments[H];if(!(C.push)){C=[C]}$C=(typeof (C[0])=="object")?C[0]:(typeof (C[0])=="string"?$(C[0]):null);if(!$C){continue}$C.$pos=this.position($C);$C.dragMove=this.dragMove;$C.dragEnd=this.dragEnd;$C.stop=this.stop;if(!!C[1]){$C.parent=C[1];$C.$pos.color=$C.style.backgroundColor}if($C.addEventListener){$C.addEventListener("mousedown",this.dragStart.create($C),false);if(!!C[1]){$C.addEventListener("mousedown",this.shiftColor.create($C),false)}}else{$C.attachEvent("onmousedown",this.dragStart.create($C));if(!!C[1]){$C.attachEvent("onmousedown",this.shiftColor.create($C))}}}};this.initialize.apply(this,arguments)};MxtWindow.prototype.addShadow=function(){obj=this.element;if(!obj){return false}var R=navigator.userAgent.toLowerCase();var B=R.indexOf("opera")>-1;var F=R.indexOf("msie")>-1&&!B;var P=R.indexOf("netscape")>-1;var K=obj.offsetWidth;var O=obj.offsetHeight;var D=0;var M=0;var L=function(S){if(!S){return false}var U=0,T=0;if(F||B){while(S!=null&&S.nodeName!="#document"){U+=S.offsetLeft;T+=S.offsetTop;S=S.parentNode}}else{T=S.offsetTop;U=S.offsetLeft}return{T:T,L:U}};var Q=L(obj);D=Q.L;M=Q.T;var J=this.targetWindow.document.createElement("div");var I=this.targetWindow.document.createElement("div");var H=this.targetWindow.document.createElement("div");var G=this.targetWindow.document.createElement("div");var A=function(U,T,S){if(!U){return false}if(!B){if(!S){U.style.cssText=T}else{U.style.cssText+=T}}else{if(!S){U.setAttribute("style",T)}else{U.setAttribute("style",U.getAttribute("style")+";"+T)}}};var E="width:100%;height:100%;position:absolute;margin:0px;padding:0px;top:-1px;left:-1px";A(J,"position:absolute;left:"+(D+3)+"px;top:"+(M+3)+"px;width:"+K+"px;height:"+O+"px;background:#eee");A(I,E+";background:#ddd");A(H,E+";background:#ccc");A(G,E+";background:#fff");if(F||P){A(J,";z-index:-1",1)}else{A(obj,"position:absolute;z-index:2;left:+"+D+"px;top:"+M+"px",1)}J.appendChild(I);I.appendChild(H);H.appendChild(G);var N=this.targetWindow.document.createElement("div");N.className="mxt-window";N.appendChild(J);N.appendChild(obj);this.element=N};function initIpadScroll(E,A,B){if(v3x.isIpad){var D=document.getElementById(E);if(D){if(A){D.style.height=A+"px"}if(B){D.style.width=B+"px"}D.style.overflow="auto";touchScroll(E)}}}function initIe10AutoScroll(F,D){var A=getA8Top().document.getElementById("main");var E=getA8Top().document.body.offsetHeight;if(E<300){E=getA8Top().document.documentElement.offsetHeight}var B=A!=null?A.offsetHeight-D:parseInt(E)-D;if(B<0){return }initIe10Scroll(F,B)}function setHeightAuto(F,A,B){var D=parseInt(document.body.clientHeight)-B;var E=parseInt(document.body.clientWidth)-A;if(v3x.isMSIE9){D=parseInt(document.documentElement.clientHeight)-B;E=parseInt(document.documentElement.clientWidth)-A;if(D<0){D=parseInt(document.body.clientHeight)-B}if(E<0){E=parseInt(document.body.clientWidth)-A}}initIe10Scroll(F,D,E)}function bindOnresize(D,A,B){window.onresize=function(){setHeightAuto(D,A,B)};setHeightAuto(D,A,B)}function initIe10Scroll(E,A,B){var D=document.getElementById(E);if(D){D.style.overflow="auto";if(A>0){D.style.height=A+"px"}if(B>0){D.style.width=B+"px"}}}function initFFScroll(E,A,B){if(v3x.isFirefox){var D=document.getElementById(E);if(D){if(A){D.style.height=A+"px"}if(B){D.style.width=B+"px"}D.style.overflow="auto"}}}function initSafariScroll(E,A,B){if(v3x.isSafari){var D=document.getElementById(E);if(D){if(A){D.style.height=A+"px"}if(B){D.style.width=B+"px"}D.style.overflow="auto"}}}function initChromeScroll(E,A,B){if(v3x.isChrome){var D=document.getElementById(E);if(D){if(A){D.style.height=A+"px"}if(B){D.style.width=B+"px"}D.style.overflow="auto"}}}function isTouchDevice(){try{document.createEvent("TouchEvent");return true}catch(A){return false}}function touchScroll(E){if(isTouchDevice()){var A=document.getElementById(E);var B=0;var D=0;A.addEventListener("touchstart",function(F){B=this.scrollTop+F.touches[0].pageY;D=this.scrollLeft+F.touches[0].pageX},false);A.addEventListener("touchmove",function(F){this.scrollTop=B-F.touches[0].pageY;this.scrollLeft=D-F.touches[0].pageX;F.preventDefault()},false)}}function isDecimal(B,A,E,D){if(!testRegExp(B,"^-?[0-9]{0,"+(E?E:"")+"}\\.?[0-9]{1,"+(D?D:"")+"}$")){if(A){alert(v3x.getMessage("V3XLang.formValidate_isNumber",A))}return false}return true}function showPushWindow(J){var H="";var G=document.getElementById("edocType");var E=document.getElementById("pushMessageMemberIds");if(G){H=G.value}var F=document.getElementById("pushMessageMemberIds").value;var A=colWorkFlowURL+"?method=showPushWindow&summaryId="+J+"&edocType="+H+"&sel="+encodeURIat(F);var B=document.getElementById("replyedAffairId");if(B!=null&&typeof (B)!="undefined"){A+="&replyedAffairId="+B.value}var I=v3x.openWindow({url:A,height:350,width:300});if(typeof (I)!="undefined"&&I!=null){var L=I[0];var K=I[1];document.getElementById("pushMessageMemberIds").value=L;var D=document.getElementById("pushMessageMemberNames");if(D&&B!=B.value){D.value=K;D.title=K}}}function sendSMSV3X(A){var B=getBaseURL()+"/message.do?method=showSendSMSDlg";if(A){B+="&receiverIds="+A}if(getA8Top().isCtpTop){getA8Top().senSmsWin=getA8Top().$.dialog({title:"\u53d1\u9001\u77ed\u4fe1",transParams:{parentWin:window},url:B,width:420,height:250,isDrag:false})}else{getA8Top().senSmsWin=v3x.openDialog({title:"\u53d1\u9001\u77ed\u4fe1",transParams:{parentWin:window},url:B,width:420,height:250,isDrag:false})}}function sendSmsCollBack(A){getA8Top().senSmsWin.close();if(!A){return }alert(A)}function sendMessageForCard(A,E){var G=getA8Top();if(getA8Top().window.opener){G=getA8Top().window.opener.getA8Top()}var F=G.getUCStatus();if(F!=""){alert(F);return }var B;if(A){B=getBaseURL()+"/message.do?method=showSendDlg&getData=fromParent"}else{B=getBaseURL()+"/message.do?method=showSendDlg&receiverIds="+E}var D=v3x.isChrome?"1":"modal";if(getA8Top().isCtpTop){getA8Top().sendMessageWin=getA8Top().$.dialog({title:" ",transParams:{parentWin:window},url:B,width:420,height:240,isDrag:false})}else{getA8Top().sendMessageWin=v3x.openDialog({title:" ",transParams:{parentWin:window},url:B,width:420,height:240,isDrag:false})}}function sendMessageForIMTab(E,A){if(!getA8Top().contentFrame.topFrame.onlineWin){var D=50;var B=(window.screen.availHeight-600)/2;getA8Top().contentFrame.topFrame.onlineWin=getA8Top().contentFrame.topFrame.open(getBaseURL()+"/message.do?method=showOnlineUser&id="+E+"&name="+A,"","left="+D+",top="+B+",width=600,height=600,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no")}else{getA8Top().contentFrame.topFrame.onlineWin.focus();getA8Top().contentFrame.topFrame.onlineWin.showIMTab("1",E,A,"false")}}var global_forwardType=null;function forwardColV3X(A,D,B){global_forwardType=B;getA8Top().toCollWin=getA8Top().$.dialog({title:"\u8f6c\u53d1\u534f\u540c",url:getBaseURL()+"/collaboration/collaboration.do?method=showForward&showType=model&data="+A+"_"+D,width:360,height:420,transParams:{parentWin:window}})}function callbackForwardColV3x(){if(global_forwardType=="self"){document.location.reload(true)}else{if(global_forwardType=="list"){if(getParameter("method")=="listSent"){document.location.reload(true)}}}}function confirmToOffice2003(){if(confirm(_("V3XLang.OfficeSaveTo2003"))){return true}else{return false}}function isOffice2007(A){if(typeof (A)=="undefined"||A==null){return false}if(A.indexOf(".docx")!=-1||A.indexOf(".xlsx")!=-1||A.indexOf(".pptx")!=-1){return true}else{return false}}function V3XAutocomplete(){this._disableEvent=false;this._onchange=function(D,G,B,A){if(v3xautocomplete._disableEvent){return }if(D){if(D.select){var E={label:G.value,value:G.id};D.select(E,B)}if(D.bindSelect){var F=jQuery.Event("change");if(jQuery.isFunction(D.bindSelect)){F.target=D.bindSelect(jQuery(A))}else{F.target=jQuery(D.bindSelect)}try{jQuery(F.target).val(G.id).trigger(F,jQuery(F.target));jQuery(F.target).blur()}catch(F){}}}};this._getViewElement=function(B){var A;if(typeof B=="string"){A=jQuery(document.getElementById(B+"_autocomplete"))}else{A=jQuery(B)}return A}}var v3xautocomplete=new V3XAutocomplete();V3XAutocomplete.prototype.autocomplete=function(L,Y,E){var M=this._getViewElement(L);if(typeof (M)=="undefined"||M==null||M[0]==null){return }if(!M){return false}var O=true;var W=true;var Q=240;var R=0;var F=false;var D=0;var J={id:"",value:""};var U=17;var P=Y.length==0;if(!P&&Y.length==1&&Y[0].value==""&&!Y[0].label){P=true}if(E){jQuery(M).data("options",E);if(E.button!==undefined){W=E.button}if(E.maxHeight!==undefined){Q=E.maxHeight}if(E.width!==undefined){R=E.width}if(E.autoSize!==undefined){F=E.autosize}if(E.appendBlank!==undefined){O=E.appendBlank}}var I=new Array();var T=Y==null?I:Y;if(T.length>0){if(O){I.push(J)}jQuery.each(T,function(a,c){var b={id:c.value,value:c.label};if(b.value){I.push(b);var Z=b.value.length;if(Z>D){D=Z}}})}var B=function(b){for(var Z in I){var a=I[Z];if(a.id==b.id&&a.value==b.value){return true}}return false};var H=jQuery(M).data("current");jQuery(M).data("current",null);var K=function(Z,a){if(!a.item){return false}jQuery(document.getElementById(L)).val(a.item.id);jQuery(M).val(a.item.value);jQuery(M).data("current",a.item);X(E,a.item,L,M);return false};var A=function(){K(null,{item:J});jQuery(M).data("current",null)};if(W){var N=M.next('button[name="acToggle"]').length>0;if(!N){var V="background-image:url('common/images/desc.gif');vertical-align:middle;background-repeat:no-repeat;background-color: #ececec;background-position:center;width:"+U+"px;height:21px;border:1px #d1d1d1 solid;";M.after('<button type="button" name="acToggle" tabindex="-1" onclick="v3xautocomplete.toggle(this.previousSibling);this.blur();" style="'+V+'"/>');jQuery(M).width(jQuery(M).width()-10)}}var X=this._onchange;jQuery(M).bind("blur",function(){var Z=jQuery(M).data("current");if(Z){if(jQuery(M).val()!=Z.value){jQuery(M).val(Z.value)}}else{A()}});jQuery(M).bind("click",function(){this.select()});M.autocomplete({minLength:0,source:I,autoFocus:true,delay:0,focus:function(Z,a){return false},position:{collision:"flip"},select:K,search:function(){var Z=jQuery(this).autocomplete("widget");Z.css("height","auto")},beforePosition:function(){var Z=jQuery(this).autocomplete("widget");if(Z.outerHeight()>Q){Z.css("overflow-y","auto");Z.css("overflow-x","hidden");var a=Z.children();if(a.size()*(a.height+2)>Q){Z.css("height",Q+"px")}}},close:function(){jQuery("#ui_mask").hide()},open:function(){var j=getA8Top()._zoomParam;j=j==undefined?1:j;var h=jQuery(this).autocomplete("widget");var i;if(F){i=D*8+20}else{if(R){i=R}else{i=jQuery(this).outerWidth();if(W){var f=M.next('button[name="acToggle"]').position().top;var a=(f>=(M.position().top+M.outerHeight()));if(!a){i+=U}}}}var e=M.outerWidth();if(i<120){i=120}if(i<0||(i>500&&i>(e+U))){i=300}h.width(i);h.find(".ui-menu-item").css("overflow","hidden").css("white-space","nowrap");h.find("li").each(function(k,l){l.title=l.innerText});jQuery(M.parents()).scroll(function(){h.css("display","none")});var b=h.position().top;var g=M.position().top;var Z=h.outerHeight();var c=M.outerHeight();if(b<0){b=0;if(Z<g){b=g-Z}Z=g-b;h.css("top",b/j+"px");h.css("height",Z+"px")}if(b+Z<g){b=g-Z;h.css("top",b/j+"px")}if(b+Z>g+c){b=g+c;h.css("top",b/j+"px")}h.css("left",M.position().left/j+"px");if(Z>0&&Z<48){Z=48}var d=M.position().left;h.css("left",d+"px");h.css("z-index",9000);if(jQuery("#ui_mask").length==0){$("<iframe></iframe>").attr("id","ui_mask").css({border:"0px",position:"absolute",filter:"alpha(opacity=0)",left:0,top:0,width:"1px",height:"1px",display:"none"}).css("z-index",8999).appendTo($("body"))}jQuery("#ui_mask").css({width:h.width()+30+"px",top:b-10+"px",left:d-20+"px",height:Z+80+"px"}).show();jQuery("#ui_mask").data("bind",this)}});var G=false;if(H!=null){G=B(H);if(!G){A()}}if(P){A();M[0].disabled=true;if(W){M.next('button[name="acToggle"]').attr("disabled",true).css("opacity","0.4")}}else{M[0].disabled=false;if(W){M.next('button[name="acToggle"]').attr("disabled",false).css("opacity","1")}if(E&&(E.value||E.value==null||E.value=="")){var S=E.value;var B=false;if(S!=null){jQuery.each(I,function(Z,a){if(a.id==S){B=true;return }})}if(B){if(typeof L=="string"){this.select(L,S)}else{this.select(M,S)}}else{if(!G){A()}else{jQuery(M).data("current",H)}}}else{if(jQuery(M).val()){A()}}}};V3XAutocomplete.prototype.select=function(E,G){var A=this._getViewElement(E);var F=A.autocomplete("option","source");if(!F){return false}var D=jQuery(A).data("options");var B=this._onchange;jQuery.each(F,function(H,I){if(I.id==G){jQuery(document.getElementById(E)).val(I.id);A.val(I.value);jQuery(A).data("current",I);B(D,I,E,A);return true}})};V3XAutocomplete.prototype.refresh=function(B){var A=this._getViewElement(B);var D=jQuery(A).data("current");if(D){this._disableEvent=true;this.select(A,D.id);this._disableEvent=false}};V3XAutocomplete.prototype.disableEvent=function(A){this._disableEvent=A};V3XAutocomplete.prototype.getData=function(B){var A=this._getViewElement(B);var E=A.autocomplete("option","source");var D=new Array();jQuery.each(E,function(F,H){var G={value:H.id,label:H.value};if(G.value){D.push(G)}});return D};V3XAutocomplete.prototype.copy=function(I,H){var A=this._getViewElement(I);var F=A.autocomplete("option","source");var E=new Array();jQuery.each(F,function(J,L){var K={value:L.id,label:L.value};if(K.value){E.push(K)}});jQuery(I).unbind("click");var B=jQuery(A).data("options");try{if(jQuery.expando){jQuery(H).removeAttr(jQuery.expando)}}catch(G){}var D=jQuery(A).data("current");if(D){B.value=D.id}this.autocomplete(H,E,B)};V3XAutocomplete.prototype.toggle=function(B){var A=this._getViewElement(B);if(A.autocomplete("widget").is(":visible")){A.autocomplete("close");return }A.autocomplete("search","");A.focus()};V3XAutocomplete.prototype.build=function(A,F){function E(G){var H=new Array();jQuery.each(G,function(I,J){if(J.key){H.push(J.key,'="',J.value,'" ')}});return H.join("")}var B=new Array();var D=A+"_autocomplete";B.push("<input ",E([{key:"name",value:A},{key:"id",value:A},{key:"type",value:"hidden"}])," />");B.push("<input ",E([{key:"name",value:D},{key:"id",value:D},{key:"type",value:"text"},{key:"class",value:"input_autocomplete"},{key:"onclick",value:"v3xautocomplete.toggle('"+A+"');"}])," />\n");B.push("<script>\n");B.push("v3xautocomplete.autocomplete(","'",A,"',",F,");\n");B.push("<\/script>");return(B.join(""))};var postUrl="";function getQueryCondition(P,B,J){var D=document.getElementById("ftable");var L=D.rows[0];var E=J;var N=isCrossTable();if(N){E=0;var I;var K=L.cells.length;for(var G=0;G<K;G++){var H=L.cells[G];if(H.getAttribute("rowspan")=="2"){E++}if(H.getAttribute("colspan")!=null){I=parseInt(H.getAttribute("colspan"))}}}if(B>(E-1)){var M="";for(var G=0;G<E;G++){M+=getRowHead(G,P)+","}if(N){M+=getColHead(E,I,B)+",";M+=getCrossDataCol(E,B)+","}else{M+=getDataCol(B)+","}var F=document.all("showdetail").value;postUrl=getBaseURL()+"/formreport.do?method=showReportQuery&str="+encodeURIComponent(M);var A=screen.width-155;var O=screen.height-300;v3x.openWindow({url:getBaseURL()+"/formreport.do?method=openShowReportQuery",workSpace:"yes",dialogType:"modal",resizable:false});return }}function getSummaryId(D){var A=new XMLHttpRequestCaller(null,"","",false,"GET","false",D);var B=A.serviceRequest();return B}function showQueryTable(B){var G=document.getElementById("showdetail").value;var H=document.getElementById("formname").value;var J=document.getElementById("formid").value;var F=document.getElementById("queryname").value;var I=document.getElementById("isFlow").value;if(I=="true"){var D=getBaseURL()+"/formquery.do?method=hasSummaryId&id="+B+"&showdetail="+encodeURIComponent(G)+"&formid="+J+"&formname="+H;var E=getSummaryId(D);if(E.trim()=="null"){alert(v3x.getMessage("formLang.formquery__selectnone"))}else{if(E.indexOf("|")>-1){D=getBaseURL()+"/formquery.do?method=collFrameViewRelate&summaryId="+E+"&showdetail="+encodeURIComponent(G)+"&appid="+J+"&queryname="+encodeURIComponent(F);v3x.openWindow({url:D,workSpace:"yes",dialogType:v3x.getBrowserFlag("pageBreak")?"modal":"open"})}else{D=getBaseURL()+"/formquery.do?method=showRecordDetail&summaryId="+E+"&showdetail="+encodeURIComponent(G)+"&appid="+J+"&queryname="+encodeURIComponent(F);v3x.openWindow({url:D,workSpace:"yes",dialogType:v3x.getBrowserFlag("pageBreak")?"modal":"open"})}}}else{if(I=="false"){var A=document.getElementById("appShowDetail").value;v3x.openWindow({url:getBaseURL()+"/appFormController.do?method=viewFormData&isOpenWin=true&appformId="+J+"&masterId="+B+"&showDetail="+encodeURIComponent(A),dialogType:"modal",workSpace:"yes",resizable:"true"})}}}function isCrossTable(){var A=document.getElementById("ftable");var B=A.rows[0];var F=B.cells.length;for(var D=0;D<F;D++){var E=B.cells[D];if(E.getAttribute("rowspan")=="2"){return true}}return false}function getColHead(B,F,E){var A=document.getElementById("ftable");var D=A.rows[0];return D.cells[Math.floor((E-B)/F)+B].getAttribute("value")}function getCrossDataCol(B,D){var A=document.getElementById("ftable");return A.rows[1].cells[D-B].getAttribute("value")}function getDataCol(B){var A=document.getElementById("ftable");return A.rows[0].cells[B].getAttribute("value")}function getRowHead(B,D){var A=document.getElementById("ftable");return A.rows[D].cells[B].getAttribute("value")}function newPlan(A,B,D){getA8Top().contentFrame.mainFrame.location.href=A+"?method=initAdd&type="+B+"&time="+D}function newTask(B,D){var A=v3x.openWindow({url:B+"?method=addTaskPageFrame&from=timing&time="+D,width:530,height:480,resizable:false});if(A||A=="true"){window.location.href=window.location.href}}function newCal(B,D){var A=v3x.openWindow({url:B+"?method=createEvent&time="+D,width:530,height:480,resizable:false});if(A&&A=="true"){window.location.href=window.location.href}}function newMeeting(A,B){getA8Top().contentFrame.mainFrame.location.href=A+"?method=create&formOper=new&time="+B}function isLeftClose(){return getA8Top().contentFrame.document.getElementById("LeftRightFrameSet").cols=="142,*"}function showCtpLocation(A,L){var I=getA8Top();if(L&&L.html){if(I.showLocation){var J=I.currentSpaceType||"personal";var F=I.skinPathKey||"defaultV51";var G='<span class="nowLocation_ico"><img src="'+v3x.baseURL+"/main/skin/frame/"+F+"/menuIcon/"+J+'.png"></span>';L.html=G+L.html;I.showLocation(L.html)}return }if(I.$){function B(Q){if(I.$){function P(W,T,X){for(var U=0;U<W.length;U++){var Y=W[U];Y.parentMenu=T;var V=Y.resourceCode;if(V!=null){X[V]=Y}if(Y.items){P(Y.items,Y,X)}}}var N=I.memberMenus;if(N){var S="resourceMenuCache";var O=I.$.data(I.document.body,S);if(O==undefined){O=new Array();P(N,null,O);I.$.data(I.document.body,S,O)}var M=[];var R=O[Q];if(R!=undefined){while(R!=null){M.push(R);R=R.parentMenu}}return M.reverse()}}return[]}var D=B(A);if(D.length>0){var K="\u5f53\u524d\u4f4d\u7f6e\uff1a";if(I.$){K=I.$.i18n("seeyon.top.nowLocation.label")}var J=I.currentSpaceType||"personal";var F=I.skinPathKey||"defaultV51";var G='<span class="nowLocation_ico"><img src="'+v3x.baseURL+"/main/skin/frame/"+F+"/menuIcon/"+J+'.png"></span>';G+='<span class="nowLocation_content">';var H=[];for(var E=0;E<D.length;E++){if(D[E].url){H.push('<a href="javascript:void(0)" class="hand" onclick="showMenu(\''+v3x.baseURL+D[E].url+"')\">"+D[E].name+"</a>")}else{H.push('<a style="cursor:default" >'+D[E].name+"</a>")}}G+=H.join(" > ");if(L&&L.surffix){G+=" > "+L.surffix}I.showLocation(G)}}}function resetCtpLocation(){var A=getA8Top();if(A&&A.hideLocation){A.hideLocation()}}function openEditorAssociate(E,F,M,I,G,N,A,O){function J(){if(v3x){return v3x.baseURL?v3x.baseURL:parent._ctxPath}return"/seeyon"}var B;var L=false;var D=document.getElementById("moduleId");if(D!=null){I=D.value}else{if(typeof (summary_id)!==undefined&&(typeof (summary_id)!=="undefined")){I=summary_id}}if(typeof (_baseObjectId)!==undefined&&(typeof (_baseObjectId)!=="undefined")){I=_baseObjectId}var K=document.getElementById("moduleType");if(K!=null){G=K.value}else{if(typeof (_baseApp)!==undefined&&(typeof (_baseApp)!=="undefined")){G=_baseApp}}if(F=="collaboration"){B="collaboration/collaboration.do?method=summary&openFrom=glwd&type=&affairId="+M+"&baseObjectId="+I+"&baseApp="+G}else{if(F=="edoc"){B="edocController.do?method=detailIFrame&from=Done&openFrom=glwd&affairId="+M+"&isQuote=true&baseObjectId="+I+"&baseApp=4"}else{if(F=="km"){B="doc.do?method=docOpenIframeOnlyId&openFrom=glwd&docResId="+M+"&baseObjectId="+I+"&baseApp="+G}else{if(F=="meeting"){B="mtMeeting.do?method=myDetailFrame&id="+M+"&isQuote=true&baseObjectId="+I+"&baseApp="+G+"&state=10"}else{L=true;B="fileUpload.do?method=download&fileId="+E+"&createDate="+N.substring(0,10)+"&filename="+encodeURI(A)+"&v="+O}}}}B=B+"&fromEditor=1";B=J()+"/"+B;if(L){var H=document.getElementById("downloadFileFrame");if(H){H.src=B}else{window.open(B,"_blank")}}else{openDetailURL(B)}}function closeAllDialog(A){var B=window;if(A){B=A}B.$(".mask").remove();B.$(".dialog_box").remove();B.$(".shield").remove();B.$(".mxt-window").remove()}function removeCtpWindow(G,B){try{var F=getA8Top();if(G==null||G==undefined){G=F.location+"";var E=G.indexOf("/seeyon/");if(E!=-1){G=G.substring(E)}}if(B==2){if(getA8Top().isCtpTop){return }if(getA8Top().opener){F=getA8Top().opener.getA8Top()}}var A=F._windowsMap;if(A){A.remove(G)}}catch(D){}}function closeOpenMultyWindow(D,F){if(D==undefined){D=window.location+"";var E=D.indexOf("/seeyon/");if(E!=-1){D=D.substring(E)}}var B=getCtpTop()._windowsMap;if(B){var A=B.get(D);if(A){if(F!=undefined&&A.isFormSubmit){A.isFormSubmit=F}A.close()}B.remove(D)}}function replaceKey(E,A){if(E&&A){var F=getA8Top();var D=F._windowsMap;if(D){var B=D.get(_id);if(B){D.putRef(A,B);D.remove(E)}}}}function addAnotherKey(B,E,J,H,A){if(B&&E){var M=getCtpTop();if(J==2){if(getCtpTop().opener){M=getCtpTop().opener}}var F=M._windowsMap;if(F){var K=F.get(B);if(K){F.putRef(E,K)}else{if(H){if(F.keys().size()==0){F.putRef(E,A)}else{var G=F.keys().size();var L;for(var D=0;D<G;D++){var I=F.keys().get(D);if(I.indexOf(H)){L=F.get(I);break}}F.putRef(E,L)}}}}}}function getMultyWindowId(B,D){if(D==undefined||B==undefined){return }var E;var F=D.indexOf(B);var A=D.indexOf("&",F);if(A==-1){E=D.substring(F+B.length+1)}else{E=D.substring(F+B.length+1,A)}return E}function openCtpWindow(D){var P,T,R,N,M,K,Y,I,B;this.windowArgs=D;T=D.width||parseInt(screen.width)-20;R=D.height||parseInt(screen.height)-80;this.settings={dialog_type:"open",resizable:"yes",scrollbars:"yes"};P=D.html;I=D.url;if(I.indexOf("seeyon")==0){I=_ctxPath+I}B=D.dialogType||this.settings.dialog_type;K=D.resizable||this.settings.resizable;Y=D.scrollbars||this.settings.scrollbars;var L=null;var W=(K=="yes")?"no":"yes";var F=D.id;if(F==undefined){F=I}var U=getA8Top()._windowsMap;if(U){for(var S=0;S<U.keys().size();S++){var Q=U.keys().get(S);try{var E=U.get(Q);var O=E.document;if(O){var Z=parseInt(O.body.clientHeight);if(Z==0){E=null;U.remove(Q);S--}}else{E=null;U.remove(Q);S--}}catch(X){E=null;U.remove(Q);S--}}if(U.size()==10){alert(v3x.getMessage("V3XLang.window_max_length"));return }var V=U.get(F);if(V){try{var H=V.location.href;var J="";var A=H.indexOf("/seeyon/");if(A!=-1){J=H.substring(A)}if(J==I){var O=V.document;alert(v3x.getMessage("V3XLang.window_already_exit"));V.focus();return }}catch(X){V=null;U.remove(F)}}}else{getA8Top()._windowsMap=new Properties();U=getA8Top()._windowsMap}R-=25;var G=window.open(I,"ctpPopup"+new Date().getTime(),"top=0,left=0,scrollbars=yes,dialog=yes,minimizable=yes,modal=open,width="+T+",height="+R+",resizable=yes");if(G==null){return }G.focus();if(U){U.putRef(F,G)}return G}function getCtpTopFromOpener(D){var A=D.getA8Top();for(var B=0;B<10;B++){if(typeof A.isCtpTop!="undefined"&&A.isCtpTop){return A}else{A=A.opener}}}function resizeFckeditor(){try{var F=document.getElementById("editerDiv_td")||document.getElementById("ie6_ckeditor")||document.getElementById("scrollListMeetingDiv");var A=document.getElementById("editerDiv")||document.getElementById("RTEEditorDiv");var E=document.getElementById("cke_1_contents");if(F==null||A==null||E==null){return }A.style.display="none";F.style.height="auto";var D=F.clientHeight;A.style.height=D+"px";A.style.display="block";E.style.height=(D-50)+"px"}catch(B){}}function isYoZoOffice(){var D=false;try{var B=new ActiveXObject("HandWrite.HandWriteCtrl");D=B.WebApplication(".eio")}catch(A){}return D}function clearOfficeFlag(){try{var B=navigator.userAgent;var A=(navigator.appName=="Microsoft Internet Explorer")||B.indexOf("Trident")!=-1;var D=getA8Top();D.isOffice=false;D.officeObj=null}catch(E){}}function setOfficeFlag(B,D){try{var E=navigator.userAgent;var A=(navigator.appName=="Microsoft Internet Explorer")||E.indexOf("Trident")!=-1;if(A){var F=getA8Top();F.isOffice=B;return }var F=getA8Top();F.isOffice=B;if(F.officeObj&&typeof F.officeObj=="object"&&"[object Array]"==Object.prototype.toString.call(F.officeObj)){F.officeObj.push(D)}else{F.officeObj=[];F.officeObj.push(D)}}catch(G){}}function hideOfficeObj(){try{var E=navigator.userAgent;var B=(navigator.appName=="Microsoft Internet Explorer")||E.indexOf("Trident")!=-1;if(B){return }var F=getA8Top();if(F.isOffice&&F.officeObj&&F.officeObj.length>0){for(var D=0;D<F.officeObj.length;D++){var A=F.officeObj[D];if(A&&A.style){A.style.visibility="hidden"}}}}catch(G){}}var OfficeObjExt={iframeId:null,showDialogOffice:function(){},setIframeId:function(A){OfficeObjExt.iframeId=A},firstHeight:null,showExt:function(){if(OfficeObjExt.iframeId==null){return }var D=document.getElementById(OfficeObjExt.iframeId);var B;if(OfficeObjExt.firstHeight==null){B=D.style.height;OfficeObjExt.firstHeight=B}else{B=OfficeObjExt.firstHeight}var A=B;if(B.indexOf("%")>0){A=B.substring(0,B.length-1);A=parseInt(A);A=A-2;D.style.height=A+"%"}else{if(B.indexOf("px")>0){A=B.substring(0,B.length-2);A=parseInt(A);A=A-2;D.style.height=A+"px"}else{B=$(D).height();OfficeObjExt.firstHeight=B+"px";D.style.height=(B-2)+"px"}}window.setTimeout(function(){D.style.height=B},2)},showIfame:function(B){var D,F,G;D=B.firstAttr;F=B.iframe;G=B.callback||function(){};var E;if(OfficeObjExt[D]==null){E=F.style.height;OfficeObjExt[D]=E}else{E=OfficeObjExt[D]}var A=E;if(E.indexOf("%")>0){A=E.substring(0,E.length-1);A=parseInt(A);A=A-2;F.style.height=A+"%"}else{if(E.indexOf("px")>0){A=E.substring(0,E.length-2);A=parseInt(A);A=A-2;F.style.height=A+"px"}else{E=$(F).height();OfficeObjExt[D]=E+"px";F.style.height=(E-2)+"px"}}window.setTimeout(function(){F.style.height=E;window.setTimeout(B.callback,1)},2)}};function showOfficeObj(){try{var E=navigator.userAgent;var B=(navigator.appName=="Microsoft Internet Explorer")||E.indexOf("Trident")!=-1;if(B){return }var H=navigator.userAgent.toLowerCase().match(/chrome/)!=null;var F=getA8Top();try{if((F.$(".mask").size()>0&&F.$(".mask").css("display")!="none")||(F.$(".shield").size()>0&&F.$(".shield").css("display")!="none")){if(typeof OfficeObjExt.showDialogOffice=="undefined"){return }OfficeObjExt.showDialogOffice();return }}catch(G){}if(F.isOffice&&F.officeObj&&F.officeObj.length>0){for(var D=0;D<F.officeObj.length;D++){var A=F.officeObj[D];if(A&&A.style){A.style.visibility="visible"}}}if(H){window.setTimeout(OfficeObjExt.showExt,50)}}catch(G){}};
/*
 * jQuery UI Core 1.9.2
 * http://jqueryui.com
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/category/ui-core/
 */
(function(B,F){var A=0,E=/^ui-id-\d+$/;B.ui=B.ui||{};if(B.ui.version){return }B.extend(B.ui,{version:"1.9.2",keyCode:{BACKSPACE:8,COMMA:188,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SPACE:32,TAB:9,UP:38}});B.fn.extend({_focus:B.fn.focus,focus:function(G,H){return typeof G==="number"?this.each(function(){var I=this;setTimeout(function(){B(I).focus();if(H){H.call(I)}},G)}):this._focus.apply(this,arguments)},scrollParent:function(){var G;if((B.ui.ie&&(/(static|relative)/).test(this.css("position")))||(/absolute/).test(this.css("position"))){G=this.parents().filter(function(){return(/(relative|absolute|fixed)/).test(B.css(this,"position"))&&(/(auto|scroll)/).test(B.css(this,"overflow")+B.css(this,"overflow-y")+B.css(this,"overflow-x"))}).eq(0)}else{G=this.parents().filter(function(){return(/(auto|scroll)/).test(B.css(this,"overflow")+B.css(this,"overflow-y")+B.css(this,"overflow-x"))}).eq(0)}return(/fixed/).test(this.css("position"))||!G.length?B(document):G},zIndex:function(J){if(J!==F){return this.css("zIndex",J)}if(this.length){var H=B(this[0]),G,I;while(H.length&&H[0]!==document){G=H.css("position");if(G==="absolute"||G==="relative"||G==="fixed"){I=parseInt(H.css("zIndex"),10);if(!isNaN(I)&&I!==0){return I}}H=H.parent()}}return 0},uniqueId:function(){return this.each(function(){if(!this.id){this.id="ui-id-"+(++A)}})},removeUniqueId:function(){return this.each(function(){if(E.test(this.id)){B(this).removeAttr("id")}})}});function D(I,G){var K,J,H,L=I.nodeName.toLowerCase();if("area"===L){K=I.parentNode;J=K.name;if(!I.href||!J||K.nodeName.toLowerCase()!=="map"){return false}H=B("img[usemap=#"+J+"]")[0];return !!H&&C(H)}return(/input|select|textarea|button|object/.test(L)?!I.disabled:"a"===L?I.href||G:G)&&C(I)}function C(G){return B.expr.filters.visible(G)&&!B(G).parents().andSelf().filter(function(){return B.css(this,"visibility")==="hidden"}).length}B.extend(B.expr[":"],{data:B.expr.createPseudo?B.expr.createPseudo(function(G){return function(H){return !!B.data(H,G)}}):function(I,H,G){return !!B.data(I,G[3])},focusable:function(G){return D(G,!isNaN(B.attr(G,"tabindex")))},tabbable:function(I){var G=B.attr(I,"tabindex"),H=isNaN(G);return(H||G>=0)&&D(I,!H)}});B(function(){try{var G=document.body,I=G.appendChild(I=document.createElement("div"));I.offsetHeight;B.extend(I.style,{minHeight:"100px",height:"auto",padding:0,borderWidth:0});B.support.minHeight=I.offsetHeight===100;B.support.selectstart="onselectstart" in I;G.removeChild(I).style.display="none"}catch(H){}});if(!B("<a>").outerWidth(1).jquery){B.each(["Width","Height"],function(I,G){var H=G==="Width"?["Left","Right"]:["Top","Bottom"],J=G.toLowerCase(),L={innerWidth:B.fn.innerWidth,innerHeight:B.fn.innerHeight,outerWidth:B.fn.outerWidth,outerHeight:B.fn.outerHeight};function K(O,N,M,P){B.each(H,function(){N-=parseFloat(B.css(O,"padding"+this))||0;if(M){N-=parseFloat(B.css(O,"border"+this+"Width"))||0}if(P){N-=parseFloat(B.css(O,"margin"+this))||0}});return N}B.fn["inner"+G]=function(M){if(M===F){return L["inner"+G].call(this)}return this.each(function(){B(this).css(J,K(this,M)+"px")})};B.fn["outer"+G]=function(M,N){if(typeof M!=="number"){return L["outer"+G].call(this,M)}return this.each(function(){B(this).css(J,K(this,M,true,N)+"px")})}})}if(B("<a>").data("a-b","a").removeData("a-b").data("a-b")){B.fn.removeData=(function(G){return function(H){if(arguments.length){return G.call(this,B.camelCase(H))}else{return G.call(this)}}})(B.fn.removeData)}(function(){var G=/msie ([\w.]+)/.exec(navigator.userAgent.toLowerCase())||[];B.ui.ie=G.length?true:false;B.ui.ie6=parseFloat(G[1],10)===6})();B.fn.extend({disableSelection:function(){return this.bind((B.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",function(G){G.preventDefault()})},enableSelection:function(){return this.unbind(".ui-disableSelection")}});B.extend(B.ui,{plugin:{add:function(H,I,K){var G,J=B.ui[H].prototype;for(G in K){J.plugins[G]=J.plugins[G]||[];J.plugins[G].push([I,K[G]])}},call:function(G,I,H){var J,K=G.plugins[I];if(!K||!G.element[0].parentNode||G.element[0].parentNode.nodeType===11){return }for(J=0;J<K.length;J++){if(G.options[K[J][0]]){K[J][1].apply(G.element,H)}}}},contains:B.contains,hasScroll:function(J,H){if(B(J).css("overflow")==="hidden"){return false}var G=(H&&H==="left")?"scrollLeft":"scrollTop",I=false;if(J[G]>0){return true}J[G]=1;I=(J[G]>0);J[G]=0;return I},isOverAxis:function(H,G,I){return(H>G)&&(H<(G+I))},isOver:function(L,H,K,J,G,I){return B.ui.isOverAxis(L,K,G)&&B.ui.isOverAxis(H,J,I)}})})(jQuery);
/*
 * jQuery UI Widget 1.9.2
 * http://jqueryui.com
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/jQuery.widget/
 */
(function(B,E){var A=0,D=Array.prototype.slice,C=B.cleanData;B.cleanData=function(F){for(var G=0,H;(H=F[G])!=null;G++){try{B(H).triggerHandler("remove")}catch(I){}}C(F)};B.widget=function(G,J,F){var M,L,I,K,H=G.split(".")[0];G=G.split(".")[1];M=H+"-"+G;if(!F){F=J;J=B.Widget}B.expr[":"][M.toLowerCase()]=function(N){return !!B.data(N,M)};B[H]=B[H]||{};L=B[H][G];I=B[H][G]=function(N,O){if(!this._createWidget){return new I(N,O)}if(arguments.length){this._createWidget(N,O)}};B.extend(I,L,{version:F.version,_proto:B.extend({},F),_childConstructors:[]});K=new J();K.options=B.widget.extend({},K.options);B.each(F,function(O,N){if(B.isFunction(N)){F[O]=(function(){var P=function(){return J.prototype[O].apply(this,arguments)},Q=function(R){return J.prototype[O].apply(this,R)};return function(){var T=this._super,R=this._superApply,S;this._super=P;this._superApply=Q;S=N.apply(this,arguments);this._super=T;this._superApply=R;return S}})()}});I.prototype=B.widget.extend(K,{widgetEventPrefix:L?K.widgetEventPrefix:G},F,{constructor:I,namespace:H,widgetName:G,widgetBaseClass:M,widgetFullName:M});if(L){B.each(L._childConstructors,function(O,P){var N=P.prototype;B.widget(N.namespace+"."+N.widgetName,I,P._proto)});delete L._childConstructors}else{J._childConstructors.push(I)}B.widget.bridge(G,I)};B.widget.extend=function(K){var G=D.call(arguments,1),J=0,F=G.length,H,I;for(;J<F;J++){for(H in G[J]){I=G[J][H];if(G[J].hasOwnProperty(H)&&I!==E){if(B.isPlainObject(I)){K[H]=B.isPlainObject(K[H])?B.widget.extend({},K[H],I):B.widget.extend({},I)}else{K[H]=I}}}}return K};B.widget.bridge=function(G,F){var H=F.prototype.widgetFullName||G;B.fn[G]=function(K){var I=typeof K==="string",J=D.call(arguments,1),L=this;K=!I&&J.length?B.widget.extend.apply(null,[K].concat(J)):K;if(I){this.each(function(){var N,M=B.data(this,H);if(!M){return B.error("cannot call methods on "+G+" prior to initialization; attempted to call method '"+K+"'")}if(!B.isFunction(M[K])||K.charAt(0)==="_"){return B.error("no such method '"+K+"' for "+G+" widget instance")}N=M[K].apply(M,J);if(N!==M&&N!==E){L=N&&N.jquery?L.pushStack(N.get()):N;return false}})}else{this.each(function(){var M=B.data(this,H);if(M){M.option(K||{})._init()}else{B.data(this,H,new F(K,this))}})}return L}};B.Widget=function(){};B.Widget._childConstructors=[];B.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",defaultElement:"<div>",options:{disabled:false,create:null},_createWidget:function(F,G){G=B(G||this.defaultElement||this)[0];this.element=B(G);this.uuid=A++;this.eventNamespace="."+this.widgetName+this.uuid;this.options=B.widget.extend({},this.options,this._getCreateOptions(),F);this.bindings=B();this.hoverable=B();this.focusable=B();if(G!==this){B.data(G,this.widgetName,this);B.data(G,this.widgetFullName,this);this._on(true,this.element,{remove:function(H){if(H.target===G){this.destroy()}}});this.document=B(G.style?G.ownerDocument:G.document||G);this.window=B(this.document[0].defaultView||this.document[0].parentWindow)}this._create();this._trigger("create",null,this._getCreateEventData());this._init()},_getCreateOptions:B.noop,_getCreateEventData:B.noop,_create:B.noop,_init:B.noop,destroy:function(){this._destroy();this.element.unbind(this.eventNamespace).removeData(this.widgetName).removeData(this.widgetFullName).removeData(B.camelCase(this.widgetFullName));this.widget().unbind(this.eventNamespace).removeAttr("aria-disabled").removeClass(this.widgetFullName+"-disabled ui-state-disabled");this.bindings.unbind(this.eventNamespace);this.hoverable.removeClass("ui-state-hover");this.focusable.removeClass("ui-state-focus")},_destroy:B.noop,widget:function(){return this.element},option:function(I,J){var F=I,K,H,G;if(arguments.length===0){return B.widget.extend({},this.options)}if(typeof I==="string"){F={};K=I.split(".");I=K.shift();if(K.length){H=F[I]=B.widget.extend({},this.options[I]);for(G=0;G<K.length-1;G++){H[K[G]]=H[K[G]]||{};H=H[K[G]]}I=K.pop();if(J===E){return H[I]===E?null:H[I]}H[I]=J}else{if(J===E){return this.options[I]===E?null:this.options[I]}F[I]=J}}this._setOptions(F);return this},_setOptions:function(F){var G;for(G in F){this._setOption(G,F[G])}return this},_setOption:function(F,G){this.options[F]=G;if(F==="disabled"){this.widget().toggleClass(this.widgetFullName+"-disabled ui-state-disabled",!!G).attr("aria-disabled",G);this.hoverable.removeClass("ui-state-hover");this.focusable.removeClass("ui-state-focus")}return this},enable:function(){return this._setOption("disabled",false)},disable:function(){return this._setOption("disabled",true)},_on:function(I,H,G){var J,F=this;if(typeof I!=="boolean"){G=H;H=I;I=false}if(!G){G=H;H=this.element;J=this.widget()}else{H=J=B(H);this.bindings=this.bindings.add(H)}B.each(G,function(P,O){function M(){if(!I&&(F.options.disabled===true||B(this).hasClass("ui-state-disabled"))){return }return(typeof O==="string"?F[O]:O).apply(F,arguments)}if(typeof O!=="string"){M.guid=O.guid=O.guid||M.guid||B.guid++}var N=P.match(/^(\w+)\s*(.*)$/),L=N[1]+F.eventNamespace,K=N[2];if(K){J.delegate(K,L,M)}else{H.bind(L,M)}})},_off:function(G,F){F=(F||"").split(" ").join(this.eventNamespace+" ")+this.eventNamespace;G.unbind(F).undelegate(F)},_delay:function(I,H){function G(){return(typeof I==="string"?F[I]:I).apply(F,arguments)}var F=this;return setTimeout(G,H||0)},_hoverable:function(F){this.hoverable=this.hoverable.add(F);this._on(F,{mouseenter:function(G){B(G.currentTarget).addClass("ui-state-hover")},mouseleave:function(G){B(G.currentTarget).removeClass("ui-state-hover")}})},_focusable:function(F){this.focusable=this.focusable.add(F);this._on(F,{focusin:function(G){B(G.currentTarget).addClass("ui-state-focus")},focusout:function(G){B(G.currentTarget).removeClass("ui-state-focus")}})},_trigger:function(F,G,H){var K,J,I=this.options[F];H=H||{};G=B.Event(G);G.type=(F===this.widgetEventPrefix?F:this.widgetEventPrefix+F).toLowerCase();G.target=this.element[0];J=G.originalEvent;if(J){for(K in J){if(!(K in G)){G[K]=J[K]}}}this.element.trigger(G,H);return !(B.isFunction(I)&&I.apply(this.element[0],[G].concat(H))===false||G.isDefaultPrevented())}};B.each({show:"fadeIn",hide:"fadeOut"},function(G,F){B.Widget.prototype["_"+G]=function(J,I,L){if(typeof I==="string"){I={effect:I}}var K,H=!I?G:I===true||typeof I==="number"?F:I.effect||F;I=I||{};if(typeof I==="number"){I={duration:I}}K=!B.isEmptyObject(I);I.complete=L;if(I.delay){J.delay(I.delay)}if(K&&B.effects&&(B.effects.effect[H]||B.uiBackCompat!==false&&B.effects[H])){J[G](I)}else{if(H!==G&&J[H]){J[H](I.duration,I.easing,L)}else{J.queue(function(M){B(this)[G]();if(L){L.call(J[0])}M()})}}}});if(B.uiBackCompat!==false){B.Widget.prototype._getCreateOptions=function(){if(B.metadata&&B.metadata.get){return B.metadata&&B.metadata.get(this.element[0])[this.widgetName]}return null}}})(jQuery);
/*
 * jQuery UI Mouse 1.9.2
 * http://jqueryui.com
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/mouse/
 *
 * Depends:
 *  jquery.ui.widget.js
 */
(function(B,C){var A=false;B(document).mouseup(function(D){A=false});B.widget("ui.mouse",{version:"1.9.2",options:{cancel:"input,textarea,button,select,option",distance:1,delay:0},_mouseInit:function(){var D=this;this.element.bind("mousedown."+this.widgetName,function(E){return D._mouseDown(E)}).bind("click."+this.widgetName,function(E){if(true===B.data(E.target,D.widgetName+".preventClickEvent")){B.removeData(E.target,D.widgetName+".preventClickEvent");E.stopImmediatePropagation();return false}});this.started=false},_mouseDestroy:function(){this.element.unbind("."+this.widgetName);if(this._mouseMoveDelegate){B(document).unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate)}},_mouseDown:function(F){if(A){return }(this._mouseStarted&&this._mouseUp(F));this._mouseDownEvent=F;var E=this,G=(F.which===1),D=(typeof this.options.cancel==="string"&&F.target.nodeName?B(F.target).closest(this.options.cancel).length:false);if(!G||D||!this._mouseCapture(F)){return true}this.mouseDelayMet=!this.options.delay;if(!this.mouseDelayMet){this._mouseDelayTimer=setTimeout(function(){E.mouseDelayMet=true},this.options.delay)}if(this._mouseDistanceMet(F)&&this._mouseDelayMet(F)){this._mouseStarted=(this._mouseStart(F)!==false);if(!this._mouseStarted){F.preventDefault();return true}}if(true===B.data(F.target,this.widgetName+".preventClickEvent")){B.removeData(F.target,this.widgetName+".preventClickEvent")}this._mouseMoveDelegate=function(H){return E._mouseMove(H)};this._mouseUpDelegate=function(H){return E._mouseUp(H)};B(document).bind("mousemove."+this.widgetName,this._mouseMoveDelegate).bind("mouseup."+this.widgetName,this._mouseUpDelegate);F.preventDefault();A=true;return true},_mouseMove:function(D){if(B.ui.ie&&!(document.documentMode>=9)&&!D.button){return this._mouseUp(D)}if(this._mouseStarted){this._mouseDrag(D);return D.preventDefault()}if(this._mouseDistanceMet(D)&&this._mouseDelayMet(D)){this._mouseStarted=(this._mouseStart(this._mouseDownEvent,D)!==false);(this._mouseStarted?this._mouseDrag(D):this._mouseUp(D))}return !this._mouseStarted},_mouseUp:function(D){B(document).unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate);if(this._mouseStarted){this._mouseStarted=false;if(D.target===this._mouseDownEvent.target){B.data(D.target,this.widgetName+".preventClickEvent",true)}this._mouseStop(D)}return false},_mouseDistanceMet:function(D){return(Math.max(Math.abs(this._mouseDownEvent.pageX-D.pageX),Math.abs(this._mouseDownEvent.pageY-D.pageY))>=this.options.distance)},_mouseDelayMet:function(D){return this.mouseDelayMet},_mouseStart:function(D){},_mouseDrag:function(D){},_mouseStop:function(D){},_mouseCapture:function(D){return true}})})(jQuery);
/*
 * jQuery UI Slider 1.9.2
 * http://jqueryui.com
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/slider/
 *
 * Depends:
 *  jquery.ui.core.js
 *  jquery.ui.mouse.js
 *  jquery.ui.widget.js
 */
(function(B,C){var A=5;B.widget("ui.slider",B.ui.mouse,{version:"1.9.2",widgetEventPrefix:"slide",options:{animate:false,distance:0,max:100,min:0,orientation:"horizontal",range:false,pointer:true,step:1,value:0,values:null},_create:function(){var I,D,E=this.options,F=this.element.find(".ui-slider-handle").addClass("ui-state-default ui-corner-all"),K="<a class='ui-slider-handle ui-state-default ui-corner-all' href='#' title='"+E.value+"'></a>",N=[];this._keySliding=false;this._mouseSliding=false;this._animateOff=true;this._handleIndex=null;this._detectOrientation();this._mouseInit();this.element.addClass("ui-slider ui-slider-"+this.orientation+" ui-widget ui-widget-content ui-corner-all"+(E.disabled?" ui-slider-disabled ui-disabled":""));this.range=B([]);if(E.range){if(E.range===true){if(!E.values){E.values=[this._valueMin(),this._valueMin()]}if(E.values.length&&E.values.length!==2){E.values=[E.values[0],E.values[0]]}}this.range=B("<div></div>").appendTo(this.element).addClass("ui-slider-range ui-widget-header"+((E.range==="min"||E.range==="max")?" ui-slider-range-"+E.range:""))}D=(E.values&&E.values.length)||1;for(I=F.length;I<D;I++){N.push(K)}this.handles=F.add(B(N.join("")).appendTo(this.element));this.handle=this.handles.eq(0);if(E.pointer){this.point=B("<div class='relative'></div>").width(this.element.width()).css("margin-top",this.element[0].offsetHeight-2).addClass("ui-slider-pointer");var G="";var J=this._valueMin();var M=this._valueMax();for(var I=J;I<=M;I++){var L=I;var H=(M!==J)?(L-J)/(M-J)*100:0;G+="<span class='ui_sliderPoint absolute'step='"+I+"' style='left:"+H+"%;'><em></em>";if(E.text){G+="<p class='ui_point_text'>"+E.text[I]+"</p>"}G+="</span>"}this.point.append(B(G)).appendTo(this.element)}this.handles.filter("a").click(function(O){O.preventDefault()}).mouseenter(function(){if(!E.disabled){B(this).addClass("ui-state-hover")}}).mouseleave(function(){B(this).removeClass("ui-state-hover")}).focus(function(){if(!E.disabled){B(".ui-slider .ui-state-focus").removeClass("ui-state-focus");B(this).addClass("ui-state-focus")}else{B(this).blur()}}).blur(function(){B(this).removeClass("ui-state-focus")});this.handles.each(function(O){B(this).data("ui-slider-handle-index",O)});this._on(this.handles,{keydown:function(S){var T,Q,P,R,O=B(S.target).data("ui-slider-handle-index");switch(S.keyCode){case B.ui.keyCode.HOME:case B.ui.keyCode.END:case B.ui.keyCode.PAGE_UP:case B.ui.keyCode.PAGE_DOWN:case B.ui.keyCode.UP:case B.ui.keyCode.RIGHT:case B.ui.keyCode.DOWN:case B.ui.keyCode.LEFT:S.preventDefault();if(!this._keySliding){this._keySliding=true;B(S.target).addClass("ui-state-active");T=this._start(S,O);if(T===false){return }}break}R=this.options.step;if(this.options.values&&this.options.values.length){Q=P=this.values(O)}else{Q=P=this.value()}switch(S.keyCode){case B.ui.keyCode.HOME:P=this._valueMin();break;case B.ui.keyCode.END:P=this._valueMax();break;case B.ui.keyCode.PAGE_UP:P=this._trimAlignValue(Q+((this._valueMax()-this._valueMin())/A));break;case B.ui.keyCode.PAGE_DOWN:P=this._trimAlignValue(Q-((this._valueMax()-this._valueMin())/A));break;case B.ui.keyCode.UP:case B.ui.keyCode.RIGHT:if(Q===this._valueMax()){return }P=this._trimAlignValue(Q+R);break;case B.ui.keyCode.DOWN:case B.ui.keyCode.LEFT:if(Q===this._valueMin()){return }P=this._trimAlignValue(Q-R);break}this._slide(S,O,P)},keyup:function(P){var O=B(P.target).data("ui-slider-handle-index");if(this._keySliding){this._keySliding=false;this._stop(P,O);this._change(P,O);B(P.target).removeClass("ui-state-active")}}});this._refreshValue();this._animateOff=false},_destroy:function(){this.handles.remove();this.range.remove();this.element.removeClass("ui-slider ui-slider-horizontal ui-slider-vertical ui-slider-disabled ui-widget ui-widget-content ui-corner-all");this._mouseDestroy()},_mouseCapture:function(F){var J,M,E,H,L,N,I,D,K=this,G=this.options;if(G.disabled){return false}this.elementSize={width:this.element.outerWidth(),height:this.element.outerHeight()};this.elementOffset=this.element.offset();J={x:F.pageX,y:F.pageY};M=this._normValueFromMouse(J);E=this._valueMax()-this._valueMin()+1;this.handles.each(function(O){var P=Math.abs(M-K.values(O));if(E>P){E=P;H=B(this);L=O}});if(G.range===true&&this.values(1)===G.min){L+=1;H=B(this.handles[L])}N=this._start(F,L);if(N===false){return false}this._mouseSliding=true;this._handleIndex=L;H.addClass("ui-state-active").focus();I=H.offset();D=!B(F.target).parents().andSelf().is(".ui-slider-handle");this._clickOffset=D?{left:0,top:0}:{left:F.pageX-I.left-(H.width()/2),top:F.pageY-I.top-(H.height()/2)-(parseInt(H.css("borderTopWidth"),10)||0)-(parseInt(H.css("borderBottomWidth"),10)||0)+(parseInt(H.css("marginTop"),10)||0)};if(!this.handles.hasClass("ui-state-hover")){this._slide(F,L,M)}this._animateOff=true;return true},_mouseStart:function(){return true},_mouseDrag:function(F){var D={x:F.pageX,y:F.pageY},E=this._normValueFromMouse(D);this._slide(F,this._handleIndex,E);return false},_mouseStop:function(D){this.handles.removeClass("ui-state-active");this._mouseSliding=false;this._stop(D,this._handleIndex);this._change(D,this._handleIndex);this._handleIndex=null;this._clickOffset=null;this._animateOff=false;return false},_detectOrientation:function(){this.orientation=(this.options.orientation==="vertical")?"vertical":"horizontal"},_normValueFromMouse:function(E){var D,H,G,F,I;if(this.orientation==="horizontal"){D=this.elementSize.width;H=E.x-this.elementOffset.left-(this._clickOffset?this._clickOffset.left:0)}else{D=this.elementSize.height;H=E.y-this.elementOffset.top-(this._clickOffset?this._clickOffset.top:0)}G=(H/D);if(G>1){G=1}if(G<0){G=0}if(this.orientation==="vertical"){G=1-G}F=this._valueMax()-this._valueMin();I=this._valueMin()+G*F;return this._trimAlignValue(I)},_start:function(F,E){var D={handle:this.handles[E],value:this.value()};if(this.options.values&&this.options.values.length){D.value=this.values(E);D.values=this.values()}return this._trigger("start",F,D)},_slide:function(H,G,F){var D,E,I;if(this.options.values&&this.options.values.length){D=this.values(G?0:1);if((this.options.values.length===2&&this.options.range===true)&&((G===0&&F>D)||(G===1&&F<D))){F=D}if(F!==this.values(G)){E=this.values();E[G]=F;I=this._trigger("slide",H,{handle:this.handles[G],value:F,values:E});D=this.values(G?0:1);if(I!==false){this.values(G,F,true)}}}else{if(F!==this.value()){I=this._trigger("slide",H,{handle:this.handles[G],value:F});if(I!==false){this.value(F)}}}},_stop:function(F,E){var D={handle:this.handles[E],value:this.value()};if(this.options.values&&this.options.values.length){D.value=this.values(E);D.values=this.values()}this._trigger("stop",F,D)},_change:function(F,E){if(!this._keySliding&&!this._mouseSliding){var D={handle:this.handles[E],value:this.value()};if(this.options.values&&this.options.values.length){D.value=this.values(E);D.values=this.values()}D.handle.title=D.value;this._trigger("change",F,D)}},value:function(D){if(arguments.length){this.options.value=this._trimAlignValue(D);this._refreshValue();this._change(null,0);return }return this._value()},values:function(E,H){var G,D,F;if(arguments.length>1){this.options.values[E]=this._trimAlignValue(H);this._refreshValue();this._change(null,E);return }if(arguments.length){if(B.isArray(arguments[0])){G=this.options.values;D=arguments[0];for(F=0;F<G.length;F+=1){G[F]=this._trimAlignValue(D[F]);this._change(null,F)}this._refreshValue()}else{if(this.options.values&&this.options.values.length){return this._values(E)}else{return this.value()}}}else{return this._values()}},_setOption:function(E,F){var D,G=0;if(B.isArray(this.options.values)){G=this.options.values.length}B.Widget.prototype._setOption.apply(this,arguments);switch(E){case"disabled":if(F){this.handles.filter(".ui-state-focus").blur();this.handles.removeClass("ui-state-hover");this.handles.prop("disabled",true);this.element.addClass("ui-disabled")}else{this.handles.prop("disabled",false);this.element.removeClass("ui-disabled")}break;case"orientation":this._detectOrientation();this.element.removeClass("ui-slider-horizontal ui-slider-vertical").addClass("ui-slider-"+this.orientation);this._refreshValue();break;case"value":this._animateOff=true;this._refreshValue();this._change(null,0);this._animateOff=false;break;case"values":this._animateOff=true;this._refreshValue();for(D=0;D<G;D+=1){this._change(null,D)}this._animateOff=false;break;case"min":case"max":this._animateOff=true;this._refreshValue();this._animateOff=false;break}},_value:function(){var D=this.options.value;D=this._trimAlignValue(D);return D},_values:function(D){var G,F,E;if(arguments.length){G=this.options.values[D];G=this._trimAlignValue(G);return G}else{F=this.options.values.slice();for(E=0;E<F.length;E+=1){F[E]=this._trimAlignValue(F[E])}return F}},_trimAlignValue:function(G){if(G<=this._valueMin()){return this._valueMin()}if(G>=this._valueMax()){return this._valueMax()}var D=(this.options.step>0)?this.options.step:1,F=(G-this._valueMin())%D,E=G-F;if(Math.abs(F)*2>=D){E+=(F>0)?D:(-D)}return parseFloat(E.toFixed(5))},_valueMin:function(){return this.options.min},_valueMax:function(){return this.options.max},_refreshValue:function(){var I,H,L,J,M,G=this.options.range,F=this.options,K=this,E=(!this._animateOff)?F.animate:false,D={};if(this.options.values&&this.options.values.length){this.handles.each(function(N){H=(K.values(N)-K._valueMin())/(K._valueMax()-K._valueMin())*100;D[K.orientation==="horizontal"?"left":"bottom"]=H+"%";B(this).stop(1,1)[E?"animate":"css"](D,F.animate);if(K.options.range===true){if(K.orientation==="horizontal"){if(N===0){K.range.stop(1,1)[E?"animate":"css"]({left:H+"%"},F.animate)}if(N===1){K.range[E?"animate":"css"]({width:(H-I)+"%"},{queue:false,duration:F.animate})}}else{if(N===0){K.range.stop(1,1)[E?"animate":"css"]({bottom:(H)+"%"},F.animate)}if(N===1){K.range[E?"animate":"css"]({height:(H-I)+"%"},{queue:false,duration:F.animate})}}}I=H})}else{L=this.value();J=this._valueMin();M=this._valueMax();H=(M!==J)?(L-J)/(M-J)*100:0;D[this.orientation==="horizontal"?"left":"bottom"]=H+"%";this.handle.stop(1,1)[E?"animate":"css"](D,F.animate);if(G==="min"&&this.orientation==="horizontal"){this.range.stop(1,1)[E?"animate":"css"]({width:H+"%"},F.animate)}if(G==="max"&&this.orientation==="horizontal"){this.range[E?"animate":"css"]({width:(100-H)+"%"},{queue:false,duration:F.animate})}if(G==="min"&&this.orientation==="vertical"){this.range.stop(1,1)[E?"animate":"css"]({height:H+"%"},F.animate)}if(G==="max"&&this.orientation==="vertical"){this.range[E?"animate":"css"]({height:(100-H)+"%"},{queue:false,duration:F.animate})}}}})}(jQuery));
/*
 * jQuery UI Draggable 1.9.2
 * http://jqueryui.com
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/draggable/
 *
 * Depends:
 *  jquery.ui.core.js
 *  jquery.ui.mouse.js
 *  jquery.ui.widget.js
 */
(function(A,B){A.widget("ui.draggable",A.ui.mouse,{version:"1.9.2",widgetEventPrefix:"drag",options:{addClasses:true,appendTo:"parent",axis:false,connectToSortable:false,containment:false,cursor:"auto",cursorAt:false,grid:false,handle:false,helper:"original",iframeFix:false,opacity:false,refreshPositions:false,revert:false,revertDuration:500,scope:"default",scroll:true,scrollSensitivity:20,scrollSpeed:20,snap:false,snapMode:"both",snapTolerance:20,stack:false,zIndex:false},_create:function(){if(this.options.helper=="original"&&!(/^(?:r|a|f)/).test(this.element.css("position"))){this.element[0].style.position="relative"}(this.options.addClasses&&this.element.addClass("ui-draggable"));(this.options.disabled&&this.element.addClass("ui-draggable-disabled"));this._mouseInit()},_destroy:function(){this.element.removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");this._mouseDestroy()},_mouseCapture:function(C){var D=this.options;if(this.helper||D.disabled||A(C.target).is(".ui-resizable-handle")){return false}this.handle=this._getHandle(C);if(!this.handle){return false}A(D.iframeFix===true?"iframe":D.iframeFix).each(function(){A('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width:this.offsetWidth+"px",height:this.offsetHeight+"px",position:"absolute",opacity:"0.001",zIndex:1000}).css(A(this).offset()).appendTo("body")});return true},_mouseStart:function(C){var D=this.options;this.helper=this._createHelper(C);this.helper.addClass("ui-draggable-dragging");this._cacheHelperProportions();if(A.ui.ddmanager){A.ui.ddmanager.current=this}this._cacheMargins();this.cssPosition=this.helper.css("position");this.scrollParent=this.helper.scrollParent();this.offset=this.positionAbs=this.element.offset();this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-this.margins.left};A.extend(this.offset,{click:{left:C.pageX-this.offset.left,top:C.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});this.originalPosition=this.position=this._generatePosition(C);this.originalPageX=C.pageX;this.originalPageY=C.pageY;(D.cursorAt&&this._adjustOffsetFromHelper(D.cursorAt));if(D.containment){this._setContainment()}if(this._trigger("start",C)===false){this._clear();return false}this._cacheHelperProportions();if(A.ui.ddmanager&&!D.dropBehaviour){A.ui.ddmanager.prepareOffsets(this,C)}this._mouseDrag(C,true);if(A.ui.ddmanager){A.ui.ddmanager.dragStart(this,C)}return true},_mouseDrag:function(E,G){var D=A.browser.msie;var C=A.browser.version;D=D&&(C.length>3);D=D||A.browser.mozilla;if(D){if(E.buttons!=1){this._mouseUp({});return false}}this.position=this._generatePosition(E);this.positionAbs=this._convertPositionTo("absolute");if(!G){var F=this._uiHash();if(this._trigger("drag",E,F)===false){this._mouseUp({});return false}this.position=F.position}if(!this.options.axis||this.options.axis!="y"){this.helper[0].style.left=this.position.left+"px"}if(!this.options.axis||this.options.axis!="x"){this.helper[0].style.top=this.position.top+"px"}if(A.ui.ddmanager){A.ui.ddmanager.drag(this,E)}return false},_mouseStop:function(E){var G=false;if(A.ui.ddmanager&&!this.options.dropBehaviour){G=A.ui.ddmanager.drop(this,E)}if(this.dropped){G=this.dropped;this.dropped=false}var C=this.element[0],F=false;while(C&&(C=C.parentNode)){if(C==document){F=true}}if(!F&&this.options.helper==="original"){return false}if((this.options.revert=="invalid"&&!G)||(this.options.revert=="valid"&&G)||this.options.revert===true||(A.isFunction(this.options.revert)&&this.options.revert.call(this.element,G))){var D=this;A(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,10),function(){if(D._trigger("stop",E)!==false){D._clear()}})}else{if(this._trigger("stop",E)!==false){this._clear()}}return false},_mouseUp:function(C){A("div.ui-draggable-iframeFix").each(function(){this.parentNode.removeChild(this)});if(A.ui.ddmanager){A.ui.ddmanager.dragStop(this,C)}return A.ui.mouse.prototype._mouseUp.call(this,C)},cancel:function(){if(this.helper.is(".ui-draggable-dragging")){this._mouseUp({})}else{this._clear()}return this},_getHandle:function(C){var D=!this.options.handle||!A(this.options.handle,this.element).length?true:false;A(this.options.handle,this.element).find("*").andSelf().each(function(){if(this==C.target){D=true}});return D},_createHelper:function(D){var E=this.options;var C=A.isFunction(E.helper)?A(E.helper.apply(this.element[0],[D])):(E.helper=="clone"?this.element.clone().removeAttr("id"):this.element);if(!C.parents("body").length){C.appendTo((E.appendTo=="parent"?this.element[0].parentNode:E.appendTo))}if(C[0]!=this.element[0]&&!(/(fixed|absolute)/).test(C.css("position"))){C.css("position","absolute")}return C},_adjustOffsetFromHelper:function(C){if(typeof C=="string"){C=C.split(" ")}if(A.isArray(C)){C={left:+C[0],top:+C[1]||0}}if("left" in C){this.offset.click.left=C.left+this.margins.left}if("right" in C){this.offset.click.left=this.helperProportions.width-C.right+this.margins.left}if("top" in C){this.offset.click.top=C.top+this.margins.top}if("bottom" in C){this.offset.click.top=this.helperProportions.height-C.bottom+this.margins.top}},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var C=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&A.contains(this.scrollParent[0],this.offsetParent[0])){C.left+=this.scrollParent.scrollLeft();C.top+=this.scrollParent.scrollTop()}if((this.offsetParent[0]==document.body)||(this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&A.ui.ie)){C={top:0,left:0}}return{top:C.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:C.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var C=this.element.position();return{top:C.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:C.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else{return{top:0,left:0}}},_cacheMargins:function(){this.margins={left:(parseInt(this.element.css("marginLeft"),10)||0),top:(parseInt(this.element.css("marginTop"),10)||0),right:(parseInt(this.element.css("marginRight"),10)||0),bottom:(parseInt(this.element.css("marginBottom"),10)||0)}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var F=this.options;if(F.containment=="parent"){F.containment=this.helper[0].parentNode}if(F.containment=="document"||F.containment=="window"){this.containment=[F.containment=="document"?0:A(window).scrollLeft()-this.offset.relative.left-this.offset.parent.left,F.containment=="document"?0:A(window).scrollTop()-this.offset.relative.top-this.offset.parent.top,(F.containment=="document"?0:A(window).scrollLeft())+A(F.containment=="document"?document:window).width()-this.helperProportions.width-this.margins.left,(F.containment=="document"?0:A(window).scrollTop())+(A(F.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top]}if(!(/^(document|window|parent)$/).test(F.containment)&&F.containment.constructor!=Array){var G=A(F.containment);var D=G[0];if(!D){return }var E=G.offset();var C=(A(D).css("overflow")!="hidden");this.containment=[(parseInt(A(D).css("borderLeftWidth"),10)||0)+(parseInt(A(D).css("paddingLeft"),10)||0),(parseInt(A(D).css("borderTopWidth"),10)||0)+(parseInt(A(D).css("paddingTop"),10)||0),(C?Math.max(D.scrollWidth,D.offsetWidth):D.offsetWidth)-(parseInt(A(D).css("borderLeftWidth"),10)||0)-(parseInt(A(D).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left-this.margins.right,(C?Math.max(D.scrollHeight,D.offsetHeight):D.offsetHeight)-(parseInt(A(D).css("borderTopWidth"),10)||0)-(parseInt(A(D).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top-this.margins.bottom];this.relative_container=G}else{if(F.containment.constructor==Array){this.containment=F.containment}}},_convertPositionTo:function(F,H){if(!H){H=this.position}var D=F=="absolute"?1:-1;var E=this.options,C=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&A.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,G=(/(html|body)/i).test(C[0].tagName);return{top:(H.top+this.offset.relative.top*D+this.offset.parent.top*D-((this.cssPosition=="fixed"?-this.scrollParent.scrollTop():(G?0:C.scrollTop()))*D)),left:(H.left+this.offset.relative.left*D+this.offset.parent.left*D-((this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():G?0:C.scrollLeft())*D))}},_generatePosition:function(D){var E=this.options,L=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&A.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,I=(/(html|body)/i).test(L[0].tagName);var H=D.pageX;var G=D.pageY;if(this.originalPosition){var C;if(this.containment){if(this.relative_container){var K=this.relative_container.offset();C=[this.containment[0]+K.left,this.containment[1]+K.top,this.containment[2]+K.left,this.containment[3]+K.top]}else{C=this.containment}if(D.pageX-this.offset.click.left<C[0]){H=C[0]+this.offset.click.left}if(D.pageY-this.offset.click.top<C[1]){G=C[1]+this.offset.click.top}if(D.pageX-this.offset.click.left>C[2]){H=C[2]+this.offset.click.left}if(D.pageY-this.offset.click.top>C[3]){G=C[3]+this.offset.click.top}}if(E.grid){var J=E.grid[1]?this.originalPageY+Math.round((G-this.originalPageY)/E.grid[1])*E.grid[1]:this.originalPageY;G=C?(!(J-this.offset.click.top<C[1]||J-this.offset.click.top>C[3])?J:(!(J-this.offset.click.top<C[1])?J-E.grid[1]:J+E.grid[1])):J;var F=E.grid[0]?this.originalPageX+Math.round((H-this.originalPageX)/E.grid[0])*E.grid[0]:this.originalPageX;H=C?(!(F-this.offset.click.left<C[0]||F-this.offset.click.left>C[2])?F:(!(F-this.offset.click.left<C[0])?F-E.grid[0]:F+E.grid[0])):F}}return{top:(G-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+((this.cssPosition=="fixed"?-this.scrollParent.scrollTop():(I?0:L.scrollTop())))),left:(H-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+((this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():I?0:L.scrollLeft())))}},_clear:function(){this.helper.removeClass("ui-draggable-dragging");if(this.helper[0]!=this.element[0]&&!this.cancelHelperRemoval){this.helper.remove()}this.helper=null;this.cancelHelperRemoval=false},_trigger:function(C,D,E){E=E||this._uiHash();A.ui.plugin.call(this,C,[D,E]);if(C=="drag"){this.positionAbs=this._convertPositionTo("absolute")}return A.Widget.prototype._trigger.call(this,C,D,E)},plugins:{},_uiHash:function(C){return{helper:this.helper,position:this.position,originalPosition:this.originalPosition,offset:this.positionAbs}}});A.ui.plugin.add("draggable","connectToSortable",{start:function(D,F){var E=A(this).data("draggable"),G=E.options,C=A.extend({},F,{item:E.element});E.sortables=[];A(G.connectToSortable).each(function(){var H=A.data(this,"sortable");if(H&&!H.options.disabled){E.sortables.push({instance:H,shouldRevert:H.options.revert});H.refreshPositions();H._trigger("activate",D,C)}})},stop:function(D,F){var E=A(this).data("draggable"),C=A.extend({},F,{item:E.element});A.each(E.sortables,function(){if(this.instance.isOver){this.instance.isOver=0;E.cancelHelperRemoval=true;this.instance.cancelHelperRemoval=false;if(this.shouldRevert){this.instance.options.revert=true}this.instance._mouseStop(D);this.instance.options.helper=this.instance.options._helper;if(E.options.helper=="original"){this.instance.currentItem.css({top:"auto",left:"auto"})}}else{this.instance.cancelHelperRemoval=false;this.instance._trigger("deactivate",D,C)}})},drag:function(D,G){var F=A(this).data("draggable"),C=this;var E=function(J){var O=this.offset.click.top,N=this.offset.click.left;var H=this.positionAbs.top,L=this.positionAbs.left;var K=J.height,M=J.width;var P=J.top,I=J.left;return A.ui.isOver(H+O,L+N,P,I,K,M)};A.each(F.sortables,function(I){var H=false;var J=this;this.instance.positionAbs=F.positionAbs;this.instance.helperProportions=F.helperProportions;this.instance.offset.click=F.offset.click;if(this.instance._intersectsWith(this.instance.containerCache)){H=true;A.each(F.sortables,function(){this.instance.positionAbs=F.positionAbs;this.instance.helperProportions=F.helperProportions;this.instance.offset.click=F.offset.click;if(this!=J&&this.instance._intersectsWith(this.instance.containerCache)&&A.ui.contains(J.instance.element[0],this.instance.element[0])){H=false}return H})}if(H){if(!this.instance.isOver){this.instance.isOver=1;this.instance.currentItem=A(C).clone().removeAttr("id").appendTo(this.instance.element).data("sortable-item",true);this.instance.options._helper=this.instance.options.helper;this.instance.options.helper=function(){return G.helper[0]};D.target=this.instance.currentItem[0];this.instance._mouseCapture(D,true);this.instance._mouseStart(D,true,true);this.instance.offset.click.top=F.offset.click.top;this.instance.offset.click.left=F.offset.click.left;this.instance.offset.parent.left-=F.offset.parent.left-this.instance.offset.parent.left;this.instance.offset.parent.top-=F.offset.parent.top-this.instance.offset.parent.top;F._trigger("toSortable",D);F.dropped=this.instance.element;F.currentItem=F.element;this.instance.fromOutside=F}if(this.instance.currentItem){this.instance._mouseDrag(D)}}else{if(this.instance.isOver){this.instance.isOver=0;this.instance.cancelHelperRemoval=true;this.instance.options.revert=false;this.instance._trigger("out",D,this.instance._uiHash(this.instance));this.instance._mouseStop(D,true);this.instance.options.helper=this.instance.options._helper;this.instance.currentItem.remove();if(this.instance.placeholder){this.instance.placeholder.remove()}F._trigger("fromSortable",D);F.dropped=false}}})}});A.ui.plugin.add("draggable","cursor",{start:function(D,E){var C=A("body"),F=A(this).data("draggable").options;if(C.css("cursor")){F._cursor=C.css("cursor")}C.css("cursor",F.cursor)},stop:function(C,D){var E=A(this).data("draggable").options;if(E._cursor){A("body").css("cursor",E._cursor)}}});A.ui.plugin.add("draggable","opacity",{start:function(D,E){var C=A(E.helper),F=A(this).data("draggable").options;if(C.css("opacity")){F._opacity=C.css("opacity")}C.css("opacity",F.opacity)},stop:function(C,D){var E=A(this).data("draggable").options;if(E._opacity){A(D.helper).css("opacity",E._opacity)}}});A.ui.plugin.add("draggable","scroll",{start:function(D,E){var C=A(this).data("draggable");if(C.scrollParent[0]!=document&&C.scrollParent[0].tagName!="HTML"){C.overflowOffset=C.scrollParent.offset()}},drag:function(E,F){var D=A(this).data("draggable"),G=D.options,C=false;if(D.scrollParent[0]!=document&&D.scrollParent[0].tagName!="HTML"){if(!G.axis||G.axis!="x"){if((D.overflowOffset.top+D.scrollParent[0].offsetHeight)-E.pageY<G.scrollSensitivity){D.scrollParent[0].scrollTop=C=D.scrollParent[0].scrollTop+G.scrollSpeed}else{if(E.pageY-D.overflowOffset.top<G.scrollSensitivity){D.scrollParent[0].scrollTop=C=D.scrollParent[0].scrollTop-G.scrollSpeed}}}if(!G.axis||G.axis!="y"){if((D.overflowOffset.left+D.scrollParent[0].offsetWidth)-E.pageX<G.scrollSensitivity){D.scrollParent[0].scrollLeft=C=D.scrollParent[0].scrollLeft+G.scrollSpeed}else{if(E.pageX-D.overflowOffset.left<G.scrollSensitivity){D.scrollParent[0].scrollLeft=C=D.scrollParent[0].scrollLeft-G.scrollSpeed}}}}else{if(!G.axis||G.axis!="x"){if(E.pageY-A(document).scrollTop()<G.scrollSensitivity){C=A(document).scrollTop(A(document).scrollTop()-G.scrollSpeed)}else{if(A(window).height()-(E.pageY-A(document).scrollTop())<G.scrollSensitivity){C=A(document).scrollTop(A(document).scrollTop()+G.scrollSpeed)}}}if(!G.axis||G.axis!="y"){if(E.pageX-A(document).scrollLeft()<G.scrollSensitivity){C=A(document).scrollLeft(A(document).scrollLeft()-G.scrollSpeed)}else{if(A(window).width()-(E.pageX-A(document).scrollLeft())<G.scrollSensitivity){C=A(document).scrollLeft(A(document).scrollLeft()+G.scrollSpeed)}}}}if(C!==false&&A.ui.ddmanager&&!G.dropBehaviour){A.ui.ddmanager.prepareOffsets(D,E)}}});A.ui.plugin.add("draggable","snap",{start:function(D,E){var C=A(this).data("draggable"),F=C.options;C.snapElements=[];A(F.snap.constructor!=String?(F.snap.items||":data(draggable)"):F.snap).each(function(){var H=A(this);var G=H.offset();if(this!=C.element[0]){C.snapElements.push({item:this,width:H.outerWidth(),height:H.outerHeight(),top:G.top,left:G.left})}})},drag:function(O,L){var F=A(this).data("draggable"),M=F.options;var S=M.snapTolerance;var R=L.offset.left,Q=R+F.helperProportions.width,E=L.offset.top,D=E+F.helperProportions.height;for(var P=F.snapElements.length-1;P>=0;P--){var N=F.snapElements[P].left,K=N+F.snapElements[P].width,J=F.snapElements[P].top,U=J+F.snapElements[P].height;if(!((N-S<R&&R<K+S&&J-S<E&&E<U+S)||(N-S<R&&R<K+S&&J-S<D&&D<U+S)||(N-S<Q&&Q<K+S&&J-S<E&&E<U+S)||(N-S<Q&&Q<K+S&&J-S<D&&D<U+S))){if(F.snapElements[P].snapping){(F.options.snap.release&&F.options.snap.release.call(F.element,O,A.extend(F._uiHash(),{snapItem:F.snapElements[P].item})))}F.snapElements[P].snapping=false;continue}if(M.snapMode!="inner"){var C=Math.abs(J-D)<=S;var T=Math.abs(U-E)<=S;var H=Math.abs(N-Q)<=S;var I=Math.abs(K-R)<=S;if(C){L.position.top=F._convertPositionTo("relative",{top:J-F.helperProportions.height,left:0}).top-F.margins.top}if(T){L.position.top=F._convertPositionTo("relative",{top:U,left:0}).top-F.margins.top}if(H){L.position.left=F._convertPositionTo("relative",{top:0,left:N-F.helperProportions.width}).left-F.margins.left}if(I){L.position.left=F._convertPositionTo("relative",{top:0,left:K}).left-F.margins.left}}var G=(C||T||H||I);if(M.snapMode!="outer"){var C=Math.abs(J-E)<=S;var T=Math.abs(U-D)<=S;var H=Math.abs(N-R)<=S;var I=Math.abs(K-Q)<=S;if(C){L.position.top=F._convertPositionTo("relative",{top:J,left:0}).top-F.margins.top}if(T){L.position.top=F._convertPositionTo("relative",{top:U-F.helperProportions.height,left:0}).top-F.margins.top}if(H){L.position.left=F._convertPositionTo("relative",{top:0,left:N}).left-F.margins.left}if(I){L.position.left=F._convertPositionTo("relative",{top:0,left:K-F.helperProportions.width}).left-F.margins.left}}if(!F.snapElements[P].snapping&&(C||T||H||I||G)){(F.options.snap.snap&&F.options.snap.snap.call(F.element,O,A.extend(F._uiHash(),{snapItem:F.snapElements[P].item})))}F.snapElements[P].snapping=(C||T||H||I||G)}}});A.ui.plugin.add("draggable","stack",{start:function(D,E){var G=A(this).data("draggable").options;var F=A.makeArray(A(G.stack)).sort(function(I,H){return(parseInt(A(I).css("zIndex"),10)||0)-(parseInt(A(H).css("zIndex"),10)||0)});if(!F.length){return }var C=parseInt(F[0].style.zIndex)||0;A(F).each(function(H){this.style.zIndex=C+H});this[0].style.zIndex=C+F.length}});A.ui.plugin.add("draggable","zIndex",{start:function(D,E){var C=A(E.helper),F=A(this).data("draggable").options;if(C.css("zIndex")){F._zIndex=C.css("zIndex")}C.css("zIndex",F.zIndex)},stop:function(C,D){var E=A(this).data("draggable").options;if(E._zIndex){A(D.helper).css("zIndex",E._zIndex)}}})})(jQuery);
/*
 * jQuery resize event - v1.1 - 3/14/2010
 * http://benalman.com/projects/jquery-resize-plugin/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */
(function($,H,C){var A=$([]),E=$.resize=$.extend($.resize,{}),I,K="setTimeout",J="resize",D=J+"-special-event",B="delay",F="throttleWindow";E[B]=250;E[F]=true;$.event.special[J]={setup:function(){if(!E[F]&&this[K]){return false}var L=$(this);A=A.add(L);$.data(this,D,{w:L.width(),h:L.height()});if(A.length===1){G()}},teardown:function(){if(!E[F]&&this[K]){return false}var L=$(this);A=A.not(L);L.removeData(D);if(!A.length){clearTimeout(I)}},add:function(L){if(!E[F]&&this[K]){return false}var N;function M(S,O,P){var Q=$(this),R=$.data(this,D);R.w=O!==C?O:Q.width();R.h=P!==C?P:Q.height();N.apply(this,arguments)}if($.isFunction(L)){N=L;return M}else{N=L.handler;L.handler=M}}};function G(){I=H[K](function(){A.each(function(){var N=$(this),M=N.width(),L=N.height(),O=$.data(this,D);if(M!==O.w||L!==O.h){N.trigger(J,[O.w=M,O.h=L])}});G()},E[B])}})(jQuery,this);
function setDialogFocusDom(F){try{var E=document.getElementById(F);if(E){var B=E.contentWindow;var D=B.document.getElementsByTagName("body")[0];var A=D.style.display;if(A==""||A=="block"){D.focus()}}}catch(C){}}function MxtDialog(C){this.id=C.id?C.id:Math.floor(Math.random()*100000000);this.title=C.title?C.title:"Dialog";this.html=C.html?C.html:"";this.url=C.url?C.url:"";this.width=C.width?parseInt(C.width):400;this.height=C.height?parseInt(C.height):350;this.buttons=C.buttons?C.buttons:[];this.isDrag=C.isDrag==undefined?true:C.isDrag;this.showMask=C.showMask==undefined?false:C.showMask;this.borderSize=1;this.shadow=C.shadow==undefined?true:false;this.checkMax=C.checkMax==undefined?true:C.checkMax;this.closeTitle=C.closeTitle?C.closeTitle:$.i18n("common.button.close.label");this.minTitle=C.minTitle?C.minTitle:"min";this.maxTitle=C.maxTitle?C.maxTitle:"max";this.autoTitle=C.autoTitle?C.autoTitle:"auto";this.isClear=false;this.headerHeight=32;this.footerHeight=44;this.isFrountEvent=C.isFrountEvent?C.isFrountEvent:false;this.targetWindow=C.targetWindow==null?window:C.targetWindow;this.isHead=C.isHead==undefined?true:C.isHead;this.minParam=C.minParam;this.maxParam=C.maxParam;this.closeParam=C.closeParam;this.panelParam=C.panelParam;this.bottomHTML=C.bottomHTML;this.overflow=C.overflow==undefined?"auto":C.overflow;this.formSubmitBtn=C.formSubmitBtn?C.formSubmitBtn:false;this.w_space=C.w_space?C.w_space:0;this.ifMax();if(this.minParam==undefined){this.minParam={show:false,handler:function(){}}}if(this.maxParam==undefined){this.maxParam={show:false,handler:function(){}}}if(this.closeParam==undefined){this.closeParam={show:true,handler:function(){}}}this.left=C.left;this.top=C.top;this.type=C.type==null?"dialog":"panel";this.targetId=C.targetId;this.htmlId=C.htmlId;this.htmlObj=null;this.buttonAlign=C.buttonAlign?C.buttonAlign:"align_right";this.transParamsCopy=null;this.emphasizeIndex=0;this.zIndex=1000;this.transParams=C.transParams;this.isFromModle=C.isFromModle==undefined?false:C.isFromModle;this.isFormItem=C.isFormItem?C.isFormItem:false;this.isHide=C.isHide==undefined?false:C.isHide;this._zoomParam=1;if(this._zoomParam==null||this._zoomParam==undefined){this._zooParam=1}if($("#"+this.id,this.targetWindow.document).size()>0){var D=document.body.clientWidth;var F=(document.documentElement.scrollHeight>document.documentElement.clientHeight?document.documentElement.scrollHeight:document.documentElement.clientHeight);if(this.targetId!=null){var A=document.getElementById(this.targetId);var B=A.getBoundingClientRect().left;if((B+this.width)>D){B=B+A.clientWidth-this.width;shadowLeft="left:-3px;"}this.left=B;var E=document.documentElement.scrollTop;if($.browser.chrome){E=$("body").scrollTop()}this.top=A.getBoundingClientRect().top+A.offsetHeight+E;this.left=(this.left+this.width)<D?this.left:(this.left-this.width-A.offsetWidth);this.top=(this.top+this.height)<F?this.top:(this.top-this.height-A.offsetHeight<0?0:this.top-this.height-A.offsetHeight)}else{this.left=(this.left+this.width)<D?(this.left+this.w_space):(this.left-this.width-C.w_space);this.top=(this.top+this.height)<F?this.top:(this.top-this.height<0?0:this.top-this.height);if(this.left<0){this.left=0}}this.targetWindow.$("#"+this.id).css({left:this.left,top:this.top});this.showDialog();return }if(this.type=="dialog"){if(typeof ($("#"+this.id)[0])=="undefined"){this.getDialog();this.drag()}else{if(typeof ($("#"+this.id+"_min")[0])!="undefined"){$("#"+this.id+"_auto_min").click()}}}else{this.getPanel()}var G=this;this.targetWindow.$(document).bind("keyup",function(J){if($("#"+G.id)){if(J.keyCode==27){G.close()}}var I=J.target;var H=J.target.tagName.toUpperCase();if(J.keyCode==8){if((H=="INPUT"&&!$(I).attr("readonly"))||(H=="TEXTAREA"&&!$(I).attr("readonly"))||(H=="DIV"&&$(I).attr("contenteditable")=="true")){if(I.type){if((I.type.toUpperCase()=="RADIO")||(I.type.toUpperCase()=="CHECKBOX")){return false}else{return true}}}else{return false}}});this.officeAction(false)}MxtDialog.prototype.getPanel=function(){var maskId=this.id+"_mask";var _client_width=document.body.clientWidth;var _client_height=(document.documentElement.scrollHeight>document.documentElement.clientHeight?document.documentElement.scrollHeight:document.documentElement.clientHeight);try{var masks=this.targetWindow.$(".mask,.shield,.projectTask_detailDialog_box,.mxt-window");if(masks.size()>0){this.zIndex=parseInt(masks.eq(0).css("z-index"));this.zIndex=this.zIndex+5}}catch(e){}if(this.showMask&&typeof ($("#"+maskId)[0])=="undefined"){this.targetWindow.$("body").prepend("<div id='"+maskId+"' class='mask' style='width:100%;height:"+_client_height+"px;z-index:"+this.zIndex+"'>&nbsp;</div>")}if(typeof ($("#"+this.id)[0])!="undefined"){return }var htmlStr="";var _left=(_client_width-(this.width+this.borderSize*2+5))/2;var _top=(document.documentElement.clientHeight-(this.height+this.borderSize*2+15+5))/2;if(this.left==null){this.left=_left}if(this.top==null){this.top=_top}var shadowLeft="";if(this.targetId!=null){var tarobj=document.getElementById(this.targetId);var leftTemp=tarobj.getBoundingClientRect().left;if((leftTemp+this.width)>_client_width){leftTemp=leftTemp+tarobj.clientWidth-this.width}this.left=leftTemp;this.top=tarobj.getBoundingClientRect().top+tarobj.offsetHeight+document.documentElement.scrollTop;this.left=this.left+this.width<_client_width?this.left:this.left-this.width-tarobj.offsetWidth;this.top=this.top+this.height<_client_height?this.top:(this.top-this.height-tarobj.offsetHeight<0?0:this.top-this.height-tarobj.offsetHeight)}else{this.left=this.left+this.width<_client_width?this.left+this.w_space:this.left-this.width-this.w_space;this.top=this.top+this.height<_client_height?this.top:(this.top-this.height<0?0:this.top-this.height)}var closeHeight=15;var margins=this.borderSize*2;if(this.panelParam!=undefined&&!this.panelParam.show){closeHeight=0}if(this.panelParam!=undefined&&!this.panelParam.margins){margins=0}htmlStr+="<div id='"+this.id+"' class='dialog_box absolute' style='z-index:"+(this.zIndex+1)+";left:"+(parseInt(this.left<0?0:this.left)+document.documentElement.scrollLeft)+"px;top:"+(parseInt(this.top<0?0:this.top))+"px;'>";if(this.shadow){htmlStr+="<div id='"+this.id+"_shadow' class='dialog_shadow absolute' style='"+shadowLeft+"width:"+(this.width+this.borderSize*2)+"px;height:"+(this.height+margins+closeHeight)+"px;'>&nbsp;</div>"}htmlStr+="<iframe id='"+this.id+"_iframe_shadow' class='absolute' style='"+shadowLeft+"width:"+this.width+"px;height:"+(this.height+margins)+"px;border:0'></iframe>";htmlStr+="<div id='"+this.id+"_main' class='dialog_main absolute' style='width:"+this.width+"px'>";htmlStr+="<div id='"+this.id+"_main_head' >";htmlStr+="</div>";htmlStr+="<div id='"+this.id+"_main_body' class='dialog_main_body left' style='width:"+this.width+"px;height:"+this.height+"px;'>";htmlStr+="<div id='"+this.id+"_main_iframe' class='dialog_main_iframe absolute' style='top:"+this.headerHeight+"px;width:"+this.width+"px;height:"+this.height+"px;display:none;'>&nbsp;</div>";htmlStr+="<div id='"+this.id+"_main_content' class='dialog_main_content absolute'>";if(this.url!=""){htmlStr+="<iframe id='"+this.id+"_main_iframe_content' name='"+this.id+"_main_iframe' class='dialog_main_content_html "+(margins==0?"":" ")+"' src='"+this.url+"' scrolling='no' frameborder='0' width='"+(this.width-(margins==0?0:22))+"' height='"+(this.height-(margins==0?0:22))+"' />"}else{htmlStr+="<div id='"+this.id+"_main_iframe_div' class='dialog_main_content_html "+(margins==0?"":" ")+"' style='width:"+(this.width-(margins==0?0:22))+"px;height:"+(this.height-(margins==0?0:22))+"px;border-width:"+(margins==0?0:1)+"px;background:#fff;'>"+(this.htmlId==undefined?this.html:"")+"</div>"}htmlStr+="</div>";htmlStr+="</div>";if(this.buttons.length>0){htmlStr+="<div id='"+this.id+"_main_footer' class='dialog_main_footer left padding_t_5 w100b'>";htmlStr+="<div class='left over_hidden margin_l_5 padding_t_5 padding_b_5'  style='font-size:12px;'>";if(this.bottomHTML!=undefined){htmlStr+=this.bottomHTML}htmlStr+="</div>";htmlStr+="<div class='right "+this.buttonAlign+"' >";if(this.buttons.length>0){for(var i=0;i<this.buttons.length;i++){var jsonTemp=this.buttons[i];if(jsonTemp.id==undefined){jsonTemp.id=Math.floor(Math.random()*100000000)+"_btn"}if(!this.isFrountEvent){if(jsonTemp.id=="btnok"){$.hotkeys.returnKeys.push(jsonTemp.id+this.id)}if(jsonTemp.id=="btncancel"){$.hotkeys.cancelKeys.push(jsonTemp.id+this.id)}htmlStr+="<a id='"+jsonTemp.id+this.id+"' class='common_button "+(jsonTemp.disabled?"common_button_disable":"common_button_gray")+" margin_r_10' style='cursor:pointer;display:"+(jsonTemp.hide?"none":"")+"'>"+jsonTemp.text+"</a>"}}}htmlStr+="</div>";htmlStr+="</div>"}htmlStr+="</div>";htmlStr+="</div>";this.targetWindow.$("body").prepend(htmlStr);var temp=$("#"+this.id+"_main_iframe_content",this.targetWindow.document);if(temp.size()>0&&temp[0].contentWindow){try{if(temp[0].contentWindow.parentDialogObj==undefined){temp[0].contentWindow.parentDialogObj=new Object()}eval("temp[0].contentWindow.parentDialogObj['"+this.id+"'] = this;")}catch(e){}}if(this.htmlId!=null){this.htmlObj=$("#"+this.htmlId).clone(true);$("#"+this.htmlId).after('<div id="'+this.htmlId+'_area"></div>');this.targetWindow.$("#"+this.id+"_main_iframe_div").append($("#"+this.htmlId).show())}var self=this;if(this.panelParam==undefined||this.panelParam.show){if(this.panelParam&&this.panelParam.inside){$("#"+this.id+"_main_head",this.targetWindow.document).css({position:"absolute","z-index":"9999",right:5})}$("<span id='"+this.id+"_close' class='dialog_close right margin_t_0' title='"+this.closeTitle+"'></span>").click(function(){self.close()}).appendTo($("#"+this.id+"_main_head",this.targetWindow.document))}if(this.buttons.length>0){for(var i=0;i<this.buttons.length;i++){var jsonTemp=this.buttons[i];if(!this.isFrountEvent){if(jsonTemp.disabled){continue}else{this.targetWindow.$("#"+jsonTemp.id+this.id).click(jsonTemp.handler).click(function(){self.close()})}}}this.targetWindow.$("#"+this.buttons[0].id+this.id).focus()}else{this.targetWindow.$("#"+this.id).focus()}};MxtDialog.prototype.getDialog=function(){var maskId=this.id+"_mask";var _client_width=(this.targetWindow.document.documentElement.scrollWidth>this.targetWindow.document.documentElement.clientWidth?this.targetWindow.document.documentElement.scrollWidth:this.targetWindow.document.documentElement.clientWidth);var _client_height=(this.targetWindow.document.documentElement.scrollHeight>this.targetWindow.document.documentElement.clientHeight?this.targetWindow.document.documentElement.scrollHeight:this.targetWindow.document.documentElement.clientHeight);try{var masks=this.targetWindow.$(".mask,.shield,.projectTask_detailDialog_box,.mxt-window");if(masks.size()>0){this.zIndex=parseInt(masks.eq(0).css("z-index"));this.zIndex=this.zIndex+5}}catch(e){}if(typeof ($("#"+maskId)[0])=="undefined"){this.targetWindow.$("body").prepend("<div id='"+maskId+"' class='mask' style='width:100%;height:"+_client_height+"px;z-index:"+this.zIndex+";zoom:"+(this._zoomParam==null?1:this._zoomParam)+"'>&nbsp;</div>")}if(typeof ($("#"+this.id)[0])!="undefined"){return }var htmlStr="";var _left=(_client_width-(this.width+this.borderSize*2+5))/2;var _top=(this.targetWindow.document.documentElement.clientHeight-(this.height+this.borderSize*2+this.headerHeight+this.footerHeight+5))/2;if(this.left==undefined){this.left=_left}if(this.top==undefined){this.top=_top}htmlStr+="<div id='"+this.id+"' class='dialog_box absolute' style='z-index:"+(this.zIndex+1)+";left:"+((this.left<0?0:this.left)+this.targetWindow.document.documentElement.scrollLeft)+"px;top:"+((this.top<0?0:this.top)+this.targetWindow.document.documentElement.scrollTop)+"px;zoom:"+(this._zoomParam==null?1:this._zoomParam)+";'>";if(this.shadow){htmlStr+="<div id='"+this.id+"_shadow' class='dialog_shadow absolute' style='top:0px;left:0px;width:"+(this.width+this.borderSize)+"px;height:"+(this.height+this.borderSize+this.headerHeight+(this.buttons.length>0?this.footerHeight:0))+"px;'>&nbsp;</div>"}htmlStr+="<iframe id='"+this.id+"_iframe_shadow' class='absolute' style='width:"+this.width+"px;height:"+(this.height+this.headerHeight+(this.buttons.length>0?this.footerHeight:0))+"px;border:0'></iframe>";htmlStr+="<div id='"+this.id+"_main' class='dialog_main absolute' style='width:"+this.width+"px;border:0px;'>";if(this.isHead){htmlStr+="<div id='"+this.id+"_main_head' class='dialog_main_head' style='height:"+this.headerHeight+"px'>";htmlStr+="<span id='"+this.id+"_title' class='dialog_title left' style='width:"+(this.width-100)+"px;  white-space: nowrap;overflow: hidden;text-overflow: ellipsis;color:#fff;'>"+this.title+"</span>";if(this.closeParam&&this.closeParam.show){htmlStr+="<span id='"+this.id+"_close' class='dialog_close right' title='"+this.closeTitle+"'></span>"}if(this.maxParam&&this.maxParam.show){htmlStr+="<span id='"+this.id+"_max' class='dialog_max right' title='"+this.maxTitle+"'></span>"}if(this.minParam&&this.minParam.show){htmlStr+="<span id='"+this.id+"_min' class='dialog_min right' title='"+this.minTitle+"'></span>"}htmlStr+="</div>"}htmlStr+="<div id='"+this.id+"_main_body' class='dialog_main_body left' style='width:"+this.width+"px;height:"+this.height+"px'>";htmlStr+="<div id='"+this.id+"_main_iframe' class='dialog_main_iframe absolute' style='left:5px;top:"+(this.headerHeight+5)+"px;width:"+(this.width-10)+"px;height:"+(this.height-10)+"px;display:none;'>&nbsp;</div>";var ua=navigator.userAgent;if(ua.indexOf("Android")>-1||ua.indexOf("iPhone")>-1){htmlStr+="<div id='"+this.id+"_main_content' class='dialog_main_content absolute' style='display:inline-block;height:80%; width:100%;-webkit-overflow-scrolling: touch;overflow: scroll;'>"}else{htmlStr+="<div id='"+this.id+"_main_content' class='dialog_main_content absolute'>"}if(this.url!=""){htmlStr+="<iframe id='"+this.id+"_main_iframe_content' name='"+this.id+"_main_iframe' class='dialog_main_content_html ' src='"+this.url+"' scrolling='auto' frameborder='0' width='"+(this.width)+"' height='"+(this.height)+"' />"}else{htmlStr+="<div id='"+this.id+"_main_iframe_div' class='dialog_main_content_html  ' style='width:"+(this.width)+"px;height:"+(this.height)+"px;overflow:"+this.overflow+";'>"+(this.htmlId==undefined?this.html:"")+"</div>"}htmlStr+="</div>";htmlStr+="</div>";if(this.buttons.length>0){htmlStr+="<div id='"+this.id+"_main_footer' class='dialog_main_footer left padding_t_5 w100b' style='background:#4d4d4d;color:#fff;height:"+this.footerHeight+"px;'>";htmlStr+="<div class='left over_hidden margin_l_5 padding_t_5 padding_b_5'  style='font-size:12px;margin-top:7px;'>";if(this.bottomHTML!=undefined){htmlStr+=this.bottomHTML}htmlStr+="</div>";htmlStr+="<div class='right "+this.buttonAlign+"' style='margin-top:4px;'>";if(this.buttons.length>0){for(var j=0;j<this.buttons.length;j++){var jsonTemp=this.buttons[j];if(jsonTemp.isEmphasize==true){this.buttons[j].btnType=1}}for(var i=0;i<this.buttons.length;i++){var jsonTemp=this.buttons[i];if(jsonTemp.id==undefined){jsonTemp.id=Math.floor(Math.random()*100000000)+"_btn"}if(!this.isFrountEvent){if(jsonTemp.id=="btnok"){$.hotkeys.returnKeys.push(jsonTemp.id+this.id)}if(jsonTemp.id=="btncancel"){$.hotkeys.cancelKeys.push(jsonTemp.id+this.id)}if(jsonTemp.btnType==1){htmlStr+="<a id='"+jsonTemp.id+this.id+"' class='common_button "+(jsonTemp.disabled?"common_button_disable":"common_button_emphasize")+" margin_r_10' style='cursor:pointer;display:"+(jsonTemp.hide?"none":"")+"'>"+jsonTemp.text+"</a>"}else{htmlStr+="<a id='"+jsonTemp.id+this.id+"' class='common_button "+(jsonTemp.disabled?"common_button_disable":"common_button_gray")+" margin_r_10' style='cursor:pointer;display:"+(jsonTemp.hide?"none":"")+"'>"+jsonTemp.text+"</a>"}}}}htmlStr+="</div>";htmlStr+="</div>"}htmlStr+="</div>";htmlStr+="</div>";this.targetWindow.$("body").prepend(htmlStr);var temp=$("#"+this.id+"_main_iframe_content",this.targetWindow.document);if(temp.size()>0&&temp[0].contentWindow){try{if(temp[0].contentWindow.parentDialogObj==undefined){temp[0].contentWindow.parentDialogObj=new Object()}eval("temp[0].contentWindow.parentDialogObj['"+this.id+"'] = this;")}catch(e){}}if(temp.size()>0&&this.transParams!=undefined){try{if(!this.isFromModle){this.transParamsCopy=this.transParams;temp[0].contentWindow.dialogArguments=this.transParams;temp[0].contentWindow.transParams=this.transParams}else{this.transParamsCopy=this.transParams;temp[0].contentWindow.transParams=this.transParams}}catch(e){this.transParamsCopy=this.transParams;temp[0].contentWindow.transParams=this.transParams}}if(this.htmlId!=null){this.htmlObj=$("#"+this.htmlId).clone(true);$("#"+this.htmlId).after('<div id="'+this.htmlId+'_area"></div>');this.targetWindow.$("#"+this.id+"_main_iframe_div").append($("#"+this.htmlId).show())}var self=this;if(this.closeParam&&this.closeParam.show){if(this.closeParam.autoClose==false){this.targetWindow.$("#"+this.id+"_close").click(this.closeParam.handler)}else{this.targetWindow.$("#"+this.id+"_close").click(this.closeParam.handler).click(function(){self.close()})}}if(this.maxParam&&this.maxParam.show){this.targetWindow.$("#"+this.id+"_max").click(function(){self.maxfn()}).click(this.maxParam.handler)}if(this.minParam&&this.minParam.show){this.targetWindow.$("#"+this.id+"_min").click(function(){self.minfn()}).click(this.minParam.handler)}if(this.buttons.length>0){for(var i=0;i<this.buttons.length;i++){var jsonTemp=this.buttons[i];if(!this.isFrountEvent){if(jsonTemp.disabled){continue}else{this.targetWindow.$("#"+jsonTemp.id+this.id).click(jsonTemp.handler)}}}this.targetWindow.$("#"+this.buttons[0].id+this.id).parent().focus()}else{this.targetWindow.$("#"+this.id).parent().focus()}$(window).scroll(function(){var _client_width2=document.documentElement.scrollWidth;var _client_height2=document.documentElement.scrollHeight;$(".mask").css({width:_client_width2,height:_client_height2})})};MxtDialog.prototype.setBtnEmphasize=function(A){this.targetWindow.$(".common_button_emphasize").removeClass("common_button_emphasize").addClass("common_button_gray");this.targetWindow.$("#"+A+this.id).removeClass("common_button_gray").addClass("common_button_emphasize")};MxtDialog.prototype.getBtn=function(C){for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];if(A.id==C){return this.targetWindow.$("#"+A.id+this.id)}}return null};MxtDialog.prototype.hideBtn=function(C){for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];if(A.id==C){this.targetWindow.$("#"+A.id+this.id).hide()}}};MxtDialog.prototype.showBtn=function(E){for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];if(A.id==E){var C=this.targetWindow.$("#"+A.id+this.id).show();var D="";if(A.btnType!=undefined){switch(A.btnType*1){case 0:D="common_button_gray";break;case 1:D="common_button_emphasize";break}C.removeClass("common_button_disable common_button_gray common_button_emphasize").addClass(D)}return C}}};MxtDialog.prototype.enabledBtn=function(E){for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];if(A.id==E){var C=this.targetWindow.$("#"+A.id+this.id).show();var D;switch(C.attr("btnType")){case"0":D="common_button_gray";break;case"1":D="common_button_emphasize";break}C.removeClass("common_button_disable").addClass(D).unbind("click").click(A.handler)}}};MxtDialog.prototype.disabledBtn=function(D){for(var B=0;B<this.buttons.length;B++){var A=this.buttons[B];if(A.id==D){var C=this.targetWindow.$("#"+A.id+this.id).show();if(C.hasClass("common_button_gray")){C.attr("btnType","0")}else{C.attr("btnType","1")}C.removeClass("common_button_gray common_button_emphasize").addClass("common_button_disable").unbind("click")}}};MxtDialog.prototype.drag=function(){if(this.isDrag){var B=this.targetWindow.$("#"+this.id);var A=this.targetWindow.$("#"+this.id+"_main_head");this.targetWindow.$("#"+this.id).draggable({cancel:".dialog_main_body,.dialog_main_content_html,.dialog_main_footer",handle:".dialog_main_head",containment:"body",scroll:false,delay:150,distance:10,iframeFix:true})}};MxtDialog.prototype.close=function(J){try{this.targetWindow.$("#"+this.id+"_main_iframe_content")[0].contentWindow.document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("officeEditorFrame").contentWindow.pdfOcxUnLoad()}catch(H){}try{this.targetWindow.$("#"+this.id+"_main_iframe_content")[0].contentWindow.document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("officeEditorFrame").contentWindow.OcxUnLoad()}catch(H){}if(this.isHide){this.hideDialog();return }var G=this.isFormItem;var A=false;var J=J;J?null:J=[];if(J.isFormItem!=undefined){G=J.isFormItem}if(this.htmlId!=undefined){if(G){var I=this.targetWindow.$("#"+this.htmlId).find("select");if(I.size()>0){A=true;var C=[];I.each(function(){C.push($(this).find("option:selected").val())})}this.htmlObj=this.targetWindow.$("#"+this.htmlId).clone(true)}if(this.htmlObj!=null){this.htmlObj.hide()}$("#"+this.htmlId+"_area").after(this.htmlObj);$("#"+this.htmlId+"_area").remove()}var D=this.targetWindow.$("#"+this.id+"_mask");setTimeout(function(){D.remove()},10);try{if(this.isClear){var F=this.targetWindow.$("#"+this.id+"_main_iframe_content");if(F.size()>0){F[0].contentWindow.document.write("");var E=F[0];F.contents().find("body").empty();$(E.document).find("*").unbind().die();E.src="about:blank";E.contentWindow.document.write("");E.contentWindow.close();$.gc();if(F[0].contentWindow.location.href!=window.location.href){if(getCtpTop().dialogArguments==undefined||getCtpTop().dialogArguments==null){F[0].contentWindow.close()}}setTimeout(function(){F.remove()},10)}}else{this.targetWindow.$("#"+this.id+"_main_iframe_content").attr("src","")}}catch(H){this.targetWindow.$("#"+this.id+"_main_iframe_content").attr("src","")}var B=this.targetWindow.$("#"+this.id);setTimeout(function(){B.remove()},10);this.officeAction(true);if(A){$("#"+this.htmlId+" select").each(function(K){var L=$(this);$(this).find("option").each(function(M){if($(this).val()==C[K]){L.find("option").eq(M).attr("selected","selected")}})})}if(J.handler!=undefined){J.handler()}};MxtDialog.prototype.officeAction=function(B){var E=["officeFrameDiv","zwIframe","mainbodyFrame"];var A=window;if($("#componentDiv").size()>0){try{A=$("#componentDiv")[0].contentWindow.$("#zwIframe")[0].contentWindow}catch(F){}}for(var C=0;C<E.length;C++){var D=E[C];var G=A.$("#"+D);if(G.size()>0){this.officeIframe=G;break}}this.qianzhangIframe=$("[classid='clsid:2294689C-9EDF-40BC-86AE-0438112CA439']");DialogOfficeObj.qianzhangIframe=this.qianzhangIframe;DialogOfficeObj.officeIframe=this.officeIframe;if(!B){DialogOfficeObj.hideOfficeObj()}else{DialogOfficeObj.showOfficeObj()}};var DialogOfficeObj={officeIframe:{size:function(){return 0}},qianzhangIframe:{size:function(){return 0}},hideOfficeObjExt:function(){try{var B=getA8Top();var A=B.isOffice;if((typeof A=="undefined")||(A==false)){return false}if(DialogOfficeObj.officeIframe&&DialogOfficeObj.officeIframe.size()>0){DialogOfficeObj.officeIframe.css({visibility:"hidden"})}if(DialogOfficeObj.qianzhangIframe.size()>0){DialogOfficeObj.qianzhangIframe.css({visibility:"hidden"})}}catch(C){}return true},showOfficeObjExt:function(){try{var B=getA8Top();var A=B.isOffice;if((typeof A=="undefined")||(A==false)){return false}if(DialogOfficeObj.officeIframe&&DialogOfficeObj.officeIframe.size()>0){DialogOfficeObj.officeIframe.css({visibility:"visible"})}if(DialogOfficeObj.qianzhangIframe.size()>0){DialogOfficeObj.qianzhangIframe.css({visibility:"visible"})}}catch(C){}return true},hideOfficeObj:function(){var B=navigator.userAgent.toLowerCase();var A=(B.indexOf("opera")!=-1);var C=(B.indexOf("msie")!=-1&&!A);if(C){if(!DialogOfficeObj.hideOfficeObjExt()){return }}if(window.hideOfficeObj){hideOfficeObj()}},showOfficeObj:function(){var B=navigator.userAgent.toLowerCase();var A=(B.indexOf("opera")!=-1);var C=(B.indexOf("msie")!=-1&&!A);if(C){if(!DialogOfficeObj.showOfficeObjExt()){return }}if(window.showOfficeObj){showOfficeObj()}}};MxtDialog.prototype.closeMin=function(){var B=this.targetWindow.$("#"+this.id+"_mask");setTimeout(function(){B.remove()},10);var A=this.targetWindow.$("#"+this.id+"_main_iframe_content");setTimeout(function(){A.attr("src","")},10);var E=this.targetWindow.$("#"+this.id);setTimeout(function(){E.remove()},10);var C=this.targetWindow.$("#"+this.id+"_div_min");setTimeout(function(){C.remove()},10);var F=this.targetWindow.$("#min-divs .dialog_box_min");if(F.length==0){var D=this.targetWindow.$("#min-divs");setTimeout(function(){D.remove()},10)}};MxtDialog.prototype.minfn=function(){this.targetWindow.$("#"+this.id).hide();this.targetWindow.$("#"+this.id+"_mask").hide();var D="";var C=this.targetWindow.$("#min-divs");var B=0;if(C.length<=0){D+="<div id='min-divs' class='absolute' style='left:10px;bottom:33px;z-index:"+(this.zIndex+1)+";'>"}else{B=C.children().length}D+="<div id='"+this.id+"_div_min' class='dialog_box_min absolute' style='left:"+B*150+"px'>";D+="<div id='"+this.id+"_main_min' class='dialog_main absolute' style='width:150px'>";D+="<div id='"+this.id+"_main_head_min' class='dialog_main_head'>";D+="<span id='"+this.id+"_title_min' class='dialog_title left' style='width:50px;  white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"+this.title+"</span>";D+="<span id='"+this.id+"_close_min' class='dialog_close right' title='"+this.closeTitle+"'></span>";if(this.maxParam){D+="<span id='"+this.id+"_auto_min' class='dialog_auto right' title='"+this.autoTitle+"'></span>"}D+="</div>";D+="</div>";D+="</div>";if(C.length<=0){D+="</div>";this.targetWindow.$("body").prepend(D)}else{C.append(D)}var A=this;this.targetWindow.$("#"+this.id+"_close_min").click(function(){A.closeMin()});if(this.maxParam){this.targetWindow.$("#"+this.id+"_auto_min").click(function(){A.autoMinfn()})}};MxtDialog.prototype.ifMax=function(){if(this.checkMax==false){return }var A=this.targetWindow.document.body.clientWidth-40;var C=this.targetWindow.document.documentElement.clientHeight-80;var D=this.width;var B=this.height;this.width=D>A?A:D;this.height=B>C?C:B;if(this.width<=0){this.width=D}if(this.height<=0){this.height=B}};MxtDialog.prototype.maxfn=function(){var B=this.targetWindow.$(window).width();var C=this.targetWindow.document.documentElement.clientHeight-(this.isHead?70:40);this.targetWindow.$("#"+this.id+"_main").width(B);this.targetWindow.$("#"+this.id+"_shadow").width(B+this.borderSize*2).height(C+this.borderSize*2+this.headerHeight+this.footerHeight);this.targetWindow.$("#"+this.id+"_main_body").width(B).height(C);this.targetWindow.$("#"+this.id+"_main_iframe").width(B).height(C);if(this.url!=""){this.targetWindow.$("#"+this.id+"_main_iframe_content").css({width:(B-22)+"px",height:(C-22)+"px"})}else{this.targetWindow.$("#"+this.id+"_main_iframe_div").width(B-22).height(C-22)}this.targetWindow.$("#"+this.id).css({top:"0px",left:"0px"});var A=this;this.targetWindow.$("#"+this.id+"_max").addClass("dialog_auto").unbind("click").click(function(){A.autofn()}).click(this.maxParam.handler)};MxtDialog.prototype.autofn=function(){var B=this.width;var C=this.height;this.targetWindow.$("#"+this.id+"_main").width(B);this.targetWindow.$("#"+this.id+"_shadow").width(B+this.borderSize*2).height(C+this.borderSize*2+this.headerHeight+this.footerHeight);this.targetWindow.$("#"+this.id+"_main_body").width(B).height(C);this.targetWindow.$("#"+this.id+"_main_iframe").width(B).height(C);if(this.url!=""){this.targetWindow.$("#"+this.id+"_main_iframe_content").width(B-22).height(C-22)}else{this.targetWindow.$("#"+this.id+"_main_iframe_div").width(B-22).height(C-22)}this.targetWindow.$("#"+this.id).css({top:this.top+"px",left:this.left+"px"});var A=this;this.targetWindow.$("#"+this.id+"_max").removeClass("dialog_auto").unbind("click").click(function(){A.maxfn()}).click(this.maxParam.handler)};MxtDialog.prototype.removeMinDiv=function(){var A=$("#min-divs");if(A.length>0){if(A.children().length==0){setTimeout(function(){A.remove()},10)}}};MxtDialog.prototype.autoMinfn=function(){var A=this.targetWindow.$("#"+this.id+"_div_min");setTimeout(function(){A.remove()},10);this.targetWindow.$("#"+this.id).show();this.targetWindow.$("#"+this.id+"_mask").show();this.removeMinDiv()};MxtDialog.prototype.reSize=function(C){var B=this.targetWindow.document.body.clientWidth;var E=this.targetWindow.document.body.clientHeight;if(C.cHeight){E=C.cHeight}if(C.cWidth){B=C.cWidth}var A=C.width;var F=C.height;var D=(B-(A+this.borderSize*2+5))/2;var G=(E-(F+this.borderSize*2+15+5))/2;if(G<0){G=0}if(this.buttons.length==0){this.footerHeight=0}if((F+G)>E){F=E-G-30}this.targetWindow.$("#"+this.id+"_main").width(A);this.targetWindow.$("#"+this.id+"_shadow").width(A+this.borderSize*2).height(F+this.borderSize*2+this.headerHeight+this.footerHeight);this.targetWindow.$("#"+this.id+"_main_body").width(A).height(F);this.targetWindow.$("#"+this.id+"_main_iframe").width(A).height(F);this.targetWindow.$("#"+this.id+"_iframe_shadow").width(A).height(F);if(this.url!=""){this.targetWindow.$("#"+this.id+"_main_iframe_content").css({width:A+"px",height:F+"px"})}else{this.targetWindow.$("#"+this.id+"_main_iframe_div").width(A).height(F)}this.targetWindow.$(".dialog_title").width(A-100);if(C.positionFix!=true){this.targetWindow.$("#"+this.id).css({left:D+"px",top:G+"px"})}};MxtDialog.prototype.getReturnValue=function(D){if(D==null){D={}}var F=this.id+"_main_iframe_content";var C=null;var B=this.targetWindow;var E=B.document.getElementById(F);if(E!=null){var A=null;if(E.contentWindow&&typeof (E.contentWindow.OK)=="function"){A=E.contentWindow.OK(D)}else{return null}return A}else{return null}};MxtDialog.prototype.getMin=function(D){if(D==null){D={}}var F=this.id+"_main_iframe_content";var C=null;var B=this.targetWindow;var E=B.document.getElementById(F);if(E!=null){var A=null;if(E.contentWindow){A=E.contentWindow.MIN(D)}else{A=E.MIN(D)}return A}else{return null}};MxtDialog.prototype.getMax=function(D){if(D==null){D={}}var F=this.id+"_main_iframe_content";var C=null;var B=this.targetWindow;var E=B.document.getElementById(F);if(E!=null){var A=null;if(E.contentWindow){A=E.contentWindow.MAX(D)}else{A=E.MAX(D)}return A}else{return null}};MxtDialog.prototype.getClose=function(D){if(D==null){D={}}var F=this.id+"_main_iframe_content";var C=null;var B=this.targetWindow;var E=B.document.getElementById(F);if(E!=null){var A=null;if(E.contentWindow){A=E.contentWindow.CLOSE(D)}else{A=E.CLOSE(D)}return A}else{return null}};MxtDialog.prototype.getWidth=function(){return this.targetWindow.$("#"+this.id+"_main_iframe_content").css("width")};MxtDialog.prototype.getHeight=function(){return this.targetWindow.$("#"+this.id+"_main_iframe_content").css("height")};MxtDialog.prototype.getTransParams=function(){return this.transParamsCopy};MxtDialog.prototype.reloadUrl=function(url){var _url=url;_url?null:_url=this.url;this.targetWindow.$("#"+this.id+"_main_iframe_content").attr("src",_url);var temp=$("#"+this.id+"_main_iframe_content",this.targetWindow.document);if(temp.size()>0&&temp[0].contentWindow){try{if(temp[0].contentWindow.parentDialogObj==undefined){temp[0].contentWindow.parentDialogObj=new Object()}eval("temp[0].contentWindow.parentDialogObj['"+this.id+"'] = this;")}catch(e){}}if(temp.size()>0&&this.transParams!=undefined){try{if(!this.isFromModle){this.transParamsCopy=this.transParams;temp[0].contentWindow.dialogArguments=this.transParams}else{this.transParamsCopy=this.transParams;temp[0].contentWindow.transParams=this.transParams}}catch(e){this.transParamsCopy=this.transParams;temp[0].contentWindow.transParams=this.transParams}}};MxtDialog.prototype.setTitle=function(A){this.targetWindow.$("#"+this.id+"_title").html(A)};MxtDialog.prototype.hideDialog=function(){this.targetWindow.$("#"+this.id+"_main_iframe_content").attr("src","");this.targetWindow.$("#"+this.id+"_mask").hide();this.targetWindow.$("#"+this.id).hide();this.officeAction(true)};MxtDialog.prototype.showDialog=function(){this.targetWindow.$("#"+this.id+"_main_iframe_content").attr("src",this.url);this.targetWindow.$("#"+this.id+"_mask").show();this.targetWindow.$("#"+this.id).show();this.officeAction(false)};MxtDialog.prototype.getObjectById=function(A){return this.targetWindow?this.targetWindow.$("#"+A):null};MxtDialog.prototype.getObjectByClass=function(A){return this.targetWindow?this.targetWindow.$("."+A):null};MxtDialog.prototype.startLoading=function(A){if(this.targetWindow){this.targetWindow.$("#"+this.id+"_main_iframe").show()}};MxtDialog.prototype.endLoading=function(){if(this.targetWindow){this.targetWindow.$("#"+this.id+"_main_iframe").hide()}};function MxtMsgBox(A){this.id=A.id?A.id:Math.floor(Math.random()*100000000);this.title=A.title?A.title:"MessageBox";this.type=A.type?A.type:0;this.msg=A.msg?A.msg:"";this.buttons=A.buttons?A.buttons:[];this.width=A.width?A.width:350;this.height=A.height?A.height:120;this.isDrag=A.isDrag?A.isDrag:true;this.borderSize=1;this.closeTitle=A.closeTitle?A.closeTitle:$.i18n("common.button.close.label");this.submitText=A.submitText?A.submitText:"submit";this.headerHeight=32;this.footerHeight=40;this.imgType=A.imgType==null?null:A.imgType;this.okText=A.okText?A.okText:$.i18n("message.ok.js");this.cancelText=A.cancelText?A.cancelText:$.i18n("message.cancel.js");this.yesText=A.yesText?A.yesText:$.i18n("message.yes.js");this.noText=A.noText?A.noText:$.i18n("message.no.js");this.retryText=A.retryText?A.retryText:$.i18n("message.retry.js");this.detailText=A.detailText?A.detailText:$.i18n("message.detail.js");this.ok_fn=A.ok_fn?A.ok_fn:null;this.cancel_fn=A.cancel_fn?A.cancel_fn:null;this.yes_fn=A.yes_fn?A.yes_fn:null;this.no_fn=A.no_fn?A.no_fn:null;this.retry_fn=A.retry_fn?A.retry_fn:null;this.detail_fn=A.detail_fn?A.detail_fn:null;this.close_fn=A.close_fn?A.close_fn:this.cancel_fn;this.close_show=A.close_show?A.close_show:true;this.zIndex=5000;this.isFrountEvent=A.isFrountEvent?A.isFrountEvent:false;this.targetWindow=A.targetWindow==null?getCtpTop():A.targetWindow;this.bottomHTML=A.bottomHTML;this._zoomParam=1;if(this._zoomParam==null||this._zoomParam==undefined){this._zooParam=1}if(typeof this.targetWindow.$==="undefined"){alert(this.msg);return }this.init();this.drag();var B=this;$(document).keyup(function(C){if($("#"+B.id)){if(C.keyCode==27){B.close()}}})}MxtMsgBox.prototype.init=function(){var E=this.id+"_mask";var G=this.targetWindow.document.body.clientWidth;var B=(this.targetWindow.document.documentElement.scrollHeight>this.targetWindow.document.documentElement.clientHeight?this.targetWindow.document.documentElement.scrollHeight:this.targetWindow.document.documentElement.clientHeight);try{var K=this.targetWindow.$(".mask,.shield,.projectTask_detailDialog_box,.mxt-window");if(K.size()>0){this.zIndex=parseInt(K.eq(0).css("z-index"));this.zIndex=this.zIndex+5}}catch(F){}if(typeof ($("#"+E)[0])=="undefined"){this.targetWindow.$("body").prepend("<div id='"+E+"' class='mask' style='width:"+G+"px;height:"+B+"px;z-index:"+this.zIndex+";zoom:"+(this._zoomParam==null?1:this._zoomParam)+";'>&nbsp;</div>")}if(typeof ($("#"+this.id)[0])!="undefined"){this.targetWindow.$("#"+this.id).remove()}var A="";var J=(G-(this.width+this.borderSize*2+5))/2;var I=(this.targetWindow.document.documentElement.clientHeight-(this.height+this.borderSize*2+this.headerHeight+this.footerHeight+5))/2;if(I<=0){I=($(document.body).height()-(this.height+this.borderSize*2+this.headerHeight+this.footerHeight+5))/2}A+="<div id='"+this.id+"' class='dialog_box absolute' style='z-index:"+(this.zIndex+2)+";left:"+((J<0?0:J)+this.targetWindow.document.documentElement.scrollLeft)+"px;top:"+((I<0?0:I)+(this.targetWindow.document.documentElement.scrollTop==0?this.targetWindow.document.body.scrollTop:this.targetWindow.document.documentElement.scrollTop))+"px;zoom:"+(this._zoomParam==null?1:this._zoomParam)+";'>";A+="<div id='"+this.id+"_shadow' class='dialog_shadow absolute' style='width:"+(this.width+this.borderSize*0)+"px;height:"+(this.height+this.borderSize*0+this.footerHeight)+"px;top:0px;left:0px;'>&nbsp;</div>";A+="<iframe id='"+this.id+"_iframe_shadow' class='absolute' style='width:"+this.width+"px;height:"+(this.height+this.headerHeight+this.footerHeight)+"px;border:0'></iframe>";A+="<div id='"+this.id+"_main' class='dialog_main absolute' style='width:"+this.width+"px;border:0px;background:#fff;'>";A+="<div id='"+this.id+"_main_head' class='dialog_main_head' style='background:#fff;'>";if(this.close_show){}A+="</div>";if(this.close_show){A+="<span id='"+this.id+"_close' class='dialog_close_msg' title='"+this.closeTitle+"'></span>"}A+="<div id='"+this.id+"_main_body' class='dialog_main_body left' style='width:"+this.width+"px;height:"+this.height+"px'>";A+="<div id='"+this.id+"_main_iframe' class='dialog_main_iframe absolute' style='top:"+this.headerHeight+"px;width:"+this.width+"px;height:"+this.height+"px;display:none;'>&nbsp;</div>";A+="<div id='"+this.id+"_main_content' class='dialog_main_content absolute'>";A+="<div class='dialog_main_content_html ' style='width:"+(this.width)+"px;height:"+(this.height)+"px;overflow:auto;border:0px;'>";A+="<table width='90%' class='margin_t_20' style='font-size:12px;'><tr>";if(this.imgType!=null){A+="<td valign='top' width='24' class='padding_l_20'><span class='msgbox_img_"+this.imgType+"'></span>";A+="</td>"}A+="<td class='msgbox_content padding_l_10' style='padding-right:15px;'>";A+=this.msg;A+="</td>";A+="</tr></table>";A+="</div>";A+="</div>";A+="</div>";A+="<div id='"+this.id+"_main_footer' class='dialog_main_footer left align_right padding_t_10 w100b' style='background:#4d4d4d'>";if(this.bottomHTML!=undefined){A+='<span class="left margin_l_10 margin_t_5 font_size12">'+this.bottomHTML+"</span>"}A+='<span class="right">';switch(this.type){case 0:A+="<a  id='ok_msg_btn_first'  class='common_button common_button_emphasize margin_r_10 hand'>"+this.okText+"</a>";break;case 1:A+="<a  id='ok_msg_btn_first'   class='common_button common_button_emphasize margin_r_10 hand'>"+this.okText+"</a>";A+="<a  id='cancel_msg_btn'  class='common_button common_button_gray margin_r_10 hand'>"+this.cancelText+"</a>";break;case 2:A+="<a  id='yes_msg_btn'   class='common_button common_button_emphasize margin_r_10 hand'>"+this.yesText+"</a>";A+="<a  id='no_msg_btn'   class='common_button common_button_gray margin_r_10 hand'>"+this.noText+"</a>";A+="<a  id='cancel_msg_btn'   class='common_button common_button_gray margin_r_10 hand'>"+this.cancelText+"</a>";break;case 3:A+="<a  id='yes_msg_btn'   class='common_button common_button_emphasize margin_r_10 hand'>"+this.yesText+"</a>";A+="<a  id='no_msg_btn'  class='common_button common_button_gray margin_r_10 hand'>"+this.noText+"</a>";break;case 4:A+="<a  id='retry_msg_btn'   class='common_button common_button_emphasize margin_r_10 hand'>"+this.retryText+"</a>";A+="<a  id='cancel_msg_btn'  class='common_button common_button_gray margin_r_10 hand'>"+this.cancelText+"</a>";break;case 5:A+="<a  id='ok_msg_btn_first'  class='common_button common_button_emphasize margin_r_10 hand'>"+this.okText+"</a>";A+="<a  id='detail_msg_btn'   class='common_button common_button_gray margin_r_10 hand'>"+this.detailText+"</a>";break;case 100:if(this.buttons.length>0){for(var D=0;D<this.buttons.length;D++){var C=this.buttons[D];if(D==0){A+="<a  id='"+C.id+"_btn'   class='common_button common_button_emphasize margin_r_10 hand' title='"+C.text+"'>"+C.text+"</a>"}else{A+="<a  id='"+C.id+"_btn'   class='common_button common_button_gray margin_r_10 hand' title='"+C.text+"'>"+C.text+"</a>"}}}break;default:A+="<a  id='ok_msg_btn_first'   class='common_button common_button_gray margin_r_10 hand'>"+this.okText+"</a>"}A+="</span>";A+="</div>";A+="</div>";A+="</div>";this.officeAction(false);this.targetWindow.$("body").prepend(A);var H=this;this.targetWindow.$("#"+this.id+"_close").click(function(){H.close()}).click(this.close_fn);switch(this.type){case 0:if(!this.isFrountEvent){this.targetWindow.$("#ok_msg_btn_first").click(function(){H.close()}).click(this.ok_fn)}else{this.targetWindow.$("#ok_msg_btn_first").click(this.ok_fn).click(function(){H.close()})}break;case 1:if(!this.isFrountEvent){this.targetWindow.$("#ok_msg_btn_first").click(function(){H.close()}).click(this.ok_fn);this.targetWindow.$("#cancel_msg_btn").click(function(){H.close()}).click(this.cancel_fn)}else{this.targetWindow.$("#ok_msg_btn_first").click(this.ok_fn).click(function(){H.close()});this.targetWindow.$("#cancel_msg_btn").click(this.cancel_fn).click(function(){H.close()})}break;case 2:if(!this.isFrountEvent){this.targetWindow.$("#yes_msg_btn").click(function(){H.close()}).click(this.yes_fn);this.targetWindow.$("#no_msg_btn").click(function(){H.close()}).click(this.no_fn);this.targetWindow.$("#cancel_msg_btn").click(function(){H.close()}).click(this.cancel_fn)}else{this.targetWindow.$("#yes_msg_btn").click(this.yes_fn).click(function(){H.close()});this.targetWindow.$("#no_msg_btn").click(this.no_fn).click(function(){H.close()});this.targetWindow.$("#cancel_msg_btn").click(this.cancel_fn).click(function(){H.close()})}break;case 3:if(!this.isFrountEvent){this.targetWindow.$("#yes_msg_btn").click(function(){H.close()}).click(this.yes_fn);this.targetWindow.$("#no_msg_btn").click(function(){H.close()}).click(this.no_fn)}else{this.targetWindow.$("#yes_msg_btn").click(this.yes_fn).click(function(){H.close()});this.targetWindow.$("#no_msg_btn").click(this.no_fn).click(function(){H.close()})}break;case 4:if(!this.isFrountEvent){this.targetWindow.$("#retry_msg_btn").click(function(){H.close()}).click(this.retry_fn);this.targetWindow.$("#cancel_msg_btn").click(function(){H.close()}).click(this.cancel_fn)}else{this.targetWindow.$("#retry_msg_btn").click(this.retry_fn).click(function(){H.close()});this.targetWindow.$("#cancel_msg_btn").click(this.cancel_fn).click(function(){H.close()})}break;case 5:if(!this.isFrountEvent){this.targetWindow.$("#ok_msg_btn_first").click(function(){H.close()}).click(this.ok_fn);this.targetWindow.$("#detail_msg_btn").click(function(){H.close()}).click(this.detail_fn)}else{this.targetWindow.$("#ok_msg_btn_first").click(this.ok_fn).click(function(){H.close()});this.targetWindow.$("#detail_msg_btn").click(this.detail_fn).click(function(){H.close()})}break;case 100:if(this.buttons.length>0){for(var D=0;D<this.buttons.length;D++){var C=this.buttons[D];if(!this.isFrountEvent){this.targetWindow.$("#"+C.id+"_btn").click(function(){H.close()}).click(C.handler)}else{this.targetWindow.$("#"+C.id+"_btn").click(C.handler).click(function(){H.close()})}}}break;default:if(!this.isFrountEvent){this.targetWindow.$("#ok_msg_btn_first").click(function(){H.close()}).click(this.ok_fn)}else{this.targetWindow.$("#ok_msg_btn_first").click(this.ok_fn).click(function(){H.close()})}}if(this.targetWindow.$("#ok_msg_btn_first").size()>0){this.targetWindow.$("#ok_msg_btn_first").parent().focus()}};MxtMsgBox.prototype.drag=function(){if(this.isDrag){var A={cancel:".dialog_main_content_html,.dialog_main_footer",containment:"body",scroll:false};var B=this.targetWindow.$("#"+this.id);if(typeof B.draggable!=="undefined"){B.draggable(A)}else{alert(this.msg)}}};MxtMsgBox.prototype.close=function(){this.targetWindow.$("#"+this.id+"_mask").remove();this.targetWindow.$("#"+this.id).remove();this.officeAction(true)};MxtMsgBox.prototype.officeAction=function(A){if(!A){DialogOfficeObj.hideOfficeObj()}else{DialogOfficeObj.showOfficeObj()}};
function MxtProgressBar(A){if(A==undefined){A={}}this.id=A.id?A.id:Math.floor(Math.random()*100000000);this.text=A.text?A.text:"";this.progress=A.progress?A.progress:"";this.width=A.width?A.width:600;this.height=A.height?A.height:70;this.isMode=A.isMode==undefined?true:A.isMode;this.buttons=A.buttons;if(this.buttons!=null){this.height+=30}this.borderSize=1;this.init();MxtProgressBar.current=this}MxtProgressBar.current=null;MxtProgressBar.createCtpTopBar=function(A){var C=null;try{C=getCtpTop()}catch(B){return null}if(C!=null){C.MxtProgressBar.current=new C.MxtProgressBar(A);return C.MxtProgressBar.current}else{return null}};MxtProgressBar.getCtpTopBar=function(){var B=null;try{B=getCtpTop()}catch(A){return null}if(B!=null){return B.MxtProgressBar.current}else{return null}};MxtProgressBar.prototype.init=function(){var D=this.id+"_mask";var G=document.body.clientWidth;var B=(document.documentElement.scrollHeight>document.documentElement.clientHeight?document.documentElement.scrollHeight:document.documentElement.clientHeight);if(typeof ($("#"+D)[0])=="undefined"&&this.isMode==true){$("body").prepend("<div id='"+D+"' class='mask' style='width:"+G+"px;height:"+B+"px;'>&nbsp;</div>")}if(typeof ($("#"+this.id)[0])!="undefined"){$("#"+this.id).remove()}var A="";if(this.progress==""){var I=(G-66)/2;var H=(document.documentElement.clientHeight-66)/2;A+="<div id='"+this.id+"' class='common_loading_progress_box absolute clearfix' style='left:"+(I+document.documentElement.scrollLeft)+"px;top:"+(H+document.documentElement.scrollTop)+"px;'></div>";if(this.text!=""&&this.text!=undefined){A+="<div id='"+this.id+"_text' class='absolute clearfix' style='width:auto;overflow:hidden;border:0px #286fbf solid;background:#f8f8f8;z-index:1001;font-size:12px;padding:5px;left:"+(I+document.documentElement.scrollLeft-76)+"px;top:"+(H+document.documentElement.scrollTop+66)+"px;'>"+this.text+"</div>"}}else{var I=(G-(this.width+5))/2;var H=(document.documentElement.clientHeight-(this.height+5))/2;A+="<div id='"+this.id+"' class='common_progress_box absolute clearfix' style='left:"+((I<0?0:I)+document.documentElement.scrollLeft)+"px;top:"+((H<0?0:H)+document.documentElement.scrollTop)+"px;'>";A+="<div id='"+this.id+"_shadow' class='common_progress_shadow absolute' style='width:"+(this.width+this.borderSize*2)+"px;height:"+(this.height+this.borderSize*2)+"px;'>&nbsp;</div>";A+="<div class='common_progress_strip absolute padding_5' style='width:"+(this.width-10)+"px;height:"+(this.height-10)+"px;'>";if(this.text!=""){A+="<dl id='"+this.id+"_title' class='common_progress_strip_title margin_b_5 margin_t_5 '>"+this.text+"</dl>"}A+="<dl id='"+this.id+"_text' class='common_progress_strip_per margin_l_10 right margin_r_5'>"+this.progress+"%</dl>";A+="<dl class='common_progress_strip_content'>";A+="<dt id='"+this.id+"_progress' class='common_progress_strip_bg' style='width:"+this.progress+"%'></dt>";A+="</dl>";A+="<div class='padding_10'><table class='common_right'><tr><td class='clearfix' id='"+this.id+"_buttons'>";A+="</td></tr></table></div>";A+="</div>";A+="</div>"}$("body").prepend(A);if(this.buttons!=null){for(var C=0;C<this.buttons.length;C++){var E=this.buttons[C];$("<a id='"+E.id+"' href='javascript:void(0)' class='common_button common_button_gray margin_r_10'>"+E.text+"</a>\n").click(E.handler).appendTo($("#"+this.id+"_buttons"))}}var F=$("#"+this.id+"_text").width();$("#"+this.id+"_text").css("left",I+document.documentElement.scrollLeft-((F-56)/2)+"px")};MxtProgressBar.prototype.setText=function(A){$("#"+this.id+"_text").css({width:"100%","text-align":"center",left:"0",background:"none"});$("#"+this.id+"_text").html("<span style='text-align: center;background-color: #f8f8f8;padding: 3px 5px'>"+A+"</span>")};MxtProgressBar.prototype.setProgress=function(A){$("#"+this.id+"_progress").css("width",A+"%");$("#"+this.id+"_text").html(A+"%")};MxtProgressBar.prototype.setTitle=function(A){$("#"+this.id+"_title").html(A)};MxtProgressBar.prototype.close=function(){$("#"+this.id+"_mask").remove();$("#"+this.id).remove();if(this.text!=""&&this.text!=undefined){$("#"+this.id+"_text").remove()}MxtProgressBar.current=null};MxtProgressBar.prototype.start=function(){$("#"+this.id+"_mask").show();$("#"+this.id).show();if(this.text!=""&&this.text!=undefined){$("#"+this.id+"_text").show()}};
function StringBuffer(){this._strings_=new Array()}StringBuffer.prototype.append=function(A){if(A){if(A instanceof Array){this._strings_=this._strings_.concat(A)}else{this._strings_[this._strings_.length]=A}}return this};StringBuffer.prototype.reset=function(A){this.clear();this.append(A)};StringBuffer.prototype.clear=function(){this._strings_=new Array()};StringBuffer.prototype.isBlank=function(){return this._strings_.length==0};StringBuffer.prototype.toString=function(A){A=A==null?"":A;if(this._strings_.length==0){return""}return this._strings_.join(A)};String.prototype.getBytesLength=function(){var A=this.match(/[^\x00-\xff]/ig);return this.length+(A==null?0:A.length)};String.prototype.getLimitLength=function(C,F){if(!C||C<0){return this}var A=this.getBytesLength();if(A<=C){return this}F=F==null?"..":F;C=C-F.length;var B=0;var D="";for(var E=0;E<this.length;E++){if(this.charCodeAt(E)>255){B+=2}else{B++}D+=this.charAt(E);if(B>=C){return D+F}}return this};String.prototype.escapeHTML=function(B,A){try{return escapeStringToHTML(this,B,A)}catch(C){}return this};String.prototype.escapeJavascript=function(){return escapeStringToJavascript(this)};String.prototype.escapeSpace=function(){return this.replace(/ /g,"&nbsp;")};String.prototype.escapeSameWidthSpace=function(){return this.replace(/ /g,"&nbsp;&nbsp;")};String.prototype.escapeXML=function(){return this.replace(/\&/g,"&amp;").replace(/\</g,"&lt;").replace(/\>/g,"&gt;").replace(/\"/g,"&quot;")};String.prototype.escapeQuot=function(){return this.replace(/\'/g,"&#039;").replace(/"/g,"&#034;")};String.prototype.startsWith=function(A){return this.indexOf(A)==0};String.prototype.endsWith=function(A){var B=this.indexOf(A);return B>-1&&B==this.length-A.length};String.prototype.trim=function(){var C=this.toCharArray();var A=0;var D=C.length;for(var B=0;B<C.length;B++){var E=C[B];if(E==" "){A++}else{break}}if(A==this.length){return""}for(var B=C.length;B>0;B--){var E=C[B-1];if(E==" "){D--}else{break}}return this.substring(A,D)};String.prototype.toCharArray=function(){var B=[];for(var A=0;A<this.length;A++){B[A]=this.charAt(A)}return B};function ArrayList(){this.instance=new Array()}ArrayList.prototype.size=function(){return this.instance.length};ArrayList.prototype.add=function(A){this.instance[this.instance.length]=A};ArrayList.prototype.addSingle=function(A){if(!this.contains(A)){this.instance[this.instance.length]=A}};ArrayList.prototype.addAt=function(A,B){if(A>=this.size()||A<0||this.isEmpty()){this.add(B);return }this.instance.splice(A,0,B)};ArrayList.prototype.addAll=function(A){if(!A||A.length<1){return }this.instance=this.instance.concat(A)};ArrayList.prototype.addList=function(A){if(A&&A instanceof ArrayList&&!A.isEmpty()){this.instance=this.instance.concat(A.instance)}};ArrayList.prototype.get=function(A){if(this.isEmpty()){return null}if(A>this.size()){return null}return this.instance[A]};ArrayList.prototype.getLast=function(){if(this.size()<1){return null}return this.instance[this.size()-1]};ArrayList.prototype.set=function(B,C){if(B>=this.size()){throw"IndexOutOfBoundException : Index "+B+", Size "+this.size()}var A=this.instance[B];this.instance[B]=C;return A};ArrayList.prototype.removeElementAt=function(A){if(A>this.size()||A<0){return }this.instance.splice(A,1)};ArrayList.prototype.remove=function(B){var A=this.indexOf(B);this.removeElementAt(A)};ArrayList.prototype.contains=function(A,B){return this.indexOf(A,B)>-1};ArrayList.prototype.indexOf=function(C,D){for(var A=0;A<this.size();A++){var B=this.instance[A];if(B==C){return A}else{if(D!=null&&B!=null&&C!=null&&B[D]==C[D]){return A}}}return -1};ArrayList.prototype.lastIndexOf=function(C,D){for(var A=this.size()-1;A>=0;A--){var B=this.instance[A];if(B==C){return A}else{if(D!=null&&B!=null&&C!=null&&B[D]==C[D]){return A}}}return -1};ArrayList.prototype.subList=function(B,D){if(B<0){B=0}if(D>this.size()){D=this.size()}var C=this.instance.slice(B,D);var A=new ArrayList();A.addAll(C);return A};ArrayList.prototype.toArray=function(){return this.instance};ArrayList.prototype.isEmpty=function(){return this.size()==0};ArrayList.prototype.clear=function(){this.instance=new Array()};ArrayList.prototype.toString=function(A){A=A||", ";return this.instance.join(A)};function Properties(A){this.instanceKeys=new ArrayList();this.instance={};if(A){this.instance=A;for(var B in A){this.instanceKeys.add(B)}}}Properties.prototype.size=function(){return this.instanceKeys.size()};Properties.prototype.get=function(B,A){if(B==null){return null}var C=this.instance[B];if(C==null&&A!=null){return A}return C};Properties.prototype.remove=function(A){if(A==null){return null}this.instanceKeys.remove(A);delete this.instance[A]};Properties.prototype.put=function(A,B){if(A==null){return null}if(this.instance[A]==null){this.instanceKeys.add(A)}this.instance[A]=B};Properties.prototype.putRef=function(A,B){if(A==null){return null}this.instanceKeys.add(A);this.instance[A]=B};Properties.prototype.getMultilevel=function(D,B){if(D==null){return null}var C=D.split(".");function A(I,G,F){try{if(I==null||(typeof I!="object")){return null}var J=I.get(G[F]);if(F<G.length-1){J=A(J,G,F+1)}return J}catch(H){}return null}var E=A(this,C,0);return E==null?B:E};Properties.prototype.containsKey=function(A){if(A==null){return false}return this.instance[A]!=null};Properties.prototype.keys=function(){return this.instanceKeys};Properties.prototype.values=function(){var D=new ArrayList();for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);if(A){var C=this.instance[A];D.add(C)}}return D};Properties.prototype.isEmpty=function(){return this.instanceKeys.isEmpty()};Properties.prototype.clear=function(){this.instanceKeys.clear();this.instance={}};Properties.prototype.swap=function(C,B){if(!C||!B||C==B){return }var E=-1;var D=-1;for(var A=0;A<this.instanceKeys.instance.length;A++){if(this.instanceKeys.instance[A]==C){E=A}else{if(this.instanceKeys.instance[A]==B){D=A}}}this.instanceKeys.instance[E]=B;this.instanceKeys.instance[D]=C};Properties.prototype.entrySet=function(){var A=[];for(var C=0;C<this.instanceKeys.size();C++){var B=this.instanceKeys.get(C);var D=this.instance[B];if(!B){continue}var E=new Object();E.key=B;E.value=D;A[A.length]=E}return A};Properties.prototype.toString=function(){var C="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);C+=A+"="+this.instance[A]+"\n"}return C};Properties.prototype.toStringTokenizer=function(E,D){E=E==null?";":E;D=D==null?"=":D;var F="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);var C=this.instance[A];if(!A){continue}if(B>0){F+=E}F+=A+D+C}return F};Properties.prototype.toQueryString=function(){if(this.size()<1){return""}var D="";for(var B=0;B<this.instanceKeys.size();B++){var A=this.instanceKeys.get(B);var C=this.instance[A];if(!A){continue}if(B>0){D+="&"}if(typeof C=="object"){}else{D+=A+"="+encodeURIat(C)}}return D};
(function(){var fieldTypeValue={string:"string",number:"number",email:"email",telephone:"telephone",mobilePhone:"mobilePhone","0":"0","1":"1","2":"2","3":"3","4":"4","5":"5","8":"0","9":"0","6":"6"};var fieldType="type";var fieldName="name";var maxValue="maxValue";var minValue="minValue";var minLength="minLength";var maxLength="maxLength";var china3char="china3char";var notNull="notNull";var dotNumber="dotNumber";var fieldDiaplayName="displayName";var fieldLen="fieldLen";var nullable="nullable";var isNumber="isNumber";var integerDigits="integerDigits";var decimalDigits="decimalDigits";var isEmail="isEmail";var notNullWithoutTrim="notNullWithoutTrim";var isInteger="isInteger";var max="max";var min="min";var maxEqual="maxEqual";var minEqual="minEqual";var isWord="isWord";var character="avoidChar";var isDeaultValue="isDeaultValue";var deaultValue="deaultValue";var regExp="regExp";var errorMsg="errorMsg";var func="func";$.fn.resetValidate=function(options){var errorClassName="error-form";this.find("."+errorClassName).removeClass(errorClassName).each(function(i,e){var prt=$(e);var es=prt.data("errorIcon");if(es){prt.removeClass("error-form").next().remove();prt.removeAttr("title");prt.removeData("errorIcon");prt.find("input,textarea").unbind("propertychange");prt.css({width:($(this).width()+35)+"px"})}})};function checkValue(obj,options,errorArray){var resultTemp=obj;var resultTempPar=resultTemp.parent();curCheckObj=checkInput(resultTemp,options.checkNull);if(curCheckObj.errorArray){var len=curCheckObj.errorArray.length;if(len>0){showError(resultTempPar,curCheckObj,options,resultTemp);if(!resultTempPar.hasClass("error-form")||resultTemp.attr("comptype")=="calendar"){if(resultTemp.hasClass("comp")){resultTemp.focus(function(){checkval($(this),options)})}}if($.browser.msie&&parseInt($.browser.version)<9){resultTemp.bind("propertychange",function(e){if(e.originalEvent&&e.originalEvent.propertyName=="value"){checkval($(this),options)}})}else{resultTemp.bind("change",function(){checkval($(this),options)})}errorArray.push(curCheckObj.errorArray.join("\r\n"))}}}function MxtCheckForm(form,options){if(typeof form==="string"){form=$("#"+form)}else{form=$(form)}var errorArray=[],curCheckObj=null;var result=[];var focusObj=null;var firstErrorObj=null;if(options&&options.validateHidden){$(".validate",form).add(form).each(function(){if(!this.disabled&&$(this).attr("validate")&&this.tagName.toLowerCase()!="span"&&this.tagName.toLowerCase()!="div"){result.push($(this))}})}else{$(".validate",form).add(form).each(function(){if(!this.disabled&&$(this).is(":visible")&&$(this).attr("validate")&&this.tagName.toLowerCase()!="span"&&this.tagName.toLowerCase()!="div"){result.push($(this))}})}for(var i=0;i<result.length;i++){if(i==0){focusObj=result[0]}checkValue(result[i],options,errorArray);if(firstErrorObj==null&&errorArray.length==1){firstErrorObj=result[i]}result[i]=null}form=null;if(focusObj!=null){var tempId=focusObj.attr("id");if(tempId!=null){if(!/^field\d{0,5}/.test(tempId)){focusObj.focus()}}else{focusObj.focus()}}if(errorArray.length>0){var errorAlert=options.errorAlert;if(errorAlert){if(top.$("#checkformError").length<=0){$.alert({id:"checkformError",msg:errorArray.join("<br/>")})}}return false}else{return true}}function MxtCheckInput(input){var options={errorIcon:true};if(input==null){return true}var errorArray=[];checkValue(input,options,errorArray);var result=true;if(curCheckObj.errorArray&&curCheckObj.errorArray.length>0){result=false}input=null;return result}function MxtCheckMsg(msg,context){if(msg==null){return }context=context||document.body;if(typeof context==="string"){context=$("#"+context)}else{context=$(context)}for(var elemSelector in msg){addCheckMsg($(elemSelector,context),msg[elemSelector])}context=null}window.MxtCheckForm=MxtCheckForm;window.MxtCheckInput=MxtCheckInput;window.MxtCheckMsg=MxtCheckMsg;window.RemoveCheckMsg=checkval;function checkInput(input,checkIsNull){if(input==null){return{}}var checkObj=getCheckObj(input);if(checkObj!=null){if(checkObj.errorArray==null){checkObj.errorArray=[]}checkObj.checkNull=checkIsNull;if(checkIsNull){checkNotNull(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkNotNullWithourTrim(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}}checkIsNumber(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsEmail(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsWord(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsDefaultValue(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsTelephone(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsMobilePhone(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsDate(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsDateTime(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsDateTimes(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsShorterThanMax(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkIsLongerThanMin(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkCustomRegExp(checkObj);if(checkObj.errorArray.length>0){input=null;return checkObj}checkCustomFunc(checkObj,input);if(checkObj.errorArray.length>0){input=null;return checkObj}}input=null;return checkObj}function checkval(obj,options){if(options==null){var settings={errorIcon:true,errorAlert:false,errorBg:false,validateHidden:false,checkNull:true};options=$.extend(settings,options)}var temp=checkInput(obj,true);var prt=obj.parent();if(!temp.errorArray||(temp.errorArray&&temp.errorArray.length===0)){prt.removeClass("error-form");prt.removeAttr("title");if(prt.data("errorIcon")){prt.removeData("errorIcon");prt.next().remove();if(options.errorIcon){prt.css({width:(prt.width()+35)+"px"});if(obj.hasClass("comp")){obj.width("100%")}}}if(prt.data("errorBg")){prt.removeData("errorBg");prt.css("background","#fff");if(obj&&!(temp[notNull]||temp[nullable])){$(obj).css("background","#fff")}}}else{showError(prt,temp,options,obj)}}function showError(par,obj,options,objDom){if(options){var _w=par.width();if(options.errorIcon){par.addClass("error-form").css({"float":"left"}).attr("title",obj.errorArray.join(""));var es=par.data("errorIcon");if(!es){es=$("<span class='error-title'></span>");par.data("errorIcon",es);par.after(es);par.css({width:(_w-35)+"px"})}es.attr("title",obj.errorArray.join(""))}if(options.errorBg){var bg=par.data("errorBg");if(!bg){par.css("background","#FCDD8B");if(objDom){$(objDom).css("background","#FCDD8B")}par.data("errorBg",true)}}}else{}}function addCheckMsg(elem,msg){if(elem==null){return }if(typeof msg=="string"){try{msg=eval("({"+msg+"})")}catch(e){return }}var checkObj=getCheckObj(elem);$.extend(checkObj,msg);elem=null}function getCheckObj(input){if(input==null){return{}}if(input.data("checkObj")){var checkObj=input.data("checkObj");checkObj.errorArray=null;checkObj.value=input.val();return input.data("checkObj")}var checkObj=null,validate=null;input=$(input);validate=input.attr("validate");if(validate==null||$.trim(validate)==""){return{}}else{try{checkObj=eval("({"+validate+"})")}catch(e){checkObj={};var errorMessage=input.attr("name")+$.i18n("validate.notJson.js");addErrorMessage(checkObj,errorMessage,true);input=null;return checkObj}}if(checkObj.name==null){var tempName=checkObj[fieldName]||checkObj[fieldDiaplayName]||input.attr("name");if(tempName){checkObj.name=tempName}else{var errorMessage=$.i18n("validate.notName.js");addErrorMessage(checkObj,errorMessage,true);input=null;return checkObj}}checkObj.value=input.val();input.data("checkObj",checkObj);input=null;return checkObj}function checkNotNull(obj){if(obj==null){return true}if(obj[notNull]||obj[nullable]){if(isNull(obj.value)){addErrorMessage(obj,obj.name+$.i18n("validate.notNull.js"),true);return false}}return true}function checkNotNullWithourTrim(obj){if(obj==null){return true}if(obj[notNullWithoutTrim]){if(isNull(obj.value,true)){addErrorMessage(obj,obj.name+$.i18n("validate.notNull.js"),true);return false}}return true}function checkIsNumber(obj){if(obj==null){return true}if(isNull(obj.value)){return true}var isNumberFlag=false,isIntegerFlag=false;if(obj[isNumber]||(obj[fieldType]==fieldTypeValue.number)||(obj[fieldType]==fieldTypeValue["1"])||(obj[fieldType]==fieldTypeValue["2"])){isNumberFlag=true;if(isNull(obj.value)){return true}if(!isANumber(obj.value)){addErrorMessage(obj,obj.name+$.i18n("validate.notNumber.js"));return false}var value=""+$.trim(obj.value);var dotIndex=value.indexOf("."),intdigits=obj[integerDigits],decDigits=obj[decimalDigits];if(decDigits==null){decDigits=obj[dotNumber]}if(intdigits!=null&&isANumber(intdigits)){var intbits=dotIndex>-1?dotIndex:value.length;if(intbits>parseInt(intdigits)){addErrorMessage(obj,obj.name+$.i18n("validate.integerDigits.js",intdigits));return false}}if(decDigits!=null&&isANumber(decDigits)){var decbits=dotIndex>-1?(value.length-1-dotIndex):0;if(decbits>parseInt(decDigits)){addErrorMessage(obj,obj.name+$.i18n("validate.decimalDigits.js",decDigits));return false}}}if(obj[isInteger]){isIntegerFlag=true;if(isNull(obj.value)){return true}if(!isANumber(obj.value)){addErrorMessage(obj,obj.name+$.i18n("validate.integer.js"));return false}var value=""+obj.value;if(value.indexOf(".")>-1){addErrorMessage(obj,obj.name+$.i18n("validate.integer.decimal.js"));return false}}if(isNumberFlag||isIntegerFlag){if(!checkIsLessThanMax(obj)){return false}if(!checkIsBiggerThanMin(obj)){return false}}return true}function checkIsEmail(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[isEmail]||(obj[fieldType]=="email")){var str=obj.value;if(isNull(str)){return true}else{var result=true;if(str.indexOf("@")==-1){result=false}else{if(str.indexOf("@")==0){result=false}else{if((str.length-str.indexOf("@"))<5){result=false}else{if(str.indexOf(".")==-1){result=false}else{if((str.length-str.indexOf("."))<3){result=false}}}}}if(!result){addErrorMessage(obj,obj.name+$.i18n("validate.email.js"))}return result}}return true}function checkIsWord(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[isWord]||(obj[fieldType]==fieldTypeValue.string)||(obj[fieldType]==fieldTypeValue["0"])||(obj[fieldType]==fieldTypeValue["8"])||(obj[fieldType]==fieldTypeValue["9"])){if(typeof obj.value!="string"){return false}if(obj[character]&&typeof obj[character]=="string"){var value=""+obj.value,chars=obj[character];for(var i=0,len=chars.length;i<len;i++){if(value.indexOf(chars.charAt(i))>-1){addErrorMessage(obj,obj.name+$.i18n("validate.specialhave.js")+obj[character]);return false}}}}return true}function checkIsDefaultValue(obj){if(obj==null){return false}if(isNull(obj.value)){return false}if(obj[isDeaultValue]&&obj[deaultValue]){if($.trim(obj.value)==obj[deaultValue]){addErrorMessage(obj,obj.name+$.i18n("validate.notDefault.js")+"("+obj[deaultValue]+")!");return true}}return false}var telReg=/^\d[-_0-9]{5,}\d$/;function checkIsTelephone(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[fieldType]=="telephone"){var value=""+obj.value;if(telReg.test(value)!=true){addErrorMessage(obj,obj.name+$.i18n("validate.phoneNumber.js"));return false}}return true}var mobileReg=/\d{11,}/;function checkIsMobilePhone(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[fieldType]=="mobilePhone"){var value=""+obj.value;if(mobileReg.test(value)!=true){addErrorMessage(obj,obj.name+$.i18n("validate.mobileNumber.js"));return false}}return true}var dateReg=/^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;function checkIsDate(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[fieldType]==3){var value=""+obj.value;if(dateReg.test(value)!=true){addErrorMessage(obj,obj.name+$.i18n("validate.yyyy.MM.dd.js"));return false}}return true}var datetimeReg=/^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29)) (20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d$/;function checkIsDateTime(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[fieldType]==4){var value=""+obj.value;if(datetimeReg.test(value)!=true){addErrorMessage(obj,obj.name+$.i18n("validate.yyyy.MM.dd.hh.mm.ss.js"));return false}}return true}var datetimeRegs=/^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29)) (20|21|22|23|[0-1]?\d):[0-5]?\d$/;function checkIsDateTimes(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[fieldType]==5){var value=""+obj.value;if(datetimeRegs.test(value)!=true){addErrorMessage(obj,obj.name+$.i18n("validate.yyyy.MM.dd.hh.mm.ss.js"));return false}}return true}function checkIsShorterThanMax(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[maxLength]!=null){if(isANumber(obj[maxLength])){if(obj[isNumber]||(obj[fieldType]==fieldTypeValue.number)||(obj[fieldType]==fieldTypeValue["1"])||(obj[fieldType]==fieldTypeValue["2"])){if(obj.value.length>0){obj.value=obj.value.replace(/\./,"")}if(longerThanSecond(obj.value,obj[maxLength])){addErrorMessage(obj,obj.name+$.i18n("validate.maxLength.js",obj[maxLength]));return false}}else{if(obj[china3char]==true){if(longerThanSecondChina(obj.value,obj[maxLength])){addErrorMessage(obj,obj.name+$.i18n("validate.maxLengthChina.js",obj[maxLength]));return false}}else{if(longerThanSecond(obj.value,obj[maxLength])){addErrorMessage(obj,obj.name+$.i18n("validate.maxLength.js",obj[maxLength]));return false}}}}else{addErrorMessage(obj,obj.name+$.i18n("validate.maxLength.notNumber.js"));return false}}return true}function checkIsLongerThanMin(obj){if(obj==null){return true}if(isNull(obj.value)){return true}if(obj[minLength]!=null){if(isANumber(obj[minLength])){if(shorterThanSecond(obj.value,obj[minLength])){addErrorMessage(obj,obj.name+$.i18n("validate.minLength.js")+obj[minLength]+"!");return false}}else{addErrorMessage(obj,obj.name+$.i18n("validate.minLength.notNumber.js"));return false}}return true}function checkIsLessThanMax(obj){if(obj==null){return true}if(isNull(obj.value)){return true}var tempMax=obj[max];if(tempMax==null){tempMax=obj[maxValue]}if(tempMax!=null&&isANumber(tempMax)){value=parseFloat(obj.value);if(obj[maxEqual]==false){if(tempMax<=value){addErrorMessage(obj,obj.name+$.i18n("validate.mustLittle.js")+tempMax+"!");return false}}else{if(tempMax<value){addErrorMessage(obj,obj.name+$.i18n("validate.mustLittleOrEqual.js")+tempMax+"!");return false}}}return true}function checkIsBiggerThanMin(obj){if(obj==null){return true}if(isNull(obj.value)){return true}var tempMin=obj[min];if(tempMin==null){tempMin=obj[minValue]}if(tempMin!=null&&isANumber(tempMin)){value=parseFloat(obj.value);if(obj[minEqual]==false){if(tempMin>=value){addErrorMessage(obj,obj.name+$.i18n("validate.mustBigger.js")+tempMin+"!");return false}}else{if(tempMin>value){addErrorMessage(obj,obj.name+$.i18n("validate.mustBiggerOrEqual.js")+tempMin+"!");return false}}}return true}function checkCustomRegExp(obj){if(obj==null){return true}if(isNull(obj.value)){return true}var customRegExp=obj[regExp];if(customRegExp!=null){if(!new RegExp(customRegExp).test(obj.value)){addErrorMessage(obj,obj.name+$.i18n("validate.notMatch.js"));return false}}return true}function checkCustomFunc(obj,input){if(obj==null||input==null){input=null;return true}if(typeof obj[func]=="function"){var result=obj[func](input,obj);if(result==null||result==false){addErrorMessage(obj,obj.name+$.i18n("validate.notMatch.js"))}}input=null;return true}function isNull(value,notTrim){if(value==null){return true}else{if(typeof (value)=="string"){value=notTrim==true?$.trim(value):value;if(value==""){return true}}}return false}function isANumber(value){if(typeof value=="string"){value=value}return/^[-+]?\d+([\.]\d+)?$/.test(value)}function longerThanSecond(first,second){if(first!=null&&second!=null&&isANumber(second)){second=parseFloat(second);if(first.length>second){return true}}return false}function longerThanSecondChina(first,second){if(first!=null&&second!=null&&isANumber(second)){second=parseFloat(second);if(getLength(first)>second){return true}}return false}function shorterThanSecond(first,second){if(first!=null&&second!=null&&isANumber(second)){second=parseFloat(second);if(first.length<second){return true}}return false}function getLength(value){if(value==null){return 0}else{if(value==""){return 1}else{var result=0;for(var i=0,len=value.length;i<len;i++){var ch=value.charCodeAt(i);if(ch<256){result++}else{result+=3}}return result}}}function addErrorMessage(obj,errMsg,useSystem){if(obj){if(obj.errorArray==null){obj.errorArray=[]}var customErrorMsg=obj[errorMsg];if(useSystem!=true&&customErrorMsg){obj.errorArray.push(customErrorMsg)}else{obj.errorArray.push(errMsg)}}}$.fn.validate=function(options){var settings={errorIcon:true,errorAlert:false,errorBg:false,validateHidden:false,checkNull:true};options=$.extend(settings,options);return MxtCheckForm(this,options)};$.fn.validateChange=function(obj){var tempElem=this;if(tempElem!=null&&tempElem.size()>0){addCheckMsg(tempElem,obj)}tempElem=null};var invalid=[];$._invalidObj=function(obj){if(obj){invalid.push(obj)}invalid.contains(obj)};$._isInValid=function(obj){if(invalid.contains){return invalid.contains(obj)}return null};$.isNull=isNull;$.isANumber=isANumber})();
function MxtToolTip(A){this.id=A.id?A.id:"toolTip_"+Math.floor(Math.random()*1000000000);this.width=A.width?A.width:200;this.event=A.event?A.event:null;this.targetId=A.targetId?A.targetId:null;this.openPoint=A.openPoint?A.openPoint:[];this.openAuto=A.openAuto?A.openAuto:false;this.direction=A.direction?A.direction:"TL";this.showHtmlID=A.htmlID?A.htmlID:null;this.showMsg=A.msg?A.msg:null;this.targetWindow=A.targetWindow==null?window:A.targetWindow;this.z_index=A.z_index==null?5000:A.z_index;this.left=0;this.top=0;this.init()}MxtToolTip.prototype.init=function(){var B=this;$(".tooltip").remove();var A="";A+="<div id='"+this.id+"' class='tooltip' style='display:none; position: absolute; width: "+this.width+"px;z-index:"+this.z_index+"'>";A+="<div class='tooltip_border'>";A+="<span><em class='tooltip_em' style=''></em></span>";A+="<div class='tooltip_text'></div>";A+="</div>";A+="</div>";$(this.targetWindow.document).find("body").append(A);if(this.showHtmlID!=null){$("#"+this.showHtmlID).wrap("<div id='"+this.id+"_area'></div>");$(this.targetWindow.document).find("#"+this.id+" .tooltip_text").append($("#"+this.showHtmlID).clone(true));$("#"+this.id+"_area").empty()}else{if(this.showMsg!=null){$(this.targetWindow.document).find("#"+this.id+" .tooltip_text").html(this.showMsg)}else{$(this.targetWindow.document).find("#"+this.id+" .tooltip_text").html($("#"+this.targetId).attr("tooltip"))}}this.setPoint(this.left,this.top);if(this.openAuto==true){this.show()}var B=this;$(this.targetWindow.document).find("#"+this.id+" .tooltip_close").click(function(){B.hide()})};MxtToolTip.prototype.getPD=function(){var E;var B;var D=$(this.targetWindow.document).find("#"+this.id).width();var F=$(this.targetWindow.document).find("#"+this.id).height();var C=$(this.targetWindow).width();var A=$(this.targetWindow).height();if(this.event){E=$("#"+this.targetId).offset().left;B=$("#"+this.targetId).offset().top+$("#"+this.targetId).height()}else{E=this.openPoint[0];B=this.openPoint[1]}if((this.direction.substr(0,1)=="T")||(this.direction.substr(0,1)=="B")){if(E+D>C){this.direction=this.direction.substr(0,1)+"R";this.left=E-D}else{this.left=E}if(B+F>A-5){this.direction="B"+this.direction.substr(1);this.top=B-F}else{this.top=B+5}}else{if(E+D>C){this.direction="R"+this.direction.substr(1);this.left=E-D}else{this.left=E}if(B+F>A){this.direction=this.direction.substr(0,1)+"B";this.top=B-F}else{this.top=B}}this.setDirection(this.direction)};MxtToolTip.prototype.setPoint=function(A,B){this.left=A;this.top=B;this.getPD();$(this.targetWindow.document).find("#"+this.id).css({left:this.left+"px",top:this.top+"px"})};MxtToolTip.prototype.setDirection=function(B){var C=$(this.targetWindow.document).find("#"+this.id+" .tooltip_em");var A="";switch(B){case"TL":A="0 -166px";C.css({left:"",top:"-5px",right:"",bottom:""});break;case"TR":A="0 -166px";C.css({left:"",top:"-5px",right:"10px",bottom:""});break;case"BL":A="0 -160px";C.css({left:"",top:"",right:"",bottom:"-5px"});break;case"BR":A="0 -160px";C.css({left:"",top:"",right:"10px",bottom:"-5px"});break;case"LT":A="-22px -160px";C.css({left:"-5px",top:"",right:"",bottom:"",width:"6px",height:"11px"});break;case"LB":A="-22px -160px";C.css({left:"-5px",top:"",right:"",bottom:"10px",width:"6px",height:"11px"});break;case"RT":A="-16px -160px";C.css({left:"",top:"",right:"-5px",bottom:"",width:"6px",height:"11px"});break;case"RB":A="-16px -160px";C.css({left:"",top:"",right:"-5px",bottom:"10px",width:"6px",height:"11px"});break}C.css({"background-position":A})};MxtToolTip.prototype.setHtml=function(A){if(A.id){if(this.showHtmlID!=null){$(this.targetWindow.document).find("#"+this.showHtmlID).clone(true).appendTo("#"+this.id+"_area");$("#"+this.showHtmlID).unwrap()}this.showHtmlID=A.id;$("#"+this.showHtmlID).wrap("<div id='"+this.showHtmlID+"_area'></div>");$(this.targetWindow.document).find("#"+this.id+" .tooltip_text").empty().append($("#"+this.showHtmlID).clone(true));$("#"+this.showHtmlID+"_area").empty()}if(A.text){$(this.targetWindow.document).find("#"+this.id+" .tooltip_text").html(A.text)}};MxtToolTip.prototype.close=function(){$(this.targetWindow.document).find("#"+this.showHtmlID).clone(true).appendTo("#"+this.id+"_area");$("#"+this.showHtmlID).unwrap();$(this.targetWindow.document).find("#"+this.id).remove()};MxtToolTip.prototype.show=function(){$(this.targetWindow.document).find("#"+this.id).show()};MxtToolTip.prototype.hide=function(){$(this.targetWindow.document).find("#"+this.id).hide()};function MxtTip(A){this.settings={id:"MxtTip"+Math.floor(Math.random()*100000000),targetId:null,top:0,left:0,keepTime:2000,autoShow:true,autoClose:true,offsetTop:0,offsetLeft:0,checkPosition:true,color:"#463900",background:"#FDF0A4",content:"\u9700\u8981\u4f60\u7ed9\u6211\u6307\u5b9a\u5185\u5bb9,\u4eb2~",beforeShowCallBack:function(){},callBack:function(){}};$.extend(this.settings,A);this.init()}MxtTip.prototype.init=function(){var G=this;var A="";A+="<div id='"+G.settings.id+"' class='MxtTip' style='display:none;position:absolute;z-index:10000;left:0;top:0; background:"+G.settings.background+";color:"+G.settings.color+";'><div class='MxtTip_content' style='padding: 5px 10px;font-size:12px;'>"+G.settings.content+"<em class='close ico16 close_16' style='display:none;'></em></div></div>";$("body").append(A);G.myObj=$("#"+G.settings.id);if(G.settings.targetId){var F=G.myObj.width();var C=$("#"+G.settings.targetId);var E=C.width();var D,B;D=C.offset().top;B=C.offset().left*1+(E-F)/2;G.setPosition({top:D,left:B})}else{if(G.settings.top&&G.settings.left){G.setPosition({top:G.settings.top,left:G.settings.left})}}this.mouserHander();if(G.settings.autoShow){G.show()}};MxtTip.prototype.setPosition=function(A){var D=this;var C=A.top*1+D.settings.offsetTop;var B=A.left*1+D.settings.offsetLeft;if(D.settings.checkPosition){C=C>=0?C:0;B=B>=0?B:0}D.myObj.css({top:C+"px",left:B+"px"})};MxtTip.prototype.mouserHander=function(){};MxtTip.prototype.show=function(){var A=this;A.settings.beforeShowCallBack();A.myObj.fadeIn("fast");setTimeout(function(){A.close()},A.settings.keepTime)};MxtTip.prototype.close=function(){var A=this;A.myObj.fadeOut("fast",function(){A.myObj.remove();A.settings.callBack()})};
function MxtTimeLine(A){this.id=A.id!=undefined?A.id:Math.floor(Math.random()*100000000);this.height=A.height==undefined?500:A.height;this.render=A.render;this.timeStep=A.timeStep==undefined?["8:00","18:00"]:A.timeStep;this.date=A.date;if(this.date==undefined){var B=new Date();this.date[0]=B.getFullYear();this.date[1]=B.getMonth()+1;this.date[2]=B.getDate()}this.autoHeight=0;this.dateHeight=20;this.editHeight=10;this.boxPadding=10;this.isHasMaxEvent=false;this.hideFlag=true;this.items=A.items;this.action=A.action;this.searchClick=A.searchClick==undefined?function(){}:A.searchClick;this.editClick=A.editClick==undefined?function(){}:A.editClick;this.maxClick=A.maxClick==undefined?function(){}:A.maxClick;this.MonHead=[31,28,31,30,31,30,31,31,30,31,30,31];this.scaleArray=new Object();this.scaleHourArray=new Object();this.initTimeLine();this.initType()}MxtTimeLine.prototype.initTimeLine=function(){this.isHasMax();if(this.isHasMaxEvent){this.boxPadding=25}this.timeLineHeight=this.height-this.dateHeight-this.editHeight-this.boxPadding-this.autoHeight;this.time_line_box=$("<div class='time_line_box' id='"+this.id+"_box' style='padding-bottom:"+this.boxPadding+"px'></div>");this.time_line_edit=$("<div class='clearfix'><span id='"+this.id+"_editor' class='ico16 editor_16 left'></span><span id='"+this.id+"_maximize' class='ico16 maximize_16 right'></span> </div>");this.time_line_edit_div=$("<div class='time_line_edit hidden over_hidden'></div>");this.time_line_date=$("<div class='time_line_date' style='height:30px;letter-spacing:1px;'><span id='"+this.id+"_date'>"+(this.date[1].length==1?"0"+this.date[1]:this.date[1])+"-"+(this.date[2].length==1?"0"+this.date[2]:this.date[2])+"</span></div>");this.time_line_date_set=$("<div id='"+this.id+"_time_line_date_set' class='hidden' style='height:20px'></div>");this.time_line_date_set_mouth=$("<select class='left "+this.id+"_time_line_date_set_mouth' id='"+this.id+"_time_line_date_set_mouth'></select>");this.time_line_date_set_day=$("<select class='left "+this.id+"_time_line_date_set_day' id='"+this.id+"_time_line_date_set_day'></select>");this.time_line_date_set_ok=$("<a class='tooltip_close font_size12 right margin_r_10 margin_t_5 hand color_blue'>"+$.i18n("common.button.ok.label")+"</a>");this.time_line_date_set_cancel=$("<a class='tooltip_close font_size12 right margin_t_5 hand color_blue'>"+$.i18n("common.button.cancel.label")+"</a>");this.time_line_date_set.append(this.time_line_date_set_mouth);this.time_line_date_set.append("<span class='left font_size12' style='margin-top:2px;margin-right:10px;'>"+$.i18n("calendar_month")+"</span>");this.time_line_date_set.append(this.time_line_date_set_day);this.time_line_date_set.append("<span class='left font_size12 ' style='margin-top:2px;margin-right:2px;'>"+$.i18n("calendar_day")+"</span>");this.time_line_date_set.append(this.time_line_date_set_cancel);this.time_line_date_set.append(this.time_line_date_set_ok);this.time_line_date.append(this.time_line_date_set);this.time_line_edit_div.append(this.time_line_edit);$("body").append(this.time_line_edit_div);this.time_line_box.append(this.time_line_date);this.time_line_main=$("<div class='time_line_main relative' style='height:"+this.timeLineHeight+"px' id='"+this.id+"_main'></div>");this.timeStepInt=parseInt(this.timeStep[1],10)-parseInt(this.timeStep[0],10);this.subTime=this.timeLineHeight/(this.timeStepInt*2);for(var E=0;E<this.timeStepInt*2;E++){if(E==0){var C=$("<div class='time_hour_scale absolute'></div>");C.css({top:E*this.subTime-1});this.time_line_main.append(C);var B=$("<div class='time_hour absolute clearfix'><div class='time_hour_number' style='width:13px;'>"+(parseInt(this.timeStep[0],10)+E/2)+"</div><div class='time_hour_number_00' style='width:17px;'>:00</div></div>");B.css({top:(E*this.subTime-6)-7});this.time_line_main.append(B);this.scaleArray[parseInt(this.timeStep[0],10)+E/2]=E*this.subTime;this.scaleHourArray[parseInt(this.timeStep[0],10)+E/2]=B}else{if(E%2==0){var C=$("<div class='time_hour_scale absolute'></div>");C.css({top:E*this.subTime-1});this.time_line_main.append(C);var B=$("<div class='time_hour absolute clearfix'><div class='time_hour_number'>"+(parseInt(this.timeStep[0],10)+E/2)+"</div><div class='time_hour_number_00'>00</div></div>");B.css({top:(E*this.subTime-6)-7});this.time_line_main.append(B);this.scaleArray[parseInt(this.timeStep[0],10)+E/2]=E*this.subTime;this.scaleHourArray[parseInt(this.timeStep[0],10)+E/2]=B}else{var G=$("<div class='time_harf_hour_scale absolute'></div>");G.css({top:E*this.subTime});this.time_line_main.append(G)}}}var G=$("<div class='time_hour_scale absolute'></div>");G.css({top:this.timeStepInt*2*this.subTime-1});var B=$("<div class='time_hour absolute clearfix'><div class='time_hour_number'>"+parseInt(this.timeStep[1],10)+"</div><div class='time_hour_number_00'>00</div></div>");B.css({top:(this.timeStepInt*2*this.subTime-6)-7});this.time_line_main.append(B);this.scaleArray[parseInt(this.timeStep[1],10)]=this.timeStepInt*2*this.subTime;this.scaleHourArray[parseInt(this.timeStep[1],10)]=B;this.time_line_main.append(G);this.time_line_box.append(this.time_line_main);if(this.render==undefined){$("body").append(this.time_line_box)}else{$("#"+this.render).append(this.time_line_box)}this.year=this.date[0];this.month=parseInt(this.date[1],10);this.day=this.date[2];for(var F=1;F<13;F++){this.time_line_date_set_mouth.append($("<option "+(F==this.month?"selected":"")+">"+F+"</option>"))}this.changeDate(parseInt(this.year,10),parseInt(this.month,10));var A=this;$("#"+this.id+"_editor").click(this.editClick);$("#"+this.id+"_maximize").click(this.maxClick);this.time_line_date_set_ok.click(this.searchClick);this.time_line_date_set_mouth.change(function(){A.changeDate(parseInt(A.date[0],10),parseInt($(this).val(),10))});var D=true;this.time_line_box.mouseenter(function(){var H=$(this).offset();A.time_line_edit_div.css({left:H.left,top:H.top-16}).show();D=true}).mouseleave(function(){setTimeout(function(){if(D){A.time_line_edit_div.hide()}},10)});this.time_line_edit_div.mouseenter(function(){$("#"+A.id+"_time_line_date_set_tooltip").hide();$(this).show();D=false}).mouseleave(function(){$(this).hide();D=true});this.time_line_date.click(function(){if(A.setDateTooltip==undefined){var H=A.time_line_date.offset().left-230;var I=A.time_line_date.offset().top;A.setDateTooltip=$.tooltip({id:A.id+"_time_line_date_set_tooltip",width:230,openAuto:false,openPoint:[H,I],htmlID:A.id+"_time_line_date_set",direction:"RT",z_index:900})}$("#"+A.id+"_time_line_date_set").show();A.setDateTooltip.show();if($.browser.msie){if($.browser.version=="8.0"||$.browser.version=="7.0"||$.browser.version=="9.0"){$("."+A.id+"_time_line_date_set_mouth").val(parseInt(A.month,10));$("."+A.id+"_time_line_date_set_day").val(parseInt(A.day,10))}}})};MxtTimeLine.prototype.isHasMax=function(){for(var B=0;B<this.items.length;B++){var A=this.items[B];var D=parseInt(A.dateTime,10);var C=A.childItems;if(D==parseInt(this.timeStep[1],10)&&C.length>0){this.isHasMaxEvent=true}}};MxtTimeLine.prototype.initType=function(){var Q=this;if(this.items&&this.items.length>0){for(var H=0;H<this.items.length;H++){var K=this.items[H];var I=K.type;var B=parseInt(K.dateTime,10);var L=K.childItems;if(B<parseInt(this.timeStep[0],10)||B>parseInt(this.timeStep[1],10)){continue}var C=$("<span class='time_line_icon "+I+"'></span>");C.css({top:this.scaleArray[B]+5});(function(S,R){S.mouseenter(function(){$(this).addClass(R+"_over")}).mouseleave(function(){$(this).removeClass(R+"_over")})})(C,I);this.time_line_main.append(C);var F="<div id='"+this.id+"_contentDiv"+H+"' class='"+this.id+"_time_dialog hidden'><ul class='time_dialog'>";for(var G=0;G<L.length;G++){var P=L[G];if(G==0){F+="<li style='border:0px;padding-top:0px;' onclick="+this.action+"('"+P.id+"','"+(P.type==undefined?I:P.type)+"')>"}else{if(G==(L.length-1)){F+="<li style='padding-bottom:0px' onclick="+this.action+"('"+P.id+"','"+(P.type==undefined?I:P.type)+"')>"}else{F+="<li onclick="+this.action+"('"+P.id+"','"+(P.type==undefined?I:P.type)+"')>"}}F+="<div class='title'><em class='time_type_icon "+P.type+"_ico  margin_r_5' style='position: static;display: inline-block;'></em><span style='display:inline-block;line-height:16px;height:16px;vertical-align:2px;'>"+P.title+"</span></div>";F+="<div class='content'>"+P.content+"</div>";F+="<div class='clearfix'>";var N=90;var D=90;var A="";if(P.type=="task"){D=200;N=0;A="display:none;"}else{if(P.type=="meeting"){D=200;N=0;A="display:none;"}else{if(P.type=="plan"){D=220;N=0;A="display:none;"}else{if(P.type=="event"){D=200;N=0;A="display:none;"}else{if(P.type=="collaboration"){N=70;D=130}else{if(P.type=="edoc"){N=130;D=70}}}}}}if(P.account!=undefined){F+="<span class='left account' style='"+A+"width:"+N+"px; text-align:left;font-size:12px;' title='"+P.account+"'>"+P.account+"</span>"}if(P.type=="meeting"){F+="<span class='right' style='width:"+D+"px; text-align:right;font-size:12px;'>";if(P.account!=undefined){F+="<span class='margin_r_10'>"+P.account+"</span>"}F+=P.dateTime+"</span></div>"}else{F+="<span class='right' style='width:"+D+"px; text-align:right;font-size:12px;'>"+P.dateTime+"</span></div>"}F+="</li>"}F+="</ul>";F+="</div>";C.append($(F));var E=C.offset().left-260-6;var J=C.offset().top-8;var M=Q.id+"_contentDiv"+H;var O=Q.id+"_tooltip_"+H;(function(W,R,T,Y,V,X){var S;var U;$(W).mouseenter(function(){$("#"+Y).removeClass("hidden");if(U==undefined){U=$.tooltip({id:R,width:260,openAuto:false,openPoint:[V,X],htmlID:Y,direction:"RT",z_index:900})}(function(Z,a){$("#"+Z).mouseenter(function(){a.hideFlag=false;$(this).show()}).mouseleave(function(){a.hideFlag=true;$(this).hide()})})(R,T);S=setTimeout(function(){T.hideFlag=true;$("div.tooltip").hide();$("#"+R).show();if($.browser.msie){if($.browser.version=="6.0"){var a=$("#"+R).find(".time_dialog").eq(0);var Z=a.height();if(Z>300){a.height(300)}}}},500)}).mouseleave(function(){clearTimeout(S);setTimeout(function(){if(T.hideFlag){U.hide();$("#"+Y).addClass("hidden");T.hideFlag=false}},100)})})(C,O,Q,M,E,J)}}};MxtTimeLine.prototype.clearLine=function(){this.scaleArray=new Object();this.scaleHourArray=new Object();this.boxPadding=10;this.isHasMaxEvent=false;this.setDateTooltip=undefined;$("#"+this.id+"_editor").remove();$("#"+this.id+"_maximize").remove();$("#"+this.id+"_box").remove();$("#"+this.id+"_time_line_date_set").remove();$("#"+this.id+"_time_line_date_set_tooltip").remove();$("."+this.id+"_time_dialog").remove()};MxtTimeLine.prototype.reset=function(A){this.timeStep=A.timeStep==undefined?this.timeStep:A.timeStep;this.date=A.date==undefined?this.date:A.date;this.autoHeight=A.autoHeight==undefined?this.autoHeight:A.autoHeight;this.editClick=A.editClick==undefined?this.editClick:A.editClick;this.maxClick=A.maxClick==undefined?this.maxClick:A.maxClick;this.items=A.items==undefined?this.items:A.items;this.clearLine();this.initTimeLine();this.initType()};MxtTimeLine.prototype.getDate=function(){var B=this.date[0];var D=$("#"+this.id+"_time_line_date_set_mouth").val();var A=$("#"+this.id+"_time_line_date_set_day").val();var E=this.timeStep[0];var C=this.timeStep[1];return{year:B,mounth:D,day:A,fromTime:E,toTime:C}};MxtTimeLine.prototype.setTimeLineDate=function(A){this.year=A.year;this.mounth=A.mounth;this.day=A.day;if(this.mounth==undefined){this.mounth=A.date.getMonth()+1}if(this.day==undefined){this.day=A.date.getDate()}$("#"+this.id+"_date").empty().html(this.mounth+"-"+this.day);$("#"+this.id+"_time_line_date_set_mouth").empty();for(var B=1;B<13;B++){$("#"+this.id+"_time_line_date_set_mouth").append($("<option "+(B==this.mounth?"selected":"")+">"+B+"</option>"))}this.changeDate(parseInt(this.year,10),parseInt(this.mounth,10))};MxtTimeLine.prototype.changeDate=function(B,A){var C=this.MonHead[A-1];if(A==2&&this.IsPinYear(B)){C++}this.writeDay(C)};MxtTimeLine.prototype.writeDay=function(C){var B="";for(var A=1;A<(C+1);A++){B+="<option "+(A==parseInt(this.day,10)?"selected":"")+" value='"+A+"'> "+A+"</option>"}$("#"+this.id+"_time_line_date_set_day").replaceWith("<select class='left "+this.id+"_time_line_date_set_day' id='"+this.id+"_time_line_date_set_day'>"+B+"</select>")};MxtTimeLine.prototype.IsPinYear=function(A){return(0==A%4&&(A%100!=0||A%400==0))};MxtTimeLine.prototype.getDateObj=function(A){var I=this.items;var E=null;if(I&&I.length>0){for(var C=0;C<I.length;C++){var G=I[C];var D=G.childItems;if(D&&D.length>0){for(var B=0;B<D.length;B++){var F=D[B];var H=F.id;if(H&&H==A){E=F;break}}}}}return E};
(function(B){B.tiny=B.tiny||{};B.tiny.scrollbar={options:{axis:"y",wheel:40,scroll:true,lockscroll:true,size:"auto",sizethumb:"auto"}};B.fn.tinyscrollbar=function(C){var D=B.extend({},B.tiny.scrollbar.options,C);this.each(function(){B(this).data("tsb",new A(B(this),D))});return this};B.fn.tinyscrollbar_update=function(C){return B(this).data("tsb").update(C)};function A(K,U){var Q=this,H=K,R={obj:B(".viewport",K)},T={obj:B(".overview",K)},X={obj:B(".scrollbar",K)},O={obj:B(".track",X.obj)},L={obj:B(".thumb",X.obj)},P=U.axis==="x",N=P?"left":"top",F=P?"Width":"Height",J=0,C={start:0,now:0},M={},W=("ontouchstart" in document.documentElement)?true:false;function Y(){Q.update();I();return Q}this.update=function(Z){R[U.axis]=R.obj[0]["offset"+F];T[U.axis]=T.obj[0]["scroll"+F];T.ratio=R[U.axis]/T[U.axis];X.obj.toggleClass("disable",T.ratio>=1);O[U.axis]=U.size==="auto"?R[U.axis]:U.size;L[U.axis]=Math.min(O[U.axis],Math.max(0,(U.sizethumb==="auto"?(O[U.axis]*T.ratio):U.sizethumb)));X.ratio=U.sizethumb==="auto"?(T[U.axis]/O[U.axis]):(T[U.axis]-R[U.axis])/(O[U.axis]-L[U.axis]);J=(Z==="relative"&&T.ratio<=1)?Math.min((T[U.axis]-R[U.axis]),Math.max(0,J)):0;J=(Z==="bottom"&&T.ratio<=1)?(T[U.axis]-R[U.axis]):isNaN(parseInt(Z,10))?J:parseInt(Z,10);E()};function E(){var Z=F.toLowerCase();L.obj.css(N,J/X.ratio);T.obj.css(N,-J);M.start=L.obj.offset()[N];X.obj.css(Z,O[U.axis]);O.obj.css(Z,O[U.axis]);L.obj.css(Z,L[U.axis])}function I(){if(!W){L.obj.bind("mousedown",S);O.obj.bind("mouseup",G)}else{R.obj[0].ontouchstart=function(Z){if(1===Z.touches.length){S(Z.touches[0]);Z.stopPropagation()}}}if(U.scroll&&window.addEventListener){H[0].addEventListener("DOMMouseScroll",D,false);H[0].addEventListener("mousewheel",D,false)}else{if(U.scroll){H[0].onmousewheel=D}}}function S(Z){var a=parseInt(L.obj.css(N),10);M.start=P?Z.pageX:Z.pageY;C.start=a=="auto"?0:a;if(!W){B(document).bind("mousemove",G);B(document).bind("mouseup",V);L.obj.bind("mouseup",V)}else{document.ontouchmove=function(b){b.preventDefault();G(b.touches[0])};document.ontouchend=V}}function D(b){if(T.ratio<1){var Z=b||window.event,a=Z.wheelDelta?Z.wheelDelta/120:-Z.detail/3;J-=a*U.wheel;J=Math.min((T[U.axis]-R[U.axis]),Math.max(0,J));L.obj.css(N,J/X.ratio);T.obj.css(N,-J);if(U.lockscroll||(J!==(T[U.axis]-R[U.axis])&&J!==0)){Z=B.event.fix(Z);Z.preventDefault()}}}function G(Z){if(T.ratio<1){if(!W){C.now=Math.min((O[U.axis]-L[U.axis]),Math.max(0,(C.start+((P?Z.pageX:Z.pageY)-M.start))))}else{C.now=Math.min((O[U.axis]-L[U.axis]),Math.max(0,(C.start+(M.start-(P?Z.pageX:Z.pageY)))))}J=C.now*X.ratio;T.obj.css(N,-J);L.obj.css(N,C.now)}}function V(){B(document).unbind("mousemove",G);B(document).unbind("mouseup",V);L.obj.unbind("mouseup",V);document.ontouchmove=document.ontouchend=null}return Y()}}(jQuery));
(function(E){function B(F){var G=E.extend({data:[],value:null},F);this.data=G.data;this.value=G.value;this.onChange=G.onChange;this.originValue=this.value;function H(I){return I.replace(/[-[\]{}()*+?.,\\^$|#\s]/g,"\\$&")}this.filter=function(K,I){if(K==null){return[]}var J=new RegExp(H(I),"i");return E.grep(K,function(L){return J.test(L.label||L.value||L)})};return this}B.prototype.search=function(G,F){return this.filter(this.data,G)};B.prototype.get=function(G){var F=E.grep(this.data,function(H){return H.value==G});if(F.length>0){return F[0]}return null};B.prototype.getAll=function(F){return this.data};B.prototype.val=function(F){if(F){this.value=F;E(this).trigger("change",F)}return this.value};B.prototype.restore=function(){this.val(this.originValue)};B.prototype.destroy=function(F){this.data=null;this.value=null;E(this).unbind("change")};function C(F){this.id=Math.random()*10000;this.setting=E.extend({autoSize:false},F);this.onSelect=F.onSelect;this.ui=F.ui;this._cursor=null;this.cursor=function(I){if(I===null||I){this._cursor=I}return this._cursor};this.ds=F.ds;this.data=F.ds.getAll();var H=this;function G(){var J="autocomplete_popup";var I=E("#"+J);if(I.length==0){I=E("<div></div>").attr("id",J).addClass("autocomplete-popup").append(E("<div></div>").addClass("menu")).appendTo(E("body"));I.hide();I.mousedown(function(K){var L=E(K.target).closest(".item").length==0;if(!L){H.close()}else{setTimeout(function(){E(document).one("mousedown",function(M){if(I[0]!=M.target&&!E.contains(I,M.target)){H.close()}})},1)}setTimeout(function(){clearTimeout(I.closing)},13);E(H).trigger("clicked")})}if(E("#"+J+"_mask").length==0){E("<iframe></iframe>").attr("id",J+"_mask").addClass("autocomplete-popup-mask").appendTo(E("body"))}E(this).unbind("moveFirst").bind("moveFirst",function(L,K){H.moveFirst()}).unbind("moveNext").bind("moveNext",function(L,K){H.moveNext()}).bind("movePrevious",function(L,K){H.movePrevious()});return I}this.container=G();this.moveFirst=function(){H.cursor(E(H.container).find("div.menu div:first-child"));H.highlight()};this.moveNext=function(){if(H.cursor()==null){H.moveFirst();return }var I=H.cursor().next();if(I.length>0){H.cursor(I);H.highlight()}};this.movePrevious=function(){if(H.cursor()==null){H.moveFirst();return }var I=H.cursor().prev();if(I.length>0){H.cursor(I);H.highlight()}};this.highlight=function(){E(".item-selected").removeClass("item-selected");H.cursor().addClass("item-selected")};this.calcPosition=function(){var V=300;var M=E(document).scrollTop();var Q=document.documentElement.clientWidth+E(document).scrollLeft();var O=document.documentElement.clientHeight+M;if(V>O){V=O}var U=E(H.ui);var S=U.offset().top-1;var K=U.outerHeight();var T={left:0,top:0,width:0,height:0};T.left=U.offset().left;T.width=U.width();var R=U.next('input[name="acToggle"]').length>0;if(R){T.width=T.width+U.next('input[name="acToggle"]').outerWidth()-3}var J=H.container;var N=S+K;var I=J.height("").outerHeight();var W=I;if(I>V){I=V}if((N+I>O)&&(N>(O/2))){N=S-I-2}if(N<M){N=M}if(N<0){N=0;if(I<S){N=S-I}I=S-N}if(N+I+5<S){N=S-I-5}if(N+I>S+K){N=S+K}if(N+I>O){I=O-N-10}if(W>I){T.scroll=true}T.height=I;T.top=N;if(H.setting.autoSize){var P=0;E.each(H.data,function(Y,Z){var X=Z.label.length;if(X>P){P=X}});var L=P*8+24;T.width=T.width>L?T.width:L}return T}}C.prototype.refresh=function(){var G=this.container.find("div.menu");G.empty();var H=this;var F=this.ds.value;E.each(this.data,function(K,M){var L=F&&(M.value==F.value)?" item-selected":"";var N=typeof M.title=="undefined"?"":M.title.replace(/<script>/g,"");var J=typeof M.label=="undefined"?"":M.label.escapeHTML(true);var I=E("<div></div>").html(J).data("item",M).attr("title",N).addClass("item"+L).hover(function(O){H.cursor(E(this));H.highlight()}).mousedown(function(O){H.select(O)}).appendTo(G);if(L){H.cursor(I)}});if(this.cursor()==null){this.moveFirst()}this.highlight();if(this.data.length==0){G.addClass("empty-menu")}else{G.removeClass("empty-menu")}};C.prototype.search=function(F){this.data=this.ds.search(F);this.cursor(null);this.refresh()};C.prototype.hide=function(F){E("#autocomplete_popup_mask").hide();this.container.hide()};C.prototype.show=function(){var J=this;var I=this.calcPosition();var G=this.container;if(I.scroll){G.css("overflow-y","auto").css("overflow-x","hidden").css("height",I.height+"px")}else{G.css("height","auto")}G.css({width:I.width-1+"px",top:I.top+1+"px",left:I.left+1+"px"});var F=G.height();E("#autocomplete_popup_mask").css({width:I.width+2+"px",top:I.top-0+"px",left:I.left-0+"px",height:F+"px"}).show();E(G.parents()).scroll(function(){J.hide()});var H=E(J.ui).offset().top;setTimeout(function(){var K=E(J.ui).offset().top;if(K!=H){J.hide()}},500);this.container.show()};C.prototype.toggle=function(){this.container.toggle()};C.prototype.close=function(F){this.hide()};C.prototype.visible=function(){return E(this.container).is(":visible")};C.prototype.select=function(F){var G=this.cursor();if(G!=null){this.ds.val(G.data("item"))}E(this.ui.ui).focus()};C.prototype.destroy=function(F){E(this).unbind("moveFirst").unbind("movePrevious").unbind("moveNext")};var A={isClickPopup:false};function D(H){var G=false;var L=this.keyCode;var K=E(H.ui);var M=this;var J=H.value;this.ds=new B({data:H.data,value:J});E(this.ds).unbind("change").bind("change",function(P,O){if(O){var N=K.data("value")==O.value;D.updateUi(K,O,N);if(H.onSelect){H.onSelect(O)}}});var F=new C(E.extend(H,{ds:this.ds,input:this}));var I;K.unbind("keyup").bind("keyup",function(N){switch(N.keyCode){case L.PAGE_UP:break;case L.PAGE_DOWN:break;case L.UP:if(M.popup.visible()){E(F).trigger("movePrevious")}else{M.popup.refresh();M.popup.show()}N.preventDefault();break;case L.DOWN:if(M.popup.visible()){E(F).trigger("moveNext")}else{M.popup.refresh();M.popup.show()}N.preventDefault();break;case L.ENTER:case L.NUMPAD_ENTER:if(M.popup.visible()){I=true;F.select();F.close();N.preventDefault()}case L.TAB:break;case L.ESCAPE:F.close(N);break;case L.CONTROL:F.close(N);break;case L.ALT:F.close(N);break;default:clearTimeout(M.searching);var O=E(this).val();M.searching=setTimeout(function(){F.search(O);F.show()},150);break}}).keypress(function(N){if(I){I=false;N.preventDefault()}}).unbind("click").bind("click",function(N){F.refresh();F.show()}).unbind("blur").bind("blur",function(N){E(this).val(E(this).data("label"));if(A.isClickPopup){A.isClickPopup=false;return }A.isClickPopup=false;F.close();if(G){F.select()}M.destroy()});E(F).unbind("clicked").bind("clicked",function(N){A.isClickPopup=true});E(K.parents()).scroll(function(){F.close()});this.ui=K;this.popup=F}D.prototype.destroy=function(F){this.popup.destroy(F);this.ds.destroy(F)};D.updateUi=function(F,H,G){F.val(H.label).attr("title",H.title).data("value",H.value).data("label",H.label);if(!G){F.trigger("changed",H)}};D.prototype.keyCode={ALT:18,BACKSPACE:8,CAPS_LOCK:20,COMMA:188,COMMAND:91,COMMAND_LEFT:91,COMMAND_RIGHT:93,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,MENU:93,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38,WINDOWS:91};E.autocomplete=function(G,H){var K=E(G);if(typeof (G)=="string"){K=E("#"+G)}var J=K[0].nodeName.toLowerCase();if(H.visibility!="undefined"){if(J=="select"){var F=E("#"+K.attr("id")+"_txt");var I=F.next('input[name="acToggle"]');if(H.visibility){F.show();if(E.browser.mozilla){I.css("display","inline-block")}I.show()}else{F.hide();I.hide()}}}};E.fn.autocomplete=function(J){var V=false;if(this.length==0){return }var Q={value:"",label:""};var I=this[0].nodeName.toLowerCase();var Y=true;if(J&&J.visibility!="undefined"){Y=J.visibility}function F(c,d,e){if(!V){c.trigger(d,e)}}function U(c){if(b&&b.length>0){c.removeAttr("disabled")}else{c.attr("disabled",true)}}function H(c){var d=[];c.find("option").each(function(){var f=E(this);var e=f.text();var g=f.attr("title");if(g==undefined){g=e}d.push({value:f.val(),label:e,title:g})});return d}function O(c){var d=c.find("option:selected");d=(d.length>0)?d:c.find("option:first");if(d.length>0){return{value:d.val(),label:d.text()}}else{return{value:"",label:""}}}if(I=="select"){var S=this;var N=this.data("binding");if(!N){var T=this.width();var Z=this.attr("id")!=undefined?('id="'+this.attr("id")+'_txt" '):"";N=E("<input "+Z+'type="text" widthVal="'+T+'"/>').insertAfter(this);N.width(T-(N.outerWidth(true)-N.width()));if(Y==false){N.hide()}N.data("binding",S);S.data("binding",N);S.change(function(f,e){if(e){return }var c=E(this);var g=O(c);var d=N.data("value")==g.value;D.updateUi(N,g,d);N.autocomplete({data:H(c),value:O(c)})});N.bind("changed",function(d,c){if(J.valueChange){J.valueChange(N)}S.val(c.value);F(S,"change",c)})}var a=O(this);this.hide();if(J&&J.value){if(J.value!=a.value){S.val(J.value);a=O(this)}}F(N,"change",a);D.updateUi(N,a,true);if(J.valueChange){J.valueChange(N)}var L=E.extend({data:H(this)},J);return N.autocomplete(L)}if(I!="input"){return }var W=E(this);this.showButton=true;var b=this.data("data");if(J){if(J.data){b=J.data}if(J.value){this.data("value",J.value)}}if(this.showButton){var P=this.next('input[name="acToggle"]').length>0;if(!P){var K=_ctxPath;if(!K){K=""}var X="background-image:url('"+K+"/common/images/desc.gif');background-repeat:no-repeat;background-color: #ececec;background-position:center;width:"+13+"px;height:22px;border:1px #d1d1d1 solid;vertical-align:middle";var G=E('<input type="button" name="acToggle" tabindex="-1" onclick="$(this.previousSibling).trigger(\'focus\').trigger(\'click\');" style="'+X+'"/>');if(Y==false){G.hide()}this.after(G);var M=0;if(E.browser.msie&&parseInt(E.browser.version,10)<9){M=parseInt(this.attr("widthVal"),10)-G.outerWidth(true)-5;if(M<=0){var N=this;setTimeout(function(){var f=E("select",N.parent());if(f.length>0){var e=f.css("display");f.css("display","");var d=f.width();f.css("display",e);var c=d-G.outerWidth(true)-3;N.width(c)}},300)}else{this.width(M)}}else{M=this.width()-(this.outerWidth(true)-this.width())-G.outerWidth(true)-2;this.width(M)}}}U(this);var R=E.extend({data:b,ui:W,value:W.data("value"),autoSize:false},J);this.focus(function(){this.select();new D(R)})}})(jQuery);
/**************************************** 消息通用(A8/精灵/IM) ****************************************/

/**
 * 消息定义
 */
function CLASS_MESSAGE(id, title, referenceId, userHistoryMessageId, content, messageType, senderId, senderName, receiverId, receiverName, creationDateTime, messageLink, linkOpenType, atts, importantLevel, messageCategory){
    this.id = id;
    this.title = title;
    this.referenceId = referenceId;
    this.userHistoryMessageId = userHistoryMessageId;
    this.content = content;
    this.messageType = messageType;
    this.senderId = senderId;
    this.senderName = senderName;
    this.receiverId = receiverId;
    this.receiverName = receiverName;
    this.creationDateTime = creationDateTime;
    this.messageLink = messageLink;
    this.linkOpenType = linkOpenType;
    this.atts = atts;
    this.importantLevel = importantLevel;
    this.messageCategory = messageCategory;
}

/**
 * 显示消息
 */
function showMessage(messagePer, messageSysList, allMsgCountStr, fromType){
	var handleWin = getHandleWin(fromType);
	//系统消息
	if(messageSysList != null && messageSysList.length > 0){
		var allLength = messageSysList.length;
		var _projectleaveProperties = new Properties();
		var _deptleaveProperties = new Properties();
		var _spaceleaveProperties = new Properties();
		var _calleaveProperties = new Properties();
		var _sysList  = new Array();
		//message.link.department.leaveWord
		//message.link.project.leaveWord 
		//message.link.cal.reply
		for(var i = 0;i<messageSysList.length;i++){
			var _msg = messageSysList[i];
			var _link = _msg.messageLink;
			if(_link!=null && _link!=''){
				var strs = _link.split("|");
				if(strs[0]=='message.link.department.leaveWord'){
		        	if(_deptleaveProperties.containsKey(strs[1])){
		        		_deptleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_deptleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.space.leaveWord'){
					if(_spaceleaveProperties.containsKey(strs[1])){
		        		_spaceleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_spaceleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.project.leaveWord'){
					if(_projectleaveProperties.containsKey(strs[1])){
						_projectleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_projectleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.cal.reply'){
					if(_calleaveProperties.containsKey(strs[1])){
						_calleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_calleaveProperties.put(strs[1], _list);
		        	}
				}else{
					_sysList[_sysList.length]=_msg;
				}
			}else{
				_sysList[_sysList.length]=_msg;
			}

		}
		//alert(_deptleaveProperties.size()+'--'+_projectleaveProperties.size()+'--'+_calleaveProperties.size()+'--'+_sysList.length)
		if((_sysList != null && _sysList.length > 0) || _projectleaveProperties.size()>0 || _deptleaveProperties.size()>0 || _spaceleaveProperties.size()>0 || _calleaveProperties.size()>0){
			/*
		  if(handleWin.isSysMessageWindowEyeable){
				var sysMessageDIVObj = handleWin.$("#sysMsgContentDiv");
				var countSpanObj = handleWin.$("#sysMsgCountSpan");
				if(sysMessageDIVObj.length > 0){
					var countMessages1 = handleWin.document.getElementsByName('countMessages');
					var countSysMessages1 = handleWin.document.getElementsByName('countSysMessages');
					var _length1 = countMessages1.length + countSysMessages1.length;
					
					var systemMsgContent = sysMessageListToHTML(_sysList, true, fromType,1);
					var _projectContent = leaveWordMessageListToHTML(_projectleaveProperties, true, fromType,1);
					var _deptContent = leaveWordMessageListToHTML(_deptleaveProperties, true, fromType,2);
					var _spaceContent = leaveWordMessageListToHTML(_spaceleaveProperties, true, fromType,4);
					var _calContent = leaveWordMessageListToHTML(_calleaveProperties, true, fromType,3);
//					sysMessageDIVObj.html(systemMsgContent+_projectContent+_deptContent+_spaceContent+_calContent+sysMessageDIVObj.html());
					sysMessageDIVObj.prepend(systemMsgContent+_projectContent+_deptContent+_spaceContent+_calContent);
					try{
						var countMessages = handleWin.document.getElementsByName('countMessages');
						var countSysMessages = handleWin.document.getElementsByName('countSysMessages');
						var _length = countMessages.length + countSysMessages.length;
						var originalCount = parseInt(countSpanObj.text(), 10);
						var allCount = allLength+originalCount;
						countSpanObj.text(allCount);
						//var originalNewCount = _projectleaveProperties.size()+_deptleaveProperties.size()+_calleaveProperties.size()+_sysList.length + originalCount;
						if(_length1 < 5){
							sysMessageDIVObj.height(getHeight(_length));
						}
						DivSetVisible(true, fromType);
					}catch(e){
						
					}
				}
			}else{
				var msgObj = showSysMessage(_sysList, allLength, fromType,_projectleaveProperties,_deptleaveProperties,_spaceleaveProperties,_calleaveProperties);
				ShowMessageWindow(msgObj, fromType);
				handleWin.isSysMessageWindowEyeable = true;
			}
			*/
			showSysMessage(_sysList, allLength, fromType,_projectleaveProperties,_deptleaveProperties,_spaceleaveProperties,_calleaveProperties);
			handleWin.playMessageRadio();
			if(fromType == "a8"){
				getCtpTop().startActionTitle();
			}
		}
	}
	
	//在线消息－按发送顺序读出
	if(messagePer){
		var key = messagePer.jid.substring(0, messagePer.jid.indexOf('@'));
	  	if(msgProperties.containsKey(key)){
			msgProperties.get(key).add(messagePer);
	  	}else{
			var thisArrayList = new ArrayList();
			thisArrayList.add(messagePer);
			msgProperties.put(key, thisArrayList);
	  	}
	  	if(msgProperties.size() > 0){
	  		clearTimeoutUc();
	  		$('#ucMsg_point').show();
	  		setTimeout(function () {
	  			checkImgs();
	  		},5000);
			if(handleWin.isPerMessageWindowEyeable){
				var perMessageDIVObj = handleWin.$("#personMsgContentDiv");
				if(perMessageDIVObj.length > 0){
					var personMsgContent = perMessageListToHTML(true, fromType);
//					perMessageDIVObj.html(personMsgContent + perMessageDIVObj.html());
					perMessageDIVObj.prepend(personMsgContent);
					try{
						var height = getPerMessageHeight();
						perMessageDIVObj.height(height);
						DivSetVisible(true, fromType);
					}catch(e){}
				}
			}else{
				var msgObj = showPerMessage(fromType, false);
				ShowMessageWindow(msgObj, fromType);
				handleWin.isPerMessageWindowEyeable = true;
			}
			
			handleWin.playMessageRadio();
			if(fromType == "a8"){
				getCtpTop().startActionTitle();
			}
	  	}
	}
}
var timeerObj = null;
function clearTimeoutUc() { 
	if (timeerObj != null) { 
		clearTimeout(timeerObj);
	}
}
function checkImgs () {
  if(msgProperties.size() > 0){
  	// 将跳动改成显示和隐藏
  	if ($('#ucMsg_point').css('display') != "none") {
  		$('#ucMsg_point').hide();
  		timeerObj = setTimeout(function () { 
  			checkImgs();
  		},600);
  	} else { 
  		$('#ucMsg_point').show();
  		timeerObj = setTimeout(function () { 
  			checkImgs();
  		},600);
  	}
  }else{
    clearTimeoutUc();
  }
//	if ($('#ucMsg_point').attr('style').indexOf('block') > -1) {
//		$('#ucMsg').attr('style','bottom:5px;padding-bottom:5px;');
//		setTimeout(function () {
//			$('#ucMsg').attr('style','');
//			setTimeout(function () {
//				$('#ucMsg').attr('style','bottom:5px;padding-bottom:5px;');
//				setTimeout(function () {
//					$('#ucMsg').attr('style','');
//				},100);
//			},100);
//			setTimeout(function (){
//				checkImgs();
//			},5000);
//    },100);
//	}
}

function showImg () {
	alert($('#ucMsg_point').attr('style'));
}

/**
 * 消息显示
 */
function ShowMessageWindow(ClassMessageObj, fromType){
	var handleWin = getHandleWin(fromType);
	switch(ClassMessageObj.messageType){
		case 1:
				handleWin.$("#SysMsgContainerTR").show();
				handleWin.$("#SysMsgContainer").html(ClassMessageObj.content);
				break;
		case 3:
				handleWin.$("#PerMsgContainerTR").show();
				handleWin.$("#PerMsgContainer").html(ClassMessageObj.content);
				break;
	}
 	DivSetVisible(true, fromType);
}

/**
 * 显示系统消息
 */
function showSysMessage(msgList, allMsgCountStr, fromType,_projectleaveProperties,_deptleaveProperties,_spaceleaveProperties,_calleaveProperties){
	if((msgList == null || msgList.length < 1) && (_projectleaveProperties == null || _projectleaveProperties.size < 1) && (_deptleaveProperties == null || _deptleaveProperties.size < 1) && (_spaceleaveProperties == null || _spaceleaveProperties.size < 1) && (_calleaveProperties == null || _calleaveProperties.size() < 1)){
		return;
	}
	var _pdc = _projectleaveProperties.size()+_deptleaveProperties.size()+_spaceleaveProperties.size()+_calleaveProperties.size();
	var count = msgList.length+_pdc;
	var height = getHeight(count);
	var systemMsgContent = sysMessageListToHTML(msgList, false, fromType,_pdc);
	var _projectContent = leaveWordMessageListToHTML(_projectleaveProperties, false, fromType,1);
	var _deptleaveContent = leaveWordMessageListToHTML(_deptleaveProperties, false, fromType,2);
	var _spaceleaveContent = leaveWordMessageListToHTML(_spaceleaveProperties, false, fromType,4);
	var _calleaveContent = leaveWordMessageListToHTML(_calleaveProperties, false, fromType,3);
	var handleWin = getHandleWin(fromType);
  handleWin.$.prependNewSysMsg(systemMsgContent + _projectContent + _deptleaveContent + _spaceleaveContent + _calleaveContent);
  handleWin.$.sysMessageEventBind();
  handleWin.$.updateSysMessageNum(count, count);
  if(getCtpTop().openFrom.toLowerCase() != "ucpc"){
	  handleWin.$("#message").click();
  }
  /*
	var strBuffer = new StringBuffer();
	strBuffer.append("<table width='280' id='sysTable' border='0' class='msgborder' cellspacing='0' cellpadding='0'>");
	strBuffer.append("<tr>");
	strBuffer.append("<td height='100%' class='msgContentSys'>");
	strBuffer.append("<div class='msgContentDivHeader'>");
  	strBuffer.append(message_header_system_label).append("(<span id='sysMsgCountSpan'>").append(allMsgCountStr).append("</span>").append(message_header_unit_label).append(")");
  	strBuffer.append("</div>");
	strBuffer.append("<div id='sysMsgContentDiv' style='width:100%;height:").append(height).append(";overflow-x:hidden;overflow-y:auto;'>");
	strBuffer.append(systemMsgContent+_projectContent+_deptleaveContent+_spaceleaveContent+_calleaveContent);
	strBuffer.append("</div>");
	strBuffer.append("</td>");
	strBuffer.append("</tr>");
	strBuffer.append("</table>");
	var MSG = new CLASS_MESSAGE("", "", "", "", strBuffer.toString(), 1);
	strBuffer.clear();
	return MSG;
	*/
}
/**
 * 将留言板/日程事件消息转换为HTML type:(1项目 2部门 3日程 4空间)
 */
function leaveWordMessageListToHTML(leaveProperties, printHRFlag, fromType,type){
  var sysMsgStrBuffer = new StringBuffer();
  var handleWin = getHandleWin(fromType);
  var _keys = leaveProperties.keys();
  var _length = _keys.size();
  for(var j = 0; j < _length; j ++){
    var key = _keys.get(j);
    var msgList = leaveProperties.get(key);
    var _msg = msgList.get(0);
    var referenceId = _msg.referenceId;
    var userHistoryMessageId = _msg.userHistoryMessageId;
    var datetime = new Date(parseInt(_msg.creationDateTime, 10)).format("MM-dd HH:mm");
    var countStr = "count" + _msg.referenceId;
    var tdStr = "td" + _msg.referenceId;
    var timeStr = "time" + _msg.referenceId;
    var deptNameSpan = "deptNameSpan"+_msg.referenceId;
    var countSpan = getCtpTop().document.getElementById(countStr);
    var content = _msg.content;
    var deptName ='';
    var label = handleWin.v3x.getMessage("V3XLang.leaveword");
    if(type == 1){
      deptName = getProjectName(referenceId);
    }
    if(type == 2){
      deptName = getDepartmentName(referenceId);  
    }
    if(type == 3){
      var deptNameTemp = getEventName(referenceId);
      label = handleWin.v3x.getMessage("V3XLang.reply");
      deptName  = "&lt;"+deptNameTemp+"&gt;";
    }
    if(type == 4){
      deptName = getSpaceName(referenceId);
    }
    var splitedArray = _msg.messageCategory.split("|");
    var msgCategoryValue = splitedArray[0];
    sysMsgStrBuffer.append("<div id=\"sysMsgDiv").append(userHistoryMessageId).append("\" class=\"msg_remove\" msgCategory=\"").append(msgCategoryValue).append("\"").append(" userHistoryMessageId=\"").append(userHistoryMessageId).append("\"").append(" >");
    sysMsgStrBuffer.append("<div class=\"msg_system_box_main\" style=\"cursor:default\" ");
    if(_msg.messageLink){
      if(fromType == "a8"){
        sysMsgStrBuffer.append(" typeAttr='leaveWord' countAttrId='"+referenceId+"'  onclick='getCtpTop().openDocument(\"").append(_msg.messageLink).append("\", \"").append(_msg.linkOpenType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
      } else {
        var link = _msg.messageLink;
        var strs = link.split("|");
        var linkType = messageLinkConstants.get(strs[0]);
        linkType = linkType.substring(7, linkType.length);
          if(linkType){
              var l = 1;
          while(true){
            var param = strs[l];
            if(!param){
              break;
            }
            var regEx = eval("messageRegEx_" + (l - 1));
            linkType = linkType.replace(regEx, param);
            l ++;
          }
          sysMsgStrBuffer.append(" onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
        }
      }
    }
    sysMsgStrBuffer.append(" >");
    sysMsgStrBuffer.append("<div class=\"left " + "msg_ca_" + msgCategoryValue +"\"></div>");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right\"");
    if(_msg.messageLink){
      sysMsgStrBuffer.append(" style=\"cursor:pointer\"");
    }
    sysMsgStrBuffer.append(">");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right_main\">");
    sysMsgStrBuffer.append(_msg.content);
    sysMsgStrBuffer.append("<div class=\"msg_ico_1\"></div><div title=\"" + $.i18n("portal.message.ignore") + "\" class=\"msg_ico_2\" style=\"cursor:pointer\" msgCategory=\"").append(_msg.messageCategory).append("\"").append("></div></div>");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right_info\">");
    var senderName = "";
    sysMsgStrBuffer.append("<div title='" + senderName + "' class=\"left\">");
    sysMsgStrBuffer.append("</div><div class=\"msg_date right\">");
    sysMsgStrBuffer.append(datetime);
    sysMsgStrBuffer.append("</div></div></div><div class=\"clear\"></div></div><div class=\"msg_line\"></div></div>");
    handleWin.$.showMsgByUnreadCategory(_msg.messageCategory, 1);
    /*
    if(countSpan){
      var tdObj = getCtpTop().document.getElementById(tdStr);
      var timeObj = getCtpTop().document.getElementById(timeStr);
      var deptNameObj = getCtpTop().document.getElementById(deptNameSpan);
      var tt = parseInt(countSpan.getAttribute('title'))+msgList.size();
      countSpan.innerHTML = tt;
      countSpan.setAttribute('title',tt);
      tdObj.innerHTML = "<div class='default-a' style='text-decoration: none;width:240px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+content+"</div>";
      timeObj.innerHTML = datetime;
      deptNameObj.setAttribute('title',deptName);
      deptNameObj.innerHTML = deptName;
      
    }else{
      sysMsgStrBuffer.append("<table width='100%' id='sysMsgTable" + userHistoryMessageId+"'");
      if(_msg.messageLink){
        if(fromType == "a8"){
          sysMsgStrBuffer.append(" class='hand' typeAttr='leaveWord' countAttrId='"+referenceId+"'  onclick='getCtpTop().openDocument(\"").append(_msg.messageLink).append("\", \"").append(_msg.linkOpenType).append("\");getCtpTop().updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
        }else{
          var link = msgList[i].messageLink;
          var strs = link.split("|");
          var linkType = messageLinkConstants.get(strs[0]);
          linkType = linkType.substring(7, linkType.length);
            if(linkType){
                var l = 1;
            while(true){
              var param = strs[l];
              if(!param){
                break;
              }
              var regEx = eval("messageRegEx_" + (l - 1));
              linkType = linkType.replace(regEx, param);
              l ++;
            }
            sysMsgStrBuffer.append(" class='hand' onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
          }
        }
      }
      sysMsgStrBuffer.append("><input type='hidden' name='countMessages'/>");
      sysMsgStrBuffer.append("<tr>");
        sysMsgStrBuffer.append("<td class='default-a' style='text-decoration: none;font-weight: bold;'>");
//        sysMsgStrBuffer.append("<span title='"+deptName+"' id='"+deptNameSpan+"'>"+deptName.getLimitLength(20,'...')+"</span>");
        sysMsgStrBuffer.append("<span title='"+deptName+"' id='"+deptNameSpan+"'>"+deptName+"</span>");
        sysMsgStrBuffer.append(label+"(<span name='leavewordCount' id='"+countStr+"' title='"+msgList.size()+"'>"+msgList.size()+"</span>)");
        sysMsgStrBuffer.append("</td>");
        sysMsgStrBuffer.append("<td id='"+timeStr+"' align='right' nowrap='nowrap' class='default-a' style='text-decoration: none;'>");
        sysMsgStrBuffer.append(datetime);
        sysMsgStrBuffer.append("</td>");
      sysMsgStrBuffer.append("</tr>");
      sysMsgStrBuffer.append("<tr>");
      sysMsgStrBuffer.append("<td id='"+tdStr+"' colspan='2'><div class='default-a' style='text-decoration: none;width:240px;overflow:hidden;text-overflow:ellipsis;'>");
      sysMsgStrBuffer.append(content);
      sysMsgStrBuffer.append("</div></td>");
      sysMsgStrBuffer.append("</tr>");
      sysMsgStrBuffer.append("</table>");
      if(j < _length - 1 || printHRFlag){
        sysMsgStrBuffer.append("<hr size='1' class='border-top' style='padding-top:8px; border-left:0;border-right:0;' />");
      }
    }
    */
  }
  
  var resultStr = sysMsgStrBuffer.toString();
  sysMsgStrBuffer.clear();
  return resultStr;
}
/**
 * 显示在线消息
 */
function showPerMessage(fromType, isNotice){
	var count = 1;
	var personMsgContent = "";
	var height = "30";
	if(!isNotice){
		count = msgProperties.size();
		if(count < 1){
			return;
		}
		height = getPerMessageHeight();
		personMsgContent = perMessageListToHTML(false, fromType);
	}
  	var strBuffer = new StringBuffer();
  	strBuffer.append("<table id='perTable' width='280' border='0' cellspacing='0' cellpadding='0' class='msgborder'>");
  	strBuffer.append("<tr>");
  	strBuffer.append("<td height='100%' class='msgContentPerson'>");
  	strBuffer.append("<div class='msgContentDivHeader'>");
  	strBuffer.append(message_header_person_label).append("(<span id='perMsgCountSpan'>" + count + "</span>").append(message_header_unit_label).append(")");
  	strBuffer.append("</div>");
  	strBuffer.append("<div id='personMsgContentDiv' style='width:100%;height:").append(height).append("px;overflow:auto;overflow-x:hidden;'>");
  	strBuffer.append(personMsgContent);
  	strBuffer.append("</div>");
  	strBuffer.append("</td>");
  	strBuffer.append("</tr>");
  	strBuffer.append("</table>");
  	var MSG = new CLASS_MESSAGE("", "", "", "", strBuffer.toString(), 3);
  	strBuffer.clear();
  	return MSG;
}

function showPerNotice(random, content, fromType){
	try{
	    var msgStrBuffer = new StringBuffer();
		msgStrBuffer.append("<table width='100%' border='0' cellspacing='0' cellpadding='0' id='" + random + "'>");
		msgStrBuffer.append("<tr valign='middle' class='hand' onclick='removeMsgFromBox(\"person\", \"" + random + "\", \"\", \"" + fromType + "\");'>");
		msgStrBuffer.append("<td align='left' class='messageHeaderContent' colspan='3' title='" + content + "'>" + content.getLimitLength(25, "...") + "</td>");
		msgStrBuffer.append("</tr>");
		msgStrBuffer.append("</table>");
		
		var handleWin = getHandleWin(fromType);
		if(handleWin.isPerMessageWindowEyeable){
			msgStrBuffer.append("<hr size='1' class='border-top margin_tb_5' style='border-left:0;border-right:0;' />");
			handleWin.$("#personMsgContentDiv").prepend(msgStrBuffer.toString());
			var height = getPerMessageHeight();
			handleWin.$("#personMsgContentDiv").height(height);
			var count = msgProperties.size() + noticeProperties.size();
			handleWin.$("#perMsgCountSpan").text(count);
			DivSetVisible(true, fromType);
		}else{
			var msgObj = showPerMessage(fromType, true);
			ShowMessageWindow(msgObj, fromType);
			handleWin.$("#personMsgContentDiv").prepend(msgStrBuffer.toString());
			handleWin.isPerMessageWindowEyeable = true;
		}
		
		msgStrBuffer.clear();
		
		handleWin.playMessageRadio();
		if(fromType == "a8"){
			getCtpTop().startActionTitle();
		}
	}catch(e){}
}

/**
 * 将系统消息转换为HTML
 */
function sysMessageListToHTML(msgList, printHRFlag, fromType,_pdc){
  var sysMsgStrBuffer = new StringBuffer();
  for (var i = 0; i < msgList.length; i++) {
    var isSwichSkinStyle = false;
    if(msgList[i].referenceId == "141322537970846464" || msgList[i].referenceId == "8950558293947007546"){
      isSwichSkinStyle = true;
    }
    var userHistoryMessageId = msgList[i].userHistoryMessageId;
    var datetime = new Date(parseInt(msgList[i].creationDateTime, 10)).format("MM-dd HH:mm");
    var splitedArray = msgList[i].messageCategory.split("|");
    var msgCategoryValue = splitedArray[0];
    sysMsgStrBuffer.append("<div id=\"sysMsgDiv").append(userHistoryMessageId).append("\" class=\"msg_remove\" msgCategory=\"").append(msgCategoryValue).append("\"").append(" userHistoryMessageId=\"").append(userHistoryMessageId).append("\"").append(" >");
    sysMsgStrBuffer.append("<div class=\"msg_system_box_main\" style=\"cursor:default\" ");
    if(msgList[i].messageLink){
      if(fromType == "a8"){
        sysMsgStrBuffer.append(" onclick='getCtpTop().openDocument(\"").append(msgList[i].messageLink).append("\", \"").append(msgList[i].linkOpenType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
      } else {
        var link = msgList[i].messageLink;
        var strs = link.split("|");
        var linkType = messageLinkConstants.get(strs[0]);
        linkType = linkType.substring(7, linkType.length);
        if(linkType){
          var l = 1;
          while(true){
            var param = strs[l];
            if(!param){
              break;
            }
            var regEx = eval("messageRegEx_" + (l - 1));
            linkType = linkType.replace(regEx, param);
            l ++;
          }
          sysMsgStrBuffer.append(" onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
        }
      }
    } else {
      if(isSwichSkinStyle){
        sysMsgStrBuffer.append(" onclick='updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\");getCtpTop().$.switchAccount(\"" + msgList[i].referenceId + "\");'");
      } else {
        sysMsgStrBuffer.append(" onclick='updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
      }
    }
    sysMsgStrBuffer.append(" >");
    sysMsgStrBuffer.append("<div class=\"left " + "msg_ca_" + msgCategoryValue +"\"></div>");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right\"");
    if(msgList[i].messageLink){
      sysMsgStrBuffer.append(" style=\"cursor:pointer\"");
    }
    sysMsgStrBuffer.append(">");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right_main\">");
    sysMsgStrBuffer.append(msgList[i].content);
    sysMsgStrBuffer.append("<div class=\"msg_ico_1\"></div><div title=\"" + $.i18n("portal.message.ignore") + "\" class=\"msg_ico_2\" style=\"cursor:pointer\" msgCategory=\"").append(msgList[i].messageCategory).append("\"").append("></div></div>");
    sysMsgStrBuffer.append("<div class=\"msg_system_main_right_info\">");
    var senderName = "";
    if (msgList[i].senderId != '-1') {
      senderName = msgList[i].senderName + msgList[i].accountShortName;
    } else {
      senderName = msgList[i].senderName;
    }
    sysMsgStrBuffer.append("<div title='" + senderName + "' class=\"left\">");
    sysMsgStrBuffer.append(senderName.getLimitLength(12, "..."));
    sysMsgStrBuffer.append("</div><div class=\"msg_date right\">");
    sysMsgStrBuffer.append(datetime);
    sysMsgStrBuffer.append("</div></div></div><div class=\"clear\"></div></div><div class=\"msg_line\"></div></div>");
    var handleWin = getHandleWin(fromType);
    handleWin.$.showMsgByUnreadCategory(msgList[i].messageCategory, 1);
    /*
    sysMsgStrBuffer.append("<table width='100%' id='sysMsgTable" + userHistoryMessageId + "'><input type='hidden' name='countSysMessages'/>");
    sysMsgStrBuffer.append("<tr valign='top'");
    if(msgList[i].messageLink){
      if(fromType == "a8"){
        sysMsgStrBuffer.append(" class='hand' onclick='getCtpTop().openDocument(\"").append(msgList[i].messageLink).append("\", \"").append(msgList[i].linkOpenType).append("\");getCtpTop().updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
      }else{
        var link = msgList[i].messageLink;
        var strs = link.split("|");
        var linkType = messageLinkConstants.get(strs[0]);
        linkType = linkType.substring(7, linkType.length);
          if(linkType){
              var l = 1;
          while(true){
            var param = strs[l];
            if(!param){
              break;
            }
            var regEx = eval("messageRegEx_" + (l - 1));
            linkType = linkType.replace(regEx, param);
            l ++;
          }
          sysMsgStrBuffer.append(" class='hand' onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
        }
      }
    }
    sysMsgStrBuffer.append(">");
    sysMsgStrBuffer.append("<td id='LeftTD").append(userHistoryMessageId).append("' width='70%' class='default-a' style='text-decoration: none; word-wrap: break-word;'>");
    sysMsgStrBuffer.append("<div width='196px'>");
    if(msgList[i].importantLevel == '2' || msgList[i].importantLevel == '3'){
      sysMsgStrBuffer.append("<span class='ico16  important" + msgList[i].importantLevel + "_16'></span>");
    }
    sysMsgStrBuffer.append(msgList[i].content);
    sysMsgStrBuffer.append("</div>");
    sysMsgStrBuffer.append("</td>");
    var senderName = "";
    if (msgList[i].senderId != '-1') {
      senderName = msgList[i].senderName + msgList[i].accountShortName;
    } else {
      senderName = msgList[i].senderName;
    }
    sysMsgStrBuffer.append("<td nowrap id='RightTD").append(userHistoryMessageId).append("' width='30%' align='right' style='color: #000000; text-decoration: none;' title='" + senderName + "'>").append(senderName.getLimitLength(12, "...")).append("<br>").append(datetime);
    sysMsgStrBuffer.append("</td>");
    sysMsgStrBuffer.append("</tr>");
    sysMsgStrBuffer.append("</table>");
    if(i < msgList.length - 1 || printHRFlag || (_pdc!=null && _pdc>0)){
      sysMsgStrBuffer.append("<hr size='1' class='border-top' style='padding-top:12px; border-left:0;border-right:0;' />");
    }
    */
  }
  var resultStr = sysMsgStrBuffer.toString();
  sysMsgStrBuffer.clear();
  return resultStr;
}

/**
 * 将在线消息转换为HTML
 */
function perMessageListToHTML(printHRFlag, fromType){
	var handleWin = getHandleWin(fromType);
	var msgStrBuffer = new StringBuffer();
	var msgInstanceKeys = msgProperties.keys();
	var msgFromCount = msgInstanceKeys.size();//聊天对象个数
	for(var i = 0; i < msgFromCount; i++){
		var key = msgInstanceKeys.get(i);
		var msg = msgProperties.get(key);
		var msgCount = msg.size();//当前聊天对象的消息个数
		var latestMsg = msg.getLast();
		var tID  = key;
		var tableId = tID + "_Table";
		var tName = latestMsg.name.escapeHTML();
		var senderName = "";
		if (latestMsg.type != 1) {
			senderName = latestMsg.username.escapeHTML() + ":";
		}
		
		var msgContent = "";
		if (latestMsg.atts.size() > 0) {
			msgContent = senderName + "给您发送了文件";
		} else if (latestMsg.microtalk != null) {
			msgContent = senderName + "给您发送了语音";
		} else if (latestMsg.vcard != null){
			msgContent = senderName + "给您发送了名片";
		} else {
			msgContent = getMsgLimitLength(senderName + latestMsg.content, 80);
			msgContent = msgContent.escapeHTML();
			for(var j = 0; j < face_texts_replace.length; j++){
				msgContent = msgContent.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
			}
		}
		
		if(handleWin.$("#" + tableId).length > 0){
			handleWin.$("#" + tableId + "CountSpan").text(msgCount);
			handleWin.$("#" + tableId + "DateSpan").text(latestMsg.time);
			handleWin.$("#" + tableId + "ContentSpan").html(msgContent);
		}else{
			msgStrBuffer.append("<table width='100%' style='*width:250px;' class='hand' height='50' border='0' cellspacing='0' cellpadding='0' id='" + tableId + "' onclick='removeMsgFromBox(\"person\", \"" + tableId + "\", \"" + tID + "\", \"" + fromType + "\");openWinIM(\"" + tName + "\", \"" + latestMsg.jid + "\")'>");
			msgStrBuffer.append("<tr valign='top'>");
			msgStrBuffer.append("<td width='40%' align='left' class='messageHeaderContent default-a'><b><a>" + tName + "(<span id='" + tableId + "CountSpan'>" + msgCount + "</span>" + message_header_unit_label + ")</a></b></td>");
			msgStrBuffer.append("<td width='50%' align='right' class='messageHeaderContent'><span id='" + tableId + "DateSpan'>" + latestMsg.time + "</span></td>");
			msgStrBuffer.append("</tr>");
			msgStrBuffer.append("<tr valign='top'>");
			msgStrBuffer.append("<td colspan='3' align='left' class='messageBodyContent default-a'><div id='" + tableId + "ContentSpan'><a>" + msgContent + "</a></div></td>");
			msgStrBuffer.append("</tr>");
			msgStrBuffer.append("</table>");
			
			if(i < msgFromCount - 1 || printHRFlag){
				msgStrBuffer.append("<hr size='1' class='border-top' style='border-left:0;border-right:0;' />");
			}
			
			var count = msgProperties.size() + noticeProperties.size();
			handleWin.$("#perMsgCountSpan").text(count);
		}
	}
	
	var resultStr = msgStrBuffer.toString();
	msgStrBuffer.clear();
	return resultStr;
}

/**
 * 最小化消息窗口
 */
function changeMessageWindow(fromType){
	if(fromType == "a8"){
		var msgDiv = getCtpTop().$("#msgWindowDIV");
		var msgMaxDiv = getCtpTop().$("#msgWindowMaxDIV");
		var DivShim4MsgWindow = getCtpTop().$("#DivShim4MsgWindow");
		if(msgDiv.is(":hidden")){
			msgDiv.show();
			msgMaxDiv.hide();
			DivShim4MsgWindow.show();
		}else{
			msgDiv.hide();
			msgMaxDiv.show();
			DivShim4MsgWindow.hide();
		}
	}else{
		window.external.js_btnClickMinx();
	}
}

/**
 * 关闭消息窗口
 */
function destroyMessageWindow(isClear, fromType){
	if(isClear == "true"){
		msgProperties.clear();//清空页面存储的在线消息
	}
	
	var handleWin = getHandleWin(fromType);
	
	handleWin.$("#PerMsgContainer").html("");
	handleWin.isPerMessageWindowEyeable = false;
	
	handleWin.$("#SysMsgContainer").html("");
	handleWin.isSysMessageWindowEyeable = false;
	
	//性能优化:去掉右下角系统消息的未读数量
	/*if(fromType == "a8"){
		getCtpTop().$("#notReadSysCountSpan").hide();
	}*/
	
	handleWin.$("#msgWindowDIV").hide();
	var DivRefIframe = handleWin.$("#DivShim4MsgWindow");
	DivRefIframe.hide();
	if(fromType == "a8"){
		getCtpTop().standardTitleFun();
	}else{
		window.external.js_btnClickClose();
	}
}

/**
 * 如果个人设置"消息查看后从消息框中移出",则系统消息点击后从消息框中移出,否则只改变消息颜色
 */
function afterClickMessage(userHistoryMessageId, fromType){
	var handleWin = getHandleWin(fromType);
	if(handleWin.msgClosedEnable){
	  if(fromType == "a8"){
	    handleWin.$.ignoreSysMsg(userHistoryMessageId);
	  } else {
	    removeMsgFromBox("system", userHistoryMessageId, "", fromType);
	  }
	}else{
	  if(fromType == "a8"){
	    handleWin.$.markSysMsgReaded(userHistoryMessageId);
    } else {
      changeTRColor(userHistoryMessageId, fromType);
    }
	}
}

/**
 * 消息点击后从消息框中移除,消息总数做相应减少
 */
function removeMsgFromBox(type, index, tID, fromType){
	var handleWin = getHandleWin(fromType);
	var divId = "sysMsgContentDiv";
	var tableId = "sysMsgTable" + index;
	var spanId = "sysMsgCountSpan";
	if(type == "person"){
		divId = "personMsgContentDiv";
		tableId = index;
		spanId = "perMsgCountSpan";
		if(tID){
			msgProperties.remove(tID);
		}else{
			noticeProperties.remove(tableId);
		}
	}
	
	//移除消息
	var msgContentDiv = handleWin.document.getElementById(divId);
	var msgTable = handleWin.document.getElementById(tableId);
	var msgChildren = msgContentDiv.children;
	var currentMsgCount = -1;
	for(var i = 0; i < msgChildren.length; i += 2){
		if(msgTable == msgChildren[i]){
			currentMsgCount = i;
			break;
		}
	}
	if(currentMsgCount != -1 && msgChildren.length != 1){
		if(currentMsgCount != msgChildren.length - 1){
			msgContentDiv.removeChild(msgChildren[currentMsgCount + 1]);
		}else{
			msgContentDiv.removeChild(msgChildren[currentMsgCount - 1]);
		}
		msgContentDiv.removeChild(msgTable);
	}else{
		msgContentDiv.removeChild(msgTable);
	}
	
	//更改消息总数
	var countSpanObj = handleWin.$("#" + spanId);
	var originalCount = parseInt(countSpanObj.text()) - 1;
	if(originalCount == 0){
		colseMessageWindow(type, fromType);
		return;
	}
	countSpanObj.text(originalCount);
	
	//更改消息高度
	var height = getHeight(originalCount);
	if(type == "person"){
		height = getPerMessageHeight();
	}
	handleWin.$("#" + divId).height(height);
	
	DivSetVisible(false, fromType);
}

/**
 * 系统消息点击后改变颜色
 */
function changeTRColor(index, fromType){
	var handleWin = getHandleWin(fromType);
	handleWin.$("#LeftTD" + index).css("color", "#666666");
	handleWin.$("#RightTD" + index).css("color", "#666666");
}

/**
 * 关闭消息
 */
function colseMessageWindow(type, fromType){
	var handleWin = getHandleWin(fromType);
	if(type == "system"){
		handleWin.$("#SysMsgContainer").html("");
		handleWin.$("#SysMsgContainerTR").hide();
		handleWin.isSysMessageWindowEyeable = false;
	}else if(type == "person"){
		handleWin.$("#PerMsgContainer").html("");
		handleWin.$("#PerMsgContainerTR").hide();
		handleWin.isPerMessageWindowEyeable = false;
	}
	DivSetVisible(false, fromType);
}

/**
 * 消息框显示/隐藏
 */
function DivSetVisible(state, fromType){
	var handleWin = getHandleWin(fromType);
	var DivRef = handleWin.$("#msgWindowDIV");
	var DivRefIframe = handleWin.$("#DivShim4MsgWindow");
	var helperTObj = handleWin.$("#helperTable");
	if(state){
		if(fromType == "a8"){
			getCtpTop().$("#msgWindowMaxDIV").hide();
		}
		DivRef.show();
		DivRef.height(helperTObj.height());
		DivRefIframe.height(helperTObj.height()).show();
		if(fromType == "genius"){
			resizeMessageWindow(DivRef.height());
		}
	}else{
		if(handleWin.isSysMessageWindowEyeable == false && handleWin.isPerMessageWindowEyeable == false){//系统消息和在线消息都关闭
			destroyMessageWindow("false", fromType);
		}else{//关闭一个
			DivRef.height(helperTObj.height());
			DivRefIframe.height(helperTObj.height()).show();
			if(fromType == "genius"){
				resizeMessageWindow(DivRef.height());
			}
		}
	}
}

/**
 * 计算系统消息框高度
 */
function getHeight(count){
	return (count > 4) ? "188px" : (count * 60) + "px";
}

/**
 * 计算在线消息框高度
 */
function getPerMessageHeight(){
	var height = msgProperties.size() * 60 + noticeProperties.size() * 35;
	if (height > 188) {
		height = 188;
	}
	return height;
}

/**
 * 如果是当日则显示HH:mm,如果非当日则显示yyyy-MM-dd HH:mm
 */
function showDatetime(datetime){
	var date1 = new Date(parseInt(datetime, 10)).format("yyyy-MM-dd");
	var date2 = new Date().format("yyyy-MM-dd");
	var dateStyle = "HH:mm:ss";
	if(date1 != date2){
		dateStyle = "yyyy-MM-dd HH:mm:ss";
	}
	return new Date(parseInt(datetime, 10)).format(dateStyle);
}

function getHandleWin(fromType){
	return fromType == "a8" ? getCtpTop() : window;
}

/**
 * 获取部门名称
 */
function getDepartmentName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "ajaxGetDepartmentName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取空间名称
 */
function getSpaceName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "ajaxGetSpaceName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取项目名称
 */
function getProjectName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "projectManager", "ajaxGetProjectName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取事件名称
 */
function getEventName(id){
  var requestCaller = new XMLHttpRequestCaller(this, "ajaxCalEventManager", "ajaxGetEventName", false);
  requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 点击系统消息时更新未读状态
 */
function updateMessageState(id, obj, fromType){
	if(typeof(id) == "undefined" || id == null || id  == ""){
		return;
	}
	var handleWin = getHandleWin(fromType);
	//只第一次点击更新数据库
	if(handleWin.$(obj).attr("hasClicked") != "true"){
		updateSystemMessageState(id);
		handleWin.$(obj).attr("hasClicked", "true");
	}
}

/**
 * 更新系统消息已读状态
 */
function updateSystemMessageState(id) {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageState", false);
    requestCaller.addParameter(1, "long", id);
    requestCaller.serviceRequest();
}

function updateSystemMessageStateByUser() {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageStateByUser", false);
    requestCaller.serviceRequest();
}

function updateSystemMessageStateByCategory(category) {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageStateByCategory", false);
    requestCaller.addParameter(1, "String", category);
    requestCaller.serviceRequest();
}

/**************************************** 在线消息页面闪烁start ****************************************/
var myIntervalTitle = null;
var standardTitle = null;
$(document).ready(function(){
    try {
    standardTitle = document.title;
  } catch (e) {
    standardTitle = '';
  }
});

var step = 0;
function flash_title(){
	step++
	if (step == 3) {step = 1}
	if (step == 1) {
		if(productVersion == "A8"){
			if(productAbout == 'U8'){
				document.title = 'U8＋OA';
			}else if(productAbout == 'NC'){
				document.title = 'NC-OA';
			}else{
				document.title = 'A8-V5';
			}
		}else if(productVersion == 'A6'){
			if(productAbout == 'U8'){
				document.title = 'U8＋OA';
			}else{
				document.title = 'A6-V5';
			}
		}else if(productVersion == 'A6s'){
			document.title = 'A6s';
		}else if(productVersion == 'G6'){
			document.title = 'G6-V5';
		}else{
			document.title = 'A8-V5';
		}
	}
	if (step == 2) {document.title = standardTitle}
}

function startActionTitle(){
	if(!myIntervalTitle){
		myIntervalTitle = window.setInterval("flash_title()", 1000);
	}
}

function standardTitleFun(){
	if(!standardTitle){
		standardTitle = document.title
	}
	
	document.title = standardTitle;
	
	if(myIntervalTitle != null){
		window.clearInterval(myIntervalTitle);
		document.title = standardTitle;
		myIntervalTitle = null;
	}
}
/**************************************** 在线消息页面闪烁end ****************************************/

/**************************************** 播放声音start ****************************************/
function playMessageRadio(){
	if(isEnableMsgSound){
		$("#playSoundHelper").attr("src", v3x.baseURL + "/playSound.htm");
		try{
			//解决IE6恢复窗口重复播放声音的问题
			window.setTimeout("clearMessageRadio()", 2000);
		}catch(e){
			
		}
	}else{
		clearMessageRadio();
	}
}

function clearMessageRadio(){
	$("#playSoundHelper").attr("src", "");
}
/**************************************** 播放声音end ****************************************/

/**
 * 在线交流页面
 */
var onlineWin = null;
function onlineMember(){
	if (onlineWin && !onlineWin.closed) {
		onlineWin.focus();
    } else {
    	var left = 140;
    	var top = (window.screen.availHeight - 600) / 2 - 10;
        onlineWin = window.open(_ctxPath + "/online.do?method=showOnlineUser", "", "left=" + left + ",top=" + top + ",width=600,height=600,location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
    }
}
function getMsgLimitLength(text, maxLength) {
	var len = text.getBytesLength();
	if (len <= maxLength) {
		return text;
	}

	var symbol = "...";
	maxLength = maxLength - symbol.length;

	var a = 0;
	var temp = '';
	for ( var i = 0; i < text.length; i++) {
		if (text.charCodeAt(i) > 255) {
			a += 2;
		} else {
			a++;
		}

		temp += text.charAt(i);

		if (a >= maxLength) {
			break;
		}
	}

	var start = temp.substring(0, temp.length - 7);
	var end = temp.substring(temp.length - 7, temp.length);
	if (end.indexOf("[") != -1 && (end.indexOf("]") == -1 || end.indexOf("]") < end.indexOf("["))) {
		start += end.substring(0, end.indexOf("["));
	} else {
		start += end;
	}

	start += symbol;

	return start;
}
var ContantsOutNumberMinute=30;var ContantsOutNumber=10;var messageTask=null;var isFirstTask=true;var ucDisconnect=false;function initMessage(A){if(!A||A<30){A=30}ContantsOutNumber=ContantsOutNumberMinute*60/A;messageTask=new Task(A);setTimeout("getMessage()",5*1000)}function Task(A){this.intervalSecond=A*1000;this.iTimeoutID=null;this.outNumber=0}Task.prototype.start=function(){this.iTimeoutID=window.setTimeout("getMessage()",this.intervalSecond+parseInt(Math.random()*5)*1000);isFirstTask=false};Task.prototype.clear=function(){if(this.iTimeoutID){window.clearTimeout(this.iTimeoutID);this.iTimeoutID=null}};Task.prototype.showOut=function(){showOnlineNum("X");this.clear()};Task.prototype.out=function(A){this.outNumber++;ucDisconnect=true;showOnlineNum("X");if(!isA8geniusMsg){}if(this.outNumber>ContantsOutNumber){A=A||"";if(window.confirm($.i18n("onlineMessage_alert_serverOver",A))){if(!isA8geniusMsg){getCtpTop().logout(true)}else{window.external.js_OnLogOut("")}}}else{this.start()}};function getMessage(){showOnlineNum("...");new GetMessage().run()}function GetMessage(){this.name="doGetMessage"}GetMessage.prototype.run=function(){try{var A=new XMLHttpRequestCaller(this,null,null,true,"GET",true,"/getAJAXMessageServlet");A.filterLogoutMessage=false;A.closeConnection=true;A.serviceRequest();if(!isA8geniusMsg){}try{initConnection()}catch(B){}}catch(B){messageTask.out()}};GetMessage.prototype.showAjaxError=function(A){messageTask.out(A)};GetMessage.prototype.invoke=function(result){if(result){var resultVar=null;try{eval("resultVar = "+result)}catch(e){}if(!resultVar){if(result.indexOf("[LOGOUT]")==0){messageTask.clear();if(!isA8geniusMsg){isDirectClose=false;getCtpTop().showLogoutMsg(result.substring(8))}else{window.external.js_OnLogOut(result.substring(8))}return }else{if(result.indexOf("[LOGWARN]")==0){alert(result.substring(9))}else{}}}else{var onlineNumber=resultVar.N||"0";var processNewUserMessages=resultVar.M;var C=resultVar.C||"0";var messagesCounter=parseInt(C,10);showOnlineNum(""+onlineNumber);showOnlineInfo(processNewUserMessages,messagesCounter)}}messageTask.outNumber=0;messageTask.start()};function showOnlineNum(B){try{if(B){if(!isA8geniusMsg){$("#onlineNum").text(B);$("#onlineNum_adm").text(B)}else{window.external.js_OnlineCount(B)}}}catch(A){}}function showOnlineInfo(f,C){try{if(f&&f.length>0){var E=new Array();var S=new Array();if(!isA8geniusMsg){var T=new Set()}var Y=0;var V=0;var O=false;for(var Z=0;Z<f.length;Z++){var P=f[Z];var N=P.R;var d=P.H;var K=P.MC;var X=P.C||"";var Q=P.T;var h=P.S;var B=P.N;var M=P.SN;if(h==-1||h=="-1"){B=ANNONYMOUS_NAME}var D="";var b="";var A=P.D;var g=P.VC;var R=P.L;if(!isA8geniusMsg){if(R=="message.link.cal.view"||R=="message.link.plan.send"||R=="message.link.taskmanage.view"||R=="message.link.edoc.sended"||R=="message.link.col.pending"||R=="message.link.mt.send"){O=true}}if(isA8geniusMsg&&R=="message.link.NC.message"){R=null}var I=R;if(Q==0&&R){if(!isA8geniusMsg){T.add(R)}var W=0;while(true){var G=P["P"+W];if(!G){break}I+="|"+G;W++}}var J=parseInt(P.O,10);var U=P.A;var L=P.I;if(Q==0){if(!(I&&I.indexOf("leaveWord")!=-1)){X=X.escapeHTML()}}else{A=showDatetime(A)}if(g!=null&&g!=""){I=I+"|vc:"+g}var F=new CLASS_MESSAGE("","",N,d,X,Q,h,B,D,b,A,I,J,U,L,K);F.accountShortName=M;if(Q==1||Q==2||Q==3||Q==4||Q==5){E[Y++]=F}else{if(Q==0){S[V++]=F}}}if(O==true&&isFirstTask==false){setTimeout("getCtpTop().timeLineObjReset(getCtpTop().timeLineObj)",0)}if((Y+V)>0){var a=(C>(Y+V)&&C>50)?"/"+C:"";if(!isA8geniusMsg){showMessage(null,S,a,"a8");if(isFirstTask==false){try{getCtpTop().refreshSection(T.toArray())}catch(H){}}}else{showMessage(null,S,a,"genius")}}}}catch(c){messageTask.clear()}};
function changeobjattr(A){A.removeClass("stopmeeting");A.addClass("stopmeetinged");A.unbind("click");A.attr("disabled",true);A.removeAttr("id")}function changedIDattr(B,C){var A=$("#"+B+"_Iframe").contents().find("#"+C);changeobjattr(A)}function changeattr(F){var A=$("#"+F+"_Iframe").contents().find("#agreemeeting");var E=$("#"+F+"_Iframe").contents().find("#formeeting");var B=$("#"+F+"_Iframe").contents().find("#meetingcreater");var C=$("#"+F+"_Iframe").contents().find("#meetingcreatername");var D=$("#"+F+"_Iframe").contents().find("#stopmeeting");changeobjattr(A);changeobjattr(E);changeobjattr(D);B.removeAttr("id");C.removeAttr("id");$("#"+F+"_Iframe").contents().find("#lanchmeeting").val("");$("#"+F+"_Iframe").contents().find("#resavemeeting").val("")}function deletemeeting(A){$.ajax({type:"POST",url:messageURL+"?method=deletemeeting",data:{confKey:A}})}function addMeetingEvent(A,B,C){$("#"+B+"_Iframe").contents().find("#agreemeeting").unbind("click");$("#"+B+"_Iframe").contents().find("#agreemeeting").click(function(){getA8Top().sendIMMessage(A,B,C,"A","","vomeeting");changeattr(B);$("#"+B+"_Iframe").contents().find("#confKey").removeAttr("id");$("#"+B+"_Iframe").contents().find("#resavemeeting").val("");$("#"+B+"_Iframe").contents().find("#lanchmeeting").val("")});$("#"+B+"_Iframe").contents().find("#formeeting").unbind("click");$("#"+B+"_Iframe").contents().find("#formeeting").click(function(){getA8Top().sendIMMessage(A,B,C,"F","","vomeeting");changeattr(B);$("#"+B+"_Iframe").contents().find("#confKey").removeAttr("id");$("#"+B+"_Iframe").contents().find("#resavemeeting").val("");$("#"+B+"_Iframe").contents().find("#lanchmeeting").val("")})}function showMessageForIM(E,f){var U=new Properties();if(E!=null&&E.length>0){for(var Y=0;Y<E.length;Y++){var N=E[Y];if(currentUserId!=N.senderId){var h="";if(N.messageType==1){h=N.senderId}else{h=N.referenceId}if(U.containsKey(h)){U.get(h).add(N)}else{var D=new ArrayList();D.add(N);U.put(h,D)}}}}if(U.size()>0){var P=U.keys();for(var X=0;X<P.size();X++){var d=P.get(X);var I=U.get(d);var O=I.getLast();var V="";var Q="";var Z="";if(O.messageType=="1"){V=currentUserId+"_"+O.senderId;Q=O.senderId;Z=O.senderName}else{V=O.referenceId;Q=O.referenceId;Z=getTeamName(O.messageType,O.referenceId)}var l=Z.getLimitLength(24,"..").escapeHTML();if($("#imTabs").tabs("exists",l)){var H=$("#imTabs").tabs("getTab",l);var W=H.panel("options").tab;W.removeClass("tabs-selected-off");for(var T=0;T<I.size();T++){var S=I.get(T);var c=$("#"+V+"_Iframe").contents().find("#resavemeeting");var C=$("#"+V+"_Iframe").contents().find("#lanchmeeting");if(S.content.indexOf("<span class='meeting' id = 'vomeeting'>")!=-1){if(c.val()=="true"){$("#"+V+"_Iframe").contents().find("#vomeeting").removeAttr("id");$("#"+V+"_Iframe").contents().find("#confKey").removeAttr("id");$("#"+V+"_Iframe").contents().find("#meetingcreatername").removeAttr("id");changeattr(V)}S.content+='<span id="agreemeeting" class="stopmeeting">'+_("MainLang.message_vomeeting_agree")+'</span>&nbsp;&nbsp;<span id="formeeting" class="stopmeeting">'+_("MainLang.message_vomeeting_refuse")+"</span>";c.val("true");if($("#"+V+"_Iframe").contents().find("#lanchmeeting").val()=="true"){var A=$("#"+V+"_Iframe").contents().find("#stopmeeting");changeobjattr(A);$("#"+V+"_Iframe").contents().find("#lanchmeeting").val("")}}if(c.val()=="true"&&S.content.indexOf("<script>try{if(vomak==''){stopmeeting('');}}catch(e){}<\/script>")!=-1){$("#"+V+"_Iframe").contents().find("#confKey").removeAttr("id");$("#"+V+"_Iframe").contents().find("#meetingcreatername").removeAttr("id");c.val("");changeattr(V)}if(C.val()=="true"&&S.content.indexOf("<script>try{if(vomak==''){sstopmeeting('A');}}catch(e){}<\/script>")!=-1){var L=$("#"+V+"_Iframe").contents().find("#iscreater");var b=$("#"+V+"_Iframe").contents().find("#lanchmeetinged");var B=$("#"+V+"_Iframe").contents().find("#cconfKey");if(b.val()==""&&L.val()=="true"){var G="/seeyon/message.do?method=joinmeeting&iscreater=true&meeting_id="+currentUserId+"&confKey="+B.val();window.open(G);b.val("true");L.val("");C.val("")}$("#"+V+"_Iframe").contents().find("#meetingcreatername").removeAttr("id");B.val("");var A=$("#"+V+"_Iframe").contents().find("#stopmeeting");changeobjattr(A)}if(C.val()=="true"&&S.content.indexOf("<script>try{if(vomak==''){sstopmeeting('F');}}catch(e){}<\/script>")!=-1){var K=$("#"+V+"_Iframe").contents().find("#rnum");var M=parseInt(K.val());M++;K.val(M);var R=$("#"+V+"_Iframe").contents().find("#tnum");var F=parseInt(R.val());if(F==M){var A=$("#"+V+"_Iframe").contents().find("#stopmeeting");var B=$("#"+V+"_Iframe").contents().find("#cconfKey");changeobjattr(A);C.val("");$("#"+V+"_Iframe").contents().find("#iscreater").val("");deletemeeting(B.val())}}if(S.content.indexOf("<span class='meeting'")!=-1&&S.content.indexOf("vomak==''")!=-1){S.content.replace("vomak==''","false")}var g="<div style='padding: 5px 10px;'><span style='color: #335186;'>"+S.senderName.escapeHTML()+"</span>&nbsp;&nbsp;<font class='col-reply-date'>"+S.creationDateTime+"</font></div><div style='padding: 5px 30px; word-wrap:break-word;word-break:break-all;'>"+S.content+"</div>";$("#"+V+"_Iframe").contents().find("#sendContent").append(g);if($("#"+V+"_Iframe").contents().find("#resavemeeting").val()=="true"){addMeetingEvent(S.messageType,V,Q)}try{$("#"+V+"_Iframe").contents().find("#sendContent")[0].scrollTop=$("#"+V+"_Iframe").contents().find("#sendContent")[0].scrollHeight-$("#"+V+"_Iframe").contents().find("#sendContent").height()}catch(a){}var J=$("#imTabs").tabs("getSelected");var H=$("#imTabs").tabs("getTab",l);if(f!="true"&&J!=H){var W=H.panel("options").tab;W.addClass("tabs-selected-sel");$("#imTabs").tabs("select",J.panel("options").title)}}}else{if(IMMsgProperties.containsKey(Q)){IMMsgProperties.get(Q).addAll(I)}else{IMMsgProperties.put(Q,I)}var J=$("#imTabs").tabs("getSelected");showIMTab(O.messageType,Q,Z.escapeHTML(),"true");var H=$("#imTabs").tabs("getTab",l);if(f!="true"&&J&&J!=null){var W=H.panel("options").tab;W.addClass("tabs-selected-sel");$("#imTabs").tabs("select",J.panel("options").title)}}if(f!="true"){if(isA8genius=="true"){window.external.ReciveNewMsg("","")}else{startActionTitle()}playMessageRadio()}}}};
var dialogCalEventUpdate;function openDocument(str,linkOpenType){if(!str){return }var verifyCode=null;var vcBeginIndex=str.indexOf("|vc:");if(vcBeginIndex!=-1){vcBeginIndex=vcBeginIndex+4;verifyCode=str.substr(vcBeginIndex)}var strs=str.split("|");var linkType=getCtpTop().messageLinkConstants.get(strs[0]);if(linkType){vcBeginIndex=linkType.indexOf("v={");if(vcBeginIndex!=-1){linkType=linkType.substring(0,vcBeginIndex-1);strs.pop()}}if(strs[0]=="message.link.taskmanage.view"||strs[0]=="message.link.taskmanage.viewfromreply"){linkType="javascript:viewTaskInfo4Event('{0}')"}else{if(strs[0]=="message.link.taskmanage.viewfeedback"){linkType="javascript:viewTaskInfo4Event('{0}','{1}','feedback')"}}if(linkType){var l=1;while(true){var param=strs[l];if(!param){break}var regEx=eval("messageRegEx_"+(l-1));linkType=linkType.replace(regEx,param);l++}}if(verifyCode){linkType=linkType+"&v="+verifyCode}if(linkType){if(linkType.match("^(javascript):")){try{eval(linkType.substring(11))}catch(e){alert(e.message)}}else{if(linkType.indexOf("?")>0){linkType+="&_isModalDialog=true"}else{linkType+="?_isModalDialog=true"}if(linkOpenType==0){var rv;if(strs[0].match("message.link.bbs")||strs[0].match("message.link.bul")||strs[0].match("message.link.inq")||strs[0].match("message.link.news")){rv=v3x.openWindow({url:linkType,left:20,top:20,dialogType:"open",resizable:"yes",width:screen.width-50,height:screen.height-150})}else{if(strs[0].match("message.link.office")){checkOfficeState(linkType)}else{if(strs[0].match("message.link.cal")){var ajaxTestBean=new calEventManager();var res=ajaxTestBean.isHasDeleteByType(strs[1],"event");if(res!=null&&res!=""){$.alert({msg:res,ok_fn:function(){}})}else{var isOnePerson=ajaxTestBean.isOnePerson(strs[1]);var isReceiveMember=ajaxTestBean.isReceiveMember($.ctx.CurrentUser.id,strs[1]);var curButton="";if(isOnePerson=="yes"||isReceiveMember){curButton=[{id:"sure",text:$.i18n("common.button.ok.label"),handler:function(){dialogCalEventUpdate.getReturnValue()}},{id:"update",text:$.i18n("calendar.update"),handler:function(){dialogCalEventUpdate.getReturnValue("update")}},{id:"cancel",text:$.i18n("calendar.cancel"),handler:function(){dialogCalEventUpdate.close()}},{id:"btnClose",text:$.i18n("calendar.close"),handler:function(){dialogCalEventUpdate.close()}}]}else{curButton=[{id:"btnClose",text:$.i18n("calendar.close"),handler:function(){dialogCalEventUpdate.close()}}]}dialogCalEventUpdate=$.dialog({id:"calEventUpdate",url:linkType,width:600,height:500,checkMax:true,targetWindow:getCtpTop(),title:$.i18n("calendar.event.search.title"),transParams:{diaClose:viewCurDialogClose,showButton:showCurBtn,isview:"true"},buttons:curButton});if(isOnePerson=="yes"||isReceiveMember){dialogCalEventUpdate.hideBtn("sure");dialogCalEventUpdate.hideBtn("cancel")}}}else{if(strs[0].match("message.link.taskmanage")){var ajaxTestBean=new calEventManager();var res=ajaxTestBean.isHasDeleteByType(strs[1],"task");if(res!=null&&res!=""){$.alert(res)}else{var title=$.i18n("taskmanage.content");dialog=$.dialog({id:"viewTaskPortal",url:linkType,width:$(getCtpTop()).width()-100,height:$(getCtpTop()).height()-100,title:title,targetWindow:getCtpTop(),closeParam:{show:true,autoClose:false,handler:function(){dialog.getClose({dialogObj:dialog})}},buttons:[{text:$.i18n("common.button.close.label"),handler:function(){dialog.getClose({dialogObj:dialog})}}]})}}else{if(strs[0].match("message.link.plan")){var ajaxTestBean=new calEventManager();var res=ajaxTestBean.isHasDeleteByType(strs[1],"plan").toString();if(res=="true"){var planViewdialog=$.dialog({id:"showPlan",url:linkType,width:$(getCtpTop().document).width()-100,height:$(getCtpTop().document).height()-100,title:$.i18n("plan.dialog.showPlanTitle"),targetWindow:getCtpTop(),buttons:[{text:$.i18n("plan.dialog.close"),handler:function(){planViewdialog.close()}}]})}else{if(res=="false"){$.alert("\u60a8\u6ca1\u6709\u67e5\u770b\u6743\u9650\uff0c\u8bf7\u8054\u7cfb\u53d1\u8d77\u4eba\uff01")}else{if(res=="absence"){$.alert("\u8ba1\u5212\u5df2\u88ab\u5220\u9664\uff0c\u8bf7\u8054\u7cfb\u53d1\u8d77\u4eba\uff01")}}}}else{if(strs[0].match("message.link.mt")||strs[0].match("message.link.meeting")||strs[0].match("message.link.office.meetingroom")){var idIndex=linkType.indexOf("id");if(idIndex!=-1){var id=getMultyWindowId("id",linkType);openCtpWindow({url:linkType,id:id})}else{openCtpWindow({url:linkType})}}else{if(strs[0].match("message.link.sap.synchLog")){getCtpTop().showCurrentPage(linkType);return }else{if(strs[0].match("message.link.hr.salary.open")){getCtpTop().main.location.href=linkType;return }else{if(strs[0].match("message.link.hr.salary.admin")){openSalaryAdminByURL(linkType);return }else{if(strs[0].match("message.link.doc.open.only")||strs[0].match("message.link.doc.openfromborrow")||strs[0].match("message.link.doc.open.index")||strs[0].match("message.link.doc.open.learning")){openKnowledgeByURL(linkType)}else{if(strs[0].match("message.link.col")){if(!checkIsAffairValid(linkType)){return }var params=[$("#summary"),$(".slideDownBtn"),$("#listPending")];var title=$.i18n("collaboration.summary.pageTitle");getCtpTop().showSummayDialogByURL(linkType,title,params)}else{if(strs[0].match("message.link.exchange")||strs[0].match("message.link.edoc")){var isEdocExchange=strs[0].match("message.link.exchange");if(!isEdocExchange&&!checkIsAffairValid(linkType)){return }var idIndex=linkType.indexOf("affairId");if(idIndex!=-1){var id=getMultyWindowId("affairId",linkType);openCtpWindow({url:linkType,id:id})}else{openCtpWindow({url:linkType})}}else{if(!checkIsAffairValid(linkType)){return }rv=v3x.openWindow({url:linkType,dialogType:v3x.getBrowserFlag("openWindow")?"modal":"open",FullScrean:"yes"})}}}}}}}}}}}}if(rv=="true"||rv==true){getCtpTop().refreshSection([strs[0]])}refreshSectionFont("pendingSection",strs)}else{if(linkOpenType==1){getCtpTop().showCurrentPage(linkType)}}}}}function checkOfficeState(B){var A=getMultyWindowId("method",B);var G=getMultyWindowId("affairId",B);var I=getMultyWindowId("applyId",B);var E=getMultyWindowId("operate",B);var H="auto";var D=false;if(B.indexOf("autoMgr.do")>-1){getCtpTop()._officeWinW=openCtpWindow({url:B});return }var L=[0,25,30,35];if(A.indexOf("stock")!=-1){H="stock";L=[0,15,20,25]}else{if(A.indexOf("asset")!=-1){H="asset";L=[0,25,30,35]}else{if(A.indexOf("Book")!=-1||A.indexOf("book")!=-1){L=[0,15,20,25];I=getMultyWindowId("bookApplyId",B);H="book"}}}if(A.indexOf("Audit")!=-1||A.indexOf("audit")!=-1){E="audit"}var J=new XMLHttpRequestCaller(this,"stockUseManager","hasApplyHasState",false);var C={applyId:I,affairId:G,mode:H,checkStates:L,operate:E};J.addParameter(1,"String",$.toJSON(C));var F=J.serviceRequest();var K=$.parseJSON(F);if(K.hasState){$.alert(K.msg)}else{getCtpTop()._officeWinW=openCtpWindow({url:B})}}function openSalaryAdminByURL(linkType){$.post("/seeyon/hrSalary.do?method=ajaxIsAdmin","",function(json){var jso=eval(json);if(jso[0].isAdmin){getCtpTop().main.location.href=linkType}else{$.alert(jso[0].isNotAdminInfo)}})}function checkIsAffairValid(A){try{if(A&&(A.indexOf("stepBackRecord")>-1||A.indexOf("repealRecord")>-1)){return true}var B;var H=getCtpTop().frames.main;if(H.frontPageOutUtilsJS){var B=getWindowObj(H,"pendingSection");var F;if(A){if(A.indexOf("affairId=")!=-1){var D=A.substring(A.indexOf("affairId="));var C=D.split("&")[0];F=C.split("=")[1]}}if(F&&B){var G=B.isAffairValid(F);if(G!=""){$.messageBox({title:$.i18n("system.prompt.js"),type:0,imgType:2,msg:G,ok_fn:function(){B.parent.sectionHandler.reload("pendingSection",true)}});return false}}}return true}catch(E){}}function getWindowObj(G,D){var C;var B=G.sectionHandler.allSectionPanels;for(var F in B){var A=B[F];if(A.sectionBeanId==D){var E=G.$("#"+A.nodeId).find("iframe")[0];if(E){if(typeof (E.contentWindow.cancelBold4Messge)=="function"){C=E.contentWindow}}}}return C}function refreshSectionFont(B,C){var E=getCtpTop().frames.main;if(!E.frontPageOutUtilsJS){return }try{var A=getWindowObj(E,"pendingSection");if(A){A.cancelBold4Messge(C)}}catch(D){}}function showCurBtn(){dialogCalEventUpdate.showBtn("sure");dialogCalEventUpdate.hideBtn("update")}function viewCurDialogClose(A){if(A==-1){dialogCalEventAdd.close()}else{dialogCalEventUpdate.close()}}function updateMessageState(D,B,C){var A=null;if(D){if(C=="show"){if($("#"+D+"Span").length>0){updateSystemMessageState(D);if(B=="notRead"){location.href=location.href}else{$("#"+D+"Span").remove();$("#"+D+"Div").remove()}}}else{updateSystemMessageState(D);if(B=="notRead"){location.href=location.href}else{$("#"+D+"Span").remove();$("#"+D+"Div").remove()}}}else{if($("span[name='unReadMsg']").length==0){return }else{if(confirm(_("MainLang.message_system_ignore_all"))){updateSystemMessageStateByUser();if(B=="notRead"){location.href=location.href}else{$("div[name='unReadMsg'],span[name='unReadMsg']").remove()}}}}};
/**************************************** A8消息 ****************************************/

/**
 * 显示在线IM聊天窗口
 * 如果在线IM聊天窗口没有打开,先打开再添加聊天页签
 * 如果在线IM聊天窗口已经打开,直接获取焦点再添加聊天页签
 */
function showOnlineIM(key){
	var msg = msgProperties.get(key);
	var latestMsg = msg.getLast();
	var tType = latestMsg.messageType;
	var tID = tType == 1 ? latestMsg.senderId : latestMsg.referenceId;
	
	if(!onlineWin){
		var left = 50;
		var top = (window.screen.availHeight - 600) / 2;
		
		onlineWin = window.open("/seeyon/message.do?method=showOnlineUser&id=" + tID, "", 
			"left=" + left + ",top=" + top + ",width=600,height=600,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no");
	}else{
		onlineWin.focus();
		
		onlineWin.showMessageForIM(msg.instance, "true");
		msgProperties.remove(key);
	}
}

/**
 * 协同中发起讨论
 */
function showOnlineIMForCol(id, name){
	if(!onlineWin){
		var left = 50;
		var top = (window.screen.availHeight - 600) / 2;
		
		onlineWin = window.open("/seeyon/message.do?method=showOnlineUser&fromcol=true&name=" + encodeURIComponent(name) + "&id=" + id, "", 
			"left=" + left + ",top=" + top + ",width=600,height=600,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no");
	}else{
		onlineWin.focus();
		onlineWin.showIMTab('5', id, name, 'false');
	}
}

function showMessageSet(url){
  var dialog = $.dialog({
	id : 'showMessageSet',
    url : url,
    width : $(getCtpTop()).width() - 100,
    height : 600,
    title : $.i18n("message.setting.title"),
    targetWindow : getCtpTop()
  });
}

/**
 * 更多消息、未读消息
 */
function showMoreMessage(src){
	/*if(getCtpTop().contentFrame.document.getElementById("LeftRightFrameSet").cols == "0,*"){
		getCtpTop().contentFrame.leftFrame.closeLeft();
	}*/
	gotoDefaultPortal();
	getCtpTop().$("#main").attr("src", src);
}
var sectionMappingLinkType={pendingSection:["message.link.col.pending","message.link.exchange.receive","message.link.exchange.send","message.link.exchange.register.pending","message.link.mt.send","message.link.edoc.pending","message.link.bul.auditing","message.link.office.auto","message.link.office.stock","message.link.office.asset","message.link.office.book","message.link.office.meetingroom"],NCPendingSection:["message.link.NC.message"],guestbookSection:["message.link.project.leaveWord"],collaborationRemindSection:["message.link.mt.send","message.link.col.pending","message.link.edoc.pending","message.link.taskmanage.view",]};var linkTypeMappingSection={"message.link.inquiry_send":["inquirySection","singleBoardInquirySection","groupInquirySection",],"message.link.news.open":["newsSection","singleBoardNewsSection","singleBoardGroupNewsSection","groupNewsSection"],"message.link.bul.alreadyauditing":["bulletinSection","singleBoardBulSection","singleBoardGroupBulletinSection","groupBulletinSection","myBulletinSection"],"message.link.bbs.open":["singleBoardBbsSection","singleBoardGroupBbsSection","singleBoardBbsSection","groupBbsSection"],"message.link.plan.send":["planManageSection","departmentPlanSection"]};Array.prototype.contains=function(A){for(var B=0;B<this.length;B++){if(this[B]==A){return true}}return false};function getSectionIdByLinkType(A){var E=linkTypeMappingSection[A];if(E){return E}var D=[];for(var C in sectionMappingLinkType){var B=sectionMappingLinkType[C];if(B&&B.contains(A)){D[D.length]=C}}return D}function refreshSection(D){var G=getCtpTop().frames.main;if(!G.frontPageOutUtilsJS){return }if(D){for(var C=0;C<D.length;C++){var B=D[C];try{var A=getSectionIdByLinkType(B);if(!A){return }for(var E=0;E<A.length;E++){G.sectionHandler.reload(A[E],true)}}catch(F){alert(F.message)}}}};
/*----------------------------------------------------------------------------\
|                                Cross Panel 1.0                              |
|-----------------------------------------------------------------------------|
|                       Created by Tanmf (tanmf@seeyon.com)                   |
|                    For UFIDA-Seeyon (http://www.seeyon.com/)                |
|-----------------------------------------------------------------------------|
| A utility will be used for Organization Medol, use AJAX Tech. to load the   |
|data                                                                         |
|-----------------------------------------------------------------------------|
|                            Copyright (c) 2006 Tanmf                         |
|-----------------------------------------------------------------------------|
| Dependencies:                                                               |
|-----------------------------------------------------------------------------|
| 2006-09-20 | Original Version Posted.                                       |
|-----------------------------------------------------------------------------|
| Created 2006-09-20 | All changes are in the log above. | Updated 2006-08-20 |
\----------------------------------------------------------------------------*/

var orgDataCenterFlag = true;


var Constants_Account      = "Account";
var Constants_Department   = "Department";
var Constants_Team         = "Team";
var Constants_Post         = "Post";
var Constants_Level        = "Level";
var Constants_Member       = "Member";
var Constants_Role         = "Role";
var Constants_Outworker    = "Outworker";
var Constants_ExchangeAccount   = "ExchangeAccount";
var Constants_concurentMembers  = "ConcurentMembers";
var Constants_OrgTeam           = "OrgTeam";
var Constants_RelatePeople      = "RelatePeople";
var Constants_FormField         = "FormField";
var Constants_OfficeField       = "office";
var Constants_Admin             = "Admin";
var Constants_Node              = "Node";
var Constants_WfSuperNode       = "WF_SUPER_NODE";
var Constants_OrgRecent         = "OrgRecent";

var PeopleRelate_TypeName = {
        1 : "",
        2 : "",
        3 : "",
        4 : ""
};


/****************************************************************
 * ��λ
 * @param id
 * @param parentId �ϼ���λId
 * @param name
 * @param hasChild �Ƿ����ӵ�λ
 * @param shortname ��λ���
 * @param levelScope ְ�񼶱�����
 * @param description
 */
function Account(id, parentId, path, name, hasChild, shortname, levelScope, description){
    this.id = id;
    this.parentId = parentId;
    this.path = path;
    this.name = name;
    this.hasChild = hasChild;
    this.shortname = shortname;
    this.levelScope = levelScope;
    this.description = description;

    this.accessChildren = new ArrayList();
}

Account.prototype.toString = function(){
    return this.id + "\t" + this.name + "\t" + this.shortname + "\t" + this.levelScope;
};

/**
 * @param id
 * @param parentId
 * @param name
 * @param hasChild
 * @param description
 * @param path
 * @param concurents ��ְ  "Concurent":{"-3416446029311948944":[{"DN":"���۲�","A":"-7402591981046643031","PN":"ְԱ","N":"���","id":"7798797857441336066"}]}
 * @param postList �����µĸ�λ ArrayList<Post.id>
 */
function Department(id, parentId, name, hasChild, path, postList, roleList, isInternal, concurents, description, accountId){
    this.id = id;
    this.parentId = parentId;
    this.name = name;
    this.hasChild = hasChild;
    this.path = path;
    this.postList = postList;
    this.roleList = roleList;
    this.isInternal = isInternal == 0 ? false : true;
    this.concurents = concurents;
    this.description = description;
    this.accountId = accountId;

    //���������е���Ա,�����Ӳ���,�Լ�������Ա
    this.allMembers = null;
    this.allMembersMap = null; //<Member.id, Member>
    //������ֱ����Ա������������Ա
    this.directMembers = new ArrayList();
    this.directMembersExist = {};
    //ֱ���Ӳ���
    this.directChildren = null;
    //���е��Ӳ���
    this.allChildren = null;
    //��ְ��Ա
    this.concurentMembers = null;

    //�����µĸ�λ
    this.Dposts = null;
    //�����µĽ�ɫ
    this.Droles = null;

    //����ȫ��
    this.fullName = null;
}

Department.prototype.toString = function(){
    return this.name;
};

/**
 * ȡ�ò����µĸ�λ�б�
 * @return List<Post>
 */
Department.prototype.getPosts = function(){
    if(!this.postList){
        return null;
    }

    if(this.Dposts){
        return this.Dposts;
    }

    this.Dposts = new ArrayList();

    for(var i = 0; i < this.postList.size(); i++) {
        var postId = this.postList.get(i);
        var post = getObject(Constants_Post, postId);

        this.Dposts.add(post);
    }

    return this.Dposts;
};

/**
 * �õ����������еĽ�ɫ
 */
Department.prototype.getRoles = function(){
    if(!this.roleList){
        return null;
    }

    if(this.Droles){
        return this.Droles;
    }

    this.Droles = new ArrayList();
    for(var i = 0; i < this.roleList.size(); i++) {
        var roleId = this.roleList.get(i);

        var role = getObject(Constants_Role, roleId);
        this.Droles.add(role);
    }

    return this.Droles;
}
/**
 * ���������е���Ա,�����Ӳ���,�Լ�������Ա,��ְ��Ա
 */
Department.prototype.getAllMembers = function(){
    if(this.allMembers == null){
        this.allMembers = new ArrayList();

        var _departments = getDataCenter(Constants_Department, this.accountId);
        for(var i = 0; i < _departments.size(); i++){
            var d = _departments.get(i);
            if(!(d.isInternal == false) && checkIsChildDepartment(this.path, d.path)){
                this.allMembers.addList(d.getDirectMembers());
            }
        }

        this.allMembers.addList(this.getDirectMembers());
    }

    function checkIsChildDepartment(parentPath, childPath){
        return childPath.indexOf(parentPath) == 0;
    }

    return this.allMembers;
}

/**
 * �õ��ò�����������<Member.Id, Member>
 */
Department.prototype.getAllMembersMap = function(){
    if(this.allMembersMap == null){
        this.allMembersMap = new Properties();
        var _allMembers = this.getAllMembers();
        for(var i = 0; i < _allMembers.size(); i++) {
            var m = _allMembers.get(i);
            this.allMembersMap.put(m.id, m);
        }
    }

    return this.allMembersMap;
}

/**
 * ���ֱ�ӳ�Ա������������Ա,��ְ��Ա������ظ���ֻ��ʾһ������������������
 */
Department.prototype.addDirectMembers = function(member, isCheck){
    var isExist = false;
    if(isCheck == true){
        isExist = this.directMembersExist[member.id];
    }

    if(!isExist){ //����������
        this.directMembers.add(member);
        this.directMembersExist[member.id] = true;
    }
}

/**
 * �õ����ŵ�ֱ�ӳ�Ա������������Ա,��ְ��Ա
 */
Department.prototype.getDirectMembers = function(){
    return this.directMembers;
}

/**
 * �õ�ֱ���Ӳ���
 */
Department.prototype.getDirectChildren = function(){
    if(this.directChildren){
        return this.directChildren;
    }

    return new ArrayList();
}

/**
 *
 */
Department.prototype.getAllChildren = function(){
    if(!this.allChildren){
        this.allChildren =  new ArrayList();

        var currentChildren = this.getDirectChildren();
        this.allChildren.addList(currentChildren);

        for(var i = 0; i < currentChildren.size(); i++) {
            this.allChildren.addList(currentChildren.get(i).getAllChildren());
        }
    }

    return this.allChildren;
}

/**
 * �õ���ְ��Ա
 */
Department.prototype.getConcurents = function(){
    if(this.concurentMembers){
        return this.concurentMembers;
    }

    this.concurentMembers = new ArrayList();
    if(this.concurents){
        for(var i = 0; i < this.concurents.length; i++) {
            //{"DN":"���۲�","A":"-7402591981046643031","PN":"ְԱ","N":"���","id":"7798797857441336066","GL":"5744187978606337796"}
            var em = this.concurents[i];

            var member = getObject(Constants_concurentMembers, em[Constants_key_id]);
            var index = this.concurentMembers.indexOf(member);
            if(index < 0){
                this.concurentMembers.add(member);
            }
        }
    }

    return this.concurentMembers;
}

Department.prototype.getFullName = function(){
    if(this.fullName == null){
        this.fullName = this.name;

        var parentPath = getDepartmentParentPath(this.path);
        var parentDepartment = Path2Depart[parentPath];

        if(parentDepartment){
            var parentDepartmentFullName = parentDepartment.getFullName();
            this.fullName = parentDepartmentFullName + "/" + this.fullName;
        }
    }

    return this.fullName;
}

/****************************************************************
 * @param id
 * @param name
 * @param description
 */
function Post(id, name, type, code, description, accountId){
    this.id = id;
    this.name = name;
    this.type = type;
    this.code = code;
    this.description = description;
    this.accountId = accountId;

    this.members = new ArrayList();
    this.membersExist = {};
}

Post.prototype.getMembers = function(){
    return this.members;
}

Post.prototype.addMember = function(member, isCheck){
    var isExist = false;
    if(isCheck == true){
        isExist = this.membersExist[member.id];
    }

    if(!isExist){ //����������
        this.members.add(member);
        this.membersExist[member.id] = true;
    }
}

Post.prototype.getAllMembers = function(){
    return this.members;
}

/****************************************************************
 * @param id
 * @param parentId
 * @param name
 * @param hasChild
 * @param sortId
 * @param groupLevelId ���䵽���ŵ�ְ�񼶱�id������sortId
 * @param description
 */
function Level(id, parentId, name, hasChild, sortId, groupLevelId, code, description, accountId){
    this.id = id;
    this.parentId = parentId;
    this.name = name;
    this.hasChild = hasChild;
    this.sortId = sortId;
    this.groupLevelId = groupLevelId;
    this.code = code;
    this.description = description;
    this.accountId = accountId;

    this.members = null;
}
Level.prototype.getMembers = function(){
    if(this.members){
        return this.members;
    }

    this.members = new ArrayList();

    var _members = getDataCenter(Constants_Member, this.accountId);
    for(var i = 0; i < _members.size(); i++){
        var member = _members.get(i);
        if(member.levelId == this.id){
            this.members.add(member);
        }
    }

    return this.members;
}

Level.prototype.getAllMembers = function(){
    return this.getMembers();
}

/**
 * @param id
 * @param name
 * @param description
 */
function Role(id, name, type, bond, description, accountId){
    this.id = id;
    this.name = name;
    this.type = type;
    this.bond = bond;
    this.description = description;
    this.accountId = accountId;
}

/****************************************************************
 * @param id
 * @param name
 * @param departmentId
 * @param postId
 * @param secondPostIds List<[Department.id, Post.id]>
 * @param levelId
 * @param email
 * @param mobile
 * @param description
 */
function Member(id, name, sortId, departmentId, postId, secondPostIds, levelId, _isInternal, email, mobile, description, accountId){
    this.id = id;
    this.name = name;
    this.sortId = parseInt(sortId);
    this.departmentId = departmentId;
    this.departmentName = "";//��Ա���ڲ������ƣ�����ȫ���Ų�ѯ�����ʾȫ·��
    this.postId = postId;
    this.secondPostIds = secondPostIds;
    this.levelId = levelId;
    this.isInternal = _isInternal == 0 ? false : true;
    this.email = email;
    this.mobile = mobile;
    this.description = description;
    this.accountId = accountId;

    //һ����Member����չ���ԣ�ͨ��������������и�ֵ��֮�������¸�ֵ

    this.department = null;
    this.post = null;
    this.level = null;
    this.teams = null;
    this.secondPost = null; //Properties<departmentId, ArrayList<Post>>

    //�ֱ�---�����Ա�ܼ�
    this.secretLevel = null;
}

Member.prototype.clone = function(){
    var newMember = new Member();
    newMember.id = this.id;
    newMember.name = this.name;
    newMember.sortId = this.sortId;
    newMember.departmentId = this.departmentId;
    newMember.postId = this.postId;
    newMember.secondPostIds = this.secondPostIds;
    newMember.levelId = this.levelId;
    newMember.isInternal = this.isInternal;
    newMember.email = this.email;
    newMember.mobile = this.mobile;
    newMember.description = this.description;
    newMember.accountId = this.accountId;

    //һ����Member����չ���ԣ�ͨ��������������и�ֵ��֮�������¸�ֵ
    newMember.department = this.department;
    newMember.post = this.post;
    newMember.level = this.level;
    newMember.teams = this.teams;
    newMember.secondPost = this.secondPost;

    //�ֱ�---�����Ա�ܼ�
    newMember.secretLevel = this.secretLevel;
    return newMember;
}

Member.prototype.getLevel = function(){
    if(this.level == null){
        this.level = getObject(Constants_Level, this.levelId);
    }

    return this.level;
}

Member.prototype.getDepartment = function(){
    if(this.department == null){
        this.department = getObject(Constants_Department, this.departmentId);
    }

    return this.department;
}

Member.prototype.getPost = function(){
    if(this.post == null){
        this.post = getObject(Constants_Post, this.postId);
    }

    return this.post;
}

Member.prototype.getSecondPost = function(){
    if(this.secondPost == null){
        if(this.secondPostIds){
            this.secondPost = new Properties();

            for(var i = 0; i < this.secondPostIds.size(); i++) {
                var dId = this.secondPostIds.get(i)[0];
                var pId = this.secondPostIds.get(i)[1];

                var p = getObject(Constants_Post, pId);
                if(p){
                    var _posts = this.secondPost.get(dId);
                    if(_posts == null){
                        _posts = new ArrayList();
                        this.secondPost.put(dId, _posts);
                    }

                    _posts.add(p);
                }
            }
        }
        else{
            this.secondPost = EmptyProperties;
        }
    }

    return this.secondPost;
}

/**
 * �жϵ�ǰ���Ƿ���ָ�����ż�ְ
 */
Member.prototype.isSecondPostInDept = function(departmentId){
    return this.getSecondPost().get(departmentId) != null;
}

/**
 * ���ݼ�ְ��λ�õ��Ҽ�ְ����
 */
Member.prototype.getSecondDepartmentId = function(postId){
    if(this.secondPostIds == null){
        return null;
    }

    for(var i = 0; i < this.secondPostIds.size(); i++) {
        var pId = this.secondPostIds.get(i)[1];

        if(pId == postId){
            return this.secondPostIds.get(i)[0];
        }
    }

    return null;
}

Member.prototype.getSecondDepartmentIds = function(){
    if(this.secondPostIds == null){
        return null;
    }

    var result = new Set();

    for(var i = 0; i < this.secondPostIds.size(); i++) {
        result.add(this.secondPostIds.get(i)[0]);
    }

    return result;
}

Member.prototype.toString = function(){
    return "id=" + this.id + ", name=" + this.name + ", postId=" + this.postId +
            ", levelId=" + this.levelId + ", departmentId=" + this.departmentId;
}

/****************************************************************
 * @param id
 * @param type ���� 1 - ���� 2 - ϵͳ�� 3 - ��Ŀ��
 * @param name
 * @param teamSupervisors ArrayList<Member.id> �������
 * @param teamMembers ArrayList<Member.id> ��ĳ�Ա
 * @param teamLeaders ArrayList<Member.id> ����쵼
 * @param teamRelatives ArrayList<Member.id> ��Ĺ�����Ա
 * @param description
 */
function Team(id, type, name, depId, teamLeaders, teamMembers, teamSupervisors, teamRelatives, externalMember, description, accountId){
    this.id = id;
    this.type = type;
    this.name = name;
    this.depId = depId;
    this.teamLeaders = teamLeaders; //����
    this.teamMembers = teamMembers; //��Ա
    this.teamSupervisors = teamSupervisors; //�쵼
    this.teamRelatives = teamRelatives; //������Ա
    this.externalMember = externalMember || []; //�ⵥλ��Ա
    this.description = description;
    this.accountId = accountId || "";

    this.department = null;

    this.leaders = new ArrayList();
    this.members = new ArrayList();
    this.supervisors = new ArrayList();
    this.relatives = new ArrayList();

    this.isInit = false;
}

/**
 * ȡ������������
 */
Team.prototype.getDepartment = function(){
    if(!this.department){
        if(!this.depId || this.depId == -1){
            return null;
        }

        this.department = getObject(Constants_Department, this.depId);
    }

    return this.department;
}

/**
 * ��ʼ����Ա
 */
Team.prototype.initMembers = function(){
    if(this.isInit == true){
        return;
    }

    for(var i = 0; i < this.externalMember.length; i++) {
        var em = this.externalMember[i];
        var member = new Member(em[Constants_key_id], em["N"], 999999, null, null, null, null, true, em["Y"], em["M"], '');
        member.type = "E";
        member.departmentName = em["DN"] || "";
        member.accountId = em["A"];

        //�ֱ�---�����Ա�ܼ�
        member.secretLevel = em["SL"];

        addExMember(member);
    }

    var temp = dataCenterMap[currentAccountId_orgDataCenter][Constants_Member] || {};

    for(var i = 0; i < this.teamLeaders.size(); i++) {
        var memberId = this.teamLeaders.get(i);
        var member = temp[memberId];

        if(member != null){
            this.leaders.add(member);
        }
    }

    for(var i = 0; i < this.teamMembers.size(); i++) {
        var memberId = this.teamMembers.get(i);
        var member = temp[memberId];

        if(member != null){
            this.members.add(member);
        }
    }

    for(var i = 0; i < this.teamSupervisors.size(); i++) {
        var memberId = this.teamSupervisors.get(i);
        var member = temp[memberId];

        if(member != null){
            this.supervisors.add(member);
        }
    }

    for(var i = 0; i < this.teamRelatives.size(); i++) {
        var memberId = this.teamRelatives.get(i);
        var member = temp[memberId];

        if(member != null){
            this.relatives.add(member);
        }
    }

    this.isInit = true;
}

/**
 * �õ���Ա�����ܡ���Ա����Id
 */
Team.prototype.getAllMemberIds = function(){
    var allMemberIds = new ArrayList();
    allMemberIds.addList(this.teamLeaders);
    allMemberIds.addList(this.teamMembers);

    return allMemberIds;
}


/**
 * ���еĳ�Ա���������ܡ���Ա
 */
Team.prototype.getAllMembers = function(){
    this.initMembers();
    var allMembers = new ArrayList();

    allMembers.addList(this.leaders);
    allMembers.addList(this.members);

    return allMembers;
}

/**
 * �õ��������
 * @return List<Member>
 */
Team.prototype.getLeaders = function(){
    this.initMembers();
    return this.leaders;
}

/**
 * �õ���ĳ�Ա
 *
 * @return List<Member>
 */
Team.prototype.getMembers = function(){
    this.initMembers();
    return this.members;
}

/**
 * �õ�����쵼
 * @return List<Member>
 */
Team.prototype.getSupervisors = function(){
    this.initMembers();
    return this.supervisors;
}

/**
 * �õ���Ĺ�����Ա
 * @return List<Member>
 */
Team.prototype.getRelatives = function(){
    this.initMembers();
    return this.relatives;
}

function addExMember(member){
    try {
        var obj = dataCenterMap[currentAccountId_orgDataCenter][Constants_Member][member.id];
        if(!obj){
            getDataCenter(Constants_Member).add(member);
            dataCenterMap[currentAccountId_orgDataCenter][Constants_Member][member.id] = member;
        }
    }
    catch (e) {
        alert(e.message)
    }
}

/**************************************************************
 * �ⲿ��λ�����ڹ��Ľ���
 */
function ExchangeAccount(id, name, description){
    this.id = id;
    this.name = name;
    this.isInternal = false;
    this.description = description;
}

/**************************************************************
 * �����飬���ڹ���
 */
function OrgTeam(id, name, description){
    this.id = id;
    this.name = name;
    this.description = description;
}
OrgTeam.prototype.toString = function(){
    return this.id + ", " + this.name;
}

/****************************************************************
 * ������Ա
 */
function RelatePeople(type, name, description){
    this.type = type;
    this.name = name;
    this.description = description;

    this.memberOrginal = new ArrayList();

    this.members = null;
}

RelatePeople.prototype.addMember = function(o){
    this.memberOrginal.add(o);
}

RelatePeople.prototype.getMembers = function(){
    if(this.members == null){
        var st = new Date();
        this.members = new ArrayList();
        for ( var i = 0; i < this.memberOrginal.size(); i++) {
            var o = this.memberOrginal.get(i);
            var em = o["E"];
            if(em){
                var member = new Member(o["K"], em["N"], 999999, null, null, null, null, true, em["Y"], em["M"], '');
                member.type = "E";
                member.departmentName = em["DN"] || "";
                member.accountId = em["A"];

                //�ֱ�---�����Ա�ܼ�
                member.secretLevel = em["SL"];

                addExMember(member);
                this.members.add(member);
            }
            else{
                var member = dataCenterMap[currentAccountId_orgDataCenter][Constants_Member][o["K"]];
                if(member != null){
                    this.members.add(member);
                }
            }
        }
    }

    return this.members;
}

RelatePeople.prototype.toString = function(){
    return this.id + ", " + this.name;
}

/*******************************************************************
 * ����Ա
 */
function Admin(id, name, role, accountId, description){
    this.id = id;
    this.name = name;
    this.role = role;
    this.accountId = accountId;
    this.description = description;
};

Admin.prototype.toString = function(){
    return this.is + ", " + this.name;
};

/**
 * ���ؼ�
 * @param {} id
 * @param {} name
 */
function FormField(id, name, departmentRole){
    this.id = id;
    this.name = name;
    this.departmentRole = departmentRole;
}
FormField.prototype.getRoles = function(){
    var r = new ArrayList();

    if(this.departmentRole){
        for(var i = 0; i < this.departmentRole.length; i++){
            r.add(this.departmentRole[i]);
        }
    }

    return r;
};
FormField.prototype.toString = function(){
    return this.name + ", " + this.id;
};

/**
 * �ۺϰ칫�ؼ�
 */
function OfficeField(id, name, departmentRole){
    this.id = id;
    this.name = name;
    this.departmentRole = departmentRole;
}
OfficeField.prototype.getRoles = function(){
    var r = new ArrayList();

    if(this.departmentRole){
        for(var i = 0; i < this.departmentRole.length; i++){
            r.add(this.departmentRole[i]);
        }
    }

    return r;
};
OfficeField.prototype.toString = function(){
    return this.id + ", " + this.name;
};

/**
 * ��̬�ڵ�
 * @param id
 * @param name
 * @returns
 */
function Node(id, name, departmentRole){
    this.id = id;
    this.name = name;
    this.departmentRole = departmentRole;
}
Node.prototype.getRoles = function(){
    var r = new ArrayList();

    if(this.departmentRole){
        for(var i = 0; i < this.departmentRole.length; i++){
            r.add(this.departmentRole[i]);
        }
    }

    return r;
};
Node.prototype.toString = function(){
    return this.id + ", " + this.name;
};
/*****************************************************************************************************
* �����ϵ��ҳǩ
*/

function OrgRecent(id, name, em) {
    this.id = id;
    this.name = name;
    this.type = "Member"
    this.em = em;
}

OrgRecent.prototype.getDepartment = function(){
    var _temp = getObject(Constants_Member, this.id);
    return getObject(Constants_Department, _temp.departmentId);
}

OrgRecent.prototype.initMembers = function(){
   var em =this.em;
  if(em){
      var member = new Member(this.id, em["N"], 999999, null, null, null, null, true, em["Y"], em["M"], '');
      member.type = "E";
      member.departmentName = em["DN"] || "";
      member.accountId = em["A"];
      //�ֱ�---�����Ա�ܼ�
      member.secretLevel = em["SL"];

      addExMember(member);
  }
}

OrgRecent.prototype.getOneMember = function(){
  this.initMembers();
    return getObject(Constants_Member, this.id);
}
/******************************************************************************************************/
/******************************************************************************************************/
var currentAccountId_orgDataCenter    = null;
var currentMemberId_orgDataCenter  = null;

var ajaxLoadOrganization = "ajaxSelectPeopleManager";
var Constants_key_id = "K";

var hasLoadOrgModel = new Properties();
var hasLoadExchangeAccountModel = new Properties();

//��֯ģ��ʱ���
var orgLocalTimestamp = new Properties();

/**
 * Properties<accountId, Properties<EntityType, List<Entity>>>
 *
 * �ö���Ҫֱ�ӷ��ʣ�����getDataCenter(type)
 */
var dataCenter = new Properties();

/**
 * ���еĶ���������
 *
 * {accountId, {EntityType, {id, Entity}}}
 */
var dataCenterMap = {};

//~ ���еĵ�λ <account.id, Account>
var allAccounts = new Properties();
var rootAccount = new Account();

/**
 * ְ�񼶱� {accountId, {hashCode, level.id}}
 */
var levelHashCodeMap = {};
var departmentHashCodeMap = {};
var postHashCodeMap = {};

/**
 * ȡ����֯ģ������
 *
 * @param type ���ͣ����û�з�������
 */
function getDataCenter(type, accountId){
    accountId = accountId || currentAccountId_orgDataCenter;
    if(!hasLoadOrgModel.get(accountId)){
        return null;
    }

    if(type){
        var accountDataCenter = dataCenter.get(accountId);

        if(accountDataCenter){
            return accountDataCenter.get(type);
        }
    }

    return dataCenter.get(accountId);
}

/**
 * �������ͺ�Idȡ��Object
 */
function getObject(type, id, accountId0){
    if(type == Constants_Account){
        return allAccounts.get(id);
    }
    var _accountId = accountId;
    var accountId = accountId0 || currentAccountId_orgDataCenter;

    if(!hasLoadOrgModel.get(accountId)){
        return null;
    }

    var object = null;
    try {
        object = dataCenterMap[accountId][type][id]; //�ӵ�ǰ�ĵ�λ��
        if(object){
            return object;
        }

        if(accountId0 != null){ //���ָ���˵�λ���Ͳ��ٲ�ȫ�֣��ʹ˷���
            return object;
        }
    }
    catch (e) {
    }
    if(!_accountId){
      for(var dataCenterItem in dataCenterMap) {
        if(dataCenterMap[dataCenterItem]){
          try{
            object = dataCenterMap[dataCenterItem][type][id];
          }catch(e){}
        }
        if(object){
          return object;
        }
      }
    }

    return null;
}

function getObjects(type, id, accountId){
    if(type == Constants_Account){
        return allAccounts.get(id);
    }

    accountId = accountId || currentAccountId_orgDataCenter;

    if(!hasLoadOrgModel.get(accountId)){
        return null;
    }

    var count = 0;
    var objects = [];
    try {
        var list = getDataCenter(type, accountId);
        for ( var i = 0; i < list.size(); i++) {
            if(list.get(i).id == id){
                objects[count++] = list.get(i);
            }
        }
    }
    catch (e) {
    }

    return objects;
}

//Map<Department.path, Department>
var Path2Depart = {};

//��ǰ�����ⲿ��Ա���������Ĺ�����Χ[Department.path]
var ExternalMemberWorkScope = new ArrayList();

//��ǰ�����ڲ���Ա���ܷ�����Щ�ⲿ��Ա <departmentId, List<memberId>>
var ExtMemberScopeOfInternal = new Properties();

/********************** Data Center *************************
 * Load based data
 *
 * ������֯ģ������
 *
 * @param accountId ��Ҫ���ص�λ
 */
function initOrgModel(accountId, memberId, extParameters){
    if(accountId && memberId){
        currentAccountId_orgDataCenter = accountId;
        currentMemberId_orgDataCenter  = memberId;
    }

    this.invoke = function(){

    };

    var accountDataCenter = dataCenter.get(currentAccountId_orgDataCenter);

    var departments   = null; //����
    var teams         = null; //��
    var posts         = null; //��λ
    var levels        = null; //ְ�񼶱�
    var members       = null; //��Ա
    var roles         = null; //�����ɫ
    var outworkers    = null; //�ⲿ��Ա
    var exchangeAccounts   = null; //�ⲿ��λ�����ڹ��Ľ���
    var orgTeams           = null; //�����飬���ڹ���
    var relatePeoples      = null; //������Ա
    var concurentMembers   = null; //��ְ��Ա��ֻ���˵�Id�͵�λId
    var admins             = null; //����Ա
    var formFields         = null; //���ؼ�
    var officeFields       = null; //�ۺϰ칫�ؼ�
    var nodes              = null; //��̬�ڵ�
    var supernodes         = null; //�����ڵ�
    var orgrecent          = null; //���ҳǩ

    if(!accountDataCenter){ //��һ�μ���
        accountDataCenter = new Properties();

        departments   = new ArrayList();
        teams         = new ArrayList();
        posts         = new ArrayList();
        levels        = new ArrayList();
        members       = new ArrayList();
        roles         = new ArrayList();
        outworkers    = new ArrayList();
        exchangeAccounts    = new ArrayList();
        orgTeams            = new ArrayList();
        relatePeoples       = new ArrayList();
        concurentMembers    = new ArrayList();
        admins              = new ArrayList();
        formFields          = new ArrayList();
        officeFields        = new ArrayList();
        nodes               = new ArrayList();
        supernodes          = new ArrayList();
        orgrecent           = new ArrayList();

        accountDataCenter.put(Constants_Department, departments);
        accountDataCenter.put(Constants_Post, posts);
        accountDataCenter.put(Constants_Level, levels);
        accountDataCenter.put(Constants_Member, members);
        accountDataCenter.put(Constants_Team, teams);
        accountDataCenter.put(Constants_Role, roles);
        accountDataCenter.put(Constants_Outworker, outworkers);
        accountDataCenter.put(Constants_ExchangeAccount, exchangeAccounts);
        accountDataCenter.put(Constants_OrgTeam, orgTeams);
        accountDataCenter.put(Constants_RelatePeople, relatePeoples);
        accountDataCenter.put(Constants_concurentMembers, concurentMembers);
        accountDataCenter.put(Constants_Admin, admins);
        accountDataCenter.put(Constants_FormField, formFields);
        accountDataCenter.put(Constants_OfficeField, officeFields);
        accountDataCenter.put(Constants_Node, nodes);
        accountDataCenter.put(Constants_WfSuperNode, supernodes);
        accountDataCenter.put(Constants_OrgRecent, orgrecent);
    }
    else{
        departments   = accountDataCenter.get(Constants_Department);
        teams         = accountDataCenter.get(Constants_Team);
        posts         = accountDataCenter.get(Constants_Post);
        levels        = accountDataCenter.get(Constants_Level);
        members       = accountDataCenter.get(Constants_Member);
        roles         = accountDataCenter.get(Constants_Role);
        outworkers    = accountDataCenter.get(Constants_Outworker);
        exchangeAccounts    = accountDataCenter.get(Constants_ExchangeAccount);
        orgTeams            = accountDataCenter.get(Constants_OrgTeam);
        relatePeoples       = accountDataCenter.get(Constants_RelatePeople);
        concurentMembers    = accountDataCenter.get(Constants_concurentMembers);
        admins              = accountDataCenter.get(Constants_Admin);
        formFields          = accountDataCenter.get(Constants_FormField);
        officeFields        = accountDataCenter.get(Constants_OfficeField);
        nodes               = accountDataCenter.get(Constants_Node);
        supernodes          = accountDataCenter.get(Constants_WfSuperNode);
        orgrecent           = accountDataCenter.get(Constants_OrgRecent);
    }

    var departmentsMap   = null; //����
    var teamsMap         = null; //��
    var postsMap         = null; //��λ
    var levelsMap        = null; //ְ�񼶱�
    var membersMap       = null; //��Ա
    var rolesMap         = null; //�����ɫ
    var outworkersMap    = null; //�ⲿ��Ա
    var exchangeAccountsMap   = null; //�ⲿ��λ�����ڹ��Ľ���
    var orgTeamsMap           = null; //�����飬���ڹ��Ľ���
    var relatePeoplesMap      = null; //������Ա
    var concurentMembersMap   = null; //��ְ��Ա��ֻ���˵�Id�͵�λId
    var adminsMap             = null; //����Ա
    var formFieldsMap         = null; //���ؼ�
    var officeFieldsMap       = null; //�ۺϰ칫�ؼ�
    var nodesMap              = null; //��̬�ڵ�
    var supernodesMap         = null; //�����ڵ�
    var orgrecentMap          = null; //�����ϵ��

    var accountDataCenterMap = dataCenterMap[currentAccountId_orgDataCenter];

    if(!accountDataCenterMap){ //��һ�μ���
        accountDataCenterMap = {};

        departmentsMap   = {};
        teamsMap         = {};
        postsMap         = {};
        levelsMap        = {};
        membersMap       = {};
        rolesMap         = {};
        outworkersMap    = {};
        exchangeAccountsMap    = {};
        orgTeamsMap            = {};
        relatePeoplesMap       = {};
        concurentMembersMap    = {};
        adminsMap              = {};
        formFieldsMap          = {};
        officeFieldsMap        = {};
        nodesMap               = {};
        supernodesMap          = {};
        orgrecentMap           = {};

        accountDataCenterMap[Constants_Department] = departmentsMap;
        accountDataCenterMap[Constants_Post] = postsMap;
        accountDataCenterMap[Constants_Level] = levelsMap;
        accountDataCenterMap[Constants_Member] = membersMap;
        accountDataCenterMap[Constants_Team] = teamsMap;
        accountDataCenterMap[Constants_Role] = rolesMap;
        accountDataCenterMap[Constants_Outworker] = outworkersMap;
        accountDataCenterMap[Constants_ExchangeAccount] = exchangeAccountsMap;
        accountDataCenterMap[Constants_OrgTeam] = orgTeamsMap;
        accountDataCenterMap[Constants_RelatePeople] = relatePeoplesMap;
        accountDataCenterMap[Constants_concurentMembers] = concurentMembersMap;
        accountDataCenterMap[Constants_Admin] = adminsMap;
        accountDataCenterMap[Constants_FormField] = formFieldsMap;
        accountDataCenterMap[Constants_OfficeField] = officeFieldsMap;
        accountDataCenterMap[Constants_Node] = nodesMap;
        accountDataCenterMap[Constants_WfSuperNode] = supernodesMap;
        accountDataCenterMap[Constants_OrgRecent] = orgrecentMap;
    }
    var levelHashCodes = levelHashCodeMap[currentAccountId_orgDataCenter];
    if(levelHashCodes == null){
        levelHashCodes = {};
        levelHashCodeMap[currentAccountId_orgDataCenter] = levelHashCodes;
    }
    var departmentHashCodes = departmentHashCodeMap[currentAccountId_orgDataCenter];
    if(departmentHashCodes == null){
        departmentHashCodes = {};
        departmentHashCodeMap[currentAccountId_orgDataCenter] = departmentHashCodes;
    }
    var postHashCodes = postHashCodeMap[currentAccountId_orgDataCenter];
    if(postHashCodes == null){
        postHashCodes = {};
        postHashCodeMap[currentAccountId_orgDataCenter] = postHashCodes;
    }

    try {
        var isNeedInitDepartment = false;
        var isNeedInitMember = false;

//      var startTime = new Date().getTime();

        var spm = new selectPeopleManager();

        extParameters = extParameters || "";

        var result = spm.getOrgModel(orgLocalTimestamp.get(currentAccountId_orgDataCenter, ""), currentAccountId_orgDataCenter, currentMemberId_orgDataCenter, extParameters);
        if(result == null || result == ""){
            alert("�������ߣ�ԭ���������ʧȥ����");
            return false;
        }

//      if(!result0 || result0.startsWith("[LOGOUT]")){
//          alert(result0.substring(8));
//          return false;
//      }
//      var result = null;
//      eval("result = " + result0 + ";");
//      if(!result){
//          return;
//      }
//      log.debug("Load and eval : " + (new Date().getTime() - startTime) + "ms");

        orgLocalTimestamp.put(currentAccountId_orgDataCenter, result["timestamp"]); //������ʱ�������Ϊ�µ�ʱ��� ��ʽΪMember=234123;Department=3245243

        // ��λ
        var _accounts = result["Account"];
        if(_accounts){
            allAccounts.clear();

            for(var i = 0; i < _accounts.length; i++) {
                var d = _accounts[i];
                var id = d[Constants_key_id];
                var isRoot = d['R'];

                //Account(id, parentId, path, name, hasChild, shortname, levelScope, description)
                var account = new Account(id, d["P"], null, d["N"], d["C"], d["S"], d["L"], "");

                allAccounts.put(id, account);
            }
        }

        //��ְ key ����id, value Members
        var concurents = result["Concurent"];
        if(concurents != null){
            concurentMembers.clear();
            accountDataCenterMap[Constants_concurentMembers] = concurentMembersMap = {};
            for(var dpid in concurents) {
                var ems = concurents[dpid];
                if(ems){
                    for(var i = 0; i < ems.length; i++) {
                        var em = ems[i];
                        var id = em[Constants_key_id];

                        var member = new Member(id, em["N"], em["S"], dpid, em["P"], null, em["L"], true, em["Y"], em["M"], '');
                        member.type = "E";
                        member.accountId = em["A"];
                        member.departmentName = em["DN"] || "";

                        //�ֱ�---�����Ա�ܼ�
                        member.secretLevel = em["SL"];

                        concurentMembers.add(member);
                        concurentMembersMap[id] = member;
                    }
                }
            }
            isNeedInitMember = true;
        }
        else{
            concurents = {};
        }

//      startTime = new Date().getTime();
        var _posts = result[Constants_Post];
        if(_posts){
            posts.clear();
            accountDataCenterMap[Constants_Post] = postsMap = {};
            for(var i = 0; i < _posts.length; i++) {
                var d = _posts[i];
                var id = d[Constants_key_id];
                var post = new Post(id, d["N"], d["T"], d["C"], "", currentAccountId_orgDataCenter);
                posts.add(post);

                postsMap[id] = post;

                postHashCodes[d["H"]] = id;
            }
        }
//      log.debug("posts : " + (new Date().getTime() - startTime) + "ms");

//      startTime = new Date().getTime();
        var _levels = result[Constants_Level];
        if(_levels){
            levels.clear();
            accountDataCenterMap[Constants_Level] = levelsMap = {};
            for(var i = 0; i < _levels.length; i++) {
                var d = _levels[i];
                var id = d[Constants_key_id];
                var level = new Level(id, "", d["N"], true, d["S"], d["G"], d["C"], "", currentAccountId_orgDataCenter);
                levels.add(level);
                levelsMap[id] = level;

                levelHashCodes[d["H"]] = id;
            }
        }
//      log.debug("levels : " + (new Date().getTime() - startTime) + "ms");

        //���Ž�ɫ
        var departmentRoleIds = new ArrayList();

        var _roles = result[Constants_Role];
        if(_roles){
            roles.clear();
            accountDataCenterMap[Constants_Role] = rolesMap = {};
            for(var i = 0; i < _roles.length; i++) {
                var d = _roles[i];
                var id   = d[Constants_key_id];
                var type = d["T"];
                var name = d["N"];
                var bond = d["B"];

                /**
                 * 1 �̶���ɫ AccountManager AccountAdmin account_exchange account_edoccreate FormAdmin HrAdmin ProjectBuild DepManager DepAdmin department_exchange
                 * 2 ��Խ�ɫ Sender SenderDepManager SenderSuperManager NodeUserDepManager NodeUserSuperManager
                 * 3 �û��Զ����ɫ
                 * 4 �����ɫ(�U��)
                 */
                if(id.indexOf("_") > -1){
                    continue;
                }

                if(type == 3 || type == 4){
                    type = 1;
                }

                var role = new Role(id, name, type, bond, "", currentAccountId_orgDataCenter);
                roles.add(role);
                rolesMap[id] = role;

                if(bond == 2){
                    departmentRoleIds.add(id);
                }
            }
        }
        //����Ա
        var _admins = result[Constants_Admin];
        if(_admins){
            admins.clear();
            accountDataCenterMap[Constants_Admin] = adminsMap = {};
            for(var i = 0; i < _admins.length; i++){
                var a = _admins[i];

                var id = a[Constants_key_id];
                var name = a["N"];

                var admin = new Admin(id, name, a["C"], a["A"], "");
                admins.add(admin);
                adminsMap[id] = admin;
            }
        }

//      startTime = new Date().getTime();
        var _department = result[Constants_Department];
        if(_department){
            Path2Depart = {};
            outworkers.clear();
            departments.clear();
            accountDataCenterMap[Constants_Department] = departmentsMap = {};
            accountDataCenterMap[Constants_Outworker] = outworkersMap = {};

            for(var i = 0; i < _department.length; i++) {
                var d = _department[i];

                var id = d[Constants_key_id];

                isNeedInitDepartment = true;
                var depPosts = new ArrayList();
                var S = d["S"];
                if(S){
                    for(var l = 0; l < S.length; l++) {
                        depPosts.add(postHashCodes[S[l]]);
                    }
                }

                //��ְ��Ա
                var concurentMembersOfDepart = concurents[d[Constants_key_id]];

                //Department(id, parentId, name, hasChild, path, postList, description)
                var path = d["P"];
                var depart = new Department(id, null, d["N"], false, path, depPosts, departmentRoleIds, d["I"], concurentMembersOfDepart, "", currentAccountId_orgDataCenter);

                if(depart.isInternal){ //�ڲ�����
                    departments.add(depart);
                    Path2Depart[path] = depart;
                }
                else{
                    outworkers.add(depart);
                    outworkersMap[id] = depart;
                }

                departmentsMap[id] = depart;
                departmentHashCodes[d["H"]] = id;
            }
        }
//      log.debug("departments : " + (new Date().getTime() - startTime) + "ms");

//      startTime = new Date().getTime();
        var _members = result[Constants_Member];
        if(_members){
            members.clear();
            accountDataCenterMap[Constants_Member] = membersMap = {};
            for(var c = 0; c < concurentMembers.size(); c++) {
                var member = concurentMembers.get(c);
                members.add(member);
                membersMap[member.id] = member;
            }

            for(var i = 0; i < _members.length; i++) {
                var d = _members[i];
                var id = d[Constants_key_id];
                //Member(id, name, departmentId, postId, secondPostIds, levelId, _isInternal, email, mobile, description)
                var deptId = departmentHashCodes[d["D"]];
                var levelId = levelHashCodes[d["L"]];
                var postId = postHashCodes[d["P"]];

                if(!deptId){
                    continue;
                }

                var secondPostIds = null;
                var SP = d["F"];
                if(SP){
                    secondPostIds = new ArrayList();
                    for(var s = 0; s < SP.length; s++) {
                        var secondPostId = new Array();
                        secondPostId[0] = departmentHashCodes[SP[s][0]];
                        secondPostId[1] = postHashCodes[SP[s][1]];
                        secondPostIds.add(secondPostId);
                    }
                }
                else{
                    secondPostIds = EmptyArrayList;
                }

                var member = new Member(id, d["N"], d["S"], deptId, postId, secondPostIds, levelId, d["I"], d["Y"], d["M"], "", currentAccountId_orgDataCenter);
                //�ֱ�---�����Ա�ܼ�
                member.secretLevel = d["SL"];

                members.add(member);
                membersMap[id] = member;
            }

            isNeedInitMember = true;
        }
//      log.debug("members : " + (new Date().getTime() - startTime) + "ms");

        var _teams = result[Constants_Team];
        if(_teams){
            teams.clear();
            accountDataCenterMap[Constants_Team] = teamsMap = {};
            for(var i = 0; i < _teams.length; i++) {
                var d = _teams[i];
                var id = d[Constants_key_id];
                var teamLeaders = new ArrayList();
                teamLeaders.addAll(d["L"]);
                var teamMembers = new ArrayList();
                teamMembers.addAll(d["M"]);
                var teamSupervisors = new ArrayList();
                teamSupervisors.addAll(d["S"]);
                var teamRelatives = new ArrayList();
                teamRelatives.addAll(d["RM"]);

                var team = new Team(id, d["T"] || 2, d["N"], d["O"] || currentAccountId_orgDataCenter, teamLeaders, teamMembers, teamSupervisors, teamRelatives, d["E"], "", d["A"] || currentAccountId_orgDataCenter);
                teams.add(team);

                teamsMap[id] = team;
            }
        }

        var _exchangeAccounts = result[Constants_ExchangeAccount];
        if(_exchangeAccounts){
            exchangeAccounts.clear();
            accountDataCenterMap[Constants_ExchangeAccount] = exchangeAccountsMap = {};
            for(var i = 0; i < _exchangeAccounts.length; i++) {
                var d = _exchangeAccounts[i];
                var id = d[Constants_key_id];

                var exchangeAccount = new ExchangeAccount(id, d["N"], "");
                exchangeAccounts.add(exchangeAccount);
                exchangeAccountsMap[id] = exchangeAccount;
            }
        }

        var _orgTeams = result[Constants_OrgTeam];
        if(_orgTeams){
            orgTeams.clear();
            accountDataCenterMap[Constants_OrgTeam] = orgTeamsMap = {};
            for(var i = 0; i < _orgTeams.length; i++) {
                var d = _orgTeams[i];
                var id = d[Constants_key_id];

                var orgTeam = new OrgTeam(id, d["N"], "");
                orgTeams.add(orgTeam);
                orgTeamsMap[id] = orgTeam;
            }
        }

        var _relatePeoples = result[Constants_RelatePeople];
        if(_relatePeoples){
            relatePeoples.clear();
            accountDataCenterMap[Constants_RelatePeople] = relatePeoplesMap = {};

            var leader = new RelatePeople(1, PeopleRelate_TypeName[1]); // �쵼
            var assistant = new RelatePeople(2, PeopleRelate_TypeName[2]); // ����
            var junior = new RelatePeople(3, PeopleRelate_TypeName[3]); // �¼�
            var confrere = new RelatePeople(4, PeopleRelate_TypeName[4]); //ͬ��

            relatePeoples.add(leader);
            relatePeoples.add(assistant);
            relatePeoples.add(junior);
            relatePeoples.add(confrere);

            relatePeoplesMap[1] = leader;
            relatePeoplesMap[2] = assistant;
            relatePeoplesMap[3] = junior;
            relatePeoplesMap[4] = confrere;

            for(var i = 0; i < _relatePeoples.length; i++) {
                var d = _relatePeoples[i];

                relatePeoplesMap[d["T"]].addMember(d);
            }
        }

        // ���ҳǩ
        var _orgrecent = result[Constants_OrgRecent];
        if(_orgrecent) {
            orgrecent.clear();
            accountDataCenterMap[Constants_OrgRecent] = orgrecentMap = {};
            for(var i = 0; i < _orgrecent.length; i++) {
                var d = _orgrecent[i];
                var id = d[Constants_key_id];
                var orgRec = new OrgRecent(id, d["N"],d["E"]);
                orgrecent.add(orgRec);
                orgrecentMap[id] = orgRec;
            }
        }


        //���ؼ�
        var _formFields = result[Constants_FormField];
        formFields.clear();
        accountDataCenterMap[Constants_FormField] = formFieldsMap = {};
        if(_formFields){
            for(var i = 0; i < _formFields.length; i++) {
                var f = _formFields[i];

                var formField = new FormField(f[Constants_key_id], f["N"], f["R"]);
                formFields.add(formField);
                formFieldsMap[f[Constants_key_id]] = formField;
            }
        }

        //�ۺϰ칫�ؼ�
        var _officeFields = result[Constants_OfficeField];
        if(_officeFields){
            officeFields.clear();
            accountDataCenterMap[Constants_OfficeField] = officeFieldsMap = {};
            for(var i = 0; i < _officeFields.length; i++) {
                var o = _officeFields[i];

                var officeField = new Node(o[Constants_key_id], o["N"], o["R"]);
                officeFields.add(officeField);
                officeFieldsMap[o[Constants_key_id]] = officeField;
            }
        }

        //��̬�ڵ�
        var _nodes = result[Constants_Node];
        if(_nodes){
            nodes.clear();
            accountDataCenterMap[Constants_Node] = nodesMap = {};
            for(var i = 0; i < _nodes.length; i++) {
                var n = _nodes[i];

                var node = new Node(n[Constants_key_id], n["N"], n["R"]);
                nodes.add(node);
                nodesMap[n[Constants_key_id]] = node;
            }
        }

        var _supernodes = result[Constants_WfSuperNode];
        if(_supernodes){
            supernodes.clear();
            accountDataCenterMap[Constants_WfSuperNode] = supernodesMap = {};
            for(var i = 0; i < _supernodes.length; i++) {
                var n = _supernodes[i];

                var node = new Node(n[Constants_key_id], n["N"], n["R"]);
                supernodes.add(node);
                supernodesMap[n[Constants_key_id]] = node;
            }
        }

        //�ڲ���Ա�����Է�����Щ�ⲿ��Ա
        var _ExtMemberScopeOfInternal = result["ExtMemberScopeOfInternal"];
        if(_ExtMemberScopeOfInternal){
            ExtMemberScopeOfInternal.clear();

            for(var extDepatId in _ExtMemberScopeOfInternal) {
                var extMemberIds = new ArrayList();
                extMemberIds.addAll(_ExtMemberScopeOfInternal[extDepatId]);

                ExtMemberScopeOfInternal.put(extDepatId, extMemberIds);
            }
        }

        //�ⲿ��Ա�����Է�����Щ�ڲ���Ա
        var _ExternalMemberWorkScope = result["ExternalMemberWorkScope"];
        if(_ExternalMemberWorkScope){
            ExternalMemberWorkScope.clear();

            for(var i = 0; i < _ExternalMemberWorkScope.length; i++) {
                var ws = _ExternalMemberWorkScope[i];
                if(ws.indexOf("D") == 0){
                    var dId = ws.substring(1);
                    var d1 = departmentsMap[departmentHashCodes[dId]];
                    if(d1){
                        ExternalMemberWorkScope.add("D" + d1.path);
                    }
                }
                else if(ws.indexOf("M") == 0){
                    ExternalMemberWorkScope.add(ws);
                }
                else if(ws.indexOf("A") == 0){
                    ExternalMemberWorkScope.clear();
                    ExternalMemberWorkScope.add("0");
                    break;
                }
            }
        }

        if(isNeedInitDepartment){
            intiDepartmentParentId(departments, Path2Depart);
            //���ⲿ������ӵ��ڲ�����
            departments.addList(outworkers);
        }

        for(var i = 0; i < outworkers.size(); i++) {
            var d = outworkers.get(i);
            var parentPath = getDepartmentParentPath(d.path);
            var parentDep = Path2Depart[parentPath];

            if(parentDep != null){
                d.parentId = parentDep.id;
                d.parentDepartment = parentDep;
            }
            else{
                d.parentId = currentAccountId_orgDataCenter;
            }
        }

        if(isNeedInitMember){
            if(!concurentMembers.isEmpty()){//������ְʱ�Ž���ȫ������
                QuickSortArrayList(members, "sortId");
            }

            var lawlevel = levels.getLast();

            for(var i = 0; i < members.size(); i++){
                var member = members.get(i);

                var levelId = member.levelId ? member.levelId : lawlevel != null ? lawlevel.id : null;
                if(levelId){
                    member.level = levelsMap[levelId];
                }

                var d = departmentsMap[member.departmentId];
                if(d){
                    d.addDirectMembers(member, false);
                }
                else{
                    //alert(member.name + "�����ڲ���[" + member.departmentId + "]������")
                }

                if(member.isInternal && member.postId != null){
                    var p = postsMap[member.postId];
                    if(p){
                        p.addMember(member, true);
                        member.post = p;
                    }
                    else{
                        //alert(member.name + "������[" + member.postId + "]������")
                    }
                }

                var sp = member.secondPostIds; //������Ϣ
                if(sp && !sp.isEmpty()){
                    for(var k = 0; k < sp.size(); k++) {
                        var dId = sp.get(k)[0]; //�������ڲ���
                        var d1 = departmentsMap[dId];
                        var pId = sp.get(k)[1]; //���ڸ�λ
                        var p1 = postsMap[pId];
                        if(d1){
                            var newMember = member.clone();
                            newMember.postId = pId;
                            newMember.post = p1;
                            newMember.departmentId = dId;
                            newMember.department = d1;
                            newMember.type = "F";
                            d1.addDirectMembers(newMember, false);

                            if(p1 && member.isInternal){
                                p1.addMember(newMember, true);
                            }
                        }
                    }
                }
            }
        }
    }
    catch (ex1) {
        //alert("loadOrgModel() Exception : " + ex1.message);
      throw ex1
    }

    dataCenter.put(currentAccountId_orgDataCenter, accountDataCenter);
    dataCenterMap[currentAccountId_orgDataCenter] = accountDataCenterMap;

    hasLoadOrgModel.put(currentAccountId_orgDataCenter, true);
}

/**
 * ����path�Բ��ŵ�parent�������µ���
 */
function intiDepartmentParentId(departments, Path2Depart){
    for(var i = 0; i < departments.size(); i++){
        var depart = departments.get(i);
        var parentPath = getDepartmentParentPath(depart.path);
        var parentDepart = Path2Depart[parentPath];

        if(parentDepart){
            depart.parentId = parentDepart.id;

            parentDepart.hasChild = true;
            if(parentDepart.directChildren == null){
                parentDepart.directChildren = new ArrayList();
            }

            parentDepart.directChildren.add(depart);
        }
        else{
            depart.parentId = currentAccountId_orgDataCenter;
        }
    }
}

function getDepartmentParentPath(path){
    return path.substring(0, path.length - 4);
}



/**
 * ֱ���ӽڵ�
 * ???? E (id, parentId)
 * @param list ArrayList<E> ?????? ????????????????parentId????
 * @param parentId ??Id
 * @return ArrayList<E> ????????????????
 */
function findChildInList(list, parentId) {
    var temp = new ArrayList();
    if(list == null){
        return temp;
    }

    for(var i = 0; i < list.size(); i++){
        if(list.get(i).parentId == parentId){
            temp.add(list.get(i));
        }
    }

    return temp;
}

/**
 * �����ӽڵ㣬�������ӵ�
 */
function findAllChildInList(list, parentId) {
    var temp = new ArrayList();
    if(list == null){
        return temp;
    }

    for(var i = 0; i < list.size(); i++){
        var obj = list.get(i);
        if(obj.parentId == parentId){
            temp.add(obj);

            var cList = findAllChildInList(list, obj.id);
            temp.addList(cList);
        }
    }

    return temp;
}

/**
 * ????ID????????????????????????????????????
 * ???? E (id)
 * @param list ArrayList<E> ?????? ????????????????parentId????
 * @param id
 * @return E ????
 */
function findObjectById(list, id){
    if(!list){
        return null;
    }

    for(var i = 0; i < list.size(); i++){
        if(list.get(i).id == id){
            return list.get(i);
        }
    }

    return null;
}
/**
 * ???????????????
 * @param list ArrayList<E>
 * @param keyword Stirng
 * @return tempList ArrayList<E>
 */
function findObjectsLikeName(list, keyword){
    var tempList = new ArrayList();

    if(!list){
        return tempList;
    }
    for(var i = 0; i < list.size(); i++){
        if(list.get(i).name.indexOf(keyword) != -1){
            tempList.add(list.get(i));
        }
    }

    return tempList;
}

/**
 * find parent Object
 * E (id)
 * @param list ArrayList<E> There is the attribute 'parentId' and 'id';
 * @param id current object's id
 * @return E
 */
function findParent(list, id){
    if(!list){
        return null;
    }

    var currentObject = findObjectById(list, id);

    if(currentObject == null){
        return null;
    }

    return findObjectById(list, currentObject.parentId);
}
/**
 * find Mult-Level parent Objects
 * @param list ArrayList<E> There is the attribute 'parentId' and 'id';
 * @param id current object's id
 * @param tempNodes ArrayList empty
 * @return ArrayList the first item is the top parent object
 */
function findMultiParent(list, id, tempNodes){
    if(!list){
        return null;
    }

    var parentObject = findParent(list, id);

    if(tempNodes == null){
        tempNodes = new ArrayList();
    }

    if(parentObject != null){//????????
        tempNodes.add(parentObject);

        findMultiParent(list, parentObject.id, tempNodes);
    }

    var returnNodes = new ArrayList();

    for(var i = tempNodes.size() - 1; i > -1; i--){
        returnNodes.add(tempNodes.get(i));
    }

    return returnNodes;
}

/**
 * ��list�в��ҷ��϶���ĳ������ֵ�Ķ���ֻȡһ��
 */
function findByProperty(list, propertyName, propertyValue){
    if(!list){
        return null;
    }

    for(var i = 0; i < list.size(); i++){
        if(list.get(i)[propertyName] == propertyValue){
            return list.get(i);
        }
    }

    return null;
}

function addPersonalTeam(myAccountId, teamId, teamName, members){
    var teamMemberIds = new ArrayList();
    var e = []; //�ⲿ��Ա��Ϣ
    for(var i = 0; i < members.length; i++) {
        var member = members[i];

        var memberId = member.id;
        var accountId = member.accountId;

        if(accountId != myAccountId){ //�ⵥλ��
            var m = getObject(Constants_Member, memberId, accountId);
            var departmentName = null;
            if(m){
                departmentName = getObject(Constants_Department, m.departmentId, accountId).name;
            }

            e[e.length] = {
                "K" : memberId,
                "N"  : member.name,
                "DN" : departmentName,
                "A"  : accountId
            };
        }

        teamMemberIds.add(memberId);
    }

    var team = new Team(teamId, 1, teamName, -1, new ArrayList(), teamMemberIds, new ArrayList(), new ArrayList(), e, "");

    getDataCenter(Constants_Team, myAccountId).add(team);
    dataCenterMap[myAccountId][Constants_Team][teamId] = team;
}


function initTimeLineDate(){return new MxtTimeLine({id:"timeLine",height:$("#content_layout_body_right").height(),render:"content_layout_body_right",date:timeLineDate[2],timeStep:timeLineDate[0],searchClick:function(){timeLineObjReset(timeLineObj)},editClick:function(){timeLineDialog=$.dialog({url:_ctxPath+"/calendar/calEvent.do?method=editTimeLine",width:425,height:180,targetWindow:getCtpTop(),transParams:{searchFunc:timeLineObjReset,diaClose:timeLineObjDialogClose,timeLineObjResetParam:timeLineObj},title:$.i18n("calendar.editTimeLine.title"),buttons:[{id:"sure",isEmphasize:true,text:$.i18n("calendar.sure"),handler:function(){timeLineDialog.getReturnValue()}},{id:"cancel",text:$.i18n("calendar.cancel"),handler:function(){timeLineDialog.close()}}]})},maxClick:function(){var A=_ctxPath+"/calendar/calEvent.do?method=arrangeTime&type=day";var C=getCurDayStr();var B=C[0]+"-"+C[1]+"-"+C[2];A=A+"&selectedDate="+B;A=A+"&curDay="+B;$("#main").attr("src",A)},action:"timeLineAction",items:timeLineDate[1]})}function getCurDayStr(){var C=timeLineObj.getDate();var A=new Array();if(C.year==""||C.mounth==""||C.day==""){var B=new Date();C.year=B.getFullYear();C.mounth=B.getMonth()+1;C.day=B.getDate()}A[0]=C.year;A[1]=C.mounth;A[2]=C.day;return A}function openPlan(F,E){var D=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+F;var A=new calEventManager();var C=A.isHasDeleteByType(F,"plan");C=C.toString();if(C=="true"){var B=$.dialog({id:"showPlan",url:D,width:$(getCtpTop().document).width()-100,height:$(getCtpTop().document).height()-100,title:$.i18n("plan.dialog.showPlanTitle"),targetWindow:getCtpTop(),buttons:[{text:$.i18n("plan.dialog.close"),handler:function(){B.close();if(E instanceof Function){E()}}}]})}else{var G;if(C=="false"){G=$.i18n("plan.alert.nopotent")}else{if(C=="absence"){G=$.i18n("plan.alert.deleted")}}$.error({msg:G,ok_fn:function(){if(E instanceof Function){E()}}})}}function timeLineAction(C,A){var B=timeLineObj.getDateObj(C);showDate(B,refleshTimeLinePage)}function showDate(C,B){var A=C.type;if(A=="event"){if(curUserID!=undefined){C.curUserID=curUserID}else{C.curUserID=parent.curUserID}dynamicUpdateCalEventDailog(C,B)}else{if(A=="task"){viewTaskInfo4Event(C.id,B)}else{if(A=="plan"){openPlan(C.id,B)}else{if(A=="meeting"){if(C.canView){if(typeof (curNextDate)=="object"){curNextDate=curNextDate.format("yyyy-MM-dd")}openMeeting(C.id,B)}}else{if(A=="collaboration"){showSummayDialog(C.id,C.subject,B)}else{if(A=="edoc"){openEdocByStatus(C.id,C.states,_ctxPath,B)}}}}}}}function timeLineObjReset(D){if(D!=null&&typeof (D)!="undefined"){var C=getCurDayStr();var A=C[0]+"-"+C[1]+"-"+C[2];var B=new timeLineManager();B.getTimeLineResetDate(A,{success:function(E){D.reset({date:C,timeStep:E[0],action:"timeLineAction",items:E[1]})}})}}function timeLineObjDialogClose(){timeLineDialog.close()}function refleshTimeLinePage(){timeLineObjReset(timeLineObj)}function viewTaskInfo4Event(B,C){var E=new calEventManager();var H=E.isHasDeleteByType(B,"task");if(H!=null&&H!=""){$.error({msg:H,ok_fn:function(){if(C instanceof Function){C()}}})}else{var I=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&isTimeLine=2&from=timeLineDate&taskId="+B;var D=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+B;var F=new taskDetailTreeManager();var G=F.checkTaskTree(B);var J="";var A=true;J=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+B;if(G){A=false}removeAllDialog();new projectTaskDetailDialog({url1:I,url2:D,url3:J,openB:true,hideBtnC:A,animate:false})}}function showSummayDialog(E,F,D){var B=_ctxPath+"/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="+E;var C=$(getCtpTop().document).width()-100;var A=$(getCtpTop().document).height()-50;$.dialog({url:B,width:C,height:A,title:F,id:"dialogDealColl",transParams:{callbackOfEvent:D,window:window},targetWindow:getCtpTop()})}var dialogDealColl;function openMeeting(B,C){var A=_ctxPath+"/mtMeeting.do?method=myDetailFrame&id="+B;openCtpWindow({url:A,id:B})}function openEdocByStatus(D,C,A,B){if(C=="3"){openDetail_edoc("listPending","from=Pending&affairId="+D+"&from=Pending",A,B)}else{if((C=="4")){openDetail_edoc("","from=Done&affairId="+D,A,B)}else{}}}function openDetail_edoc(C,B,A,D){if(C=="exchange"){B=B}else{B=A+"/edocController.do?method=detailIFrame&"+B;if("listPending"==C||"listReading"==C||""==C){var E=v3x.openWindow({url:B,FullScrean:"yes",dialogType:v3x.getBrowserFlag("pageBreak")==true?"modal":"1"})}else{var E=v3x.openWindow({url:B,FullScrean:"yes",dialogType:v3x.getBrowserFlag("pageBreak")==true?"modal":"1"})}}if(E=="true"){if(D instanceof Function){D()}}}function accessManagerData(C,B){var A=new calEventManager();return A.isHasDeleteByType(C,B)}var calEventDialogUpdate;function dynamicUpdateCalEventDailog(G,F){var E=accessManagerData(G.id,"event");var B=new calEventManager();var C=false;var D=$.ctx.CurrentUser.id;C=B.isReceiveMember(D,G.id);if(E!=null&&E!=""){$.alert({msg:E,ok_fn:function(){if(E=="${ctp:i18n('calendar.event.create.had.delete')}"){if(F instanceof Function){F()}}}})}else{var A=600;if(G.shareType==1&&G.receiveMemberId==null){A=500}calEventDialogUpdate=$.dialog({id:"calEventUpdate",url:_ctxPath+"/calendar/calEvent.do?method=editCalEvent&id="+G.id,width:600,height:A,targetWindow:getCtpTop(),checkMax:true,transParams:{diaClose:dialogClose,showButton:showBtn,isview:"true",refleshMethod:F},title:$.i18n("calendar.event.search.title"),buttons:[{id:"sure",isEmphasize:true,text:$.i18n("calendar.sure"),handler:function(){calEventDialogUpdate.getReturnValue()}},{id:"update",text:$.i18n("calendar.update"),handler:function(){calEventDialogUpdate.getReturnValue("update")}},{id:"cancel",text:$.i18n("calendar.cancel"),handler:function(){calEventDialogUpdate.close()}},{id:"btnClose",text:$.i18n("calendar.close"),handler:function(){calEventDialogUpdate.close()}}]});calEventDialogUpdate.hideBtn("sure");calEventDialogUpdate.hideBtn("btnClose");calEventDialogUpdate.hideBtn("update");calEventDialogUpdate.hideBtn("cancel");if(typeof (G.curUserID)=="undefined"){G.curUserID=$.ctx.CurrentUser.id}if(G.createUserId!=G.curUserID&&(C==false||C=="false")){calEventDialogUpdate.showBtn("btnClose")}else{calEventDialogUpdate.showBtn("update");calEventDialogUpdate.showBtn("cancel")}}}function dialogClose(C,B,A){calEventDialogUpdate.close();if(B=="true"){if(A instanceof Function){A()}}}function showBtn(){calEventDialogUpdate.showBtn("sure");calEventDialogUpdate.hideBtn("update")};
var portalManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=portalManager",getCustomizeMenusOfMember:function(){return this.ajaxCall(arguments,"getCustomizeMenusOfMember")},getCustomizeShortcutsOfMember:function(){return this.ajaxCall(arguments,"getCustomizeShortcutsOfMember")},getPageTitle:function(){return this.ajaxCall(arguments,"getPageTitle")},getGroupShortName:function(){return this.ajaxCall(arguments,"getGroupShortName")},getGroupSecondName:function(){return this.ajaxCall(arguments,"getGroupSecondName")},getAccountName:function(){return this.ajaxCall(arguments,"getAccountName")},getAccountSecondName:function(){return this.ajaxCall(arguments,"getAccountSecondName")},getProductId:function(){return this.ajaxCall(arguments,"getProductId")},getSpaceMenus:function(){return this.ajaxCall(arguments,"getSpaceMenus")},getSpaceOwnerMenus:function(){return this.ajaxCall(arguments,"getSpaceOwnerMenus")},getSpaceSort:function(){return this.ajaxCall(arguments,"getSpaceSort")},getSpaceMenusForPortal:function(){return this.ajaxCall(arguments,"getSpaceMenusForPortal")},getMenusOfMember:function(){return this.ajaxCall(arguments,"getMenusOfMember")},isExceedMaxLoginNumberServerInAccount:function(){return this.ajaxCall(arguments,"isExceedMaxLoginNumberServerInAccount")},setCurrentUserCustomize:function(){return this.ajaxCall(arguments,"setCurrentUserCustomize")},getGroupAndAccountNameInfo:function(){return this.ajaxCall(arguments,"getGroupAndAccountNameInfo")}});var selectPeopleManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=selectPeopleManager",getOrgModel:function(){return this.ajaxCall(arguments,"getOrgModel")},getQueryOrgModel:function(){return this.ajaxCall(arguments,"getQueryOrgModel")},saveAsTeam:function(){return this.ajaxCall(arguments,"saveAsTeam")}});var calEventManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=calEventManager",getCalEventById:function(){return this.ajaxCall(arguments,"getCalEventById")},isOnePerson:function(){return this.ajaxCall(arguments,"isOnePerson")},isHasDeleteByType:function(){return this.ajaxCall(arguments,"isHasDeleteByType")},isReceiveMember:function(){return this.ajaxCall(arguments,"isReceiveMember")}});var timeLineManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=timeLineManager",getTimeLineResetDate:function(){return this.ajaxCall(arguments,"getTimeLineResetDate")}});var onlineManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=onlineManager",updateOnlineSubState:function(){return this.ajaxCall(arguments,"updateOnlineSubState")}});var portalTemplateManager=RemoteJsonService.extend({jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=portalTemplateManager",transReSetToDefault:function(){return this.ajaxCall(arguments,"transReSetToDefault")},transSaveHotSpots:function(){return this.ajaxCall(arguments,"transSaveHotSpots")},transAllowHotSpotChoose:function(){return this.ajaxCall(arguments,"transAllowHotSpotChoose")},transAllowHotSpotCustomize:function(){return this.ajaxCall(arguments,"transAllowHotSpotCustomize")},getSkinDatas:function(){return this.ajaxCall(arguments,"getSkinDatas")},getAllowSkinStyleChoose:function(){return this.ajaxCall(arguments,"getAllowSkinStyleChoose")},getAllowHotSpotCustomize:function(){return this.ajaxCall(arguments,"getAllowHotSpotCustomize")},transSwitchSkinStyle:function(){return this.ajaxCall(arguments,"transSwitchSkinStyle")},getCurrentPortalTemplateAndHotSpots:function(){return this.ajaxCall(arguments,"getCurrentPortalTemplateAndHotSpots")},transSwitchPortalTemplate:function(){return this.ajaxCall(arguments,"transSwitchPortalTemplate")},getAllowPortalTemplateChoose:function(){return this.ajaxCall(arguments,"getAllowPortalTemplateChoose")},getHotSpotsByTemplateId:function(){return this.ajaxCall(arguments,"getHotSpotsByTemplateId")}});var portalTemplateManagerObject=new portalTemplateManager();
function CtpTimeLine(A){if(A==undefined){A={}}this.id=A.id!=undefined?A.id:Math.floor(Math.random()*100000000);this.timeStep=A.timeStep==undefined?["8:00","18:00"]:A.timeStep;this.timeLineHeight=A.timeLineHeight==undefined?457:A.timeLineHeight;this.scaleArray=new Object();this.date=A.date;if(this.date==undefined){this.date=[];var B=new Date();this.date[0]=B.getFullYear();this.date[1]=B.getMonth()+1;this.date[2]=B.getDate()}this.MonthSub=["","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];this.MonHead=[31,28,31,30,31,30,31,31,30,31,30,31];this.action=A.action;this.searchClick=A.searchClick==undefined?function(){}:A.searchClick;this.editClick=A.editClick==undefined?function(){}:A.editClick;this.maxClick=A.maxClick==undefined?function(){}:A.maxClick;this.initTimeLine()}CtpTimeLine.prototype.initTimeLine=function(){if($("#timeline_close").size()>0){return }$("body").prepend("<div class='timeline_close' id='timeline_close' style='top:"+35*_zoomParam+"px'></div><div id='timeline_box' class='timeline_box' style='top:"+50*_zoomParam+"px'></div><iframe src='' id='timeline_iframe' frameborder='0' class='timeline_iframe' style='top:"+50*_zoomParam+"px'></iframe>");$("#timeline_box").append("<div class='mold_list'><ul><li><em class='mold_icon mold_plan'></em><span class='mold_text'>"+$.i18n("application_5_label")+"</span></li><li><em class='mold_icon mold_meeting'></em><span class='mold_text'>"+$.i18n("application_6_label")+"</span></li><li id='taskmodel'><em class='mold_icon mold_task'></em><span class='mold_text'>"+$.i18n("calendar.arrangeTime.task")+"</span></li><li><em class='mold_icon mold_event'></em><span class='mold_text'>"+$.i18n("calendar.arrangeTime.event")+"</span></li><li><em class='mold_icon mold_collaboration'></em><span class='mold_text'>"+$.i18n("calendar.arrangeTime.collaboration.timed")+"</span></li><li><em class='mold_icon mold_edoc'></em><span class='mold_text'>"+$.i18n("calendar.arrangeTime.doc.timed")+"</span></li></ul></div>");$("#timeline_box").append("<div class='action_box'><span id='action_calender' class='action_calender'></span><span id='action_set' class='action_set'></span></div>");$("#timeline_box").append("<div class='timeline_main_box'><div id='current_day' class='current_day'></div><div id='timeline_main' class='timeline_main'><div class='timeline_main_bg'></div></div></div>");this.timeline_box=$("#timeline_box");this.time_line_main=$("#timeline_main");var A=$("body").height()-$(".layout_header").height();if(A<657){this.timeline_box.height(A-10);$("#timeline_iframe").height(A-10)}else{if(A>657){this.timeline_box.height(657);$("#timeline_iframe").height(657)}}$("#timeline_close").click(function(){$(".timeline_box").hide();$(".timeline_iframe").hide();$("#dragSkin").show();$(this).hide()});$("#action_calender").click(this.maxClick);$("#action_set").click(this.editClick);if(isShowEdoc==true||isShowEdoc=="true"){$(".mold_plan").parents("li").hide();$(".mold_task").parents("li").hide();$(".mold_event").parents("li").hide();$(".mold_edoc").parents("li").hide()}this.resetInit()};CtpTimeLine.prototype.resetInit=function(){this.year=this.date[0];this.month=this.date[1];if(this.month.length==2&&this.month.indexOf("0")==0){this.month=this.month.substr(1)}this.day=this.date[2];this.time_line_date_set=$("<div id='"+this.id+"_time_line_date_set' class='hidden time_line_set'></div>");this.time_line_date_set_mouth=$("<select class='left' id='"+this.id+"_time_line_date_set_mouth'></select>");this.time_line_date_set_day=$("<select class='left' id='"+this.id+"_time_line_date_set_day'></select>");this.time_line_date_set_ok=$("<a class='tooltip_close font_size12 right margin_r_10 margin_t_5 hand color_blue'>"+$.i18n("calendar_ok")+"</a>");this.time_line_date_set_cancel=$("<a class='tooltip_close font_size12 right margin_t_5 hand color_blue'>"+$.i18n("common.button.cancel.label")+"</a>");this.time_line_date_set.append(this.time_line_date_set_mouth);this.time_line_date_set.append("<span class='left font_size12' style='margin-top:2px;margin-right:10px;'>"+$.i18n("calendar_month")+"</span>");this.time_line_date_set.append(this.time_line_date_set_day);this.time_line_date_set.append("<span class='left font_size12 ' style='margin-top:2px;margin-right:2px;'>"+$.i18n("calendar_day")+"</span>");this.time_line_date_set.append(this.time_line_date_set_cancel);this.time_line_date_set.append(this.time_line_date_set_ok);this.timeline_box.append(this.time_line_date_set);var C=this;for(var E=1;E<13;E++){this.time_line_date_set_mouth.append($("<option "+(E==this.date[1]?"selected":"")+">"+E+"</option>"))}this.changeDate(parseInt(this.year,10),parseInt(this.month,10));this.time_line_date_set_mouth.change(function(){C.changeDate(parseInt(C.date[0],10),parseInt($(this).val(),10))});this.time_line_date_set_ok.click(this.searchClick);this.time_line_date_set_cancel.click(function(){C.time_line_date_set.hide()});$("#current_day").html("<span class='current_day_num'>"+this.date[2]+"</span><span class='current_mon_num'>"+this.MonthSub[this.month]+"</span>");this.time_line_date_set_mouth.val(this.month);this.changeDate(parseInt(this.year,10),parseInt(this.month,10));this.timeStepInt=parseInt(this.timeStep[1],10)-parseInt(this.timeStep[0],10);this.subTime=45;if(parseInt(this.timeStep[1],10)-parseInt(this.timeStep[0],10)<10){this.subTime=this.timeLineHeight/this.timeStepInt}for(var D=0;D<(this.timeStepInt+1);D++){var B=$("<div id='"+(parseInt(this.timeStep[0],10)+D)+"_icon' class='time_none'></div>");B.css({top:D*this.subTime});this.time_line_main.append(B);var A=$("<div class='time_hour absolute clearfix'><div class='time_hour_number_00'>:00</div><div class='time_hour_number'>"+(parseInt(this.timeStep[0],10)+D)+"</div></div>");A.css({top:(D*this.subTime+15)});this.time_line_main.append(A);this.scaleArray[parseInt(this.timeStep[0],10)+D]=D*this.subTime}$("#current_day").unbind().toggle(function(){C.time_line_date_set.show()},function(){C.time_line_date_set.hide()})};CtpTimeLine.prototype.initData=function(){if(this.items&&this.items.length>0){for(var E=0;E<this.items.length;E++){var H=this.items[E];var F=H.type;var A=parseInt(H.dateTime,10);var I=H.childItems;if(A<parseInt(this.timeStep[0],10)||A>parseInt(this.timeStep[1],10)){continue}var B=$("<span class='time_one'></span>");B.css({top:this.scaleArray[A]});if(F=="mix"){B=$("<span class='time_more'></span>");B.css({top:this.scaleArray[A]-2})}this.time_line_main.append(B);var C="<div  class='time_content_container'>";for(var D=0;D<I.length;D++){var J=I[D];if(J.account==null||!J.account){J.account=""}var G="<div class='left_l_arrow'>\u25c6</div><div class='left_r_arrow'>\u25c6</div>";if(E%2!=0){G="<div class='right_r_arrow'>\u25c6</div><div class='right_l_arrow'>\u25c6</div>"}C+="<div onclick="+this.action+"('"+J.id+"','"+(J.type==undefined?F:J.type)+"') class='time_dialog_container margin_5 clearfix "+(D==0?"arrowStr":"hidden time_dialog_container_hidden")+"'>"+(D==0?G:"")+"<ul><li class='type_li'><span class='type_icon type_"+J.type+"'></span></li>";C+="<li class='type_content_li'><div class='type_content_li_div'>"+J.subject+"</div>";C+="<div class='clearfix'><span class='left time_account'>"+J.account+"</span><span class='right time_time_date'>"+J.dateTime+"</span></div>";C+="</li></ul></div>"}if(I.length>1){C+="<div class='time_content_more'><span id='number_span'>\u8fd8\u6709"+(I.length-1)+"\u6761</span><span id='number_show' class=' hidden'>"+$.i18n("calendar.arrangeTime.collapse")+"</span></div>"}C+="</div>";var K=$(C);B.append(K);if(E%2==0){K.css({left:36})}else{K.css({right:34})}$(".time_content_more").toggle(function(){$(this).parent().find(".time_dialog_container_hidden").show();$(this).find("#number_show").show();$(this).find("#number_span").hide();$(this).parents(".time_more").css("z-index",100+$(".time_dialog_container_hidden:visible").size()*1)},function(){$(this).parents(".time_more").css("z-index","");$(this).parent().find(".time_dialog_container_hidden").hide();$(this).find("#number_show").hide();$(this).find("#number_span").show()});$(".time_more").unbind().click(function(){$(this).find(".time_content_more").click()})}}};CtpTimeLine.prototype.timeShow=function(){var A=this;$(".timeline_box").slideDown(function(){if($.browser.msie){if($.browser.version=="6.0"){A.timeline_box.css("overflow-y","auto")}}});$(".timeline_iframe").slideDown(function(){$("#timeline_close").show()})};CtpTimeLine.prototype.clearLine=function(){$(".time_one").remove();$(".time_none").remove();$(".time_more").remove();$(".time_hour").remove();$("#current_day").empty();$("#"+this.id+"_time_line_date_set").remove()};CtpTimeLine.prototype.reset=function(A){this.timeStep=A.timeStep==undefined?this.timeStep:A.timeStep;this.date=A.date==undefined?this.date:A.date;this.autoHeight=A.autoHeight==undefined?this.autoHeight:A.autoHeight;this.editClick=A.editClick==undefined?this.editClick:A.editClick;this.maxClick=A.maxClick==undefined?this.maxClick:A.maxClick;this.items=A.items==undefined?this.items:A.items;this.scaleArray=new Object();this.clearLine();this.resetInit();this.initData()};CtpTimeLine.prototype.getSetDate=function(){var B=this.date[0];var D=$("#"+this.id+"_time_line_date_set_mouth").val();var A=$("#"+this.id+"_time_line_date_set_day").val();var E=this.timeStep[0];var C=this.timeStep[1];return{year:B,mounth:D,day:A,fromTime:E,toTime:C}};CtpTimeLine.prototype.getDataObj=function(A){var I=this.items;var E=null;if(I&&I.length>0){for(var C=0;C<I.length;C++){var G=I[C];var D=G.childItems;if(D&&D.length>0){for(var B=0;B<D.length;B++){var F=D[B];var H=F.id;if(H&&H==A){E=F;break}}}}}return E};CtpTimeLine.prototype.setTimeLineDate=function(A){this.year=parseInt(A.year,10);this.mounth=parseInt(A.mounth,10);this.day=parseInt(A.day,10);if(this.mounth==undefined){this.mounth=A.date.getMonth()+1}if(this.day==undefined){this.day=A.date.getDate()}$("#"+this.id+"_date").empty().html(this.mounth+"-"+this.day);$("#"+this.id+"_time_line_date_set_mouth").empty();for(var B=1;B<13;B++){$("#"+this.id+"_time_line_date_set_mouth").append($("<option "+(B==this.mounth?"selected":"")+">"+B+"</option>"))}this.changeDate(parseInt(this.year,10),parseInt(this.mounth,10))};CtpTimeLine.prototype.changeDate=function(B,A){var C=this.MonHead[A-1];if(A==2&&this.IsPinYear(B)){C++}this.writeDay(C)};CtpTimeLine.prototype.writeDay=function(C){var B="";for(var A=1;A<(C+1);A++){B+="<option "+(A==parseInt(this.day,10)?"selected":"")+" value='"+A+"'> "+A+"</option>"}$("#"+this.id+"_time_line_date_set_day").replaceWith("<select class='left "+this.id+"_time_line_date_set_day' id='"+this.id+"_time_line_date_set_day'>"+B+"</select>")};CtpTimeLine.prototype.IsPinYear=function(A){return(0==A%4&&(A%100!=0||A%400==0))};
function showSummayDialogByURL(A,F,E){try{var D=A.indexOf("affairId");var C=A.indexOf("id");var G="";if(D!=-1){G=getMultyWindowId("affairId",A);openCtpWindow({url:A,id:G})}else{if(C!=-1){G=getMultyWindowId("id",A);openCtpWindow({url:A,id:G})}else{openCtpWindow({url:A})}}}catch(B){}};
