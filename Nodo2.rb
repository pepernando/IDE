class Nodo
    def initialize()
        @hijos =[]
        @hermano
        @linea=0
        @tipo
        @valor
    end

    def getType()
        return @tipo
    end

    def getValor()
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
    def setType(tipo)
        @tipo=tipo
    end

    def setLinea(lin)
        @linea=lin
    end

    def imp()
        a=0
        while (a<@linea) do
            print "\t"
            a+=1
        end
        print "[#{@tipo},#{@valor}]\n"
        a=0
        #print "[#{@hijos.length}]"
        while (a<@hijos.length) do
           if @hijos[a]!=nil
            @hijos[a].imp()
           end
           a+=1
        end
        if (@hermano != nil)
            #print "hermano #{@hermano.getType}\n"
            @hermano.imp()
        end
    end
    def realinea (lv)
        @linea=lv
        a=0
        while (a<@hijos.length) do
            if @hijos[a]!= nil
                @hijos[a].realinea(lv+1)
            end
            a+=1
        end
        if (@hermano != nil)
            @hermano.realinea(lv)
        end
    end

    def texto ()tex=""
        if @tipo !=nil
        a=0
        while (a<@linea) do
            tex += "\t"
            a+=1
        end
        tex +="#{@valor}\n"
        a=0
        #print "[#{@hijos.length}]"
        while (a<@hijos.length) do
           if @hijos[a] != nil
            tex +="#{@hijos[a].texto()}"
           end
           a+=1
        end
        if (@hermano != nil)
            #print "hermano #{@hermano.getType}\n"
            tex +="#{@hermano.texto()}"
        end

        end
        return tex

    end


end
