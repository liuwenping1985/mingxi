package com.seeyon.apps.docexport.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import www.seeyon.com.utils.FileUtil;

import cn.com.hkgt.cinda.external.GeArchiveFactory;
import cn.com.hkgt.cinda.interfaces.AffixObj;
import cn.com.hkgt.cinda.interfaces.AppParameter;
import cn.com.hkgt.cinda.interfaces.ArchiveObj;
import cn.com.hkgt.cinda.interfaces.ArchiveService;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.dev.doc.dao.CindaUserDao;
import com.seeyon.apps.dev.doc.exception.ExportDocException;
import com.seeyon.apps.dev.doc.utils.DocFileInfo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.domain.EdocSummary;

public class DocExportUtils {

	private static final Log log = LogFactory.getLog(DocExportUtils.class);
	private static final String appNumber = SystemProperties.getInstance().getProperty("exportdoc.archive.appNumber", "3");////应用系统代码 :3	公文流转系统 
	public static final String serviceUrl = SystemProperties.getInstance().getProperty("exportdoc.archive.serverAddress");
	private static CindaUserDao cindaUserDao = (CindaUserDao) AppContext.getBean("cindaUserDao");
	private static GuidMapper guidMapper = (GuidMapper) AppContext.getBean("guidMapper");
	public static ArchiveObj transToArchiveObj (EdocSummary summary , byte[] wendanInfoBytes,List<AffixObj> affixList) throws ExportDocException{
		
		//下面是相关的档案数据了
		ArchiveObj arch = new ArchiveObj();
		arch.setArchiveTypeOne("1");//档案类型
			V3xOrgMember member = null;
			try {
				member = OrgHelper.getOrgManager().getMemberById(summary.getStartUserId());
			} catch (BusinessException e) {
				throw new ExportDocException(summary.getSubject()+"获取发起人出错，不能归档到档案系统！",e);
			}
			String sendDeptId = summary.getSendDepartmentId()==null?summary.getSendDepartmentId2():summary.getSendDepartmentId();
			V3xOrgEntity dept = null;
			try {
				dept =  OrgHelper.getOrgManager().getEntity(sendDeptId);
			} catch (BusinessException e) {
				throw new ExportDocException(summary.getSubject()+"获取部门出错，不能归档到档案系统！",e);
			}
			arch.setCreateUserId(member.getLoginName());
			arch.setFileSrcDept(dept.getName());
			//6位机构编号，如技术部的为015900，北京分公司为110000
			//String orgname =  Strings.isBlank(summary.getSendTo())?summary.getSendTo2():summary.getSendTo();
			String orgname = dept.getName();
			String xdOrgid = cindaUserDao.getOrgByName(orgname).getOrganizationcode();
			log.info("查询"+orgname+"在信达系统中心中的编码=="+xdOrgid);
			if(Strings.isBlank(xdOrgid)){
				try {
					V3xOrgEntity acc = OrgHelper.getOrgManager().getAccountById(dept.getOrgAccountId());
					orgname = acc.getName();
					xdOrgid = cindaUserDao.getOrgByName(orgname).getOrganizationcode();
					log.info("查询"+orgname+"在信达系统中心中的编码=="+xdOrgid);
				} catch (BusinessException e) {
					e.printStackTrace();
					throw new ExportDocException(summary.getSubject()+"获取一级机构出错，不能归档到档案系统！",e);
				}
			}
			if(Strings.isBlank(xdOrgid)){
				throw new ExportDocException(summary.getSubject()+"获取发文部门编码错，【"+orgname+"】在系统中没有找到编码，不能归档到档案系统！");
			}
			arch.setMngOrgOne(xdOrgid);	//一级机构 Id 必填
			arch.setMngOrgOneName(orgname);//	一级机构名称	必填
		
			//用户或单位，通常与公章名匹配，如总裁办公室，综合管理部等
			arch.setCharger(orgname);//	责任者	必填
		//文件提供单位
		
		
		arch.setArchiveTypeOne("1");//	一级档案类型	必填
		
		
		//arch.setIsoCode("");//	档号，默认为空，联审委档案值为 L	可选项
		
		arch.setPrjTitle(summary.getSubject());//	标题	必填	
		arch.setPrjDate(Datetimes.format((summary.getCompleteTime()==null?summary.getStartTime():summary.getCompleteTime()), "yyyy-MM-dd"));//	文件日期	必填
		arch.setCreateDate(Datetimes.format(summary.getStartTime(), "yyyy-MM-dd"));//	创建日期	必填
		arch.setFileId(summary.getId()+"");//	文件 ID	可选项
		
		String no_ = Strings.isBlank(summary.getDocMark())?(Strings.isBlank(summary.getDocMark2())?summary.getSerialNo():summary.getDocMark2()):summary.getDocMark();
		arch.setFileNo(no_);//	文件号	可选项
		
		arch.setFileType("A");//	取值为 A/B，其中，A:对外公开档案;B: 内部查看档案 	必填
		arch.setSecrecyLevel("6");//	密级，默认为 6	必填
		
		arch.setPaperNo(no_);//	纸质档案编号	可选项
		arch.setPageNum(1);//	文件页数	必填
		arch.setFileExtension("pdf");//	文件扩展名	必填
		arch.setSortSource("1");//	取值为 1	必填
		arch.setDocState("00");//	文档标识，00:本地上传(存于 WorkSiteMP 中);02:在线生成，存于/docstore 目录 下 04:存于分公司服务器	必填
		
		//咨询文档返回不需要赋值 的字段
//		arch.setRemark1("");//	备注	可选项//备注 发文 or 收文  
//		arch.setFilePath("");	//共享存储中路径 必填     
//		arch.setFilePathRaw("");//	文件在应用端原始路径(包含文件名)	必填
//		arch.setClientNo("");//	客户编号	必填
//		arch.setPrjName("");//	案卷名称	必填
		log.info("生成归档公文信息=="+JSONObject.toJSONString(arch));
		arch.setFileInfoBytes(wendanInfoBytes);//	字节流数组	必填
		arch.setAffixList(affixList); //附件列表		可选项
		
		
		return arch;
	}
	/**
	 * 生成单个的附件文件
	 * @param fileInfo
	 * @return
	 * @throws ExportDocException
	 */
	public static AffixObj convertToAffixObj(DocFileInfo fileInfo) throws ExportDocException{
		AffixObj affixObj = new AffixObj();
		String showname = fileInfo.getFile_title().indexOf(".")==-1?fileInfo.getFile_title()+"."+fileInfo.getFile_suffix():fileInfo.getFile_title();
		affixObj.setAffixTitle(showname);//附件标题
		affixObj.setAffixCode(fileInfo.getId()+"");//附件编号
		affixObj.setFileName(showname);//文件名称
		affixObj.setAffixType(fileInfo.getFile_suffix());//附件类型
		affixObj.setFileExtension(fileInfo.getFile_suffix());//文件扩展名
		log.info("生成附件=="+JSONObject.toJSONString(affixObj));
		if(fileInfo.getFile()!=null){
			try {
				affixObj.setInByte(convertFileToByteArr(new FileInputStream(fileInfo.getFile())));
			} catch (FileNotFoundException e) {
				log.error("获取文件出错",e);
			}//附件文件字节流数组
		}else if(fileInfo.getFile_InputStream()!=null){
			affixObj.setInByte(convertFileToByteArr(fileInfo.getFile_InputStream()));//附件文件字节流数组
		}
		return affixObj;
		
	}
	/**
	 * 华科产生byte[]的方法copy自华科中的部分代码封装
	 * @param inputFile
	 * @return
	 */
	public static byte[] convertFileToByteArr(InputStream fileinput) throws ExportDocException{
		try {
			int len=fileinput.available();
			byte[]  affix_data=new byte[len];
			fileinput.read(affix_data);
			fileinput.close();
			return affix_data;
		} catch (Exception e) {
			throw new ExportDocException("获取文件字节数组出错！",e);
		}
	}
	public static byte[] convertFileToByteArr(File file) throws ExportDocException{
		try {
			InputStream affix_fio =new FileInputStream(file);
			int len=affix_fio.available();
			byte[]  affix_data=new byte[len];
			affix_fio.read(affix_data);
			affix_fio.close();
			return affix_data;
		} catch (Exception e) {
			throw new ExportDocException("获取文件字节数组出错！",e);
		}
	}
	public static byte[] convertFileToByteArr(String pathname) throws ExportDocException{

		try {
			InputStream affix_fio = new FileInputStream(pathname);
			int len=affix_fio.available();
			byte[]  affix_data=new byte[len];
			affix_fio.read(affix_data);
			affix_fio.close();
			return affix_data;
		} catch (Exception e) {
			throw new ExportDocException("获取文件字节数组出错！",e);
		}
	}
	/**
	 * 
	 * http://portal02.zc.cinda.ccb/archivegeWeb/geArchiveService
	 * 主归档方法
	 * @param arcList
	 * @return
	 */
	public static Boolean archiveFile(List<ArchiveObj> arcList ,String serverAddr,String userId,String ownerIp)throws ExportDocException{
		//相关的固定参数
		log.info("信达当前推送接口地址为："+serverAddr);
		AppParameter param = new AppParameter();
		param.setAppNumber(appNumber);//应用系统代码 :3	公文流转系统
		param.setIp(ownerIp); //调用者 ip 地址
		param.setUserId(userId);//调用者 Id
		log.info("AppParameter="+JSONObject.toJSONString(param));
		GeArchiveFactory factory = new GeArchiveFactory();
		try {
			ArchiveService geArchive = factory.createArchiveService(serverAddr);
			List results = geArchive.submitCommonArchive(arcList, param);
			InputStream in = new ByteArrayInputStream(JSONObject.toJSONString(results).getBytes());
			String fileName= getTempFilepath("archLog")+"/"+Datetimes.format(new Date(), "yyyyMMddHHmmss")+"_"+arcList.get(0).getFileId()+".json";
			FileUtil.write(in, new FileOutputStream(fileName));
			log.info("调用归档接口返回信息见："+fileName);
			if(results!=null && results.size()>0){
				return true;
			}
		} catch (Exception e) {
			log.error("调用信达归档接口失败",e);
			throw new ExportDocException("调用信达归档接口失败",e);
		}
		return false;
	}
	private static String getTempFilepath(String path){
		String temppath = SystemEnvironment.getBaseFolder()+File.separator+"exportedoc"+File.separator+path+File.separator;
		File file = new File(temppath);
    	File filePath = new File(temppath);
        if (!filePath.exists()) {  
            filePath.mkdirs();  
        }
        log.info("exportedoc Temp path:"+file.getAbsolutePath());
		return file.getAbsolutePath();  
	}
	/**
	 * @param args
	 * @throws ExportDocException 
	 */
	public static void main(String[] args) throws ExportDocException {
		ArchiveObj arch = JSONObject.parseObject(FileUtil.readTextFile("/Users/mac/Desktop/acrh.json", "utf-8"),ArchiveObj.class);
		arch.setFileInfoBytes(convertFileToByteArr("/Users/mac/Downloads/444945580290325579041.pdf"));
		List<AffixObj> listaff = JSONObject.parseArray(FileUtil.readTextFile("/Users/mac/Desktop/attrs.json", "utf-8"),AffixObj.class);
		File files = new File("/Users/mac/Downloads");
		File[] listf = files.listFiles();
		for (AffixObj affixObj : listaff) {
			for (File file : listf) {
				if(file.getName().equalsIgnoreCase(affixObj.getFileName())){
					affixObj.setInByte(convertFileToByteArr(file));
				}
			}
			
		}
		arch.setAffixList(listaff);
		List<ArchiveObj> arcList =new ArrayList<ArchiveObj>();
		arcList.add(arch);
		String server = "http://portal02.zc.cinda.ccb/archivegeWeb/geArchiveService";
		String userid = "jsbfkq";
		String ownerIP = "110.3.3.29";
		archiveFile(arcList,server,userid,ownerIP);// "8a82828c2108e09601210a1f29260177");
		
	}
}
