({
    getStoreRecord : function (component, event, helper) {
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
                component.set("v.entrances", store.Entrances__c);
                var cap = Math.floor( (store.Current_Traffic__c / store.Maximum_Traffic__c)  * 100);
                component.set("v.capacity", cap);
                if (store.Entrances__c > 1) {
                    console.log('Run Helper');
                    this.initiatePolling(component, event, helper);
                }
            })
            $A.enqueueAction(action);

        } 
    },

    changeTraffic : function(component, dir) {
        const selection = component.get("v.selection");
        var action = component.get("c.changeTraffic");
        action.setParams({
            storeId: selection[0].id,
            changeDir: dir
        });
        action.setCallback(this, function(response) {
            var store = response.getReturnValue();
        })
        $A.enqueueAction(action);
    },

    initiatePolling : function(component, event, helper) {
        var myFunction = function() {
            const selection = component.get('v.selection');;
            var action = component.get("c.storeDetail");
            action.setParams({
                storeId: selection[0].id,
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    console.log("Success: " + JSON.stringify(response.getReturnValue()));
                    var store = response.getReturnValue();
                    component.set("v.currentTraffic", store.Current_Traffic__c);
                    component.set("v.maxTraffic", store.Maximum_Traffic__c);
                    var cap = Math.floor( (store.Current_Traffic__c / store.Maximum_Traffic__c)  * 100);
                    component.set("v.capacity", cap);
                } else {
                    console.log("Error");
                }
                setTimeout($A.getCallback(myFunction), 5000);
            });
            $A.enqueueAction(action);
        }
        myFunction();
    },

    /* subscribe: function (component, event, helper) {
        const empApi = component.find("empApi");
        console.log(empApi);
        const channel = component.get('v.channel');
        console.log(channel);
        const replayId = -1;
        
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            // Process event (this is called each time we receive an event)
            console.log('Received event ', JSON.stringify(eventReceived));
            helper.onReceiveChange(component, eventReceived);
        }))
        .then(subscription => {
            // Confirm that we have subscribed to the event channel.
            // We haven't received an event yet.
            console.log('Subscribed to channel ', subscription.channel);
            // Save subscription to unsubscribe later
            component.set('v.subscription', subscription);
        });
        
        console.log(component.get("v.subscription"));
    },

    unsubscribe: function (component, event, helper) {
        const empApi = component.find('empApi');
        const channel = component.get('v.subscription').channel;
        const callback = function (message) {
          console.log('Unsubscribed from channel ' + message.channel);
        };
        empApi.unsubscribe(component.get('v.subscription'), $A.getCallback(callback));
    },

    onReceiveChange : function (component, message) {
        const selection = component.get("v.selection");
        const newChange = { store: message.data.payload.Store_Record_Id__c, changeVal: message.data.payload.Change_Value__c };
        console.log(selection[0].id);
        console.log(message.data.payload.Store_Record_Id__c);
        console.log(message.data.payload.Change_Value__c);
        if (newChange.store == selection[0].id) {
            var current = component.get("v.currentTraffic");
            var max = component.get("v.maxTraffic");
            console.log(current);
            current += newChange.changeVal;
            console.log(current);
            component.set("v.currentTraffic", current);
            var cap = Math.floor( (current / max)  * 100);
            component.set("v.capacity", cap);
            console.log(cap);
        }
        
    },

    displayToast: function (component, type, message) {
        const toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
          type: type,
          message: message
        });
        toastEvent.fire();
    } */
})
