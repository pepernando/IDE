class Token

  def initialize(linea,columna,tipo,contenido)
    # Instance variables
    @linea = linea
    @columna =columna
    @tipo = tipo
    @contenido = contenido
  end

  def toString
    puts "#{@linea} #{@columna} #{@tipo} #{@contenido}"
  end

  def returnString
    return "#{@linea} #{@columna} #{@tipo} #{@contenido}"
  end

  def returnStringFormated
    return "#{@linea}|#{@columna}|#{@tipo}|#{@contenido}"
  end

end
