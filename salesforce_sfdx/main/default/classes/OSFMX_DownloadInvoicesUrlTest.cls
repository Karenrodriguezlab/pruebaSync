/**
 * @File Name          : WebServiceRestCreateClosedSale.cls
 * @Description        : Unit Test para OSFMX_DownloadInvoicesUrl. 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    04/03/2021   		    Edgar Maldonado                 Se crea clase original.
 * 1.3	  21/05/2021			Edgar Maldonado					Se agrega escenario de una sola factura con un solo concepto.
 * 1.4	  28/05/2021			Edgar Maldonado					Se agregan datos para Multipagos.
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
        options.put('PrivateKeyMultipagos','TestKey1234567890');
        factura.put('tipo_documento','Factura');
        factura.put('id_factura','testIdFact001');
        factura.put('estado_factura','Vencido');
        factura.put('referencia_factura','ABC123');
        factura.put('monto_factura',100);
        factura.put('cuenta_contrato','00123456789');
        payload.put('facturas',factura);
        options.put('billingPayload',payload);
        OSFMX_TransactionRecordMultipagos__c multipagosRec = new OSFMX_TransactionRecordMultipagos__c(
            OSFMX_Referencia_Factura__c='ABC123',
            OSFMX_LastEvent__c='Respuesta Exitosa Cheque en Línea',
            OSFMX_MpAuthorization__c='Auth12345',
            OSFMX_IsValidMpSignature__c=true,
        	OSFMX_CuentaContrato__c='00123456789'
        );
        INSERT multipagosRec;
        remoteAcc.invokeMethod('generateMd5Token',inputs,output,options);
        
        factura.put('cuenta_contrato','00987654321');
        multipagosRec.OSFMX_CuentaContrato__c='00987654321';
        multipagosRec.OSFMX_LastEvent__c='Botón Pagar Presionado';
        UPDATE multipagosRec;
        remoteAcc.invokeMethod('generateMd5Token',inputs,output,options);
    }
}