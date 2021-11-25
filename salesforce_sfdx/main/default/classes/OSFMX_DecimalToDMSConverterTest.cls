@isTest
public class OSFMX_DecimalToDMSConverterTest {

    @isTest
    static void testInvokeMethod() {
        OSFMX_DecimalToDMSConverter remoteAcc = new OSFMX_DecimalToDMSConverter();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String,Object> payload = new Map<String, Object>();
        List<Map<String,Object>> facturasList = new List<Map<String,Object>>();
        Map<String,Object> factura = new Map<String, Object>();
        
        options.put('latitude',19.4324501);
        options.put('longitude',-99.1333817);
        remoteAcc.invokeMethod('convertDecimalToDMS',inputs,output,options);
        System.assertEquals('19°25\'56.82"N', 
                            output.get('lat'), 
                            'No se convirtió correctamente la latitud.');
        System.assertEquals('99°8\'0.17"O', 
                            output.get('lng'), 
                            'No se convirtió correctamente la longitud.');
    }
}