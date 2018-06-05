/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

/**
 *
 * @author peper
 */
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class Ejecutor{
    
    public Process comando(String c) throws IOException{
        return Runtime.getRuntime().exec(c);
    }
    
    public BufferedReader salidaComando(Process p){
        return new BufferedReader(new InputStreamReader(p.getInputStream()));
    }
    
    public BufferedReader errorComando(Process p){
        return new BufferedReader(new InputStreamReader(p.getErrorStream()));
    }
    
    public String leerBufer(BufferedReader b) throws IOException{
        String aux = "", aux2 = "";
        while( (aux2 = b.readLine()) != null ){
            aux+=String.format(" %s \n",aux2);
        }
        if("".equals(aux)) return "SIN ERRORES!";
        return aux;
    }
    
}
