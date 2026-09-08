/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();
    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }

    private int strComment = 0;
    private boolean stringContainsNull = false;

%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;

    case MULT_COMMENT:
        yybegin(YYINITIAL);
        return new Symbol(TokenConstants.ERROR, "EOF in comment");

    case STRING:
        yybegin(YYINITIAL);
        return new Symbol(TokenConstants.ERROR, "EOF in string constant");

    /* If necessary, add code for other states here, e.g:
     case COMMENT:
     ...
     break;
    */
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup
%state UNI_COMMENT
%state MULT_COMMENT
%state STRING
slash = \\\"

typeId = [A-Z][A-Za-z0-9_]*
objectId = [a-z][A-Za-z0-9_]*
intConst = [0-9]+
true = [t][rR][uU][eE]
false = [f][aA][lL][sS][eE]

inherits = [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
pool = [Pp][Oo][Oo][Ll]
case = [Cc][Aa][Ss][Ee]
not = [Nn][Oo][Tt]
in = [Ii][Nn]
class = [Cc][Ll][Aa][Ss][Ss]
fi = [Ff][Ii]
loop = [Ll][Oo][Oo][Pp]
if = [Ii][Ff]
of = [Oo][Ff]
new = [Nn][Ee][Ww]
isvoid = [Ii][Ss][Vv][Oo][Ii][Dd]
else = [Ee][Ll][Ss][Ee]
while = [Ww][Hh][Ii][Ll][Ee]
esac = [Ee][Ss][Aa][Cc]
let = [Ll][Ee][Tt]
then = [Tt][Hh][Ee][Nn]


%%

<YYINITIAL>{inherits}  { return new Symbol(TokenConstants.INHERITS); }

<YYINITIAL>{pool}      { return new Symbol(TokenConstants.POOL); }

<YYINITIAL>{case}      { return new Symbol(TokenConstants.CASE); }

<YYINITIAL>{in}        { return new Symbol(TokenConstants.IN); }

<YYINITIAL>{class}     { return new Symbol(TokenConstants.CLASS); }

<YYINITIAL>{fi}        { return new Symbol(TokenConstants.FI); }

<YYINITIAL>{loop}      { return new Symbol(TokenConstants.LOOP); }

<YYINITIAL>{if}        { return new Symbol(TokenConstants.IF); }

<YYINITIAL>{of}        { return new Symbol(TokenConstants.OF); }

<YYINITIAL>{new}       { return new Symbol(TokenConstants.NEW); }

<YYINITIAL>{isvoid}    { return new Symbol(TokenConstants.ISVOID); }

<YYINITIAL>{else}      { return new Symbol(TokenConstants.ELSE); }

<YYINITIAL>{while}     { return new Symbol(TokenConstants.WHILE); }

<YYINITIAL>{esac}      { return new Symbol(TokenConstants.ESAC); }

<YYINITIAL>{let}       { return new Symbol(TokenConstants.LET); }

<YYINITIAL>{then}      { return new Symbol(TokenConstants.THEN); }

<YYINITIAL>{not}       { return new Symbol(TokenConstants.NOT); }

<YYINITIAL>{intConst}  { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext())); }

<YYINITIAL>{true}      { return new Symbol(TokenConstants.BOOL_CONST, "true"); }

<YYINITIAL>{false}     { return new Symbol(TokenConstants.BOOL_CONST, "false"); }

<YYINITIAL>{typeId}    { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>{objectId}  { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>"=>"        { return new Symbol(TokenConstants.DARROW); }

<YYINITIAL>"+"         { return new Symbol(TokenConstants.PLUS); }

<YYINITIAL>"-"         { return new Symbol(TokenConstants.MINUS); } 

<YYINITIAL>"*"         { return new Symbol(TokenConstants.MULT); }

<YYINITIAL>"/"         { return new Symbol(TokenConstants.DIV); }

<YYINITIAL>"~"         { return new Symbol(TokenConstants.NEG); }

<YYINITIAL>"<"         { return new Symbol(TokenConstants.LT); }

<YYINITIAL>"<="        { return new Symbol(TokenConstants.LE); }

<YYINITIAL>"="         { return new Symbol(TokenConstants.EQ); }

<YYINITIAL>"<-"        { return new Symbol(TokenConstants.ASSIGN); }

<YYINITIAL>"("         { return new Symbol(TokenConstants.LPAREN); }

<YYINITIAL>")"         { return new Symbol(TokenConstants.RPAREN); }

<YYINITIAL>"{"         { return new Symbol(TokenConstants.LBRACE); }

<YYINITIAL>"}"         { return new Symbol(TokenConstants.RBRACE); }

<YYINITIAL>";"         { return new Symbol(TokenConstants.SEMI); }

<YYINITIAL>","         { return new Symbol(TokenConstants.COMMA); }

<YYINITIAL>":"         { return new Symbol(TokenConstants.COLON); }

<YYINITIAL>"."         { return new Symbol(TokenConstants.DOT); }

<YYINITIAL>"@"         { return new Symbol(TokenConstants.AT); }

<YYINITIAL>[\t\r\f\b\x0B ]  { }    
<YYINITIAL>[\n]             { curr_lineno++; }
<YYINITIAL>[-][-]           { yybegin(UNI_COMMENT); } 
<YYINITIAL>"(*"             { strComment++;
                              yybegin(MULT_COMMENT); }
<YYINITIAL>"*)"             { return new Symbol(TokenConstants.ERROR, "Unmatched"); }
<YYINITIAL>"\""             { string_buf.setLength(0); 
                              yybegin(STRING); }

<UNI_COMMENT>.              { }
<UNI_COMMENT>[\n]           { curr_lineno++;
                              yybegin(YYINITIAL); } 

<MULT_COMMENT>"(*"          { strComment++; }
<MULT_COMMENT>.             { }
<MULT_COMMENT>[\n]          { curr_lineno++; }
<MULT_COMMENT>[\r]          { }
<MULT_COMMENT>"*)"          { strComment--;
                              if (strComment == 0) {
                                yybegin(YYINITIAL);
                              }
                            }

<STRING>\\\\n               { string_buf.append("\\n");}
<STRING>\\n                 { string_buf.append("\n"); }
<STRING>\\b                 { string_buf.append("\b"); }
<STRING>\\f                 { string_buf.append("\f"); }
<STRING>\\t                 { string_buf.append("\t"); }
<STRING>\\[\n]              { string_buf.append("\n"); }
<STRING>{slash}             { string_buf.append("\""); }
<STRING>\\\\                { string_buf.append("\\"); }
<STRING>[^\n\0\\\"]+        { string_buf.append(yytext()); }
<STRING>\\                  {}  
<STRING>\n                  { yybegin(YYINITIAL);
                              return new Symbol(TokenConstants.ERROR, "Unterminated string constant"); }
<STRING>\0                  { stringContainsNull = true; }
<STRING>"\""                {   yybegin(YYINITIAL); 
                                if (stringContainsNull) {
                                    stringContainsNull = false; 
                                    return new Symbol(TokenConstants.ERROR, "String contains null character");
                                }
                                String stringBufferContent = string_buf.toString();
                                if (stringBufferContent.length() >= MAX_STR_CONST) {
                                    return new Symbol(TokenConstants.ERROR, "String constant too long");
                                } else {
                                    return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(stringBufferContent));
                                }
                            }

<YYINITIAL>.                { return new Symbol(TokenConstants.ERROR, yytext()); }