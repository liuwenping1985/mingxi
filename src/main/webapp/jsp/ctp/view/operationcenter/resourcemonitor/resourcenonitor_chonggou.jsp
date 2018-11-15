<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Management Monitor</title>
		<link rel="stylesheet" type="text/css" href="../../../common/css/default.css">
		<link rel="stylesheet" type="text/css" href="../../../common/skin/default/skin.css">
        <script src="../../../common/js/echarts-all.js"></script>
		<style type="text/css">div.gauge {height:400px;} div.textinfo{display:none;}</style>
<c:if test="${rf > 0 }">
        <meta http-equiv='Refresh' content='${rf * 60 };url=status.do?rf=${rf }' />
</c:if>
		<script type="text/javascript">
			function toggle(targetid){
			    if (document.getElementById){
			    	target=document.getElementById(targetid);
			        if (target.style.display=='block'){
			        	   target.style.display='none';
			        } else {
			        	target.style.display='block';
			       	}
			    }
			}
		</script>

	</head>
	<body>
        <div class="comp" comp="type:'breadcrumb',code:'T01_gauge'"></div>
        <table border='0' width='100%' cellspacing='0' cellpadding='0'>
			<tr>
				<td width='50%'>&nbsp;</td>
				<td width='50%' align='right'>
				    <form method='get' style='margin:0px'>
						Auto-Refresh Time: <input value='1' name='rf' type='text' maxlength='3' size='3'> Minutes
						&nbsp;&nbsp;<input value='go' name='b1' type='submit'>
						<c:if test="${rf > 0 }">
					      &nbsp;<a href='index.do'>Cancel</a>
						</c:if>
				    </form>
				</td>
			</tr>
		</table>
        <hr size="1" noshade="noshade">
        <div style='padding: 10px'>
            <b>Now: ${currentDateString }</b>
<!-- 
/********************************************** A8 ***********************************************/
 -->
			<pre>
					<div id="onlineUser" class="gauge" onclick='toggle("onlineUserText")'></div>
					<div id="onlineUserM1" class="gauge"  onclick='toggle("onlineUserText")'></div>
				<script type="text/javascript">
				var myChart = echarts.init(document.getElementById('onlineUser'), "macarons");
				option = {
				    tooltip : { formatter: "{a} <br/>{b} : {c}" },
				    series : [{ 
				    	startAngle:180,
				    	endAngle:0,
				    	radius:[0,'100%'],
						name:'', 
						max:${servernum},
						type:'gauge', 
						detail : { formatter:'{value}' },
						detail:{
	                        show : true,
	                        offsetCenter: [0, '5%'],
	                        formatter: '{value}'
	                    },
						data:[{
						    value:${onlineUserNumber4Server}, 
						    name: 'PC在线用户数'
						}]
				 	}]
				};
				myChart.setOption(option);
				
				var myChart2 = echarts.init(document.getElementById('onlineUserM1'), "macarons");
				option2 = {
				    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
				    series : [{ 
				        name:'', 
				        max:${m1num},
				        type:'gauge', 
				        detail : {
				        	formatter:'{value}%'
				       	}, 
				       	data:[{
				       		value:${onlineUserNumber4ServerM1}, 
				       		name: 'M1 Users'
				        }]
				    }]
				};
				myChart2.setOption(option2);
				</script>
	            <div id='onlineUserText' class='textinfo'>
	                Online Users: ${onlineUserNumber4Server }; 
	                Peak Online Users: ${peakOnlineUserNumber4Server } (${peakdate })
	                <br/>
	                M1 Users: ${onlineUserNumber4ServerM1 }; 
	                Peak M1 Users: ${peadOnlineUserNumber4ServerM1 } (${peaddatem1 })
	            </div>
            </pre>
<!-- 
/*********************************************** Server **********************************************/
-->
			<div id='serverText' class='textinfo'>
			    <h4>Server</h4>
			        <pre>
                        OS Name: ${osname }; OS Version: ${osversion }; OS Architecture: ${osarch }
                        <br/>
                        Processors: ${processors }
<c:if test="${hasOperatingSystemBean }">
						; Free Physical Memory Size: ${freePhysicalMemSize }
						; Total Physical Memory Size: ${totalPhysicalMemSize }
						; Free Swap Space Size: ${freeSwapSize }
						; Total Swap Space Size: ${totalSwapSize }
						</div>
                        <div id="PhysicalMemory" class="gauge" onclick='toggle("serverText")'></div>
                        <div id="SwapSpace" class="gauge"  onclick='toggle("serverText")'></div>
                        <script type="text/javascript">
                        var myChart = echarts.init(document.getElementById('PhysicalMemory'));
                        option = {
                       	    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                       	    series : [{ 
                       	    	name:'', 
                       	    	type:'gauge', 
                       	    	detail : {
                       	    		formatter:'{value}%'
                   	    		},
                   	    		data:[{
                   	    			value:"${physicalMemValue}", 
                   	    			name: 'Physical Memory'
                   	    		}] 
                       	    }]
                       	};
                        myChart.setOption(option);

                        var myChart2 = echarts.init(document.getElementById('SwapSpace'));
                        option2 = {
                       	    tooltip : { formatter: "{a} <br/>{b} : {c}%"    },
                       	    series : [{ 
                       	    	name:'',
                       	    	type:'gauge', 
                       	    	detail : {formatter:'{value}%'},
                       	        data:[{
                       	        	value:"${swapMemVaue}", 
                       	        	name: 'Swap Space'
                       	        }] 
                       	    }]
                       	};
                        myChart2.setOption(option2);
                        </script>
</c:if>
                    </pre>
<!-- 
/********************************************** JVM ***********************************************/
 -->
<c:if test="${hasMemPool }">
					<div  id='jvmText'  class='textinfo' >
						<table border='0' cellspacing='0' cellpadding='0' class='sort'>
							<thead>
								<tr class="sort">
								<td class="sort" width='80'>Type</td>
								<td class="sort" width='120'>Gen</td>
								<td class="sort" width='80' align='right'>Init</td>
								<td class="sort" width='80' align='right'>Used</td>
								<td class="sort" width='80' align='right'>Max</td>
								<td class="sort" width='80' align='right'>Committed</td>
								<td class="sort" width='80' align='right'>Peak</td>
								<td class="sort" width='80' align='right'>Used Ratio</td>
								<td class="sort" width='80' align='right'>Peak Ratio</td>
								</tr>
							</thead>
						   <tbody>
						   <c:forEach items="${memPoolList }" var="tempm">
					            <tr>
					                <td class="sort">${tempm[0] }</td>
					                <td class="sort">${tempm[1] }</td>
					                <td class="sort" align='right'>${tempm[2] }</td>
					                <td class="sort" align='right'>${tempm[3] }</td>
					                <td class="sort" align='right'>${tempm[4] }</td>
					                <td class="sort" align='right'>${tempm[5] }</td>
					                <td class="sort" align='right'>${tempm[6] }</td>
					                <td class="sort" align='right'>${tempm[7] }</td>
					                <td class="sort" align='right'>${tempm[8] }</td>
					            </tr>
                           </c:forEach>
					        </tbody>
					    </table>
					</div>
                    <div id="CMSOldGen" class="gauge" onclick='toggle("jvmText")'></div>
                    <div id="CMSPermGen" class="gauge"  onclick='toggle("jvmText")'></div>
                        <script type="text/javascript">
                        var myChart = echarts.init(document.getElementById('CMSOldGen'));
                        option = {
                       	    tooltip : { formatter: "{a} <br/>{b} : {c}%"    },
                       	    series : [{ 
                       	    	name:'', 
                       	    	type:'gauge', 
                       	    	detail : {
                       	    		formatter:'{value}%'
                   	    		},
                       	    	data:[{
                       	    		value:${oldPerc}, 
                       	    		name: 'CMS Old Gen'
                   	    		}] 
                  	    	}]
                   	    };
                        myChart.setOption(option);
                        var myChart2 = echarts.init(document.getElementById('CMSPermGen'));
                        option2 = {
                       	    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                       	    series : [{ 
                       	    	name:'',
                       	    	type:'gauge', 
                       	    	detail : {
                       	    		formatter:'{value}%'
                   	    		},
                   	    		data:[{
                   	    			value:${perPerc}, 
                   	    			name: 'CMS Perm Gen'
           	    			    }] 
               	    		}]
                   	    };
                        myChart2.setOption(option2);
                        </script>
</c:if>


<!-- 
/******************************************** JDBC *************************************************/
-->

<c:forEach items="${datasourceMap }" var="dmap">
					    <div id="${dmap["name"] }Text" class='textinfo'><h5>${dmap["name"] }</h5>
					    </div>
					
					    <div id="${dmap["name"] }" class="gauge" onclick='toggle("${dmap["name"] }Text")'></div>
					
					    <script type="text/javascript">
					    var myChart = echarts.init(document.getElementById("${dmap["name"] }"));
					    option = {
					  	    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
					  	    series : [{ 
					  	    	name:'',
					  	    	max:${dmap.fProvider.maxCount}, 
					  	        type:'gauge', 
					  	        detail : {
					  	        	formatter:'{value}%'
				  	        	},
				  	        	data:[{
				  	        		value:${dmap.fProvider.noUseCount}, 
				  	        		name: '${dmap["name"] }'
				        		}] 
					       	}]
					    };
					    myChart.setOption(option);
					    </script>
</c:forEach>
					    <div id="attPartition" class="gauge" onclick='toggle("onlineUserText")'></div>
					    <div id="appServerPath" class="gauge"></div>
                        <script type="text/javascript">
					    <c:if test="${attFlag }">
					    var myChart = echarts.init(document.getElementById('attPartition'));
					    option = {
					  	    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
					  	    series : [{ 
					  	    	name:'', 
					  	    	type:'gauge', 
					  	    	detail : {
					  	    		formatter:'{value}%'
				  	    		},
				  	    		data:[{
				  	    			value:${attRatio}, 
				  	    			name: 'Attach Use Ratio'
				    			}] 
					  		}]
					    };
					    myChart.setOption(option);
					    </c:if>
					    <c:if test="${appFlag }">                   
					    var myChart2 = echarts.init(document.getElementById('appServerPath'));
					    option2 = {
					  	    tooltip : { formatter: "{a} <br/>{b} : {c}%" },
					        series : [{ 
					        	name:'',
					        	type:'gauge', 
					        	detail : {
					        		formatter:'{value}%'
				        		},
				        		data:[{
				        			value:${appRatio}, 
				        			name: 'AppServer Use Ratio'
				       			}] 
					   		}]
					    };
					    myChart2.setOption(option2);
                        </c:if>
					    </script>

						<script type="text/javascript">
						<!--
						function log(){
						    var today = "${currentDateString}";
						    
						    var fn = window.prompt("Please input log file name, eq. ctp, capability", "ctp");
						    var date = window.prompt("Please input date, format: yyyy-MM-dd", today);
						    var index = window.prompt("Please input index, eg.1,2,3,4...", "1");
						    var url = null;
						    if(today == date){
						        url = "../../../logs/" + fn + ".log";
						    }
						    else{
						        url = "../../../logs/" + date + "/" + fn + ".log." + date + "." + index + ".log";
						    }
						    
						    window.open(url);
						}
						//-->
						</script>
                        <hr size="1" noshade="noshade"><center style='padding: 10px'><font size="-1" color="#525D76"><em>Copyright &copy; 2009, www.seeyon.com ${allTime }ms</em></font></center>
    </body>
</html>
