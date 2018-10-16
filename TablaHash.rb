class Row
    def initialize(nodo)
        @tipo = nodo.getTipoNodo.to_s
        @valor = nodo.getValor.to_s
        @eval = nodo.getEval
        # @linea = nodo.getLinea
        @linea = []
        @nlineas = 0
    end

    def getTipo
        return @tipo
    end

    def getEval
        return @eval
    end

    def setEval(aux)
        @eval = aux
    end

    def getLinea
        aux = ""
        @linea.each{|act|
            aux += act.to_s 
            aux += " "
        }
        return aux
    end

    def getlineaIni
        return @linea[0]
    end

    def pushLinea(aux)
        @linea.push(aux.to_i)
    end

    def getValor
        return @valor
    end
end

class HashTable
    def initialize
        @rows = []
    end

    def add(row)
        @rows.push(Row.new(row))
    end

    def addLine(identificador,linea)
        @rows.each{ |act|
            if (linea.to_i!=0)#esta se usa para el caso c++ ya que aqui no se tinene una linea
                if (act.getValor == identificador)
                    act.pushLinea( linea.to_i ) 
                end
            end
        }
    end

    def mostrar
        @rows.each{ |act|
            puts "#{act.getTipo} #{act.getValor} #{act.getEval} #{act.getLinea}"
        }
    end

    def hashaTexto
        arraux = ""
        @rows.each{ |act|
            arraux+= "#{act.getValor}|#{act.getTipo}|#{act.getEval} |#{act.getLinea} \n"
        }
        File.open("Hash.txt",'w') {|f| f.write(arraux)}
    end

    def solicitaTipo(nombre) #busca en la tala el tipo de dato para ver si no se le asigna 
        band = false
        aux = ""
        @rows.each{ |act|
            if (act.getValor == nombre)
                band = true
                aux = act.getTipo 
                break;
            end
        }
        if(band)
            return aux
        else
            puts "La variable que buscas no existe"
            return " "
        end
    end

    def existe(nombre) #busca en la tala el tipo de dato para ver si no se le asigna 
        band = false
        @rows.each{ |act|
            if (act.getValor == nombre)
                band = true
                break;
            end
        }
        return band
    end

    def actualizaValor(nombre,valor) #busca en la tala el tipo de dato para ver si no se le asigna 
        @rows.each{ |act|
            if (act.getValor == nombre)
                act.setEval(valor) 
                break;
            end
        }
    end

    def getValExp(nombre) #busca en la tala el tipo de dato para ver si no se le asigna 
        @rows.each{ |act|
            if (act.getValor == nombre)
                return act.getEval 
            end
        }
    end

    def lineaIni(nombre) #busca en la tala el tipo de dato para ver si no se le asigna 
        @rows.each{ |act|
            if (act.getValor == nombre)
                return act.getlineaIni
                break;
            end
        }
        return 0
    end
end