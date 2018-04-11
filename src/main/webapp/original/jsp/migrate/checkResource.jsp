<%@ page isELIgnored="false"%>
<script type="text/javascript">
    var resources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
    function checkToolbarResource(){
		var spans = document.getElementsByTagName('span');
		for (var i = 0; i < spans.length; i++) {
			var span = spans[i];
			var resCode = span.getAttribute('resCode');
			if(resCode){
				if(resources.indexOf(resCode) == -1){
					span.style.display = 'none'; 
				}
			}
		};
    }
    checkToolbarResource();    
</script>
