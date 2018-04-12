/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.print.Doc;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
/**
 *
 * @author peper
 */
public class ThreadColorear extends Thread{
    private Colorear c;

    public ThreadColorear(JTextPane jp){
        c = new Colorear(jp);
    }
    
    @Override
    public void run(){
        try {
            while(true){
               c.colorear();
               Thread.sleep(500);
            }

        } catch (InterruptedException e) {
        } catch (BadLocationException ex) {
            Logger.getLogger(ThreadColorear.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
    

