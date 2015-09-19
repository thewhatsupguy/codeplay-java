package in.thewhatsupguy.codeplay;

import java.util.Scanner;
import java.util.Arrays;
import in.thewhatsupguy.codeplay.helloworld.HelloWorld;
public class CodePlay{

    public static void main(String args []){
        CodePlay.welcomeMessage();
        CodePlay.programList();
        String selectedProgram = CodePlay.userInput(new String[]{"1"});
        CodePlay.runProgram(selectedProgram);
    }

    private static void welcomeMessage(){
        System.out.println("Welcome to Code Play Runner");
    }

    private static void programList(){
        System.out.println("1 - Hello World");
    }

    private static String userInput(String [] validInputs){
        Scanner scannerInput = new Scanner(System.in);
        String userInput ;
        do{
            System.out.println("Please select a valid Program");
            userInput = scannerInput.nextLine();
        }while(!Arrays.asList(validInputs).contains(userInput));
        scannerInput.close();  
        return userInput;        
    }

    private static void runProgram(String selectedProgram){
        HelloWorld.main(new String [] {});
    }
}



