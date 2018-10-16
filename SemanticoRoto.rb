require_relative 'Nodo'
require_relative 'TablaHash'

class Semantico

    def initialize
        @arrayExisten = []
        @arrayErrores = ""
        @ht = HashTable.new
        @nodoRaiz = Nodo.new
        File.open('arbolSint.bin') do |act|
            @nodoRaiz = Marshal.load(act)
        end
    end

    def valido(nodo)
        if(nodo!=nil)
            return true 
        else 
            return false
        end
    end

    #funcion para ver si algo es numerico
    def is_number?(obj)
        obj.to_f.to_s == obj.to_s || obj.to_i.to_s == obj.to_s
    end

    #revisar si sus dos hijos son numericos , si no lo son se le asignara el valor no numerico
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
                        #al crear, cada hijo es nulo por defecto
                        # actual.setEval("null")
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

    #en vez de esta funcion otra funcion que en cada nodo verifique si sus hijos son compartibles
    #asi se le asignara a este un tipo de dato o un error y recibira un nodo como parametro
    def evalOp(a,b)
        if (a=="Integer" && b=="Float") 
            return "Float"
        elsif (a=="Float" && b=="Integer")
            return "Float"
        elsif (a==b)
            return a
        else
            return "Error"
        end
    end

    def evalComp(a,b)
        if (a=="Integer" && b=="Float") 
            return "Bool"
        elsif (a=="Float" && b=="Integer")
            return "Bool"
        elsif (a==b)
            return "Bool"
        else
            return "Error"
        end
    end

    def preOr(nodo)
        if(valido(nodo))
            nodo.getHij.each{|actual|
                preOr(actual) 
            } 
            case(nodo.getTipoNodo)   
                when "Suma","Resta","Multiplicacion","Division","Residuo"
                    a = nodo.getHij[0].getTipoNodo
                    b = nodo.getHij[1].getTipoNodo
                    nodo.setTipoNodo(evalOp(a,b))
                when "Mayor","Menor","MayorIgual","MenorIgual","Comparacion","DiferenteDe"
                    a = nodo.getHij[0].getTipoNodo
                    b = nodo.getHij[1].getTipoNodo
                    nodo.setTipoNodo(evalComp(a,b))
                when "If","While"
                    if(nodo.getHij[0].getEval == '0' || nodo.getHij[0].getEval == '1')
                        nodo.setTipoNodo("Bool")
                        if(nodo.getHij[0].getEval == '0')
                            nodo.setEval('0')
                        else
                            nodo.setEval('1')
                        end
                    else
                        nodo.setTipoNodo("Error")
                        @arrayErrores+="Tipos incompatibles #{nodo.getpos}"
                    end
                when "Do"
                    #menos uno se utilia para indicar en ultimo elemento del array
                    nodo.setTipoNodo(nodo.getHij[-1].getTipoNodo)            
                    nodo.setEval(nodo.getHij[-1].getEval)     
            end
        end
    end

    def recorridoEvaluar(nodo)
        if(valido(nodo))
            nodo.getHij.each{|actual|
                recorridoEvaluar(actual) 
            }
            auxi = ""
            case(nodo.getTipoNodo)
            when "Suma"
                # puts "#{nodo.getHij[0].getEval.to_f} "
                puts "#{nodo.getHij.size} "
                nodo.getHij.each{|actual|
                    puts "#{actual.getEval}" 
                }
                # nodo.setEval( nodo.getHij[0].getEval.to_f + nodo.getHij[1].getEval.to_f )
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
            when "Float","Integer","Bool" #como expresion fue reemplazado por el tipo
                if(@ht.existe(nodo.getValor))#si el nodo existe en la tabla es un identificador valido
                    nodo.setEval( @ht.getValExp(nodo.getValor) )
                end
            end
        end
    end

    def analizar
        recorridoExisten(@nodoRaiz)

        recorridoEvaluar(@nodoRaiz)

        # preOr(@nodoRaiz)

        File.open("Semantico.txt",'w') {|f| f.write( @nodoRaiz.texto(0,1) )}
        File.open("Errores.txt",'a+') {|f| f.write("Errores Semanticos:\n" + @arrayErrores )}
        
        @ht.hashaTexto
    end

end

sint = Semantico.new
sint.analizar

asd = "esta es una cadena ".to_f
puts "cad #{asd}"