public with sharing class StoreTrafficController {
    
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds, String anOptionalParam) {
        // Prepare query paramters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
            Store__c (Id, Name, Maximum_Traffic__c, Store_Number__c WHERE id NOT IN :selectedIds)
            LIMIT :MAX_RESULTS];

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Accounts & convert them into LookupSearchResult
        String storeIcon = 'custom:custom50';
        Store__c [] stores = ((List<Store__c>) searchResults[0]);
        for (Store__c store : stores) {
            results.add(new LookupSearchResult(store.Id, 'Store', storeIcon, store.Name, 'Store • '+ store.Store_Number__c));
        }
        return results;
    }

    @AuraEnabled
    public static LookupSearchResult initSelection(String UserId){

        String storeIcon = 'custom:custom50';
        
        if (UserId == '') {
                throw new AuraHandledException('No User Provided');
        }
        
        Id accId = [SELECT contactId, contact.AccountId FROM User WHERE Id = :UserId].contact.AccountId;
        Store__c store = [SELECT Id, Name, Maximum_Traffic__c, Store_Number__c FROM Store__c WHERE Store_Account__c = :accId];

        LookupSearchResult result = new LookupSearchResult(store.Id, 'Store', storeIcon, store.Name, 'Store • '+ store.Store_Number__c);

        return result;
    }

    @AuraEnabled
    public static Store__c storeDetail(String storeId) {
        
        Store__c thisStore = [SELECT Id, Entrances__c, Current_Traffic__c, Maximum_Traffic__c FROM Store__c WHERE Id = :storeId];
        System.debug(thisStore);
        return thisStore;
    }

    @AuraEnabled
    public static Store__c changeTraffic(String storeId, String changeDir) {
        System.debug(storeId);

        Store__c thisStore = [SELECT Id, Entrances__c, Current_Traffic__c, Maximum_Traffic__c FROM Store__c WHERE Id = :storeId];
        System.debug(thisStore);

        Store_Date__c storeDateToday = null;
        System.debug(storeDateToday);
        Date today = date.today();

        try{
            storeDateToday = [SELECT Id, Total_Traffic__c, Store__c, Date__c FROM Store_Date__c WHERE Store__c = :thisStore.Id AND Date__c = :today];
        } catch(Exception ex){
            storeDateToday = new Store_Date__c(Store__c=thisStore.Id,Date__c=today,Total_Traffic__c=0);
            insert storeDateToday;
        }

        
        System.debug(storeDateToday);

        Integer changeVal = 0;
        
        if (changeDir == 'Increment') {
            if (thisStore.Current_Traffic__c >= thisStore.Maximum_Traffic__c) {
                throw new AuraHandledException('Cannot increase traffic');
            }
            thisStore.Current_Traffic__c++;
            changeVal = 1;
            storeDateToday.Total_Traffic__c++;
        }

        if (changeDir == 'Decrement') {
            thisStore.Current_Traffic__c--;
            changeVal = -1;
        }
    
        System.debug(thisStore);
        System.debug(storeDateToday);
        update thisStore;
        update storeDateToday;

        //Traffic_Change_Event__e trafEvent = new Traffic_Change_Event__e(Store_Record_Id__c=storeId,Change_Value__c=changeVal);
        //Database.SaveResult result = EventBus.publish(trafEvent);
        //System.debug(trafEvent);

        //if (result.isSuccess()) {
        //    System.debug('Successfully published event.');
        //} else {
        //    for(Database.Error err : result.getErrors()) {
        //        System.debug('Error returned: ' +
        //                    err.getStatusCode() +
        //                    ' - ' +
        //                    err.getMessage());
        //    }
        //}       

        return thisStore;
    }

    public class LookupSearchResult {

        private Id id;
        private String sObjectType;
        private String icon;
        private String title;
        private String subtitle;
    
        public LookupSearchResult(Id id, String sObjectType, String icon, String title, String subtitle) {
            this.id = id;
            this.sObjectType = sObjectType;
            this.icon = icon;
            this.title = title;
            this.subtitle = subtitle;
        }
    
        @AuraEnabled
        public Id getId() {
            return id;
        }
    
        @AuraEnabled
        public String getSObjectType() {
            return sObjectType;
        }
    
        @AuraEnabled
        public String getIcon() {
            return icon;
        }
    
        @AuraEnabled
        public String getTitle() {
            return title;
        }
    
        @AuraEnabled
        public String getSubtitle() {
            return subtitle;
        }
    }
}