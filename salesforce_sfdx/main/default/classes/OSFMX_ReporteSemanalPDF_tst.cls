@isTest
public class OSFMX_ReporteSemanalPDF_tst {
    @isTest
    static void getUrlTest() {
        OSFMX_URL__c objRecord = new OSFMX_URL__c(Name = 'Name Test', URL__c = 'https://engieclorg--devmexico.my.salesforce.com/sfc/p/#c0000003wiic/a/c0000000A8ad/f8v7NllIspLl96MdgknfX_h1aBkBo6IGyyK2UBPQcEg');
        insert objRecord;
        String urlExpected = objRecord.OSFMX_URL_PDF__c;
        String urlActual = OSFMX_ReporteSemanalPDF_cls.getUrlReporte();
        System.assertEquals(urlExpected, urlActual, 'Error');
    }
}