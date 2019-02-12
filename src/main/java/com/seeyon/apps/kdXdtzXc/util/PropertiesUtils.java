package com.seeyon.apps.kdXdtzXc.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtils {
	private static PropertiesUtils instance;

	private static Properties properties;

	private static long filelastmodify = 0;

	private static String PRO_FILE_PATH = "/app.properties";

	public PropertiesUtils() {
		properties = getFromClasspath();
	}

	public static PropertiesUtils getInstance() {
		if (instance == null) {
			instance = new PropertiesUtils();
		} else {
			File file = new File(PropertiesUtils.class.getResource("/").getFile() + PRO_FILE_PATH);
			if (file != null && file.exists()) {
				if (file.lastModified() != PropertiesUtils.filelastmodify) {
					properties = getFromClasspath();
					filelastmodify = file.lastModified();
				}
			}
		}
		return instance;
	}

	public Object get(String key) {
		return properties.get(key);
	}

	private static Properties getFromClasspath() {
		Properties props = new Properties();
		InputStream in = null;
		try {
			in = new FileInputStream(getWebClassPath() + PRO_FILE_PATH);
			if (in != null)
				props.load(in);
		} catch (Exception e) {
			if (in != null)
				try {
					in.close();
				} catch (Exception localException1) {
				}
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception localException2) {
				}
			}
		}
		return props;
	}

	private static String getWebClassPath() {
		File classRootFile = new File(PropertiesUtils.class.getClassLoader().getResource("").getPath());
		return getFileSlashPath(classRootFile.getAbsolutePath());
	}

	private static String getFileSlashPath(String filePath) {
		if (org.apache.commons.lang.StringUtils.isEmpty(filePath))
			return "";
		return filePath.replace("\\", "/").replace("\\\\", "/");
	}

}
