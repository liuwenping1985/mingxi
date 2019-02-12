package com.seeyon.ctp.common.office;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import DBstep.iMsgServer2000;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.util.json.JSONUtil;

public class MSignatureManagerImpl implements MSignatureManager {
    public static final String C_sSignatureParamKey_SummaryID = "summaryID";
    public static final String C_sSignatureParamKey_RecordID = "RECORDID";
    public static final String C_sSignatureParamKey_FieldName = "fieldName";
    public static final String C_sSignatureParamKey_UserName = "currentOrgName";
    public static final String C_sSignatureParamKey_FieldValue = "fieldValue";
    public static final String C_sSignatureParamKey_Status = "STATUS";
    public static final String C_sSignatureParamKey_RowID = "ROWID";
    public static final String C_sSignatureParamKey_Width = "WIDTH";
    public static final String C_sSignatureParamKey_Height = "HEIGHT";
    public static final String C_sSignatureParamKey_MarkName = "MARKNAME";
    public static final String C_sSignatureParamKey_ClientIP = "CLIENTIP";
    public static final String C_sSignatureParamKey_MarkGUID = "MARKGUID";
    public static final String C_sSignatureParamKey_HostName = "HOSTNAME";
    
    public HtmlHandWriteManager htmlHandWriteManager;
    
    @SuppressWarnings("unchecked")
    @Override
    public boolean transSaveSignatureAndHistory(String paramStr,String affairId,String isNewImg) throws BusinessException {
        HttpServletRequest request = AppContext.getRawRequest();
        if(paramStr != null) {
            List<Map<String, String>> paramMapperList = (List<Map<String, String>>)JSONUtil.parseJSONString(paramStr);
            for(Map<String, String> paramMapper : paramMapperList) {
                String recordID = paramMapper.get(C_sSignatureParamKey_SummaryID);
                String fieldName = paramMapper.get(C_sSignatureParamKey_FieldName);
                User user = AppContext.getCurrentUser();
                //String userName = paramMapper.get(C_sSignatureParamKey_UserName);
                String fieldValue = "";
                try {
                    fieldValue = MSignaturePicHandler.encodeSignatureDataForJINGE(paramMapper.get(C_sSignatureParamKey_FieldValue));
                } catch (IOException e) {
                    throw new BusinessException("transSaveSignatureAndHistory-->",e);
                }
                
                iMsgServer2000 msgObj = new iMsgServer2000();
                msgObj.SetMsgByName(C_sSignatureParamKey_RecordID, recordID);
                msgObj.SetMsgByName("AFFAIRID", affairId);
                msgObj.SetMsgByName("FIELDNAME", fieldName);
                msgObj.SetMsgByName("FIELDVALUE", fieldValue);
                msgObj.SetMsgByName("USERNAME", user.getName());
                msgObj.SetMsgByName(C_sSignatureParamKey_ClientIP, request.getRemoteAddr());
                String markGUID = "{" + UUID.randomUUID() + "}";
                msgObj.SetMsgByName(C_sSignatureParamKey_MarkGUID, markGUID);
                msgObj.SetMsgByName("isNewImg", isNewImg);
                htmlHandWriteManager.saveSignature(msgObj);
                
                msgObj.MsgTextClear();
                msgObj.SetMsgByName(C_sSignatureParamKey_RecordID, recordID);
                msgObj.SetMsgByName(C_sSignatureParamKey_FieldName, fieldName);
                msgObj.SetMsgByName(C_sSignatureParamKey_UserName, user.getName());
                msgObj.SetMsgByName(C_sSignatureParamKey_MarkName, "");
                msgObj.SetMsgByName(C_sSignatureParamKey_MarkGUID, markGUID);
                msgObj.SetMsgByName(C_sSignatureParamKey_ClientIP, request.getLocalAddr());
                htmlHandWriteManager.saveSignatureHistory(msgObj);
            }
        }
        
        return true;
    }

    public HtmlHandWriteManager getHtmlHandWriteManager() {
        return htmlHandWriteManager;
    }

    public void setHtmlHandWriteManager(HtmlHandWriteManager htmlHandWriteManager) {
        this.htmlHandWriteManager = htmlHandWriteManager;
    }
}
