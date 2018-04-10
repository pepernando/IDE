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
    
    //Nuestro famoso main para ejecutarlo
    public static void main(String[] arg){
        Ejecutor ejecutor = new Ejecutor();
        
        try{
            //En la siguiente linea le paso el siguiente comando
            // ls /etc/init.d que mostrara todos los demonios que estan corriendo
            // en el sistema.
            //ahora falta que ustedes pongan lo que requieran
            Process p = ejecutor.comando("ruby src/ide/Lexico.rb");
            System.out.println("Salida comando:");
            System.out.println(ejecutor.leerBufer(ejecutor.salidaComando(p)));
            /*System.out.println("Errores comando:");
            System.out.println(ejecutor.leerBufer(ejecutor.errorComando(p)));*/
        } catch(IOException e){
            System.out.println("No se ejecuto correctamente por las sgtes razones: ");
            System.exit(0);
        }
        
    }
}
