public with sharing class OSFMX_MultiSiteComponentCtrl {
    public Id masterQuoteId{get;set;}
    public String titleMaster{get;set;}
    public String detailMaster{get;set;}
    public List<String> titleChild{get;set;}
    public List<String> detailChild{get;set;}      
    public List<Quote> childQuotes;
    public Quote quote;
    
    
    public OSFMX_MultiSiteComponentCtrl() {
        titleMaster = '#009BFF';
        detailMaster = '#80CDFF';
        titleChild = new List<String>();
        detailChild = new List<String>();  
        titleChild.add('#A4A4A4');
        titleChild.add('#72C660');
        detailChild.add('#CFCFCF');
        detailChild.add('#A6CA9E');
                            
    }
    public Quote getQuote(){
        quote = [SELECT Id,Account.Name,Account.OSFMX_RFC__c,OSFMX_MasterNivelApro__c,OSFMX_OfferType__c,OSFMX_Plazo_suministro_Gas__c,
        OSFMX_RequestedVolumeGjYear__c,OSFMX_MasterDailyVolume__c,OSFMX_MasterGwhYear__c,OSFMX_MasterConsumoPlazoSTR__c,OSFMX_IndexReference__c,
        OSFMX_MasterCuadrante__c,OSFMX_Master_MargenEstimadoMoleculaUSD__c,OSFMX_Rango_comercializaci_n__c,OSFMX_Margen_comercializacion_usd__c
         FROM Quote WHERE Id =:masterQuoteId limit 1];
        return quote;
    }
    public List<Quote> getChildQuotes(){
        childQuotes = [SELECT Id, Name,OSMXConsumo_Plazo__c, OSFMX_ParticularSpecifications__c, OSFMX_DistributorOrCarrier__c, OSFMX_ActualPrice__c, 
        OSFMX_PriceStructure__c, OSFMX_Spread_piso_por_cuadrante__c, OSFMX_Margen_estimado_molecula_usd__c, OSFMX_GasTransportPrice__c, 
        OSFMXSpreadAvoidCurrenSymbol__c, OSFMX_Spread_BC_excedente_USD_Gj__c,vlocity_cmt__DefaultServicePointId__r.Name,OSFMX_IndexReference__c
        FROM Quote WHERE vlocity_cmt__ParentQuoteId__c =:masterQuoteId];
        return childQuotes;
    }

    /*public List<Quote> getchildQuotes(){
        return childQuotes;
    }
    public String gettitleMaster(){
        return titleMaster;
    }
    public Quote getquote(){
        return quote;
    }
    public String getdetailMaster(){
        return detailMaster;
    }
    public List<String> gettitleChild(){
        return titleChild;
    }
    public List<String> getdetailChild(){
        return detailChild;
    }*/
}