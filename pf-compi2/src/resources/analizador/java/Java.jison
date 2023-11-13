%lex
%options case-sensitive


%%

[ \r\t\n]+                   { /*ignorar*/}
[/][/].*                                        { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}

[0-9]+"."[0-9]+                 return 'DOUBLE'
[0-9]+                          return 'INT'
"true"|"false"                  return 'BOOLEAN'
\"[^"]*\"                     { yytext = yytext.substr(1,yyleng-2); return 'STRING'; }
\'.\'                         { yytext = yytext.substr(1,yyleng-2); return 'CHAR'; }

//palabras reservadas
"public"                        return 'PR_PUBLIC'
"private"                       return 'PR_PRIVATE'
"final"                         return 'PR_FINAL'
"class"                         return 'PR_CLASS'
"void"                          return 'PR_VOID'
"int"                           return 'PR_INT'
"double"                        return 'PR_DOUBLE'
"char"                          return 'PR_CHAR'
"boolean"                       return 'PR_BOOLEAN'
"string"                        return 'PR_STRING'
"main"                          return 'PR_MAIN'
"import"                        return 'PR_IMPORT'
"@Getter"                       return 'PR_GETTER'
"@Setter"                       return 'PR_SETTER'

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

[a-zA-Z]+[a-zA-Z0-9_]*          return 'ID'




<<EOF>>                         return 'EOF'
.                               {/*Instertar codigo para recuperar el error lexico*/
            //error
            let ErrorLS = new Object();
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
    //-w-let tablaDeSimbolos = [];
    let tablasDeSimbolos = [];
    //-w-let ambitoActual = [];
    let ids = [];
    let simbolosParametros = [];
    let cadParametros = "";
    let ambitoClase = true;
    let tipoDatoSwtich = "";

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
        tablasDeSimbolos.splice(0, tablasDeSimbolos.length);
        let tablaGlobal = [];
        tablasDeSimbolos.push(tablaGlobal);
        ids.splice(0, ids.length);
        simbolosParametros.splice(0, simbolosParametros.length);
        cadParametros = "";
        ambitoClase = true;
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
        let ErrorLS = new Object();
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
                    const operacion = new Object();
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
                const operacion = new Object();
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

    function existeClase(id,yy){
        //-w-for(let simbolo in tablaDeSimbolos){
        for(let simbolo in getAmbitoActual()){
            //-w-if(tablaDeSimbolos[simbolo].rol==yy.CLASE && tablaDeSimbolos[simbolo].id==id){
            if(getAmbitoActual()[simbolo].rol==yy.CLASE && getAmbitoActual()[simbolo].id==id){
                return true;
            }
        }
        return false;
    }

    function obtenerSimbolo(id){
        for (let i=getAmbitoActual().length - 1; i >= 0; i--) {
            if(id==getAmbitoActual()[i].id){
                return getAmbitoActual()[i];
            }
        }
        return null;
    }

    function obtenerUltimoMetodo(yy){
        console.log(tablasDeSimbolos);
        for (let i=getAmbitoActual().length - 1; i >= 0; i--) {
            if(getAmbitoActual()[i].rol == yy.METODO){
                return getAmbitoActual()[i];
            }
        }
        return null;
    }

    function agregarSimbolo(id,tipo,ambito,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = ambito;
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        //-w-tablaDeSimbolos.push(simboloNuevo);
        getAmbitoActual().push(simboloNuevo);
    }

    function agregarSimboloParametro(id,tipo,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = "";
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        simbolosParametros.push(simboloNuevo);
    }

    function pushSimbolosParametros(){
        while(simbolosParametros.length>0){
            //-w-tablaDeSimbolos.push(simbolosParametros.pop());
            getAmbitoActual().push(simbolosParametros.pop());
            //-w-tablaDeSimbolos.at(-1).ambito = ambitoActual.at(-1);
        }
    }

    function validarVariable(id,yy){
        //-w-let tabla = tablaDeSimbolos.slice();
        let tabla = getAmbitoActual().slice();
        while(tabla.length>0){
            let sim = tabla.pop();
            if((sim.rol==yy.VARIABLE || sim.rol==yy.PARAMETRO) && sim.id==id){

                return sim;
            }
        }
        return null;
    }
%}

%%

inicial :  a1 EOF   {
                        for(const simbolo in getAmbitoActual()){
                            console.log("Id: "+getAmbitoActual()[simbolo].id);
                            console.log("Tipo: "+getAmbitoActual()[simbolo].tipo);
                            console.log("Ambito: "+getAmbitoActual()[simbolo].ambito);
                            console.log("Visibilidad: "+getAmbitoActual()[simbolo].visibilidad);
                            console.log("Rol: "+getAmbitoActual()[simbolo].rol);
                        }
                    }
    ;



err : error {
            //error
            let ErrorLS = new Object();
            ErrorLS.lexema = yytext;
            ErrorLS.linea = this._$.first_line;
            ErrorLS.columna = this._$.first_column;
            ErrorLS.tipo = 'Sintáctico';
            ErrorLS.descripcion = '';
            errores.push(ErrorLS);
    }
    ;

a1 : declaracion_clase
    | declaracion_clase a1
    ;

//DECLARACION DE CLASE ---------------------------------------------------------------

declaracion_clase : declaracion_clase_p LLAVE_A instrucciones_clase LLAVE_C {
        //-w-ambitoActual.pop();
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    | declaracion_clase_p LLAVE_A LLAVE_C {
        //-w-ambitoActual.pop();
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    | err
    ;

declaracion_clase_p : PR_PUBLIC PR_CLASS ID {
            if(existeClase($3,yy)){
                errorSemantico("La clase "+$3+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
            }
            agregarSimbolo($3,"","",yy.PUBLIC,yy.CLASE);
            nuevoAmbito();
            yy.PILA_INS.apilar(yy.nuevaClase($3.toString()));
        }
        | PR_CLASS ID {
            if(existeClase($3,yy)){
                errorSemantico("La clase "+$3+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
            }
            agregarSimbolo($3,"","",yy.PUBLIC,yy.CLASE);
            nuevoAmbito();
            yy.PILA_INS.apilar(yy.nuevaClase($3.toString()));
        }
    ;

//------------------------------------------------------------------------------------


//INSTRUCCIONES DENTRO DE CLASE--------------------------------------------------------

instrucciones_clase : instrucciones_clase_p
    | instrucciones_clase_p instrucciones_clase
    ;

instrucciones_clase_p : declaracion_variable PUNTO_Y_COMA { yy.PILA_INS.apilar($1); }
    | declaracion_metodo
    ;

//-------------------------------------------------------------------------------------

// METODO PRINCIPAL ----------------------------------------------------------------

metodo_principal : metodo_principal_p /*LLAVE_A instrucciones_metodo LLAVE_C*/ {
        cerrarAmbito();
        ambitoClase = true;
        yy.PILA_INS.sacar();
    }
    ;

metodo_principal_p : PR_MAIN PARENT_A PARENT_C {
        //nuevoAmbito();
        //yy.PILA_INS.apilar(yy.nuevoMetodo($2.toString()));

        if(existeSimbolo($1+cadParametros,yy.METODO)){
            //-w-errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
            errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado.",this._$.first_line,this._$.first_column);
        }
        //-w-agregarSimbolo(ambitoActual.at(-1)+"_"+$1+cadParametros,"",ambitoActual.at(-1),"",yy.METODO);
        agregarSimbolo($1+cadParametros,"","","",yy.METODO);
        nuevoAmbito();

        yy.PILA_INS.apilar(yy.nuevoMetodo($1+cadParametros));

        //-w-ambitoActual.push(ambitoActual.at(-1)+"_"+$1+cadParametros);
        ambitoClase = false;
        cadParametros = "";
        pushSimbolosParametros();
    }
    ;

//INSTRUCCIONES DENTRO DE METODO--------------------------------------------------------

instrucciones_metodo : instrucciones_metodo_p
    | instrucciones_metodo_p instrucciones_metodo
    ;

instrucciones_metodo_p : declaracion_variable PUNTO_Y_COMA { yy.PILA_INS.apilar($1); }
    | asignacion_variable PUNTO_Y_COMA { yy.PILA_INS.apilar($1); }
    | instruccion_if
    | ciclo_for
    | ciclo_while
    | ciclo_do_while
    | instruccion_switch
    | instruccion_print
    | instruccion_println
    ;

//-------------------------------------------------------------------------------------

//DECLARACION DE VARIABLE ------------------------------------------------------------

declaracion_variable : visibilidad tipo ids asignacion {
            if($1 != yy.DEFAULT){
                if(!ambitoClase){
                    errorSemantico("Ilegal inicio de expresión: "+$1+".",this._$.first_line,this._$.first_column);
                }
            }
            //declaracion y asignacion
            if($4==null || $2 == $4.tipoResultado){
                while(ids.length>0){
                    //asignacion de tipo correcta
                    let id = ids.pop();
                    //-w-if(existeSimbolo(id,ambitoActual.at(-1),yy.VARIABLE)){
                    if(existeSimbolo(id,yy.VARIABLE)){
                        errorSemantico("La variable "+id+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
                    }else{
                        if($4 != null){
                            //simboloVariable.valor = $4.valor;
                            $$ = yy.nuevaDeclaracion(id,$4.instruccion);
                        }
                        //-w-agregarSimbolo(id,$2,ambitoActual.at(-1),$1,yy.VARIABLE);
                        agregarSimbolo(id,$2,"",$1,yy.VARIABLE);
                    }
                }
            }else{
                errorSemantico("Tipo de dato requerido : "+$2+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }
    ;

ids : ids_p
    | ids_p COMA ids
    ;

ids_p : ID { ids.push($1); }
    ;

tipo : PR_INT { $$ = yy.INT; }
    | PR_DOUBLE { $$ = yy.DOUBLE; }
    | PR_CHAR { $$ = yy.CHAR; }
    | PR_STRING { $$ = yy.STRING; }
    | PR_BOOLEAN { $$ = yy.BOOLEAN; }
    ;

asignacion : /*Lambda*/ { $$ = null; }
    | ASIGNACION expresion_multiple { $$ = $2; }
    ;

//------------------------------------------------------------------------------------

//ASIGNACION DE VARIABLES ------------------------------------------------------------

asignacion_variable : ID ASIGNACION expresion_multiple {
        //validando id
        let simId = validarVariable($1,yy);
        if(simId==null){
            errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
        }else{
            if(simId.tipo == $3.tipoResultado){
                //asignacion exitosa;
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                $$ = yy.nuevaAsignacion($1.toString(),$3.instruccion);
            }else{
                errorSemantico("Tipo de dato requerido : "+simId.tipo+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
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

//VISIBILIDAD-------------------------------------------------------------------------

visibilidad : PR_PUBLIC { $$ = yy.PUBLIC; }
    | PR_PRIVATE { $$ = yy.PRIVATE; }
    | /*Lambda*/ { $$ = yy.DEFAULT; }
    ;

//------------------------------------------------------------------------------------

//DECLARACION DE METODOS -------------------------------------------------------------

declaracion_metodo : visibilidad tipo declaracion_metodo_p {
        let ultimoMetodoDeclarado = obtenerUltimoMetodo(yy);
        ultimoMetodoDeclarado.visibilidad = $1;
        ultimoMetodoDeclarado.tipo = $2;
    }
    | visibilidad PR_VOID declaracion_metodo_p {
        let ultimoMetodoDeclarado1 = obtenerUltimoMetodo(yy);
        ultimoMetodoDeclarado1.visibilidad = $1;
        ultimoMetodoDeclarado1.tipo = $2;
    }
    ;

declaracion_metodo_p : declaracion_metodo_p_a llill {
        //-w-ambitoActual.pop();
        cerrarAmbito();
        ambitoClase = true;
        yy.PILA_INS.sacar();
    }
    /*| declaracion_metodo_p_a LLAVE_A LLAVE_C {
        //-w-ambitoActual.pop();
        cerrarAmbito();
        ambitoClase = true;
        yy.PILA_INS.sacar();
    }*/
    ;

declaracion_metodo_p_a : ID PARENT_A parametros_b_p PARENT_C {
        //-w-if(existeSimbolo(ambitoActual.at(-1)+"_"+$1+cadParametros,ambitoActual.at(-1),yy.METODO)){
        if(existeSimbolo($1+cadParametros,yy.METODO)){
            //-w-errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
            errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado.",this._$.first_line,this._$.first_column);
        }
        //-w-agregarSimbolo(ambitoActual.at(-1)+"_"+$1+cadParametros,"",ambitoActual.at(-1),"",yy.METODO);
        agregarSimbolo($1+cadParametros,"","","",yy.METODO);
        nuevoAmbito();

        yy.PILA_INS.apilar(yy.nuevoMetodo($1+cadParametros));

        //-w-ambitoActual.push(ambitoActual.at(-1)+"_"+$1+cadParametros);
        ambitoClase = false;
        cadParametros = "";
        pushSimbolosParametros();
    }
    | metodo_principal
    ;

parametros : parametros_p
    | parametros_p COMA parametros
    ;

parametros_p : tipo ID {
        cadParametros+="_"+$1;
        if(simbolosParametros.some(w => w.id === $2)){
            errorSemantico("La variable "+$2+" ya ha sido definida como parámetro.",this._$.first_line,this._$.first_column);
        }else{
            agregarSimboloParametro($2,$1,yy.PRIVATE,yy.PARAMETRO);
        }
    }
    ;

parametros_b_p : parametros
    | /*Lambda*/
    ;

//------------------------------------------------------------------------------------

//INSTRUCCIONES PRINT Y PRINTLN ------------------------------------------------------

instruccion_print : PR_PRINT PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {

    }
    ;

instruccion_println : PR_PRINTLN PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {

    }
    ;

//------------------------------------------------------------------------------------


//PRODUCCION LLAVE INSTRUCCIONES LLAVE ----------------------------------------------

llill :  LLAVE_A instrucciones_metodo LLAVE_C
    | LLAVE_A LLAVE_C
    ;

//-----------------------------------------------------------------------------------



//CONDICIONAL IF ELSE-IF ELSE --------------------------------------------------------

instruccion_if : instruccion_if_b_p llill fin_if instruccion_if_p {
        yy.PILA_INS.sacar();
    }
    ;

inicio_if : { nuevoAmbito(); };

fin_if : { cerrarAmbito(); };

instruccion_if_b_p : PR_IF inicio_if PARENT_A expresion_multiple PARENT_C {
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoIf($4.instruccion));
        }catch(exception){
        }
    }
    ;

instruccion_if_p : instrucciones_else_if
    | instrucciones_else_if instruccion_else
    | instruccion_else
    | /*Lambda*/
    ;

instrucciones_else_if : instruccion_else_if
    | instrucciones_else_if instruccion_else_if
    ;

instruccion_else_if : instruccion_else_if_b_p  llill fin_else_if
    ;

fin_else_if : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

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

instruccion_else : PR_ELSE inicio_else llill fin_else
    ;

inicio_else : {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoElse());
    };

fin_else : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

//------------------------------------------------------------------------------------



// CICLO DO WHILE --------------------------------------------------------------------

ciclo_do_while : PR_DO inicio_do llill fin_do
    PR_WHILE PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {
        try{
            if($9.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$9.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.sacarDoWhile($7.instruccion);
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

ciclo_while : parte_while llill fin_while
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

ciclo_for : PR_FOR inicio_for PARENT_A ciclo_for_p PARENT_C llill fin_for {

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

primera_exp : declaracion_variable { $$ = $1; }
    | asignacion_variable { $$ = $1; }
    ;

accion_posterior : asignacion_variable { $$ = $1; }
    | /*Lambda*/ { $$ = null; }
    ;

//------------------------------------------------------------------------------------


instruccion_switch : inicio_switch instruccion_switch_c_p {
        yy.PILA_INS.sacar();
    }
    ;

inicio_switch : PR_SWITCH  PARENT_A expresion_multiple PARENT_C {
        if($3.tipoResultado == yy.DOUBLE || $3.tipoResultado == yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.INT+","+yy.CHAR+","+yy.STRING+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
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

instruccion_switch_b_p : PR_CASE inicio_cas_sw case_p case_ins instruccion_break fin_cas_sw{

    }
    ;


case_p : expresion_multiple {
        if($1.tipoResultado != tipoDatoSwtich){
            errorSemantico("Tipo de dato requerido : "+tipoDatoSwtich+" . Obtenido: "+$1.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }

        yy.PILA_INS.apilar(yy.nuevoCase($1.instruccion));
    }
    ;


case_ins : DOS_PUNTOS
    | DOS_PUNTOS instrucciones_metodo
    ;

inicio_cas_sw : { nuevoAmbito(); };

fin_cas_sw : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    }
    ;

instruccion_switch_default : PR_DEFAULT inicio_def_sw case_ins fin_def_sw
    ;

inicio_def_sw : {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoDefault());
    };

fin_def_sw : {
        cerrarAmbito();
        yy.PILA_INS.sacar();
    };

//------------------------------------------------------------------------------------

// INSTRUCCION BREAK ----------------------------------------------------------------

instruccion_break : PR_BREAK PUNTO_Y_COMA
    | /*Lambda*/
    ;

//-----------------------------------------------------------------------------------

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
    | DOUBLE    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.DOUBLE;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.DOUBLE,$1.toString());
                    $$ = operacion;
                }
    | CHAR      {
                    operacion = new Object();
                    operacion.tipoResultado = yy.CHAR;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.CHAR,$1.toString());
                    $$ = operacion;
                }
    | STRING    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.STRING;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.STRING,$1.toString());
                    $$ = operacion;
                }
    | BOOLEAN   {
                    operacion = new Object();
                    operacion.tipoResultado = yy.BOOLEAN;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.BOOLEAN,$1.toString());
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

