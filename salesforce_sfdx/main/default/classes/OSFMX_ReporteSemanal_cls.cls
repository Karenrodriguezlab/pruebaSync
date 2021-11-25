public class OSFMX_ReporteSemanal_cls {

    @AuraEnabled
	public static String getUrlReporte(){
        
        String url;
        
        OSFMX_URL__c objRecord = [SELECT Id, Name, URL__c FROM OSFMX_URL__c order by createddate desc limit 1];

        url = objRecord.URL__c;
        
        return url;
    }
    
}