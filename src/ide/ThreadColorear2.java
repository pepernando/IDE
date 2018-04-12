/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

import java.awt.Color;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextPane;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

/**
 *
 * @author peper
 */
public class ThreadColorear2 extends Thread{
    
    private Ejecutor ejecutor;
    private String ruta;
    private StyledDocument doc;
    private FileReader f;
    private Style style;
    
    public ThreadColorear2(JTextPane jTextPaneCode,String ruta) {
        ejecutor = new Ejecutor();
        this.ruta = ruta;
        doc = jTextPaneCode.getStyledDocument();
        style = jTextPaneCode.addStyle("Estilo", null);
    }
    
    @Override
    public void run(){
        Process p;
        try {
            p = ejecutor.comando("ruby src/ide/Lexico.rb " + ruta);
        } catch (IOException ex) {
            Logger.getLogger(ThreadColorear2.class.getName()).log(Level.SEVERE, null, ex);
        }
        //ejecutor.leerBufer(ejecutor.salidaComando(p));
    }
    
    public void colorear() throws IOException {
        String linea = "";
        
        f = new FileReader("src/ide/styleddoc.txt");

        if (doc.getLength()>0) {
            try (BufferedReader b = new BufferedReader(f)) {

                //resetStyle();
                
                while ((linea = b.readLine()) != null) {
                    //cadaux += linea + "\n";
                    //System.out.println(linea);
                    String[] spt = linea.split("\\|");
                    //System.out.println("Offset:" + spt[0] + " Tipo:" + spt[1] + " Valor:" + spt[2]);
                    if ("PRESERVADA".equals(spt[1])) {
                        int auxini = Integer.parseInt(spt[0]) - spt[2].length()+1;
                        //System.out.println("auxini" + auxini);
                        findRemplace(auxini, Integer.parseInt(spt[0]), Color.BLUE);
                        //System.out.println("se cumple preservada");
                    } else if ("DIGITO".equals(spt[1])) {
                        int auxini = Integer.parseInt(spt[0]) - spt[2].length()+1;
                        findRemplace(auxini, Integer.parseInt(spt[0]), Color.cyan);
                        //System.out.println("se cumple digito");
                    } else if ("IDENTIFICADOR".equals(spt[1])) {
                        int auxini = Integer.parseInt(spt[0]) - spt[2].length()+1;
                        findRemplace(auxini, Integer.parseInt(spt[0]) + 1, Color.GREEN);
                        //System.out.println("se cumple digito");
                    }else if("OPERADOR".equals(spt[1])){
                        int auxini = Integer.parseInt(spt[0])-spt[2].length()+1;
                        findRemplace(auxini,Integer.parseInt(spt[0])+1,Color.BLACK);
                    }else if("CADENA".equals(spt[1])){
                        findRemplace(Integer.parseInt(spt[0]),Integer.parseInt(spt[2]),Color.orange);
                    }else if("LINECOMMENT".equals(spt[1])){
                        findRemplace(Integer.parseInt(spt[0]),Integer.parseInt(spt[2]),Color.LIGHT_GRAY);
                    }else if("ERROR".equals(spt[0])){
                        findRemplace(Integer.parseInt(spt[1]),Integer.parseInt(spt[1])+1,Color.red);
                    }else if("MULTCOMMENT".equals(spt[1])){
                        findRemplace(Integer.parseInt(spt[0]),Integer.parseInt(spt[2]),Color.lightGray);
                    }else if("INCOMPLETCAD".equals(spt[0])){
                        findRemplace(Integer.parseInt(spt[1]),doc.getLength(),Color.orange);
                    }else if("INCOMPLETCOMMENT".equals(spt[0])){
                        findRemplace(Integer.parseInt(spt[1]),doc.getLength(),Color.gray);
                    }
                }
            }
        }else{
            System.out.println("Error panel vacio");
        }
    }
        
    public void findRemplace(int ini, int fin, Color c) {
        StyleConstants.setForeground(style, c);
        int aux = fin - ini;
        doc.setCharacterAttributes(ini, fin, style, true);
    }
        
}
