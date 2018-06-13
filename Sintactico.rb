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
                node.setTipoNodo(simbol)
                node.setValor(@arrayTokens[@punteroToken].returnContenido)
                @punteroToken+=1
                return node
            else
                @arrayErrores[@punteroError]="Token Consumido #{@arrayTokens[@punteroToken].returnContenido} en #{@arrayTokens[@punteroToken-1].returnUbicacion}\n"
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

    def returnErrores
        cadaux = ""
        @arrayErrores.uniq! #este elimina los duplicados
        @arrayErrores.each{ |actual| #solo itera el array y lo imprime
            cadaux += actual
        }
        return cadaux
    end

    def returnArbolTexto
        return @nodoRaiz.texto(0)
    end

    def imp
        @nodoRaiz.imp
    end

    #Programa -> main { lista-declaración lista-sentencia }
    def programa
        raiz=Nodo.new
        raiz.setTipoNodo("Main")
        auxil=match("Main")
        if auxil != nil
            @nodoRaiz=auxil
        else
            @arrayErrores[@punteroError]="El token esperado era Main #{@auxiliarTexto}"
            @punteroError+=1
            while (@arrayTokens[@punteroToken].returnTipo != "LlaveAbre") do @punteroToken+=1 end

        end
        auxil=match("LlaveAbre")
        if auxil == nil
            @punteroError+=1
        end
        auxil=listaDeclaracion
        if auxil != nil
            a=0
            while a<auxil.length do
                @nodoRaiz.agHij(auxil[a])
                a+=1
            end
        end
        auxil=listaSentencias
        if auxil != nil
            a=0
            while a<auxil.length do
                @nodoRaiz.agHij(auxil[a])
                a+=1
            end
        end
        auxil=match("LlaveCierra")
        if auxil == nil
            @arrayErrores[@punteroError]= "Token esperado era } #{@auxiliarTexto}\n"
            @punteroError+=1
        end
    end

    # lista-declaración -> { declaración ; }
    def listaDeclaracion
        ligram=[]
        ban=0
        while( nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "Integer" ||@arrayTokens[@punteroToken].returnTipo == "Bool" || @arrayTokens[@punteroToken].returnTipo == "Float")  ) do
            ligram[ban]=declaracion
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
    def declaracion
        dec = tipo
        lisvar = listaVariables
        a=0
        while a<lisvar.length do
            dec.agHij(lisvar[a])
            a+=1
        end
        return dec
    end

    #tipo → integer | float | bool
    def tipo
        axVal = Nodo.new
        case @arrayTokens[@punteroToken].returnTipo
        when "Integer"
            axVal=match("Integer")
        when "Float"
            axVal=match("Float")
        when "Bool"
            axVal=match("Bool")
        end
        return axVal
    end

    #lista-sentencia -> { sentencia }
    def listaSentencias
        liSen=[]
        ban=0
        while  nodoExiste && @arrayTokens[@punteroToken].returnTipo != "LlaveCierra" do
            auxil=sentencia
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
    def listaVariables
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
    def sentencia
        aux=Nodo.new
        case @arrayTokens[@punteroToken].returnTipo
        when "LlaveAbre"
            aux=bloque
        when "If"
            aux=seleccion
        when "Do"
            aux=repeti
        when "While"
            aux=itera
        when "Read"
            aux=sentRead
        when "Write"
            aux=sentWrite
        when "Identificador"
            aux=asignacion
        when "PuntoyComa"
            @punteroToken+=1
        else
            @arrayErrores[@punteroError]="El token que se esperaba #{@arrayTokens[@punteroToken].returnContenido} en #{@arrayTokens[@punteroToken-1].returnUbicacion}\n"
            @punteroError+=1
            @punteroToken+=1
        end
        return aux
    end

    #bloque -> { lista-sentencia }
    def bloque
        nodoAux = Nodo.new
        nodoAux.setTipoNodo('4')
        nodoAux.setValor('BloqueSen')
        match("LlaveAbre")
        auxil=listaSentencias
        if auxil != nil
            a=0
            while a<auxil.length do
                nodoAux.agHij(auxil[a])
                a+=1
            end
        end
        match("LlaveCierra")
        return nodoAux
    end

    #seleccion -> if ( expresion ) then bloque [ else bloque ]
    def seleccion
        axSel=match("If")
        match("ParentesisAbre")
        aux=expresion
        axSel.agHij(aux)
        match("ParentesisCierra")
        match("Then")
        aux=bloque
        axSel.agHij(aux)
        if(nodoExiste && @arrayTokens[@punteroToken].returnTipo == "Else")
            els=match("Else")
            axSel.agHij(els)
            aux=bloque
            els.agHij(aux)
        end
        return axSel
    end

    #asignación → identificador := expresión ;
    def asignacion
        aux=match("Identificador")
        if @arrayTokens[@punteroToken].returnTipo =="Incremento" || @arrayTokens[@punteroToken].returnTipo=="Decremento"
            axA=nil
            if @arrayTokens[@punteroToken].returnTipo =="Incremento"
                axA=Nodo.new
                axA.setTipoNodo("Suma")
                axA.setValor("+")
            elsif @arrayTokens[@punteroToken].returnTipo =="Decremento"
                axA=Nodo.new
                axA.setTipoNodo("Resta")
                axA.setValor("-")
            end
            aux2=Nodo.new
            aux2.setTipoNodo("TokenInicial")
            aux2.setValor('1')
            a=Nodo.new
            a.setTipoNodo(aux.getTipoNodo)
            a.setValor(aux.getValor)
            axA.agHij(a)
            axA.agHij(aux2)
            axAsi=Nodo.new
            axAsi.setTipoNodo("Asignacion")
            axAsi.setValor(":=")
            axAsi.agHij(aux)
            axAsi.agHij(axA)
            @punteroToken+=1
            match("PuntoyComa")
            return axAsi
        end
        axAsi=match("Asignacion")
        axAsi.agHij(aux)
        aux=expresion
        axAsi.agHij(aux)
        match("PuntoyComa")
        return axAsi
    end

    #repetición → do bloque until ( expresión ) ;
    def repeti()
        axRep=match("Do")
        aux=bloque
        axRep.agHij(aux)
        util=match("Until")
        axRep.agFam(util)
        match("ParentesisAbre")
        aux=expresion
        util.agHij(aux)
        match("ParentesisCierra")
        match("PuntoyComa")
        return axRep
    end

    #iteración → while ( expresión ) bloque
    def itera
        axIte=match("While")
        match("ParentesisAbre")
        aux=expresion
        axIte.agHij(aux)
        match("ParentesisCierra")
        aux=bloque
        axIte.agHij(aux)
        return axIte
    end

    #sent-read → read identificador ;
    def sentRead
        axSr=match("Read")
        aux=match("Identificador")
        axSr.agHij(aux)
        match("PuntoyComa")
        return axSr
    end

    #sent-write → write cadena, expression;|write cadena ;
    def sentWrite
        axSw=match("Write")
        aux=match("Cadena")
        axSw.agHij(aux)
        if nodoExiste && @arrayTokens[@punteroToken].returnTipo == "Coma"
            match("Coma")
            aux=expresion
            axSw.agHij(aux)
        end
        match("PuntoyComa")
        return axSw
    end

    #expresión -> expresion-simple [ relación expresion-simple ]
    def expresion
        axExp=expresionSimple
        if nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "MayorIgual" || @arrayTokens[@punteroToken].returnTipo == "Mayor" || @arrayTokens[@punteroToken].returnTipo == "Menor" || @arrayTokens[@punteroToken].returnTipo == "MenorIgual"  || @arrayTokens[@punteroToken].returnTipo == "Comparacion"  || @arrayTokens[@punteroToken].returnTipo == "DiferenteDe")        # si el token  sguiente estan en el rango realcional entonces es una expsim rel expsim
            aux=relacion
            auEx=axExp
            axExp=aux
            axExp.agHij(auEx)
            aux=expresionSimple
            axExp.agHij(aux)
        end
        return axExp
    end

    #expresion-simple -> termino { suma-op termino }
    def expresionSimple
        axEsim=termino
        while nodoExiste &&  (@arrayTokens[@punteroToken].returnTipo == "Suma" || @arrayTokens[@punteroToken].returnTipo == "Resta" || @arrayTokens[@punteroToken].returnTipo == "Incremento" || @arrayTokens[@punteroToken].returnTipo =="Decremento") do       # si mi siguiente token se encuentra entre en 22 y 25 se cicla
            auxS=axEsim
            axEsim=sumaop
            axEsim.agHij(auxS)
            aux2=termino
            axEsim.agHij(aux2)
        end
        return axEsim
    end

    #termino -> factor { mult-op factor }
    def termino
        axTer=factor
        while nodoExiste && (@arrayTokens[@punteroToken].returnTipo == "Multiplicacion" || @arrayTokens[@punteroToken].returnTipo == "Division" || @arrayTokens[@punteroToken].returnTipo == "Residuo")
            auxT=axTer
            axTer=mulop
            axTer.agHij(auxT)
            aux2=factor

            axTer.agHij(aux2)
        end
        return axTer
    end

    #factor → ( expresión ) | numero | identificador
    def factor
        if nodoExiste
            case  @arrayTokens[@punteroToken].returnTipo
            when "ParentesisAbre"
                match("ParentesisAbre")
                axFac=expresion
                match("ParentesisCierra")
            when "Entero"
                axFac=match("Entero")
            when "Decimal"
                axFac=match("Decimal")
            when "Identificador"
                axFac=match("Identificador")
            end
        else
            @arrayErrores[@punteroError]="No se eperaba el siguiente ;\n"
            @punteroError+=1
            @punteroToken+=1
        end
        return axFac
    end

    #relacion → <= | < | > | >= | == | !=
    def relacion
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
        return axRel
    end

    #suma-op → + | - | ++ |--
    def sumaop
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
        return axSumop
    end

    #mult-op → * | / | %
    def mulop
        case @arrayTokens[@punteroToken].returnTipo
        when "Multiplicacion"
            axMulop=match("Multiplicacion")
        when "Division"
            axMulop=match("Division")
        when "Residuo"
            axMulop=match("Residuo")
        end
        return axMulop
    end
end

#iniciar el programa
ct = ControlToken.new
ct.llenarDesdeArchivo("Tokens.txt")

sintactico = Sintactico.new(ct.getArray)
sintactico.programa

puts "#{sintactico.returnArbolTexto}"
puts "Errores \n#{sintactico.returnErrores}"

File.open("Arbol.txt",'w') {|f| f.write(sintactico.returnArbolTexto)}
File.open("ErroresS.txt",'w') {|f| f.write(sintactico.returnErrores)}
