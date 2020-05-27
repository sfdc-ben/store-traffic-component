({
    lookupSearch : function(component, event, helper) {
        // Get the lookup component that fired the search event
        const lookupComponent = event.getSource();
        // Get the SampleLookupController.search server side action
        const serverSearchAction = component.get('c.search');
        // You can pass optional parameters to the search action
        // but you can only use setParam and not setParams to do so
        serverSearchAction.setParam('anOptionalParam', 'not used');
        // Pass the action to the lookup component by calling the search method
        lookupComponent.search(serverSearchAction);
    },

    clearErrorsOnChange: function(component, event, helper) {
        const selection = component.get('v.selection');
        const errors = component.get('v.errors');
        if (selection.length == 0) {
            console.log("Clear");
            component.set("v.currentTraffic", 0);
            component.set("v.maxTraffic", 5);
            component.set("v.capacity", 0);
        } else {
            helper.getStoreRecord(component);
        }

        if (selection.length && errors.length) {
            component.set('v.errors', []);
        }
        
    },

    clearSelection: function(component, event, helper) {
        component.set('v.selection', []);
    },

    increment: function(component, event, helper) {
        var current = component.get("v.currentTraffic");
        var max = component.get("v.maxTraffic");
        current++;
        console.log(current);
        component.set("v.currentTraffic", current);
        var cap = Math.floor( (current / max)  * 100);
        component.set("v.capacity", cap);
        console.log(cap);
        helper.changeTraffic(component,"Increment");
    },

    decrement: function(component, event, helper) {
        var current = component.get("v.currentTraffic");
        var max = component.get("v.maxTraffic");
        current--;
        console.log(current)
        component.set("v.currentTraffic", current);
        var cap = Math.floor( (current / max)  * 100);
        component.set("v.capacity", cap);
        console.log(cap);
        helper.changeTraffic(component,"Decrement");
    }
})