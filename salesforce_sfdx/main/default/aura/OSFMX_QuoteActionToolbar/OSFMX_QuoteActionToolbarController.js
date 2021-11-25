({
	doInit  : function(component, event, helper) {
        console.log('::: IN doInit');
        helper.setVFiframe(component, event, helper);
        console.log('::: OUT doInit');
	},    
    refreshRecord  : function(component, event, helper) {
        console.log('::: IN refreshRecord');
        helper.setVFiframe(component, event, helper);
        console.log('::: OUT doInit');
	}
})