require_relative 'token'

class ControlToken
  def initialize
    @arrayTokens = []
    @arraytexto = ""
  end

  def addToken(linea,columna,tipo,contenido)
    t = Token.new(linea, columna, tipo, contenido)
    @arrayTokens << t
  end

  def getToken(i)
    if i < @arrayTokens.length
      @arrayTokens[i].toString
    else
      puts "El indice es menor al tamaño del Array"
    end
  end

  def getallTokens
    @arrayTokens.each{|x|
      x.toString
    }
  end

  def getallTokensString
    aux = ""
    @arrayTokens.each{|x|
      aux+="#{x.returnString}\n"
    }
    return aux
  end

  def getallTokensFormated
    aux = ""
    @arrayTokens.each{|x|
      aux+="#{x.returnStringFormated}\n"
    }
    return aux
  end

  def llenarDesdeArchivo(archivo)
    #arch = 'Tokens.txt'
    File.open(archivo).each do |linea|
      linea.chomp!
      lineas = linea.split("|")
      addToken(lineas[0],lineas[1],lineas[2],lineas[3])
    end
  end

  def getArray
    return @arrayTokens
  end

  def getSize
    return @arrayTokens.length
  end

end
