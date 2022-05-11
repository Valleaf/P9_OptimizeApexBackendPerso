public with sharing class DataFactory {

    public static Account createAccount(String name,boolean insertFlag) {
        Account account = new Account(Name = name);
        if(insertFlag) {
            insert account;
        }
        return account;
    }
}
