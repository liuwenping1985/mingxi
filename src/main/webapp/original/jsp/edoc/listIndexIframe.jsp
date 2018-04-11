<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>

<html>
<head>
</head>
<body>

<input type="hidden" id="workFlowContent" />
<iframe id="indexIframe" name="indexIframe" src="edocController.do?method=listIndexIframe&from=${param.from}&edocType=${param.edocType}&track=${param.track }&list=${param.list}&listType=${param.listType}&id=${param.id}&meetingSummaryId=${param.meetingSummaryId}&comm=${param.comm}&edocId=${param.edocId}&recieveId=${param.recieveId}&forwordType=${param.forwordType}&checkOption=${param.checkOption}&newContactReceive=${param.newContactReceive}&subType=${param.subType}&exchangeId=${param.exchangeId}&templeteId=${param.templeteId}&affairId=${param.affairId}&app=${param.app}&transmitSendNewEdocId=${param.transmitSendNewEdocId}&registerId=${param.registerId}&recAffairId=${param.recAffairId}&modelType=${param.modelType}" width="100%" height="800" style="border:0px;"/>
</body>
</html>
