/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ide;

import java.awt.Color;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTree;
import javax.swing.SwingUtilities;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

/**
 *
 * @author Peper
 */
public class Ventana extends javax.swing.JFrame {

    private TextLineNumber tln;
    private boolean p1, b2;
    private int rowNum, colNum;
    private String ruta;
    private StyledDocument doc;
    private Style style;
    private Ejecutor ejecutor;
    private FileReader filereader;
    private Colorear c;
    boolean cambios = false;
    
    
    public Ventana() throws IOException {
        //comentario de modificacion
        initComponents();
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setTitle("IDE");
        //comentario
        tln = new TextLineNumber(jTextPaneCode);
        jScrollPane2.setRowHeaderView(tln);
        style = jTextPaneCode.addStyle("Estilo", null);
        ejecutor = new Ejecutor();
        p1 = true;
        b2 = true;
        rowNum = colNum = 0;
        
        ruta = "src/txtFiles/styleddoc.txt";
        File f = new File(ruta);
        f.createNewFile();
        
        doc = jTextPaneCode.getStyledDocument();
        
        //agregarellistener();
        c = new Colorear(jTextPaneCode);
        c.agregarellistener();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jScrollPane7 = new javax.swing.JScrollPane();
        jTextPaneErrores = new javax.swing.JTextPane();
        jTextField2 = new javax.swing.JTextField();
        jToolBar1 = new javax.swing.JToolBar();
        jButtonCompilar = new javax.swing.JButton();
        jButtonCompilarEjecutar = new javax.swing.JButton();
        jButtonEjecutar = new javax.swing.JButton();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTextArea3 = new javax.swing.JTextArea();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTextArea4 = new javax.swing.JTextArea();
        jScrollPane6 = new javax.swing.JScrollPane();
        jTextArea5 = new javax.swing.JTextArea();
        jScrollPane9 = new javax.swing.JScrollPane();
        jTree2 = new javax.swing.JTree();
        jToolBar2 = new javax.swing.JToolBar();
        jButtonAbrir = new javax.swing.JButton();
        jButtonNuevo = new javax.swing.JButton();
        jButtonGuardar = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextPaneCode = new javax.swing.JTextPane();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenuNuevo = new javax.swing.JMenu();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItemAbir = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenuItemCerrar = new javax.swing.JMenuItem();
        jMenuItemGuardar = new javax.swing.JMenuItem();
        jMenuItemGuardarcomo = new javax.swing.JMenuItem();
        jSeparator2 = new javax.swing.JPopupMenu.Separator();
        jMenuItemSalir = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenuItem1 = new javax.swing.JMenuItem();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                formKeyPressed(evt);
            }
        });

        jTextPaneErrores.setEditable(false);
        jScrollPane7.setViewportView(jTextPaneErrores);

        jTabbedPane1.addTab("Errores", jScrollPane7);
        jTabbedPane1.addTab("Resultados", jTextField2);

        jToolBar1.setRollover(true);

        jButtonCompilar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/build.png"))); // NOI18N
        jButtonCompilar.setToolTipText("Compilar");
        jButtonCompilar.setFocusable(false);
        jButtonCompilar.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonCompilar.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonCompilar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCompilarActionPerformed(evt);
            }
        });
        jToolBar1.add(jButtonCompilar);

        jButtonCompilarEjecutar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/buildrun.png"))); // NOI18N
        jButtonCompilarEjecutar.setToolTipText("Compilar y Ejecutar");
        jButtonCompilarEjecutar.setFocusable(false);
        jButtonCompilarEjecutar.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonCompilarEjecutar.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonCompilarEjecutar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCompilarEjecutarActionPerformed(evt);
            }
        });
        jToolBar1.add(jButtonCompilarEjecutar);

        jButtonEjecutar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/run.png"))); // NOI18N
        jButtonEjecutar.setToolTipText("Ejecutar");
        jButtonEjecutar.setFocusable(false);
        jButtonEjecutar.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonEjecutar.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonEjecutar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEjecutarActionPerformed(evt);
            }
        });
        jToolBar1.add(jButtonEjecutar);

        jTextArea1.setEditable(false);
        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jScrollPane1.setViewportView(jTextArea1);

        jTabbedPane2.addTab("Lexico", jScrollPane1);

        jTextArea3.setColumns(20);
        jTextArea3.setRows(5);
        jScrollPane4.setViewportView(jTextArea3);

        jTabbedPane2.addTab("Semantico", jScrollPane4);

        jTextArea4.setColumns(20);
        jTextArea4.setRows(5);
        jScrollPane5.setViewportView(jTextArea4);

        jTabbedPane2.addTab("Hash Table", jScrollPane5);

        jTextArea5.setColumns(20);
        jTextArea5.setRows(5);
        jScrollPane6.setViewportView(jTextArea5);

        jTabbedPane2.addTab("Condigo Intermedio", jScrollPane6);

        jScrollPane9.setViewportView(jTree2);

        jTabbedPane2.addTab("Sintactico", jScrollPane9);

        jToolBar2.setRollover(true);

        jButtonAbrir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/open.png"))); // NOI18N
        jButtonAbrir.setToolTipText("Abrir");
        jButtonAbrir.setFocusable(false);
        jButtonAbrir.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonAbrir.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonAbrir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAbrirActionPerformed(evt);
            }
        });
        jToolBar2.add(jButtonAbrir);

        jButtonNuevo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/new.png"))); // NOI18N
        jButtonNuevo.setToolTipText("Nuevo");
        jButtonNuevo.setFocusable(false);
        jButtonNuevo.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonNuevo.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonNuevo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNuevoActionPerformed(evt);
            }
        });
        jToolBar2.add(jButtonNuevo);

        jButtonGuardar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/save.png"))); // NOI18N
        jButtonGuardar.setToolTipText("Guardar");
        jButtonGuardar.setFocusable(false);
        jButtonGuardar.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonGuardar.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButtonGuardar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonGuardarActionPerformed(evt);
            }
        });
        jToolBar2.add(jButtonGuardar);

        jLabel1.setText("Linnea: 0 Columna: 0");

        jTextPaneCode.addCaretListener(new javax.swing.event.CaretListener() {
            public void caretUpdate(javax.swing.event.CaretEvent evt) {
                jTextPaneCodeCaretUpdate(evt);
            }
        });
        jTextPaneCode.addAncestorListener(new javax.swing.event.AncestorListener() {
            public void ancestorMoved(javax.swing.event.AncestorEvent evt) {
            }
            public void ancestorAdded(javax.swing.event.AncestorEvent evt) {
                jTextPaneCodeAncestorAdded(evt);
            }
            public void ancestorRemoved(javax.swing.event.AncestorEvent evt) {
            }
        });
        jTextPaneCode.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                jTextPaneCodeFocusGained(evt);
            }
        });
        jTextPaneCode.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextPaneCodePropertyChange(evt);
            }
        });
        jTextPaneCode.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextPaneCodeKeyTyped(evt);
            }
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextPaneCodeKeyPressed(evt);
            }
        });
        jScrollPane2.setViewportView(jTextPaneCode);

        jMenuNuevo.setText("Archivo");

        jMenuItem6.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_N, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItem6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/new.png"))); // NOI18N
        jMenuItem6.setText("Nuevo");
        jMenuItem6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem6ActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItem6);

        jMenuItemAbir.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_A, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItemAbir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/open.png"))); // NOI18N
        jMenuItemAbir.setText("Abrir");
        jMenuItemAbir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAbirActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItemAbir);
        jMenuNuevo.add(jSeparator1);

        jMenuItemCerrar.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_X, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItemCerrar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/close.png"))); // NOI18N
        jMenuItemCerrar.setText("Cerrar");
        jMenuItemCerrar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCerrarActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItemCerrar);

        jMenuItemGuardar.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_G, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItemGuardar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/save.png"))); // NOI18N
        jMenuItemGuardar.setText("Guardar");
        jMenuItemGuardar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemGuardarActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItemGuardar);

        jMenuItemGuardarcomo.setText("Guerdar como...");
        jMenuItemGuardarcomo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemGuardarcomoActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItemGuardarcomo);
        jMenuNuevo.add(jSeparator2);

        jMenuItemSalir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ide/Icons/exit.png"))); // NOI18N
        jMenuItemSalir.setText("Salir");
        jMenuItemSalir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemSalirActionPerformed(evt);
            }
        });
        jMenuNuevo.add(jMenuItemSalir);

        jMenuBar1.add(jMenuNuevo);

        jMenu2.setText("Editar");

        jMenuItem5.setText("Ocultar");
        jMenuItem5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem5ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem5);

        jMenuItem1.setText("Expandir/Contraer Arbol");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem1);

        jMenuBar1.add(jMenu2);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(jLabel1))
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToolBar2, javax.swing.GroupLayout.PREFERRED_SIZE, 301, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jToolBar1, javax.swing.GroupLayout.PREFERRED_SIZE, 475, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 758, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 421, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jToolBar1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jToolBar2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTabbedPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 377, Short.MAX_VALUE)
                    .addComponent(jScrollPane2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 112, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jMenuItemAbirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAbirActionPerformed
        System.out.println("Este Boton Funciona");
        abrir();
        try {
            compilar();
        } catch (IOException ex) {
            Logger.getLogger(Ventana.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_jMenuItemAbirActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
        if (p1 == true) {
            jTabbedPane1.setVisible(false);
            p1 = false;
        } else {
            jTabbedPane1.setVisible(true);
            p1 = true;
        }
    }//GEN-LAST:event_jMenuItem5ActionPerformed

    private void jMenuItemSalirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemSalirActionPerformed
        this.dispatchEvent(new WindowEvent(this, WindowEvent.WINDOW_CLOSING));
    }//GEN-LAST:event_jMenuItemSalirActionPerformed

    private void formKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyPressed

    }//GEN-LAST:event_formKeyPressed

    private void jMenuItemGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemGuardarActionPerformed
        guardar();
    }//GEN-LAST:event_jMenuItemGuardarActionPerformed

    private void jMenuItemGuardarcomoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemGuardarcomoActionPerformed
        guardarComo();
    }//GEN-LAST:event_jMenuItemGuardarcomoActionPerformed

    private void jMenuItemCerrarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCerrarActionPerformed
        jTextPaneCode.setText("");
        ruta = "";
    }//GEN-LAST:event_jMenuItemCerrarActionPerformed

    private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
        if (JOptionPane.showConfirmDialog(null, "Desea Guardarlo antes?", "Advertencia",
                JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (ruta.equals("")) {
                guardarComo();
            } else {
                guardar();
            }
        }   // no option
        jTextPaneCode.setText("");

    }//GEN-LAST:event_jMenuItem6ActionPerformed

    private void jButtonNuevoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNuevoActionPerformed
        if (JOptionPane.showConfirmDialog(null, "Desea Guardarlo antes?", "Advertencia",
                JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (ruta.equals("")) {
                guardarComo();
            } else {
                guardar();
                ruta = "";
            }
        }// no option    
        jTextPaneCode.setText("");
    }//GEN-LAST:event_jButtonNuevoActionPerformed

    private void jButtonGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonGuardarActionPerformed
        if (ruta.equals("")) {
            guardarComo();
        } else {
            guardar();
        }
    }//GEN-LAST:event_jButtonGuardarActionPerformed

    private void jButtonAbrirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAbrirActionPerformed
        abrir();
        try {
            compilar();
            //trco.start();
        } catch (IOException ex) {
            Logger.getLogger(Ventana.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }//GEN-LAST:event_jButtonAbrirActionPerformed

    private void jButtonEjecutarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEjecutarActionPerformed
        c.colorear();
    }//GEN-LAST:event_jButtonEjecutarActionPerformed

    private void jButtonCompilarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCompilarActionPerformed
        try {
            compilar();
        } catch (IOException ex) {
            Logger.getLogger(Ventana.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_jButtonCompilarActionPerformed

    private void jTextPaneCodeCaretUpdate(javax.swing.event.CaretEvent evt) {//GEN-FIRST:event_jTextPaneCodeCaretUpdate
        if (b2) {
            rowNum = tln.getPx();
            colNum = tln.getPy();
            jLabel1.setText("Fila: " + rowNum + " Columna: " + colNum);
        }
        b2 = true;
    }//GEN-LAST:event_jTextPaneCodeCaretUpdate

    private void jTextPaneCodePropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextPaneCodePropertyChange
    }//GEN-LAST:event_jTextPaneCodePropertyChange

    private void jTextPaneCodeAncestorAdded(javax.swing.event.AncestorEvent evt) {//GEN-FIRST:event_jTextPaneCodeAncestorAdded

    }//GEN-LAST:event_jTextPaneCodeAncestorAdded

    private void jTextPaneCodeFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextPaneCodeFocusGained

    }//GEN-LAST:event_jTextPaneCodeFocusGained

    private void jTextPaneCodeKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPaneCodeKeyTyped

    }//GEN-LAST:event_jTextPaneCodeKeyTyped

    private void jButtonCompilarEjecutarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCompilarEjecutarActionPerformed
        guardar();
        //resetStyle();
    }//GEN-LAST:event_jButtonCompilarEjecutarActionPerformed

    private void jTextPaneCodeKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPaneCodeKeyPressed
        
    }//GEN-LAST:event_jTextPaneCodeKeyPressed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        expandAllNodes(jTree2,0, 0);
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Ventana.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        java.awt.EventQueue.invokeLater(() -> {
            try {
                new Ventana().setVisible(true);
            } catch (IOException ex) {
                Logger.getLogger(Ventana.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
    }

    void guardarComo() {
        try {
            JFileChooser chooser = new JFileChooser();

            int returnVal = chooser.showSaveDialog(chooser);

            ruta = chooser.getSelectedFile().getAbsolutePath();

            File file = new File(ruta);

            file.createNewFile();

            // Writes the content to the file
            try ( // creates a FileWriter Object
                    FileWriter writer = new FileWriter(file)) {
                writer.write(jTextPaneCode.getText());
                writer.flush();
            }
        } catch (IOException e) {
        }
    }

    void guardar() {
        if (!"src/src/txtFiles/styleddoc.txt".equals(ruta)) {
            try {
                File file = new File(ruta);
                
                file.createNewFile();

                // Writes the content to the file
                try ( // creates a FileWriter Object
                    FileWriter writer = new FileWriter(file)) {
                    // Writes the content to the file
                    writer.write(jTextPaneCode.getText());
                    writer.flush();
                }

            } catch (IOException e) {

            }
        } else {
            if (JOptionPane.showConfirmDialog(null, "El Archivo no a sido"
                    + " creado\nDesea Crearlo?", "Advertencia",
                    JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
                guardarComo();
                //System.out.println(ruta);
            } else {
                // no option
                jTextPaneCode.setText("");
            }

        }
    }

    void abrir() {
        b2 = false;
            String cadaxuliar = "";
            JFileChooser chooser = new JFileChooser();
        
            int returnVal = chooser.showOpenDialog(chooser);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
            //System.out.println("You chose to open this file: " +
            //chooser.getSelectedFile().getName());

            File archivo = null;
            FileReader fr = null;
            BufferedReader br = null;

            try {
                archivo = new File(chooser.getSelectedFile().getAbsolutePath());
                fr = new FileReader(archivo);
                br = new BufferedReader(fr);
                ruta = chooser.getSelectedFile().getAbsolutePath();

                String linea;

                while ((linea = br.readLine()) != null) {
                    cadaxuliar += linea + "\n";
                }
                cadaxuliar = cadaxuliar.substring(0, cadaxuliar.length() - 1);//para que no se agruegue el ultimo espacio
                jTextPaneCode.setText(cadaxuliar);
            } catch (IOException e) {
            } finally {
                try {
                    if (null != fr) {
                        fr.close();
                    }
                } catch (IOException e2) {
                }
            }

        }
        b2 = true;
    }

    public void colorear() throws IOException {
        String linea = "";
        
        filereader = new FileReader("src/txtFiles/styleddoc.txt");

        if (doc.getLength()!=0) {
            try (BufferedReader b = new BufferedReader(filereader)) {

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
    
    public void agregarellistener(){
        doc.addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                RunnableColorear();
                //cambios = true;
                
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                RunnableColorear();
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                
            }
        });
    }

    public void findRemplace(int ini, int fin, Color c) {
        StyleConstants.setForeground(style, c);
        int aux = fin - ini;
        doc.setCharacterAttributes(ini, fin, style, true);
    }

    
    public void compilar() throws IOException {
        String cadaux = "";
        String caderr = "Errores Lexicos:\n";
        guardar();
        jTextArea1.setText("");

        try {
            Process p = ejecutor.comando("ruby src/Ruby/Lexico.rb " + ruta);
            cadaux = ejecutor.leerBufer(ejecutor.salidaComando(p));
            //colorear();
        } catch (IOException e) {
            System.out.println("Error al ejectutar rb");
        }
        String linea = "";
        
        FileReader f = new FileReader("src/txtFiles/errores.txt");

        if (!"".equals(jTextPaneCode.getText())) {
            try (BufferedReader b = new BufferedReader(f)) {
                while ((linea = b.readLine()) != null) {
                    caderr+=linea+"\n";
                }
            }
        }
        jTextArea1.setText(cadaux);
        jTextPaneErrores.setText(caderr);
    }
    
    public void compilar2() throws IOException {
        guardar();
        try {
            Process p = ejecutor.comando("ruby src/Ruby/Lexico.rb " + ruta);
            ejecutor.leerBufer(ejecutor.salidaComando(p));
            colorear();
        } catch (IOException e) {
            
        }
    }
    
    private void RunnableColorear(){
        Runnable resaltar = () -> {
            try {
                //compilar();
                compilar2();
            } catch (IOException ex) {
                Logger.getLogger(Ventana.class.getName()).log(Level.SEVERE, null, ex);
            }
        };
        SwingUtilities.invokeLater(resaltar);
       
    }
    
    private void expandAllNodes(JTree tree, int startingIndex, int rowCount){
        for(int i=startingIndex;i<rowCount;++i){
            tree.expandRow(i);
            //tree.collapseRow(i);
        }

        if(tree.getRowCount()!=rowCount){
            expandAllNodes(tree, rowCount, tree.getRowCount());
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonAbrir;
    private javax.swing.JButton jButtonCompilar;
    private javax.swing.JButton jButtonCompilarEjecutar;
    private javax.swing.JButton jButtonEjecutar;
    private javax.swing.JButton jButtonGuardar;
    private javax.swing.JButton jButtonNuevo;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItemAbir;
    private javax.swing.JMenuItem jMenuItemCerrar;
    private javax.swing.JMenuItem jMenuItemGuardar;
    private javax.swing.JMenuItem jMenuItemGuardarcomo;
    private javax.swing.JMenuItem jMenuItemSalir;
    private javax.swing.JMenu jMenuNuevo;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JScrollPane jScrollPane9;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTextArea jTextArea1;
    private javax.swing.JTextArea jTextArea3;
    private javax.swing.JTextArea jTextArea4;
    private javax.swing.JTextArea jTextArea5;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextPane jTextPaneCode;
    private javax.swing.JTextPane jTextPaneErrores;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JToolBar jToolBar2;
    private javax.swing.JTree jTree2;
    // End of variables declaration//GEN-END:variables
}
