/*
Copyright (c) 2009, Shlomy Gantz BlueBrick Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of Shlomy Gantz or BlueBrick Inc. nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY SHLOMY GANTZ/BLUEBRICK INC. ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL SHLOMY GANTZ/BLUEBRICK INC. BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
var JSGantt;
if (!JSGantt) JSGantt = {};
var vTimeout = 0;
var ganttLog = {
	devMode : false,
	isDebugEnabled : function() {
		return this.devMode;
	},
	debug : function(message){
		if(this.isDebugEnabled()) {
			alert("甘特图调试信息【" + message + "】");
		}
	}
}
JSGantt.TaskItem = function(pID, pName, pStart, pEnd, pColor, pLink, pRes, pComp, pGroup, pSprint, pParent, pOpen, pDepend, pCaption) {
    var vID = pID;
    var vName = pName.replace(/&apos;/gi, "'").replace(/&quot;/gi, "\"");
    var vStart = new Date();
    var vEnd = new Date();
    var vColor = pColor;
    var vLink = pLink;
    var vRes = pRes;
    var vComp = pComp;
    var vGroup = pGroup;
    var vSprint = pSprint;
    var vParent = pParent;
    var vOpen = pOpen;
    var vDepend = pDepend;
    var vCaption = pCaption;
    var vDuration = '';
    var vLevel = 0;
    var vNumKid = 0;
    var vVisible = 1;
    var x1, y1, x2, y2;
    if (vGroup != 1) {
        vStart = JSGantt.parseDateStr(pStart, g.getDateInputFormat());
        vEnd = JSGantt.parseDateStr(pEnd, g.getDateInputFormat())
    }
    this.getID = function() {
        return vID
    };
    this.getName = function() {
        return vName
    };
    this.getStart = function() {
        return vStart
    };
    this.getEnd = function() {
        return vEnd
    };
    this.getColor = function() {
        return vColor
    };
    this.getLink = function() {
        return vLink
    };
    this.getDepend = function() {
        if (vDepend && vDepend > 0) return vDepend;
        else return null
    };
    this.getCaption = function() {
        if (vCaption) return vCaption;
        else return ''
    };
    this.getResource = function() {
        if (vRes) return vRes;
        else return '&nbsp'
    };
    this.getCompVal = function() {
        if (vComp) return vComp;
        else return 0
    };
    this.getCompStr = function() {
        if (vComp) return vComp + '%';
        else return '0.0%'
    };
    this.getParent = function() {
        return vParent
    };
    this.getGroup = function() {
        return vGroup
    };
    this.getSprint = function() {
    	return vSprint;
    };
    this.getOpen = function() {
        return vOpen
    };
    this.getLevel = function() {
        return vLevel
    };
    this.getNumKids = function() {
        return vNumKid
    };
    this.getStartX = function() {
        return x1
    };
    this.getStartY = function() {
        return y1
    };
    this.getEndX = function() {
        return x2
    };
    this.getEndY = function() {
        return y2
    };
    this.getVisible = function() {
        return vVisible
    };
    this.setDepend = function(pDepend) {
        vDepend = pDepend
    };
    this.setStart = function(pStart) {
        vStart = pStart
    };
    this.setEnd = function(pEnd) {
        vEnd = pEnd
    };
    this.setLevel = function(pLevel) {
        vLevel = pLevel
    };
    this.setNumKid = function(pNumKid) {
        vNumKid = pNumKid
    };
    this.setCompVal = function(pCompVal) {
        vComp = pCompVal
    };
    this.setStartX = function(pX) {
        x1 = pX
    };
    this.setStartY = function(pY) {
        y1 = pY
    };
    this.setEndX = function(pX) {
        x2 = pX
    };
    this.setEndY = function(pY) {
        y2 = pY
    };
    this.setOpen = function(pOpen) {
        vOpen = pOpen
    };
    this.setVisible = function(pVisible) {
        vVisible = pVisible
    }
};
function ganttDisplayChoice() {
	var treeAndChart = document.getElementById('treeAndChart').checked == true ? 1 : 0;
	g.setShowTreeAndGantt(treeAndChart);
}
JSGantt.GanttChart = function(pGanttVar, pDiv, pFormat) {
    var vGanttVar = pGanttVar;
    var vDiv = pDiv;
    var vFormat = pFormat;
    // 资源和任务周期始终不予显示
    var vShowRes = 0;
    var vShowDur = 0;
    // 完成率、开始时间和结束时间允许用户配置
    var vShowComp = 1;
    var vShowStartDate = 1;
    var vShowEndDate = 1;
    var vDateInputFormat = "yyyy-mm-dd";
    var vDateDisplayFormat = "yyyy-mm-dd";
    var vNumUnits = 0;
    var vCaptionType;
    var vDepId = 1;
    var vTaskList = new Array();
    var vFormatArr = new Array("day", "week", "month", "quarter");
    var vQuarterArr = new Array(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4);
    var vMonthDaysArr = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    var vMonthArr = [];
    for(var i=0; i<12; i++) {
    	vMonthArr[vMonthArr.length] = v3x.getMessage('TaskManage.month' + (i + 1));
    }
    // 是否同时显示任务树和甘特图(反之只显示甘特图)
    var vShowTreeAndGantt = 1;
    this.setShowComp = function(pShow) {
        vShowComp = pShow
    };
    this.setShowStartDate = function(pShow) {
        vShowStartDate = pShow
    };
    this.setShowEndDate = function(pShow) {
        vShowEndDate = pShow
    };
    this.setDateInputFormat = function(pShow) {
        vDateInputFormat = pShow
    };
    this.setDateDisplayFormat = function(pShow) {
        vDateDisplayFormat = pShow
    };
    this.setCaptionType = function(pType) {
        vCaptionType = pType
    };
    this.setShowTreeAndGantt = function(pShowTreeAndGantt) {
    	if(vShowTreeAndGantt != pShowTreeAndGantt) {
    		var t1 = new Date().getTime();
	    	vShowTreeAndGantt = pShowTreeAndGantt;
    		this.Draw();
    		this.DrawDependencies();
    		ganttLog.debug("重新绘制甘特图耗时：" + (new Date().getTime() - t1) + "MS");
    	}
    }
    this.getShowTreeAndGantt = function() {
    	return vShowTreeAndGantt;
    };
    this.setFormat = function(pFormat) {
        vFormat = pFormat;
        this.Draw()
    };
    this.getShowRes = function() {
        return vShowRes
    };
    this.getShowDur = function() {
        return vShowDur
    };
    this.getShowComp = function() {
        return vShowComp
    };
    this.getShowStartDate = function() {
        return vShowStartDate
    };
    this.getShowEndDate = function() {
        return vShowEndDate
    };
    this.getDateInputFormat = function() {
        return vDateInputFormat
    };
    this.getDateDisplayFormat = function() {
        return vDateDisplayFormat
    };
    this.getCaptionType = function() {
        return vCaptionType
    };
    this.CalcTaskXY = function() {
        var vList = this.getList();
        if(!vList || vList.length == 0)
        	return;
        
        var vTaskDiv;
        var vParDiv;
        var vLeft,
        vTop,
        vHeight,
        vWidth;
        for (i = 0; i < vList.length; i++) {
            vID = vList[i].getID();
            vTaskDiv = document.getElementById("taskbar_" + vID);
            vBarDiv = document.getElementById("bardiv_" + vID);
            vParDiv = document.getElementById("childgrid_" + vID);
            if (vBarDiv) {
                vList[i].setStartX(vBarDiv.offsetLeft);
                vList[i].setStartY(vParDiv.offsetTop + vBarDiv.offsetTop + 6);
                vList[i].setEndX(vBarDiv.offsetLeft + vBarDiv.offsetWidth);
                vList[i].setEndY(vParDiv.offsetTop + vBarDiv.offsetTop + 6)
            }
        }
    };
    this.AddTaskItem = function(value) {
        vTaskList.push(value)
    };
    this.getList = function() {
        return vTaskList
    };
    this.clearDependencies = function() {
        var parent = document.getElementById('rightside');
        var depLine;
        var vMaxId = vDepId;
        for (i = 1; i < vMaxId; i++) {
            depLine = document.getElementById("line" + i);
            if (depLine) {
                parent.removeChild(depLine)
            }
        };
        vDepId = 1
    };
    this.sLine = function(x1, y1, x2, y2) {
        vLeft = Math.min(x1, x2);
        vTop = Math.min(y1, y2);
        vWid = Math.abs(x2 - x1) + 1;
        vHgt = Math.abs(y2 - y1) + 1;
        vDoc = document.getElementById('rightside');
        var oDiv = document.createElement('div');
        oDiv.id = "line" + vDepId++;
        oDiv.style.position = "absolute";
        oDiv.style.margin = "0px";
        oDiv.style.padding = "0px";
        oDiv.style.overflow = "hidden";
        oDiv.style.border = "0px";
        oDiv.style.zIndex = 0;
        oDiv.style.backgroundColor = "red";
        oDiv.style.left = vLeft + "px";
        oDiv.style.top = vTop + "px";
        oDiv.style.width = vWid + "px";
        oDiv.style.height = vHgt + "px";
        oDiv.style.visibility = "visible";
        vDoc.appendChild(oDiv)
    };
    this.dLine = function(x1, y1, x2, y2) {
        var dx = x2 - x1;
        var dy = y2 - y1;
        var x = x1;
        var y = y1;
        var n = Math.max(Math.abs(dx), Math.abs(dy));
        dx = dx / n;
        dy = dy / n;
        for (i = 0; i <= n; i++) {
            vx = Math.round(x);
            vy = Math.round(y);
            this.sLine(vx, vy, vx, vy);
            x += dx;
            y += dy
        }
    };
    this.drawDependency = function(x1, y1, x2, y2) {
        if (x1 + 10 < x2) {
            this.sLine(x1, y1, x1 + 4, y1);
            this.sLine(x1 + 4, y1, x1 + 4, y2);
            this.sLine(x1 + 4, y2, x2, y2);
            this.dLine(x2, y2, x2 - 3, y2 - 3);
            this.dLine(x2, y2, x2 - 3, y2 + 3);
            this.dLine(x2 - 1, y2, x2 - 3, y2 - 2);
            this.dLine(x2 - 1, y2, x2 - 3, y2 + 2)
        } else {
            this.sLine(x1, y1, x1 + 4, y1);
            this.sLine(x1 + 4, y1, x1 + 4, y2 - 10);
            this.sLine(x1 + 4, y2 - 10, x2 - 8, y2 - 10);
            this.sLine(x2 - 8, y2 - 10, x2 - 8, y2);
            this.sLine(x2 - 8, y2, x2, y2);
            this.dLine(x2, y2, x2 - 3, y2 - 3);
            this.dLine(x2, y2, x2 - 3, y2 + 3);
            this.dLine(x2 - 1, y2, x2 - 3, y2 - 2);
            this.dLine(x2 - 1, y2, x2 - 3, y2 + 2)
        }
    };
    this.DrawDependencies = function() {
        this.CalcTaskXY();
        this.clearDependencies();
        var vList = this.getList();
        if(vList && vList.length > 0) {
	        for (var i = 0; i < vList.length; i++) {
	            vDepend = vList[i].getDepend();
	            if (vDepend) {
	                var vDependStr = vDepend + '';
	                var vDepList = vDependStr.split(',');
	                var n = vDepList.length;
	                for (var k = 0; k < n; k++) {
	                    var vTask = this.getArrayLocationByID(vDepList[k]);
	                    if (vList[vTask].getVisible() == 1) 
	                    	this.drawDependency(vList[vTask].getEndX(), vList[vTask].getEndY(), vList[i].getStartX() - 1, vList[i].getStartY())
	                }
	            }
	        }
        }
    };
    this.getArrayLocationByID = function(pId) {
        var vList = this.getList();
        if(vList && vList.length > 0) {
	        for (var i = 0; i < vList.length; i++) {
	            if (vList[i].getID() == pId) return i
	        }
        }
    };
    // 生成任务树HTML代码
    function getTreeTableHtml(vTaskList, vFormatArr, vGanttVar) {
    	var vNameWidth = 200;
        var vStatusWidth = 70;
		var vLeftWidth = 15 + 200 + 70 + 70 + 70;
		
    	var str = new StringBuffer();
    	str.append('<DIV class=scroll id=leftside style="width:' + vLeftWidth + 'px">' +
        		   		'<TABLE cellSpacing=0 width="100%" cellPadding=0 border=0 class=gantLeftTable>' +
        		   			'<TBODY>' + 
        		   				'<TR style="HEIGHT: 17px">' + 
        		   					'<TD style="WIDTH: 15px; HEIGHT: 17px"></TD>' + 
        		   					'<TD style="WIDTH: ' + vNameWidth + 'px; HEIGHT: 17px"><NOBR></NOBR></TD>');
        if (vShowComp == 1) 
        	str.append(				'<TD style="WIDTH: ' + vStatusWidth + 'px; HEIGHT: 17px"></TD>');
        if (vShowStartDate == 1) 
        	str.append(				'<TD style="WIDTH: ' + vStatusWidth + 'px; HEIGHT: 17px"></TD>');
        if (vShowEndDate == 1) 
        	str.append(				'<TD style="WIDTH: ' + vStatusWidth + 'px; HEIGHT: 17px"></TD>');
        str.append(				'</TR>');
        	
        str.append(				'<TR style="HEIGHT: 20px">' + 
        		   					'<TD style="BORDER-TOP: #efefef 1px solid; WIDTH: 15px; HEIGHT: 20px"></TD>' + 
        		   					'<TD style="BORDER-TOP: #efefef 1px solid; WIDTH: ' + vNameWidth + 'px; HEIGHT: 20px"><NOBR></NOBR></TD>');
        if (vShowComp == 1) 
        	str.append(				'<TD style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; WIDTH: 60px; HEIGHT: 20px" align=center nowrap>' + v3x.getMessage('TaskManage.finish_rate') + '</TD>');
        if (vShowStartDate == 1) 
        	str.append(				'<TD style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; WIDTH: 60px; HEIGHT: 20px" align=center nowrap>' + v3x.getMessage('TaskManage.start_date') + '</TD>');
        if (vShowEndDate == 1) 
        	str.append(				'<TD style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; WIDTH: 60px; HEIGHT: 20px" align=center nowrap>' + v3x.getMessage('TaskManage.end_date') + '</TD>');
        str.append(				'</TR>');
        
        for (i = 0; i < vTaskList.length; i++) {
            if (vTaskList[i].getGroup()) {
                vBGColor = "f3f3f3";
                vRowType = "group"
            } else {
                vBGColor = "ffffff";
                vRowType = "row"
            }
            vID = vTaskList[i].getID();
            if (vTaskList[i].getVisible() == 0) 
            	str.append(		'<TR id=child_' + vID + ' bgcolor=#' + vBGColor + ' style="display:none"  onMouseover=g.mouseOver(this,' + vID + ',"left","' + vRowType + '") onMouseout=g.mouseOut(this,' + vID + ',"left","' + vRowType + '")>');
            else 
            	str.append(		'<TR id=child_' + vID + ' bgcolor=#' + vBGColor + ' onMouseover=g.mouseOver(this,' + vID + ',"left","' + vRowType + '") onMouseout=g.mouseOut(this,' + vID + ',"left","' + vRowType + '")>');
            
            str.append(				'<TD class=gdatehead style="WIDTH: 15px; HEIGHT: 20px; BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;">&nbsp;</TD>' + 
            		   				'<TD class=gname style="WIDTH: ' + vNameWidth + 'px; HEIGHT: 20px; BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px;" nowrap><NOBR><span style="color: #aaaaaa">');
            
            for (j = 1; j < vTaskList[i].getLevel(); j++) {
                str.append('&nbsp;&nbsp;&nbsp;&nbsp;');
            }
            
            str.append('</span>');
            if (vTaskList[i].getGroup()) {
                if (vTaskList[i].getOpen() == 1) 
                	str.append('<SPAN id="group_' + vID + '" style="color:#000000; cursor:pointer; font-weight:bold; FONT-SIZE: 12px;" onclick="JSGantt.folder(' + vID + ',' + vGanttVar + ');' + vGanttVar + '.DrawDependencies();">&ndash;</span><span style="color:#000000">&nbsp;</SPAN>');
                else 
                	str.append('<SPAN id="group_' + vID + '" style="color:#000000; cursor:pointer; font-weight:bold; FONT-SIZE: 12px;" onclick="JSGantt.folder(' + vID + ',' + vGanttVar + ');' + vGanttVar + '.DrawDependencies();">+</span><span style="color:#000000">&nbsp</SPAN>');
            } else {
                str.append('<span style="color: #000000; font-weight:bold; FONT-SIZE: 12px;">&nbsp&nbsp&nbsp</span>');
            }
            str.append('<span onclick=JSGantt.taskLink("' + vTaskList[i].getLink() + '"); style="cursor:pointer"> ' + vTaskList[i].getName().getLimitLength(40, '...') + '</span></NOBR>' +
            						'</TD>');
            if (vShowComp == 1) 
            	str.append(			'<TD class=gname style="WIDTH: 60px; HEIGHT: 20px; TEXT-ALIGN: center; BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><NOBR>' + vTaskList[i].getCompStr() + '</NOBR></TD>');
            if (vShowStartDate == 1) 
            	str.append(			'<TD class=gname style="WIDTH: 60px; HEIGHT: 20px; TEXT-ALIGN: center; BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><NOBR>' + JSGantt.formatDateStr(vTaskList[i].getStart(), vDateDisplayFormat) + '</NOBR></TD>');
            if (vShowEndDate == 1) 
            	str.append(			'<TD class=gname style="WIDTH: 60px; HEIGHT: 20px; TEXT-ALIGN: center; BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><NOBR>' + JSGantt.formatDateStr(vTaskList[i].getEnd(), vDateDisplayFormat) + '</NOBR></TD>');
            str.append(			'</TR>');
        }
        str.append('<TR>' +
        		   		'<TD border=1 colspan=5 align=left style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #efefef 1px solid; height=18px">&nbsp;&nbsp;&nbsp;&nbsp;' + v3x.getMessage('TaskManage.date_format') + ':');
        
        if (vFormat == 'day') 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" VALUE="day" checked>' + v3x.getMessage('TaskManage.day'));
        else 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" onclick=JSGantt.changeFormat("day",' + vGanttVar + '); VALUE="day">' + v3x.getMessage('TaskManage.day'))
        
        if (vFormat == 'week') 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" VALUE="week" checked>' + v3x.getMessage('TaskManage.week'));
        else 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" onclick=JSGantt.changeFormat("week",' + vGanttVar + ') VALUE="week">' + v3x.getMessage('TaskManage.week'));
        
        if (vFormat == 'month') 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" VALUE="month" checked>' + v3x.getMessage('TaskManage.month'));
        else 
        	str.append('<INPUT TYPE=RADIO NAME="radFormat" onclick=JSGantt.changeFormat("month",' + vGanttVar + ') VALUE="month">' + v3x.getMessage('TaskManage.month'));
        
        if (vFormatArr.join().indexOf("quarter") != -1) {
            if (vFormat == 'quarter') 
            	str.append('<INPUT TYPE=RADIO NAME="radFormat" VALUE="quarter" checked>' + v3x.getMessage('TaskManage.quarter'));
            else 
            	str.append('<INPUT TYPE=RADIO NAME="radFormat" onclick=JSGantt.changeFormat("quarter",' + vGanttVar + ') VALUE="quarter">' + v3x.getMessage('TaskManage.quarter'));
        }
        str.append(		'</TD>' +
        			'</TR>' +
        		'</TBODY>' +
        	'</TABLE>' +
        '</DIV>');
        
        return str.toString();
    }
    this.Draw = function() {
        if (vTaskList && vTaskList.length > 0) {
            JSGantt.processRows(vTaskList, 0, -1, 1, 1);
            var vMainTable =
            		"<TABLE id=theTable width='100%' height='100%' cellSpacing=0 cellPadding=0 border=0>" +
            			'<TBODY>' +
            				'<TR>';
            
            // 任务树HTML代码生成
            if(vShowTreeAndGantt == 1) {
	            var vLeftTable = '<TD vAlign=top bgColor=#ffffff align=center width=420>';
	            vLeftTable += 		getTreeTableHtml(vTaskList, vFormatArr, vGanttVar);
	            vLeftTable += 	 '</TD>';
	            
            	vMainTable += vLeftTable;
            }
            
            // 甘特图HTML代码生成
            var vRightTable = getGanttHtml(vShowTreeAndGantt, vTaskList, vFormat);
            
            vMainTable += vRightTable + 
            				'</TR>' +
            			'</TBODY>' +
            		'</TABLE>';
            vDiv.innerHTML = vMainTable;
        }
    };
    // 生成甘特图HTML代码
    function getGanttHtml(vShowTreeAndGantt, vTaskList, vFormat) {
        var vColWidth = 0;
        var vColUnit = 0;
        var vDayWidth = 0;
        var vTaskLeft = 0;
        var vTaskRight = 0;
        var vNumCols = 0;
        var vID = 0;
        
    	var vMinDate = JSGantt.getMinDate(vTaskList, vFormat);
        var vMaxDate = JSGantt.getMaxDate(vTaskList, vFormat);
        
        if (vFormat == 'day') {
            vColWidth = 19;
            vColUnit = 1
        } else if (vFormat == 'week') {
            vColWidth = 37;
            vColUnit = 7
        } else if (vFormat == 'month') {
            vColWidth = 37;
            vColUnit = 30
        } else if (vFormat == 'quarter') {
            vColWidth = 60;
            vColUnit = 90
        } else if (vFormat == 'hour') {
            vColWidth = 18;
            vColUnit = 1
        }
        var vNumDays = (Date.parse(vMaxDate) - Date.parse(vMinDate)) / (24 * 60 * 60 * 1000);  //总天数
        var vNumUnits = vNumDays / vColUnit;                                                   //有几个单位 总天数换算成日/周/月/季度
        var vChartWidth = vNumUnits * vColWidth + 1;                                           //单位数×单位宽度=总宽度
        vDayWidth = (vColWidth / vColUnit) + (1 / vColUnit);                                   //单位宽度/天数+1/单位内天数 = 每天的宽度
            
    	var vDateRowStr = "";
        var vItemRowStr = "";
        
        if(vShowTreeAndGantt == 0) {
        	vChartWidth = vChartWidth * 3;
        	vDayWidth = vDayWidth * 3; 
        }
        var divWidth =  parseInt(document.body.clientWidth)-455;
        if(vShowTreeAndGantt == 0){
        	divWidth =  parseInt(document.body.clientWidth);
        }
        var paddingBottom = 0;
        if(v3x.isMSIE6){divWidth=divWidth-2;}
        if(v3x.isMSIE7 || v3x.isMSIE6){paddingBottom=20;}
    	var ret = '<td width=10>&nbsp;</td><TD vAlign=top bgColor=#ffffff>' + 
						'<DIV class=scroll2 id=rightside style="width: ' + divWidth+ 'px;padding-bottom:'+paddingBottom+'px;" >' + 
						'<TABLE style="width: ' + vChartWidth + 'px;" cellSpacing=0 cellPadding=0 border=0>' + 
							'<TBODY>' + 
								'<TR style="HEIGHT: 18px">';
		var vTmpDate = new Date();
		var vNxtDate = new Date();
		var vCurrDate = new Date();
		
        vTmpDate.setFullYear(vMinDate.getFullYear(), vMinDate.getMonth(), vMinDate.getDate());
        vTmpDate.setHours(0);
        vTmpDate.setMinutes(0);
        var vStr = "";
        while (Date.parse(vTmpDate) <= Date.parse(vMaxDate)) {
            vStr = vTmpDate.getFullYear() + '';
            vStr = vStr.substring(2, 4);
            if (vFormat == 'day') {
                ret += 		'<td class=gdatehead style="FONT-SIZE: 12px; HEIGHT: 19px;" align=center colspan=7 nowrap=nowrap>' + 
									JSGantt.formatDateStr(vTmpDate, vDateDisplayFormat) + ' ~ ';
                vTmpDate.setDate(vTmpDate.getDate() + 6);
                ret += JSGantt.formatDateStr(vTmpDate, vDateDisplayFormat) + 
									'</td>';
                vTmpDate.setDate(vTmpDate.getDate() + 1);
            } else if (vFormat == 'week') {
                ret += 		'<td class=gdatehead align=center style="FONT-SIZE: 12px; HEIGHT: 19px;" width=' + vColWidth + 'px>`' + vStr + '</td>';
                vTmpDate.setDate(vTmpDate.getDate() + 7);
            } else if (vFormat == 'month') {
                ret += 		'<td class=gdatehead align=center style="FONT-SIZE: 12px; HEIGHT: 19px;" width=' + vColWidth + 'px>`' + vStr + '</td>';
                vTmpDate.setDate(vTmpDate.getDate() + 1);
                while (vTmpDate.getDate() > 1) {
                    vTmpDate.setDate(vTmpDate.getDate() + 1);
                }
            } else if (vFormat == 'quarter') {
                ret += 		'<td class=gdatehead align=center style="FONT-SIZE: 12px; HEIGHT: 19px;" width=' + vColWidth + 'px>`' + vStr + '</td>';
                vTmpDate.setDate(vTmpDate.getDate() + 81);
                while (vTmpDate.getDate() > 1) {
                    vTmpDate.setDate(vTmpDate.getDate() + 1);
                }
            }
        }
        ret += 			'</TR>' + 
        // 日期刻度行代码结束，转入甘特图表部分
						'<TR>';
        vTmpDate.setFullYear(vMinDate.getFullYear(), vMinDate.getMonth(), vMinDate.getDate());
        vNxtDate.setFullYear(vMinDate.getFullYear(), vMinDate.getMonth(), vMinDate.getDate());
        vNumCols = 0;
        while (Date.parse(vTmpDate) <= Date.parse(vMaxDate)) {
            if (vFormat == 'day') {
            	var equal = JSGantt.formatDateStr(vCurrDate, 'mm/dd/yyyy') == JSGantt.formatDateStr(vTmpDate, 'mm/dd/yyyy');
            	vWeekdayColor = equal ? "ccccff" : "ffffff";
                vWeekendColor = equal ? "9999ff" : "cfcfcf";
                vWeekdayGColor = equal ? "bbbbff" : "f3f3f3";
                vWeekendGColor = equal ? "8888ff" : "c3c3c3";
				
                if (vTmpDate.getDay() % 6 == 0) {
                    vDateRowStr += '<td class="gheadwkend" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekendColor + ' align=center><div style="width: ' + vColWidth + 'px">' + vTmpDate.getDate() + '</div></td>';
                    vItemRowStr += '<td class="gheadwkend" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; cursor: default;"  bgcolor=#' + vWeekendColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp</div></td>'
                } else {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid;"  bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">' + vTmpDate.getDate() + '</div></td>';
                    if (JSGantt.formatDateStr(vCurrDate, 'mm/dd/yyyy') == JSGantt.formatDateStr(vTmpDate, 'mm/dd/yyyy')) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; cursor: default;"  bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; cursor: default;"  align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>'
                }
                vTmpDate.setDate(vTmpDate.getDate() + 1);
            } else if (vFormat == 'week') {
                vNxtDate.setDate(vNxtDate.getDate() + 7);
                if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
					vWeekdayColor = "ccccff";
                else 
					vWeekdayColor = "ffffff";
                if (vNxtDate <= vMaxDate) {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + (vTmpDate.getMonth() + 1) + '/' + vTmpDate.getDate() + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>'
                } else {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid; bgcolor=#' + vWeekdayColor + ' BORDER-RIGHT: #efefef 1px solid;" align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + (vTmpDate.getMonth() + 1) + '/' + vTmpDate.getDate() + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                }
                vTmpDate.setDate(vTmpDate.getDate() + 7);
            } else if (vFormat == 'month') {
                vNxtDate.setFullYear(vTmpDate.getFullYear(), vTmpDate.getMonth(), vMonthDaysArr[vTmpDate.getMonth()]);
                if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
					vWeekdayColor = "ccccff";
                else 
					vWeekdayColor = "ffffff";
                if (vNxtDate <= vMaxDate) {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + vMonthArr[vTmpDate.getMonth()].substr(0, 3) + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>'
                } else {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + vMonthArr[vTmpDate.getMonth()].substr(0, 3) + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                }
                vTmpDate.setDate(vTmpDate.getDate() + 1);
                while (vTmpDate.getDate() > 1) {
                    vTmpDate.setDate(vTmpDate.getDate() + 1);
                }
            } else if (vFormat == 'quarter') {
                vNxtDate.setDate(vNxtDate.getDate() + 122);
                if (vTmpDate.getMonth() == 0 || vTmpDate.getMonth() == 1 || vTmpDate.getMonth() == 2) 
					vNxtDate.setFullYear(vTmpDate.getFullYear(), 2, 31);
                else if (vTmpDate.getMonth() == 3 || vTmpDate.getMonth() == 4 || vTmpDate.getMonth() == 5) 
					vNxtDate.setFullYear(vTmpDate.getFullYear(), 5, 30);
                else if (vTmpDate.getMonth() == 6 || vTmpDate.getMonth() == 7 || vTmpDate.getMonth() == 8) 
					vNxtDate.setFullYear(vTmpDate.getFullYear(), 8, 30);
                else if (vTmpDate.getMonth() == 9 || vTmpDate.getMonth() == 10 || vTmpDate.getMonth() == 11) 
					vNxtDate.setFullYear(vTmpDate.getFullYear(), 11, 31);
					
                if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
					vWeekdayColor = "ccccff";
                else 
					vWeekdayColor = "ffffff";
					
                if (vNxtDate <= vMaxDate) {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + v3x.getMessage('TaskManage.quarter_sn', vQuarterArr[vTmpDate.getMonth()]) + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>'
                } else {
                    vDateRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; HEIGHT: 19px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center width:' + vColWidth + 'px><div style="width: ' + vColWidth + 'px">' + v3x.getMessage('TaskManage.quarter_sn', vQuarterArr[vTmpDate.getMonth()]) + '</div></td>';
                    if (vCurrDate >= vTmpDate && vCurrDate < vNxtDate) 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" bgcolor=#' + vWeekdayColor + ' align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                    else 
						vItemRowStr += '<td class="ghead" style="BORDER-TOP: #efefef 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #efefef 1px solid; BORDER-RIGHT: #efefef 1px solid;" align=center><div style="width: ' + vColWidth + 'px">&nbsp&nbsp</div></td>';
                }
                vTmpDate.setDate(vTmpDate.getDate() + 81);
                while (vTmpDate.getDate() > 1) {
                    vTmpDate.setDate(vTmpDate.getDate() + 1);
                }
            }
        }
        ret += vDateRowStr + '</TR>';
        ret += '</TBODY></TABLE>';
        
        for (i = 0; i < vTaskList.length; i++) {
            vTmpDate.setFullYear(vMinDate.getFullYear(), vMinDate.getMonth(), vMinDate.getDate());
            vTaskStart = vTaskList[i].getStart();
            vTaskEnd = vTaskList[i].getEnd();
            vNumCols = 0;
            vID = vTaskList[i].getID();
            vNumUnits = (vTaskList[i].getEnd() - vTaskList[i].getStart()) / (24 * 60 * 60 * 1000) + 1;
            if (vTaskList[i].getVisible() == 0) 
				ret += '<DIV id=childgrid_' + vID + ' style="position:relative; display:none;">';
            else 
				ret += '<DIV id=childgrid_' + vID + ' style="position:relative">';
				
			vDateRowStr = JSGantt.formatDateStr(vTaskStart, vDateDisplayFormat) + ' - ' + JSGantt.formatDateStr(vTaskEnd, vDateDisplayFormat);
			vTaskRight = (Date.parse(vTaskList[i].getEnd()) - Date.parse(vTaskList[i].getStart())) / (24 * 60 * 60 * 1000) + 1 / vColUnit;
			vTaskLeft = Math.ceil((Date.parse(vTaskList[i].getStart()) - Date.parse(vMinDate)) / (24 * 60 * 60 * 1000));
			var tSubject = vTaskList[i].getName();
			if (vFormat == 'day') {
				var tTime = new Date();
				tTime.setTime(Date.parse(vTaskList[i].getStart()));
				if (tTime.getMinutes() > 29) 
					vTaskLeft += .5;
			}
			if(vShowTreeAndGantt == 0) {
//				tSubject = '<div style="Z-INDEX: -4; float:left; background-color:white; height:18px; overflow: hidden; width:' + Math.ceil((vTaskRight) * (vDayWidth) - 1) + 'px">' +
//						   		vTaskList[i].getName() +
//						   '</div>';
			}
			
			if (vTaskList[i].getGroup() == 1 &&　vTaskList[i].getSprint() == 1) {
				ret += '<DIV><TABLE style="position:relative; top:0px; width: ' + vChartWidth + 'px;" cellSpacing=0 cellPadding=0 border=0>' + '<TR id=childrow_' + vID + ' class=yesdisplay style="HEIGHT: 20px" bgColor=#f3f3f3 onMouseover=g.mouseOver(this,' + vID + ',"right","group") onMouseout=g.mouseOut(this,' + vID + ',"right","group")>' + vItemRowStr + '</TR></TABLE></DIV>';
				ret += '<div id=bardiv_' + vID + ' style="position:absolute; top:5px; left:' + Math.ceil(vTaskLeft * (vDayWidth) + 1) + 'px; height: 7px; width:' + Math.ceil((vTaskRight) * (vDayWidth) - 1) + 'px">' + 
					   		'<div id=taskbar_' + vID + ' title="' + escapeToHTML(vTaskList[i].getName()) + ': ' + vDateRowStr + '" class=gtask style="background-color:#008CCE; height: 12px; width:' + Math.ceil((vTaskRight) * (vDayWidth) - 1) + 'px;  cursor: pointer;opacity:0.9;">' + 
					   			tSubject + 
					   			'<div style="Z-INDEX: -4; float:left; background-color:#008CCE; height:3px; overflow: hidden; margin-top:1px; ' + 'margin-left:1px; margin-right:1px; filter: alpha(opacity=80); opacity:0.8; width:' + vTaskList[i].getCompStr() + '; ' + 'cursor: pointer;" onclick=JSGantt.taskLink("' + vTaskList[i].getLink() + '");>' + 
					   			'</div>' + 
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:left; background-color:#008CCE; height:4px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:right; background-color:#008CCE; height:4px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:left; background-color:#008CCE; height:3px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:right; background-color:#008CCE; height:3px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:left; background-color:#008CCE; height:2px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:right; background-color:#008CCE; height:2px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:left; background-color:#008CCE; height:1px; overflow: hidden; width:1px;">' +
					   		'</div>' + 
					   		'<div style="Z-INDEX: -4; float:right; background-color:#008CCE; height:1px; overflow: hidden; width:1px;">' +
					   		'</div>';
			} 
			else {
				ret += '<DIV><TABLE style="position:relative; top:0px; width: ' + vChartWidth + 'px;" cellSpacing=0 cellPadding=0 border=0>' + '<TR id=childrow_' + vID + ' class=yesdisplay style="HEIGHT: 20px" bgColor=#ffffff onMouseover=g.mouseOver(this,' + vID + ',"right","row") onMouseout=g.mouseOut(this,' + vID + ',"right","row")>' + vItemRowStr + '</TR></TABLE></DIV>';
				ret += 		'<div id=bardiv_' + vID + ' style="position:absolute; top:4px; left:' + Math.ceil(vTaskLeft * (vDayWidth) + 1) + 'px; height:18px; width:' + Math.ceil((vTaskRight) * (vDayWidth) - 1) + 'px">' + 
						   		'<div id=taskbar_' + vID + ' title="' + escapeToHTML(vTaskList[i].getName()) + ': ' + vDateRowStr + '" class=gtask style="background-color:#' + vTaskList[i].getColor() + '; height: 13px; width:' + Math.ceil((vTaskRight) * (vDayWidth) - 1) + 'px; cursor: pointer;opacity:0.9;" ' + 'onclick=JSGantt.taskLink("' + vTaskList[i].getLink() + '"); >' + 
						   			tSubject + 
						   			'<div class=gcomplete style="Z-INDEX: -4; float:left; background-color:black; height:5px; overflow: auto; margin-top:4px; filter: alpha(opacity=40); opacity:0.4; width:' + vTaskList[i].getCompStr() + '; overflow:hidden">' + 
						   			'</div>' + 
						   		'</div>';
			}    
			if (g.getCaptionType()) {
				vCaptionStr = '';
				switch (g.getCaptionType()) {
				case 'Caption':
					vCaptionStr = vTaskList[i].getCaption();
					break;
				case 'Complete':
					vCaptionStr = vTaskList[i].getCompStr();
					break
				}
				ret += '<div style="FONT-SIZE:12px; position:absolute; top:-3px; width:120px; left:' + (Math.ceil((vTaskRight) * (vDayWidth) - 1) + 6) + 'px">' + vCaptionStr + '</div>'
			}
			ret += 		'</div>';
            ret += 	'</DIV>';
        }
        
        return ret;
    }
    
    function escapeToHTML(str){
	if(!str) {
		return "";
	}
	str = str.replace(/\'/g, "&#039;");
	str = str.replace(/"/g, "&#034;");
	return str;
	}
	
    this.mouseOver = function(pObj, pID, pPos, pType) {
        if (pPos == 'right') vID = 'child_' + pID;
        else vID = 'childrow_' + pID;
        pObj.bgColor = "#ffffaa";
        vRowObj = JSGantt.findObj(vID);
        if (vRowObj) vRowObj.bgColor = "#ffffaa"
    };
    this.mouseOut = function(pObj, pID, pPos, pType) {
        if (pPos == 'right') vID = 'child_' + pID;
        else vID = 'childrow_' + pID;
        pObj.bgColor = "#ffffff";
        vRowObj = JSGantt.findObj(vID);
        if (vRowObj) {
            if (pType == "group") {
                pObj.bgColor = "#f3f3f3";
                vRowObj.bgColor = "#f3f3f3"
            } else {
                pObj.bgColor = "#ffffff";
                vRowObj.bgColor = "#ffffff"
            }
        }
    }
};
JSGantt.isIE = function() {
    if (typeof document.all != 'undefined') {
        return true
    } else {
        return false
    }
};
JSGantt.processRows = function(pList, pID, pRow, pLevel, pOpen) {
    var vMinDate = new Date();
    var vMaxDate = new Date();
    var vMinSet = 0;
    var vMaxSet = 0;
    var vList = pList;
    var vLevel = pLevel;
    var i = 0;
    var vNumKid = 0;
    var vCompSum = 0;
    var vVisible = pOpen;
    for (i = 0; i < pList.length; i++) {
        if (pList[i].getParent() == pID) {
            vVisible = pOpen;
            pList[i].setVisible(vVisible);
            if (vVisible == 1 && pList[i].getOpen() == 0) {
                vVisible = 0
            }
            pList[i].setLevel(vLevel);
            vNumKid++;
            if (pList[i].getGroup() == 1) {
                JSGantt.processRows(vList, pList[i].getID(), i, vLevel + 1, vVisible)
            };
            if (vMinSet == 0 || pList[i].getStart() < vMinDate) {
                vMinDate = pList[i].getStart();
                vMinSet = 1
            };
            if (vMaxSet == 0 || pList[i].getEnd() > vMaxDate) {
                vMaxDate = pList[i].getEnd();
                vMaxSet = 1
            };
            vCompSum += pList[i].getCompVal()
        }
    }
    if (pRow >= 0) {
        pList[pRow].setStart(vMinDate);
        pList[pRow].setEnd(vMaxDate);
        pList[pRow].setNumKid(vNumKid);
        //pList[pRow].setCompVal(Math.ceil(vCompSum / vNumKid))
    }
};
JSGantt.getMinDate = function getMinDate(pList, pFormat) {
    var vDate = new Date();
    vDate.setFullYear(pList[0].getStart().getFullYear(), pList[0].getStart().getMonth(), pList[0].getStart().getDate());
    for (i = 0; i < pList.length; i++) {
        if (Date.parse(pList[i].getStart()) < Date.parse(vDate)) 
        	vDate.setFullYear(pList[i].getStart().getFullYear(), pList[i].getStart().getMonth(), pList[i].getStart().getDate())
    }
    if (pFormat == 'day') {
        vDate.setDate(vDate.getDate() - 1);
        while (vDate.getDay() % 7 > 0) {
            vDate.setDate(vDate.getDate() - 1)
        }
    } else if (pFormat == 'week') {
        vDate.setDate(vDate.getDate() - 7);
        while (vDate.getDay() % 7 > 0) {
            vDate.setDate(vDate.getDate() - 1)
        }
    } else if (pFormat == 'month') {
        while (vDate.getDate() > 1) {
            vDate.setDate(vDate.getDate() - 1)
        }
    } else if (pFormat == 'quarter') {
        if (vDate.getMonth() == 0 || vDate.getMonth() == 1 || vDate.getMonth() == 2) {
            vDate.setFullYear(vDate.getFullYear(), 0, 1)
        } else if (vDate.getMonth() == 3 || vDate.getMonth() == 4 || vDate.getMonth() == 5) {
            vDate.setFullYear(vDate.getFullYear(), 3, 1)
        } else if (vDate.getMonth() == 6 || vDate.getMonth() == 7 || vDate.getMonth() == 8) {
            vDate.setFullYear(vDate.getFullYear(), 6, 1)
        } else if (vDate.getMonth() == 9 || vDate.getMonth() == 10 || vDate.getMonth() == 11) {
            vDate.setFullYear(vDate.getFullYear(), 9, 1)
        }
    };
    return (vDate)
};
JSGantt.getMaxDate = function(pList, pFormat) {
    var vDate = new Date();
    vDate.setFullYear(pList[0].getEnd().getFullYear(), pList[0].getEnd().getMonth(), pList[0].getEnd().getDate());
    for (i = 0; i < pList.length; i++) {
        if (Date.parse(pList[i].getEnd()) > Date.parse(vDate)) {
            vDate.setTime(Date.parse(pList[i].getEnd()))
        }
    }
    if (pFormat == 'day') {
        vDate.setDate(vDate.getDate() + 1);
        while (vDate.getDay() % 6 > 0) {
            vDate.setDate(vDate.getDate() + 1)
        }
    }
    if (pFormat == 'week') {
        vDate.setDate(vDate.getDate() + 11);
        while (vDate.getDay() % 6 > 0) {
            vDate.setDate(vDate.getDate() + 1)
        }
    }
    if (pFormat == 'month') {
        while (vDate.getDay() > 1) {
            vDate.setDate(vDate.getDate() + 1)
        }
        vDate.setDate(vDate.getDate() - 1)
    }
    if (pFormat == 'quarter') {
        if (vDate.getMonth() == 0 || vDate.getMonth() == 1 || vDate.getMonth() == 2) vDate.setFullYear(vDate.getFullYear(), 2, 31);
        else if (vDate.getMonth() == 3 || vDate.getMonth() == 4 || vDate.getMonth() == 5) vDate.setFullYear(vDate.getFullYear(), 5, 30);
        else if (vDate.getMonth() == 6 || vDate.getMonth() == 7 || vDate.getMonth() == 8) vDate.setFullYear(vDate.getFullYear(), 8, 30);
        else if (vDate.getMonth() == 9 || vDate.getMonth() == 10 || vDate.getMonth() == 11) vDate.setFullYear(vDate.getFullYear(), 11, 31)
    }
    return (vDate)
};
JSGantt.findObj = function(theObj, theDoc) {
    var p, i, foundObj;
    if (!theDoc) {
        theDoc = document;
    }
    if ((p = theObj.indexOf("?")) > 0 && parent.frames.length) {
        theDoc = parent.frames[theObj.substring(p + 1)].document;
        theObj = theObj.substring(0, p)
    }
    if (! (foundObj = theDoc[theObj]) && theDoc.all) {
        foundObj = theDoc.all[theObj]
    }
    for (i = 0; ! foundObj && i < theDoc.forms.length; i++) {
        foundObj = theDoc.forms[i][theObj]
    }
    for (i = 0; ! foundObj && theDoc.layers && i < theDoc.layers.length; i++) {
        foundObj = JSGantt.findObj(theObj, theDoc.layers[i].document)
    }
    if (!foundObj && document.getElementById) {
        foundObj = document.getElementById(theObj)
    }
    return foundObj
};
JSGantt.changeFormat = function(pFormat, ganttObj) {
    if (ganttObj) {
        ganttObj.setFormat(pFormat);
        ganttObj.DrawDependencies();
    } else {
        alert(v3x.getMessage('TaskManage.gantt_error'));
    }
};
JSGantt.folder = function(pID, ganttObj) {
    var vList = ganttObj.getList();
    for (i = 0; i < vList.length; i++) {
        if (vList[i].getID() == pID) {
            if (vList[i].getOpen() == 1) {
                vList[i].setOpen(0);
                JSGantt.hide(pID, ganttObj);
                if (JSGantt.isIE()) {
                    JSGantt.findObj('group_' + pID).innerText = '+';
                } else {
                    JSGantt.findObj('group_' + pID).textContent = '+';
                }
            } else {
                vList[i].setOpen(1);
                JSGantt.show(pID, 1, ganttObj);
                if (JSGantt.isIE()) {
                    JSGantt.findObj('group_' + pID).innerText = '-';
                } else {
                    JSGantt.findObj('group_' + pID).textContent = '-';
                }
            }
        }
    }
};
JSGantt.hide = function(pID, ganttObj) {
    var vList = ganttObj.getList();
    var vID = 0;
    for (var i = 0; i < vList.length; i++) {
        if (vList[i].getParent() == pID) {
            vID = vList[i].getID();
            JSGantt.findObj('child_' + vID).style.display = "none";
            JSGantt.findObj('childgrid_' + vID).style.display = "none";
            vList[i].setVisible(0);
            if (vList[i].getGroup() == 1) {
                JSGantt.hide(vID, ganttObj);
            }
        }
    }
};
JSGantt.show = function(pID, pTop, ganttObj) {
    var vList = ganttObj.getList();
    var vID = 0;
    for (var i = 0; i < vList.length; i++) {
        if (vList[i].getParent() == pID) {
            vID = vList[i].getID();
            if (pTop == 1) {
                if (JSGantt.isIE()) {
                    if (JSGantt.findObj('group_' + pID).innerText == '+') {
                        JSGantt.findObj('child_' + vID).style.display = "";
                        JSGantt.findObj('childgrid_' + vID).style.display = "";
                        vList[i].setVisible(1);
                    }
                } else {
                    if (JSGantt.findObj('group_' + pID).textContent == '+') {
                        JSGantt.findObj('child_' + vID).style.display = "";
                        JSGantt.findObj('childgrid_' + vID).style.display = "";
                        vList[i].setVisible(1);
                    }
                }
            } else {
                if (JSGantt.isIE()) {
                    if (JSGantt.findObj('group_' + pID).innerText == '-') {
                        JSGantt.findObj('child_' + vID).style.display = "";
                        JSGantt.findObj('childgrid_' + vID).style.display = "";
                        vList[i].setVisible(1);
                    }
                } else {
                    if (JSGantt.findObj('group_' + pID).textContent == '-') {
                        JSGantt.findObj('child_' + vID).style.display = "";
                        JSGantt.findObj('childgrid_' + vID).style.display = "";
                        vList[i].setVisible(1);
                    }
                }
            }
            if (vList[i].getGroup() == 1) {
                JSGantt.show(vID, 0, ganttObj);
            }
        }
    }
};
JSGantt.taskLink = function(pRef) {
	if(pRef == 'javascript:void(0);'){
		return;
	}
	
//    var ret = v3x.openWindow({
//        url: pRef,
//		width	: getA8Top().document.body.clientWidth  - 100,
//		height	: getA8Top().document.body.clientHeight - 37,
//		resizable	: "true"
//    });
//    if (ret == true || ret == 'true') {
//        try {
//            parent.getA8Top().reFlesh();
//        } catch(e) {}
//    }
    var taskInfoDialog = v3x.openDialog({
        id:"taskInfoDialog",
        title : v3x.getMessage("TaskManage.task_content"),
        url : pRef,
        targetWindow : parent.window.top,
        width : getA8Top().document.body.clientWidth  - 100,
        height : getA8Top().document.body.clientHeight - 37,
        buttons : [{
            id:"close",
            text: v3x.getMessage("TaskManage.task_close"), 
            handler: function () {
                taskInfoDialog.close();
                window.location.href = window.location.href;
            } 
         }]
    });
};
JSGantt.parseDateStr = function(pDateStr, pFormatStr) {
    return parseDate(pDateStr);
};
JSGantt.formatDateStr = function(pDate, pFormatStr) {
    vYear4Str = pDate.getFullYear() + '';
    vYear2Str = vYear4Str.substring(2, 4);
    vMonthStr = (pDate.getMonth() + 1) + '';
    vDayStr = pDate.getDate() + '';
    var vDateStr = "";
    switch (pFormatStr) {
    case 'mm/dd/yyyy':
        return (vMonthStr + '/' + vDayStr + '/' + vYear4Str);
    case 'dd/mm/yyyy':
        return (vDayStr + '/' + vMonthStr + '/' + vYear4Str);
    case 'yyyy-mm-dd':
        return (vYear4Str + '-' + vMonthStr + '-' + vDayStr);
    case 'mm/dd/yy':
        return (vMonthStr + '/' + vDayStr + '/' + vYear2Str);
    case 'dd/mm/yy':
        return (vDayStr + '/' + vMonthStr + '/' + vYear2Str);
    case 'yy-mm-dd':
        return (vYear2Str + '-' + vMonthStr + '-' + vDayStr);
    case 'mm/dd':
        return (vMonthStr + '/' + vDayStr);
    case 'dd/mm':
        return (vDayStr + '/' + vMonthStr)
    }
};