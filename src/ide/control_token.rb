require_relative 'token'

class ControlToken
  def initialize
    @token = []
  end

  def addToken( linea,columna,tipo,contenido)
    @token << Token.new(linea,columna,tipo,contenido)
  end

  def getToken(i)
    if i < @token.length
      @token[i].toString
    else
      puts "El indice es menor al tamaño del Array"
    end
  end

  def getallTokens
    @token.each{|x|
      x.toString
    }
  end
end
