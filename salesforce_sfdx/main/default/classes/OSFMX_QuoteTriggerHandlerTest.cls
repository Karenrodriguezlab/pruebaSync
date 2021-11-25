@isTest
private class OSFMX_QuoteTriggerHandlerTest {
    
    @isTest 
    static void insertOpp() {
        Account acc = new Account();
        acc.name = 'Acme';
        acc.BillingStreet = '123';
        acc.BillingPostalCode = '12345';
        acc.BillingCity = 'City';
        acc.BillingStateCode = 'AG';
        acc.BillingCountryCode = 'MX';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.name = 'Testopp';
        Opp.Accountid = acc.id;
        opp.CloseDate = date.today();
        opp.StageName = 'Qualification';
        insert opp;
        
        Pricebook2 pb = new Pricebook2(Name='Standard Price Book 2009',Description='Price Book 2009 Products',IsActive=true);
        insert pb;
        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
        insert prod;
        PricebookEntry pbe = new PricebookEntry(unitprice=0.01,Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
        insert pbe;
        
        RecordType rt = [select Id from RecordType where DeveloperName = 'OSFMX_OfertaGas' limit 1];
        Quote q = new Quote();
        q.Name = 'Testq';
        q.OpportunityId = Opp.id;
        q.BillingStreet = '123';
        q.BillingCity = 'City';
        q.BillingPostalCode = '12345';
        q.Pricebook2Id= pb.id;
        q.RecordTypeId = rt.Id;
        insert q;
        
        Test.startTest();
        q.BillingCity = 'City2';
        update q;
        Test.stopTest();
        System.assertEquals('City2', q.BillingCity);
	}
}