package com.seeyon.apps.menhu.manager;

import com.seeyon.apps.menhu.vo.UserToken;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

import java.util.*;


/**
 * Created by liuwenping on 2019/1/14.
 */
public final class LoginTokenManager {

    private static Map<String, UserToken> tokenContainer = new HashMap<String, UserToken>();
    private Timer timer = new Timer();

    public static LoginTokenManager getInstance() {

        return Holder.ins;

    }

    private LoginTokenManager() {

        timer.schedule(new CheckThread(), 300 * 1000L, 24 * 3600 * 1000L);
    }

    static class Holder {

        static LoginTokenManager ins = new LoginTokenManager();

    }
    public UserToken createToken(V3xOrgMember member) {

        if (member == null) {
            return null;
        }
        UserToken token = new UserToken();
        String val = UUID.randomUUID().toString();
        String tokenString = val.replaceAll("-", "");
        token.setToken(tokenString);
        token.setValidDate(new Date().getTime() + token.getPeriod());
        token.setUserId(member.getId());
        token.setUserName(member.getName());
        token.setUserLoginName(member.getLoginName());
        tokenContainer.put(tokenString, token);
        return token;
    }
    public UserToken createToken(User user) {

        UserToken token = new UserToken();
        String val = UUID.randomUUID().toString();
        String tokenString = val.replaceAll("-", "");
        token.setToken(tokenString);
        token.setValidDate(new Date().getTime() + token.getPeriod());
        token.setUserId(user.getId());
        token.setUserName(user.getName());
        token.setUserLoginName(user.getLoginName());
        tokenContainer.put(tokenString, token);
        return token;
    }
    public UserToken createToken() {
        User user = AppContext.getCurrentUser();
        if (user == null) {
            return null;
        }
        return createToken(user);
    }

    public UserToken checkToken(String token) {

        UserToken userToken = tokenContainer.remove(token);
        if (userToken != null) {
            if (userToken.isValidToken()) {
                return userToken;
            }
        }
        return null;
    }

    private static class CheckThread extends TimerTask {


        public void run() {

            synchronized (tokenContainer) {
                if (tokenContainer.isEmpty()) {
                    return;
                }
                try {
                    List<String>invalidList = new ArrayList<String>();
                    for (Map.Entry<String, UserToken> token : tokenContainer.entrySet()) {
                        if (token.getValue().isValidToken()) {
                            continue;
                        }
                        invalidList.add(token.getKey());
                    }
                    if(invalidList.isEmpty()){
                        return;
                    }
                    for(String key:invalidList){
                        tokenContainer.remove(key);
                    }
                } catch (Exception e) {

                }


            }


        }
    }

    public static void main(String[] args) {

        String val = "";//LoginTokenManager.getInstance().getToken();

        System.out.println(val);

    }


}
