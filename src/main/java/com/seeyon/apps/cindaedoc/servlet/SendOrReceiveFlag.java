package com.seeyon.apps.cindaedoc.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.cindaedoc.manager.CindaedocManager;
import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.v3x.exchange.dao.EdocSendDetailDao;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;

@WebServlet(name="SendOrReceiveFlagForEdoc",urlPatterns="/exchange/receiveEdocMessage")
public class SendOrReceiveFlag extends HttpServlet {

	private static final long serialVersionUID = 9059485961901359574L;

	private static Log log = LogFactory.getLog(SendOrReceiveFlag.class);

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 读取消息
		String msg = receiveMsg(request);
		log.info("接收到平台消息：" + msg);
		if (msg == null || msg.indexOf("TYPE") == -1) {// 无效消息，不进行处理
			response.getOutputStream().write("error=no type".getBytes());
			return;
		}

		// 数据消息格式：TYPE=FILE;MSGID={XXXX,XXXX,XXX};
		// 返回：TYPE=FILE;MSG=OK
		// 回执消息格式：TYPE=FLAG;{XXXXX=OK,XXXXX=REDO,XXX=ER}
		// 返回：TYPE=FLAG;MSGID={XXXX,XXXX,XXX};
		String[] arr = msg.split(";");
		String type = arr[0].split("=")[1].trim();

		CindaedocManager cindaedocManager = (CindaedocManager) AppContext.getBean("cindaedocManager");
		EdocSendDetailDao edocSendDetailDao = (EdocSendDetailDao) AppContext.getBean("edocSendDetailDao");

		if ("FLAG".equals(type)) {// 接收回执
			String ids = arr[1].substring(1, arr[1].length() - 1);
			String[] msgInfos = ids.split(",");
			String tmp = "";
			for (int i = 0; i < msgInfos.length; i++) {
				String info = msgInfos[i];
				String key = info.split("=")[0];
				String value = info.split("=")[1];
				EdocDetailMsgid edm = cindaedocManager.getDetailIdByMsgId(key);
				if (edm != null) {
					EdocSendDetail esd = edocSendDetailDao.get(edm.getDetailId());
					tmp += "," + key;
					if ("OK".equals(value)) {// 回执成功
						esd.setContent("签收成功");
						esd.setStatus(EdocSendDetail.Exchange_iStatus_SendDetail_Recieved);
						esd.setRecUserName("公文管理员");
						esd.setRecTime(new java.sql.Timestamp(new Date().getTime()));
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
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
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
			log.error("平台信息读取失败：", ex);
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