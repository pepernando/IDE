require_relative 'Nodo'
require_relative 'TablaHash'

@arrayExisten = []
@arrayErrores = ""

@ht = HashTable.new

#probando desSerializar
File.open('arbolSint.bin') do |act|
    @nodoRaiz = Marshal.load(act)
end

def valido(nodo)
    if(nodo!=nil)
        return true 
    else 
        return false
    end
end

#aqui se contruye la tabla hash y se heredan los tipos a los atributos
def recorridoExisten(nodo) 
    if(valido(nodo))
        case nodo.getTipoNodo  
            when 'Integer','Float','Bool'
                nodo.getHij.each{|actual|
                    case(nodo.getTipoNodo)
                        when 'Integer'
                            actual.setTipoNodo('Integer')
                        when 'Float'
                            actual.setTipoNodo('Float')
                        when 'Bool'
                            actual.setTipoNodo('Bool')
                    end

                    if(@arrayExisten.include? actual.getValor)
                        @arrayErrores+="la variable #{actual.getValor} ya habia sido declarada\n"
                        actual.setTipoNodo("Error")
                    # end
                    else
                        @arrayExisten.push(actual.getValor)
                        @ht.add(actual)
                        @ht.addLine( actual.getValor , actual.getLinea)
                    end
                }
            when 'Identificador'
                if(!@arrayExisten.include? nodo.getValor)
                    @arrayErrores+="la variable #{nodo.getValor} no se declaro \n"
                    nodo.setEval(nodo.setTipoNodo("Error"))
                else
                    @ht.addLine( nodo.getValor , nodo.getLinea)
                    nodo.setTipoNodo( @ht.solicitaTipo( nodo.getValor) )
                    # puts "var: #{nodo.getValor} linea: #{nodo.getLinea}"
                end
            when "Entero","Decimal"
                nodo.setEval(nodo.getValor)
                if(nodo.getTipoNodo=="Entero")
                    nodo.setTipoNodo("Integer")
                else
                    nodo.setTipoNodo("Float")
                end
        end
        nodo.getHij.each{|actual|
            recorridoExisten(actual)
        }
    end
end

def evalTipo(a,b)
    if (a=="Integer" && b=="Float") || (a=="Integer" && b=="Float")
        return Float
    elsif (a==b)
        return a
    else
        return "Error"
    end
end

# def recorreTipo(nodo)
#     if(valido(nodo))
#         case(nodo.getTipoNodo)
#         when "Integer"
#     end
# end

#importante!! revisar divison entre
def recorridoEvaluar(nodo)
    band = false
    if(valido(nodo))
        nodo.getHij.each{|actual|
            recorridoEvaluar(actual) 
        }
        auxi = ""
        case(nodo.getTipoNodo)
        when "Suma"
            nodo.setEval( nodo.getHij[0].getEval.to_f + nodo.getHij[1].getEval.to_f )
        when "Resta"
            nodo.setEval( nodo.getHij[0].getEval.to_f - nodo.getHij[1].getEval.to_f )
        when "Multiplicacion"
            nodo.setEval( nodo.getHij[0].getEval.to_f * nodo.getHij[1].getEval.to_f )
        when "Division"
            nodo.setEval( nodo.getHij[0].getEval.to_f / nodo.getHij[1].getEval.to_f )
        when "Residuo"
            nodo.setEval( nodo.getHij[0].getEval.to_f % nodo.getHij[1].getEval.to_f )
        when "Mayor"
            if (nodo.getHij[0].getEval.to_f > nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
        when "Menor"
            if (nodo.getHij[0].getEval.to_f < nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
        when "MayorIgual"            
            if (nodo.getHij[0].getEval.to_f >= nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
        when "MenorIgual"            
            if (nodo.getHij[0].getEval.to_f <= nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
            band = true
        when "Comparacion"            
            if (nodo.getHij[0].getEval.to_f == nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
        when "DiferenteDe"
            if (nodo.getHij[0].getEval.to_f != nodo.getHij[1].getEval.to_f)
                auxi = "true"
            else
                auxi = "false"
            end
            nodo.setEval( auxi )
        when "Asignacion"
            nodo.getHij[0].setEval(nodo.getHij[1].getEval)
            @ht.actualizaValor(nodo.getHij[0].getValor ,nodo.getHij[1].getEval)
            nodo.setEval(nodo.getHij[1].getEval)
            band = true
        when "Float","Integer","Bool" #como expresion fue reemplazado por el tipo
            if(@ht.existe(nodo.getValor))#si el nodo existe en la tabla es un identificador valido
                nodo.setEval( @ht.getValExp(nodo.getValor) )
            end
        end
    end
end

recorridoExisten(@nodoRaiz)

recorridoEvaluar(@nodoRaiz)

# puts"#{@nodoRaiz.texto(0,1)}"
# puts "Errores Semanticos:\n"
# puts "#{@arrayErrores}"
# @ht.mostrar

File.open("Semantico.txt",'w') {|f| f.write( @nodoRaiz.texto(0,1) )}
File.open("Errores.txt",'a+') {|f| f.write("Errores Semanticos:\n" + @arrayErrores )}
@ht.hashaTexto