/**
 * @Description        : Interfaz programable que calcula y almacena los valores para "OSFMX_ConsumosSector__c" 
 * 							en base al contenido de "OSMX_Consumos_Clientes__c".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    	28/04/2021   		Edgar Maldonado     	Initial Version.
 * 1.1    	25/05/2021   		Edgar Maldonado      	Por solicitud en pruebas integrales, 
 * 															Porcentaje_Volatibilidad__c se redondea a 2 enteros y 2 decimales.
 * 1.2    	03/06/2021   		Edgar Maldonado     	Se corrije error "CANNOT_EXECUTE_FLOW_TRIGGER" de ambiente Integra.
 * 1.3		01/09/2021			Edgar Maldonado			Se ajusta para no tomar en cuenta registros con ID_Instalacion__c 
 * 															distinto a null.
**/
global class OSFMX_ConsumosSectorSchedulable implements Schedulable {
    
	global void execute(SchedulableContext ctx) {
        System.debug('##### OSFMX_ConsumosSectorSchedulable - execute() - Context: ' + ctx);
        List<OSFMX_ConsumosSector__c> consumosSectorList = new List<OSFMX_ConsumosSector__c>();
        List<AggregateResult> sumBySectorList = [
            SELECT Sector__c,SUM(M1__c) m1Sum,SUM(M2__c) m2Sum,SUM(M3__c) m3Sum,SUM(M4__c) m4Sum,SUM(M5__c) m5Sum,
            		SUM(M6__c) m6Sum,SUM(M7__c) m7Sum,SUM(M8__c) m8Sum,SUM(M9__c) m9Sum,SUM(M10__c) m10Sum,
            		SUM(M11__c) m11Sum,SUM(M12__c) m12Sum
            FROM OSMX_Consumos_Clientes__c
            WHERE ID_Instalacion__c=null
            GROUP BY Sector__c
        ];
        List<OSFMX_ConsumosSector__c> consumosSectorToDeleteList = [
            SELECT Id
            FROM OSFMX_ConsumosSector__c
        ];
        
        for(AggregateResult resultItem:sumBySectorList){
            System.debug('##### OSFMX_ConsumosSectorSchedulable - execute() - resultItem: ' + resultItem);
            OSFMX_ConsumosSector__c consumosSectorItem = new OSFMX_ConsumosSector__c();
            String volatility;
            
            String sector = (String)resultItem.get('Sector__c');
            List<Double> sumByMonthList = new List<Double>();
            consumosSectorItem.M1__c=(Double)resultItem.get('m1Sum');
            sumByMonthList.add(consumosSectorItem.M1__c);
			consumosSectorItem.M2__c=(Double)resultItem.get('m2Sum');
            sumByMonthList.add(consumosSectorItem.M2__c);
            consumosSectorItem.M3__c=(Double)resultItem.get('m3Sum');
            sumByMonthList.add(consumosSectorItem.M3__c);
            consumosSectorItem.M4__c=(Double)resultItem.get('m4Sum');
            sumByMonthList.add(consumosSectorItem.M4__c);
            consumosSectorItem.M5__c=(Double)resultItem.get('m5Sum');
            sumByMonthList.add(consumosSectorItem.M5__c);
            consumosSectorItem.M6__c=(Double)resultItem.get('m6Sum');
            sumByMonthList.add(consumosSectorItem.M6__c);
            consumosSectorItem.M7__c=(Double)resultItem.get('m7Sum');
            sumByMonthList.add(consumosSectorItem.M7__c);
            consumosSectorItem.M8__c=(Double)resultItem.get('m8Sum');
            sumByMonthList.add(consumosSectorItem.M8__c);
            consumosSectorItem.M9__c=(Double)resultItem.get('m9Sum');
            sumByMonthList.add(consumosSectorItem.M9__c);
            consumosSectorItem.M10__c=(Double)resultItem.get('m10Sum');
            sumByMonthList.add(consumosSectorItem.M10__c);
            consumosSectorItem.M11__c=(Double)resultItem.get('m11Sum');
            sumByMonthList.add(consumosSectorItem.M11__c);
            consumosSectorItem.M12__c=(Double)resultItem.get('m12Sum');
            sumByMonthList.add(consumosSectorItem.M12__c);
			Double average = calculateAverage(sumByMonthList,false);
            Double standardDeviation = calculateStandardDeviation(sumByMonthList, average, false);
            Decimal volatilityPercentage = 0;
            if(average>0){
                volatilityPercentage = standardDeviation/average;
            }
            volatilityPercentage = volatilityPercentage.setScale(4);
            if(volatilityPercentage<=0.1){
                volatility='BAJA';
            }else{
                volatility='ALTA';
            }
            consumosSectorItem.Sector__c = sector;
            consumosSectorItem.Promedio_por_Sector__c = average;
            consumosSectorItem.Desviacion_Estandar_por_Sector__c = standardDeviation;
            consumosSectorItem.Porcentaje_Volatibilidad__c = volatilityPercentage;
            consumosSectorItem.Volatibilidad__c = volatility;
            consumosSectorList.add(consumosSectorItem);
        }
        
        DELETE consumosSectorToDeleteList;
        INSERT consumosSectorList;
        
        System.debug('##### OSFMX_ConsumosSectorSchedulable - execute() - consumosSectorList insertados: ' + consumosSectorList);
	}
    
    private Double calculateAverage(List<Double> numberList, Boolean doZerosCount){
        Integer counter=0;
        Double totalSum=0;
        
        System.debug('##### OSFMX_ConsumosSectorSchedulable - execute() - calculateAverage - numberList: ' + numberList);
        for(Double item:numberList){
            if(item!=null){
                totalSum+=item;
                if(item!=0||doZerosCount){
                    counter++;
                }
            }
        }
        if(counter>0){
            return totalSum/counter;
        }else{
            return 0;
        }
        
    }
    
    private Double calculateStandardDeviation(List<Double> numberList, Double average, Boolean doZerosCount){
        Integer counter=0;
        Double sumOfSquares=0;
        Double divideSumOfSquares=0;
        Double standardDeviation;
        
        for(Double item:numberList){
            if(item!=null){
                if(item!=0||doZerosCount){
                    counter++;
                    Double squareOfDistanceToAvg = (item - average) * (item - average);
                    sumOfSquares+=squareOfDistanceToAvg;
                }
            }
        }
        if(counter>0){
            divideSumOfSquares = sumOfSquares/counter;
        }
        standardDeviation = System.Math.sqrt(divideSumOfSquares);
        
        return standardDeviation;
    }
}