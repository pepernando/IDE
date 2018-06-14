class Nodo

    def initialize
        @hijos =[]
        @hermano
        @tipo
        @valor
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

    def agFam(herm)
        @hermano=herm
    end

    def setValor(valor)
        @valor=valor
    end

    def setTipoNodo(tipo)
        @tipo=tipo
    end

    def texto(linea)
        tex=""
        if @tipo != nil
          #es un for de 0 a linea - 1
          if @valor !='noP'

            (0..linea - 1).each {
              tex += "\t"
            }

            tex +="#{@valor}\n"

            @hijos.each{ |actual|
              if actual != nil
                tex += "#{actual.texto(linea+1)}"
              end
            }
          else
            @hijos.each{ |actual|
              if actual != nil
                tex += "#{actual.texto(linea)}"
              end
            }
          end

          if (@hermano != nil)
              tex +="#{@hermano.texto(linea)}"
          end
        end
        return tex
    end
  end

