class multicatch{
    public static void main(string args[]){
         try{
            int a[]=new int[5];
        int x=10/0;
        }
        catch(arrayindexoutofboundexception e){
            system.out.println("array index error");
        }
        catch0(arithmeticexception e){
            system.out.println("divide by zero error");
        }
    }
}