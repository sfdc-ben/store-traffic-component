 public with sharing class StoreTrafficController {
    
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds, String anOptionalParam) {
        // We're not using anOptionalParam parameter
        // it's just here to demonstrate custom params
        
        // Prepare query paramters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
            Store__c (Id, Name, Max_Traffic__c, Store_Number__c WHERE id NOT IN :selectedIds)
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

    @AuraEnabled(cacheable=true)
    public static Store__c storeDetail(String storeId) {
        
        Store__c thisStore = [SELECT Id, Current_Traffic__c, Max_Traffic__c FROM Store__c WHERE Id = :storeId];
        System.debug(thisStore);
        return thisStore;
    }

    @AuraEnabled
    public static Store__c changeTraffic(String storeId, String changeDir) {
        System.debug(storeId);

        Store__c thisStore = [SELECT Id, Current_Traffic__c, Max_Traffic__c FROM Store__c WHERE Id = :storeId];
        System.debug(thisStore);
        
        if (changeDir == 'Increment') {
            thisStore.Current_Traffic__c++;
        }

        if (changeDir == 'Decrement') {
            thisStore.Current_Traffic__c--;
        }

        System.debug(thisStore);
        update thisStore;

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
