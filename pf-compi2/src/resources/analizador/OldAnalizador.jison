
%lex
%options case-sensitive


%%

[ \r\t\n]+                   { /*ignorar*/}

//palabras reservadas
"paquete"                       return 'PR_PAQUETE'
"com"                           return 'PR_COM'
"%%PY"                          return 'ET_PY'
"%%JAVA"                        return 'ET_JAVA'
"%%PROGRAMA"                    return 'ET_PROGRAMA'
"#include"                      return 'ET_INCLUDE'

//tipos de datos
[a-zA-Z]+[a-zA-Z0-9_]*          return 'ID'

[/][/].*                                           { /*ignorar comentario de linea*/}
[/][*][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}

<<EOF>>                         return 'EOF'
.   {/*Instertar codigo para recuperar el error lexico*/
        //error
        ErrorLS = new Object();
        ErrorLS.lexema = yytext;
        ErrorLS.linea = yylloc.first_line;
        ErrorLS.columna = yylloc.first_column;
        ErrorLS.tipo = 'Léxico';
        ErrorLS.descripcion = 'El lexema '+yytext+' no es válido.';
        errores.push(ErrorLS);
    }


/lex


%start inicial

%{
    let errores = [] ;

    exports.errores = errores;

    exports.reset = function(){
        errores.splice(0, errores.length);
    }
%}

%%

inicial :  a0 EOF
        ;

a0 :    a1 b1 ET_PROGRAMA
        | err
        ;

a1 : ET_PY
    | //lambda
    ;

b1 : ET_JAVA
    | //lambda
    ;

       

err : error {
                //error
                ErrorLS = new Object();
                ErrorLS.lexema = yytext;
                ErrorLS.linea = this._$.first_line;
                ErrorLS.columna = this._$.first_column;
                ErrorLS.tipo = 'Sintáctico';
                ErrorLS.descripcion = '';
                errores.push(ErrorLS);
        }
        ;



