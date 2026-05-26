class invalidAgeException extends exception{
    invalidAgeException(string message){
        super(message);
    }
}
class testcustomexception{
    static void checkage(int age)throws invalidageexception{
        if(age<18){
            throw new invalidageexception{
            }
            else{
                FileSystem.out.println("eligible");
            }
        }
        publiuc static void main(string args[]){
            try{
                checkage(15);

            }
            catch
            
        }
    }

}