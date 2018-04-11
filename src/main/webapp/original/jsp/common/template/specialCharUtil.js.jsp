<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script>
/**
* 1. + URL 中+号表示空格 %2B 
* 2. 空格 URL中的空格可以用+号或者编码 %20 
* 3. / 分隔目录和子目录 %2F 
* 4. ? 分隔实际的 URL 和参数 %3F 
* 5. % 指定特殊字符 %25 
* 6. # 表示书签 %23 
* 7. & URL 中指定的参数间的分隔符 %26 
* 8. = URL 中指定参数的值 %3D
**/ 
function to16char(str){
	str=str.replace(/\+/g,"%2B");
	str=str.replace(/\?/g,"%3F");
	str=str.replace(/\%/g,"%25");
	str=str.replace(/\#/g,"%23");
	str=str.replace(/\&/g,"%26");
	str=str.replace(/\=/g,"%3D");
	return str;
}

</script>