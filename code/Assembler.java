import java.util.Arrays;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class Assembler{
    public static void main (String args[]){
        //open file and read from file
        File assemblyFile = new File("program1_nospace.txt");
        File outputFile = new File("output_file.txt");
        FileWriter writer;
        Scanner sc;
        try{
            writer = new FileWriter("outputFile");
            sc = new Scanner(assemblyFile);
            int lineCount = 0;
            while(sc.hasNextLine()) {
                String line = sc.nextLine();
                lineCount++;
                //add $1, $2
                if(line.length() == 0){
                    continue;
                }
                String machCode;
                if(line.indexOf('/') != -1 && line.indexOf('/') != 0){
                    machCode = parseInstr(lineCount, line.substring(0, line.indexOf('/')));
                } else {
                    machCode = parseInstr(lineCount, line);
                }
                 
                if(machCode.length() == 0){
                    continue;
                }
                writer.write(machCode + "\n");
                
            }
            sc.close();
            writer.close();
        } catch(IOException e){
            e.printStackTrace();
        }
        
    }

    public static String parseInstr(int lineCount, String instr){
        String opcode = instr.substring(0, instr.indexOf(' ')).toLowerCase();
        String operands = instr.substring(instr.indexOf(' '));
        String operandBits="";
        switch(opcode){
            case "cpy": 
                opcode = "000";
                operandBits = parseOperandDouble(operands);
                break;
            case "load":
                opcode = "001";
                operandBits = parseOperandSingle(operands) + "000";
                break;
            case "store":
                opcode = "001";
                operandBits = parseOperandSingle(operands) + "001";
                break;
            case "or":
                opcode = "001";
                operandBits = parseOperandSingle(operands) + "010";
                break;
            case "andi":
                opcode = "001";
                operandBits = parseOperandSingle(operands);
                if(parseImm(operands).equals("1")){
                    operandBits += "011";
                } else if(parseImm(operands).equals("3")){
                    operandBits += "111";
                } else {
                    System.out.println("invalid andi immediate, line " + lineCount);
                }
                break;
            case "lsr":
                opcode = "010";
                operandBits = parseOperandSingle(operands);
                if(parseImm(operands).equals("1")){
                    operandBits += "010";
                } else if(parseImm(operands).equals("4")){
                    operandBits += "110";
                } else {
                    System.out.println("invalid lsr immediate, line " + lineCount);
                }
                break;
            case "lsl":
                opcode = "010";
                operandBits = parseOperandSingle(operands);
                if(parseImm(operands).equals("1")){
                    operandBits += "000";
                } else if(parseImm(operands).equals("4")){
                    operandBits += "100";
                } else {
                    System.out.println("invalid lsl immediate, line " + lineCount);
                }
                break;
            case "addi":
                opcode = "010";
                operandBits = parseOperandSingle(operands);
                String imm = parseImm(operands);
                if(imm.equals("1")){
                    operandBits += "001";
                } else if (imm.equals("5")){
                    operandBits += "011";
                } else if (imm.equals("15")){
                    operandBits += "101";
                } else if (imm.equals("-1")) {
                    operandBits += "111";
                } else {
                    System.out.println("invalid addi immediate, line " + lineCount);
                }
                break;
            case "beq":
                opcode = "011";
                operandBits = parseOperandDouble(operands);
                break;
            case "add":
                opcode = "100";
                operandBits = parseOperandDouble(operands);
                break;
            case "xor":
                opcode = "101";
                operandBits = parseOperandDouble(operands);
                break;
            case "and":
                opcode = "110";
                operandBits = parseOperandDouble(operands);
                break;
            case "set":
                opcode = "111";
                operandBits = operands.substring(operands.indexOf('#')+1, operands.indexOf('#')+5);
                operandBits += fitBitWidth(2, Integer.toBinaryString(Character.getNumericValue(operands.charAt(operands.indexOf('$')+1))));
                break;
            case "//":
                opcode = "";
                break;
            default:
                opcode = "";
                System.out.println("invalid instruction on line " + lineCount);
        }

        return opcode + operandBits;
    }

    public static String parseOperandDouble(String operands){
        String oper = "";
        oper += fitBitWidth(3, Integer.toBinaryString(Character.getNumericValue(operands.charAt(operands.indexOf('$')+1))));
        oper += fitBitWidth(3, Integer.toBinaryString(Character.getNumericValue(operands.charAt(operands.lastIndexOf('$')+1))));
        return oper;
    }

    public static String parseOperandSingle(String operands){
        String oper = "";
        oper += fitBitWidth(3, Integer.toBinaryString(Character.getNumericValue(operands.charAt(operands.indexOf('$')+1))));
        return oper;
    }

    public static String parseImm(String operands){
        String oper = "";
        String imm = "";
        if(operands.length() < operands.indexOf('#')+3){
            imm = operands.substring(operands.indexOf('#')+1);
        } else {
            imm = operands.substring(operands.indexOf('#')+1, operands.indexOf('#')+3).trim();   
        }
        oper += Integer.parseInt(imm);
        return oper;
    }
    public static String fitBitWidth(int width, String bits){
        while(bits.length() < width){
            bits = "0" + bits;
        }
        return bits;
    }


    //public static parseFunc();
    

}
