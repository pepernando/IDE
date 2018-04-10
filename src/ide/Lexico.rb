require_relative 'control_token'

ct = ControlToken.new #es una clase para manejar mis tokens
cterrores = ControlToken.new
linea=1 #Es una variable para la linea actual
columna=1 #Es una variable para la columna actual
contentToken = "" #Es lo que contiene el token
cadena = "" #Es el archivo completo
puntero = 0 #el indice actual
#contiene la ruta relativa del archivo

#arch = 'pruebaLexico.txt'

argumentos = []

ARGV.each do|a|
  argumentos << a
end

if argumentos.size == 1
  arch = argumentos[0]
else
  puts "Error al introducir la ruta, demasiados argumentos"
  arch = ""
end


#para abrir y cargar ek archivo
File.open(arch).each do |linea|
  linea.chomp!
  cadena += linea + "\n"
end

cadsize = cadena.size

palabrasResesrvadas = ["main","if","then","else","end","do","while","repeat","until","read","write","float","integer","bool"]

estados = {
  :inicio => 1,
  :fin => 0,
  :suma => 2,
  :resta => 3,
  :menor => 4,
  :mayor => 5,
  :asignacion => 6,
  :menorigual => 7,
  :mayorigual => 8,
  :comparacion => 9,
  :cadena => 10,
  :identificador => 11,
  :digito => 12,
  :posibledecimal => 13,
  :posiblecomment => 14,
  :inlinecomnent => 15,
  :diferente => 16,
  :multipecomment => 17,
  :posiblesalida => 18
}
estadoActual = estados[:inicio]

#Inicio del Automata
while cadsize > puntero

  if columna == 0
    columna+=1
  end

  case estadoActual
  when estados[:inicio]
    case cadena[puntero]
    when '('
      ct.addToken(linea,columna,'ParentesisAbre','(')
      estadoActual = estados[:inicio]
    when ')'
      ct.addToken(linea,columna,'ParentesisCierra',')')
      estadoActual = estados[:inicio]
    when '{'
      ct.addToken(linea,columna,'LlaveAbre','{')
      estadoActual = estados[:inicio]
    when '}'
      ct.addToken(linea,columna,'LlaveCierra','}')
      estadoActual = estados[:inicio]
    when '*'
      ct.addToken(linea,columna,'Multiplicacion','*')
      estadoActual = estados[:inicio]
    when '%'
      ct.addToken(linea,columna,'Porciento','%')
      estadoActual = estados[:inicio]
    when /[[A-Z][a-z]]/
      #ct.addToken(linea,columna,'Letra',cadena[puntero])
      estadoActual = estados[:identificador]
      contentToken = cadena[puntero]
    when /[[:digit:]]/
      #ct.addToken(linea,columna,'Digito',cadena[puntero])
      estadoActual = estados[:digito]
      contentToken = cadena[puntero]
    when '+'
      estadoActual = estados[:suma]
    when '/'
      estadoActual = estados[:posiblecomment]
    when '<'
      estadoActual = estados[:menorigual]
    when '>'
      estadoActual = estados[:mayorigual]
    when '!'
      estadoActual = estados[:diferente]
    when '-'
      estadoActual = estados[:resta]
    when ':'
      estadoActual = estados[:asignacion]
    when '='
      estadoActual = estados[:comparacion]
    when ' '
      #nada
    when '"'
      estadoActual = estados[:cadena]
      contentToken = ""
    else
      if cadena[puntero] =~ /\n/
        linea+=1
        columna=0
      else
        #ct.addToken(linea,columna,"Error",cadena[puntero]
        cterrores.addToken(linea,columna,"Error",cadena[puntero])
      end
    estadoActual = estados[:inicio]
  end
  when estados[:suma]
    if cadena[puntero] == '+'
      ct.addToken(linea,columna-1,"MasMas",'++')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Mas",'+')
      estadoActual = estados[:inicio]
    end
  when estados[:resta]
    if cadena[puntero] == '-'
      ct.addToken(linea,columna-1,"MenosMenos",'--')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Menos",'-')
      estadoActual = estados[:inicio]
    end
  when estados[:menorigual]
    if cadena[puntero] == '='
      ct.addToken(linea,columna-1,"MenorIgual",'<=')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Menor",'<')
      estadoActual = estados[:inicio]
    end
  when estados[:mayorigual]
    if cadena[puntero] == '='
      ct.addToken(linea,columna-1,"MayorIgual",'>=')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Mayor",'>')
      estadoActual = estados[:inicio]
    end
  when estados[:diferente]
    if cadena[puntero] == '='
      ct.addToken(linea,columna-2,"DiferenteDe",'!=')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      #ct.addToken(linea,columna,"Error",'!')
      cterrores.addToken(linea,columna,"Error",'!')
      estadoActual = estados[:inicio]
    end
  when estados[:asignacion]
    if cadena[puntero] == '='
      ct.addToken(linea,columna-2,"Asignacion",':=')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      #ct.addToken(linea,columna,"Error",':')
      cterrores.addToken(linea,columna,"Error",':')
      estadoActual = estados[:inicio]
    end
  when estados[:comparacion]
    if cadena[puntero] == '='
      ct.addToken(linea,columna-2,"Comparacion",'==')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      #ct.addToken(linea,columna,"Error",'=')
      cterrores.addToken(linea,columna,"Error",'=')
      estadoActual = estados[:inicio]
    end
  when estados[:cadena]
    if cadena[puntero] != '"'
      contentToken += cadena[puntero]
    else
      colaux = columna - contentToken.length
      ct.addToken(linea,colaux,"Cadena",contentToken)
      estadoActual = estados[:inicio]
    end
  when estados[:identificador]
    case cadena[puntero]
    when /[[A-Z][a-z]]/,/[[:digit:]]/,"_"
      contentToken += cadena[puntero]
    else
      colaux = columna - contentToken.length
      puntero-=1
      columna-=1
      bandtemp = false
      palabrasResesrvadas.each{|actual|
        if actual == contentToken
          bandtemp = true
        end
      }
      if bandtemp == true
        ct.addToken(linea,colaux,"PalabraReservada",contentToken)
      else
        ct.addToken(linea,colaux,"Identificador",contentToken)
      end
      estadoActual = estados[:inicio]
    end
  when estados[:digito]
    if cadena[puntero] =~ /[[:digit:]]/
      contentToken += cadena[puntero]
    elsif cadena[puntero] == '.'
      estadoActual = estados[:posibledecimal]
      contentToken += cadena[puntero]
    else
      puntero-=1
      columna-=1
      colaux = columna - contentToken.length+1
      ct.addToken(linea,colaux,"Entero",contentToken)
      estadoActual = estados[:inicio]
    end
  when estados[:posibledecimal]
    if cadena[puntero] =~ /[[:digit:]]/
      contentToken += cadena[puntero]
    else
      puntero-=1
      columna-=1
      colaux = columna - contentToken.length+1
      ct.addToken(linea,colaux,"Decimal",contentToken)
      estadoActual = estados[:inicio]
    end
  when estados[:posiblecomment]
    case cadena[puntero]
    when '*'
      estadoActual = estados[:multipecomment]
    when '/'
      estadoActual = estados[:inlinecomnent]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Division",'/')
      estadoActual = estados[:inicio]
    end

  when estados[:multipecomment]
    if cadena[puntero] == '*'
      estadoActual = estados[:posiblesalida]
    elsif cadena [puntero] =~ /\n/
      columna=0
      linea+=1
    end

  when estados[:posiblesalida]
    if cadena[puntero]== '/'
      estadoActual = estados[:inicio]
    elsif cadena [puntero] =~ /\n/
      columna=0
      linea+=1
      estadoActual = estados[:multipecomment]
    else
      estadoActual = estados[:multipecomment]
    end

  when estados[:inlinecomnent]
      if cadena [puntero] =~ /\n/
        estadoActual = estados[:inicio]
        columna=0
        linea+=1
      end
  end

  puntero+=1
  columna+=1
end
#Fin del Automata

ct.getallTokens
puts"errores:"
cterrores.getallTokens