package cn.com.cinda.taskcenter.util;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;
import org.apache.log4j.Logger;

/**
 * <p>Title: </p>
 *
 * <p>Description: 生成随机数的主键UUID</p>
 *
 * <p>Copyright: Copyright (c) 2007</p>
 *
 * <p>Company: </p>
 *
 * 
 * @version 1.0
 */
public class UUID {
//	生成唯一的主键随机数算法

//	打印错误的日志信息
	private static Logger logger = Logger.getLogger(UUID.class);


	public String valueBeforeMD5 = "";
	public String valueAfterMD5 = "";
	private static Random myRand;
	private static SecureRandom mySecureRand;

	private static String s_id;
	private static final int PAD_BELOW = 0x10;
	private static final int TWO_BYTES = 0xFF;

	/*
	* Static block to take care of one time secureRandom seed.
	* It takes a few seconds to initialize SecureRandom. You might
	* want to consider removing this static block or replacing
	* it with a "time since first loaded" seed to reduce this time.
	* This block will run only once per JVM instance.
	*/

	static {
	mySecureRand = new SecureRandom();
	long secureInitializer = mySecureRand.nextLong();
	myRand = new Random(secureInitializer);
	try {
	s_id = InetAddress.getLocalHost().toString();
	} catch (UnknownHostException e) {
	e.printStackTrace();
	}

	}

	/*
	* Default constructor. With no specification of security option,
	* this constructor defaults to lower security, high performance.
	*/
	public UUID() {
	getUUID(false);
	}

	/*
	* Constructor with security option. Setting secure true
	* enables each random number generated to be cryptographically
	* strong. Secure false defaults to the standard Random function seeded
	* with a single cryptographically strong random number.
	*/
	public UUID(boolean secure) {
	getUUID(secure);
	}

	/*
	* Method to generate the random GUID
	*/
	private void getUUID(boolean secure) {
	MessageDigest md5 = null;
	StringBuffer sbValueBeforeMD5 = new StringBuffer(128);

	try {
	md5 = MessageDigest.getInstance("MD5");
	} catch (NoSuchAlgorithmException e) {
	logger.error("Error: " + e);
	}

	try {
	long time = System.currentTimeMillis();
	long rand = 0;

	if (secure) {
	rand = mySecureRand.nextLong();
	} else {
	rand = myRand.nextLong();
	}
	sbValueBeforeMD5.append(s_id);
	sbValueBeforeMD5.append(":");
	sbValueBeforeMD5.append(Long.toString(time));
	sbValueBeforeMD5.append(":");
	sbValueBeforeMD5.append(Long.toString(rand));

	valueBeforeMD5 = sbValueBeforeMD5.toString();
	md5.update(valueBeforeMD5.getBytes());

	byte[] array = md5.digest();
	StringBuffer sb = new StringBuffer(32);
	for (int j = 0; j < array.length; ++j) {
	int b = array[j] & TWO_BYTES;
	if (b < PAD_BELOW)
	sb.append('0');
	sb.append(Integer.toHexString(b));
	}

	valueAfterMD5 = sb.toString();

	} catch (Exception e) {
	logger.error("Error:" + e);
	}
	}

	/*
	* Convert to the standard format for GUID
	* (Useful for SQL Server UniqueIdentifiers, etc.)
	* Example: C2FEEEAC-CFCD-11D1-8B05-00600806D9B6
	*/
	public String toString() {
	String raw = valueAfterMD5.toUpperCase();
	StringBuffer sb = new StringBuffer(64);
	sb.append(raw.substring(0, 8));
	sb.append("-");
	sb.append(raw.substring(8, 12));
	sb.append("-");
	sb.append(raw.substring(12, 16));
	sb.append("-");
	sb.append(raw.substring(16, 20));
	sb.append("-");
	sb.append(raw.substring(20));

	return sb.toString();
	}

	/*测试用例－－－循环100次（mian方法）
  //	 Demonstraton and self test of class
	public static void main(String args[]) {
	for (int i=0; i< 50; i++) {
		UUID myGUID = new UUID();
	System.out.println("Seeding String=" + myGUID.valueBeforeMD5);
	System.out.println("rawGUID=" + myGUID.valueAfterMD5);
	System.out.println("RandomGUID=" + myGUID.toString());
	}
	}
	
*/
}
