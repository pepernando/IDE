/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

import java.awt.Color;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextPane;
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
    private static final int ASIGNACION = 2;
    private static final int MENORIGUAL = 3;
    private static final int MAYORIGUAL = 4;
    private static final int COMPARACION = 5;
    private static final int CADENA = 6;
    private static final int INDENTIFICADOR = 7;
    private static final int DIGITO = 8;
    private static final int POSIBLECOMMENT = 9;
    private static final int POSIBLEDECIMAL = 10;
    private static final int DIFERNETE = 11;
    private static final int MULTICOMENT = 12;
    private static final int INLINECOMMENT = 13;
    private static final int POSIBLESALIDA = 14;
    private static final int DECIMAL = 15;
    //Colores
    private static final Color COLOR_ERROR = Color.RED;
    private static final Color COLOR_DIGIT = Color.cyan;
    private static final Color COLOR_OPERADOR = Color.BLACK;
    private static final Color COLOR_IDENTIF = Color.GREEN;
    private static final Color COLOR_CADENA = Color.ORANGE;
    private static final Color COLOR_COMMENT = Color.LIGHT_GRAY;
    private static final Color COLOR_PRESERVADA = Color.BLUE;

    
    private String cadena;
    private int cadSize;
    private char caracter;
    private final String[] PRESAERVADAS = {"main","if","then","else","end","do","while","repeat","until","read","write","float","integer","bool"};
    private Style style;
    private StyledDocument doc;
    private int estadoActual;
    private int puntero;
    private int offsetaux;
    
    @SuppressWarnings("empty-statement")
    public Colorear(JTextPane tp) {
        this.cadena = tp.getText();
        doc = tp.getStyledDocument();
        
        cadSize = this.cadena.length();
        caracter = ' ';
        style = tp.addStyle("Estilo", null);
        estadoActual = INICIO;
        
        puntero=0;
        offsetaux = 0;
       
        
    }
    
    
    public void colorear() throws BadLocationException{
        
        //StyleConstants.setForeground(style, Color.black);
        //doc.setCharacterAttributes(0, doc.getLength(), style, true);
        
        cadena = doc.getText(0,doc.getLength());
        cadSize = this.cadena.length();
        estadoActual = INICIO;
        puntero = 0;
        
        while(cadSize>puntero){
        
            caracter = cadena.charAt(puntero);
            switch(estadoActual){
                case INICIO: 
                    switch(caracter){
                        case ' ':
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
                            estadoActual = MENORIGUAL;
                            break;
                        case '>'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            setWord(puntero, puntero+1,COLOR_OPERADOR);
                            estadoActual = MAYORIGUAL;
                            break;
                        case '!'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = DIFERNETE;
                            break;
                        case '='://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = COMPARACION;
                            break;
                        case ':'://como menor si existe solo lo pinto, pero igual reviso el siguente
                            estadoActual = ASIGNACION;
                            break;
                        case '/':
                            estadoActual = POSIBLECOMMENT;
                            break;
                        case '\"':
                            estadoActual = CADENA;
                            offsetaux = puntero;
                            break;
                        default:
                            if(Character.isDigit(caracter)){
                                estadoActual = DIGITO;
                                offsetaux = puntero;
                            }else if (!(caracter >= 'a' && caracter <= 'z') || !(caracter >= 'A' && caracter <= 'Z')){
                               setWord(puntero, puntero+1,COLOR_IDENTIF);
                               // estadoActual = INDENTIFICADOR;
                                ///offsetaux = puntero;
                            }else{                                    
                                setWord(puntero, puntero+1,COLOR_ERROR);
                                estadoActual = INICIO;
                            }
                            break;
                    }
                break;
            case MENORIGUAL: 
                if(caracter=='='){
                    setWord(puntero, puntero+1,COLOR_OPERADOR);
                }else{
                    puntero--;
                }
                estadoActual = INICIO;
                break;
            case MAYORIGUAL: 
                if(caracter=='='){
                    setWord(puntero, puntero+1,COLOR_OPERADOR);
                }else{
                    puntero--;
                }
                estadoActual = INICIO;
                break;
            case COMPARACION: 
                if(caracter=='='){
                    setWord(puntero-1, puntero+1,COLOR_OPERADOR);
                }else{
                    puntero--;
                    setWord(puntero, puntero+1,COLOR_ERROR);
                }
                estadoActual = INICIO;
                break;
            case DIFERNETE: 
                if(caracter=='='){
                    setWord(puntero-1, puntero+1,COLOR_OPERADOR);
                }else{
                    puntero--;
                    setWord(puntero, puntero+1,COLOR_ERROR);
                }
                estadoActual = INICIO;
                break;
            case ASIGNACION: 
                if(caracter=='='){
                    setWord(puntero-1, puntero+1,COLOR_OPERADOR);
                }else{
                    puntero--;
                    setWord(puntero, puntero+1,COLOR_ERROR);
                }
                estadoActual = INICIO;
                break;
            case CADENA: 
                if(caracter=='\"'){
                    setWord(offsetaux, puntero+1,COLOR_CADENA);
                    estadoActual = INICIO;
                }
                break;
            case INDENTIFICADOR: 
                if(caracter != '_' || !Character.isDigit(caracter)||!(caracter >= 'a' && caracter <= 'z')||!(caracter >= 'A' && caracter <= 'Z')){
                    /*boolean bandaux=false;
                    for(String actual:PRESAERVADAS){
                        //if(doc.getText(offsetaux,puntero-1).equals(actual)){
                        //    bandaux = true;
                        //}
                        //System.out.println(actual);
                    }
                    System.out.println(doc.getText(offsetaux,puntero));
                    if(bandaux){
                        //setWord(offsetaux, puntero,COLOR_PRESERVADA);
                    }else{
                        //setWord(offsetaux, puntero,COLOR_IDENTIF);
                    }*/
                    estadoActual = INICIO;
                }
                break;
            case DIGITO: 
                if(caracter=='.'){
                    estadoActual = POSIBLEDECIMAL;
                }else if(!Character.isDigit(caracter)){
                    setWord(offsetaux,puntero+1,COLOR_DIGIT);
                    puntero--;
                    estadoActual = INICIO;
                }
                break;
            case POSIBLEDECIMAL: 
                if(!Character.isDigit(caracter)){
                    setWord(offsetaux,puntero+1,COLOR_DIGIT);
                    puntero-=1;
                    estadoActual=INICIO;
                }else{
                    estadoActual = DECIMAL;
                }
                break;
            case DECIMAL:
                if(!Character.isDigit(caracter)){
                    setWord(offsetaux,puntero,COLOR_DIGIT);
                    puntero--;
                    estadoActual = INICIO;
                }
            case POSIBLECOMMENT: 
                switch (caracter) {
                    case '/':
                        estadoActual = INLINECOMMENT;
                        offsetaux = puntero-1;
                        break;
                    case '*':
                        estadoActual = MULTICOMENT;
                        offsetaux = puntero-1;
                        break;
                    default:
                        setWord(puntero-1, puntero,COLOR_OPERADOR);
                        puntero--;
                        estadoActual = INICIO;
                        break;
                }
                break;
            case INLINECOMMENT:
                if(caracter=='\n'){
                    setWord(offsetaux,puntero,COLOR_COMMENT);
                    estadoActual = INICIO;
                }
                break;
            case MULTICOMENT: 
                    if(caracter=='*'){
                        estadoActual=POSIBLESALIDA;
                    }
                break;
            case POSIBLESALIDA: 
                    if(caracter=='/'){
                        setWord(offsetaux,puntero+1,COLOR_COMMENT);
                        estadoActual=INICIO; 
                    }else{
                        estadoActual=MULTICOMENT;
                    }
                break;
            }
            puntero++;
        }
        
        if(estadoActual==CADENA){
            setWord(offsetaux,doc.getLength()-1,COLOR_CADENA);
            System.out.println("Cadena Icompleta. con offset: " + offsetaux);
        }else if(estadoActual==MULTICOMENT||estadoActual==POSIBLESALIDA){
            setWord(offsetaux,doc.getLength()-1,COLOR_COMMENT);
            System.out.println("Comentario Incompleto");
        }
        
    }
    
    public void setWord(int ini, int fin, Color c) {
        StyleConstants.setForeground(style, c);
        if(fin<doc.getLength()){
            doc.setCharacterAttributes(ini, fin, style, true);
        }
    }
    
    public void agregarellistener(){
        doc.addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                System.out.println("insert");
                try {
                    colorear();
                } catch (BadLocationException ex) {
                    Logger.getLogger(Colorear.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                System.out.println("remove");
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                
            }
        });
    }
    
    /*private void highlight() {

    Runnable doHighlight = new Runnable() {
        @Override
        public void run() {
             colorear();
            }
        };       
        SwingUtilities.invokeLater(doHighlight);
    }*/
}
