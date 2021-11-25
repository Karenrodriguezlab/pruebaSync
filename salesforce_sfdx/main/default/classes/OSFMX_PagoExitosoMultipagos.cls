/****************************************************************************************************
    Author:         Luis Licona
    Company:        Globant
    Project:        OSFMX - ENGIE
    Description:    Controler class for VisualForce OSFMX_PagoExitosoMultipagos AND 
                    OSFMX_RespuestaErrorMultipagos

    Information about changes (versions)
    -------------------------------------
    Number    Dates                 Author                       	Description
    ------    --------              --------------------------   	-----------
    1.0       08-OCTOBER-2022       Luis Licona  					Creation Class.
	1.1       12-OCTOBER-2022       Edgar Maldonado  				Se guardan campos de respuesta adicionales.
	1.2       15-OCTOBER-2022       Edgar Maldonado  				Se agrega validación HASH de "mp_signature".
    1.3       29-OCTOBER			Edgar Maldonado					Se ajusta para que en la migración no genere error OSFMX_DevelopmentSettings__mdt.
*****************************************************************************************************/
public without sharing class OSFMX_PagoExitosoMultipagos {
    public String message{ get; set; }
    public String factura{ get; set; }
    
    static final String CIE             = Label.OSFMX_CIE;//'CIE';
    static final String CIE_INTER       = Label.OSFMX_CIE_INTER;//'CIE_INTER'
    static final String RESPUESTA_CIE   = Label.OSFMX_RESPUESTA_CIE;//'Respuesta de Ficha Impresa CIE';
    static final String RESPUESTA_CL    = Label.OSFMX_RESPUESTA_CL;//'Respuesta Exitosa Cheque en Línea';
    static final String VF_ERROR        = Label.OSFMX_VF_ERROR;//'OSFMX_RespuestaErrorMultipagos';
    static final String MSG_SUCCESSP1   = Label.OSFMX_MSG_SUCCESSP1;//'Estamos procesando el pago de la factura:';
    static final String MSG_SUCCESSP2   = Label.OSFMX_MSG_SUCCESSP2;//'y se verá reflejado en su estado de cuenta en un máximo de 72hrs';
    static final String MSG_ERROR       = Label.OSFMX_MSG_ERROR;//'Colocar mensaje de error';
    static final String URL_REDIRECT    = Label.OSFMX_URL_REDIRECT;//'https://devmexico-b2b-engiemexico.cs14.force.com/b2b/s/';
	
    /**
        * @description    The action method invoked when this page is requested by the server.
        * @return         PageReference to same page. 
    */
    public PageReference init() {
        
        String baseUrl      = ApexPages.currentPage().getUrl();
        String urlReferer   = ApexPages.currentPage().getheaders().get('Referer');
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - init - urlReferer: ' + urlReferer);
        Pagereference pageR = new PageReference(urlReferer);

        factura = pageR.getParameters().get('mp_order');//antes mp_reference
        message = MSG_SUCCESSP1+' '+factura+ ' '+MSG_SUCCESSP2;        
        message = baseUrl.contains(VF_ERROR) ? MSG_ERROR : message;

        String lastEvent = pageR.getParameters().get('mp_paymentMethod');
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - init - lastEvent: ' + lastEvent);
        OSFMX_TransactionRecordMultipagos__c objTransaction     = new OSFMX_TransactionRecordMultipagos__c();
        objTransaction.OSFMX_CuentaContrato__c                  = pageR.getParameters().get('mp_reference');//antes mp_contract
        objTransaction.OSFMX_MpResponse__c                      = pageR.getParameters().get('mp_response');
        objTransaction.OSFMX_MpResponsemsg__c                   = pageR.getParameters().get('mp_responsemsg');
        String mpSignatureStr 									= pageR.getParameters().get('mp_signature');
        objTransaction.OSFMX_MpSignature__c                     = mpSignatureStr;
        objTransaction.OSFMX_MpAmount__c                        = Decimal.valueOf(pageR.getParameters().get('mp_amount'));
        objTransaction.OSFMX_MpAuthorization__c                 = pageR.getParameters().get('mp_authorization');
        objTransaction.OSFMX_Referencia_Factura__c              = pageR.getParameters().get('mp_order');//antes mp_reference
        objTransaction.OSFMX_IsMultipagosErrorResponse__c       = baseUrl.contains(VF_ERROR) ? true   : false;
        objTransaction.OSFMX_IsMultipagosSuccessfulResponse__c  = baseUrl.contains(VF_ERROR) ? false  : true;
        if(lastEvent==CIE){
            objTransaction.OSFMX_LastEvent__c = RESPUESTA_CL;
        }else if(lastEvent==CIE_INTER){
            objTransaction.OSFMX_LastEvent__c = RESPUESTA_CIE;
        }
        /*INICIO Validar mp_signature*/
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - init - mp_signature: ' + mpSignatureStr);
        if(mpSignatureStr!=null){
            String multipagosPrivateKey;
        	List<OSFMX_DevelopmentSettings__mdt> config;
            
            if(Test.isRunningTest()){
                config= new List<OSFMX_DevelopmentSettings__mdt>();
                OSFMX_DevelopmentSettings__mdt configItem = new OSFMX_DevelopmentSettings__mdt(
                	OSFMX_PrivateKeyMultipagos__c='TestKey123456789'
                );
                config.add(configItem);
            }else{
                config = [SELECT OSFMX_PrivateKeyMultipagos__c FROM OSFMX_DevelopmentSettings__mdt WHERE DeveloperName='Global'];
            }
            
        	multipagosPrivateKey = config[0].OSFMX_PrivateKeyMultipagos__c;
            String mpSignatureStr2 = getSHA256TokenMultipagos(objTransaction.OSFMX_Referencia_Factura__c,
                                                              objTransaction.OSFMX_CuentaContrato__c,
                                                              '' + objTransaction.OSFMX_MpAmount__c,
                                                              objTransaction.OSFMX_MpAuthorization__c,
                                                              multipagosPrivateKey);
            if(mpSignatureStr==mpSignatureStr2){
                objTransaction.OSFMX_IsValidMpSignature__c  = true;
            }else{
                objTransaction.OSFMX_IsValidMpSignature__c  = false;
            }
        }else{
            objTransaction.OSFMX_IsValidMpSignature__c  = false;
        }
        /*FIN Validar mp_signature*/
        

        UPSERT objTransaction OSFMX_Referencia_Factura__c;
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - init - UPSERT: ' + objTransaction);
        
        return null;
    }

    /**
        * @description      Method invoke from commandButton for redirect to Start page.
        * @return           PageReference with url start.
    */
    public PageReference urlRedirection() {

          string url = URL_REDIRECT;
          PageReference page = new PageReference(url);
          page.setRedirect(true);
          return page;
    }
    
    String getSHA256TokenMultipagos(String mpOrder, String mpReference, String mpAmount, String mp_authorization, String privateKey){
        Blob privateKeyBlob = Blob.valueOf(privateKey);
        Blob informationChainBlob = Blob.valueOf(mpOrder+mpReference+mpAmount+mp_authorization);
        Blob sha256Key = Crypto.generateMac('hmacSHA256', informationChainBlob, privateKeyBlob);
        String tokenSha256 = EncodingUtil.convertToHex(sha256Key);
        
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - mpOrder: ' + mpOrder);
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - mpReference: ' + mpReference);
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - mpAmount: ' + mpAmount);
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - mp_authorization: ' + mp_authorization);
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - privateKey: ' + privateKey);
        System.debug('>>>>>>>>>>>>>>> OSFMX_PagoExitosoMultipagos - getSHA256TokenMultipagos - tokenSha256: ' + tokenSha256);
        
        return tokenSha256;
    }
}