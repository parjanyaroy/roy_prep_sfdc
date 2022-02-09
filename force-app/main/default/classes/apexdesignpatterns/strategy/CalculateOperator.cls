public with sharing class CalculateOperator {
    
    private  Calculate operation = null ;

    public CalculateOperator(String operand)
    {
        if(operand=='+'){
            operation = new Add();
        }
        else{
            operation = new Subtract();
        }
    }

    public Integer DoOperation(Integer x,Integer y)
    {
        return this.operation.operate(x,y);
    }

}