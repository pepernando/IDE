require_relative 'control_token'

ct = ControlToken.new #es una clase para manejar mis tokens
cterrores = ControlToken.new
linea=1 #Es una variable para la linea actual
columna=1 #Es una variable para la columna actual
contentToken = "" #Es lo que contiene el token
cadena = "" #Es el archivo completo
puntero = 0 #el indice actual
offsetiniaux = 0
coliniaux = 0
lineainiaux = 0
#contiene la ruta relativa del archivo

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

File.open(arch).each do |linea|
    linea.chomp!
    cadena+="#{linea}\n"
end

cadsize = cadena.size

palabrasResesrvadas = ["main","if","then","else","end","do","while","repeat","until","read","write","float","integer","bool"]

estados = {
  :inicio => 1,
  :suma => 2,
  :resta => 3,
  :asignacion => 4,
  :menorigual => 5,
  :mayorigual => 6,
  :comparacion => 7,
  :cadena => 8,
  :identificador => 9,
  :digito => 10,
  :posibledecimal => 11,
  :posiblecomment => 12,
  :inlinecomnent => 13,
  :diferente => 14,
  :multipecomment => 15,
  :posiblesalida => 16,
  :decimal => 17
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
      ct.addToken(linea,columna,'Residuo','%')
      estadoActual = estados[:inicio]
    when ';'
      ct.addToken(linea,columna,'PuntoyComa',';')
      estadoActual = estados[:inicio]
    when ','
      ct.addToken(linea,columna,'Coma',',')
      estadoActual = estados[:inicio]
    when /[[A-Z][a-z]]/
      estadoActual = estados[:identificador]
      contentToken = cadena[puntero]
    when /[[:digit:]]/
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
      #Ignorar
    when "\t"
      #Ignorar
    when '"'
      estadoActual = estados[:cadena]
      contentToken = ""
      offsetiniaux = puntero
      coliniaux = columna      
      lineainiaux = linea
    else
      if cadena[puntero] =~ /\n/
        linea+=1
        columna=0
      else
        cterrores.addToken(linea,columna,"Error",cadena[puntero])
      end
      estadoActual = estados[:inicio]
    end
  when estados[:suma]
    if cadena[puntero] == '+'
      ct.addToken(linea,columna,"Incremeno",'++')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Suma",'+')
      estadoActual = estados[:inicio]
    end
  when estados[:resta]
    if cadena[puntero] == '-'
      ct.addToken(linea,columna-1,"Decremento",'--')
      estadoActual = estados[:inicio]
    else
      puntero-=1
      columna-=1
      ct.addToken(linea,columna,"Resta",'-')
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
    if cadena[puntero] == '"'
      colaux = columna - contentToken.length
      ct.addToken(lineainiaux,coliniaux,"Cadena",contentToken)
      estadoActual = estados[:inicio]
    elsif cadena[puntero] =~ /\n/
      columna=0
      linea+=1
    else
      contentToken += cadena[puntero]            
    end
  when estados[:identificador]
    case cadena[puntero]
    when /[[A-Z][a-z]]/,/[[:digit:]]/,"_"
      contentToken += cadena[puntero]
    else
      colaux = columna - contentToken.length
      puntero-=1
      columna-=1
      #bandtemp = false
      
      #palabrasResesrvadas.each{|actual|
      #  if actual == contentToken
      #    bandtemp = true
      #  end
      #}

      if palabrasResesrvadas.include?(contentToken)
        ct.addToken(linea,colaux, contentToken.capitalize ,contentToken)
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
      #contentToken += cadena[puntero]
    else
      puntero-=1
      columna-=1
      colaux = columna - contentToken.length+1
      ct.addToken(linea,colaux,"Entero",contentToken)
      estadoActual = estados[:inicio]
    end
  when estados[:posibledecimal]
    if cadena[puntero] =~ /[[:digit:]]/
      contentToken += "."
      contentToken += cadena[puntero]
      estadoActual = estados[:decimal]
    else
      puntero-=2
      columna-=2
      colaux = columna - contentToken.length+1
      ct.addToken(linea,colaux,"Entero",contentToken)
      estadoActual = estados[:inicio]
    end
  when estados[:decimal]
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
      offsetiniaux = puntero-1
    when '/'
      estadoActual = estados[:inlinecomnent]
      offsetiniaux = puntero-1
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

cterrores.getallTokens

ct.getallTokens

File.open("Errores.txt",'w') {|f| f.write(cterrores.getallTokensString)}
File.open("Tokens.txt",'w') {|f| f.write(ct.getallTokensFormated)}

puts "Todo Correcto"

#File.open("../txtFiles/errores.txt",'w') {|f| f.write(cterrores.getallTokensString) }
#File.open("../txtFiles/styleddoc.txt",'w') {|f| f.write(styleddoc) }
