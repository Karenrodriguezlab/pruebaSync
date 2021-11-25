@isTest
public class vlcContentDistributionTriggerTest {
    
    static testMethod void testSetQuoteLineItemAttributes() {
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'ContentVersionTest',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        INSERT contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.debug('>>>>>>>>>>>>>>>> testSetQuoteLineItemAttributes - documents: ' + documents);
        OSFMX_URL__c reporte = new OSFMX_URL__c(Name='Prueba');//Reporte Semanal
        INSERT reporte;
        ContentDistribution contDritib = new ContentDistribution(ContentVersionId = contentVersion.Id, Name = 'ContentDistributionTest', 
                                                                RelatedRecordId=reporte.Id);
        INSERT contDritib;
        List<ContentDistribution> distributions = [SELECT Id, Name, DistributionPublicUrl FROM ContentDistribution];
        System.debug('>>>>>>>>>>>>>>>> testSetQuoteLineItemAttributes - distributions: ' + distributions);
        contDritib.Name = 'ContentDistributionTest_MODX';
        Test.StartTest();
        UPDATE contDritib;
        Test.StopTest();
        List<OSFMX_URL__c> documentos = [SELECT Id, OSFMX_URL_PDF__c FROM OSFMX_URL__c];
        System.assertEquals(distributions.get(0).DistributionPublicUrl,
                            documentos.get(0).OSFMX_URL_PDF__c, 'No se copió la URL de descarga del documento.');
    }
    
}