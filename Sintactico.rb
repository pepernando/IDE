require_relative 'token.rb'
require_relative 'Nodo2.rb'
require_relative 'control_token'

class Sintactico

    def initialize(li)
        @Lista=li
        @listaErrores=[]
        @raiz=Nodo.new
        @tkna=0
        @erra=0
        @texto
    end

    def match(simbol)
        if(@Lista[@tkna] != nil)
            if(simbol == @Lista[@tkna].returnTipo)
                #print "#{simbol}\n"
                node=Nodo.new
                node.setType(simbol)
                node.setValor(@Lista[@tkna].returnContenido)
                @tkna+=1
                return node
            else
                #@listaErrores[@erra]="Consumio el siguiente token #{inesperado(@Lista[@tkna].returnTipo)}"
                @listaErrores[@erra]="Consumuio el siguiente token #{@Lista[@tkna-1].returnTipo} en #{@Lista[@tkna].returnUbicacion}"
                @erra+=1
                return Nodo.new
            end
        else
            @texto="en la #{@Lista[@Lista.length-1].returnUbicacion}"
            return Nodo.new
        end
    end

    def programa 
        raiz=Nodo.new
        raiz.setType("Main")
        auxil=match("Main")
        if auxil != nil
            auxil.setLinea(0)
            @raiz=auxil
        else
            @listaErrores[@erra]="Error token que estaba esperando es  \"main\" #{@texto}"
            @erra+=1
            while (@Lista[@tkna].returnTipo != "LlaveAbre") do @tkna+=1 end

        end
        auxil=match("LlaveAbre")
        if auxil == nil
            @erra+=1
        end
            auxil=listaDec(2)
            if auxil != nil
                a=0
                while a<auxil.length do
                @raiz.agHij(auxil[a])
                a+=1
                end
            end
            auxil=listaSen(2)
            if auxil != nil
                a=0
                while a<auxil.length do
                @raiz.agHij(auxil[a])
                a+=1
                end
            end
        auxil=match("LlaveCierra")
        if auxil == nil
            @listaErrores[@erra]= "Error token que estaba esperando es \"}\" #{@texto}"
            @erra+=1
        end
        @raiz.realinea(0)
    end

    #Lista Declaracion
    def listaDec(lv)
        ligram=[]
        ban=0
        while( @tkna<@Lista.length && (@Lista[@tkna].returnTipo == "Integer" ||@Lista[@tkna].returnTipo == "Bool" || @Lista[@tkna].returnTipo == "Float")  ) do
            ligram[ban]=declaracion(lv+1)
            auxil=match("PuntoyComa")
            ban+=1
        end
        if ban !=0
         return ligram
        else
            return nil
        end
    end
    #Definicion listaSen
    def listaSen(lv)
        liSen=[]
        ban=0
        while  @tkna<@Lista.length && @Lista[@tkna].returnTipo != "LlaveCierra" do
            auxil=sentencia(lv+1)
            liSen[ban]=auxil
            ban+=1
        end
        if ban !=0
            return liSen
        else
            return nil
        end
    end
    #Definicio de declaracion
    def declaracion(lv)
        dec    = tipoVal(lv+1)
        lisvar = listaVar(lv+1)
        a=0
        while a<lisvar.length do
          dec.agHij(lisvar[a])
          a+=1
        end
        dec.setLinea(lv)
        return dec
    end

    #Tipo de Valores (Ejem: INTEGER, BOOL FLOAT)
    def tipoVal(lv)
        axVal=Nodo.new
        case @Lista[@tkna].returnTipo
        when "Integer"
            axVal=match("Integer")
        when "Float"
            axVal=match("Float")
        when "Bool"
            axVal=match("Bool")
        end
        axVal.setLinea(lv)
        return axVal
    end

    #Lista Variables
    def listaVar(lv)
        lisAx=[]
        a=0
        lisAx[0]=match("Identificador")
        a+=1
        while (@tkna<@Lista.length && @Lista[@tkna].returnTipo == "Coma") do
            ax=match("Coma")
            lisAx[a]=match("Identificador")
            a+=1
        end
        return lisAx
    end

    #Sentencia
    def sentencia(lv)
        aux=Nodo.new
        case @Lista[@tkna].returnTipo
        when "LlaveAbre"
            aux=bloq(lv+1)
        when "If"
            aux=seleccion(lv+1)
        when "Do"
            aux=repeti(lv+1)
        when "While"
            aux=itera(lv+1)
        when "Read"
            aux=seread(lv+1)
        when "Write"
            aux=sewrite(lv+1)
        when "Identificador"
            aux=asignacion(lv+1)
        when "PuntoyComa"
            @tkna+=1
        else
            #@listaErrores[@erra]="Consumuio el siguiente token #{@Lista[@tkna].returnContenido} en #{@Lista[@tkna].returnFila} #{@Lista[@tkna].returnColumna}"

            #@listaErrores[@erra]="Token inseperado era el siguiente #{inesperado(@Lista[@tkna].returnTipo)}"
            @listaErrores[@erra]= "Token inseperado era el siguiente #{@Lista[@tkna].returnTipo} en #{@Lista[@tkna].returnUbicacion}"

            @erra+=1
            @tkna+=1
        end
        return aux
    end
    #Bloque
    def bloq(lv)
        axBlo=Nodo.new
        axBlo.setLinea(lv)
        axBlo.setType('4')
        axBlo.setValor('BloqueSen')
        aux=match("LlaveAbre")
        auxil=listaSen(lv+1)
            if auxil != nil
                a=0
                while a<auxil.length do
                axBlo.agHij(auxil[a])
                a+=1
                end
            end
        match("LlaveCierra")
        return axBlo
    end

    #Asignacion
    def asignacion(lv)

        aux=match("Identificador")
        aux.setLinea(lv+1)
        if @Lista[@tkna].returnTipo =="Incremeno" || @Lista[@tkna].returnTipo=="Decremento"
            axA=nil
            if @Lista[@tkna].returnTipo =="Incremeno"
                axA=Nodo.new
                axA.setType("Suma")
                axA.setValor("+")
            elsif @Lista[@tkna].returnTipo =="Decremento"
                axA=Nodo.new
                axA.setType("Resta")
                axA.setValor("-")
            end
            aux2=Nodo.new
            aux2.setType("TokenInicial")
            aux2.setValor('1')
            a=Nodo.new
            a.setType(aux.getType)
            a.setValor(aux.getValor)
            axA.agHij(a)
            axA.agHij(aux2)
            axAsi=Nodo.new
            axAsi.setType("Asignacion")
            axAsi.setValor(":=")
            axAsi.agHij(aux)
            axAsi.agHij(axA)
            @tkna+=1
            match("PuntoyComa")
            return axAsi
        end
        axAsi=match("Asignacion")
        aux.setLinea(lv)
        axAsi.agHij(aux)
        aux=expre(lv+1)
        axAsi.agHij(aux)
        match("PuntoyComa")
        return axAsi
    end

    #Seleccion
    def seleccion(lv)
        axSel=match("If")
        axSel.setLinea(lv)
        aux=match("ParentesisAbre")
        aux=expre(lv+1)
        axSel.agHij(aux)
        aux=match("ParentesisCierra")
        aux=match("Then")
        aux=bloq(lv+1)
        axSel.agHij(aux)
        if(@tkna<@Lista.length && @Lista[@tkna].returnTipo == "Else")
            els=match("Else")
            els.setLinea(lv)
            axSel.agHij(els)
            aux=bloq(lv+1)
            els.agHij(aux)
        end
        return axSel
    end

    #DO (Repeticion)
    def repeti(lv)
        axRep=match("Do")
        axRep.setLinea(lv)
        aux=bloq(lv+1)
        axRep.agHij(aux)
        util=match("Until")
        axRep.agFam(util)
        aux=match("ParentesisAbre")
        aux=expre(lv+1)
        util.agHij(aux)
        aux=match("ParentesisCierra")
        aux=match("PuntoyComa")
        return axRep
    end

    #While
    def itera(lv)
        axIte=match("While")
        axIte.setLinea(lv)
        aux=match("ParentesisAbre")
        aux=expre(lv+1)
        axIte.agHij(aux)
        aux=match("ParentesisCierra")
        aux=bloq(lv+1)
        axIte.agHij(aux)
        return axIte
    end
    #Read
    def seread(lv)
        axSr=match("Read")
        axSr.setLinea(lv)
        aux=match("Identificador")
        aux.setLinea(lv+1)
        axSr.agHij(aux)
        aux=match("PuntoyComa")
        return axSr
    end

    #Write
    def sewrite(lv)
        axSw=match("Write")
        axSw.setLinea(lv)
        aux=match("Cadena")
        aux.setLinea(lv+1)
        axSw.agHij(aux)
        if @tkna<@Lista.length && @Lista[@tkna].returnTipo == "Coma"
           aux=match("Coma")
           aux=expre(lv+1)
           axSw.agHij(aux)
        end
        aux=match("PuntoyComa")
        return axSw
    end

    #Expresion
    def expre(lv)
        axExp=expSim(lv)
        if @tkna<@Lista.length && (@Lista[@tkna].returnTipo == "MayorIgual" || @Lista[@tkna].returnTipo == "Mayor" || @Lista[@tkna].returnTipo == "Menor" || @Lista[@tkna].returnTipo == "MenorIgual"  || @Lista[@tkna].returnTipo == "Comparacion"  || @Lista[@tkna].returnTipo == "DiferenteDE")        # si el token  sguiente estan en el rango realcional entonces es una expsim rel expsim
            aux=relacion(lv+1)
            auEx=axExp
            axExp=aux
            axExp.agHij(auEx)
            aux=expSim(lv+1)
            axExp.agHij(aux)
        end
        return axExp
    end

    #Expresion Simple
    def expSim(lv)
        axEsim=termin(lv)
        while @tkna<@Lista.length &&  (@Lista[@tkna].returnTipo == "Suma" || @Lista[@tkna].returnTipo == "Resta" || @Lista[@tkna].returnTipo == "Incremeno" || @Lista[@tkna].returnTipo =="Decremento") do       # si mi siguiente token se encuentra entre en 22 y 25 se cicla
            auxS=axEsim
            axEsim=sumaop(lv)
            axEsim.agHij(auxS)
            aux2=termin(lv+1)

            axEsim.agHij(aux2)
        end
        return axEsim
    end

    #Termino
    def termin(lv)
        axTer=factor(lv)
        while @tkna<@Lista.length && (@Lista[@tkna].returnTipo == "Multiplicacion" || @Lista[@tkna].returnTipo == "Division" || @Lista[@tkna].returnTipo == "Residuo")
            auxT=axTer
            axTer=mulop(lv)
            axTer.agHij(auxT)
            aux2=factor(lv+1)
            
            axTer.agHij(aux2)
        end
        return axTer
    end

    #Factor
    def factor(lv)
        if @tkna<@Lista.length
            case  @Lista[@tkna].returnTipo
            when "ParentesisAbre"
                aux=match("ParentesisAbre")
                axFac=expre(lv+1)
                aux=match("ParentesisCierra")
            when "NumeroEntero"
                axFac=match("NumeroEntero")
                axFac.setLinea(lv+1)
            when "NumeroDecimal"
                axFac=match("NumeroDecimal")
                axFac.setLinea(lv+1)
            when "Float"
              axFac=match("Float")
              axFac.setLinea(lv+1)
            when "Identificador"
                axFac=match("Identificador")
                axFac.setLinea(lv+1)
            end
        else
            @listaErrores[@erra]="Error, token no esperado es ;"
            @erra+=1
            @tkna+=1
        end
        return axFac
    end

    #Relacion
    def relacion(lv)
        case @Lista[@tkna].returnTipo
        when "MenorIgual"
            axRel=match("MenorIgual")
        when "Menor"
            axRel=match("Menor")
        when "Mayor"
            axRel=match("Mayor")
        when "MayorIgual"
            axRel=match("MayorIgual")
        when "Comparacion"
            axRel=match("Comparacion")
        when "DiferenteDE"
            axRel=match("DiferenteDE")
        end
        axRel.setLinea(lv)
        return axRel
    end

    #Suma op
    def sumaop(lv)
        case @Lista[@tkna].returnTipo
        when "Suma"
            axSumop=match("Suma")
        when "Resta"
            axSumop=match("Resta")
        when "Incremeno"
            axSumop=match("Incremeno")
        when "Decremento"
            axSumop=match("Decremento")
        end
        axSumop.setLinea(lv)
        return axSumop
    end

    #Mulop
    def mulop(lv)
        case @Lista[@tkna].returnTipo
        when "Multiplicacion"
            axMulop=match("Multiplicacion")
        when "Division"
            axMulop=match("Division")
        when "Residuo"
            axMulop=match("Residuo")
        end
        axMulop.setLinea(lv)
        return axMulop
    end

    #Impresion del Programa
    def imprimirErrores
        # i=0
        # while i<@listaErrores.length do
        #     print "##{@listaErrores[i]}"
        #     i+=1
        # end

        @listaErrores.uniq!

        @listaErrores.each{ |actual|
            puts actual
        }
    end

    def returnArbolTexto
        return @raiz.texto
    end

    def returnErrores
        cadaux = ""
        @listaErrores.uniq!
        @listaErrores.each{ |actual|
            cadaux += actual + "\n"
        }
        return cadaux
    end
end

################################################################################

ct = ControlToken.new
ct.llenarDesdeArchivo("Tokens.txt")
array = ct.getArray

analisis=Sintactico.new(array)
analisis.programa
#print "#{analisis.returnArbolTexto}"
File.open("Arbol.txt",'w') {|f| f.write(analisis.returnArbolTexto)}
File.open("ErroresS.txt",'w') {|f| f.write(analisis.returnErrores)}

analisis.imprimirErrores
puts "\nTodo Correcto"

#print array
