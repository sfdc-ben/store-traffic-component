({
    getStoreRecord : function(component, event) {
        const selection = component.get('v.selection');
        console.log(selection[0].id);
        if (selection.length == 1) {
            var action = component.get("c.storeDetail");
            action.setParams({
                storeId: selection[0].id,
            });
            action.setCallback(this, function(response) {
                var store = response.getReturnValue();
                console.log(store);
                component.set("v.currentTraffic", store.Current_Traffic__c);
                component.set("v.maxTraffic", store.Maximum_Traffic__c);
                var cap = Math.floor( (store.Current_Traffic__c / store.Maximum_Traffic__c)  * 100);
                component.set("v.capacity", cap);
            })
            $A.enqueueAction(action);

        } 
    },

    changeTraffic : function(component, dir) {
        const selection = component.get("v.selection");
        console.log(selection[0].id);
        var action = component.get("c.changeTraffic");
        action.setParams({
            storeId: selection[0].id,
            changeDir: dir
        });
        action.setCallback(this, function(response) {
            var store = response.getReturnValue();
            console.log(store);
        })
        $A.enqueueAction(action);
    }
})
