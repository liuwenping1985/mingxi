
/**
 * Cmcc_mas_wbsCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 13, 2008 (05:03:35 LKT)
 */

    package org.csapi.www.service;

    /**
     *  Cmcc_mas_wbsCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class Cmcc_mas_wbsCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public Cmcc_mas_wbsCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public Cmcc_mas_wbsCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for sendPush method
            * override this method for handling normal response from sendPush operation
            */
           public void receiveResultsendPush(
                    org.csapi.www.service.Cmcc_mas_wbsStub.SendPushResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from sendPush operation
           */
            public void receiveErrorsendPush(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APStatusRep method
            * override this method for handling normal response from APStatusRep operation
            */
           public void receiveResultAPStatusRep(
                    org.csapi.www.service.Cmcc_mas_wbsStub.APStatusRepRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APStatusRep operation
           */
            public void receiveErrorAPStatusRep(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getLocationForGroup method
            * override this method for handling normal response from getLocationForGroup operation
            */
           public void receiveResultgetLocationForGroup(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetLocationForGroupResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getLocationForGroup operation
           */
            public void receiveErrorgetLocationForGroup(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for handleUssd method
            * override this method for handling normal response from handleUssd operation
            */
           public void receiveResulthandleUssd(
                    org.csapi.www.service.Cmcc_mas_wbsStub.HandleUssdResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from handleUssd operation
           */
            public void receiveErrorhandleUssd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APLogOut method
            * override this method for handling normal response from APLogOut operation
            */
           public void receiveResultAPLogOut(
                    org.csapi.www.service.Cmcc_mas_wbsStub.APLogOutRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APLogOut operation
           */
            public void receiveErrorAPLogOut(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APRegistration method
            * override this method for handling normal response from APRegistration operation
            */
           public void receiveResultAPRegistration(
                    org.csapi.www.service.Cmcc_mas_wbsStub.APRegistrationRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APRegistration operation
           */
            public void receiveErrorAPRegistration(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for endUssd method
            * override this method for handling normal response from endUssd operation
            */
           public void receiveResultendUssd(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from endUssd operation
           */
            public void receiveErrorendUssd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getReceivedMessages method
            * override this method for handling normal response from getReceivedMessages operation
            */
           public void receiveResultgetReceivedMessages(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetReceivedMessagesResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getReceivedMessages operation
           */
            public void receiveErrorgetReceivedMessages(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifyUssdEnd method
            * override this method for handling normal response from notifyUssdEnd operation
            */
           public void receiveResultnotifyUssdEnd(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifyUssdEnd operation
           */
            public void receiveErrornotifyUssdEnd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getLocation method
            * override this method for handling normal response from getLocation operation
            */
           public void receiveResultgetLocation(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetLocationResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getLocation operation
           */
            public void receiveErrorgetLocation(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for sendSms method
            * override this method for handling normal response from sendSms operation
            */
           public void receiveResultsendSms(
                    org.csapi.www.service.Cmcc_mas_wbsStub.SendSmsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from sendSms operation
           */
            public void receiveErrorsendSms(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for GetReceivedSms method
            * override this method for handling normal response from GetReceivedSms operation
            */
           public void receiveResultGetReceivedSms(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetReceivedSmsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from GetReceivedSms operation
           */
            public void receiveErrorGetReceivedSms(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifySmsDeliveryStatus method
            * override this method for handling normal response from notifySmsDeliveryStatus operation
            */
           public void receiveResultnotifySmsDeliveryStatus(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifySmsDeliveryStatus operation
           */
            public void receiveErrornotifySmsDeliveryStatus(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APSvcAuthentic method
            * override this method for handling normal response from APSvcAuthentic operation
            */
           public void receiveResultAPSvcAuthentic(
                    org.csapi.www.service.Cmcc_mas_wbsStub.APSvcAuthenticRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APSvcAuthentic operation
           */
            public void receiveErrorAPSvcAuthentic(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifySmsReception method
            * override this method for handling normal response from notifySmsReception operation
            */
           public void receiveResultnotifySmsReception(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifySmsReception operation
           */
            public void receiveErrornotifySmsReception(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for stopNotification method
            * override this method for handling normal response from stopNotification operation
            */
           public void receiveResultstopNotification(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from stopNotification operation
           */
            public void receiveErrorstopNotification(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for EndNotification method
            * override this method for handling normal response from EndNotification operation
            */
           public void receiveResultEndNotification(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from EndNotification operation
           */
            public void receiveErrorEndNotification(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for startNotification method
            * override this method for handling normal response from startNotification operation
            */
           public void receiveResultstartNotification(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from startNotification operation
           */
            public void receiveErrorstartNotification(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APSvcAlarm method
            * override this method for handling normal response from APSvcAlarm operation
            */
           public void receiveResultAPSvcAlarm(
                    org.csapi.www.service.Cmcc_mas_wbsStub.AlarmRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APSvcAlarm operation
           */
            public void receiveErrorAPSvcAlarm(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifyMessageReception method
            * override this method for handling normal response from notifyMessageReception operation
            */
           public void receiveResultnotifyMessageReception(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifyMessageReception operation
           */
            public void receiveErrornotifyMessageReception(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for sendMessage method
            * override this method for handling normal response from sendMessage operation
            */
           public void receiveResultsendMessage(
                    org.csapi.www.service.Cmcc_mas_wbsStub.SendMessageResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from sendMessage operation
           */
            public void receiveErrorsendMessage(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APSvcPerfReport method
            * override this method for handling normal response from APSvcPerfReport operation
            */
           public void receiveResultAPSvcPerfReport(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APSvcPerfReport operation
           */
            public void receiveErrorAPSvcPerfReport(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getPushDeliveryStatus method
            * override this method for handling normal response from getPushDeliveryStatus operation
            */
           public void receiveResultgetPushDeliveryStatus(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetPushDeliveryStatusResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getPushDeliveryStatus operation
           */
            public void receiveErrorgetPushDeliveryStatus(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifyMessageDeliveryReceipt method
            * override this method for handling normal response from notifyMessageDeliveryReceipt operation
            */
           public void receiveResultnotifyMessageDeliveryReceipt(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifyMessageDeliveryReceipt operation
           */
            public void receiveErrornotifyMessageDeliveryReceipt(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for notifyPushDeliveryReceipt method
            * override this method for handling normal response from notifyPushDeliveryReceipt operation
            */
           public void receiveResultnotifyPushDeliveryReceipt(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from notifyPushDeliveryReceipt operation
           */
            public void receiveErrornotifyPushDeliveryReceipt(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for LocationError method
            * override this method for handling normal response from LocationError operation
            */
           public void receiveResultLocationError(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from LocationError operation
           */
            public void receiveErrorLocationError(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for makeUssd method
            * override this method for handling normal response from makeUssd operation
            */
           public void receiveResultmakeUssd(
                    org.csapi.www.service.Cmcc_mas_wbsStub.MakeUssdResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from makeUssd operation
           */
            public void receiveErrormakeUssd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for APSvcPerfCmd method
            * override this method for handling normal response from APSvcPerfCmd operation
            */
           public void receiveResultAPSvcPerfCmd(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from APSvcPerfCmd operation
           */
            public void receiveErrorAPSvcPerfCmd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getMessageDeliveryStatus method
            * override this method for handling normal response from getMessageDeliveryStatus operation
            */
           public void receiveResultgetMessageDeliveryStatus(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetMessageDeliveryStatusResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getMessageDeliveryStatus operation
           */
            public void receiveErrorgetMessageDeliveryStatus(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for LocationEnd method
            * override this method for handling normal response from LocationEnd operation
            */
           public void receiveResultLocationEnd(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from LocationEnd operation
           */
            public void receiveErrorLocationEnd(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for GetSmsDeliveryStatus method
            * override this method for handling normal response from GetSmsDeliveryStatus operation
            */
           public void receiveResultGetSmsDeliveryStatus(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetSmsDeliveryStatusResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from GetSmsDeliveryStatus operation
           */
            public void receiveErrorGetSmsDeliveryStatus(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for RecoveryAP method
            * override this method for handling normal response from RecoveryAP operation
            */
           public void receiveResultRecoveryAP(
                    org.csapi.www.service.Cmcc_mas_wbsStub.RecoveryAPRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from RecoveryAP operation
           */
            public void receiveErrorRecoveryAP(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for PauseAP method
            * override this method for handling normal response from PauseAP operation
            */
           public void receiveResultPauseAP(
                    org.csapi.www.service.Cmcc_mas_wbsStub.PauseAPRsp result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from PauseAP operation
           */
            public void receiveErrorPauseAP(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getMessage method
            * override this method for handling normal response from getMessage operation
            */
           public void receiveResultgetMessage(
                    org.csapi.www.service.Cmcc_mas_wbsStub.GetMessageResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getMessage operation
           */
            public void receiveErrorgetMessage(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for ussdContinue method
            * override this method for handling normal response from ussdContinue operation
            */
           public void receiveResultussdContinue(
                    org.csapi.www.service.Cmcc_mas_wbsStub.UssdContinueResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from ussdContinue operation
           */
            public void receiveErrorussdContinue(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for startPeriodicNotification method
            * override this method for handling normal response from startPeriodicNotification operation
            */
           public void receiveResultstartPeriodicNotification(
                    org.csapi.www.service.Cmcc_mas_wbsStub.StartPeriodicNotificationResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from startPeriodicNotification operation
           */
            public void receiveErrorstartPeriodicNotification(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for LocationNotification method
            * override this method for handling normal response from LocationNotification operation
            */
           public void receiveResultLocationNotification(
                    ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from LocationNotification operation
           */
            public void receiveErrorLocationNotification(java.lang.Exception e) {
            }
                


    }
    