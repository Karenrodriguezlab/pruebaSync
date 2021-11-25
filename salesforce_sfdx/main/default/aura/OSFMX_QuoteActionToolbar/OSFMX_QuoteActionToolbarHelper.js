({

    getBaseUrl : function (component) {
        var action = component.get('c.getBaseUrl')
        action.setCallback(this, function (response) {
          var state = response.getState()
          if (component.isValid() && state === 'SUCCESS') {
            var result = response.getReturnValue()
            component.set('v.baseUrl', result)
          }
        })
        $A.enqueueAction(action)
      },

	setVFiframe : function(component, event, helper) {
		var d = new Date();
        var n = d.getTime();   
        var recId = component.get("v.recordId");
        var baseUrl = component.get("v.baseUrl");
        
        //component.set("v.ifmsrc", 'https://engielatam--devmexico--c.visualforce.com/apex/OSFMX_QuoteActionToolbar?Id=' + recId + '&t=' + n);
        component.set("v.ifmsrc", baseUrl+'/apex/OSFMX_QuoteActionToolbar?Id=' + recId + '&t=' + n);    
        console.log('::: vf: ' + component.get("v.ifmsrc"));
	}
})