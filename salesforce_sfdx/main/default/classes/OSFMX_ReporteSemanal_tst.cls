@isTest
public class OSFMX_ReporteSemanal_tst {
    
    @isTest
    static void getUrlTest() {
        
        OSFMX_URL__c objRecord = new OSFMX_URL__c(Name = 'Name Test', URL__c = 'https://www.google.com.ar');
        insert objRecord;
        
        String urlExpected = objRecord.URL__c;
        String urlActual = OSFMX_ReporteSemanal_cls.getUrlReporte();
        
        System.assertEquals(urlExpected, urlActual, 'Error');
        
        
    }

}