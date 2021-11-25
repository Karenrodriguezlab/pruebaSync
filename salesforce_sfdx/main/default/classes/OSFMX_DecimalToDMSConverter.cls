global  class OSFMX_DecimalToDMSConverter implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String method, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Boolean res = false;
        if(method == 'convertDecimalToDMS') {
            res = convertDecimalToDMS(input, output, options);
        }
        return res;
    }
    
    private static Boolean convertDecimalToDMS(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        String lat = '';
        String lng = '';
        
        try {   
            Decimal latDec = (Decimal) options.get('latitude');
            Decimal lngDec = (Decimal) options.get('longitude');
            
            if(latDec <> null) {
                String  dirLat = latDec < 0 ? 'S' : 'N';
                lat = convert(latDec) + dirLat;
            }           
            if(lngDec <> null) {
                String dirLng = lngDec < 0 ? 'O' : 'E';
                lng = convert(lngDec) + dirLng;
            }
            
            output.put('lat', lat);
            output.put('lng', lng);
            output.put('coordenadas', lng+' '+lat);              
            System.debug('--> output : ' + output);
            
            return true;
        } catch(Exception e) {
            System.debug('--> e ' + e.getMessage());
            output.put('errorMsg',e.getMessage() + ' - ' + e.getStackTraceString());
            return false;
        }  
    }
    
    private static String convert(Decimal dec) {
        dec = dec.abs();

        Integer ent = dec.intValue();
        String  dms   = String.valueOf(ent) + '°';
        
        dec = dec - ent;
        dec = dec * 60;
        ent = dec.intValue();
        dms += String.valueOf(ent) + '\'';
        
        dec = dec - ent;
        dec = (dec * 60).setScale(2);
        dms = dms + String.valueOf(dec) + '"';
        
        return dms;
    }
}