class Nodo

    def initialize
        @tipo  
        @valor 
        @eval = "" #es el resultado 
        @hijos = []

        @linea = ""
        @columna = ""
    end

    def getTipoNodo
        return @tipo
    end

    def getValor
        return @valor
    end

    def agHij(nHijo)
        @hijos[@hijos.length]=nHijo
    end

    def getHij
      return @hijos
    end

    def setValor(valor)
        @valor=valor
    end

    def setTipoNodo(tipo)
        @tipo=tipo
    end

    def setEval(eval)
      @eval = eval
    end

    def getEval
      return @eval
    end

    def setLinea(lin,col)
      @linea = lin
      @columna = col
    end

    def getPos
      return @linea + " " + @columna
    end

    def getLinea
      return @linea 
    end

    def texto(linea,modo)#modo 0 para sintactico modo 1 semantico
        tex=""
        if @tipo != nil
          #es un for de 0 a linea - 1
          if @valor !='bloque'

            (0..linea - 1).each {
              tex += "\t"
            }

            if(modo==0)
              tex +="#{@valor}\n"
            else
              #Cambia en el texto del arbol el texto a true o false para mejor entendimiento
              # if ( (@eval=='0'||@eval=='1') && @tipo=='Bool')
              
              # if ( @tipo=='Bool')
              #   if(@eval=='1')
              #     tex +="#{@valor} ( #{@tipo}), true )\n"
              #   else
              #     tex +="#{@valor} ( #{@tipo}, false )\n"
              #   end
              # else
              #   tex +="#{@valor} (#{@tipo},#{@eval})\n"
              # end
              tex +="#{@valor} (#{@tipo},#{@eval})\n"
            end

            @hijos.each{ |actual|
              if actual != nil
                tex += "#{actual.texto(linea+1,modo)}"
              end
            }
          else
            @hijos.each{ |actual|
              if actual != nil
                tex += "#{actual.texto(linea,modo)}"
              end
            }
          end

        end
        return tex
    end
  end