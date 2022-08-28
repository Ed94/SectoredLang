class_name SRegex extends Object


# Simple Regular Expressions
# This is a "high-level" langauge and transpiler for regex
# That makes it easier to write out and read
# than the original notation or syntax.
# 
# The main interface function is transpile( <string> )
# Which can take any valid string from gdscript.


# Lexer

const TokenType : Dictionary = \
{
	fmt_S = "Formatting",
	cmt_SL = "Comment Single Line",
	
	str_start = "String Start",
	str_end   = "String End",
	
	glyph_bPOpen  = "\\(",
	glyph_bPClose = "\\)",

	expr_PStart = "Parenthesis Start",
	expr_PEnd   = "Parenthesis End",

	glyph_between   = "Glyphs Between",
	glyph_digit     = "Digit",
	glyph_inline    = "inline",
	glyph_space     = "Space",
	glyph_word      = "Word",
	glyph_ws        = "Whitespace",
	glyph_linebreak = "Line Break",

	glyph_dash    = "-",
	glyph_dot     = ". dot",
	glyph_excla   = "! Mark",
	glyph_vertS   = "\\|",
	glyph_dQuote  = "\"",

	op_lazy   = "Lazy Operator",
	op_look   = "Lookahead",
	op_not    = "Not Operator",
	op_repeat = "Repeating Operator",
	op_union  = "Union Operator",

	ref     = "Backreference Group",
	set     = "Set",

	string = "String",
	
	glyph = "Glyph",
}

const Spec : Dictionary = \
{
	TokenType.fmt_S : "^\\s",
	TokenType.cmt_SL: "^(\\(\\?\\#).+(\\))",
	
	TokenType.str_start : "^\\bstart\\b",
	TokenType.str_end   : "^\\bend\\b",

	TokenType.string : "^\"[^\"]*\"",
	
	TokenType.glyph_bPOpen  : "^\\\\\\(",
	TokenType.glyph_bPClose : "^\\\\\\)",

	TokenType.expr_PStart : "^\\(",
	TokenType.expr_PEnd   : "^\\)",

	TokenType.glyph_between   : "^\\-",
	TokenType.glyph_digit     : "^\\bdigit\\b",
	TokenType.glyph_inline    : "^\\binline\\b",
	TokenType.glyph_space     : "^\\bspace\\b",
	TokenType.glyph_word      : "^\\bword\\b",
	TokenType.glyph_ws        : "^\\bwhitespace\\b",
	TokenType.glyph_linebreak : "^\\blinebreak\\b",

	TokenType.op_lazy   : "^\\.\\blazy\\b",
	TokenType.op_repeat : "^\\.\\brepeat\\b",

	TokenType.glyph_dash    : "^\\\\\\-",
	TokenType.glyph_dot     : "^\\\\\\.",
	TokenType.glyph_excla   : "^\\\\\\!",
	TokenType.glyph_vertS   : "^\\\\\\|",
	TokenType.glyph_dQuote  : "^\\\\\"",

	TokenType.op_look   : "^\\blook\\b",
	TokenType.op_not    : "^\\!",
	TokenType.op_union  : "^\\|",

	TokenType.ref       : "^\\bbackref\\b",
	TokenType.set       : "^\\bset\\b",

	TokenType.glyph     : "^[^\\s]"
}


class Token:
	var Type  : String
	var Value : String


var SourceText : String
var Cursor     : int
var SpecRegex  : Dictionary
var Tokens     : Array
var TokenIndex : int = 0


func compile_regex():
	for type in TokenType.values() :
		var \
		regex = RegEx.new()
		var _spec = Spec[type]
		regex.compile( Spec[type] )
		
		SpecRegex[type] = regex

func init(programSrcText):
	SourceText = programSrcText
	Cursor     = 0
	TokenIndex = 0

	if SpecRegex.size() == 0 :
		compile_regex()

	tokenize()

func next_Token():
	
	var nextToken = null
	
	if Tokens.size() > TokenIndex :
		nextToken   = Tokens[TokenIndex]
		TokenIndex += 1
	
	return nextToken

func reached_EndOfText():
	return Cursor >= SourceText.length()

func tokenize():
	Tokens.clear()

	while reached_EndOfText() == false :
		var srcLeft = SourceText.substr(Cursor)
		var token   = Token.new()

		var error = true
		for type in TokenType.values() :
			var result = SpecRegex[type].search( srcLeft )
			if  result == null || result.get_start() != 0 :
				continue
			
			# Skip Comments
			if type == TokenType.cmt_SL :
				Cursor += result.get_string().length()
				error   = false
				break
			
			# Skip Whitespace
			if type == TokenType.fmt_S :
				var addVal   = result.get_string().length()
				
				Cursor += addVal
				error   = false
				break

			token.Type   = type
			token.Value  = result.get_string()
			Cursor      += ( result.get_string().length() )
			
			Tokens.append( token )
			
			error = false
			break;

		if error :
#			var assertStrTmplt = "next_Token: Source text not understood by tokenizer at Cursor pos: {value} -: {txt}"
#			var assertStr      = assertStrTmplt.format({"value" : Cursor, "txt" : srcLeft})
#			assert(true != true, assertStr)
			return

# End : Lexer



# Parser

class ASTNode:
	var Type  : String
	var Value # Not specifing a type implicity declares a Variant type.
	
	func array_Serialize(array, fn_objSerializer) :
		var result = []

		for entry in array :
			if typeof(entry) == TYPE_ARRAY :
				result.append( array_Serialize( entry, fn_objSerializer ))

			elif typeof(entry) == TYPE_OBJECT :
				result.append( entry.fn_objSerializer() )

			else :
				result.append( entry )
				
		return result

	func to_SExpression():
		var expression = [ Type ]

		if typeof(Value) == TYPE_ARRAY :
			var to_SExpression_Fn = to_SExpression
			
			var array = array_Serialize( self.Value, to_SExpression_Fn )
			
			expression.append(array)
			return expression
			
		if typeof(Value) == TYPE_OBJECT :
			var result = [ Type, Value.to_SExpression() ]
			return result
			
		expression.append(Value)
		return expression
	
	func to_Dictionary():
		if typeof(Value) == TYPE_ARRAY :
			var \
			to_Dictionary_Fn = to_Dictionary
						
			var array = array_Serialize( self.Value, to_Dictionary_Fn )
			var result = \
			{
				Type  = self.Type,
				Value = array
			}
			return result
			
		if typeof(Value) == TYPE_OBJECT :
			var result = \
			{
				Type  = self.Type,
				Value = self.Value.to_Dictionary()
			}
			return result

		var result = \
		{ 
			Type  = self.Type,
			Value = self.Value
		}
		return result

const NodeType : Dictionary = \
{
	expression = "Expression",

	between = "Glyphs Between Set",
	capture = "Capture Group",
	lazy    = "Lazy",
	look    = "Lookahead",
	op_not  = "Not Operator",
	ref     = "Backreference Group",
	repeat  = "Repeat",
	set     = "Set",
	union   = "Union",

	digit         = "Digit",
	inline        = "Any Inline",
	space         = "Space",
	word          = "Word",
	whitespace    = "Whitespace",
	linebreak     = "Line Break",
	string        = "String",
	str_start     = "String Start",
	str_end       = "String End",

	glyph = "Glyph",
}


var NextToken   : Token

# --------------------------------------------------------------------- HELPERS

# Gets the next token only if the current token is the specified intended token (tokenType)
func eat(tokenType):
	var currToken = NextToken
	
#	assert(currToken != null, "eat: NextToken was null")
	
#	var assertStrTmplt = "eat: Unexpected token: {value}, expected: {type}"
#	var assertStr      = assertStrTmplt.format({"value" : currToken.Value, "type" : tokenType})
#
#	assert(currToken.Type == tokenType, assertStr)
	
	NextToken = next_Token()
	
	return currToken

func is_Glyph(glyph = NextToken) :
	match glyph.Type:
		TokenType.glyph :
			return true
		TokenType.glyph_digit :
			return true
		TokenType.glyph_inline :
			return true
		TokenType.glyph_word :
			return true
		TokenType.glyph_ws :
			return true
		TokenType.glyph_linebreak:
			return true
		TokenType.glyph_dash :
			return true
		TokenType.glyph_dot :
			return true
		TokenType.glyph_excla :
			return true
		TokenType.glyph_vertS :
			return true
		TokenType.glyph_bPOpen :
			return true
		TokenType.glyph_bPClose :
			return true
		TokenType.glyph_dQuote :
			return true
			
	return false

func is_GlyphOrStr() :
	return is_Glyph() || NextToken.Type == TokenType.string
	
func is_GroupToken() :
	if NextToken.Value.length() == 2 && NextToken.Value[0] == "\\" :
		match NextToken.Value[1] :
			"0" : continue
			"1" : continue
			"2" : continue
			"3" : continue
			"4" : continue
			"5" : continue
			"6" : continue
			"7" : continue
			"8" : continue
			"9" : continue
			_:
				return true
	return false
	
func is_Number() :
	var \
	regex = RegEx.new()
	regex.compile("^\\d")
	
	return regex.search(NextToken.Value) != null
	
func is_RegExToken() :
	match NextToken.Value :
		"^" : 
			return true
		"$" :
			return true
		"*" : 
			return true
		"[" :
			return true
		"]" : 
			return true
		"?" :
			return true	
	return

# --------------------------------------------------------------------- HELPERS

#   > Union
# Union
# : expression | expression ..
# | expression
# ;
func parse_OpUnion(endToken):
	var expression = parse_Expression(endToken)

	if NextToken == null || NextToken.Type != TokenType.op_union :
		return expression

	eat(TokenType.op_union)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.union
	node.Value = [ expression, parse_OpUnion(endToken) ]

	return node

#   > Union
# Expression
#   : EVERYTHING (Almost)
#   ;
func parse_Expression(endToken):
	var \
	node       = ASTNode.new()
	node.Type  = NodeType.expression
	node.Value = []

	while NextToken != null && NextToken.Type != TokenType.op_union :
		if endToken != null && NextToken.Type == endToken :
			break
			
		match NextToken.Type :
			TokenType.str_start :
				node.Value.append( parse_StrStart() )

			TokenType.str_end :
				node.Value.append( parse_StrEnd() )
				
			TokenType.expr_PStart :
				node.Value.append( parse_CaptureGroup() )

			TokenType.glyph :
				node.Value.append( parse_Glyph() )

			TokenType.glyph_digit :
				node.Value.append( parse_GlyphDigit() )

			TokenType.glyph_inline :
				node.Value.append( parse_GlyphInline() )
				
			TokenType.glyph_space :
				node.Value.append( parse_GlyphSpace() )

			TokenType.glyph_word :
				node.Value.append( parse_GlyphWord() )
				
			TokenType.glyph_linebreak:
				node.Value.append( parse_GlyphLineBreak() )

			TokenType.glyph_ws :
				node.Value.append( parse_GlyphWhitespace() )


			TokenType.glyph_dash :
				node.Value.append( parse_GlyphDash() )

			TokenType.glyph_dot :
				node.Value.append( parse_GlyphDot() )

			TokenType.glyph_excla :
				node.Value.append( parse_GlyphExclamation() )

			TokenType.glyph_vertS :
				node.Value.append( parse_GlyphVertS() )

			TokenType.glyph_bPOpen :
				node.Value.append( parse_Glyph_bPOpen() )

			TokenType.glyph_bPClose :
				node.Value.append( parse_Glyph_bPClose() )
				
			TokenType.glyph_dQuote :
				node.Value.append( parse_Glyph_DQuote() )


			TokenType.op_look :
				node.Value.append( parse_OpLook() )

			TokenType.op_not :
				node.Value.append( parse_OpNot() )

			TokenType.op_repeat:
				node.Value.append( parse_OpRepeat() )

			TokenType.ref :
				node.Value.append( parse_Backreference() )

			TokenType.set :
				node.Value.append( parse_Set() )

			TokenType.string :
				node.Value.append( parse_String() )

	return node

#   > Expression
func parse_StrStart():
	eat(TokenType.str_start)

	var \
	node      = ASTNode.new()
	node.Type = NodeType.str_start

	return node

#   > Expression
func parse_StrEnd():
	eat(TokenType.str_end)

	var \
	node      = ASTNode.new()
	node.Type = NodeType.str_end

	return node

#   > Expression
# Between
#   : glyph
#   | glyph - glyph
#   ;
func parse_Between(quantifier : bool = false):
	var glyph
	
	match NextToken.Type :
		TokenType.glyph :
			glyph = parse_Glyph(quantifier)
#		TokenType.glyph_digit :
#			glyph = parse_GlyphDigit()
		TokenType.glyph_inline :
			glyph =  parse_GlyphInline()
#		TokenType.glyph_word :
#			glyph =  parse_GlyphWord()
#		TokenType.glyph_nl :
		TokenType.glyph_ws :
			glyph = parse_GlyphWhitespace()
		TokenType.glyph_dash :
			glyph = parse_GlyphDash()
		TokenType.glyph_dot :
			glyph = parse_GlyphDot()
		TokenType.glyph_excla :
			glyph = parse_GlyphExclamation()
		TokenType.glyph_vertS :
			glyph = parse_GlyphVertS()
		TokenType.glyph_bPOpen :
			glyph = parse_Glyph_bPOpen()
		TokenType.glyph_bPClose :
			glyph = parse_Glyph_bPClose()		
		TokenType.glyph_dQuote :
			glyph = parse_Glyph_DQuote()

	if NextToken.Type != TokenType.glyph_between :
		return glyph

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.between
	node.Value = []

	node.Value.append( glyph )

	if NextToken.Type == TokenType.glyph_between:
		eat(TokenType.glyph_between)

		if is_Glyph() :
			node.Value.append( parse_Glyph(quantifier) )

	return node

#   > Expression
# CaptureGroup
#   : ( OpUnion )
#   ;
func parse_CaptureGroup():
	eat(TokenType.expr_PStart)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.capture
	node.Value = parse_OpUnion(TokenType.expr_PEnd)

	eat(TokenType.expr_PEnd)

	return node

#   > Expression
#   > Between
# Glyph
#   : glyph
#   ;
func parse_Glyph(numerical = false):	
	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	
	node.Value = ""
	
	while NextToken.Type == TokenType.glyph :
		if NextToken.Value == "/" :
			node.Value += "\\/"
		elif is_RegExToken() :
			node.Value += "\\" + NextToken.Value
		elif is_GroupToken() :
			node.Value += "\\\\" + NextToken.Value[1] 
		else : 
			node.Value += NextToken.Value
	
		eat(TokenType.glyph)
		
		if numerical == false :
			break

	return node

func parse_GlyphDigit():
	eat(TokenType.glyph_digit)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.digit
	node.Value = "\\d"

	return node

func parse_GlyphInline():
	eat(TokenType.glyph_inline)

	var \
	node = ASTNode.new()
	node.Type  = NodeType.inline
	node.Value = "."

	return node
	
func parse_GlyphSpace():
	eat(TokenType.glyph_space)
	
	var \
	node = ASTNode.new()
	node.Type = NodeType.space
	node.Value = " "
	
	if NextToken.Type == TokenType.expr_PStart :
		eat(TokenType.expr_PStart)
		
		var numGlyph = parse_Glyph(true)
		for n in range(int(numGlyph.Value)) :
			node.Value += " "
			
		eat(TokenType.expr_PEnd)
	
	return node

func parse_GlyphWord():
	eat(TokenType.glyph_word)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.word
	node.Value = "\\w"

	return node
	
func parse_GlyphLineBreak():
	eat(TokenType.glyph_linebreak)
	
	var \
	node       = ASTNode.new()
	node.Type  = NodeType.linebreak
	node.Value = "\\R"
	
	return node

func parse_GlyphWhitespace():
	eat(TokenType.glyph_ws)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.whitespace
	node.Value = "\\s"

	return node

func parse_GlyphDash():
	eat(TokenType.glyph_dash)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\\-"

	return node

func parse_GlyphDot():
	eat(TokenType.glyph_dot)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\\."

	return node

func parse_GlyphExclamation():
	eat(TokenType.glyph_excla)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "!"

	return node

func parse_GlyphVertS():
	eat(TokenType.glyph_vertS)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\\|"
	
	return node

func parse_Glyph_bPOpen():
	eat(TokenType.glyph_bPOpen)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\\("
	
	return node

func parse_Glyph_bPClose():
	eat(TokenType.glyph_bPClose)

	var \
	node = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\\)"
	
	return node

func parse_Glyph_DQuote():
	eat(TokenType.glyph_dQuote)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.glyph
	node.Value = "\""
	
	return node

#   > Expression
#   : .lazy
#   ;
func parse_OpLazy():
	eat(TokenType.op_lazy)

	var \
	node      = ASTNode.new()
	node.Type = NodeType.lazy

	return node

#   > Expression
#   > OpNot
# Look
#   : look ( Expression )
#   ;
func parse_OpLook():
	eat(TokenType.op_look)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.look
	node.Value = parse_CaptureGroup()
	
	return node

#   > Expression
# OpNot
#   : ! 
#   | CaptureGroup
#   | GlyphDigit
#   | GlyphWord
#   | GlyphWhitespace
#   | OpLook
#   | String
#   | Set
#   ; 
func parse_OpNot():
	eat(TokenType.op_not)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.op_not

	match NextToken.Type:
		TokenType.expr_PStart:
			node.Value = parse_CaptureGroup()

		TokenType.glyph_digit:
			node.Value = parse_GlyphDigit()

		TokenType.glyph_word:
			node.Value = parse_GlyphWord()
			
		TokenType.glyph_linebreak:
			node.Value = parse_GlyphLineBreak()
			
		TokenType.glyph_ws:
			node.Value = parse_GlyphWhitespace()

		TokenType.op_look:
			node.Value = parse_OpLook()

		TokenType.string:
			node.Value = parse_String()

		TokenType.set:
			node.Value = parse_Set()

	return node

#   > Expression
# OpRepeat
#   : .repeat ( opt# optBetween opt# ) opt.lazy
#   ;
func parse_OpRepeat():
	eat(TokenType.op_repeat)

	var \
	node      = ASTNode.new()
	node.Type = NodeType.repeat

	var vrange = null
	var lazy   = null

	eat(TokenType.expr_PStart)

	vrange = parse_Between(true)
	
	eat(TokenType.expr_PEnd)

	if NextToken && NextToken.Type == TokenType.op_lazy :
		lazy = parse_OpLazy();
	
	node.Value = [ vrange, lazy ] 

	return node

func parse_Backreference():
	eat(TokenType.ref)

	var \
	node      = ASTNode.new()
	node.Type = NodeType.ref

	eat(TokenType.expr_PStart)
	
#	var assertStrTmplt = "Error when parsing a backreference expression: Expected digit but got: {value}"
#	var assertStr      = assertStrTmplt.format({"value" : NextToken.Value})
#
#	assert(NextToken.Type == TokenType.glyph, assertStr)
	node.Value = NextToken.Value
	eat(TokenType.glyph)
	
	eat(TokenType.expr_PEnd)

	return node

func parse_Set():
	eat(TokenType.set)

	var \
	node       = ASTNode.new()
	node.Type  = NodeType.set
	node.Value = []

	eat(TokenType.expr_PStart)

	while is_Glyph() || NextToken.Type == TokenType.op_not :
		if NextToken.Type == TokenType.op_not :
			var possibleGlyph = parse_OpNot()
			if is_Glyph(possibleGlyph.Value) :
				node.Value.append( possibleGlyph )
				continue
				
			assert(true == false, "Bad ! operator in set.")
		
		node.Value.append( parse_Between() )

	eat(TokenType.expr_PEnd)

	return node

func parse_String():
	var string = ""
	
	var index = 1
	while NextToken.Value[index] != "\"" :
		string += NextToken.Value[index]
		index += 1
	
	var \
	node       = ASTNode.new()
	node.Type  = NodeType.string
	node.Value = string

	eat(TokenType.string)

	return node

# End: Parser


# Transpiling

var ExprAST     : ASTNode
var RegexResult : String

func compile(expression : String):
	init( expression )

	NextToken = next_Token()
	ExprAST   = parse_OpUnion(null)

	return compile_Union(ExprAST)

func compile_Union(node : ASTNode):
	var result         = ""
	var expressionLeft = node.Value
	
	if node.Type == NodeType.union :
		expressionLeft = node.Value[0].Value
	
	for entry in expressionLeft :
		match entry.Type :
			NodeType.str_start:
				result += "^"
			NodeType.str_end:
				result += "$"
			
			NodeType.capture:
				result += compile_CaptureGroup(entry, false)
			NodeType.look:	
				result += compile_LookAhead(entry, false)
			NodeType.ref:
				result += compile_Backreference(entry)
			NodeType.repeat:
				result += compile_Repeat(entry)
			NodeType.set:
				result += compile_Set(entry, false)
				
			NodeType.glyph:
				result += entry.Value
			NodeType.inline:
				result += entry.Value
			NodeType.digit:
				result += entry.Value
			NodeType.space:
				result += entry.Value
			NodeType.word:
				result += entry.Value
			NodeType.linebreak:
				result += entry.Value
			NodeType.whitespace:
				result += entry.Value

			NodeType.string:
				result += compile_String(entry, false)
	
			NodeType.op_not:
				result += compile_OpNot(entry)

	if node.Type == NodeType.union && node.Value[1] != null :
		result += "|"
		result += compile_Union(node.Value[1])

	return result

func compile_CaptureGroup(node : ASTNode, negate : bool):
	var result = ""

	if negate :
		result += "(?:"
	else :
		result += "("

	result += compile_Union(node.Value)
	result += ")"

	return result

func compile_LookAhead(node : ASTNode, negate : bool):
	var result = ""

	if negate :
		result += "(?!"
	else :
		result += "(?="

	result += compile_Union(node.Value.Value)
	result += ")"
	
	return result

func compile_Backreference(node : ASTNode):
	var \
	result = "\\"
	result += node.Value

	return result

func compile_Repeat(node : ASTNode):
	var result = ""
	var vrange = node.Value[0]
	var lazy   = node.Value[1]

	if vrange.Type == NodeType.between :
		if vrange.Value.size() == 1 :
			if vrange.Value[0].Value == "0" :
				result += "*"
			elif vrange.Value[0].Value == "1" :
				result += "+"
			else :
				result += "{" + vrange.Value[0].Value + "," + "}"
		if vrange.Value.size() == 2 :
			if vrange.Value[0].Value == "0" && vrange.Value[1].Value == "1" :
				result += "?"
			else :
				result += "{" + vrange.Value[0].Value + "," + vrange.Value[1].Value + "}"
	else :
		result += "{" + vrange.Value + "}"

	if lazy != null :
		result += "?"

	return result

func compile_Set(node : ASTNode, negate : bool):
	var result = ""

	if negate :
		result += "[^"
	else :
		result += "["

	for entry in node.Value :
		if entry.Type == NodeType.op_not :
			result += compile_OpNot(entry)
		elif entry.Type == NodeType.between :
			result += entry.Value[0].Value
			result += "-"
			result += entry.Value[1].Value
		else :		
			result += entry.Value

	result += "]"

	return result

func compile_String(node : ASTNode, negate : bool):
	var result = ""

	if negate :
		result += "\\B"
	else :
		result += "\\b"

	result += node.Value

	if negate :
		result += "\\B"
	else :
		result += "\\b"

	return result

func compile_OpNot(node : ASTNode):
	var result = ""

	var entry = node.Value

	match entry.Type :
		NodeType.capture:
			result += compile_CaptureGroup(entry, true)
		NodeType.digit:
			result += "\\D"
		NodeType.word:
			result += "\\W"
		NodeType.whitespace:
			result += "\\S"
		NodeType.linebreak:
			result += "\\N"
		NodeType.look:
			result += compile_LookAhead(entry, true)
		NodeType.string:
			result += compile_String(entry, true)
		NodeType.set:
			result += compile_Set(entry, true)

	return result
