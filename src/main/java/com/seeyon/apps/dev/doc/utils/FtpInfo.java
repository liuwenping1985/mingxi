package com.seeyon.apps.dev.doc.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.dev.doc.constant.DevConstant;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.Strings;

@SuppressWarnings("serial")
public class FtpInfo extends DocFileInfo{
	public FtpInfo() {
		super();
	}
	public FtpInfo(Long id ,String ftp_path, File local_file, String docId,
			String file_title, String fileType) throws Exception {
		super(id, ftp_path, local_file, docId, file_title, fileType);

	}
	public FtpInfo(Long id , String ftp_path, InputStream file_in, Long file_size,String file_fullName,
			String docId, String file_title, String fileType) {
		super(id, ftp_path, file_in, file_size, file_fullName, docId, file_title, fileType);
	}
	public FtpInfo(Long id , String ftp_path, FileInputStream file_in, String file_fullName,
			String docId, String file_title, String fileType) {
		super(id, ftp_path, file_in, file_fullName, docId, file_title, fileType);
	}
	

}