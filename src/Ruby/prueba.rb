require 'strscan'

# expr := term
#       | term AND expr
#       | term OR expr
# term := value
#       | atom ':' value
# atom := word+
#       | quoted_string
# value := atom
#        | '(' expr ')'

class Expression < Struct.new(:op, :left, :right)
end

class Field < Struct.new(:name, :value)
end

def parse_expr(scanner)
  left = parse_term(scanner)

  scanner.skip(/\s+/)
  op = scanner.scan(/AND|OR/i)

  if op
    Expression.new(op.downcase.to_sym, left, parse_expr(scanner))
  else
    left
  end
end

def parse_term(scanner)
  scanner.skip(/\s+/)

  value = parse_value(scanner)
  return value if value.is_a?(Expression)

  if scanner.skip(/:/)
    Field.new(value, parse_value(scanner))
  else
    value
  end
end

def parse_atom(scanner)
  scanner.scan(/\w+/) ||
    parse_quoted_string(scanner) ||
    raise("expected an atom at #{scanner.pos}")
end

def parse_quoted_string(scanner)
  start = scanner.pos
  delim = scanner.scan(/['"]/)
  if delim
    scanner.scan(/[^#{delim}]*/).tap do
      scanner.scan(/#{delim}/) or raise "quoted string not terminated (start at #{start})"
    end
  end
end

def parse_value(scanner)
  start = scanner.pos
  if scanner.skip(/\(/)
    parse_expr(scanner).tap do
      scanner.scan(/\)/) or raise "expression not terminated (start at #{start})"
    end
  else
    parse_atom(scanner)
  end
end

def parse(string)
  scanner = StringScanner.new(string)
  parse_expr(scanner)
end

require 'rspec'

describe "#parse" do
  it "should parse words as atoms" do
    expect(parse("hello")).to be == "hello"
  end

  it "should parse digits as atoms" do
    expect(parse("1234")).to be == "1234"
  end

  it "should parse single-quoted string as atom" do
    expect(parse("'hello world'")).to be == "hello world"
  end

  it "should parse double-quoted string as atom" do
    expect(parse('"hello world"')).to be == "hello world"
  end

  it "should parse AND expression" do
    expr = parse("hello AND world")
    expect(expr.op).to be == :and
    expect(expr.left).to be == "hello"
    expect(expr.right).to be == "world"
  end

  it "should parse OR expression" do
    expr = parse("hello OR world")
    expect(expr.op).to be == :or
    expect(expr.left).to be == "hello"
    expect(expr.right).to be == "world"
  end

  it "should chain expressions together" do
    expr = parse("hello AND world OR other")
    expect(expr.op).to be == :and
    expect(expr.left).to be == "hello"
    expect(expr.right.op).to be == :or
    expect(expr.right.left).to be == "world"
    expect(expr.right.right).to be == "other"
  end

  it "should parse field specifications" do
    field = parse("hello:world")
    expect(field.name).to be == "hello"
    expect(field.value).to be == "world"
  end

  it "should parse field specifications with quotes" do
    field = parse("hello:'cruel world'")
    expect(field.name).to be == "hello"
    expect(field.value).to be == "cruel world"
  end

  it "should parse field with expression as value" do
    field = parse("hello:(this AND that)")
    expect(field.name).to be == "hello"
    expect(field.value.op).to be == :and
    expect(field.value.left).to be == "this"
    expect(field.value.right).to be == "that"
  end
end