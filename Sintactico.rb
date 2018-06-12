require_relative 'Nodo'
require_relative 'Token'
require_relative 'ControlToken'

class Sintactico

    def initialize(arrayAux)
        @arrayTokens = arrayAux
        @nodoRaiz=Nodo.new
        @arrayErrores = []
        @auxiliarTexto = ""
        @punteroToken=0
        @punteroError=0
    end

    def run
        if @arrayTokens.length
            puts "Error en el llenado de Tokens"
        else
            programa
        end
    end

    def match(simbol)
        if(@arrayTokens[@punteroToken] != nil)
            if(simbol == @arrayTokens[@punteroToken].returnTipo)
                node = Nodo.new
                node.setType(simbol)
                node.setValor(@arrayTokens[@punteroToken].returnContenido)
                @punteroToken+=1
                return node
            else
                @arrayErrores[@punteroError]="Consumio el siguiente token #{@arrayTokens[@punteroToken].returnContenido} en #{@arrayTokens[@punteroToken-1].returnUbicacion}\n"
                @punteroError+=1
                return Nodo.new
            end
        else
            @auxiliarTexto="en la #{@arrayTokens[@arrayTokens.length-1].returnUbicacion}"
            return Nodo.new
        end
    end

    #para reportar si los tokenns no se cargaron correctamente
    def nodoExiste
        if @punteroToken<@arrayTokens.length
            return true
        else
            return false
        end
    end

    def imprimirErrores
        #@arrayErrores.uniq! #este elimina los duplicados
        @arrayErrores.each{ |actual| #solo itera el array y lo imprime
            puts actual
        }
    end

    def ret
        return @nodoRaiz.texto
    end

    #Programa -> main { lista-declaración lista-sentencia }
    def programa
        raiz=Nodo.new
        raiz.setType("Main")
        auxil=match("Main")
        if auxil != nil
            auxil.setLinea(0)
            @nodoRaiz=auxil
        else
            @arrayErrores[@punteroError]="Error token que estaba esperando es  \"main\" #{@auxiliarTexto}"
            @punteroError+=1
            while (@arrayTokens[@punteroToken].returnTipo != "LlaveAbre") do @punteroToken+=1 end

        end
        auxil=match("LlaveAbre")
        if auxil == nil
            @punteroError+=1
        end
        auxil=listaDeclaracion(2)
        if auxil != nil
            a=0
            while a<auxil.length do
                @nodoRaiz.agHij(auxil[a])
                a+=1
            end
        end
        auxil=listaSentencias(2)
        if auxil != nil
            a=0
            while a<auxil.length do
                @nodoRaiz.agHij(auxil[a])
                a+=1
            end
        end
        auxil=match("LlaveCierra")
        if auxil == nil
            @arrayErrores[@punteroError]= "Error token que estaba esperando es \"}\" #{@auxiliarTexto}\n"
            @punteroError+=1
        end
        @nodoRaiz.realinea(0)
    end

    # lista-declaración -> { declaración ; }
    def listaDeclaracion(lv)
        ligram=[]
        ban=0
        while( nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "Integer" ||@arrayTokens[@punteroToken].returnTipo == "Bool" || @arrayTokens[@punteroToken].returnTipo == "Float")  ) do
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

    # declaración → tipo lista-variables
    def declaracion(lv)
        dec = tipo(lv+1)
        lisvar = listaVariables(lv+1)
        a=0
        while a<lisvar.length do
            dec.agHij(lisvar[a])
            a+=1
        end
        dec.setLinea(lv)
        return dec
    end

    #tipo → integer | float | bool
    def tipo(lv)
        axVal = Nodo.new
        case @arrayTokens[@punteroToken].returnTipo
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

    #lista-sentencia -> { sentencia }
    def listaSentencias(lv)
        liSen=[]
        ban=0
        while  nodoExiste && @arrayTokens[@punteroToken].returnTipo != "LlaveCierra" do
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

    #lista-variables -> identificador [ , identificador ]
    def listaVariables(lv)
        lisAx=[]
        a=0
        lisAx[0]=match("Identificador")
        a+=1
        while (nodoExiste && @arrayTokens[@punteroToken].returnTipo == "Coma") do
            ax=match("Coma")
            lisAx[a]=match("Identificador")
            a+=1
        end
        return lisAx
    end

    #sentencia → selección | iteración | repetición | sent-read |sent-write | bloque | asignación
    def sentencia(lv)
        aux=Nodo.new
        case @arrayTokens[@punteroToken].returnTipo
        when "LlaveAbre"
            aux=bloque(lv+1)
        when "If"
            aux=seleccion(lv+1)
        when "Do"
            aux=repeti(lv+1)
        when "While"
            aux=itera(lv+1)
        when "Read"
            aux=sentRead(lv+1)
        when "Write"
            aux=sentWrite(lv+1)
        when "Identificador"
            aux=asignacion(lv+1)
        when "PuntoyComa"
            @punteroToken+=1
        else
            @arrayErrores[@punteroError]="Token inseperado era el siguiente  #{@arrayTokens[@punteroToken].returnContenido} en #{@arrayTokens[@punteroToken-1].returnUbicacion}\n"
            @punteroError+=1
            @punteroToken+=1
        end
        return aux
    end

    #bloque -> { lista-sentencia }
    def bloque(lv)
        axBlo=Nodo.new
        axBlo.setLinea(lv)
        axBlo.setType('5')
        axBlo.setValor('BloqueSen')
        aux=match("LlaveAbre")
        auxil=listaSentencias(lv+1)
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

    #seleccion -> if ( expresion ) then bloque [ else bloque ]
    def seleccion(lv)
        axSel=match("If")
        axSel.setLinea(lv)
        match("ParentesisAbre")
        aux=expresion(lv+1)
        axSel.agHij(aux)
        match("ParentesisCierra")
        match("Then")
        aux=bloque(lv+1)
        axSel.agHij(aux)
        if(nodoExiste && @arrayTokens[@punteroToken].returnTipo == "Else")
            els=match("Else")
            els.setLinea(lv)
            axSel.agHij(els)
            aux=bloque(lv+1)
            els.agHij(aux)
        end
        return axSel
    end

    #asignación → identificador := expresión ;
    def asignacion(lv)
        aux=match("Identificador")
        aux.setLinea(lv+1)
        if @arrayTokens[@punteroToken].returnTipo =="Incremento" || @arrayTokens[@punteroToken].returnTipo=="Decremento"
            axA=nil
            if @arrayTokens[@punteroToken].returnTipo =="Incremento"
                axA=Nodo.new
                axA.setType("Suma")
                axA.setValor("+")
            elsif @arrayTokens[@punteroToken].returnTipo =="Decremento"
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
            @punteroToken+=1
            match("PuntoyComa")
            return axAsi
        end
        axAsi=match("Asignacion")
        aux.setLinea(lv)
        axAsi.agHij(aux)
        aux=expresion(lv+1)
        axAsi.agHij(aux)
        match("PuntoyComa")
        return axAsi
    end

    #repetición → do bloque until ( expresión ) ;
    def repeti(lv)
        axRep=match("Do")
        axRep.setLinea(lv)
        aux=bloque(lv+1)
        axRep.agHij(aux)
        util=match("Until")
        axRep.agFam(util)
        match("ParentesisAbre")
        aux=expresion(lv+1)
        util.agHij(aux)
        match("ParentesisCierra")
        match("PuntoyComa")
        return axRep
    end

    #iteración → while ( expresión ) bloque
    def itera(lv)
        axIte=match("While")
        axIte.setLinea(lv)
        match("ParentesisAbre")
        aux=expresion(lv+1)
        axIte.agHij(aux)
        match("ParentesisCierra")
        aux=bloque(lv+1)
        axIte.agHij(aux)
        return axIte
    end

    #sent-read → read identificador ;
    def sentRead(lv)
        axSr=match("Read")
        axSr.setLinea(lv)
        aux=match("Identificador")
        aux.setLinea(lv+1)
        axSr.agHij(aux)
        match("PuntoyComa")
        return axSr
    end

    #sent-write → write cadena, expression;|write cadena ;
    def sentWrite(lv)
        axSw=match("Write")
        axSw.setLinea(lv)
        aux=match("Cadena")
        aux.setLinea(lv+1)
        axSw.agHij(aux)
        if nodoExiste && @arrayTokens[@punteroToken].returnTipo == "Coma"
            match("Coma")
            aux=expresion(lv+1)
            axSw.agHij(aux)
        end
        match("PuntoyComa")
        return axSw
    end

    #expresión -> expresion-simple [ relación expresion-simple ]
    def expresion(lv)
        axExp=expresionSimple(lv)
        if nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "MayorIgual" || @arrayTokens[@punteroToken].returnTipo == "Mayor" || @arrayTokens[@punteroToken].returnTipo == "Menor" || @arrayTokens[@punteroToken].returnTipo == "MenorIgual"  || @arrayTokens[@punteroToken].returnTipo == "Comparacion"  || @arrayTokens[@punteroToken].returnTipo == "DiferenteDe")        # si el token  sguiente estan en el rango realcional entonces es una expsim rel expsim
            aux=relacion(lv+1)
            auEx=axExp
            axExp=aux
            axExp.agHij(auEx)
            aux=expresionSimple(lv+1)
            axExp.agHij(aux)
        end
        return axExp
    end

    #expresion-simple -> termino { suma-op termino }
    def expresionSimple(lv)
        axEsim=termino(lv)
        while nodoExiste &&  (@arrayTokens[@punteroToken].returnTipo == "Suma" || @arrayTokens[@punteroToken].returnTipo == "Resta" || @arrayTokens[@punteroToken].returnTipo == "Incremento" || @arrayTokens[@punteroToken].returnTipo =="Decremento") do       # si mi siguiente token se encuentra entre en 22 y 25 se cicla
            auxS=axEsim
            axEsim=sumaop(lv)
            axEsim.agHij(auxS)
            aux2=termino(lv+1)
            axEsim.agHij(aux2)
        end
        return axEsim
    end

    #termino -> factor { mult-op factor }
    def termino(lv)
        axTer=factor(lv)
        while nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "Multiplicacion" || @arrayTokens[@punteroToken].returnTipo == "Division" || @arrayTokens[@punteroToken].returnTipo == "Residuo")
            auxT=axTer
            axTer=mulop(lv)
            axTer.agHij(auxT)
            aux2=factor(lv+1)

            axTer.agHij(aux2)
        end
        return axTer
    end

    #factor → ( expresión ) | numero | identificador
    def factor(lv)
        if nodoExiste
            case  @arrayTokens[@punteroToken].returnTipo
            when "ParentesisAbre"
                match("ParentesisAbre")
                axFac=expresion(lv+1)
                match("ParentesisCierra")
            when "Entero"
                axFac=match("Entero")
                axFac.setLinea(lv+1)
            when "Decimal"
                axFac=match("Decimal")
                axFac.setLinea(lv+1)
            when "Identificador"
                axFac=match("Identificador")
                axFac.setLinea(lv+1)
            end
        else
            @arrayErrores[@punteroError]="Error token no esperado es ;\n"
            @punteroError+=1
            @punteroToken+=1
        end
        return axFac
    end

    #relacion → <= | < | > | >= | == | !=
    def relacion(lv)
        case @arrayTokens[@punteroToken].returnTipo
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
        when "DiferenteDe"
            axRel=match("DiferenteDe")
        end
        axRel.setLinea(lv)
        return axRel
    end

    #suma-op → + | - | ++ |--
    def sumaop(lv)
        case @arrayTokens[@punteroToken].returnTipo
        when "Suma"
            axSumop=match("Suma")
        when "Resta"
            axSumop=match("Resta")
        when "Incremento"
            axSumop=match("Incremento")
        when "Decremento"
            axSumop=match("Decremento")
        end
        axSumop.setLinea(lv)
        return axSumop
    end

    #mult-op → * | / | %
    def mulop(lv)
        case @arrayTokens[@punteroToken].returnTipo
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
end

#iniciar el programa
ct = ControlToken.new
ct.llenarDesdeArchivo("Tokens.txt")
sintactico = Sintactico.new(ct.getArray)
sintactico.programa
print "#{sintactico.ret}"
sintactico.imprimirErrores
