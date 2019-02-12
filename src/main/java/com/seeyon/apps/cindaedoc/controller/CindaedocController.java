package com.seeyon.apps.cindaedoc.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.cindaedoc.manager.CindaedocManager;
import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.exchange.dao.EdocSendDetailDao;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;

public class CindaedocController extends BaseController {
	
	private CindaedocManager cindaedocManager;
	
	public void setEdocSendDetailDao(EdocSendDetailDao edocSendDetailDao) {
		this.edocSendDetailDao = edocSendDetailDao;
	}

	private EdocSendDetailDao edocSendDetailDao;
	
	public void setCindaedocManager(CindaedocManager cindaedocManager) {
		this.cindaedocManager = cindaedocManager;
	}

	@NeedlessCheckLogin
	public ModelAndView recFlag(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 读取消息
		String msg = receiveMsg(request);
		if (msg == null || msg.indexOf("TYPE") == -1) {// 无效消息，不进行处理
			response.getOutputStream().write("error=no type".getBytes());
			return null;
		}

		// 回执消息格式：TYPE=FLAG;{XXXXX=OK,XXXXX=REDO,XXX=ER}
		// 返回：TYPE=FLAG;MSGID={XXXX,XXXX,XXX};
		String[] arr = msg.split(";");
		String type = arr[0].split("=")[1].trim();

		if (type.equals("FLAG")) {// 接收回执
			String ids = arr[1].substring(1, arr[1].length() - 1);
			String[] msgInfos = ids.split(",");
			String tmp = "";
			for (int i = 0; i < msgInfos.length; i++) {
				String info = msgInfos[i];
				String key = info.split("=")[0];
				String value = info.split("=")[1];
				EdocDetailMsgid edm = cindaedocManager.getDetailIdByMsgId(key);
				if (edm != null) {
					EdocSendDetail esd =  edocSendDetailDao.get(edm.getDetailId());
					tmp += "," + key;
					if ("OK".equals(value)) {// 回执成功
						esd.setContent("签收成功");
						esd.setRecUserName("公文管理员");
						esd.setRecTime(new java.sql.Timestamp(new Date().getTime()));
						esd.setStatus(EdocSendDetail.Exchange_iStatus_SendDetail_Recieved);
					}
					if (!"OK".equals(value)) {
						esd.setContent("签收失败");
					}
					edocSendDetailDao.update(esd);
				}
			}
			if (tmp.length() > 1) {
				tmp = tmp.substring(1);
			}
			String ret = "TYPE=FLAG;MSGID={" + tmp + "}";
			response.getOutputStream().write(ret.getBytes());
		}
		return null;
	}
	
	private String receiveMsg(HttpServletRequest request) throws IOException {
		InputStreamReader bsr = null;
		BufferedReader br = null;

		StringBuffer buffer = new StringBuffer();
		try {
			bsr = new InputStreamReader(request.getInputStream());
			br = new BufferedReader(bsr);

			String valueLine = null;
			while ((valueLine = br.readLine()) != null) {
				buffer.append(valueLine);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new IOException(ex);
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (Exception ex) {
				}
			}
			if (bsr != null) {
				try {
					bsr.close();
				} catch (Exception ex) {
				}
			}
		}
		return buffer.toString();
	}
}