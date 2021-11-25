public with sharing class OSFMX_QuoteTriggerHelper {

    static CustomNotificationType approvedOfferNotificationType = [SELECT Id, DeveloperName
                                                                    FROM CustomNotificationType
                                                                    WHERE DeveloperName='OSFMX_ApprovedOfferNotification'];
    static CustomNotificationType rejectedOfferNotificationType = [SELECT Id, DeveloperName
                                                                    FROM CustomNotificationType
                                                                    WHERE DeveloperName='OSFMX_RejectedOfferNotification'];
    static Group userId = [SELECT Id,Name FROM Group where DeveloperName='OSFMX_GasTeam' limit 1];

    public static void generateQuotePDF(Map<Id, Quote> oldQuoteById, List<Quote> newQuotes) {

        String pdfName = 'Formato de Oferta';
        try{
            for (Quote oferta : newQuotes) {
           	Quote oldQuote = oldQuoteById.get(oferta.Id);

           	if (oldQuote.Status !='Aprobada' && oferta.Status=='Aprobada'){
           		String nombrePlantilla;
                String nombrePDF = 'ENGIE – ';
                if (oferta.OSFMX_SolutionType__c=='Comercialización de Gas Natural'){
                  	nombrePlantilla='Engie Mexcom Oferta V2';
                  	if (oferta.OSFMX_Solution__c=='Molécula pura'){
                        nombrePDF +='Oferta Gas Natural Molécula Pura – '+oferta.QuoteNumber;
                    }
                    else{
                      	nombrePDF +='Oferta Gas Natural Comercialización + Conducción – '+oferta.QuoteNumber;
                    }
              	}
                else if (oferta.OSFMX_SolutionType__c=='Distribución de Gas Natural') {
                 	nombrePlantilla='Engie Distribucion Oferta';
                 	if (oferta.OSFMX_Solution__c=='Distribución Simple'){
                     	nombrePDF +='Oferta Gas Natural Distribución Simple – '+oferta.QuoteNumber;
                   	}
                    else{
                     	nombrePDF +='Oferta Gas Natural Distribución + Comercialización – '+oferta.QuoteNumber;
                   	}
               	}
                else {
                  	return;
               	}

              	String path = 'OSFMX_CreateObjectDocument';
                PageReference vfPDF = null;
                Map<String,Object> input   = new Map<String,Object>{'contextId'  => oferta.Id,'nombrePDF' =>nombrePDF,'nombrePlantilla'=>nombrePlantilla};
                Map<String,Object> options = new Map<String,Object>();
               	Map<String, Object> output = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, input, options);

                String templateId = (String) output.get('templateId');
                String docId      = (String) output.get('docId');
                System.debug('--> docId ' + docId + ' ::: templateId ' + templateId);

                if(String.isNotBlank(docId)) {
                	//-----------
                   	//Actualizar fecha de vencimiento de la oferta
                   	//-----------
                   	Date fechaVencimiento = Date.today();
                   	Integer diasAdicionales = oferta.OSFMX_OfferValidity__c.intValue();
                   	oferta.vlocity_cmt__ValidationDate__c = fechaVencimiento.addDays(diasAdicionales);
                    //oferta.OSFMX_FlagApproval__c = true;
                    //upsert tempQuote;
                }
         	}
            }
        }
        catch(Exception e){
            System.debug('ERROR::'+e);
        }
    }

    public static void createCustomNotification(Map<Id, Quote> oldQuoteById, List<Quote> newQuotes) {

        try{
            Map<Id,Quote> newQuotesMap = new Map<Id,Quote>(newQuotes);
            List<ProcessInstance> processInstanceList = [
                SELECT Id,TargetObjectId, Status,
                	(SELECT id,actor.name,OriginalActorId FROM Workitems),
                	(SELECT Id,ActorId,OriginalActorId FROM Steps)
                FROM ProcessInstance WHERE TargetObjectId  IN :newQuotesMap.keySet()
                ORDER BY CreatedDate DESC NULLS LAST
            ];
            Map<Id,ProcessInstance> procInstanceByQuoteIdMap = new Map<Id,ProcessInstance>();
            for(ProcessInstance procInsItem : processInstanceList){
                procInstanceByQuoteIdMap.put(procInsItem.TargetObjectId,procInsItem);
            }

            for (Quote oferta : newQuotes) {
                Quote oldQuote = oldQuoteById.get(oferta.Id);

                if (oldQuote.Status !='Aprobada' && oferta.Status=='Aprobada'){
                    // Create a new custom notification
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();

                    // Set the contents for the notification
                    notification.setTitle('Se ha aprobado la oferta '+ oferta.Name+'/'+oferta.QuoteNumber);
                    notification.setBody('Ingresar para continuar su seguimiento, gracias!');

                    // Set the notification type and target
                    notification.setNotificationTypeId(approvedOfferNotificationType.Id);
                    notification.setTargetId(oferta.Id);
                    Set<String> addressee = new Set<String>();
                    addressee.add(oferta.OwnerId);
                    if(oferta.OSFMX_SolutionType__c=='Comercialización de Gas Natural'){
                        addressee.add(userId.Id);

                        ProcessInstance processinstance = procInstanceByQuoteIdMap.get(oferta.Id);
                        for(ProcessInstanceStep pi:processinstance.Steps){
                            addressee.add(pi.OriginalActorId);
                        }
                        for(ProcessInstanceWorkitem wi:processinstance.Workitems){
                            addressee.add(wi.OriginalActorId);
                        }
                    }
                    System.debug('CAMPANA::'+addressee);
                    notification.send(addressee);
                }
                if ((oldQuote.OSFMX_SubEstatus__c!='Aprobación' && oldQuote.Status !='Observaciones') && (oferta.Status=='Observaciones' && oferta.OSFMX_SubEstatus__c=='Aprobación')){

                    // Create a new custom notification
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();

                    // Set the contents for the notification
                    notification.setTitle('Se ha rechazado la oferta '+ oferta.Name+'/'+oferta.QuoteNumber);
                    notification.setBody('Ingresar para revisar comentarios de rechazo, gracias!');

                    // Set the notification type and target
                    notification.setNotificationTypeId(rejectedOfferNotificationType.Id);
                    notification.setTargetId(oferta.Id);

                    Set<String> addressee = new Set<String>();
                    addressee.add(oferta.OwnerId);

                    if(oferta.OSFMX_SolutionType__c=='Comercialización de Gas Natural'){
                        addressee.add(userId.Id);

                        ProcessInstance processinstance = procInstanceByQuoteIdMap.get(oferta.Id);
                        for(ProcessInstanceStep pi:processinstance.Steps){
                            addressee.add(pi.OriginalActorId);
                        }
                        for(ProcessInstanceWorkitem wi:processinstance.Workitems){
                            addressee.add(wi.OriginalActorId);
                        }

                    }
                    System.debug('CAMPANA::'+addressee);
                    notification.send(addressee);
                }
            }
        }
        catch(Exception e){
            System.debug('ERROR::'+e);
        }


    }

	public static void updateServicePointByOffer(List<Quote> newQuotes){
        //Id parentQuote, Id quote,String status,String subEstatus
        try{
            Map<Id,Quote> newQuotesMap = new Map<Id,Quote>(newQuotes);
            List<OSFMX_SupplyPointForOffer__c> customServicePointQuote = [SELECT Id,OSFMX_QuoteSubStatus__c,OSFMX_QuoteStatus__c,OSFMX_ChildQuote__c
                                                                FROM OSFMX_SupplyPointForOffer__c
                                                                WHERE OSFMX_ChildQuote__c IN :newQuotesMap.keySet()];

        	Map<Id,OSFMX_SupplyPointForOffer__c> mapSupplyPointOffer = new Map<Id,OSFMX_SupplyPointForOffer__c>();

            for(OSFMX_SupplyPointForOffer__c supplyPoint : customServicePointQuote){
                mapSupplyPointOffer.put(supplyPoint.OSFMX_ChildQuote__c,supplyPoint);
            }

            List<OSFMX_SupplyPointForOffer__c> updateSupplyPointOffer = new List<OSFMX_SupplyPointForOffer__c>();

            for (Quote oferta : newQuotes) {
            	String status = oferta.Status;
                String subStatus = oferta.OSFMX_SubEstatus__c;
                OSFMX_SupplyPointForOffer__c updateServicePointQuote = mapSupplyPointOffer.get(oferta.Id);
                updateServicePointQuote.OSFMX_QuoteSubStatus__c=subStatus;
        		updateServicePointQuote.OSFMX_QuoteStatus__c = status;
                updateSupplyPointOffer.add(updateServicePointQuote);

            }

        	update updateSupplyPointOffer;
        }
        catch(Exception e){
            System.debug('ERROR::'+e);
        }

    }

    public static void updateStatusChildQuote(List<Quote> newQuotes){
        //Id parentQuote, Id quote,String status,String subEstatus
        try{
            Map<String, Object> params = new Map<String, Object>();
            params.put('MasterQuoteCollection', newQuotes);
            Flow.Interview.OSFMX_MasterQuoteCollection recordUpdaterFlow = new Flow.Interview.OSFMX_MasterQuoteCollection(params);
            recordUpdaterFlow.start();
        }
        catch(Exception e){
            System.debug('ERROR::'+e);
        }

    }

    

}
