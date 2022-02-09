public with sharing class SingletonClass {
    
    public String data {get ; private set;} 
    private static SingletonClass instance = null;
    
    private SingletonClass()
    {
        data = 'SomeTestData';
        // Add Important work stuff over here that would provide a result which will
        // be constant in the current execution context
    }
    public static SingletonClass getClassInstance()
    {
        if(instance==null)
        {
            instance= new SingletonClass();
            return instance;
        }
        else {
            return instance;
        }
        
    }

}