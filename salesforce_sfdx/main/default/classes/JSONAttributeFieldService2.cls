global with sharing class JSONAttributeFieldService2 implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Boolean res = true;
        try {
            if(methodName == 'setQuoteLineItemAttributes') {
                res = setQuoteLineItemAttributes(input, output, options);
            }
        } catch(Exception e) {
            System.debug('::: JSONAttributeFieldService.invokeMethod --> ERROR : ' + e.getMessage() + ' - ' + e.getStackTraceString());
            output.put('EXC',e.getMessage() + ' - ' + e.getStackTraceString());
            throw e;
        }
        return res;
    }
    
    global static Boolean setQuoteLineItemAttributes(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        String quoteId = (String) options.get('quoteId');
        System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes: quoteID ' + quoteId);
        
        Decimal consumoGJ = 0;
        consumoGJ = [SELECT Id, OSFMX_GJ__c FROM Quote WHERE Id =: quoteId LIMIT 1].OSFMX_GJ__c;

        Map<String,Object> inpIP = new Map<String,Object>{'consumoGJ' => consumoGJ};
        Map<String,Object> optIP = new Map<String,Object>();
        /*System.debug('>>>>>>>>> setQuoteLineItemAttributes - OSFMX_GetRangoConsumo - Result: ' 
                     + vlocity_cmt.IntegrationProcedureService.runIntegrationService('OSFMX_GetRangoConsumo', inpIP, optIP));*/
        Decimal rangoConsumo;
        if(Test.isRunningTest()){
            rangoConsumo = 0.4;
        }else{
            rangoConsumo = (Decimal) vlocity_cmt.IntegrationProcedureService.runIntegrationService('OSFMX_GetRangoConsumo', inpIP, optIP);
        }  
        System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes: rangoConsumo ' + rangoConsumo);
        
        List<QuoteLineItem> quoteItems = new List<QuoteLineItem>();
        for(QuoteLineItem qli : [SELECT Id, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode,
                                 Quote.OSFMX_IndexReference__c, Quote.OSFMX_Spread_ofertado_USD_Gj__c, Quote.OSFMX_DistributorOrCarrier__c, 
                                 Quote.OSFMX_Rango_comercializaci_n__c, Quote.Clasificacion_Tarifaria__c, Quote.OSFMX_GJ__c, Quote.Cargo_por_Uso__c, 
                                 Quote.Cargo_por_Capacidad__c, Quote.Cargo_por_Servicio__c, Quote.OSFMX_GasTransportprice__c, Quote.OSFMX_Quadrant__c
                                 FROM QuoteLineItem WHERE QuoteId =: quoteId]) {

            List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();
            Vlocity_cmt.JSONAttributeSupport jsonSupport = new Vlocity_cmt.JSONAttributeSupport();
            
            Map<String, object> inputMap = new Map<String, object>{
                'objectSO' => null,
                'runTimeAttributesJSON'  => qli.vlocity_cmt__JSONAttribute__c,
                'originalAttributesJSON' => qli.Product2.vlocity_cmt__JSONAttribute__c
            }; 
            Map<String, object> outputMap = new Map<String, object>(); 
            Map<String, object> optionsMap = new Map<String, object>();   
                                     
            if(qli.Product2.ProductCode == 'ENG_Molecula' ) {
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Indice', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_IndexReference__c));   
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Cuadrante', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Quadrant__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Rango_de_Consumo', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, rangoConsumo ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_RangoValor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Rango_comercializaci_n__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ConsumoAnualEsperado', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_GJ__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Spread', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Spread_ofertado_USD_Gj__c));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_TarifaTransporte', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_GasTransportprice__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
            } else if(qli.Product2.ProductCode == 'ENG_Comercializacion') {
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_CargoCapacidad', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Cargo_por_Capacidad__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_CargoUso', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Cargo_por_Uso__c));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_CargoServicio', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN,  qli.Quote.Cargo_por_Servicio__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ConsumoAnualEsperado', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_GJ__c ));
            } else {
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c ));
            }                                 

            inputMap.put('JSONAttributeActionRequestList', actionRequestsList);
            jsonSupport.invokeMethod('applyAttributeActions', inputMap, outputMap, optionsMap); 
                                     
            String modifiedJSON = (String)outputMap.get('modifiedJSON');
            System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes: modifiedJSON : ' + modifiedJSON);
            
            qli.vlocity_cmt__JSONAttribute__c = modifiedJSON;
            quoteItems.add(qli);
        }
        
        if(!quoteItems.isEmpty()) {
            update quoteItems;
            System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes- quoteItems actualizados: ' + quoteItems);
        }
        
        updateProducts(quoteId);
        return false;
    }
    
    @future(callout=true)
    private static void updateProducts(String quoteId) {
        Map<String,Object> inpIP = new Map<String,Object>{'ContextId' => quoteId};
        Map<String,Object> optIP = new Map<String,Object>();
        vlocity_cmt.IntegrationProcedureService.runIntegrationService('OSFMX_GetCartItems', inpIP, optIP); 
        System.debug('--> optIP' + optIP);
    }
    
}