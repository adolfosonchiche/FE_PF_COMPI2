%lex
%options case-sensitive


%%
[ \r\t\n]+                              { /*ignorar*/}
[/][/].*                                { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]     { /*ignorar comentario de bloque*/}

[0-9]+"."[0-9]+                         return 'FLOAT'
[0-9]+                                  return 'INT'
\'.\'                                   { yytext = yytext.substr(1,yyleng-2); return 'CHAR'; }
\"[^"]*\"                               { yytext = yytext.substr(1,yyleng-2); return 'PAQUETE'; }

//palabras reservadas
"int"                                   return 'PR_INT'
"float"                                 return 'PR_FLOAT'
"char"                                  return 'PR_CHAR'
"const"                                 return 'PR_CONST'
"import"                              return 'PR_INCLUDE'
"void"                                  return 'PR_VOID'
"main"                                  return 'PR_MAIN'

//  instrucciones y ciclos
"if"                            return 'PR_IF'
"else"                          return 'PR_ELSE'
"for"                           return 'PR_FOR'
"switch"                        return 'PR_SWITCH'
"case"                          return 'PR_CASE'
"do"                            return 'PR_DO'
"while"                         return 'PR_WHILE'
"default"                       return 'PR_DEFAULT'
"break"                         return 'PR_BREAK'
"println"                       return 'PR_PRINTLN'
"print"                         return 'PR_PRINT'

//simbolos
"++"                            return 'INCREMENTO'
"--"                            return 'DECREMENTO'
[+]                             return 'SUMA'
[-]                             return 'RESTA'
[*]                             return 'MULTIPLICACION'
[/]                             return 'DIVISION'
[%]                             return 'MODULO'
"^"                             return 'POTENCIA'
"{"                             return 'LLAVE_A'
"}"                             return 'LLAVE_C'
"["                             return 'CORCH_A'
"]"                             return 'CORCH_C'
"("                             return 'PARENT_A'
")"                             return 'PARENT_C'
"||"                            return 'XOR'
"|"                             return 'OR'
"&&"                            return 'AND'
"=="                            return 'IGUAL'
"!="                            return 'NO_IGUAL'
">="                            return 'MAYOR_IGUAL'
"<="                            return 'MENOR_IGUAL'
">"                             return 'MAYOR'
"<"                             return 'MENOR'
"!"                             return 'NOT'
";"                             return 'PUNTO_Y_COMA'
":"                             return 'DOS_PUNTOS'
","                             return 'COMA'
"="                             return 'ASIGNACION'

[a-zA-Z]+[a-zA-Z0-9_]*                  return 'ID'

<<EOF>>                       return 'EOF'
.       {/*Instertar codigo para recuperar el error lexico*/
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
    let errores = [];
    let tablasDeSimbolos = [];
    let ambitoActual = [];
    let ids = [];
    let tipoDatoSwtich = "";

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(yy){
        errores.splice(0, errores.length);
        tablasDeSimbolos.splice(0, tablasDeSimbolos.length);
        let tablaGlobal = [];
        tablasDeSimbolos.push(tablaGlobal);
        ambitoActual = [yy.GLOBAL];
        ids.splice(0, ids.length);
        tipoDatoSwtich = "";
    }

    function nuevoAmbito(){
        let nuevaTabla = [];
        if(tablasDeSimbolos.length){
            nuevaTabla = tablasDeSimbolos.at(-1).slice();
        }
        tablasDeSimbolos.push(nuevaTabla);
    }

    function getAmbitoActual(){
        return tablasDeSimbolos.at(-1);
    }

    function cerrarAmbito(){
        tablasDeSimbolos.pop();
    }

    function errorSemantico(descripcion,linea,columna){
        ErrorLS = new Object();
        ErrorLS.lexema = "";
        ErrorLS.linea = linea;
        ErrorLS.columna = columna;
        ErrorLS.tipo = 'Semántico';
        ErrorLS.descripcion = descripcion;
        errores.push(ErrorLS);
    }

    function produccion(yy,$1,$2,linea,columna){
        try{
            if($2!=null){
                //Analizar tipo de resultado
                let tipoResultado = yy.filtrarOperacion($1.tipoResultado,$2.tipoResultado,$2.operacionPendiente);
                if(tipoResultado!=null){
                    operacion = new Object();
                    operacion.tipoResultado = tipoResultado;
                    operacion.operacionPendiente = $1;

                    operacion.instruccion = yy.nuevaOperacion($1.instruccion,$2.instruccion,$2.operacionPendiente,null);

                    return operacion;
                }else{
                    errorSemantico("Operandos incorrectos para el operador "+$2.operacionPendiente+" .",linea,columna);
                    return null;
                }
            }else{
                return $1;
            }
        }catch(error){
            return null;
        }
    }

    function produccionPrima(yy,$1,$2,$3,linea,columna){
        try{
            if($3==null){
                operacion = new Object();
                operacion.tipoResultado = $2.tipoResultado;
                operacion.operacionPendiente = $1;

                operacion.instruccion = $2.instruccion;

                return operacion;
            }else{
                //Analizar tipo de resultado
                if($2!=null){
                    let tipoResultado = yy.filtrarOperacion($2.tipoResultado,$3.tipoResultado,$3.operacionPendiente);
                    if(tipoResultado!=null){
                        operacion = new Object();
                        operacion.tipoResultado = tipoResultado;
                        operacion.operacionPendiente = $1;

                        operacion.instruccion = yy.nuevaOperacion($2.instruccion,$3.instruccion,$3.operacionPendiente,null);

                        return operacion;
                    }else{
                        errorSemantico("Operandos incorrectos para el operador "+$3.operacionPendiente+" .",linea,columna);
                        return null;
                    }
                }else{
                    return null;
                }
            }
        }catch(error){
            return null;
        }
    }

    function existeSimbolo(id,rol){
        for(let simbolo in getAmbitoActual()){
            if(getAmbitoActual()[simbolo].rol==rol && getAmbitoActual()[simbolo].id==id){
                return true;
            }
        }
        return false;
    }

    function agregarSimbolo(id,tipo,ambito,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = ambito;
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        getAmbitoActual().push(simboloNuevo);
    }

    function validarVariable(id,yy){
        let tabla = getAmbitoActual().slice();
        while(tabla.length>0){
            let sim = tabla.pop();
            if((sim.rol==yy.VARIABLE || sim.rol==yy.PARAMETRO || sim.rol==yy.CONSTANTE) && sim.id==id){
                return sim;
            }
        }
        return null;
    }

    function implementarInclude(paquete,yy){
        return yy.importador.importar(paquete,yy.PILA_INS,yy.ARCHIVOS_JAVA,yy.ARCHIVOS_PYTHON,yy.arch_actual);
    }

%}

%%

inicial :  a1 EOF   {
                        /*yy.LISTA.agregarTexto("este texto");
                        yy.LISTA.agregarTexto("este texto 1");
                        yy.LISTA.agregarTexto("este texto 2");
                        yy.LISTA.imprimir();*/
                        /*for(const simbolo in getAmbitoActual()){
                            console.log("-----------------");
                            console.log("Id: "+getAmbitoActual()[simbolo].id);
                            console.log("Tipo: "+getAmbitoActual()[simbolo].tipo);
                            console.log("Ambito: "+getAmbitoActual()[simbolo].ambito);
                            console.log("Visibilidad: "+getAmbitoActual()[simbolo].visibilidad);
                            console.log("Rol: "+getAmbitoActual()[simbolo].rol);
                        }*/
                    }
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

a1 : instrucciones_include declaraciones metodo_principal
    | /*++++++++++++POR EL MOMENTO+++++++++++++++++*/ err
    ;

include : PR_INCLUDE PAQUETE {
        if(yy.importador.importar($2.toString(),yy.PILA_INS,yy.ARCHIVOS_JAVA,yy.ARCHIVOS_PYTHON,yy.arch_actual)){
            //todo bien
        }else{
            errorSemantico("Error al importar "+$2.toString()+" .",this._$.first_line,this._$.first_column);
        }
    }
    ;

instrucciones_include :  instrucciones_include_p
    | /*Lambda*/
    ;

instrucciones_include_p : include
    | include instrucciones_include_p
    ;



// INSTRUCCIONES DISPONIBLES EN METODO PRINCIPAL -----------------------------------

instrucciones : instrucciones_p
    | //Lammbda
    ;

instrucciones_p: instrucciones_b_p
    | instrucciones_b_p instrucciones_p
    ;

instrucciones_b_p : declaracion_variable PUNTO_Y_COMA
    | asignacion_variable PUNTO_Y_COMA { yy.PILA_INS.apilar($1); }
    | instruccion_if
    | instruccion_switch
    | ciclo_for
    | ciclo_while
    | ciclo_do_while
    ;

//----------------------------------------------------------------------------------



// METODO PRINCIPAL ----------------------------------------------------------------

metodo_principal : metodo_principal_p LLAVE_A instrucciones LLAVE_C {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    ;

metodo_principal_p : PR_VOID PR_MAIN PARENT_A PARENT_C {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoMetodo($2.toString()));
    }
    ;

//----------------------------------------------------------------------------------


// DECLARACION DE VARIABLES --------------------------------------------------------

declaraciones : declaraciones_p
    | /*Lambda*/
    ;

declaraciones_p : declaracion_variable PUNTO_Y_COMA
    | declaracion_variable PUNTO_Y_COMA declaraciones_p
    ;

declaracion_variable : tipo ids asignacion  {
        //declaracion y asignacion
        if($3==null || $1 == $3.tipoResultado){
            while(ids.length>0){
                //asignacion de tipo correcta
                let id = ids.pop();
                if(existeSimbolo(id,yy.VARIABLE) || existeSimbolo(id,yy.CONSTANTE)){
                    errorSemantico("La variable "+id+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
                }else{
                    if($3 != null){
                        //simboloVariable.valor = $3.valor;
                        yy.PILA_INS.apilar(yy.nuevaDeclaracion(id,$3.instruccion));
                    }
                    agregarSimbolo(id,$1,"",yy.DEFAULT,yy.VARIABLE);
                }
            }
        }else{
            errorSemantico("Tipo de dato requerido : "+$1+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
    }
    | PR_CONST tipo ids ASIGNACION expresion_multiple {
        //declaracion y asignacion
        if($2 == $5.tipoResultado){
            while(ids.length>0){
                //asignacion de tipo correcta
                let id = ids.pop();
                if(existeSimbolo(id,yy.VARIABLE) || existeSimbolo(id,yy.CONSTANTE)){
                    errorSemantico("La variable "+id+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
                }else{
                    //simboloVariable.valor = $3.valor;
                    agregarSimbolo(id,$2,"",yy.DEFAULT,yy.CONSTANTE);

                    yy.PILA_INS.apilar(yy.nuevaDeclaracion(id,$5.instruccion));
                }
            }
        }else{
            errorSemantico("Tipo de dato requerido : "+$2+" . Obtenido: "+$5.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
    }
    ;

ids : ids_p
    | ids_p COMA ids
    ;

ids_p : ID { ids.push($1); }
    ;

tipo : PR_INT { $$ = yy.INT; }
    | PR_FLOAT { $$ = yy.FLOAT; }
    | PR_CHAR { $$ = yy.CHAR; }
    ;

asignacion : /*Lambda*/ { $$ = null; }
    | ASIGNACION expresion_multiple { $$ = $2; }
    ;


//----------------------------------------------------------------------------------



//ASIGNACION DE VARIABLES ------------------------------------------------------------

asignacion_variable : ID ASIGNACION expresion_multiple {
        //validando id
        let simId = validarVariable($1,yy);
        if(simId==null){
            errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
        }else{
            if(simId.rol==yy.CONSTANTE){
                errorSemantico("No se puede reasignar un valor a una constante.",this._$.first_line,this._$.first_column);
            }else{
                if(simId.tipo == $3.tipoResultado){
                    //asignacion exitosa;
                    //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                    //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                    //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                    //TEMP+++++++++++++++++++++++++++++++++++
                    $$ = yy.nuevaAsignacion($1.toString(),$3.instruccion);
                }else{
                    errorSemantico("Tipo de dato requerido : "+simId.tipo+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
                }
            }
        }
    }
    | ID inc_dec {
        let simId_a = validarVariable($1,yy);
        if(simId_a==null){
            errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
        }else{
            if(simId_a.tipo == yy.INT || simId_a.tipo == yy.DOUBLE){
                //asignacion exitosa;
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //TEMP+++++++++++++++++++++++++++++++++++
                $$ = yy.nuevoIncDec($1.toString(),$2);
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.INT+","+yy.DOUBLE+" . Obtenido: "+simId_a.tipo+" .",this._$.first_line,this._$.first_column);
            }
        }
    }
    ;

inc_dec : INCREMENTO { $$ = yy.SUMA; }
    | DECREMENTO { $$ = yy.RESTA; }
    ;

//------------------------------------------------------------------------------------


// INSTRUCCION IF ------------------------------------------------------------------


instruccion_if : instruccion_if_b_p LLAVE_A instrucciones LLAVE_C fin_if instruccion_if_p {
        yy.PILA_INS.sacar();
    }
    ;

instruccion_if_b_p : PR_IF inicio_if PARENT_A expresion_multiple PARENT_C {
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoIf($4.instruccion));

        }catch(exception){
        }
    }
    ;

inicio_if : { nuevoAmbito(); }
    ;

fin_if : { cerrarAmbito(); }
    ;

instruccion_if_p : instrucciones_else_if
    | instrucciones_else_if instruccion_else
    | instruccion_else
    | /*Lambda*/
    ;

instrucciones_else_if : instruccion_else_if
    | instrucciones_else_if instruccion_else_if
    ;

instruccion_else_if : instruccion_else_if_b_p  LLAVE_A instrucciones LLAVE_C fin_else_if
    ;

instruccion_else_if_b_p : PR_ELSE PR_IF PARENT_A expresion_multiple PARENT_C {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoElseIf($4.instruccion));
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(exception){
        }
    }
    ;

fin_else_if : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

instruccion_else : PR_ELSE inicio_else LLAVE_A instrucciones LLAVE_C fin_else
    ;

inicio_else : {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoElse());
    }
    ;

fin_else : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    ;

//----------------------------------------------------------------------------------




// INSTRUCCION SWITCH --------------------------------------------------------------


instruccion_switch : inicio_switch instruccion_switch_c_p {
        yy.PILA_INS.sacar();
    }
    ;

inicio_switch : PR_SWITCH  PARENT_A expresion_multiple PARENT_C {
        if($3.tipoResultado == yy.FLOAT || $3.tipoResultado == yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.INT+","+yy.CHAR+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
        tipoDatoSwtich = $3.tipoResultado;
        yy.PILA_INS.apilar(yy.nuevoSwitch($3.instruccion));
    }
    ;

instruccion_switch_c_p : LLAVE_A LLAVE_C
    | LLAVE_A instruccion_switch_t_p LLAVE_C
    | LLAVE_A instruccion_switch_default LLAVE_C
    | LLAVE_A instruccion_switch_t_p instruccion_switch_default LLAVE_C
    ;

instruccion_switch_t_p : instruccion_switch_b_p
    | instruccion_switch_b_p instruccion_switch_t_p
    ;

instruccion_switch_b_p : PR_CASE inicio_cas_sw case_p DOS_PUNTOS instrucciones instruccion_break fin_cas_sw {

    }
    ;

case_p : expresion_multiple {
        //try{
            if($1.tipoResultado != tipoDatoSwtich){
                errorSemantico("Tipo de dato requerido : "+tipoDatoSwtich+" . Obtenido: "+$1.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoCase($1.instruccion));
        //}catch(e){
            //console.log(e);
        //}
    }
    ;

inicio_cas_sw : { nuevoAmbito(); };

fin_cas_sw : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    ;

instruccion_switch_default : PR_DEFAULT inicio_def_sw DOS_PUNTOS instrucciones fin_def_sw
    ;

inicio_def_sw : {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoDefault());
    };

fin_def_sw : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    ;

//------------------------------------------------------------------------------------


// INSTRUCCION BREAK ----------------------------------------------------------------

instruccion_break : PR_BREAK PUNTO_Y_COMA { yy.PILA_INS.apilar(yy.nuevoBreak()); }
    | /*Lambda*/
    ;

//-----------------------------------------------------------------------------------





// CICLO DO WHILE --------------------------------------------------------------------

ciclo_do_while : PR_DO inicio_do LLAVE_A instrucciones LLAVE_C fin_do
    PR_WHILE PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {
        try{
            if($9.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$9.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.sacarDoWhile($9.instruccion);
        }catch(exception){
        }
    }
    ;

inicio_do : {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoDoWhile(null));
    };

fin_do : { cerrarAmbito(); };

//------------------------------------------------------------------------------------

// CICLO WHILE --------------------------------------------------------------------

ciclo_while : parte_while LLAVE_A instrucciones LLAVE_C fin_while
    ;

parte_while : PR_WHILE inicio_while PARENT_A expresion_multiple PARENT_C {
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoWhile($4.instruccion));
        }catch(exception){
        }
    }
    ;

inicio_while : { nuevoAmbito(); };

fin_while : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

//------------------------------------------------------------------------------------




//CICLO FOR --------------------------------------------------------------------------

ciclo_for : PR_FOR inicio_for PARENT_A ciclo_for_p PARENT_C LLAVE_A instrucciones LLAVE_C fin_for {
    }
    ;

inicio_for : { nuevoAmbito(); };

fin_for : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

ciclo_for_p : primera_exp PUNTO_Y_COMA expresion_multiple PUNTO_Y_COMA accion_posterior {
        try{
            if($3.tipoResultado!=yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoFor($1,$3.instruccion,$5));
        }catch(e){
        }
    }
    ;

primera_exp : ID ASIGNACION expresion_multiple {
        //declaracion y asignacion
        try{
            if($3.tipoResultado==yy.INT){
                    if(existeSimbolo($1.toString(),yy.VARIABLE) || existeSimbolo($1.toString(),yy.CONSTANTE)){
                        errorSemantico("La variable "+$1.toString()+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
                    }else{
                        $$ = yy.nuevaDeclaracion($1.toString(),$3.instruccion);
                        agregarSimbolo($1.toString(),yy.INT,"",yy.DEFAULT,yy.VARIABLE);
                    }
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.INT+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(e){
            console.log(e);
            $$ = null;
        }
    }
    ;


/*primera_exp : declaracion_variable { $$ = $1; }
    | asignacion_variable { $$ = $1; }
    ;
*/

accion_posterior : asignacion_variable { $$ = $1; }
    |  { $$ = null; }
    ;

//------------------------------------------------------------------------------------




//EXPRESION MULTIPLE----------------------------------------------------------------
expresion_multiple : a3 { $$ = $1; };


//---------------------A3---------------------
a3 : b3 a3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

a3p : a3bp b3 a3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

a3bp : OR { $$ = yy.OR; }
    | XOR { $$ = yy.XOR; }
    ;

//---------------------B3---------------------
b3 : c3 b3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

b3p : b3bp c3 b3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

b3bp : AND { $$ = yy.AND; }
    ;

//---------------------C3---------------------

c3 : d3 c3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

c3p : c3bp d3 c3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

c3bp : IGUAL { $$ = yy.IGUAL; }
    | NO_IGUAL { $$ = yy.NO_IGUAL; }
    | MAYOR { $$ = yy.MAYOR; }
    | MENOR { $$ = yy.MENOR; }
    | MAYOR_IGUAL { $$ = yy.MAYOR_IGUAL; }
    | MENOR_IGUAL { $$ = yy.MENOR_IGUAL; }
    ;

//---------------------D3---------------------

d3 : e3 d3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

d3p : d3bp e3 d3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

d3bp : SUMA { $$ = yy.SUMA; }
    | RESTA { $$ = yy.RESTA; }
    ;

//---------------------E3---------------------

e3 : f3 e3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

e3p : e3bp f3 e3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

e3bp : MULTIPLICACION { $$ = yy.MULTIPLICACION; }
    | DIVISION { $$ = yy.DIVISION; }
    | MODULO { $$ = yy.MODULO; }
    ;

//---------------------F3---------------------

f3 : g3 f3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

f3p : f3bp g3 f3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

f3bp : POTENCIA { $$ = yy.POTENCIA; }
    ;


//---------------------G3---------------------

//+++++++++++++++++++++++++=PARENTESIS Y NOT

g3 : PARENT_A a3 PARENT_C { $$ = $2; }
    | NOT ID    {
        let simbolo = obtenerSimbolo($2);
        if(simbolo==null){
            errorSemantico("No se encuentra el símbolo "+$2+" .",this._$.first_line,this._$.first_column);
            $$ = null;
        }else{
            if(simbolo.tipo==yy.BOOLEAN){
                operacion = new Object();
                operacion.tipoResultado = yy.BOOLEAN;
                $$ = operacion;
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+simbolo.tipo+" .",this._$.first_line,this._$.first_column);
                $$ = null;
            }
        }
    }
    | NOT BOOLEAN    {
        operacion = new Object();
        operacion.tipoResultado = yy.BOOLEAN;
        $$ = operacion;
    }
    | NOT PARENT_A a3 PARENT_C {
        if($3==null){
            $$ = null;
        }else{
            if($3.tipoResultado==yy.BOOLEAN){
                operacion = new Object();
                operacion.tipoResultado = yy.BOOLEAN;
                $$ = operacion;
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
                $$ = null;
            }
        }
    }
    ;

g3 : INT        {
                    operacion = new Object();
                    operacion.tipoResultado = yy.INT;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.INT,$1.toString());
                    $$ = operacion;
                }
    | FLOAT    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.FLOAT;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.FLOAT,$1.toString());
                    $$ = operacion;
                }
    | CHAR      {
                    operacion = new Object();
                    operacion.tipoResultado = yy.CHAR;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.CHAR,$1.toString());
                    $$ = operacion;
                }
    | ID        {
                    operacion = new Object();
                    let sim_id_a = validarVariable($1,yy);
                    if(sim_id_a==null){
                        errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
                        operacion.tipoResultado = yy.ID;
                    }else{
                        operacion.tipoResultado = sim_id_a.tipo;
                    }
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.ID,$1.toString());
                    $$ = operacion;
                }
    ;


//-------------------------------------------------------------------------------
