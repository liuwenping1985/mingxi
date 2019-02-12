package com.seeyon.apps.czexchange.util;

import java.io.*;
import java.util.Properties;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.io.DocumentSource;

/**
 * 将xml+xslt 转换为 html
 * 
 * @author yangxing
 * 
 */
public class XmlXslToHtmlUtil {
	private static final Log log = LogFactory.getLog(XmlXslToHtmlUtil.class);
	/**通过流输出
	 *  将XML+XSL转换为HTML文件
	 * @param document XML转换为DOCUMENT
	 * @param xslFile XSL文件的字符串
	 * @param htmlName 要生成的HTML文件名
	 * @return 如果成功，返回HTML文件名，否发返回空
	 * @throws TransformerException 
	 * @throws UnsupportedEncodingException 
	 */
	public static InputStream transformToInputStream(Document document, String xslFile) throws TransformerException, UnsupportedEncodingException{
			TransformerFactory factory = TransformerFactory.newInstance();
			// XSLT样式表是静态存储在文件中的，
			// javax.XML.transform.Templates接口把它们解析好了进内存里缓存起来
			InputStream inputStream = new ByteArrayInputStream(xslFile
					.getBytes("utf-8"));
			StreamSource xsl = new StreamSource(inputStream);
			Transformer transformer = factory.newTransformer(xsl);
			Properties props = transformer.getOutputProperties();
			props.setProperty(OutputKeys.ENCODING, "UTF-8");
			props.setProperty(OutputKeys.METHOD, "html");
			props.setProperty(OutputKeys.VERSION, "4.0");
			transformer.setOutputProperties(props);

			DocumentSource docSource = new DocumentSource(document);
			StringWriter strWriter = new StringWriter();
			StreamResult docResult = new StreamResult(strWriter);
			transformer.transform(docSource, docResult);
			String head = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title></title></head><BODY>";
			String end = "</BODY></HTML>";
			String html = strWriter.toString();
			String toHtml = head + html + end;
			InputStream in = new ByteArrayInputStream(toHtml.getBytes("UTF-8"));   
			return in;
	}
	/**通过流输出
	 *  将XML+XSL转换为HTML文件
	 * @param document XML转换为DOCUMENT
	 * @param xslFile XSL文件的字符串
	 * @param htmlName 要生成的HTML文件名
	 * @return 如果成功，返回HTML文件名，否发返回空
	 * @throws TransformerException 
	 * @throws UnsupportedEncodingException 
	 */
	public static String transformToString(Document document, String xslFile) throws TransformerException, UnsupportedEncodingException{
			TransformerFactory factory = TransformerFactory.newInstance();
			// XSLT样式表是静态存储在文件中的，
			// javax.XML.transform.Templates接口把它们解析好了进内存里缓存起来
			InputStream inputStream = new ByteArrayInputStream(xslFile
					.getBytes("utf-8"));
			StreamSource xsl = new StreamSource(inputStream);
			Transformer transformer = factory.newTransformer(xsl);
			Properties props = transformer.getOutputProperties();
			props.setProperty(OutputKeys.ENCODING, "UTF-8");
			props.setProperty(OutputKeys.METHOD, "html");
			props.setProperty(OutputKeys.VERSION, "4.0");
			transformer.setOutputProperties(props);

			DocumentSource docSource = new DocumentSource(document);
			StringWriter strWriter = new StringWriter();
			StreamResult docResult = new StreamResult(strWriter);
			transformer.transform(docSource, docResult);
			String head = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title></title></head><BODY>";
			String end = "</BODY></HTML>";
			String html = strWriter.toString();
			String toHtml = head + html + end;
			return toHtml;
	}	
	/**
	 * 将HTML字符串，生成HTML文件
	 * @param htmlFile HTML字符串
	 * @param htmlName HTML文件名
	 * @return 如果生成成功返回HTML文件名，否则返回空
	 * @throws UnsupportedEncodingException 
	 */
	public static InputStream transformToInputStream(String htmlFile) throws UnsupportedEncodingException{
			
			String head = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title></title></head><BODY>";
			String end = "</BODY></HTML>";
			String toHtml = head + htmlFile + end;
			InputStream in = new ByteArrayInputStream(toHtml.getBytes("utf-8"));

		return in;
	}
	public static String transformToString(String htmlFile) throws UnsupportedEncodingException{
		
		String head = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title></title></head><BODY>";
		String end = "</BODY></HTML>";
		String toHtml = head + htmlFile + end;
	return toHtml;
	}
}
