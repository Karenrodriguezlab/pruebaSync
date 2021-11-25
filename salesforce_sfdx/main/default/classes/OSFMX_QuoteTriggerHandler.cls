public with sharing class OSFMX_QuoteTriggerHandler {

    public static void beforeUpdate(Map<Id, Quote> oldQuoteById, List<Quote> newQuotes) {
        List<Quote> listQuotes = new List<Quote>();
        for (Quote oferta : newQuotes) {
            if (oferta.OSFMX_OppServicePointType__c!='Multipunto' && oferta.Status=='Aprobada' && oferta.OSFMX_SolutionType__c=='Distribución de Gas Natural' ){
        		listQuotes.add(oferta);
            }
        }
        if(listQuotes.size()>0){
        	OSFMX_QuoteTriggerHelper.generateQuotePDF(oldQuoteById, listQuotes);
        }
    }

    public static void afterUpdate(Map<Id, Quote> oldQuoteById, List<Quote> newQuotes) {
       	List<Quote> listQuotesUpdateService = new List<Quote>();
        List<Quote> listQuotesCustomNotification = new List<Quote>();
        for (Quote oferta : newQuotes) {
            if (oferta.vlocity_cmt__ParentQuoteId__c!=null && oferta.OSFMX_OppServicePointType__c=='Multipunto' && oferta.Status!='Borrador' ){
                listQuotesUpdateService.add(oferta);
            }
            if (
                (oferta.OSFMX_OppServicePointType__c!='Multipunto' && (oferta.Status=='Aprobada'||(oferta.Status=='Observaciones' && oferta.OSFMX_SubEstatus__c=='Aprobación')))
                ||
               (oferta.vlocity_cmt__ParentQuoteId__c==null && oferta.OSFMX_OppServicePointType__c=='Multipunto' && (oferta.Status=='Aprobada'||(oferta.Status=='Observaciones' && oferta.OSFMX_SubEstatus__c=='Aprobación')))
            ){
                listQuotesCustomNotification.add(oferta);
            }

        }



        if (listQuotesUpdateService.size()>0){
            OSFMX_QuoteTriggerHelper.updateServicePointByOffer(listQuotesUpdateService);
        }
        if (listQuotesCustomNotification.size()>0){
            OSFMX_QuoteTriggerHelper.createCustomNotification(oldQuoteById, listQuotesCustomNotification);
        }
    }

    public static void afterUpdateMaster(Map<Id, Quote> oldQuoteById, List<Quote> newMasterQuote){
        List<Quote> listMasterQuote = new List<Quote>();
        List<Quote> listSendEmail = new List<Quote>();
        for (Quote masterQuote : newMasterQuote){
            Quote oldQuote = oldQuoteById.get(masterQuote.Id);

            if ((masterQuote.Status=='Aprobada'||(masterQuote.Status=='Observaciones' && masterQuote.OSFMX_SubEstatus__c=='Aprobación'))){
                listMasterQuote.add(masterQuote);
            }

        }
        System.debug('listsize::'+listSendEmail.size());
        if (listMasterQuote.size()>0) {
            OSFMX_QuoteTriggerHelper.updateStatusChildQuote(listMasterQuote);
        }
        
    }
}
