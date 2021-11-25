trigger OSFPE_trg_Asigna_precio_potencia on Quote (before update) {
    //Verifica si el trigger es un update
    if(Trigger.isUpdate && Trigger.isBefore){
        //Lista de proyectos
        List<Quote> propuestas = new List<Quote>();
        //Lista de precios
        List<OSFPE_obj_Precio_PPA__c> idPrecios = new List<OSFPE_obj_Precio_PPA__c>();
        //Lista de potencias
        List<OSFPE_obj_Potencia__c> idPotencias = new List<OSFPE_obj_Potencia__c>();
        
        //Lista de precios
        List<OSFPE_obj_Precio_PPA__c> idPreciosOtros = new List<OSFPE_obj_Precio_PPA__c>();
        //Lista de potencias
        List<OSFPE_obj_Potencia__c> idPotenciasOtros = new List<OSFPE_obj_Potencia__c>();
        
        
        //Se obtiene el Id del tipo de registro de Oferta Energía Peru
        Id recordTypeIdQuo = [Select Id from RecordType where DeveloperName='OSFPE_rt_Oferta_Energia_Peru'].Id;
        Map<String, List<OSFPE_obj_Precio_PPA__c>> mapaPrecioOferta = new Map<String, List<OSFPE_obj_Precio_PPA__c>>();
        Map<String, List<OSFPE_obj_Precio_PPA__c>> mapaPrecioOportunidad = new Map<String, List<OSFPE_obj_Precio_PPA__c>>();
        Map<String, List<OSFPE_obj_Potencia__c>> mapaPotenciaOferta = new Map<String, List<OSFPE_obj_Potencia__c>>();
        Map<String, List<OSFPE_obj_Potencia__c>> mapaPotenciaOportunidad = new Map<String, List<OSFPE_obj_Potencia__c>>();
            
        for(OSFPE_obj_Precio_PPA__c precio : [Select Id, OSFPE_fld_Oportunidad_enlazada__c, OSFPE_fld_Oferta_enlazada__c from OSFPE_obj_Precio_PPA__c]) {
            if(mapaPrecioOferta.containsKey(precio.OSFPE_fld_Oferta_enlazada__c)){
                List<OSFPE_obj_Precio_PPA__c> lstPrecio = mapaPrecioOferta.get(precio.OSFPE_fld_Oferta_enlazada__c);
                lstPrecio.add(precio);
                mapaPrecioOferta.remove(precio.OSFPE_fld_Oferta_enlazada__c);
                mapaPrecioOferta.put(precio.OSFPE_fld_Oferta_enlazada__c,lstPrecio);
            }else{
                List<OSFPE_obj_Precio_PPA__c> lstPrecio = new List<OSFPE_obj_Precio_PPA__c>();
                lstPrecio.add(precio);
                mapaPrecioOferta.put(precio.OSFPE_fld_Oferta_enlazada__c,lstPrecio);
            }
            
            if(mapaPrecioOportunidad.containsKey(precio.OSFPE_fld_Oportunidad_enlazada__c)){
                List<OSFPE_obj_Precio_PPA__c> lstPrecio = mapaPrecioOportunidad.get(precio.OSFPE_fld_Oportunidad_enlazada__c);
                lstPrecio.add(precio);
                mapaPrecioOportunidad.remove(precio.OSFPE_fld_Oportunidad_enlazada__c);
                mapaPrecioOportunidad.put(precio.OSFPE_fld_Oportunidad_enlazada__c,lstPrecio);
            }else{
                List<OSFPE_obj_Precio_PPA__c> lstPrecio = new List<OSFPE_obj_Precio_PPA__c>();
                lstPrecio.add(precio);
                mapaPrecioOportunidad.put(precio.OSFPE_fld_Oportunidad_enlazada__c,lstPrecio);
            }
        }
    
        for(OSFPE_obj_Potencia__c potencia : [Select Id, OSFPE_fld_Oportunidad_enlazada__c, OSFPE_fld_Oferta_enlazada__c from OSFPE_obj_Potencia__c]) {
            if(mapaPotenciaOferta.containsKey(potencia.OSFPE_fld_Oferta_enlazada__c)){
                List<OSFPE_obj_Potencia__c> lstPotencia = mapaPotenciaOferta.get(potencia.OSFPE_fld_Oferta_enlazada__c);
                lstPotencia.add(potencia);
                mapaPotenciaOferta.remove(potencia.OSFPE_fld_Oferta_enlazada__c);
                mapaPotenciaOferta.put(potencia.OSFPE_fld_Oferta_enlazada__c,lstPotencia);
            }else{
                List<OSFPE_obj_Potencia__c> lstPotencia = new List<OSFPE_obj_Potencia__c>();
                lstPotencia.add(potencia);
                mapaPotenciaOferta.put(potencia.OSFPE_fld_Oferta_enlazada__c,lstPotencia);
            }
            
            if(mapaPotenciaOportunidad.containsKey(potencia.OSFPE_fld_Oportunidad_enlazada__c)){
                List<OSFPE_obj_Potencia__c> lstPotencia = mapaPotenciaOportunidad.get(potencia.OSFPE_fld_Oportunidad_enlazada__c);
                lstPotencia.add(potencia);
                mapaPotenciaOportunidad.remove(potencia.OSFPE_fld_Oportunidad_enlazada__c);
                mapaPotenciaOportunidad.put(potencia.OSFPE_fld_Oportunidad_enlazada__c,lstPotencia);
            }else{
                List<OSFPE_obj_Potencia__c> lstPotencia = new List<OSFPE_obj_Potencia__c>();
                lstPotencia.add(potencia);
                mapaPotenciaOportunidad.put(potencia.OSFPE_fld_Oportunidad_enlazada__c,lstPotencia);
            }
        }  
        
        List<OSFPE_obj_Precio_PPA__c> lstPrecioOtrosActualizada = new List<OSFPE_obj_Precio_PPA__c>();
        List<OSFPE_obj_Potencia__c> lstPotenciaOtrosActualizada = new List<OSFPE_obj_Potencia__c>();
        List<OSFPE_obj_Precio_PPA__c> lstPrecioActualizada = new List<OSFPE_obj_Precio_PPA__c>();
        List<OSFPE_obj_Potencia__c> lstPotenciaActualizada = new List<OSFPE_obj_Potencia__c>();
        
        //For que itera en todas las propuestas que se estén actualizando
        for(Quote prop : Trigger.new){
            //Se evalua si el tipo de registro de la oferta es Oferta Energía Peru
            if(prop.RecordTypeId == recordTypeIdQuo) {
                //Evalua si ha sido sincronizado
                if(prop.IsSyncing == TRUE){
                    //Obtiene los precios enlazados a la propuesta
                    idPrecios = mapaPrecioOferta.get(prop.Id);   
                    //Obtiene las potencias enlazadas a la propuesta
                    idPotencias = mapaPotenciaOferta.get(prop.Id);
                    
                    //Obtiene las potencias enlazadas a la propuesta
                    idPreciosOtros = mapaPrecioOportunidad.get(prop.OpportunityId);
                    //Obtiene las potencias enlazadas a la propuesta
                    idPotenciasOtros = mapaPotenciaOportunidad.get(prop.OpportunityId);
                
                    //Evalua si hay un registro de Precios PPA enlazado a la Oportunidad
                    if(idPreciosOtros!=null && idPreciosOtros.size()>0){
                        
                        //Itera en cada registro de Precios
                        for(OSFPE_obj_Precio_PPA__c otroPrecio : idPreciosOtros){ 
                            
                            //Evalua si el registro de Precios PPA no está enlazado a la nueva Propuesta a enlazar
                            if(otroPrecio.OSFPE_fld_Oferta_enlazada__c != prop.Id){
                                //Quita el enlace
                                otroPrecio.OSFPE_fld_Oportunidad_enlazada__c = null;
                                lstPrecioOtrosActualizada.add(otroPrecio);
                            }
                        }
                    }
                        
                    //Evalua si hay un registro de Potencias enlazado a la Oportunidad
                    if(idPotenciasOtros!=null && idPotenciasOtros.size()>0){
                        
                        //Itera en cada registro de Potencias
                        for(OSFPE_obj_Potencia__c otraPotencia : idPotenciasOtros){ 
                            
                            //Evalua si el registro de Potencias no está enlazado a la nueva Propuesta a enlazar
                            if(otraPotencia.OSFPE_fld_Oferta_enlazada__c != prop.Id){
                                
                                //Quita el enlace
                                otraPotencia.OSFPE_fld_Oportunidad_enlazada__c = null;
                                lstPotenciaOtrosActualizada.add(otraPotencia);
                            }
                        }
                    }
                            
                    //Evalua si tiene por lo menos un registro de Precios PPA
                    if(idPrecios!=null && idPrecios.size()>0 ){
                        
                        //Itera en cada registro de Precios
                        for(OSFPE_obj_Precio_PPA__c precio : idPrecios){   
                            
                            //Asigna Oportunidad de la Propuesta al registro de Precios PPA en caso no tenga Oporutnidad asignada
                            if(precio.OSFPE_fld_Oportunidad_enlazada__c == null){                            
                                precio.OSFPE_fld_Oportunidad_enlazada__c = prop.OpportunityId; 
                                //Actualiza registro de Precios PPA
                                lstPrecioActualizada.add(precio);
                            }                    
                        }
                    }
                        
                    //Evalua si tiene por lo menos un registro de Potencias
                    if(idPotencias!=null && idPotencias.size()>0){
                        
                        //Itera en cada registro de Potencias
                        for(OSFPE_obj_Potencia__c potencia : idPotencias){
                            
                            //Asigna Oportunidad de la Propuesta al registro de Potencias en caso no tenga Oportunidad asignada
                            if(potencia.OSFPE_fld_Oportunidad_enlazada__c == null){
                                potencia.OSFPE_fld_Oportunidad_enlazada__c = prop.OpportunityId;     
                                
                                //Actualiza registro de Potencias
                                lstPotenciaActualizada.add(potencia);                             
                            }
                        }
                    }
                }else{
                        
                    //Evalua si tiene por lo menos un registro de Precios PPA
                    if(idPrecios!=null && idPrecios.size()>0){
                        
                        //Itera en cada registro de Precios
                        for(OSFPE_obj_Precio_PPA__c precio : idPrecios){   
                            
                            //Desasigna Oportunidad de la Propuesta al registro de Precios PPA en caso tenga Oportunidad asignada
                            if(precio.OSFPE_fld_Oportunidad_enlazada__c != null){                            
                                precio.OSFPE_fld_Oportunidad_enlazada__c = null;
                                
                                //Actualiza registro de Precios PPA
                                lstPrecioActualizada.add(precio);
                            }
                        }                    
                    }
                        
                    //Evalua si tiene por lo menos un registro de Potencias
                    if(idPotencias!=null && idPotencias.size()>0){
                        
                        //Itera en cada registro de Potencias
                        for(OSFPE_obj_Potencia__c potencia : idPotencias){
                            
                            //Asigna Oportunidad de la Propuesta al registro de Potencias en caso no tenga Oportunidad asignada
                            if(potencia.OSFPE_fld_Oportunidad_enlazada__c != null){
                                potencia.OSFPE_fld_Oportunidad_enlazada__c = null;   
                                
                                //Actualiza registro de Potencias
                                lstPotenciaActualizada.add(potencia);                               
                            }
                        }
                    }
                }
            }
        }
        if(lstPrecioOtrosActualizada != null && lstPrecioOtrosActualizada.size() > 0){
            update lstPrecioOtrosActualizada;
        }
        if(lstPotenciaOtrosActualizada != null && lstPotenciaOtrosActualizada.size() > 0){
            update lstPotenciaOtrosActualizada;
        }
        if(lstPotenciaActualizada != null && lstPotenciaActualizada.size() > 0){
            update lstPotenciaActualizada;
        }
        if(lstPrecioActualizada != null && lstPrecioActualizada.size() > 0){
            update lstPrecioActualizada;
        }
    }
}