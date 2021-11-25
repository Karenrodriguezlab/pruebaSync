/**
 * @File Name          : WebServiceRestCreateClosedSale.cls
 * @Description        : Se invoca como remote action desde un IP, para agregar url de descarga a las facturas de un payload. 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    03/03/2021   		    Edgar Maldonado                 Se crea clase original.
 * 1.1	  08/03/2021		    Edgar Maldonado                 Se cambioa URL hacía nuevo sistema de timbrado.
 * 1.2	  14/05/201				Edgar Maldonado					Se permite generar URL para cualquier tipo de documento.
 * 1.3	  21/05/2021			Edgar Maldonado					Se agrega escenario de una sola factura con un solo concepto.
**/
global class OSFMX_DownloadInvoicesUrl implements vlocity_cmt.VlocityOpenInterface {
        
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
        if (methodName == 'generateMd5Token')
        {
            String rfcStr = (String)options.get('RFC');
            String baseUrl;
            String UrlToDownloadInvStr;
            if(Test.isRunningTest()){
                UrlToDownloadInvStr = 'https://pruebaUnitariaSFDC';
            }else{
                List<OSFMX_DevelopmentSettings__mdt> config = [SELECT OSFMX_UrlToDownloadInvoices__c FROM OSFMX_DevelopmentSettings__mdt WHERE DeveloperName='Global'];
                UrlToDownloadInvStr = config[0].OSFMX_UrlToDownloadInvoices__c;
            }
            if(rfcStr!=null){
                baseUrl = UrlToDownloadInvStr;
                Map<String,Object> payloadMap = (Map<String,Object>)options.get('billingPayload');
                List<Map<String,Object>> facturasList;
                try{
                    facturasList = (List<Map<String,Object>>)payloadMap.get('facturas');
                }catch(Exception ex){
                    System.debug('##### OSFMX_DownloadInvoicesUrl - invokeMethod - Exception: ' + ex.getMessage());
                    Map<String,Object> facturaItem = (Map<String,Object>)payloadMap.get('facturas');
                    facturasList = new List<Map<String,Object>>();
                    facturasList.add(facturaItem);
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
}