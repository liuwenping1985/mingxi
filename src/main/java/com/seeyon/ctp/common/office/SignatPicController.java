package com.seeyon.ctp.common.office;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.ctp.util.annotation.SetContentType;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class SignatPicController extends BaseController {

  private static Log log = LogFactory.getLog(HtmlHandWriteManager.class);

  private HandWriteManager handWriteManager;

  private V3xHtmDocumentSignatManager htmSignetManager;

  public static Log getLog() {
    return log;
  }

  public static void setLog(Log log) {
    SignatPicController.log = log;
  }

  public V3xHtmDocumentSignatManager getHtmSignetManager() {
    return htmSignetManager;
  }

  public void setHtmSignetManager(V3xHtmDocumentSignatManager htmSignetManager) {
    this.htmSignetManager = htmSignetManager;
  }

  public static BASE64Decoder getDecoder() {
    return decoder;
  }

  public static void setDecoder(BASE64Decoder decoder) {
    SignatPicController.decoder = decoder;
  }

  public static BASE64Encoder getEncoder() {
    return encoder;
  }

  public static void setEncoder(BASE64Encoder encoder) {
    SignatPicController.encoder = encoder;
  }

  public HandWriteManager getHandWriteManager() {
    return handWriteManager;
  }

  private static BASE64Decoder decoder = new BASE64Decoder();

  private static BASE64Encoder encoder = new BASE64Encoder();

  public void setHandWriteManager(HandWriteManager handWriteManager) {
    this.handWriteManager = handWriteManager;
  }

  
  /**
   * 
   * 注意 ： NeedlessCheckLogin 设置了这个接口不受登录校验， 所以下面的接口需要做安全校验
   * 
   * @param request
   * @param response
   * @return
   * @throws IOException
   *
   * @Date        : 2016年8月9日下午5:08:09
   *
   */
  @SetContentType
  @NeedlessCheckLogin
  public ModelAndView writeGIF(HttpServletRequest request, HttpServletResponse response) throws IOException {

      User user = AppContext.getCurrentUser();
      boolean accessDenied =false;
      if( user == null){
          // 如果没有登录,只对来自微信的放行.
          if(UserHelper.isFromMicroCollaboration(request)){
              accessDenied = false;
          }else{
              accessDenied = true;
          }
      }
     
     //没有登录，直接屏蔽
     if(accessDenied){
         response.setStatus(HttpServletResponse.SC_NOT_FOUND);
         return null;
     }
      
    response.setContentType("image/jpeg");
    String RECORDID = request.getParameter("RECORDID");
    String FIELDNAME = request.getParameter("FIELDNAME");
    String _isNewImg = request.getParameter("isNewImg");
    String _affairId = request.getParameter("affairId");

    boolean isNewImg = false;
    if (Strings.isNotBlank(_isNewImg)) {
      isNewImg = Boolean.valueOf(_isNewImg);
    }

    List<V3xHtmDocumentSignature> dsList = null;
    V3xHtmDocumentSignature ds = new V3xHtmDocumentSignature();
    dsList = htmSignetManager.findBySummaryIdPolicyAndType(Long.valueOf(RECORDID), FIELDNAME,
        V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
    String srcData = "";
    if (isNewImg) {
      // 文单签批
      if (dsList != null && dsList.size() > 0) {
        // 老数据没有affairId数据直接载入
        if (dsList.size() == 1 && dsList.get(0).getAffairId() == null) {
          srcData = dsList.get(0).getFieldValue();
          getPic(srcData,response);
        } else {
          for (V3xHtmDocumentSignature s : dsList) {
            if (s.getAffairId() != null && s.getAffairId().equals(Long.valueOf(_affairId))) {
              srcData = s.getFieldValue();
              getPic(srcData,response);
            }
          }
        }
      }
    } else {
      //表单签批
      if (dsList != null && dsList.size() > 0) {
        ds = dsList.get(0);
        srcData = ds.getFieldValue(); // 设置签章数据
      }
      getPic(srcData,response);
    }
    
    return null;
  }

  private static void getPic(String srcData,HttpServletResponse response) throws IOException{
	byte[] pictureValue = null;
    OutputStream out = response.getOutputStream();
    DBstep.iMsgServer2000 msgObj = new DBstep.iMsgServer2000();
    if(Strings.isNotBlank(srcData)){
    	pictureValue = msgObj.LoadRevisionAsImgByte(srcData);
    }
    if(null == pictureValue){
      int width = 1;
      int height = 1;
      BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_BGR);
      //将图片背景设置成白色
      Graphics graphics = image.getGraphics();  
      graphics.setColor(Color.WHITE);
      graphics.fillRect(0, 0, width, height);
      ImageIO.write(image, "JPEG", response.getOutputStream());
      
    }else{
      out.write(pictureValue);
      out.flush();
    }
    
//    Properties p = null;
//    p = getSignatureDataFromJGBase64(srcData);
//    if (p != null) {
//      String userStr = p.getProperty("UserList");
//      String[] userArray = userStr.split(",");
//      int len = userArray.length;
//
//      try {
//        for (int i = 0; i < len; ++i) {
//          String tmpUser = userArray[i];
//          if ((tmpUser != null) && (!("".equals(tmpUser)))) {
//            String tmpPicData = p.getProperty(tmpUser);
//            if ((tmpPicData != null) && (!("".equals(tmpPicData))) && (tmpPicData.length() > 4))
//              writePicData(tmpPicData, out, true);
//          }
//        }
//      } finally {
//        try {
//          if (out != null)
//            out.close();
//        } catch (Exception e) {
//          log.error(e.getLocalizedMessage(), e);
//        }
//      }
//
//    } else {
//      // 指定生成的响应是图片
//      response.setContentType("image/jpeg");
//      int width = 1;
//      int height = 1;
//      BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_BGR);
//
//      ImageIO.write(image, "JPEG", response.getOutputStream());
//    }
  
  }
  
  
//  private static Properties getSignatureDataFromStandardBase64(String srcData) throws IOException {
//    Properties p = null;
//    if ((srcData != null) && (!("".equals(srcData)))) {
//      byte[] srcDataByteArray = decoder.decodeBuffer(srcData);
//      p = parseSignatureData(srcDataByteArray);
//    }
//    return p;
//  }
//
//  private static Properties parseSignatureData(byte[] signatureData) throws IOException {
//    Properties p = new Properties();
//    if ((signatureData != null) && (signatureData.length > 0)) {
//      ByteArrayInputStream in = new ByteArrayInputStream(signatureData);
//      InputStreamReader aIn = new InputStreamReader(in, "utf-8");
//      BufferedReader reader = new BufferedReader(aIn);
//      String tmp = null;
//      while ((tmp = reader.readLine()) != null) {
//        int eIndex = tmp.indexOf("=");
//        if (eIndex == -1)
//          break;
//        String key = tmp.substring(0, eIndex);
//        String value = tmp.substring(eIndex + 1);
//        p.setProperty(key, value);
//      }
//
//    }
//
//    return p;
//  }
//
//  private static Properties getSignatureDataFromJGBase64(String srcData) throws IOException {
//    Properties p = null;
//    if ((srcData != null) && (!("".equals(srcData)))) {
//      iMsgServer2000 iMsgServer2000 = new iMsgServer2000();
//      String tmpStr = iMsgServer2000.DecodeBase64(srcData);
//      p = parseSignatureData(tmpStr.getBytes("utf-8"));
//    }
//    return p;
//  }
//
//  public static void writePicData(String picData, OutputStream out, boolean needFix)
//      throws IOException {
//    BufferedImage image = createImage(picData);
//    if (needFix) {
//      ByteArrayOutputStream byteArrayOut = new ByteArrayOutputStream();
//      image = toFixBackground(image);
//      ImageIO.write(image, "gif", byteArrayOut);
//      byte[] tmpByteArray = byteArrayOut.toByteArray();
//      image = ImageIO.read(new ByteArrayInputStream(tmpByteArray));
//    }
//    GifEncoder gifEncoder = new GifEncoder(image, out);
//    gifEncoder.encode();
//  }
//
//  private static BufferedImage createImage(String srcPicData) throws IOException {
//    byte[] srcByteArray = decoder.decodeBuffer(srcPicData);
//    ByteArrayInputStream srcIn = new ByteArrayInputStream(srcByteArray);
//    BufferedImage srcImg = ImageIO.read(srcIn);
//    return srcImg;
//  }
//
//  private static BufferedImage toFixBackground(BufferedImage srcImage) throws IOException {
//    BufferedImage destImage = new BufferedImage(srcImage.getWidth(), srcImage.getHeight(), 1);
//    Graphics g = destImage.createGraphics();
//    g.setColor(new Color(255, 255, 255));
//    g.fillRect(0, 0, srcImage.getWidth(), srcImage.getHeight());
//    g.drawImage(srcImage, 0, 0, null);
//    g.dispose();
//    return destImage;
//  }

}
