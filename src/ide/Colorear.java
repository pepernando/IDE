package ide;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import java.awt.Color;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextPane;
import javax.swing.SwingUtilities;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.BadLocationException;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

/**
 *
 * @author peper
 */
public class Colorear {
    //Estados
    private static final int INICIO = 1;
    private static final int ESPEROIGUAL = 4;
    private static final int CADENA = 8;
    private static final int INDETIFICADOR = 9;
    private static final int DIGITO = 10;
    private static final int POSIBLEDECIMAL = 11;
    private static final int POSIBLECOMENT = 12;
    private static final int INLINECOMENT = 13;
    private static final int MULTIPLECOMENT = 15;
    private static final int POSIBLESALIDA = 16;
    private static final int DECIMAL = 17;
    //Colores
    private static final Color COLOR_ERROR = Color.RED;
    private static final Color COLOR_DIGIT = Color.cyan;
    private static final Color COLOR_OPERADOR = Color.WHITE;
    private static final Color COLOR_IDENTIF = Color.GREEN;
    private static final Color COLOR_CADENA = Color.ORANGE;
    private static final Color COLOR_COMMENT = Color.LIGHT_GRAY;
    private static final Color COLOR_PRESERVADA = new Color(197,134,192);
    
     private String cadena;
    private int cadSize;
    private char caracter;
    private final String[] PRESERVADAS = {"main","if","then","else","end","do","while","repeat","until","read","write","float","integer","bool"};
    private final Style style;
    private final StyledDocument doc;
    private int estadoActual;
    private int puntero;
    private int offsetaux;
    private boolean cambios;
    
   public Colorear(JTextPane tp) {
        this.cadena = tp.getText();
        doc = tp.getStyledDocument();
        
        cadSize = this.cadena.length();
        caracter = ' ';
        style = tp.addStyle("Estilo", null);
        
        estadoActual = INICIO;
        puntero=0;
        offsetaux = 0;
        
        cambios = false;
     
    }
    
    
    public void colorear(){
        
        try {
            cadena = doc.getText(0,doc.getLength());
        } catch (BadLocationException ex) {
            Logger.getLogger(Colorear.class.getName()).log(Level.SEVERE, null, ex);
        }
        cadSize = this.cadena.length();
        
        estadoActual = INICIO;
        puntero = 0;
        
        while(cadSize>puntero){
        
            caracter = cadena.charAt(puntero);
            
            switch(estadoActual){
                case INICIO: 
                    switch(caracter){
                        case ' ':
                        case '\n':
                        case '\t':
                            break;
                        case ')':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '(':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '{':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '}':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '*':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '%':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case ',':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case ';':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;
                        case '+'://Como mas y menos existen solos, lexicamente no hay error y lo pinto
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break; 
                        case '-':
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = INICIO;
                            break;  
                        case '<'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = ESPEROIGUAL;
                            break;
                        case '>'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = ESPEROIGUAL;
                            break;
                        case '!'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = ESPEROIGUAL;
                            break;
                        case '='://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = ESPEROIGUAL;
                            break;
                        case ':'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = ESPEROIGUAL;
                            break;
                        case '/':
                            estadoActual = POSIBLECOMENT;
                            offsetaux = puntero;
                            break;
                        case '\"':
                            estadoActual = CADENA;
                            offsetaux = puntero;
                            break;
                        default:
                            if(Character.isDigit(caracter)){
                                setWord(puntero,puntero+1,COLOR_DIGIT);
                                estadoActual = DIGITO;
                            }else if (isCharacter(caracter)){
                               //setWord(puntero, puntero+1,COLOR_IDENTIF);
                               estadoActual = INDETIFICADOR;
                               offsetaux = puntero;
                            }else{                                    
                                setWord(puntero, puntero+1,COLOR_ERROR);
                                //System.out.println("Error en Colorear");
                                estadoActual = INICIO;
                            }
                            break;
                    }
                break;
            case ESPEROIGUAL: 
                if(caracter=='='){
                    setWord(puntero-1, puntero+1,COLOR_OPERADOR);
                }else{
                    if(cadena.charAt(puntero-1)==':'||cadena.charAt(puntero-1)=='='||cadena.charAt(puntero-1)=='!'){
                        setWord(puntero-1, puntero,COLOR_ERROR);
                    }
                    puntero--;
                }
                estadoActual = INICIO;
                break;
            case CADENA: 
                if(caracter=='\"'){
                    setWord(offsetaux,puntero, COLOR_CADENA);
                    estadoActual = INICIO;
                }
                break;
            case POSIBLECOMENT:
                    switch (caracter) {
                    case '/':
                            estadoActual = INLINECOMENT;
                        break;
                    case '*':
                            estadoActual = MULTIPLECOMENT;
                        break;
                    default:
                            setWord(puntero-1,puntero, COLOR_OPERADOR);
                            estadoActual = INICIO;
                            puntero--;
                        break;    
                    }
                break;
            case INLINECOMENT:
                    if(caracter=='\n'){
                        setWord(offsetaux, puntero-1,COLOR_COMMENT);
                        estadoActual = INICIO;
                    }
                break;
            case MULTIPLECOMENT:
                    if(caracter=='*'){
                        estadoActual = POSIBLESALIDA;
                    }
                break;
            case POSIBLESALIDA:
                    if(caracter=='/'){
                        setWord(offsetaux, puntero, COLOR_COMMENT);
                        estadoActual = INICIO;
                    }else{
                        estadoActual = MULTIPLECOMENT;
                    }
                break;
            case DIGITO:
                    if(caracter=='.'){
                        estadoActual = POSIBLEDECIMAL;
                        offsetaux = puntero;
                    } else {
                        puntero--;
                        estadoActual = INICIO;
                    }
                break;
            case POSIBLEDECIMAL:
                    if(!Character.isDigit(caracter)){
                        setWord(offsetaux,offsetaux+1,COLOR_ERROR);
                        estadoActual = INICIO;
                    }else{
                        estadoActual = DECIMAL;
                    }
                break;
            case DECIMAL:
                    if(!Character.isDigit(caracter)){
                        estadoActual = INICIO;
                        puntero--;
                    }
                break;
            case INDETIFICADOR:
                if(!isCharacter(caracter) && caracter!='_' && !Character.isDigit(caracter)){
                        
                    String wordaux = cadena.substring(offsetaux, puntero);
                    boolean bandaux = false;
                        
                    for (String PRESERVADAS1 : PRESERVADAS) {
                        if (PRESERVADAS1.equals(wordaux)) {
                            setWord(offsetaux, puntero, COLOR_PRESERVADA);
                            bandaux = true;
                            break;
                        }
                    }
                    
                    if(bandaux==false){
                        setWord(offsetaux,puntero, COLOR_IDENTIF);
                    }
                         
                    puntero--;
                    estadoActual=INICIO;
                }
                break;
            }
            
            puntero++;
        }
        
        
        switch (estadoActual) {
            case CADENA:
                setWord(offsetaux,doc.getLength()-1,COLOR_CADENA);
                break;
            case POSIBLECOMENT:
            case MULTIPLECOMENT:
            case INLINECOMENT:
                setWord(offsetaux,doc.getLength()-1,COLOR_COMMENT);
                break;
            case POSIBLEDECIMAL:
            case ESPEROIGUAL:
                if(cadena.charAt(puntero-1)!='<'&&cadena.charAt(puntero-1)!='>'){
                    setWord(puntero-1,puntero, COLOR_ERROR);
                }
                break;
            case INDETIFICADOR:
                    String wordaux = cadena.substring(offsetaux, puntero);
                    boolean bandaux = false;
                    for (String PRESERVADAS1 : PRESERVADAS) {
                        if (PRESERVADAS1.equals(wordaux)) {
                            setWord(offsetaux, puntero, COLOR_PRESERVADA);
                            bandaux = true;
                            break;
                        }
                    }
                    if(bandaux==false){
                        setWord(offsetaux,puntero, COLOR_IDENTIF);
                    }
                break;
            default:
                break;
        }
            
        //System.out.println("Estado Final es:" + estadoActual);
    }
    
    public void setWord(int ini, int fin, Color c) {
        StyleConstants.setForeground(style, c);
        if(fin<=doc.getLength()){
            doc.setCharacterAttributes(ini, fin, style, true);
        }else{
            System.out.println("Se intenta pintar en un carater fuera del indice");
        }
    }
    
    private static boolean isCharacter(char aux){
        return (aux >= 'a' && aux <= 'z') || (aux >= 'A' && aux <= 'Z');
    }
    
    
    private void RunnableColorear(){
        Runnable resaltar = () -> {
            colorear();
        };
        SwingUtilities.invokeLater(resaltar);
       
    }
    
    public void agregarellistener(){
        doc.addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                //System.out.println("insert");
                /*try {
                    colorear();
                } catch (BadLocationException ex) {
                    Logger.getLogger(Colorear.class.getName()).log(Level.SEVERE, null, ex);
                }*/
                RunnableColorear();
                
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                //System.out.println("remove");
                RunnableColorear();
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                
            }
        });
    }
}
