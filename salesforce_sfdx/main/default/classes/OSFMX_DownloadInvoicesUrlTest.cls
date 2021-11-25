/**
 * @File Name          : WebServiceRestCreateClosedSale.cls
 * @Description        : Unit Test para OSFMX_DownloadInvoicesUrl. 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    04/03/2021   		    Edgar Maldonado                 Se crea clase original.
 * 1.3	  21/05/2021			Edgar Maldonado					Se agrega escenario de una sola factura con un solo concepto.
**/
@isTest
public class OSFMX_DownloadInvoicesUrlTest {

    @isTest
    static void testInvokeMethod() {
        OSFMX_DownloadInvoicesUrl remoteAcc = new OSFMX_DownloadInvoicesUrl();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String,Object> payload = new Map<String, Object>();
        List<Map<String,Object>> facturasList = new List<Map<String,Object>>();
        Map<String,Object> factura = new Map<String, Object>();
        
        options.put('RFC','TEST01RFC');
        factura.put('tipo_documento','Factura');
        factura.put('id_factura','testIdFact001');
        facturasList.add(factura);
        payload.put('facturas',facturasList);
        options.put('billingPayload',payload);
        remoteAcc.invokeMethod('generateMd5Token',inputs,output,options);
        
        options.put('RFC','TEST01RFC');
        factura.put('tipo_documento','Factura');
        factura.put('id_factura','testIdFact001');
        payload.put('facturas',factura);
        options.put('billingPayload',payload);
        remoteAcc.invokeMethod('generateMd5Token',inputs,output,options);
    }
}