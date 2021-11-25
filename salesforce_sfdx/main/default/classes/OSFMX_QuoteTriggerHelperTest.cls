@isTest
private class OSFMX_QuoteTriggerHelperTest {
    @isTest static void insertOpp() {
        Account acc = new Account (name='Acme',BillingStreet='test',BillingPostalCode='1111',
                                   BillingCity='test',BillingStateCode='AG',BillingCountryCode='MX',OSFMX_RFC__c='ADM1705112JA');
        insert acc;
        Opportunity opp= new Opportunity ();
        opp.name= 'Testopp';
        Opp.Accountid= acc.id;
        opp.CloseDate= date.today();
        opp.StageName= 'Qualification';
        insert opp;
        
         /*Inicio Modificado RRA 20 Julio 2021*/
        // Cree una instancia del registro Pricebook2 primero, estableciendo el Id.
		Pricebook2 standardPricebook = new Pricebook2(
			Id = Test.getStandardPricebookId(),
			IsActive = true
		);
		// Ejecutar una actualización de DML en el registro Pricebook2
		update standardPricebook;

		// Consultar el registro Pricebook2, para depurar
		standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];

		// Esto debería volver a ser verdadero ahora
		system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
        /*Fin Modificado RRA 20 Julio 2021*/
        Id QuoteRTId = [SELECT Id FROM RecordType WHERE DeveloperName = 'OSFMX_OfertaGas' AND SobjectType = 'Quote'].Id;//20/07/2021
      
        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
        insert prod;
        PricebookEntry pbe=new PricebookEntry(unitprice=0.01,Product2Id=prod.Id, Pricebook2Id=standardPricebook.Id, IsActive= true); 
        insert pbe;
        System.debug('##### OSFMX_QuoteTriggerHelperTest - insertOpp - pbe.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pbe.Id]);
        
        Quote q= new Quote ();
        q.Name= 'Testq';
        q.OpportunityId= Opp.id;
        q.BillingStreet= '123';
        q.BillingCity= 'City';
        q.BillingPostalCode= '12345';
        q.Pricebook2Id= standardPricebook.Id;
        q.Status = 'Borrador';
        q.OSFMX_SolutionType__c='Comercialización de Gas Natural';
        q.OSFMX_Solution__c='Molécula pura';
        q.RecordTypeId=QuoteRTId;
        insert q;
        System.debug('##### OSFMX_QuoteTriggerHelperTest - insertOpp - q.Pricebook2Id = ' + [SELECT Pricebook2Id FROM Quote WHERE Id=:q.Id]);
        QuoteLineItem qli= new QuoteLineItem(Quoteid=q.id, PricebookEntryid= pbe.Id,  quantity=2, UnitPrice=1);
        insert qli;
        
        q.Status = 'Aprobada';
        UPDATE q;
        
        Quote quote2= new Quote ();
        quote2.Name= 'Testq2';
        quote2.OpportunityId= Opp.id;
        quote2.BillingStreet= '123';
        quote2.BillingCity= 'City2';
        quote2.BillingPostalCode= '12345';
        quote2.Pricebook2Id= standardPricebook.Id;
        quote2.Status = 'Borrador';
        quote2.OSFMX_SolutionType__c='Distribución de Gas Natural';
        quote2.OSFMX_Solution__c='Distribución Simple';
        quote2.RecordTypeId=QuoteRTId;
        insert quote2;
        System.debug('##### OSFMX_QuoteTriggerHelperTest - insertOpp - quote2.Pricebook2Id = ' + [SELECT Pricebook2Id FROM Quote WHERE Id=:quote2.Id]);
        QuoteLineItem qli2= new QuoteLineItem(Quoteid=quote2.id, PricebookEntryid= pbe.Id,  quantity=2, UnitPrice=1);
        insert qli2;
        quote2.Status = 'Aprobada';
        UPDATE quote2;
        
        Quote quote3= new Quote ();
        quote3.Name= 'Testq3';
        quote3.OpportunityId= Opp.id;
        quote3.BillingStreet= '123';
        quote3.BillingCity= 'City2';
        quote3.BillingPostalCode= '12345';
        quote3.Pricebook2Id= standardPricebook.Id;
        quote3.Status = 'Observaciones';
        quote3.OSFMX_SolutionType__c='Comercialización de Gas Natural';
        quote3.OSFMX_Solution__c='Distribución Simple';
        quote3.OSFMX_SubEstatus__c='Aprobación';
    	quote3.RecordTypeId=QuoteRTId;
        insert quote3;
        System.debug('##### OSFMX_QuoteTriggerHelperTest - insertOpp - quote3.Pricebook2Id = ' + [SELECT Pricebook2Id FROM Quote WHERE Id=:quote3.Id]);
        QuoteLineItem qli3= new QuoteLineItem(Quoteid=quote3.id, PricebookEntryid= pbe.Id,  quantity=2, UnitPrice=1);
        insert qli3;
        quote3.BillingStreet = 'ModX';
        UPDATE quote3;
        
        
        //OfertaMultipunto
        //1. crear premise
        //2. crear service point
        //3. crear oferta master
        //4. crear punto de suministro para oferta master
        //5. crear oferta hija
        //
        
        vlocity_cmt__Premises__c premise = new vlocity_cmt__Premises__c();
        premise.Name = 'Test Premise';
        premise.vlocity_cmt__PropertyOwnerAccountId__c=acc.Id;
        insert premise;
        
        vlocity_cmt__ServicePoint__c servicePoint = new vlocity_cmt__ServicePoint__c();
        servicePoint.Name = 'Test Service Point';
        servicePoint.vlocity_cmt__PremisesId__c = premise.Id;
        servicePoint.OSFMX_OppSolutionType__c = 'Comercialización de Gas Natural';
        servicePoint.OSFMX_OppSolution__c = 'Comercialización + Conducción';
        servicePoint.OSFMX_ServiceAccount__c = acc.Id;
        insert servicePoint;
        
        Quote parentQuote= new Quote ();
        parentQuote.Name= 'Testq';
        parentQuote.OpportunityId= Opp.id;
        parentQuote.BillingStreet= '123';
        parentQuote.BillingCity= 'City';
        parentQuote.BillingPostalCode= '12345';
        parentQuote.Pricebook2Id= standardPricebook.Id;
        parentQuote.Status = 'Borrador';
        parentQuote.OSFMX_SolutionType__c='Comercialización de Gas Natural';
        parentQuote.OSFMX_Solution__c='Comercialización + Conducción';
        parentQuote.RecordTypeId=QuoteRTId;
        parentQuote.OSFMX_OppServicePointType__c = 'Multipunto';
        insert parentQuote;
        //System.debug('##### OSFMX_QuoteTriggerHelperTest - insertOpp - q.Pricebook2Id = ' + [SELECT Pricebook2Id FROM Quote WHERE Id=:q.Id]);
        //QuoteLineItem qli= new QuoteLineItem(Quoteid=q.id, PricebookEntryid= pbe.Id,  quantity=2, UnitPrice=1);
        //insert qli;
        
        Quote childQuote= new Quote ();
        childQuote.Name= 'Testq';
        childQuote.OpportunityId= Opp.id;
        childQuote.BillingStreet= '123';
        childQuote.BillingCity= 'City';
        childQuote.BillingPostalCode= '12345';
        childQuote.Pricebook2Id= standardPricebook.Id;
        childQuote.Status = 'Borrador';
        childQuote.OSFMX_SolutionType__c='Comercialización de Gas Natural';
        childQuote.OSFMX_Solution__c='Comercialización + Conducción';
        childQuote.RecordTypeId=QuoteRTId;
        childQuote.OSFMX_OppServicePointType__c = 'Multipunto';
        childQuote.vlocity_cmt__ParentQuoteId__c = parentQuote.Id;
        insert childQuote;
        
        OSFMX_SupplyPointForOffer__c servicePointOffer  = new OSFMX_SupplyPointForOffer__c();
        servicePointOffer.OSFMX_Opportunity__c = Opp.Id;
        servicePointOffer.OSFMX_Quote__c = parentQuote.Id;
        servicePointOffer.OSFMX_ServicePoint__c = servicePoint.Id;
        servicePointOffer.OSFMX_ChildQuote__c = childQuote.Id;
        insert servicePointOffer;
        
		childQuote.Status = 'Proceso';
		childQuote.OSFMX_SubEstatus__c = 'Producto';
		update childQuote;        
        
        //q.Status = 'Aprobada';
        //UPDATE q;
    }
    
}