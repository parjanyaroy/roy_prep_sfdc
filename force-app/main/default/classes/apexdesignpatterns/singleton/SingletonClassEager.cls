public with sharing class SingletonClassEager {
    
    private static final SingletonClassEager instance = new SingletonClassEager();

    public String data {get ; private set ;}
    
    private SingletonClassEager() {
        data='Some Sample Data';
    }

    public static SingletonClassEager getClassInstance()
    {
        return instance;
    }
}