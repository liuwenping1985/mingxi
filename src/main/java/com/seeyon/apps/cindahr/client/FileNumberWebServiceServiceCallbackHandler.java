
/**
 * FileNumberWebServiceServiceCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 13, 2008 (05:03:35 LKT)
 */

    package com.seeyon.apps.cindahr.client;

    /**
     *  FileNumberWebServiceServiceCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class FileNumberWebServiceServiceCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public FileNumberWebServiceServiceCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public FileNumberWebServiceServiceCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for deleteFileNumberInfoTemp method
            * override this method for handling normal response from deleteFileNumberInfoTemp operation
            */
           public void receiveResultdeleteFileNumberInfoTemp(
                    com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.DeleteFileNumberInfoTempResponseE result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from deleteFileNumberInfoTemp operation
           */
            public void receiveErrordeleteFileNumberInfoTemp(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for syncFileNumberInfoStatus method
            * override this method for handling normal response from syncFileNumberInfoStatus operation
            */
           public void receiveResultsyncFileNumberInfoStatus(
                    com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.SyncFileNumberInfoStatusResponseE result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from syncFileNumberInfoStatus operation
           */
            public void receiveErrorsyncFileNumberInfoStatus(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for syncFileNumberInfo method
            * override this method for handling normal response from syncFileNumberInfo operation
            */
           public void receiveResultsyncFileNumberInfo(
                    com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.SyncFileNumberInfoResponseE result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from syncFileNumberInfo operation
           */
            public void receiveErrorsyncFileNumberInfo(java.lang.Exception e) {
            }
                


    }
    