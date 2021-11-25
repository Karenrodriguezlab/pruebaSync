/*
@name: OSFPE_cls_Asigna_precio_potencia_test.
@version: 1.0
@creation date: Junio 2021
@author: Deli Peralta - Protiviti
@description: Clase test del trigger OSFPE_trg_Asigna_precio_potencia
*/
@isTest
public class OSFPE_cls_Asigna_precio_potencia_test {
/*
    @creation date:  Junio 2021
    @author: Deli Peralta - Protiviti
    @description: Método para inicializar los datos compartidos entre los unitTest
*/
    @testSetup
    static void setup(){
        Id recordTypeIdQuo = [Select Id from RecordType where DeveloperName='OSFPE_rt_Oferta_Energia_Peru'].Id;
        Account cuenta = new Account();
        Id recordTypeIdAcc = [Select Id from RecordType where DeveloperName='OSFPE_rt_Cuenta_de_Negocio'].Id;
        cuenta.RecordTypeId = recordTypeIdAcc;
        cuenta.Name ='Cuenta 01';
        cuenta.Type = 'Cliente Final';
        cuenta.OSFPE_fld_RUC__c = '20345678911';
        cuenta.BillingStreet = 'Av. La Marina 1789';
        cuenta.BillingPostalCode = '15037';
        cuenta.BillingStateCode = 'AG';
        cuenta.BillingCity = 'Lima';
        cuenta.BillingCountryCode = 'MX';

        insert cuenta;

        Opportunity oportunidad = new Opportunity();
        Id recordTypeIdOpp = [Select Id from RecordType where DeveloperName='OSFPE_rt_Oportunidad_Energia_Peru'].Id;
        oportunidad.Name ='Protiviti';
        oportunidad.RecordTypeId = recordTypeIdOpp;
        oportunidad.AccountId =cuenta.ID;
        oportunidad.Type = 'Nuevo';
        oportunidad.CloseDate = date.newInstance(2020, 5, 6);
        oportunidad.StageName = 'Prospección';
        oportunidad.Amount = 50000;
        oportunidad.OSFCL_Probabilidad_de_cierre__c = '0';

        insert oportunidad;

        Quote propuesta = new Quote();
        propuesta.Name ='Oferta 01';
        propuesta.Status = 'Borrador';
        propuesta.OSFMX_OfferType__c = 'Vinculante';
        propuesta.OSFPE_fld_Unidades_Precio_Energia__c = 'USD/MWh';
        propuesta.OSFPE_fld_Unidades_Precio_Potencia__c = 'USD/kW-mes';
        propuesta.OSFPE_fld_Indexacion_precio_de_potencia__c = '4';
        propuesta.OSFPE_fld_Indexacion_precio_de_energia__c = '5';
        propuesta.OpportunityId = oportunidad.Id;
        propuesta.RecordTypeId = recordTypeIdQuo;

        insert propuesta;

        Quote propuesta02 = new Quote();
        propuesta02.Name ='Oferta 02';
        propuesta02.Status = 'Borrador';
        propuesta02.OSFMX_OfferType__c = 'Vinculante';
        propuesta02.OSFPE_fld_Unidades_Precio_Energia__c = 'USD/MWh';
        propuesta02.OSFPE_fld_Unidades_Precio_Potencia__c = 'USD/kW-mes';
        propuesta02.OSFPE_fld_Indexacion_precio_de_potencia__c = '4';
        propuesta02.OSFPE_fld_Indexacion_precio_de_energia__c = '5';
        propuesta02.OpportunityId = oportunidad.Id;
        propuesta02.RecordTypeId = recordTypeIdQuo;
        insert propuesta02;

        OSFPE_obj_Potencia__c potencia = new OSFPE_obj_Potencia__c();
        potencia.OSFPE_fld_Oferta_enlazada__c = propuesta.Id;
        potencia.OSFPE_fld_Potencia_contratada_en_HP__c = 1;
        potencia.OSFPE_fld_Potencia_contratada_en_HFP__c= 2;
        potencia.OSFPE_fld_Inicio_de_plazo_de_suministro__c= date.newInstance(2020, 5, 6) ;
        potencia.OSFPE_fld_Fin_de_plazo_de_suministro__c= date.newInstance(2020, 5, 20) ;
        //potencia.OSFPE_fld_Oportunidad_enlazada__c = oportunidad.id;

        insert potencia;

        OSFPE_obj_Precio_PPA__c precio = new OSFPE_obj_Precio_PPA__c();
        precio.OSFPE_fld_Oferta_enlazada__c = propuesta.Id;
        precio.OSFPE_fld_Precio_de_potencia__c = 3;
        precio.OSFPE_fld_Precio_de_energia_HP__c = 4;
        precio.OSFPE_fld_Precio_de_energia_HFP__c = 5;
        precio.OSFPE_fld_Inicio_de_plazo_de_precio__c = date.newInstance(2020, 5, 20) ;
        precio.OSFPE_fld_Fin_de_plazo_de_precio__c = date.newInstance(2020, 5, 30);

        insert precio;

        OSFPE_obj_Potencia__c potencia2 = new OSFPE_obj_Potencia__c();
        potencia2.OSFPE_fld_Oferta_enlazada__c = propuesta.Id;
        potencia2.OSFPE_fld_Potencia_contratada_en_HP__c = 1;
        potencia2.OSFPE_fld_Potencia_contratada_en_HFP__c= 2;
        potencia2.OSFPE_fld_Inicio_de_plazo_de_suministro__c= date.newInstance(2020, 5, 6) ;
        potencia2.OSFPE_fld_Fin_de_plazo_de_suministro__c= date.newInstance(2020, 5, 20) ;
        //potencia.OSFPE_fld_Oportunidad_enlazada__c = oportunidad.id;

        insert potencia2;

        OSFPE_obj_Precio_PPA__c precio2 = new OSFPE_obj_Precio_PPA__c();
        precio2.OSFPE_fld_Oferta_enlazada__c = propuesta.Id;
        precio2.OSFPE_fld_Precio_de_potencia__c = 3;
        precio2.OSFPE_fld_Precio_de_energia_HP__c = 4;
        precio2.OSFPE_fld_Precio_de_energia_HFP__c = 5;
        precio2.OSFPE_fld_Inicio_de_plazo_de_precio__c = date.newInstance(2020, 5, 20) ;
        precio2.OSFPE_fld_Fin_de_plazo_de_precio__c = date.newInstance(2020, 5, 30);

        insert precio2;
    }

	@isTest static void Update_Opportunity_Sincronizar() {
        Opportunity oportunidad = [Select id from Opportunity Limit 1];
        Quote propuesta = [Select id from Quote Limit 1];

        oportunidad.SyncedQuoteId = propuesta.Id;

        Test.startTest();
        update oportunidad;
        Test.stopTest();
    }
    @isTest static void Update_Opportunity() {
        Opportunity oportunidad = [Select id from Opportunity Limit 1];
        Quote propuesta = [Select id from Quote where name = 'Oferta 01' Limit 1];
        Id recordTypeIdQuo = [Select Id from RecordType where DeveloperName='OSFPE_rt_Oferta_Energia_Peru'].Id;
        /*

        Quote propuesta02 = [Select id from Quote where name = 'Oferta 02' Limit 1];
        oportunidad.SyncedQuoteId = propuesta02.Id;*/
        OSFPE_obj_Precio_PPA__c precio = [SELECT OSFPE_fld_Oportunidad_enlazada__c FROM OSFPE_obj_Precio_PPA__c LIMIT 1];
        precio.OSFPE_fld_Oportunidad_enlazada__c = oportunidad.id;
        update precio;

        Test.startTest();
        oportunidad.SyncedQuoteId = propuesta.Id;
        update oportunidad;
        Test.stopTest();
    }

    @isTest static void Update_Opportunity2() {
        Opportunity oportunidad = [Select id from Opportunity Limit 1];
        Quote propuesta = [Select id from Quote where name = 'Oferta 01' Limit 1];
        Id recordTypeIdQuo = [Select Id from RecordType where DeveloperName='OSFPE_rt_Oferta_Energia_Peru'].Id;
		oportunidad.SyncedQuoteId = null;
        update oportunidad;


        Quote propuesta02 = [Select id from Quote where name = 'Oferta 02' Limit 1];
        oportunidad.SyncedQuoteId = propuesta02.Id;
        OSFPE_obj_Precio_PPA__c precio = [SELECT OSFPE_fld_Oportunidad_enlazada__c FROM OSFPE_obj_Precio_PPA__c LIMIT 1];
        System.debug('precio '+precio);
        precio.OSFPE_fld_Oportunidad_enlazada__c = oportunidad.id;
        update precio;

        OSFPE_obj_Potencia__c potencia = [SELECT OSFPE_fld_Oportunidad_enlazada__c FROM OSFPE_obj_Potencia__c LIMIT 1];
        System.debug('potencia '+potencia);
        potencia.OSFPE_fld_Oportunidad_enlazada__c = oportunidad.id;
        update potencia;

        Test.startTest();
        oportunidad.SyncedQuoteId = propuesta02.Id;
        update oportunidad;
        Test.stopTest();
    }
}
