{
module Language.SystemVerilog.Parser.Parse (descriptions) where

import Data.List
import Data.Maybe

import Language.SystemVerilog.AST
import Language.SystemVerilog.Parser.ParseDecl
import Language.SystemVerilog.Parser.Tokens
}

%name descriptions
%tokentype { Token }
%error { parseError }

%expect 0

%token

"always"           { Token KW_always       _ _ }
"always_comb"      { Token KW_always_comb  _ _ }
"always_ff"        { Token KW_always_ff    _ _ }
"always_latch"     { Token KW_always_latch _ _ }
"assign"           { Token KW_assign       _ _ }
"automatic"        { Token KW_automatic    _ _ }
"begin"            { Token KW_begin        _ _ }
"case"             { Token KW_case         _ _ }
"casex"            { Token KW_casex        _ _ }
"casez"            { Token KW_casez        _ _ }
"default"          { Token KW_default      _ _ }
"else"             { Token KW_else         _ _ }
"end"              { Token KW_end          _ _ }
"endcase"          { Token KW_endcase      _ _ }
"endfunction"      { Token KW_endfunction  _ _ }
"endgenerate"      { Token KW_endgenerate  _ _ }
"endinterface"     { Token KW_endinterface _ _ }
"endmodule"        { Token KW_endmodule    _ _ }
"enum"             { Token KW_enum         _ _ }
"function"         { Token KW_function     _ _ }
"for"              { Token KW_for          _ _ }
"generate"         { Token KW_generate     _ _ }
"genvar"           { Token KW_genvar       _ _ }
"if"               { Token KW_if           _ _ }
"initial"          { Token KW_initial      _ _ }
"inout"            { Token KW_inout        _ _ }
"input"            { Token KW_input        _ _ }
"integer"          { Token KW_integer      _ _ }
"interface"        { Token KW_interface    _ _ }
"localparam"       { Token KW_localparam   _ _ }
"logic"            { Token KW_logic        _ _ }
"module"           { Token KW_module       _ _ }
"modport"          { Token KW_modport      _ _ }
"negedge"          { Token KW_negedge      _ _ }
"or"               { Token KW_or           _ _ }
"output"           { Token KW_output       _ _ }
"packed"           { Token KW_packed       _ _ }
"parameter"        { Token KW_parameter    _ _ }
"posedge"          { Token KW_posedge      _ _ }
"reg"              { Token KW_reg          _ _ }
"return"           { Token KW_return       _ _ }
"static"           { Token KW_static       _ _ }
"struct"           { Token KW_struct       _ _ }
"typedef"          { Token KW_typedef      _ _ }
"unique"           { Token KW_unique       _ _ }
"wire"             { Token KW_wire         _ _ }

simpleIdentifier   { Token Id_simple       _ _ }
escapedIdentifier  { Token Id_escaped      _ _ }
systemIdentifier   { Token Id_system       _ _ }
number             { Token Lit_number      _ _ }
string             { Token Lit_string      _ _ }

"("                { Token Sym_paren_l _ _ }
")"                { Token Sym_paren_r _ _ }
"["                { Token Sym_brack_l _ _ }
"]"                { Token Sym_brack_r _ _ }
"{"                { Token Sym_brace_l _ _ }
"}"                { Token Sym_brace_r _ _ }
"~"                { Token Sym_tildy _ _ }
"!"                { Token Sym_bang _ _ }
"@"                { Token Sym_at _ _ }
"#"                { Token Sym_pound _ _ }
"%"                { Token Sym_percent _ _ }
"^"                { Token Sym_hat _ _ }
"&"                { Token Sym_amp _ _ }
"|"                { Token Sym_bar _ _ }
"*"                { Token Sym_aster _ _ }
"."                { Token Sym_dot _ _ }
","                { Token Sym_comma _ _ }
":"                { Token Sym_colon _ _ }
";"                { Token Sym_semi _ _ }
"="                { Token Sym_eq _ _ }
"<"                { Token Sym_lt _ _ }
">"                { Token Sym_gt _ _ }
"+"                { Token Sym_plus _ _ }
"-"                { Token Sym_dash _ _ }
"?"                { Token Sym_question _ _ }
"/"                { Token Sym_slash _ _ }
"$"                { Token Sym_dollar _ _ }
"'"                { Token Sym_s_quote _ _ }
"~&"               { Token Sym_tildy_amp _ _ }
"~|"               { Token Sym_tildy_bar _ _ }
"~^"               { Token Sym_tildy_hat _ _ }
"^~"               { Token Sym_hat_tildy _ _ }
"=="               { Token Sym_eq_eq _ _ }
"!="               { Token Sym_bang_eq _ _ }
"&&"               { Token Sym_amp_amp _ _ }
"||"               { Token Sym_bar_bar _ _ }
"**"               { Token Sym_aster_aster _ _ }
"<="               { Token Sym_lt_eq _ _ }
">="               { Token Sym_gt_eq _ _ }
">>"               { Token Sym_gt_gt _ _ }
"<<"               { Token Sym_lt_lt _ _ }
"++"               { Token Sym_plus_plus _ _ }
"--"               { Token Sym_dash_dash _ _ }
"+="               { Token Sym_plus_eq _ _ }
"-="               { Token Sym_dash_eq _ _ }
"*="               { Token Sym_aster_eq _ _ }
"/="               { Token Sym_slash_eq _ _ }
"%="               { Token Sym_percent_eq _ _ }
"&="               { Token Sym_amp_eq _ _ }
"|="               { Token Sym_bar_eq _ _ }
"^="               { Token Sym_hat_eq _ _ }
"+:"               { Token Sym_plus_colon _ _ }
"-:"               { Token Sym_dash_colon _ _ }
"::"               { Token Sym_colon_colon _ _ }
".*"               { Token Sym_dot_aster _ _ }
"->"               { Token Sym_dash_gt _ _ }
":="               { Token Sym_colon_eq _ _ }
":/"               { Token Sym_colon_slash _ _ }
"##"               { Token Sym_pound_pound _ _ }
"[*"               { Token Sym_brack_l_aster _ _ }
"[="               { Token Sym_brack_l_eq _ _ }
"=>"               { Token Sym_eq_gt _ _ }
"@*"               { Token Sym_at_aster _ _ }
"(*"               { Token Sym_paren_l_aster _ _ }
"*)"               { Token Sym_aster_paren_r _ _ }
"*>"               { Token Sym_aster_gt _ _ }
"==="              { Token Sym_eq_eq_eq _ _ }
"!=="              { Token Sym_bang_eq_eq _ _ }
"==?"              { Token Sym_eq_eq_question _ _ }
"!=?"              { Token Sym_bang_eq_question _ _ }
">>>"              { Token Sym_gt_gt_gt _ _ }
"<<<"              { Token Sym_lt_lt_lt _ _ }
"<<="              { Token Sym_lt_lt_eq _ _ }
">>="              { Token Sym_gt_gt_eq _ _ }
"|->"              { Token Sym_bar_dash_gt _ _ }
"|=>"              { Token Sym_bar_eq_gt _ _ }
"[->"              { Token Sym_brack_l_dash_gt _ _ }
"@@("              { Token Sym_at_at_paren_l _ _ }
"(*)"              { Token Sym_paren_l_aster_paren_r _ _ }
"->>"              { Token Sym_dash_gt_gt _ _ }
"&&&"              { Token Sym_amp_amp_amp _ _ }
"<<<="             { Token Sym_lt_lt_lt_eq _ _ }
">>>="             { Token Sym_gt_gt_gt_eq _ _ }

-- operator precedences, from *lowest* to *highest*
%nonassoc NoElse
%nonassoc "else"
%right "?" ":"
%left  "||"
%left  "&&"
%left  "|" "~|"
%left  "^" "^~"
%left  "&" "~&"
%left  "==" "!=" "===" "!==" "==?" "!=?"
%left  "<" "<=" ">" ">="
%left  "<<" ">>" "<<<" ">>>"
%left  "+" "-"
%left  "*" "/" "%"
%left  "**"
%right  UPlus UMinus "!" "~" RedOps "++" "--"
%left  "(" ")" "[" "]" "."


%%

opt(p) :: { Maybe a }
  : p { Just $1 }
  |   { Nothing }

Descriptions :: { [Description] }
  : {- empty -}    { [] }
  | Descriptions Description { $1 ++ [$2] }

Description :: { Description }
  : Part    opt(";") { $1 }
  | Typedef opt(";") { $1 }

Typedef :: { Description }
  : "typedef" Type Identifier ";" { Typedef $2 $3 }

Type :: { Type }
  : PartialType Dimensions { $1 $2 }
  | Identifier  Dimensions { Alias $1 $2 }
PartialType :: { [Range] -> Type }
  : "wire"                                  { Wire }
  | "reg"                                   { Reg }
  | "logic"                                 { Logic }
  | "enum"   opt(Type) "{" EnumItems   "}"  { Enum   $2 $4 }
  | "struct" Packed    "{" StructItems "}"  { Struct $2 $4 }
  | "integer"                               { \[] -> IntegerT }

EnumItems :: { [(Identifier, Maybe Expr)] }
  : VariablePortIdentifiers { $1 }

StructItems :: { [(Type, Identifier)] }
  : StructItem             { [$1] }
  | StructItems StructItem { $1 ++ [$2] }
StructItem :: { (Type, Identifier) }
  : Type Identifier ";" { ($1, $2) }

Packed :: { Bool }
  : "packed"    { True }
  | {- empty -} { False }

Part :: { Description }
  : "module"    Identifier Params PortDecls ";" ModuleItems "endmodule"    opt(Tag) { Part Module    $2 (fst $4) ($3 ++ (snd $4) ++ $6) }
  | "interface" Identifier Params PortDecls ";" ModuleItems "endinterface" opt(Tag) { Part Interface $2 (fst $4) ($3 ++ (snd $4) ++ $6) }

Tag :: { Identifier }
  : ":" Identifier { $2 }

Params :: { [ModuleItem] }
  : {- empty -}        { [] }
  | "#" "(" ParamDecls { $3 }
ParamDecls :: { [ModuleItem] }
  : ParamDecl(")")            { $1 }
  | ParamDecl(",") ParamDecls { $1 ++ $2 }
ParamDecl(delim) :: { [ModuleItem] }
  : "parameter" ParamType DeclAsgns delim { map (MIDecl . (uncurry $ Parameter $2)) $3 }

PortDecls :: { ([Identifier], [ModuleItem]) }
  : "(" DeclTokens(")") { parseDTsAsPortDecls $2 }
  | "("            ")"  { ([], []) }
  | {- empty -}         { ([], []) }

ModportItems :: { [(Identifier, [ModportDecl])] }
  : ModportItem                  { [$1] }
  | ModportItems "," ModportItem { $1 ++ [$3] }
ModportItem :: { (Identifier, [ModportDecl]) }
  : Identifier "(" ModportPortsDeclarations { ($1, $3) }
ModportPortsDeclarations :: { [ModportDecl] }
  : ModportPortsDeclaration(")")                          { $1 }
  | ModportPortsDeclaration(",") ModportPortsDeclarations { $1 ++ $2 }
ModportPortsDeclaration(delim) :: { [ModportDecl] }
  : ModportSimplePortsDeclaration(delim) { $1 }
ModportSimplePortsDeclaration(delim) :: { [ModportDecl] }
  : Direction ModportSimplePorts delim { map (\(a, b) -> ($1, a, b)) $2 }
ModportSimplePorts :: { [(Identifier, Maybe Expr)] }
  : ModportSimplePort                        { [$1] }
  | ModportSimplePorts "," ModportSimplePort { $1 ++ [$3] }
ModportSimplePort :: { (Identifier, Maybe Expr) }
  : "." Identifier "(" opt(Expr) ")" { ($2, $4) }
  | Identifier                       { ($1, Just $ Ident $1) }

Identifier :: { Identifier }
  : simpleIdentifier  { tokenString $1 }
  | escapedIdentifier { tokenString $1 }
  | systemIdentifier  { tokenString $1 }

Identifiers :: { [Identifier] }
  :                 Identifier { [$1] }
  | Identifiers "," Identifier { $1 ++ [$3] }

-- uses delimiter propagation hack to avoid conflicts
DeclTokens(delim) :: { [DeclToken] }
  : DeclToken                delim  { [$1] }
  | DeclToken     DeclTokens(delim) { [$1] ++ $2 }
  | "="  Expr "," DeclTokens(delim) { [DTAsgn     $2, DTComma] ++ $4 }
  | "<=" Expr "," DeclTokens(delim) { [DTAsgnNBlk $2, DTComma] ++ $4 }
  | "="  Expr                delim  { [DTAsgn     $2] }
  | "<=" Expr                delim  { [DTAsgnNBlk $2] }
DeclToken :: { DeclToken }
  : ","                       { DTComma }
  | Range                     { DTRange    $1 }
  | Identifier                { DTIdent    $1 }
  | Direction                 { DTDir      $1 }
  | ParameterBindings         { DTParams   $1 }
  | ModuleInstantiation       { DTInstance $1 }
  | PartialType               { DTType $1 }
  | Identifier "." Identifier { DTType $ InterfaceT $1 (Just $3) }
  | "[" Expr "]"              { DTBit      $2 }
  | "{" LHSs "}"              { DTConcat   $2 }

VariablePortIdentifiers :: { [(Identifier, Maybe Expr)] }
  : VariablePortIdentifier                             { [$1] }
  | VariablePortIdentifiers "," VariablePortIdentifier { $1 ++ [$3] }
VariablePortIdentifier :: { (Identifier, Maybe Expr) }
  : Identifier          { ($1, Nothing) }
  | Identifier "=" Expr { ($1, Just $3) }

Direction :: { Direction }
  : "inout"  { Inout  }
  | "input"  { Input  }
  | "output" { Output }

ModuleItems :: { [ModuleItem] }
  : {- empty -}            { [] }
  | ModuleItems ModuleItem { $1 ++ $2 }

ModuleItem :: { [ModuleItem] }
  -- This item covers module instantiations and all declarations
  : DeclTokens(";")  { parseDTsAsModuleItems $1 }
  | "parameter"  ParamType DeclAsgns ";" { map MIDecl $ map (uncurry $ Parameter  $2) $3 }
  | "localparam" ParamType DeclAsgns ";" { map MIDecl $ map (uncurry $ Localparam $2) $3 }
  | "assign" LHS "=" Expr ";"            { [Assign $2 $4] }
  | AlwaysKW Stmt                        { [AlwaysC $1 $2] }
  | "genvar" Identifiers ";"             { map Genvar $2 }
  | "generate" GenItems "endgenerate"    { [Generate $2] }
  | "modport" ModportItems ";"           { map (uncurry Modport) $2 }
  | "function" opt(Lifetime) FuncRetAndName FunctionItems DeclsAndStmts "endfunction" opt(Tag) { [Function $2 (fst $3) (snd $3) ($4 ++ fst $5) (snd $5)] }

FuncRetAndName :: { (Type, Identifier) }
  : {- empty -}        Identifier { (Implicit [], $1) }
  | DimensionsNonEmpty Identifier { (Implicit $1, $2) }
  | Type               Identifier { ($1         , $2) }

AlwaysKW :: { AlwaysKW }
  : "always"       { Always      }
  | "always_comb"  { AlwaysComb  }
  | "always_ff"    { AlwaysFF    }
  | "always_latch" { AlwaysLatch }

Lifetime :: { Lifetime }
  : "static"    { Static    }
  | "automatic" { Automatic }

ModuleInstantiation :: { (Identifier, Maybe [PortBinding]) }
  : Identifier "(" Bindings ")" { ($1, Just $3) }
  | Identifier "(" ".*"     ")" { ($1, Nothing) }

FunctionItems :: { [Decl] }
  : "(" DeclTokens(")") ";" { map makeInput $ parseDTsAsDecls $2 }
  |                     ";" { [] }

ParamType :: { Type }
  : Dimensions { Implicit $1 }
  | "integer"  { IntegerT }

EventControl :: { Sense }
  : "@" "(" Sense ")" { $3 }
  | "@" "(" "*"   ")" { SenseStar }
  | "@" "(*)"         { SenseStar }
  | "@" "*"           { SenseStar }
  | "@*"              { SenseStar }

Dimensions :: { [Range] }
  : {- empty -}        { [] }
  | DimensionsNonEmpty { $1 }
DimensionsNonEmpty :: { [Range] }
  : Range                    { [$1] }
  | DimensionsNonEmpty Range { $1 ++ [$2] }

DeclAsgns :: { [(Identifier, Expr)] }
  : DeclAsgn               { [$1] }
  | DeclAsgns "," DeclAsgn { $1 ++ [$3] }
DeclAsgn :: { (Identifier, Expr) }
  : Identifier "=" Expr { ($1, $3) }

Range :: { Range }
  : "[" Expr ":" Expr "]"  { ($2, $4) }

LHS :: { LHS }
  : Identifier         { LHSIdent  $1    }
  | LHS Range          { LHSRange  $1 $2 }
  | LHS "[" Expr "]"   { LHSBit    $1 $3 }
  | LHS "." Identifier { LHSDot    $1 $3 }
  | "{" LHSs "}"       { LHSConcat $2    }

LHSs :: { [LHS] }
  : LHS           { [$1] }
  | LHSs "," LHS  { $1 ++ [$3] }

Sense :: { Sense }
:            Sense1 { $1 }
| Sense "or" Sense1 { SenseOr $1 $3 }

Sense1 :: { Sense }
:           LHS { Sense        $1 }
| "posedge" LHS { SensePosedge $2 }
| "negedge" LHS { SenseNegedge $2 }

Bindings :: { [(Identifier, Maybe Expr)] }
  : {- empty -}      { [] }
  | BindingsNonEmpty { $1 }
BindingsNonEmpty :: { [(Identifier, Maybe Expr)] }
  : Binding                      { [$1] }
  | Binding "," BindingsNonEmpty { $1 : $3}
Binding :: { (Identifier, Maybe Expr) }
  : "." Identifier "(" opt(Expr) ")" { ($2, $4) }
  | "." Identifier                   { ($2, Just $ Ident $2) }
  | Expr                             { ("", Just $1) }

ParameterBindings :: { [(Identifier, Maybe Expr)] }
  : "#" "(" BindingsNonEmpty ")" { $3 }

Stmts :: { [Stmt] }
  : {- empty -} { [] }
  | Stmts Stmt  { $1 ++ [$2] }

Stmt :: { Stmt }
  : StmtNonAsgn       { $1 }
  | LHS "="  Expr ";" { AsgnBlk $1 $3 }
  | LHS "<=" Expr ";" { Asgn    $1 $3 }
StmtNonAsgn :: { Stmt }
  : ";" { Null }
  | "begin"                        Stmts "end" { Block Nothing             $2 }
  | "begin" ":" Identifier DeclsAndStmts "end" { Block (Just ($3, fst $4)) (snd $4) }
  | "if" "(" Expr ")" Stmt "else" Stmt         { If $3 $5 $7        }
  | "if" "(" Expr ")" Stmt %prec NoElse        { If $3 $5 Null      }
  | "for" "(" Identifier "=" Expr ";" Expr ";" Identifier "=" Expr ")" Stmt { For ($3, $5) $7 ($9, $11) $13 }
  | Unique CaseKW "(" Expr ")" Cases opt(CaseDefault) "endcase" { Case $1 $2 $4 $6 $7 }
  | EventControl Stmt                          { Timing $1 $2 }
  | "return" Expr ";"                          { Return $2 }

DeclsAndStmts :: { ([Decl], [Stmt]) }
  : DeclOrStmt DeclsAndStmts { combineDeclsAndStmts $1 $2 }
  | StmtNonAsgn Stmts        { ([], $1 : $2) }
  | {- empty -}              { ([], []) }
DeclOrStmt :: { ([Decl], [Stmt]) }
  : DeclTokens(";") { parseDTsAsDeclOrAsgn $1 }
  | "parameter"  ParamType DeclAsgns ";" { (map (uncurry $ Parameter  $2) $3, []) }
  | "localparam" ParamType DeclAsgns ";" { (map (uncurry $ Localparam $2) $3, []) }

Unique :: { Bool }
  : "unique"    { True  }
  | {- empty -} { False }

CaseKW :: { CaseKW }
  : "case"  { CaseN }
  | "casex" { CaseX }
  | "casez" { CaseZ }

Cases :: { [Case] }
  : {- empty -}  { [] }
  | Cases Case   { $1 ++ [$2] }

Case :: { Case }
  : Exprs ":" Stmt { ($1, $3) }

CaseDefault :: { Stmt }
  : "default" opt(":") Stmt { $3 }

Number :: { String }
  : number    { tokenString $1 }

String :: { String }
  : string { tail $ init $ tokenString $1 }

CallArgs :: { [Expr] }
  :              Expr  { [$1] }
  | CallArgs "," Expr  { $1 ++ [$3] }

Exprs :: { [Expr] }
:           Expr  { [$1] }
| Exprs "," Expr  { $1 ++ [$3] }

Expr :: { Expr }
: "(" Expr ")"                { $2 }
| String                      { String $1 }
| Number                      { Number $1 }
| Identifier "(" CallArgs ")" { Call $1 $3 }
| Identifier                  { Ident      $1    }
| Expr Range                  { Range $1 $2 }
| Expr "[" Expr "]"           { Bit   $1 $3 }
| "{" Expr "{" Exprs "}" "}"  { Repeat $2 $4 }
| "{" Exprs "}"               { Concat $2 }
| Expr "?" Expr ":" Expr      { Mux $1 $3 $5 }
| Expr "||" Expr              { BinOp Or  $1 $3 }
| Expr "&&" Expr              { BinOp And $1 $3 }
| Expr "|"  Expr              { BinOp BWOr $1 $3 }
| Expr "^"  Expr              { BinOp BWXor $1 $3 }
| Expr "&"  Expr              { BinOp BWAnd $1 $3 }
| Expr "==" Expr              { BinOp Eq $1 $3 }
| Expr "!=" Expr              { BinOp Ne $1 $3 }
| Expr "<"  Expr              { BinOp Lt $1 $3 }
| Expr "<=" Expr              { BinOp Le $1 $3 }
| Expr ">"  Expr              { BinOp Gt $1 $3 }
| Expr ">=" Expr              { BinOp Ge $1 $3 }
| Expr "<<" Expr              { BinOp ShiftL $1 $3 }
| Expr ">>" Expr              { BinOp ShiftR $1 $3 }
| Expr "+"  Expr              { BinOp Add $1 $3 }
| Expr "-"  Expr              { BinOp Sub $1 $3 }
| Expr "*"  Expr              { BinOp Mul $1 $3 }
| Expr "/"  Expr              { BinOp Div $1 $3 }
| Expr "%"  Expr              { BinOp Mod $1 $3 }
| Expr "**" Expr              { BinOp Pow $1 $3 }
| Expr "<<<" Expr             { BinOp ShiftAL $1 $3 }
| Expr ">>>" Expr             { BinOp ShiftAR $1 $3 }
| Expr "===" Expr             { BinOp TEq $1 $3 }
| Expr "!==" Expr             { BinOp TNe $1 $3 }
| Expr "==?" Expr             { BinOp WEq $1 $3 }
| Expr "!=?" Expr             { BinOp WNe $1 $3 }
| "!" Expr                    { UniOp Not $2 }
| "~" Expr                    { UniOp BWNot $2 }
| "+" Expr %prec UPlus        { UniOp UAdd $2 }
| "-" Expr %prec UMinus       { UniOp USub $2 }
| "&"  Expr %prec RedOps      { UniOp RedAnd  $2 }
| "~&" Expr %prec RedOps      { UniOp RedNand $2 }
| "|"  Expr %prec RedOps      { UniOp RedOr   $2 }
| "~|" Expr %prec RedOps      { UniOp RedNor  $2 }
| "^"  Expr %prec RedOps      { UniOp RedXor  $2 }
| "~^" Expr %prec RedOps      { UniOp RedXnor $2 }
| "^~" Expr %prec RedOps      { UniOp RedXnor $2 }
| PartialType "'" "(" Expr ")" { Cast ($1       []) $4 }
| Identifier  "'" "(" Expr ")" { Cast (Alias $1 []) $4 }
| Expr "." Identifier         { Access $1 $3 }
| "'" "{" PatternItems "}"    { Pattern $3 }

PatternItems :: { [(Maybe Identifier, Expr)] }
  : PatternNamedItems   { map (\(x,e) -> (Just x, e)) $1 }
  | PatternUnnamedItems { zip (repeat Nothing) $1 }
PatternNamedItems :: { [(Identifier, Expr)] }
  : PatternNamedItem                       { [$1] }
  | PatternNamedItems "," PatternNamedItem { $1 ++ [$3] }
PatternNamedItem :: { (Identifier, Expr) }
  : Identifier ":" Expr { ($1, $3) }
PatternUnnamedItems :: { [Expr] }
  : Exprs { $1 }

GenItemOrNull :: { GenItem }
  : GenItem { $1 }
  | ";"     { GenNull }

GenItems :: { [GenItem] }
  : {- empty -}      { [] }
  | GenItems GenItem { $1 ++ [$2] }

GenItem :: { GenItem }
  : "if" "(" Expr ")" GenItemOrNull "else" GenItemOrNull { GenIf $3 $5 $7      }
  | "if" "(" Expr ")" GenItemOrNull %prec NoElse         { GenIf $3 $5 GenNull }
  | "begin"                GenItems "end"                { GenBlock Nothing   $2 }
  | "begin" ":" Identifier GenItems "end"                { GenBlock (Just $3) $4 }
  | "case" "(" Expr ")" GenCases opt(GenCaseDefault) "endcase" { GenCase $3 $5 $6 }
  | "for" "(" Identifier "=" Expr ";" Expr ";" GenvarIteration ")" "begin" ":" Identifier GenItems "end" { GenFor ($3, $5) $7 $9 $13 $14 }
  -- TODO: We should restrict it to the module items that are actually allowed.
  | ModuleItem { genItemsToGenItem $ map GenModuleItem $1 }

GenCases :: { [GenCase] }
  : {- empty -}      { [] }
  | GenCases GenCase { $1 ++ [$2] }

GenCase :: { GenCase }
  : Exprs ":" GenItemOrNull { ($1, $3) }

GenCaseDefault :: { GenItem }
  : "default" opt(":") GenItemOrNull { $3 }

GenvarIteration :: { (Identifier, AsgnOp, Expr) }
  : Identifier AssignmentOperator Expr { ($1, $2, $3) }
  | IncOrDecOperator Identifier { ($2, AsgnOp $1, Number "1") }
  | Identifier IncOrDecOperator { ($1, AsgnOp $2, Number "1") }

AssignmentOperator :: { AsgnOp }
  : "="    { AsgnOpEq }
  | "+="   { AsgnOp Add }
  | "-="   { AsgnOp Sub }
  | "*="   { AsgnOp Mul }
  | "/="   { AsgnOp Div }
  | "%="   { AsgnOp Mod }
  | "&="   { AsgnOp BWAnd }
  | "|="   { AsgnOp BWOr  }
  | "^="   { AsgnOp BWXor }
  | "<<="  { AsgnOp ShiftL }
  | ">>="  { AsgnOp ShiftR }
  | "<<<=" { AsgnOp ShiftAL }
  | ">>>=" { AsgnOp ShiftAR }

IncOrDecOperator :: { BinOp }
  : "++" { Add }
  | "--" { Sub }

{

parseError :: [Token] -> a
parseError a = case a of
  []              -> error "Parse error: no tokens left to parse."
  Token t s p : _ -> error $ "Parse error: unexpected token '" ++ s ++ "' (" ++ show t ++ ") at " ++ show p ++ "."

genItemsToGenItem :: [GenItem] -> GenItem
genItemsToGenItem [] = error "genItemsToGenItem given empty list!"
genItemsToGenItem [x] = x
genItemsToGenItem xs = GenBlock Nothing xs

combineDeclsAndStmts :: ([Decl], [Stmt]) -> ([Decl], [Stmt]) -> ([Decl], [Stmt])
combineDeclsAndStmts (a1, b1) (a2, b2) = (a1 ++ a2, b1 ++ b2)

makeInput :: Decl -> Decl
makeInput (Variable _ t x a me) = Variable Input t x a me
makeInput other = error $ "unexpected non-var decl: " ++ (show other)

}