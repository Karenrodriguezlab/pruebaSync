@isTest
public class JSONAttributeFieldService2Test {
    
    static testMethod void testSetQuoteLineItemAttributes() {
        //Id standardPBookId = Test.getStandardPricebookId();
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
        Id standardPBookId = standardPricebook.Id;
        /*Fin Modificado RRA 20 Julio 2021*/
        Id QuoteRTId = [SELECT Id FROM RecordType WHERE DeveloperName = 'OSFMX_OfertaGas' AND SobjectType = 'Quote'].Id;//20/07/2021
        
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id, RecordTypeId=QuoteRTId);
        qt.Pricebook2Id = standardPBookId;
        insert qt;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - qt.Pricebook2Id = ' + [SELECT Pricebook2Id FROM Quote WHERE Id=:qt.Id]);
        
        Product2 prod = new Product2();
        prod.IsActive = true;
        prod.Name = 'test01';
        prod.ProductCode = 'ENG_Molecula';
        INSERT prod;
        Product2 prod2 = new Product2();
        prod2.IsActive = true;
        prod2.Name = 'test02';
        prod2.ProductCode = 'ENG_TransporteTarifa';
        INSERT prod2;
        
        Product2 prod3 = new Product2();
        prod3.IsActive = true;
        prod3.Name = 'test03';
        prod3.ProductCode = 'ENG_Servicio';
        INSERT prod3;
        Product2 prod4 = new Product2();
        prod4.IsActive = true;
        prod4.Name = 'test04';
        prod4.ProductCode = 'ENG_Capacidad';
        INSERT prod4;
        Product2 prod5 = new Product2();
        prod5.IsActive = true;
        prod5.Name = 'test05';
        prod5.ProductCode = 'ENG_Uso';
        INSERT prod5;
        Product2 prod6 = new Product2();
        prod6.IsActive = true;
        prod6.Name = 'test06';
        prod6.ProductCode = 'ENG_Volumetria';
        INSERT prod6;
        Product2 prod7 = new Product2();
        prod7.IsActive = true;
        prod7.Name = 'test07';
        prod7.ProductCode = 'ENG_Conexion_Estandard';
        INSERT prod7;
        Product2 prod8 = new Product2();
        prod8.IsActive = true;
        prod8.Name = 'test08';
        prod8.ProductCode = 'ENG_Conexion_NoEstandard';
        INSERT prod8;
        Product2 prod9 = new Product2();
        prod9.IsActive = true;
        prod9.Name = 'test08';
        prod9.ProductCode = 'ENG_Comercializacion';
        INSERT prod9;
        

        
        PricebookEntry pBEntry = new PricebookEntry();
        pBEntry.IsActive = true;
        pBEntry.Pricebook2Id = standardPBookId;
        pBEntry.Product2Id = prod.Id;
        pBEntry.UnitPrice=1;
        INSERT pBEntry;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry.Id]);
        PricebookEntry pBEntry2 = new PricebookEntry();
        pBEntry2.IsActive = true;
        pBEntry2.Pricebook2Id = standardPBookId;
        pBEntry2.Product2Id = prod2.Id;
        pBEntry2.UnitPrice=1;
        INSERT pBEntry2;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry2.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry2.Id]);
        
        PricebookEntry pBEntry3 = new PricebookEntry();
        pBEntry3.IsActive = true;
        pBEntry3.Pricebook2Id = standardPBookId;
        pBEntry3.Product2Id = prod3.Id;
        pBEntry3.UnitPrice=1;
        INSERT pBEntry3;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry3.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry3.Id]);
        PricebookEntry pBEntry4 = new PricebookEntry();
        pBEntry4.IsActive = true;
        pBEntry4.Pricebook2Id = standardPBookId;
        pBEntry4.Product2Id = prod4.Id;
        pBEntry4.UnitPrice=1;
        INSERT pBEntry4;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry4.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry4.Id]);
        PricebookEntry pBEntry5 = new PricebookEntry();
        pBEntry5.IsActive = true;
        pBEntry5.Pricebook2Id = standardPBookId;
        pBEntry5.Product2Id = prod5.Id;
        pBEntry5.UnitPrice=1;
        INSERT pBEntry5;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry5.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry5.Id]);
        PricebookEntry pBEntry6 = new PricebookEntry();
        pBEntry6.IsActive = true;
        pBEntry6.Pricebook2Id = standardPBookId;
        pBEntry6.Product2Id = prod6.Id;
        pBEntry6.UnitPrice=1;
        INSERT pBEntry6;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry6.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry6.Id]);
        PricebookEntry pBEntry7 = new PricebookEntry();
        pBEntry7.IsActive = true;
        pBEntry7.Pricebook2Id = standardPBookId;
        pBEntry7.Product2Id = prod7.Id;
        pBEntry7.UnitPrice=1;
        INSERT pBEntry7;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry7.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry7.Id]);
        PricebookEntry pBEntry8 = new PricebookEntry();
        pBEntry8.IsActive = true;
        pBEntry8.Pricebook2Id = standardPBookId;
        pBEntry8.Product2Id = prod8.Id;
        pBEntry8.UnitPrice=1;
        INSERT pBEntry8;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry8.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry8.Id]);
        PricebookEntry pBEntry9 = new PricebookEntry();
        pBEntry9.IsActive = true;
        pBEntry9.Pricebook2Id = standardPBookId;
        pBEntry9.Product2Id = prod9.Id;
        pBEntry9.UnitPrice=1;
        INSERT pBEntry9;
        System.debug('##### OSFMX_CopyJsonAttributesToQLITest - testSetQuoteLineItemAttributes - pBEntry9.Pricebook2Id = ' + [SELECT Pricebook2Id FROM PricebookEntry WHERE Id=:pBEntry9.Id]);
        
        QuoteLineItem qli = new QuoteLineItem();
        qli.Product2Id = prod.Id;
        qli.QuoteId = qt.Id;
        qli.Quantity = 1;
        qli.UnitPrice = 1;
        qli.PricebookEntryId = pBEntry.Id;
        INSERT qli;
        QuoteLineItem qli2 = new QuoteLineItem();
        qli2.Product2Id = prod2.Id;
        qli2.QuoteId = qt.Id;
        qli2.Quantity = 1;
        qli2.UnitPrice = 1;
        qli2.PricebookEntryId = pBEntry2.Id;
        INSERT qli2;
        
        QuoteLineItem qli3 = new QuoteLineItem();
        qli3.Product2Id = prod3.Id;
        qli3.QuoteId = qt.Id;
        qli3.Quantity = 1;
        qli3.UnitPrice = 1;
        qli3.PricebookEntryId = pBEntry3.Id;
        INSERT qli3;
        QuoteLineItem qli4 = new QuoteLineItem();
        qli4.Product2Id = prod4.Id;
        qli4.QuoteId = qt.Id;
        qli4.Quantity = 1;
        qli4.UnitPrice = 1;
        qli4.PricebookEntryId = pBEntry4.Id;
        INSERT qli4;
        QuoteLineItem qli5 = new QuoteLineItem();
        qli5.Product2Id = prod5.Id;
        qli5.QuoteId = qt.Id;
        qli5.Quantity = 1;
        qli5.UnitPrice = 1;
        qli5.PricebookEntryId = pBEntry5.Id;
        INSERT qli5;
        QuoteLineItem qli6 = new QuoteLineItem();
        qli6.Product2Id = prod6.Id;
        qli6.QuoteId = qt.Id;
        qli6.Quantity = 1;
        qli6.UnitPrice = 1;
        qli6.PricebookEntryId = pBEntry6.Id;
        INSERT qli6;
        QuoteLineItem qli7 = new QuoteLineItem();
        qli7.Product2Id = prod7.Id;
        qli7.QuoteId = qt.Id;
        qli7.Quantity = 1;
        qli7.UnitPrice = 1;
        qli7.PricebookEntryId = pBEntry7.Id;
        INSERT qli7;
        QuoteLineItem qli8 = new QuoteLineItem();
        qli8.Product2Id = prod8.Id;
        qli8.QuoteId = qt.Id;
        qli8.Quantity = 1;
        qli8.UnitPrice = 1;
        qli8.PricebookEntryId = pBEntry8.Id;
        INSERT qli8;
        QuoteLineItem qli9 = new QuoteLineItem();
        qli9.Product2Id = prod9.Id;
        qli9.QuoteId = qt.Id;
        qli9.Quantity = 1;
        qli9.UnitPrice = 1;
        qli9.PricebookEntryId = pBEntry9.Id;
        INSERT qli9;
        
        String methodName='setQuoteLineItemAttributes';
        Map<String, Object> inputMap = null; 
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('quoteId',qt.Id);
        Test.StartTest();
        /*vlocity_cmt__OmniScript__c inProc = new vlocity_cmt__OmniScript__c();//No se logró ejecutar el IP OSFMX_GetRangoConsumo, obligaba a SeeAllData
        inProc.Name='Get Rango Consumo';
        inProc.vlocity_cmt__IsActive__c=true;
        inProc.vlocity_cmt__Type__c='OSFMX';
        inProc.vlocity_cmt__SubType__c='GetRangoConsumo';
        inProc.vlocity_cmt__IsProcedure__c=true;
        inProc.vlocity_cmt__Language__c='Procedure';
        inProc.vlocity_cmt__ProcedureKey__c='OSFMX_GetRangoConsumo';
        inProc.vlocity_cmt__Version__c=1;
        INSERT inProc;
        vlocity_cmt__Element__c inProcElem = new vlocity_cmt__Element__c();
        inProcElem.vlocity_cmt__OmniScriptId__c=inProc.Id;
        inProcElem.Name='ResponseAction';
        inProcElem.vlocity_cmt__Active__c=true;
        inProcElem.vlocity_cmt__Type__c='Response Action';
        INSERT inProcElem;*/
        JSONAttributeFieldService2 quoteTest = new JSONAttributeFieldService2();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        /*vlocity_cmt__CalculationMatrix__c vCMtx = new vlocity_cmt__CalculationMatrix__c();//No se logró ejecutar el IP OSFMX_GetRangoConsumo, obligaba a SeeAllData
		vCMtx.Name='TestRangoDeConsumo';
        INSERT vCMtx;
        vlocity_cmt__CalculationMatrixVersion__c vCMtxV = new vlocity_cmt__CalculationMatrixVersion__c();
        vCMtxV.vlocity_cmt__CalculationMatrixId__c = vCMtx.Id;
        vCMtxV.Name='RangoDeConsumo V1';
        vCMtxV.vlocity_cmt__StartDateTime__c = DateTime.newInstance(2021, 01, 01);
        vCMtxV.vlocity_cmt__IsEnabled__c=true;
        INSERT vCMtxV;
        vlocity_cmt__CalculationMatrixRow__c vCMtxRow = new vlocity_cmt__CalculationMatrixRow__c();
        vCMtxRow.vlocity_cmt__CalculationMatrixVersionId__c = vCMtxV.Id;
        vCMtxRow.vlocity_cmt__InputData__c = '{"OSFMX_GJ__c" : "1507.01"}';
        vCMtxRow.vlocity_cmt__OutputData__c = '{"RangodeConsumo" : 0.0 }';
        INSERT vCMtxRow;
        
        System.debug('>>>>>>>>>>>> JSONAttributeFieldService2Test - vlocity_cmt__CalculationMatrixVersion__c: ' 
                     + [
                         SELECT Id,Name,vlocity_cmt__CurrentStatus__c,vlocity_cmt__StartDateTime__c,
                         		vlocity_cmt__IsEnabled__c
                         FROM vlocity_cmt__CalculationMatrixVersion__c
                     ]);
        System.debug('>>>>>>>>>>>> JSONAttributeFieldService2Test - vlocity_cmt__CalculationMatrixVersionId__c: ' 
                     + [
                         	SELECT Id,vlocity_cmt__InputData__c,vlocity_cmt__OutputData__c
							FROM vlocity_cmt__CalculationMatrixRow__c
                     ]);*/
        Test.StopTest();
    }
}