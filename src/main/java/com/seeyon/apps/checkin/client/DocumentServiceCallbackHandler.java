
/**
 * DocumentServiceCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 13, 2008 (05:03:35 LKT)
 */

    package com.seeyon.apps.checkin.client;

    /**
     *  DocumentServiceCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class DocumentServiceCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public DocumentServiceCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public DocumentServiceCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for exportRecentNews method
            * override this method for handling normal response from exportRecentNews operation
            */
           public void receiveResultexportRecentNews(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportRecentNewsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportRecentNews operation
           */
            public void receiveErrorexportRecentNews(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportOfflineFormModel method
            * override this method for handling normal response from exportOfflineFormModel operation
            */
           public void receiveResultexportOfflineFormModel(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportOfflineFormModelResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportOfflineFormModel operation
           */
            public void receiveErrorexportOfflineFormModel(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for updateEdocState method
            * override this method for handling normal response from updateEdocState operation
            */
           public void receiveResultupdateEdocState(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.UpdateEdocStateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from updateEdocState operation
           */
            public void receiveErrorupdateEdocState(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportRecentAccountBulletinByAccountId method
            * override this method for handling normal response from exportRecentAccountBulletinByAccountId operation
            */
           public void receiveResultexportRecentAccountBulletinByAccountId(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportRecentAccountBulletinByAccountIdResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportRecentAccountBulletinByAccountId operation
           */
            public void receiveErrorexportRecentAccountBulletinByAccountId(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportGroupNews method
            * override this method for handling normal response from exportGroupNews operation
            */
           public void receiveResultexportGroupNews(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportGroupNewsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportGroupNews operation
           */
            public void receiveErrorexportGroupNews(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for processEdocSend method
            * override this method for handling normal response from processEdocSend operation
            */
           public void receiveResultprocessEdocSend(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ProcessEdocSendResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from processEdocSend operation
           */
            public void receiveErrorprocessEdocSend(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for processEdocReceive method
            * override this method for handling normal response from processEdocReceive operation
            */
           public void receiveResultprocessEdocReceive(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ProcessEdocReceiveResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from processEdocReceive operation
           */
            public void receiveErrorprocessEdocReceive(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportNews method
            * override this method for handling normal response from exportNews operation
            */
           public void receiveResultexportNews(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportNewsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportNews operation
           */
            public void receiveErrorexportNews(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportFlow2 method
            * override this method for handling normal response from exportFlow2 operation
            */
           public void receiveResultexportFlow2(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportFlow2Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportFlow2 operation
           */
            public void receiveErrorexportFlow2(java.lang.Exception e) {
            }
                
               // No methods generated for meps other than in-out
                
           /**
            * auto generated Axis2 call back method for exportBulletin method
            * override this method for handling normal response from exportBulletin operation
            */
           public void receiveResultexportBulletin(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportBulletinResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportBulletin operation
           */
            public void receiveErrorexportBulletin(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportResearch method
            * override this method for handling normal response from exportResearch operation
            */
           public void receiveResultexportResearch(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportResearchResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportResearch operation
           */
            public void receiveErrorexportResearch(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for importEdoc method
            * override this method for handling normal response from importEdoc operation
            */
           public void receiveResultimportEdoc(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ImportEdocResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from importEdoc operation
           */
            public void receiveErrorimportEdoc(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportGroupBulletin method
            * override this method for handling normal response from exportGroupBulletin operation
            */
           public void receiveResultexportGroupBulletin(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportGroupBulletinResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportGroupBulletin operation
           */
            public void receiveErrorexportGroupBulletin(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportRecentAccountBulletin method
            * override this method for handling normal response from exportRecentAccountBulletin operation
            */
           public void receiveResultexportRecentAccountBulletin(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportRecentAccountBulletinResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportRecentAccountBulletin operation
           */
            public void receiveErrorexportRecentAccountBulletin(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportBbs method
            * override this method for handling normal response from exportBbs operation
            */
           public void receiveResultexportBbs(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportBbsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportBbs operation
           */
            public void receiveErrorexportBbs(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportFlow method
            * override this method for handling normal response from exportFlow operation
            */
           public void receiveResultexportFlow(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportFlowResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportFlow operation
           */
            public void receiveErrorexportFlow(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportEdoc method
            * override this method for handling normal response from exportEdoc operation
            */
           public void receiveResultexportEdoc(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportEdocResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportEdoc operation
           */
            public void receiveErrorexportEdoc(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for exportBulletinByDateTime method
            * override this method for handling normal response from exportBulletinByDateTime operation
            */
           public void receiveResultexportBulletinByDateTime(
                    com.seeyon.apps.checkin.client.DocumentServiceStub.ExportBulletinByDateTimeResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from exportBulletinByDateTime operation
           */
            public void receiveErrorexportBulletinByDateTime(java.lang.Exception e) {
            }
                


    }
    