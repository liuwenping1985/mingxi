package com.seeyon.ctp.common.encrypt;

import java.io.InputStream;
import java.io.PipedOutputStream;

public class PipeHandle implements Runnable {

	private PipedOutputStream out;
	private InputStream in;
	
	public PipeHandle(InputStream in,PipedOutputStream out) {
		this.in = in;
		this.out = out;
	}

	public void run() {
		if(out != null) {
			try {
				CoderFactory.getInstance().download(in, out);
			}catch(Exception e) {
				
			}
		}
	}
}
