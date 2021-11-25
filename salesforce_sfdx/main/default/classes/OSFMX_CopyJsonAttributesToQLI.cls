global with sharing class OSFMX_CopyJsonAttributesToQLI implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
    /*Registro valores atributos */
    
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
        Boolean checkApproval = (Boolean) options.get('checkApproval');
        //List<String> quoteLineItems = new List<String>();
        System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes: quoteID ' + quoteId);
        
        Decimal valorconexest;
        valorconexest = 1.0;
        
        List<QuoteLineItem> quoteItems = new List<QuoteLineItem>();
        for(QuoteLineItem qli : [SELECT Id, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode,
                                 Quote.OSFMX_IndexReference__c, Quote.OSFMX_Spread_ofertado_USD_Gj__c, Quote.OSFMX_DistributorOrCarrier__c, 
                                 Quote.OSFMX_Rango_comercializaci_n__c, Quote.Clasificacion_Tarifaria__c, Quote.OSFMX_GJ__c, Quote.Cargo_por_Uso__c, 
                                 Quote.Cargo_por_Capacidad__c, Quote.Cargo_por_Servicio__c, Quote.OSFMX_GasTransportprice__c, Quote.OSFMX_Quadrant__c,
                                 Quote.OSMXConsumo_Plazo__c, Quote.OSFMXGarantiaMoleculaTrans__c, Quote.OSFMX_Solution__c, Quote.OSFMX_TimeLimitSupply__c,
                                 Quote.OSFMXUsoCapacidad__c, Quote.OSFMX_MeterNotStandarConnection__c, Quote.OSFMX_Monto_Rango_Monto__c, Quote.OSFMX_Amount__c,
                                 Quote.Cargo_Volumetrico__c,Quote.OSFMX_CostStandardConnection__c ,Quote.OSFMX_CostNoStandardConnection__c,
                                 vlocity_cmt__UsagePriceTotal__c,vlocity_cmt__EffectiveUsageQuantity__c,vlocity_cmt__UsageQuantity__c,vlocity_cmt__UsageUnitPrice__c
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
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Rango_de_Consumo', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Monto_Rango_Monto__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ConsumoAnualEsperado', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_GJ__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Spread', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Spread_ofertado_USD_Gj__c));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSFMX_Amount__c;//05/07/2021
                                         
                                         
                                     } else if(qli.Product2.ProductCode == 'ENG_Comercializacion') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Rango_de_Consumo', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_Monto_Rango_Monto__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSMXConsumo_Plazo__c));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         if(qli.Quote.OSMXConsumo_Plazo__c!=null&&qli.Quote.OSFMX_Monto_Rango_Monto__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSMXConsumo_Plazo__c * qli.Quote.OSFMX_Monto_Rango_Monto__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                         
                                     } else if(qli.Product2.ProductCode == 'ENG_TransporteTarifa') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMXGarantiaMoleculaTrans__c ));
                                         qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSFMXGarantiaMoleculaTrans__c;//05/07/2021
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSFMXGarantiaMoleculaTrans__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSFMXGarantiaMoleculaTrans__c;//05/07/2021
                                         qli.vlocity_cmt__UsageUnitPrice__c = 1;//05/07/2021
                                         
                                     } else if(qli.Product2.ProductCode == 'ENG_Servicio') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_TimeLimitSupply__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(qli.Quote.OSFMX_TimeLimitSupply__c!=null&&qli.Quote.Cargo_por_Servicio__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSFMX_TimeLimitSupply__c * qli.Quote.Cargo_por_Servicio__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSFMX_TimeLimitSupply__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSFMX_TimeLimitSupply__c;//05/07/2021
                                     }
                                     
                                     else if(qli.Product2.ProductCode == 'ENG_Capacidad') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMXUsoCapacidad__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(qli.Quote.OSFMXUsoCapacidad__c!=null&&qli.Quote.Cargo_por_Capacidad__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSFMXUsoCapacidad__c * qli.Quote.Cargo_por_Capacidad__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSFMXUsoCapacidad__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSFMXUsoCapacidad__c;//05/07/2021
                                     }   
                                     
                                     else if(qli.Product2.ProductCode == 'ENG_Uso') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSMXConsumo_Plazo__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(qli.Quote.OSMXConsumo_Plazo__c!=null&&qli.Quote.Cargo_por_Uso__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSMXConsumo_Plazo__c * qli.Quote.Cargo_por_Uso__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                     }
                                     
                                     else if(qli.Product2.ProductCode == 'ENG_Volumetria') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSMXConsumo_Plazo__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(qli.Quote.OSMXConsumo_Plazo__c!=null&&qli.Quote.Cargo_Volumetrico__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSMXConsumo_Plazo__c * qli.Quote.Cargo_Volumetrico__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSMXConsumo_Plazo__c;//05/07/2021
                                     }                         
                                     else if(qli.Product2.ProductCode == 'ENG_Conexion_Estandard') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, valorconexest ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(valorconexest!=null&&qli.Quote.OSFMX_CostStandardConnection__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = valorconexest * qli.Quote.OSFMX_CostStandardConnection__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = valorconexest;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = valorconexest;//05/07/2021
                                     } 
                                     
                                     else if(qli.Product2.ProductCode == 'ENG_Conexion_NoEstandard') {
                                         
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ATT_EST_USAGE_QTY', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_MeterNotStandarConnection__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_Distribuidor', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.OSFMX_DistributorOrCarrier__c ));
                                         actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest('ENG_ClasificacionTarifaria', Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, qli.Quote.Clasificacion_Tarifaria__c));
                                         if(qli.Quote.OSFMX_MeterNotStandarConnection__c!=null&&qli.Quote.OSFMX_CostNoStandardConnection__c!=null){
                                             qli.vlocity_cmt__UsagePriceTotal__c = qli.Quote.OSFMX_MeterNotStandarConnection__c * qli.Quote.OSFMX_CostNoStandardConnection__c;//05/07/2021
                                         }
                                         qli.vlocity_cmt__EffectiveUsageQuantity__c = qli.Quote.OSFMX_MeterNotStandarConnection__c;//05/07/2021
                                         qli.vlocity_cmt__UsageQuantity__c = qli.Quote.OSFMX_MeterNotStandarConnection__c;//05/07/2021
                                     }                        
                                     
                                     else {
                                     }                                 
                                     
                                     inputMap.put('JSONAttributeActionRequestList', actionRequestsList);
                                     jsonSupport.invokeMethod('applyAttributeActions', inputMap, outputMap, optionsMap); 
                                     
                                     String modifiedJSON = (String)outputMap.get('modifiedJSON');
                                     System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes: modifiedJSON : ' + modifiedJSON);
                                     
                                     qli.vlocity_cmt__JSONAttribute__c = modifiedJSON;
                                     quoteItems.add(qli);
                                     //quoteLineItems.add(qli.Id);
                                     System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes-QLI(Id,UsagePriceTotal,' 
                                                  + 'EffectiveUsageQuantity,UsageQuantity,UsageUnitPrice): (' 
                                                  + qli.Id + ',' + qli.vlocity_cmt__UsagePriceTotal__c + ','
                                                  + qli.vlocity_cmt__EffectiveUsageQuantity__c + ','
                                                  + qli.vlocity_cmt__UsageQuantity__c + ','
                                                  + qli.vlocity_cmt__UsageUnitPrice__c + ')'
                                                 );//05/07/2021
                                 }
        
        if(!quoteItems.isEmpty()) {
            update quoteItems;
            System.debug('JSONAttributeFieldService-setQuoteLineItemAttributes- quoteItems actualizados: ' + quoteItems);
        }
        
        updateProducts(quoteId,checkApproval);
        return false;
    }
    
    @future(callout=true)
    private static void updateProducts(String quoteId, Boolean checkApproval) {
        Map<String,Object> inpIP = new Map<String,Object>{'ContextId' => quoteId,'checkApproval'=>checkApproval};
            Map<String,Object> optIP = new Map<String,Object>();
        vlocity_cmt.IntegrationProcedureService.runIntegrationService('OSFMX_GetCartItems', inpIP, optIP);
        
        System.debug('--> optIP' + optIP);
    }
    
}