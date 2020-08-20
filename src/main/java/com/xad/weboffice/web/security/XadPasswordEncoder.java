package com.xad.weboffice.web.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.*;
import org.springframework.security.crypto.scrypt.SCryptPasswordEncoder;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2020/8/19.
 */
public class XadPasswordEncoder {

    private static  PasswordEncoder passwordEncoder;

    public static void init(){
        String idForEncode = "wocainipojiebuchulai";
        Map encoders = new HashMap<>();
        encoders.put(idForEncode, new BCryptPasswordEncoder());
        encoders.put("noop", NoOpPasswordEncoder.getInstance());
        encoders.put("pbkdf2", new Pbkdf2PasswordEncoder());
        encoders.put("scrypt", new SCryptPasswordEncoder());
        encoders.put("sha256", new StandardPasswordEncoder());
         passwordEncoder =
                new DelegatingPasswordEncoder(idForEncode, encoders);
    }
    static{
        init();
    }


    public static void main(String[] args){
        String psd = passwordEncoder.encode("caonima");
        System.out.println(psd);
        String psd2 = passwordEncoder.encode("caonima");
        boolean ret = passwordEncoder.matches("caonima",psd2);
        System.out.println(ret);

    }
}
