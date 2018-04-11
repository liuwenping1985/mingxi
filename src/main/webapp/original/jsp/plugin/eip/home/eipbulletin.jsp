<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 通知公告  ------>
<div class="s-m-r sm-til fr" style="height: 364px;">
		<h1>通知公告 <a href="javascript:openUrl('${path}/bulData.do?method=bulIndex&typeId=${bulTypeId}&spaceType=&spaceId=')" class="more">更多 ></a></h1>
		<ul class="snr-gg" id="bulsPortalList0" style="padding: 5px 16px 5px 16px;">
		</ul>
	</div>
<script type="text/javascript">

	$(function() {
		bulsAjaxData();
	});
		var numbuls = 8;//公告展示个数
		var typebulsId = new Array();
		function bulsAjaxData(){
				if(typebulsId.length == 0){
					var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable=0&columnCode=pl_bulletin&portalCode="+encodeURI(encodeURI("${portalCode}"));
					var postdetil = ajaxController(url,false);
					if(postdetil){
						for(var i=0;i<postdetil.length;i++){
							typebulsId[i] = postdetil[i].columnDetailId;
						}
					}
				}
				for(i=0;i<typebulsId.length;i++){
		    		var _buls = $("#bulsPortalList"+i);
		    		if(_buls){
						ajaxBul(_buls,typebulsId,i);
		    		}
		    	}
				setTimeout("bulsAjaxData()", 60*1000 );
			}
		function ajaxBul(_buls,typebulsId,i){
			var buls = _buls;
			var url = "zyPortalController.do?method=getBulsPortalListType&num="+numbuls+"&typeId="+typebulsId[i];
						
			$.ajax({
				url:url,
				type:"GET",  
				dataType :'text', 
				success:function(result){
				    var json = $.parseJSON(result);
				    //var _buls = $("#bulsPortalList");
				    var html = "";
				    if(!json){return;}
				    for(var em=0; em < json.length && em < numbuls; em++){
				    	html += "<li><a href=\"javascript:bulView('"+json[em].id+"','"+json[em].spaceType+"','"+json[em].spaceId+"')\" > <i></i>"+json[em].title+"<span>"+json[em].createDate+"</span></a></li>";
				    }
				    	//html += "<a href=\"javascript:openUrl('${path}/bulData.do?method=bulIndex&typeId="+typebulsId+"&spaceType=&spaceId=')\">更多></a>";
				    buls.empty();
				    buls.append(html);
				    			
				}
			});
		}
		//打开详情页面，从首页、版块首页、换一换打开
		function bulView(bulId, _spaceType,_spaceId) {//\"javascript:newsView(
			if(window.parent.$.ctx.CurrentUser.isAdmin){
				return;
			}
		    var url = _ctxPath + "/bulData.do?method=bulView&bulId=" + bulId + "&from=list&spaceType=" + _spaceType + "&spaceId=" + _spaceId;
		    openCtpWindow({
		        'window': window,
		        'url': url
		    });
		}
	</script>