/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

import java.io.IOException;

/**
 *
 * @author Peper
 */
public class IDE {

    /**
     * @param args the command line arguments
     * @throws java.io.IOException
     */
    public static void main(String[] args) throws IOException {
       Ventana v = new Ventana();
       v.setVisible(true);
       
    }
    
}
