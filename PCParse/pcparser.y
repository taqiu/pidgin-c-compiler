# RACC specifications for PidginC parser

class PCParser

  prechigh
  nonassoc UMINUS UPLUS PREFIXOP
  left '*' '/'
  left '+' '-'
  left BOOL_OP
  left REL_OP
  preclow

rule

  target:
    program
  ;

######################### my code begin #################################

  program:
    type_decls function_defs { result = :Program[val[0],val[1]] }
  | function_defs { result = :Program[[], val[0]] }
  | type_decls { result = :Program[val[0],[]] }
  | { result = []}
  ;
  type_decls:
    type_decls type_decl { result = val[0] + [val[1]] }
  | type_decl { result = [val[0]] }
  ;

  type_decl:
    typename decl_list ';' { result = :TypeDecl[val[0], val[1]] }
  ;

  decl_list:
    decl_list ',' decl { result = val[0] + [val[2]] }
  | decl { result = [val[0]] }
  ;

  decl:
     lval { result = val[0] }
  | fn_decl { reuslt = val[0] }
  | pointer { result = val[0] }
  | '*' fn_decl {result = :Pointer[val[1]] }
  ;

  fn_decl:
    IDENTIFIER '(' ')' { result = :FunctionDecl[val[0], :Formals[[]]] }
  | IDENTIFIER '(' formal_params ')' { result = :FunctionDecl[val[0], :Formals[val[2]]]  }
  ;

  block:
    '{' type_decls stmt_list '}' { result = [val[1], val[2]] }
  | '{' stmt_list '}'  { result = [[], val[1]] }
  | '{' type_decls '}' { result = [val[1], []] }
  | '{' '}' { result = [[], []] }
  ;

  stmt:
    simple_stmt ';' { result = :SimpleStmt[val[0]] } 
  | compound_stmt 
  ;

  compound_stmt:
    FOR '(' simple_stmt ';' expr ';' simple_stmt ')' block { result = :For[val[2], val[4], val[6], :Block[val[8]]]}
  | WHILE '(' expr ')' block { result = :While[val[2], :Block[val[4]]]} 
  | IF '(' expr ')' block optional_else { result = :If[val[2],:Block[val[4]], val[5]] }
  ;

  optional_else:
    ELSE block { result = :Else[:Block[val[1]]] }
  | {result = []}	
  ;

  pointer:
    '*' lval { result = :Pointer[val[1]] }
  ;
 
  expr:
    IDENTIFIER
  | pointer
  | INT_NUM  { result = :ConstInt[val[0]] }
  | REAL_NUM  { result = :ConstReal[val[0]] }
  | STRING  { result = :ConstString[val[0]] }
  | array_ref
  | function_call
  | expr '+' expr  { result = :BinaryOp[val[0], '+', val[2]] }
  | expr '-' expr  { result = :BinaryOp[val[0], '-', val[2]] }
  | expr '*' expr  { result = :BinaryOp[val[0], '*', val[2]] }
  | expr '/' expr  { result = :BinaryOp[val[0], '/', val[2]] }
  | expr BOOL_OP expr  { result = :BinaryOp[val[0], val[1], val[2]] }
  | expr REL_OP expr  { result = :BinaryOp[val[0], val[1], val[2]] }
  | '-' expr  = UMINUS  { result = :UnaryOp['-', val[1]] }
  | '+' expr  = UPLUS  { result = :UnaryOp['+', val[1]] }
  | PREFIX_OP expr = PREFIXOP  { result = :UnaryOp[val[0], val[1]] }
  | '(' expr ')'  { result = :Parenthesis[val[1]] }
  ;

  function_def:
    typename IDENTIFIER '(' formal_params ')' block  { result = :Function[val[0], val[1], :Formals[val[3]], :Block[val[5]]] }
  | typename IDENTIFIER '(' ')' block  { result = :Function[val[0], val[1], :Formals[[]], :Block[val[4]]] }
  | typename '*' IDENTIFIER '(' formal_params ')' block  { result = :Function[:TypePointer[val[0]], val[2], :Formals[val[4]], :Block[val[6]]] }
  | typename '*' IDENTIFIER '(' ')' block  { result = :Function[:TypePointer[val[0]], val[2], :Formals[[]], :Block[val[5]]] } 
  ;

  formal_param:
    typename  { result = :Formal[val[0], []] }
  | typename IDENTIFIER  { result = :Formal[val[0], val[1]] }
  | typename '&' IDENTIFIER  { result = :Formal[val[0], :RefArg[val[2]]] }
  | typename array_formal  { result = :Formal[val[0], val[1]] }
  | typename '*' array_formal  { result = :Formal[val[0], :Pointer[val[2]]] }
  | typename '*' IDENTIFIER { result = :Formal[val[0],  :Pointer[val[2]]] }
  ;

########################## my code end ##################################

  function_defs:
    function_defs function_def { result = val[0] + [val[1]] }
  | function_def  { result = [val[0]] }
  ;

  typename:
    CHAR
  | INT
  | DOUBLE
  | VOID
  ;

  formal_params:
    formal_params ',' formal_param  { result = val[0] + [val[2]] }
  | formal_param  { result = [val[0]] }
  ;


  array_formal:
    IDENTIFIER array_formal_subs  { result = :ArrayArg[val[0], val[1]] }
  ;

  array_formal_subs:
    array_formal_subs array_formal_sub  { result = val[0] + [val[1]] }
  | array_formal_sub  { result = [val[0]] }
  ;

  array_formal_sub:
    '[' expr ']'  { result = val[1] }
  | '[' ']'  { result = :EmptySubscript[] }
  ;

  stmt_list:
    stmt_list stmt  { result = val[0] + [val[1]] }
  | stmt  { result = [val[0]] }
  ;

  simple_stmt:
    lval '=' expr  { result = :Assignment[val[0], val[2]] }
  | pointer '=' expr { result= :Assignment[val[0], val[2]] }
  | BREAK  { result = :BreakStmt[] }
  | CONTINUE  { result = :ContinueStmt[] }
  | RETURN  { result = :ReturnStmt[] }
  | RETURN expr  { result = :ReturnStmt[val[1]] }
  | expr
  ;

  lval:
    IDENTIFIER
  | array_ref
  ;


  array_ref:
    IDENTIFIER '[' array_index_list ']'  { result = :ArrayRef[val[0], val[2]] }
  ;

  array_index_list:
    array_index_list ']' '[' expr  { result = val[0] + [val[3]] }
  | expr  { result = [val[0]] }
  ;

  function_call:
    IDENTIFIER '(' actual_params ')'  { result = :FunctionCall[val[0], val[2]] }
  | IDENTIFIER '(' ')'  { result = :FunctionCall[val[0], [[]]] }
  ;

  actual_params:
    actual_params ',' expr  { result = val[0] + [val[2]] }
  | expr { result = [val[0]] }
  ;

end

---- header ----

# pcparser.rb: generated by racc

---- inner ----

  def initialize
    @scanner = Scanner.new
  end

  def parse_array tokens
    yyparse tokens, :each
  end

  def parse_file
    do_parse
  end

  def next_token
    @scanner.next_token
  end

  # override the default error reporting function to report line number
  def on_error err_token_id, err_value, value_stack
    puts "Error at or near line #{@scanner.lineno}, while parsing '#{err_value}' (#{token_to_str(err_token_id)})"
    puts "Current parse stack:"
    (value_stack.length-1).downto(0) {|i| puts "\t#{value_stack[i].to_string}"}
  end

---- footer ----

# I suggest not using the footer, unless you want to execute some code once when the parser is included
require 'rubywrite'
require 'PCParse/scanner'
