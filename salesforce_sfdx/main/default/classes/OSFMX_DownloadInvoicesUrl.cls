/**
 * @File Name          : OSFMX_DownloadInvoicesUrl.cls
 * @Description        : Se invoca como remote action desde un IP, para agregar url de descarga a las facturas de un payload. 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    03/03/2021   		    Edgar Maldonado                 Se crea clase original.
 * 1.1	  08/03/2021		    Edgar Maldonado                 Se cambioa URL hacía nuevo sistema de timbrado.
 * 1.2	  14/05/201				Edgar Maldonado					Se permite generar URL para cualquier tipo de documento.
 * 1.3	  21/05/2021			Edgar Maldonado					Se agrega escenario de una sola factura con un solo concepto.
 * 1.4	  08/10/2021			Edgar Maldonado					Se agrega generación de HASH y campos adicionales para Multipagos.
 * 1.5	  15/10/2021			Edgar Maldonado					Se agrega validación HASH de "mp_signature".
**/
global class OSFMX_DownloadInvoicesUrl implements vlocity_cmt.VlocityOpenInterface {
        
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
        if (methodName == 'generateMd5Token')
        {
            System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - RFC: ' + options.get('RFC'));
            String rfcStr = (String)options.get('RFC');
            String baseUrl;
            String UrlToDownloadInvStr;
            String keyMultipagosStr = (String)options.get('PrivateKeyMultipagos');
            String mpReferenceStr;
            Set<String> refFacturaSet = new Set<String>();
            Map<String,OSFMX_360ViewInvoice__c> infoMultipagosByRefFactMap = new Map<String,OSFMX_360ViewInvoice__c>();
            String MpNodeMultipagosStr = (String)options.get('MpNodeMultipagos');
            
            if(Test.isRunningTest()){
                UrlToDownloadInvStr = 'https://pruebaUnitariaSFDC';
            }else{
                List<OSFMX_DevelopmentSettings__mdt> config = [SELECT OSFMX_UrlToDownloadInvoices__c FROM OSFMX_DevelopmentSettings__mdt WHERE DeveloperName='Global'];
                UrlToDownloadInvStr = config[0].OSFMX_UrlToDownloadInvoices__c;
            }
            if(rfcStr!=null){
                baseUrl = UrlToDownloadInvStr;
                System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - billingPayload: ' + options.get('billingPayload'));
                Map<String,Object> payloadMap = (Map<String,Object>)options.get('billingPayload');
                List<Map<String,Object>> facturasList;
                try{
                    facturasList = (List<Map<String,Object>>)payloadMap.get('facturas');
                    mpReferenceStr = (String)payloadMap.get('cuenta_contrato');
                }catch(Exception ex){
                    System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - Exception: ' + ex.getMessage());
                    try{
                     	Map<String,Object> facturaItem = (Map<String,Object>)payloadMap.get('facturas');
                    	facturasList = new List<Map<String,Object>>();
                    	facturasList.add(facturaItem);
                        mpReferenceStr = (String)payloadMap.get('cuenta_contrato');
                    }catch(Exception ex2){
                        System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - Exception 02: ' + ex2.getMessage());
                        System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - Lista Facturas: ' + (List<Object>)payloadMap.get('facturas'));
                    }
                }
                if(facturasList!=null){
                    for(Integer i=0;i<facturasList.size();i++){
                        //if(facturasList.get(i).get('tipo_documento')=='Factura'){
                            //String tmpPdfUrl = baseUrl + '/fe_maxigas/showPDF.jsp?folio='+ facturasList.get(i).get('id_factura') + '&RFC=' + rfcStr;
                            //String tmpZipUrl = baseUrl + '/fe_maxigas/download.jsp?folio='+ facturasList.get(i).get('id_factura') + '&RFC=' + rfcStr;
                            String tmpPdfUrl = baseUrl + '/showPDF.aspx?folio='+ facturasList.get(i).get('id_factura') + '&RFC=' + rfcStr;
                            String tmpZipUrl = baseUrl + '/download.aspx?folio='+ facturasList.get(i).get('id_factura') + '&RFC=' + rfcStr;
                            String tmpTokenPdf = getTokenMd5(tmpPdfUrl);
                            String tmpTokenZip = getTokenMd5(tmpZipUrl);
                            tmpPdfUrl += '&token=' + tmpTokenPdf;
                            tmpZipUrl += '&token=' + tmpTokenZip;
                            facturasList.get(i).put('url_pdf',tmpPdfUrl);
                            facturasList.get(i).put('url_zip',tmpZipUrl);
                        /*}else{
                            facturasList.get(i).put('url_pdf','');
                            facturasList.get(i).put('url_zip','');
                        }*/
                        if(facturasList.get(i).get('tipo_documento')=='Factura'
                           	&&(facturasList.get(i).get('estado_factura')=='Vencido'||facturasList.get(i).get('estado_factura')=='No pagado')){
                                String mpOrderStr = (String)facturasList.get(i).get('referencia_factura');
                                Double mpAmount = (Double)facturasList.get(i).get('monto_factura');
                                String mpAmountStr = String.valueOf(mpAmount);
                                
                            	facturasList.get(i).put('mp_signature',getSHA256TokenMultipagos(mpOrderStr,mpReferenceStr,mpAmountStr,keyMultipagosStr));
                                facturasList.get(i).put('mp_account',(String)options.get('MpAccountMultipagos'));
                                facturasList.get(i).put('mp_urlsuccess',(String)options.get('MpUrlSuccessMultipagos'));
                                facturasList.get(i).put('mp_urlfailure',(String)options.get('MpUrlFailureMultipagos'));
                                facturasList.get(i).put('mp_reference',mpReferenceStr);
                                facturasList.get(i).put('mp_customername',UserInfo.getUserName());
                                refFacturaSet.add((String)facturasList.get(i).get('referencia_factura'));
                                facturasList.get(i).put('mp_node',MpNodeMultipagosStr);
                        }else{
                            facturasList.get(i).put('mp_signature','');
                            facturasList.get(i).put('mp_account','');
                            facturasList.get(i).put('mp_urlsuccess','');
                            facturasList.get(i).put('mp_urlfailure','');
                            facturasList.get(i).put('mp_reference','');
                            facturasList.get(i).put('mp_customername','');
                            facturasList.get(i).put('mp_node','');
                        }
                    }
                    List<OSFMX_TransactionRecordMultipagos__c> transactRecList = [
                        SELECT Id,OSFMX_Referencia_Factura__c,LastModifiedDate,OSFMX_LastEvent__c,
                        	OSFMX_MpAuthorization__c,OSFMX_IsValidMpSignature__c
                        FROM OSFMX_TransactionRecordMultipagos__c
                        WHERE OSFMX_Referencia_Factura__c IN :refFacturaSet
                    ];
                    for(OSFMX_TransactionRecordMultipagos__c item:transactRecList){
                        OSFMX_360ViewInvoice__c infoMultipagos = new OSFMX_360ViewInvoice__c();
                        if(item.OSFMX_MpAuthorization__c!=null&&!item.OSFMX_IsValidMpSignature__c){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'Inconsistencia en la información recibida del pago';
                        }else if(item.OSFMX_LastEvent__c=='Botón Pagar Presionado'){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'Se registró el intento de pago en la fecha ' 
                                + item.LastModifiedDate.format('dd/MM/yyyy');
                        } else if(item.OSFMX_LastEvent__c=='Respuesta Exitosa Cheque en Línea'){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'El pago fue recibido por el banco y se verá reflejado en su estado de cuenta en un plazo de 72 horas';
                        } else if(item.OSFMX_LastEvent__c=='Respuesta de Ficha Impresa CIE'){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'Se imprimió ficha de pago en la fecha ' 
                                + item.LastModifiedDate.format('dd/MM/yyyy');
                        } else if(item.OSFMX_LastEvent__c=='Respuesta de Error Cheque en Línea'){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'Respuesta de Error Cheque en Línea en la fecha ' 
                                + item.LastModifiedDate.format('dd/MM/yyyy');
                        } else if(item.OSFMX_LastEvent__c=='Respuesta de Error Transferencia CIE'){
                            infoMultipagos.OSFMX_InfoMultipagos__c = 'Respuesta de Error Transferencia CIE en la fecha ' 
                                + item.LastModifiedDate.format('dd/MM/yyyy');
                        }
                        
                        infoMultipagos.OSFMX_MpAuthMultipagos__c = item.OSFMX_MpAuthorization__c;
                        infoMultipagosByRefFactMap.put(item.OSFMX_Referencia_Factura__c,infoMultipagos);
                    }
                    for(Integer i=0;i<facturasList.size();i++){
                        String refFactura = (String)facturasList.get(i).get('referencia_factura');
                        OSFMX_360ViewInvoice__c info = infoMultipagosByRefFactMap.get(refFactura);
                        if(info!=null){
                            facturasList.get(i).put('info_multipagos',info.OSFMX_InfoMultipagos__c);
                            facturasList.get(i).put('authorization_multipagos',info.OSFMX_MpAuthMultipagos__c);
                        }else{
                            facturasList.get(i).put('info_multipagos','');
                            facturasList.get(i).put('authorization_multipagos','');
                        }
                        
                    }
                    
                    System.debug('>>>>>>>>>>> facturasList MODX: ' + facturasList);
                }
            }
        }
        
        return true;
    }
    
    String getTokenMd5(String url){
        Blob urlBaseBlob = Blob.valueOf(url);
        Blob md5Key = Crypto.generateDigest('md5', urlBaseBlob);
        
        return EncodingUtil.convertToHex(md5Key);
    }
    
    String getSHA256TokenMultipagos(String mpOrder, String mpReference, String mpAmount, String privateKey){
        Blob privateKeyBlob = Blob.valueOf(privateKey);
        Blob informationChainBlob = Blob.valueOf(mpOrder+mpReference+mpAmount);
        Blob sha256Key = Crypto.generateMac('hmacSHA256', informationChainBlob, privateKeyBlob);
        String tokenSha256 = EncodingUtil.convertToHex(sha256Key);
        
        return tokenSha256;
    }
}