<%--
 $Author: xiangq $
 $Rev: 1789 $
 $Date:: 2015-4-27 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<script type="text/javascript" src="${path}/common/all-min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.dd-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="${path}/main.do?method=headerjs&login=${loginTime}"></script>