public class OSFMX_ReporteSemanalPDF_cls {
  @AuraEnabled
  public static String getUrlReporte(){
        String url;
        OSFMX_URL__c objRecord = [SELECT Id, Name, OSFMX_URL_PDF__c FROM OSFMX_URL__c order by createddate desc limit 1];
        url = objRecord.OSFMX_URL_PDF__c;
        return url;
    }
}