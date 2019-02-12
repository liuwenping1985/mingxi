/**
 * Author shuqi
 * Rev 
 * Date: 2016年1月16日 下午3:54:49
 *
 * Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.common.image.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.common.image.ImageConstants;
import com.seeyon.apps.common.image.bo.QueryParams;
import com.seeyon.apps.common.image.manager.ImageManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileSecurityManager;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.util.annotation.SetContentType;

/**
 * <p>Title: 通用图片Controller</p>
 * <p>Description:<br>
 * 1、用于显示图片，<br>
 *  </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: seeyon.com</p>
 */
public class ImageController extends BaseController {
	private Log logger = CtpLogFactory.getLog(ImageController.class);
	private static String imageContentType = "image/jpeg";
	private ImageManager imageManager;
	private FileSecurityManager fileSecurityManager;
	/**
	 *<p>Description: 查看图片Controller<br>
	 *	<b>示例URL：</b><br>
	 *		http://xxx:port/contextPath/image.do?method=showImage&id={fileId|showImageId}&size={Source|Original|Custom}&h={12}&w={35}&handler={handlerName}<br>
	 *		http://xxx:port/contextPath/commonimage.do?method=showImage&id={fileId|showImageId}&size={Source|Original|Custom}&h={12}&w={35}&handler={handlerName}<br>
	 *		id:表示自定义尺寸，h表示要切图片的高，w表示要切图片的宽<br>
	 *		size: custom：表示自定义尺寸，h表示要切图片的高，w表示要切图片的宽、source：图片源文件、original：图片等比压缩后的图片，该图片的高和宽不会变；auto动态自动计算算法(用于大图查看)--尽量让图片小并且不失真<br>
	 *		h:要切图的高，只对size=custom有效<br>
	 *		w:要切图的宽，只对size=custom有效<br>
	 *		handler：如果文件不是通过Id不能从FileManager中获取，则可以通过实行
	 *		{@link com.seeyon.apps.common.image.handler.ImageHandler} 来获取图片文件<br>
	 *</p>
	 * @param request
	 * @param response
	 * @throws BusinessException
	 * @see com.seeyon.apps.common.image.handler.ImageHandler
	 */
	@SetContentType
	public ModelAndView showImage(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
		//获取请求数据
		QueryParams queryParams = QueryParams.of(request);
		//1、etag检查
		String etag = queryParams.etag();
		try {
			if(WebUtil.checkEtag(request, response, etag)){
				return null;
			}
		} catch (IOException e) {
			logger.error("读取缓存信息出问题",e);
		}
		
		//2、权限检查（验证不通过返回401）
		if(AppContext.getCurrentUser() == null){
			boolean accessDenied = true;
			if(UserHelper.isFromMicroCollaboration(request)){//微信放行
				accessDenied = false;
			}else if(StringUtils.isBlank(queryParams.handlerName())){
				//如果处理器为空则是文件，安全验证一下
				//说明是默认的通过FileManager获取的
				accessDenied = !fileSecurityManager.isNeedlessLogin(queryParams.id());
			}
			if(accessDenied){//如果访问被拒绝，返回401
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				return null;
			}
		}
		
		
		//3、读取文件
		File file = null;
		// 获取图片文件信息
		try{
			file = imageManager.getImage(queryParams );
		}catch(Exception e){
			logger.error("获取文件出现不可预料的错误", e);
		}
		
		//4、返回数据给浏览器
		if(file != null){
			//以流的形式输出
			FileInputStream in = null;
			OutputStream out = null;
			try {
				//缓存数据
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.SECOND,ImageConstants.cacheDate.intValue()/1000 );
				response.setContentType(imageContentType);
				WebUtil.writeETag(request, response,etag,ImageConstants.cacheDate);
				
				in = new FileInputStream(file);
				out = response.getOutputStream();
				CoderFactory.getInstance().download(in, out);
			} catch (Exception e) {
				logger.error("显示图片出错",e);
				//这个地方不返回404
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}finally{
				IOUtils.closeQuietly(in);
				IOUtils.closeQuietly(out);
			}
		}else{
			//没找到 404
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			logger.info("没有找到图片文件返回404,id=" + queryParams.id() + " handler:" + queryParams.handlerName());
		}
		return null;
	}
	
	//注入Manager
	public void setImageManager(ImageManager imageManager) {
		this.imageManager = imageManager;
	}

	public void setFileSecurityManager(FileSecurityManager fileSecurityManager) {
		this.fileSecurityManager = fileSecurityManager;
	}

}
