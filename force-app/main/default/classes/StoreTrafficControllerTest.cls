@isTest
private class StoreTrafficControllerTest {
    @isTest static void testSearch() {
        Test.startTest();
        
        Store__c store1 = new Store__c(Name='100 - Store 1',Entrances__c=1,Store_Number__c='100',Current_Traffic__c=0,Maximum_Traffic__c=50);
        insert store1; 

        Store__c store2 = new Store__c(Name='200 - Store 2',Entrances__c=1,Store_Number__c='200',Current_Traffic__c=0,Maximum_Traffic__c=50);
        insert store2;

        Store__c store3 = new Store__c(Name='105 - Store 3',Entrances__c=2,Store_Number__c='105',Current_Traffic__c=0,Maximum_Traffic__c=50);
        insert store3;
        
        id[] fixedSearchResults = new id[3];
   		fixedSearchResults[0] = store1.id;
        fixedSearchResults[1] = store2.id;
        fixedSearchResults[2] = store3.id;
        
  		Test.setFixedSearchResults(fixedSearchResults);

        String initSelect = Id.valueOf(store1.Id);
        List<String> strings = new List<String>();
        strings.add(initSelect);

        //Perform test
        
        List<StoreTrafficController.LookupSearchResult> retList = StoreTrafficController.search('store',strings,'');
        Integer size = retList.size();
        System.assertEquals(2, size);
		
        Test.stopTest();
    }

    @isTest static void testInitSelection() {
        Boolean success = true;
        
        try {
            StoreTrafficController.LookupSearchResult retVar = StoreTrafficController.initSelection('');
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(!success);
        }
    }

    @isTest static void testStoreDetail() {
        Test.startTest();

        Store__c store1 = new Store__c(Name='100 - Store 1',Entrances__c=1,Store_Number__c='100',Current_Traffic__c=14,Maximum_Traffic__c=50);
        insert store1; 

        Store__c storeRet = StoreTrafficController.storeDetail(store1.Id);
        System.assertEquals(store1.Current_Traffic__c, storeRet.Current_Traffic__c);

        Test.stopTest();
    }

    @isTest static void testChangeTrafficUpSuccess() {
        Test.startTest();

        Store__c store1 = new Store__c(Name='100 - Store 1',Entrances__c=1,Store_Number__c='100',Current_Traffic__c=14,Maximum_Traffic__c=50);
        insert store1; 

        Decimal updatedCount = store1.Current_Traffic__c + 1;

        Store__c storeRet = StoreTrafficController.ChangeTraffic(store1.Id, 'Increment');
        system.assertEquals(updatedCount, storeRet.Current_Traffic__c);

        Test.stopTest();
    }

    @isTest static void testChangeTrafficDownSuccess() {
        Test.startTest();

        Store__c store1 = new Store__c(Name='100 - Store 1',Entrances__c=1,Store_Number__c='100',Current_Traffic__c=14,Maximum_Traffic__c=50);
        insert store1; 

        Decimal updatedCount = store1.Current_Traffic__c -1;

        Store__c storeRet = StoreTrafficController.ChangeTraffic(store1.Id, 'Decrement');
        system.assertEquals(updatedCount, storeRet.Current_Traffic__c);

        Test.stopTest();
    }
    @isTest static void testChangeTrafficUpError() {
        Test.startTest();

        Store__c store1 = new Store__c(Name='100 - Store 1',Entrances__c=1,Store_Number__c='100',Current_Traffic__c=50,Maximum_Traffic__c=50);
        insert store1; 
        
        Boolean success = true;
        
        try {
            Store__c storeRet = StoreTrafficController.ChangeTraffic(store1.Id, 'Increment');
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(!success);
        }

        Test.stopTest();
    }
}