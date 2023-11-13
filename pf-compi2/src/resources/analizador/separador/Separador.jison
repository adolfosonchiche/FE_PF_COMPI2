%lex
%options case-sensitive


%%
[ \r\t]+                        { agregarTexto(yytext); }
[\n]                            { 
                                        contadorSalto++;
                                        agregarTexto(yytext);
                                }

"paquete"                       { 
                                        if(paquete == "" && codigoActual==0){
                                                return 'PR_PAQUETE';
                                        }else{
                                                agregarTexto(yytext);
                                        }
                                }
"com"("."[a-zA-Z0-9_]+)+        { 
                                        if(paquete == "" && codigoActual==0){
                                                paquete = yytext; 
                                                return 'NOMBRE_PAQUETE';
                                        }else{
                                                agregarTexto(yytext);
                                        } 
                                }
"%%PY"                          {
                                        inicioPython = contadorSalto; 
                                        codigoActual = 1;
                                        return 'ET_PY';
                                }
"%%JAVA"                        { 
                                        inicioJava = contadorSalto;
                                        codigoActual = 2;
                                        return 'ET_JAVA';
                                }
"%%PROGRAMA"                    { 
                                        inicioPrograma = contadorSalto;
                                        codigoActual = 3;
                                        return 'ET_PROGRAMA';
                                }

<<EOF>>                       return 'EOF'
.       {/*Instertar codigo para recuperar el error lexico*/
            agregarTexto(yytext);    
        }

/lex


%start inicial

%{
        let paquete = "";
        let codigoPY = "";
        let codigoJAVA = "";
        let codigoPROGRAMA = "";
        let codigoActual = 0;
        let contadorSalto = 0;
        let inicioPython = null;
        let inicioJava = null;
        let inicioPrograma = null;

        function agregarTexto(texto){
                if(codigoActual==1){
                        codigoPY += texto;
                }else if(codigoActual==2){
                        codigoJAVA += texto;
                }else if(codigoActual==3){
                        codigoPROGRAMA += texto;
                }
        }

        exports.reset = function(){
                codigoPY = "";
                codigoJAVA = "";
                codigoPROGRAMA = "";
                codigoActual = 0;
                paquete = "";
                inicioPython = null;
                inicioJava = null;
                inicioPrograma = null;
                contadorSalto = 0;
        }

        exports.getCodigoPython = function(){
                return codigoPY;
        }
        
        exports.getCodigoJava = function(){
                return codigoJAVA;
        }

        exports.getCodigoPrograma = function(){
                return codigoPROGRAMA;
        }

        exports.getPaquete = function(){
                return paquete;
        }

        exports.getInicioPython = function(){
                return inicioPython;
        }
        
        exports.getInicioJava = function(){
                return inicioJava;
        }

        exports.getInicioPrograma = function(){
                return inicioPrograma;
        }

%}

%%

inicial :  a1 EOF
    ;

a1 :    paq a2 a3 a4 
        | error a2 a3 a4
        ;

a2 :    ET_PY 
        | //lambda
        ;

a3 :    ET_JAVA 
        | //lambda
        ;

a4 :    ET_PROGRAMA 
        | //lambda
        ;

paq : PR_PAQUETE NOMBRE_PAQUETE
        | //lambda
        ;
