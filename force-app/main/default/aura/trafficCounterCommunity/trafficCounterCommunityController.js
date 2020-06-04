({
    doInit : function(component, event, helper) {
        /* component.set('v.subscription', null);
        const empApi = component.find('empApi');
        const errorHandler = function (message) {
            console.error('Received error ', JSON.stringify(message));
          };
        empApi.onError($A.getCallback(errorHandler));
        helper.subscribe(component, event, helper);
        helper.displayToast(component, 'success', 'Ready to receive notifications.'); */
        
        var uid = $A.get("$SObjectType.CurrentUser.Id");

        var action = component.get("c.initSelection");
            action.setParams({
                UserId: uid,
            });
            action.setCallback(this, function(response) {
                var initResult = response.getReturnValue();
                console.log(initResult);
                if (initResult != null) {
                    const selection = component.get("v.selection");
                    selection.push(initResult);
                    component.set("v.selection", selection);
                    helper.getStoreRecord(component);
                    //helper.initiatePolling(component);
                };
            })
            $A.enqueueAction(action);
    },
    
    lookupSearch : function(component, event, helper) {
        const lookupComponent = event.getSource();
        const serverSearchAction = component.get('c.search');
        serverSearchAction.setParam('anOptionalParam', 'not used');
        lookupComponent.search(serverSearchAction);
    },

    clearErrorsOnChange: function(component, event, helper) {
        const selection = component.get('v.selection');
        const errors = component.get('v.errors');
        if (selection.length == 0) {
            console.log("Clear");
            component.set("v.currentTraffic", 0);
            component.set("v.maxTraffic", 0);
            component.set("v.capacity", 0);
            component.set("v.entrances", 1);
        } else {
            helper.getStoreRecord(component);
            //helper.initiatePolling(component);
        }

        if (selection.length && errors.length) {
            component.set('v.errors', []);
        }
        
    },

    clearSelection: function(component, event, helper) {
        component.set('v.selection', []);
    },

    increment: function(component, event, helper) {
        helper.changeTraffic(component,"Increment");
        var current = component.get("v.currentTraffic");
        var max = component.get("v.maxTraffic");
        current++;
        component.set("v.currentTraffic", current);
        var cap = Math.floor( (current / max)  * 100);
        component.set("v.capacity", cap);
    },

    decrement: function(component, event, helper) {
        helper.changeTraffic(component,"Decrement");
        var current = component.get("v.currentTraffic");
        var max = component.get("v.maxTraffic");
        current--;
        component.set("v.currentTraffic", current);
        var cap = Math.floor( (current / max)  * 100);
        component.set("v.capacity", cap);
    }
})