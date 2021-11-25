/**
 * @Description        : Prueba unitaria de la clase "OSFMX_ConsumosSectorSchedulable".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    	28/04/2021   		Edgar Maldonado     	Initial Version.
 * 1.1    	03/06/2021   		Edgar Maldonado     	Se corrije error "CANNOT_EXECUTE_FLOW_TRIGGER" de ambiente Integra.
 * 1.2    	10/06/2021   		Edgar Maldonado     	Ajuste por Sector__c obligatorio.
 * 1.3		01/09/2021			Edgar Maldonado			Se ajusta para no tomar en cuenta registros con ID_Instalacion__c 
 * 															distinto a null.
**/
@isTest
public class OSFMX_ConsumosSectorSchedulableTest {
	// Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testScheduledJob() {
        Account cuenta = new Account(Name='Prueba',Industry='Cemento',OSFMX_AccountContractID__c='1234567890',
                                    BillingStreet='test',BillingPostalCode='test',BillingCity='test',
                                    BillingStateCode='AG',BillingCountryCode='MX',OSFMX_RFC__c='ADM1705112JA');
        INSERT cuenta;
        
        OSMX_Consumos_Clientes__c consumoClientesItem = new OSMX_Consumos_Clientes__c();
        consumoClientesItem.Name = 'UnitTest';
        consumoClientesItem.Sector__c = 'Cemento';
        consumoClientesItem.Razon_Social__c='Data Center';
        consumoClientesItem.Id_Business_Partner__c='1234567890';
        consumoClientesItem.M1__c=1;
        consumoClientesItem.M2__c=2;
        consumoClientesItem.M3__c=3;
        consumoClientesItem.M4__c=4;
        consumoClientesItem.M5__c=5;
        consumoClientesItem.M6__c=6;
        consumoClientesItem.M7__c=7;
        consumoClientesItem.M8__c=8;
        consumoClientesItem.M9__c=9;
        consumoClientesItem.M10__c=10;
        consumoClientesItem.M11__c=11;
        consumoClientesItem.M12__c=12;
        INSERT consumoClientesItem;
        System.debug('########## OSFMX_ConsumosSectorSchedulableTest - testScheduledJob - consumoClientesItem: ' 
                    + consumoClientesItem);
         
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('OSFMX_ConsumosSectorSchedulableTest',
                                       CRON_EXP, 
                                       new OSFMX_ConsumosSectorSchedulable());
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
        // check that the scheduled job has executed
        CronTrigger cron = 
            [
                SELECT Id,CronJobDetail.Name,State,TimesTriggered,NextFireTime 
                FROM CronTrigger
                ORDER BY CreatedDate
                DESC LIMIT 1
            ];
        System.debug('##### OSFMX_ConsumosSectorSchedulableTest - cron: ' + cron);
        System.assertEquals('OSFMX_ConsumosSectorSchedulableTest', 
                            cron.CronJobDetail.Name, 
                            'La clase Apex no fué programada correctamente.');
        List<OSFMX_ConsumosSector__c> consumosSectorList = [
                SELECT Id,Sector__c,Volatibilidad__c 
                FROM OSFMX_ConsumosSector__c
            ];
        System.debug('########## OSFMX_ConsumosSectorSchedulableTest - testScheduledJob - consumosSectorList: ' 
                    + consumosSectorList);
        System.assertEquals(1, 
                            consumosSectorList.size(),
                            'No se generó el registro correspondiente en OSFMX_ConsumosSector__c.');
    }
}