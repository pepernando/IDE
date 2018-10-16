require_relative 'Nodo'
require_relative 'TablaHash'

class Semantico

    def initialize
        #esta puede ser reemplazada por la tabla hash
        @arrayExisten = []
        @arrayErrores = ""
        #la tabla
        @ht = HashTable.new
        #el arbol
        @nodoRaiz = Nodo.new
        #lectura del arbol usando serializacion
        File.open('arbolSint.bin') do |act|
            @nodoRaiz = Marshal.load(act)
        end
    end

    #para saber si un nodo es valido
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

    #funcion temporal para inizializar hijos nulos en las operaciones
    # ya que si se le llama a su hijo 0 o 1 lanzará un error 
    def emergencia(nodo)
        if(valido(nodo))
            nodo.getHij.each{|actual|
                emergencia(actual)
            }
            case(nodo.getTipoNodo)
                when "Suma","Resta","Multiplicacion","Division","Residuo","Mayor","Menor","MayorIgual","MenorIgual","Comparacion","DiferenteDe"
                    if( nodo.getHij[0]==nil || nodo.getHij[1]==nil )
                        a = Nodo.new
                        nodo.getHij.pop
                        nodo.agHij(a)
                        puts "#{nodo.getHij[0].getEval}"
                        puts "#{nodo.getHij[1].getEval}"
                        File.open("Errores.txt",'a+') {|f| f.write("Token inesperado en #{nodo.getPos}\n")}
                    end
            end
        end
    end

    # def posBueno(nodo)
    #     if(valido(nodo))
    #         case nodo.getTipoNodo
    #             when 'Integer','Float','Bool'
    #                 if(@ht.existe(nodo.getValor))#si el nodo existe en la tabla es un identificador valido
    #                     if(nodo.getEval=="null")
    #                         puts "error en la variable #{nodo.getValor} en #{nodo.getPos}"
    #                     end 
    #                 end
    #         end
    #         nodo.getHij.each{|act|
    #             posBueno(nodo)
    #         }
    #     end
    # end

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
                        actual.setEval("null")
                        if(@arrayExisten.include? actual.getValor)
                            @arrayErrores+="la variable #{actual.getValor} ya habia sido declarada #{actual.getPos}\n"
                            actual.setTipoNodo("Error")
                        # end
                        else
                            if(actual.getValor!=nil)
                                @arrayExisten.push(actual.getValor)
                                @ht.add(actual)
                                @ht.addLine( actual.getValor , actual.getLinea)
                            end        
                        end
                    }
                when 'Identificador'
                    if(!@arrayExisten.include? nodo.getValor)
                        @arrayErrores+="la variable #{nodo.getValor} no se declaro #{nodo.getPos}\n"
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

    #funcion para comparar operaciones -*/=%
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

    #funcion para comparar relaciones <><=>===
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

    def evalNull(a,b)
        if (a=="null" || b=="null") 
            return true
        else
            return false
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
                    if(nodo.getHij[0].getEval=='null')
                        @arrayErrores+= "Error en #{nodo.getHij[0].getPos} variable no inicializada\n"
                        #posBueno(nodo.getHij[0])
                    end
                    if(nodo.getHij[0].getEval == '0' || nodo.getHij[0].getEval == '1')
                        nodo.setTipoNodo("Bool")
                        if(nodo.getHij[0].getEval == '0')
                            nodo.setEval('0')
                        else
                            nodo.setEval('1')
                        end
                    end
                when "Do"
                    #menos uno se utilia para indicar en ultimo elemento del array
                    if(nodo.getHij[-1].getEval=='null')
                        @arrayErrores+= "Error en #{nodo.getHij[-1].getPos} variable no inicializada\n"
                        #posBueno(nodo.getHij[-1])
                    end
                    nodo.setTipoNodo(nodo.getHij[-1].getTipoNodo)            
                    nodo.setEval(nodo.getHij[-1].getEval)    
                when "Asignacion"
                    if(nodo.getHij[0].getEval=='null')
                        @arrayErrores+= "Error en #{nodo.getHij[0].getPos} variable no inicializada\n"
                        #posBueno(nodo.getHij[0])
                    end
                    a = nodo.getHij[0].getTipoNodo
                    b = nodo.getHij[1].getTipoNodo
                    if(a==b)
                        nodo.setTipoNodo(a)
                    elsif (a=="Float" && b=="Integer")
                        nodo.setTipoNodo("Float")
                    elsif(a=='Bool')
                        if( nodo.getHij[1].getValor.to_i==0|| nodo.getHij[1].getValor.to_i==1)
                            nodo.setTipoNodo("Bool")
                        else
                            nodo.setTipoNodo("Error")
                            @arrayErrores+="Tipos incorpatibles a la variable #{nodo.getHij[0].getValor} en #{nodo.getHij[0].getPos}\n"                        
                        end
                    else
                        nodo.setTipoNodo("Error")
                        @arrayErrores+="Tipos incorpatibles a la variable #{nodo.getHij[0].getValor} en #{nodo.getHij[0].getPos}\n"
                    end
            end
            if(nodo.getTipoNodo=="Integer")
                if(@ht.existe(nodo.getValor))
                    if(@ht.lineaIni(nodo.getValor).to_i != nodo.getLinea.to_i)
                        nodo.setEval(nodo.getEval.to_i)
                        @ht.actualizaValor(nodo.getValor,nodo.getEval)                    
                    end
                else
                    nodo.setEval(nodo.getEval.to_i)
                end
            end
        end
    end

    def recorridoEvaluar(nodo)
        if(valido(nodo))
            nodo.getHij.each{|actual|
                recorridoEvaluar(actual) 
            }
            auxi = ""
            band = true
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
                nodo.setEval( nodo.getHij[0].getEval.to_i % nodo.getHij[1].getEval.to_i )
            when "Mayor"
                if (nodo.getHij[0].getEval.to_f > nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
                end
                nodo.setEval( auxi )
            when "Menor"
                if (nodo.getHij[0].getEval.to_f < nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
                end
                nodo.setEval( auxi )
            when "MayorIgual"            
                if (nodo.getHij[0].getEval.to_f >= nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
                end
                nodo.setEval( auxi )
            when "MenorIgual"            
                if (nodo.getHij[0].getEval.to_f <= nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
                end
                nodo.setEval( auxi )
            when "Comparacion"            
                if (nodo.getHij[0].getEval.to_f == nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
                end
                nodo.setEval( auxi )
            when "DiferenteDe"
                if (nodo.getHij[0].getEval.to_f != nodo.getHij[1].getEval.to_f)
                    auxi = "1"
                else
                    auxi = "0"
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
                band = false
            when "Read"
                @ht.actualizaValor(nodo.getHij[0].getValor ,"?")
                band = false
            else
                band = false
            end   
            if(band)
                if( evalNull(nodo.getHij[0].getEval,nodo.getHij[1].getEval) )
                    nodo.setEval("null")  
                end
            end
        end
    end

    def analizar
        emergencia(@nodoRaiz)

        #verifica si existen o los nodos reedeclarados; 
        recorridoExisten(@nodoRaiz)

        #evalua las operaciones y comparaciones 
        recorridoEvaluar(@nodoRaiz)
        #evalua los tipo
        preOr(@nodoRaiz)

        #Recorrido Evaluar y recorrido preOr podrian estar en una misma funcion para un mejor manejo

        File.open("Semantico.txt",'w') {|f| f.write( @nodoRaiz.texto(0,1) )}
        File.open("Errores.txt",'a+') {|f| f.write("Errores Semanticos:\n" + @arrayErrores )}
        
        @ht.hashaTexto
        @ht.mostrar
    end

end

sint = Semantico.new
sint.analizar