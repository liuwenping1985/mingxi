package com.seeyon.apps.kdXdtzXc.constant;

/**
 * Created by tap-pcng43 on 2017-6-13.
 */
public enum  StateEnumExt {
    edoc_init(2),
    meeting_init(2),

    meeting_send(3),
    meeting_sended(4),
    meeting_feedback(10),
    meetingroom_send(3),
    meetingroom_sended(4);

    private int key;

    private StateEnumExt(int key) {
        this.key = key;
    }

    public int getKey() {
        return this.key;
    }

    public int key() {
        return this.key;
    }

    public static StateEnumExt valueOf(int key) {
        StateEnumExt[] enums = values();
        if(enums != null) {
            StateEnumExt[] var5 = enums;
            int var4 = enums.length;

            for(int var3 = 0; var3 < var4; ++var3) {
                StateEnumExt enum1 = var5[var3];
                if(enum1.getKey() == key) {
                    return enum1;
                }
            }
        }

        return null;
    }
}
