<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript">
//初始化全局变量
var spacecharArray=[];
spacecharArray[" "]="1";
spacecharArray["\r"]="1";
spacecharArray["\n"]="1";
spacecharArray["\t"]="1";

//数字计算操作变量
var math_operatorList=[];
math_operatorList["+"]="+";
math_operatorList["-"]="-";
math_operatorList["*"]="*";
math_operatorList["/"]="/";
math_operatorList["("]="(";
math_operatorList[")"]=")";

//布尔计算操作变量
var boolean_operatorList=[];
boolean_operatorList['>']=">";
boolean_operatorList['>=']=">=";
boolean_operatorList['<']="<";
boolean_operatorList['<=']="<=";
boolean_operatorList['=']="=";
boolean_operatorList['<>']="<>";
boolean_operatorList['and']="and";
boolean_operatorList['or']="or";
boolean_operatorList['xor']="xor"; 
//解析状态常量
var C_iState_Normal=0;//标准状态
var C_iState_QMSingl=1;//单引号状态
var C_iState_QMDouble=2;//双引号状态
var C_iState_Token=3;//单词状态

//单词状态常量
var C_iWord_Normal=100;//标准状态
var C_iWord_Function=101;//函数状态
var C_iWord_Function_QMSingl=102;//函数状态中的单引号状态
var C_iWord_Function_QMDouble=103;//函数状态中的双引号状态
var C_iWord_Function_End=104;//函数结束状态
var C_iWord_operator=105;//单位操作符状态

//词法类型
var C_iToken_Number=0;
var C_iToken_String=1;
var C_iToken_word=2;
var C_iToken_SystemValue=3;
var C_iToken_DataColum=4;
var C_iToken_Operator=5;
var C_iToken_UserCondition=6;
var C_iToken_Function=7;
var C_sErr_noString="不允许出现字符串!";
var C_sErr_unkownword="未定义的变量!";
var C_sErr_noOperater="之间无操作符!";
var C_sErr_OperaterPreviousValue="无左操作变量!";
var C_sErr_OperaterPreviousIsDataCol="左操作变量必须是表单数据域，您设置的是：";
var C_sErr_OperaterNextNotDataCol="右操作变量不允许是表单数据域，您设置的是：";
var C_sErr_OperaterNoNextValue="无右操作变量!";
var C_sErr_OperaterNoOperNextValue="无操作符及右操作变量!";
var C_sErr_qtLevel="括号不匹配!"; 
var C_sErr_FunctionParamnotDataColum="函数的参数不是重复项数据域!";

var isCondition = false;

/**
*  条件列表类
*  aAllowBoolean  是否支持布尔型操作
*  aAllowString   允许字符串变量
**/
function CheckFormula(aAllowBoolean,aAllowString){
    this.funcNameList=null;
    this.operatorList=[];
    this.addOperatorList(math_operatorList);
    this.dataColumNameList=null;
    this.systemValueNameList=null;
    this.userConditionNameList=null;
    
    if (aAllowBoolean==undefined){
        aAllowBoolean=true;
        isCondition = true;
    }
    if (aAllowString==undefined)
    aAllowString==true;
    this.allowBoolean=aAllowBoolean;
    this.allowString=aAllowString;
    
    if (this.allowBoolean)
     this.addOperatorList(boolean_operatorList);
    this.conditionList=[];
}
CheckFormula.prototype.addOperatorList= function(aList){
    var key; 
    for (key in aList)   {
        this.operatorList[key]=aList[key];
    }
}
//是否为函数名
CheckFormula.prototype.isFunctionName= function(aName){
    if (this.funcNameList==undefined || this.funcNameList==null) return false;
    return  this.funcNameList[aName]!=undefined;
}
//是否为数据域,数据域必须由花括负包围,如{订货单位}
CheckFormula.prototype.isDataColum= function(aName){
    if (this.dataColumNameList == undefined
                || this.dataColumNameList == null)
            return false;
        var isSys = this.isSystemDataColum(aName);
        var ftempname = aName;
        if ((aName.charAt(0) == "{" && aName.charAt(aName.length - 1) == "}")
                || isSys) {
            if (!isSys) {
                ftempname = aName.substring(1, aName.length - 1);
            }
            return this.dataColumNameList[ftempname] != undefined;
        }
        return false;
    }

    //判断是否是系统数据域 
    CheckFormula.prototype.isSystemDataColum = function(aName) {
        if (document.getElementById("systemDataSelect")) {
            var optionsAry = document.getElementById("systemDataSelect").options;
            for ( var k = 0; k < optionsAry.length; k++) {
                if (aName == optionsAry[k].text) {
                    return true;
                }
            }
        } else {
            return false;
        }
        return false;
    }
    //是否为用户条件
    CheckFormula.prototype.isUserCondition = function(aName) {
        if (this.userConditionNameList == undefined
                || this.userConditionNameList == null)
            return false;
        if (aName.charAt(0) == "[" && aName.charAt(aName.length - 1) == "]") {
            var ftempname = aName.substring(1, aName.length - 1);
            return this.userConditionNameList[ftempname] != undefined;
        }
        return false;
    }

    //是否为系统变量
    CheckFormula.prototype.isSystemValue = function(aName) {
        if (this.systemValueNameList == undefined
                || this.systemValueNameList == null)
            return false;
        return this.systemValueNameList[aName] != undefined;
    }

    CheckFormula.prototype.getDefineName = function(aName) {
        return aName.substring(1, aName.length - 1);
    }

    CheckFormula.prototype.isNumber = function(aString) {
        return !isNaN(aString);
    }

    CheckFormula.prototype.addFunction = function(aFunctionInfo) {

        var result;
        result = new Token_function(aFunctionInfo);
        var ftemp = this.funcNameList[result.functionName];
        if (typeof (ftemp) != "object")
            result.checkObj = null;
        else
            result.checkObj = ftemp;
        this.conditionList.push(result);
    }

    CheckFormula.prototype.addWord = function(aString) {
        if (aString == undefined || aString == "")
            return;

        if (this.operatorList[aString] != undefined) { //判断是否为多字节操作符  如 and or
            this.conditionList.push(new Token_Operator(aString));
        } else if (this.isDataColum(aString)) {//判断是否为数据域
            if (!this.isSystemDataColum(aString))
                aString = this.getDefineName(aString);
            this.conditionList.push(new Token_DataColum(aString));
        } else if (this.isUserCondition(aString)) {//判断是否为数据域
            this.conditionList.push(new Token_UserCondition(this
                    .getDefineName(aString)));
        } else if (this.isSystemValue(aString)) { //判断是否系统变量
            if (aString == "单据状态_未核定" || aString == "单据状态_核定通过"
                    || aString == "单据状态_核定不通过") {
                this.conditionList[this.conditionList.length - 2] = new Token_SystemValue(
                        "核定状态");
            }
            this.conditionList.push(new Token_SystemValue(aString));
        } else if (this.isNumber(aString)) {
            this.conditionList
                    .push(new Token_value(aString, C_iToken_Number));
        } else
            this.conditionList.push(new Token_value(aString, C_iToken_word));
    }

    CheckFormula.prototype.toString = function() {
        var result = new Array();
        for (i = 0; i < this.conditionList.length; i++) {
            result += this.conditionList[i].toString() + "\n";
        }
        return result;
    }
    //检查解析完毕后的token
    CheckFormula.prototype.chekToken = function() {
        var i;
        var fPrevious, fNext, k;
        fPrevious = null;
        fNext = null;
        fnow = null;
        var result;
        var qtLevel = 0;
        for (i = 0; i < this.conditionList.length; i++) {
            fPrevious = fnow;
            fnow = this.conditionList[i];
            if ((i + 1) < this.conditionList.length)
                fNext = this.conditionList[i + 1];
            else
                fNext = null;

            if (!this.allowString)
                if (fnow.tokentype == C_iToken_String)
                    return C_sErr_noString + fnow.value;

            result = fnow.checkToken(fPrevious, fNext);
            if (result != null)
                return result;
            if (fnow.tokentype == C_iToken_Operator)
                if (fnow.operator == "(")
                    qtLevel++;
                else if (fnow.operator == ")")
                    qtLevel--;
            if (qtLevel < 0)
                return C_sErr_qtLevel;
        }

        if (qtLevel != 0)
            return C_sErr_qtLevel;
        return null;
    }

    //解析指定的字符串,解析成功返回"",解析失败返回,错误提示
    CheckFormula.prototype.validate = function(aText) {
        //清空列表
        this.conditionList.length = 0;
        var i = 0;
        var v_length = aText.length;
        if (v_length <= 0)
            return "";
        var index = 0;
        var tokenStart = 0;
        var flage = C_iState_Normal;
        var wordflage = C_iWord_Normal;
        var currnetChar;
        var tempflage;
        var nextChar;
        var fieldDataFlag = false;
        var uconditionFlag = false;
        while (index < v_length) {
            currnetChar = aText.charAt(index);
            switch (flage) {
                case C_iState_Normal: //普通状态
                    flage = pase_0(currnetChar);
                    tokenStart = index;
                    if (flage == C_iState_Token) {
                        wordflage = C_iWord_Normal;
                        if (currnetChar == '{')
                            fieldDataFlag = true;
                        if (currnetChar == '[')
                            uconditionFlag = true;
                        continue; //需要到Token中重新解析一次
                    }
                    break;
                case C_iState_QMSingl: //单引号状态
                    flage = pase_1(currnetChar);
                    if (flage == C_iState_Normal) {
                        this.conditionList.push(new Token_value(aText
                                .substring(tokenStart, index)
                                + "'", C_iToken_String));
                        tokenStart = index + 1;
                    }
                    break;
                case C_iState_QMDouble: //双引号状态
                    flage = pase_2(currnetChar);
                    if (flage == C_iState_Normal) {
                        this.conditionList.push(new Token_value(aText
                                .substring(tokenStart, index)
                                + '"', C_iToken_String));
                        tokenStart = index + 1;
                    }
                    break;
                case C_iState_Token: //单词状态
                    tempflage = pase_3(currnetChar, wordflage,
                            this.operatorList);
                    if (currnetChar == '-' && fieldDataFlag) {
                        tempflage = C_iWord_Normal;
                    }
                    //修改去掉第一个条件
                    if (tempflage == C_iWord_operator && uconditionFlag
                            && currnetChar == '-') {
                        tempflage = C_iWord_Normal;
                    }

                    //如果当前是'-'，下一个字符是数字，则当普通字符串处理        
                    nextChar = aText.charAt(index + 1);
                    if (tempflage == C_iWord_operator && currnetChar == '-'
                            && !isNaN(parseInt(nextChar, 10))) {
                        tempflage = C_iWord_Normal;
                    }

                    //将括号（表单数据域）中的-符号进行过滤，不做为操作符判断
                    if (currnetChar == '-' && fieldDataFlag) {
                        tempflage = C_iWord_Normal;
                    }
                    if (currnetChar == '-' && uconditionFlag) {
                        tempflage = C_iWord_Normal;
                    }
                    if (currnetChar == '}')
                        fieldDataFlag = false;
                    if (currnetChar == ']')
                        uconditionFlag = false;
                    //单词状态未改变,继续
                    if (wordflage == tempflage)
                        break;//跳出 switch flage语句

                    //一般的单词结束
                    if (tempflage <= C_iWord_Normal) {
                        flage = tempflage;
                        if (tokenStart < index)
                            this.addWord(aText.substring(tokenStart, index));
                        tokenStart = index;
                        wordflage = C_iWord_Normal;
                        break; //跳出 switch flage语句
                    }

                    //单词状态,并且遇到操作符 
                    if (tempflage == C_iWord_operator) {
                        if (currnetChar == '(') {
                            if (index == tokenStart) {
                                this.conditionList.push(new Token_Operator(
                                        "("));
                                tokenStart = index + 1;
                                wordflage = C_iWord_Normal;
                                break; //跳出 switch flage语句
                            } else if (this.isFunctionName(aText.substring(
                                    tokenStart, index))) {//是系统函数
                                wordflage = C_iWord_Function;
                                break; //跳出 switch flage语句
                            }
                        }
                        //其他操作符,直接断词
                        if (tokenStart < index)
                            this.addWord(aText.substring(tokenStart, index));//添加词
                        if (currnetChar == "<" || currnetChar==">") {
                            if ((index + 1) < v_length) {
                                nextChar = aText.charAt(index + 1);
                                if (nextChar == "="
                                        || ((currnetChar == "<") && (nextChar == ">"))) {//是大于等于,小于等于,不等于 双操作符
                                    this.conditionList
                                            .push(new Token_Operator(
                                                    currnetChar + nextChar));//添加操作符
                                    //忽略下一个字符
                                    index++;
                                    tokenStart = index + 1;
                                    wordflage = C_iWord_Normal;
                                    break; //跳出 switch flage语句
                                }
                            }
                        }

                        this.conditionList.push(new Token_Operator(
                                currnetChar));//添加操作符
                        tokenStart = index + 1;
                        wordflage = C_iWord_Normal;
                        break; //跳出 switch flage语句
                    }
                    //函数状态结束   
                    if (tempflage == C_iWord_Function_End) {
                        this.addFunction(aText.substring(tokenStart, index)
                                + ')');//添加函数
                        tokenStart = index + 1;
                        wordflage = C_iWord_Normal;
                        break; //跳出 switch flage语句
                    }

                    wordflage = tempflage;
                    break;
            }
            index++;
        }

        if (tokenStart < v_length) {
            if (flage == C_iState_Normal)
                ;//尾部的空白不需要处理
            else if (flage == C_iState_QMSingl) //自动添加单引号,结束掉值
                this.conditionList.push(new Token_value(aText.substring(
                        tokenStart, v_length)
                        + "'", C_iToken_String));
            else if (flage == C_iState_QMDouble)//自动添加双引号,结束掉值
                this.conditionList.push(new Token_value(aText.substring(
                        tokenStart, v_length)
                        + '"', C_iToken_String));
            else if (flage == C_iState_Token) {
                if (wordflage == C_iWord_Normal) //结算单词
                    this.addWord(aText.substring(tokenStart, v_length));
                else if (wordflage == C_iWord_Function) //结束函数,添加右括符
                    this.addFunction(aText.substring(tokenStart, v_length)
                            + ')');//添加函数
                else if (wordflage == C_iWord_Function_QMSingl) //结束函数,添加单引号和右括符
                    this.addFunction(aText.substring(tokenStart, v_length)
                            + "')");//添加函数
                else if (wordflage == C_iWord_Function_QMSingl) //结束函数,添加双引号和右括符
                    this.addFunction(aText.substring(tokenStart, v_length)
                            + '")');//添加函数
            } else
                return "结束数据未解析 = " + aText.substring(tokenStart, v_length);
        }

        var result = this.chekToken();
        if (result == null)
            return "";
        else
            return result;
    }

    //解析普通状态
    function pase_0(aChar) {
        //判断是否为空白字符
        if (spacecharArray[aChar] != undefined)
            return C_iState_Normal;
        if (aChar == "'")
            return C_iState_QMSingl;
        if (aChar == '"')
            return C_iState_QMDouble;
        return C_iState_Token;
    }

    //解析单引号
    function pase_1(aChar) {
        if (aChar == "'")
            return C_iState_Normal;
        else
            return C_iState_QMSingl;
    }

    //解析双引号
    function pase_2(aChar) {
        if (aChar == '"')
            return C_iState_Normal;
        else
            return C_iState_QMDouble;
    }

    //解析单词状态
    function pase_3(aChar, aWordFlage, aOperatorList) {
        switch (aWordFlage) {
            case C_iWord_Normal: //普通状态
                return pase_31(aChar, aOperatorList);
            case C_iWord_Function: //函数状态
                return pase_32(aChar);
            case C_iWord_Function_QMSingl: //函数状态中的单引号状态
                return pase_321(aChar);
            case C_iWord_Function_QMDouble://函数状态中的双引号状态
                return pase_322(aChar);
        }
    }

    //标准单词解析
    function pase_31(aChar, aOperatorList) {

        //遇到空白字符,单词结束
        if (spacecharArray[aChar] != undefined)
            return C_iState_Normal;

        //遇到单位操作符,单词结束
        if (aOperatorList[aChar] != undefined)
            return C_iWord_operator;

        //遇到单引号,单词结束
        if (aChar == "'")
            return C_iState_QMSingl;

        //遇到双引号,单词结束
        if (aChar == '"')
            return C_iState_QMDouble;

        return C_iWord_Normal;
    }

    //函数方式下的解析
    function pase_32(aChar) {
        if (aChar == ")")
            return C_iWord_Function_End;
        else if (aChar == "'")
            return C_iWord_Function_QMSingl;
        else if (aChar == '"')
            return C_iWord_Function_QMDouble;
        else
            return C_iWord_Function;
    }

    //函数单引号状态下的解析
    function pase_321(aChar) {
        if (aChar == "'")
            return C_iWord_Function;
        else
            return C_iWord_Function_QMSingl;
    }

    function pase_322(aChar) {
        if (aChar == '"')
            return C_iWord_Function;
        else
            return C_iWord_Function_QMDouble;
    }

    //变量,手工输入的字符串,数字等
    function Token_value(aValue, aType) {
        this.tokentype = aType;
        this.value = aValue;
    }

    Token_value.prototype.toString = function() {
        switch (this.tokentype) {
            case C_iToken_Number:
                return "数字: " + this.value;
            case C_iToken_String:
                return "字符串: " + this.value;
            case C_iToken_word:
                return "单词: " + this.value;
        }
    }
    function checkvalueToken(aPrevious, aNext, aThisValue) {
        if (isCondition&&aThisValue && aNext == null && aThisValue.indexOf("数据域: ") != -1) {
            return C_sErr_OperaterNoOperNextValue + " " + aThisValue;
        }
        if (aPrevious != null) {
            switch (aPrevious.tokentype) {
                case C_iToken_Number:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
                case C_iToken_String:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
                case C_iToken_SystemValue:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
                case C_iToken_DataColum:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
                case C_iToken_UserCondition:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
                case C_iToken_Function:
                    return " " + aThisValue + " " + aPrevious.toString()
                            + C_sErr_noOperater;
            }
        }
        if (aNext != null) {
            switch (aNext.tokentype) {
                case C_iToken_Number:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
                case C_iToken_String:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
                case C_iToken_SystemValue:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
                case C_iToken_DataColum:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
                case C_iToken_UserCondition:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
                case C_iToken_Function:
                    return " " + aThisValue + " " + aNext.toString()
                            + C_sErr_noOperater;
            }
        }
        return null;
    }
    Token_value.prototype.checkToken = function(aPrevious, aNext) {
        if (this.tokentype == C_iToken_word)
            return C_sErr_unkownword + this.value;

        return checkvalueToken(aPrevious, aNext, this.toString());
    }
    //数据域
    function Token_DataColum(aColumName) {
        this.tokentype = C_iToken_DataColum;
        this.colum = aColumName;
    }
    Token_DataColum.prototype.toString = function() {
        return "数据域: " + this.colum;
    }
    Token_DataColum.prototype.checkToken = function(aPrevious, aNext) {
        return checkvalueToken(aPrevious, aNext, this.toString());
    }
    //数据操作
    function Token_Operator(aOperator) {
        this.tokentype = C_iToken_Operator;
        this.operator = aOperator;
    }

    Token_Operator.prototype.toString = function() {
        return "操作: " + this.operator;
    }
    Token_Operator.prototype.checkToken = function(aPrevious, aNext) {
        switch (this.operator) {
            case ">":
            case ">=":
            case "<":
            case "<=":
            case "=":
            case "<>":
                if (aNext != null && aNext.tokentype == C_iToken_DataColum)//操作符右侧不能是C_iToken_DataColum
                    return C_sErr_OperaterNextNotDataCol + aNext.toString()
                            + " " + this.toString();
            case "+":
            case "-":
            case "*":
            case "/":
                if (aPrevious != null
                        && aPrevious.tokentype != C_iToken_DataColum) {//操作符左侧必须C_iToken_DataColum
                    var flag = true;
                    if (aPrevious.tokentype == C_iToken_Operator) {
                        flag = !(aPrevious.operator == "(" || aPrevious.operator == ")");
                    }
                    if (aPrevious.tokentype == C_iToken_Function
                            || aPrevious.tokentype == C_iToken_Number) {
                        flag = false;
                    }
                    /*
                    if (flag) {
                        var systemvartype = "系统变量: ";
                        var sheetstatus = "单据状态";
                        var sheetfinished = "流程状态";
                        var sheetratify = "核定状态";
                        if (aPrevious.toString() != (systemvartype + sheetstatus)
                                && aPrevious.toString() != (systemvartype + sheetfinished)
                                && aPrevious.toString() != (systemvartype + sheetratify))//单据状态和流程状态除外和核定状态
                            return C_sErr_OperaterPreviousIsDataCol
                                    + aPrevious.toString() + " "
                                    + this.toString();
                    }
                    */
                }
            case "and":
            case "or":
            case "xor":
                if (aNext == null)
                    return C_sErr_OperaterNoNextValue + this.toString();
                if (aNext.tokentype == C_iToken_Operator
                        && aNext.operator != "(")//后续的操作节点不是括号
                    return C_sErr_OperaterNoNextValue + this.toString() + " "
                            + aNext.toString();
                if (aPrevious == null)
                    return C_sErr_OperaterPreviousValue + this.toString();
                if (aPrevious.tokentype == C_iToken_Operator)//后续的操作节点不是括号
                    if (aPrevious.operator != ")")
                        return C_sErr_OperaterPreviousValue
                                + aPrevious.toString() + " " + this.toString();
                break;
            case "(":
                if (aPrevious != null)
                    if (aPrevious.tokentype != C_iToken_Operator) //括号左边必须是操作符
                        return aPrevious.toString() + " " + this.toString()
                                + C_sErr_noOperater;
                break;
            case ")":
                if (aNext != null) {
                    if (aNext.tokentype != C_iToken_Operator) { //括号右边必须是操作符
                        return this.toString() + " " + aNext.toString()
                                + C_sErr_noOperater;
                    } else if (aNext.operator == "(") {
                        return this.toString() + " " + aNext.toString()
                                + C_sErr_noOperater;
                    }
                }
                break;
        }
        return null;
    }
    //函数
    function Token_function(aFunctionInfo, aCheckObj) {
        this.tokentype = C_iToken_Function;
        if (aCheckObj == undefined)
            this.checkObj = null;
        else
            this.checkObj = aCheckObj;
        var findex = aFunctionInfo.indexOf("(");
        this.functionName = aFunctionInfo.substring(0, findex);
        if ((findex + 1) < (aFunctionInfo.length - 1))
            this.functionParam = aFunctionInfo.substring(findex + 1,
                    aFunctionInfo.length - 1);
        else
            this.functionParam = "";
    }
    Token_function.prototype.toString = function() {
        return "函数: " + this.functionName + " " + this.functionParam;
    }
    Token_function.prototype.checkToken = function(aPrevious, aNext) {
        var result = checkvalueToken(aPrevious, aNext, this.toString());
        if (result != null)
            return result;
        if (this.checkObj == null)
            return null;
        return this.checkObj.checkFunctionParam(this.functionName,
                this.functionParam);

    }
    //系统变量
    function Token_SystemValue(aSysValue) {
        this.tokentype = C_iToken_SystemValue;
        this.valueName = aSysValue;
    }

    Token_SystemValue.prototype.toString = function() {
        return "系统变量: " + this.valueName;
    }
    Token_SystemValue.prototype.checkToken = function(aPrevious, aNext) {
        return checkvalueToken(aPrevious, aNext, this.toString());
    }

    //用户条件类
    function Token_UserCondition(aParamName) {
        this.tokentype = C_iToken_UserCondition;
        this.conditionName = aParamName;
    }

    Token_UserCondition.prototype.toString = function() {
        return "用户条件: " + this.conditionName;
    }
    Token_UserCondition.prototype.checkToken = function(aPrevious, aNext) {
        return checkvalueToken(aPrevious, aNext, this.toString());
    }

    function SumFunctionCheckObj(aDataColumList) {
        this.DatacolumList = aDataColumList;
    }
    SumFunctionCheckObj.prototype.checkFunctionParam = function(aName, aParam) {
        if (this.DatacolumList == undefined || this.DatacolumList == null)
            return aName + C_sErr_FunctionParamnotDataColum + aParam;
        if (aParam.charAt(0) == "{" && aParam.charAt(aParam.length - 1) == "}") {
            var ftempname = aParam.substring(1, aParam.length - 1);
            if (this.DatacolumList[ftempname] != undefined)
                return null;
            else
                return aName + C_sErr_FunctionParamnotDataColum + aParam;
        }
        return aName + C_sErr_FunctionParamnotDataColum + aParam;
    }
    function TodateFunctionCheckObj() {

    }
    TodateFunctionCheckObj.prototype.checkFunctionParam = function(aName,
            aParam) {

        var dateStr = aParam;
        if (isDate(dateStr))
            return null;
        else
            return "用户条件: " + this.conditionName;

    }
    //判断是否是日期
    function isDate(aValue) {
        if (aValue == "" || aValue.length == 0)
            return aMsg;
        ymd1 = aValue.split("-");
        month1 = ymd1[1] - 1
        var Date1 = new Date(ymd1[0], month1, ymd1[2]);
        if (Date1.getMonth() + 1 != ymd1[1] || Date1.getDate() != ymd1[2]
                || Date1.getFullYear() != ymd1[0] || ymd1[0].length != 4) {
            return false
        }
        return true;
    }
    function differDateFunctionCheckObj(aDataColumList) {
        this.DatacolumList = aDataColumList;
    }
    differDateFunctionCheckObj.prototype.checkFunctionParam = function(aName,
            aParam) {
        if (this.DatacolumList == undefined || this.DatacolumList == null)
            return aName + C_sErr_FunctionParamnotDataColum + aParam;
        if (aParam.length == 0)
            return "differDate参数不能为空!";
        var params = aParam.split(",");
        if (params.length != 2)
            return "differDate参数个数不正确！";
        if (params[0].charAt(0) == "{"
                && params[0].charAt(params[0].length - 1) == "}") {
            if (this.DatacolumList[params[0].substring(1, params[0].length - 1)] == undefined)
                return "differDate参数不是日期数据域！";
        } else {
            return "differDate参数不是表单数据域！";
        }

        if (params[1].charAt(0) == "{"
                && params[1].charAt(params[1].length - 1) == "}") {
            if (this.DatacolumList[params[1].substring(1, params[1].length - 1)] == undefined)
                return "differDate参数不是日期数据域！";
        } else {
            return "differDate参数不是表单数据域！";
        }
        return null;
    }
</script>
