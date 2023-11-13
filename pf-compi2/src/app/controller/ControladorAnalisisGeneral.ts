import { ConstructorMensajeError } from 'src/resources/util/ConstuctorMensajeError';
import { FiltroTipoDatoJava } from 'src/resources/util/FiltroTipoDatoJava';
import * as AnalizadorJava from '../../resources/analizador/java/Java';
import { FiltroTipoDatoPrograma } from 'src/resources/util/FiltroTipoDatoPrograma';
import { ControladorInstrucciones } from './ControladorInstrucciones';
import { PilaInstruccion } from 'src/model/instruccion/structure/PilaInstruccion';
import { ArchivoInstrucciones } from 'src/model/archivo-instruccion/ArchivoInstrucciones';
import { Importador } from 'src/model/archivo-instruccion/Importador';
//import * as Filtro from '../../resources/util/FiltroTipoDato'

export class ControladorAnalisisGeneral {

  private constructorRespuesta: ConstructorMensajeError;
  private filtroTipoDatoJava: FiltroTipoDatoJava;
  private controladorInstrucciones: ControladorInstrucciones;

  public constructor() {
    this.constructorRespuesta = new ConstructorMensajeError();
    this.filtroTipoDatoJava = new FiltroTipoDatoJava();
    this.controladorInstrucciones = new ControladorInstrucciones();
    this.inicializarYYJava();
  }

  public analizar(separador: any, pila: PilaInstruccion, pilaJava: PilaInstruccion): string {

    let respuesta: string = "";

    //analizando codigo java
    if (this.existeCodigo(separador.getCodigoJava())) {
      AnalizadorJava.reset();
      AnalizadorJava.parse(separador.getCodigoJava());
      if (AnalizadorJava.getErrores().length > 0) {
        respuesta += this.constructorRespuesta.construirMensaje(AnalizadorJava.getErrores(), separador.getInicioJava());
      }
    }

    return respuesta;
  }


  public analizarCodigoJava(separador: any, pila: PilaInstruccion): string {
    let respuesta: string = "";

    //analizando codigo java
    console.log('vvvv ffff aaaa sssssseparador')
    console.log(separador.getCodigoJava());
    if (this.existeCodigo(separador.getCodigoJava())) {
      AnalizadorJava.reset();
      AnalizadorJava.parser.yy.PILA_INS = pila;


      AnalizadorJava.parse(separador.getCodigoJava());

      if (AnalizadorJava.getErrores().length > 0) {
        respuesta += this.constructorRespuesta.construirMensaje(AnalizadorJava.getErrores(), separador.getInicioJava());
      }
    }

    return respuesta;
  }


  public existeCodigo(codigo: String): Boolean {
    return !(codigo.trim() == "");
  }

  private inicializarYYJava() {
    let yy = AnalizadorJava.parser.yy;
    yy.INT = this.filtroTipoDatoJava.INT;
    yy.DOUBLE = this.filtroTipoDatoJava.DOUBLE;
    yy.CHAR = this.filtroTipoDatoJava.CHAR;
    yy.STRING = this.filtroTipoDatoJava.STRING;
    yy.BOOLEAN = this.filtroTipoDatoJava.BOOLEAN;

    yy.ID = this.filtroTipoDatoJava.ID;

    yy.VOID = this.filtroTipoDatoJava.VOID;

    yy.METODO = this.filtroTipoDatoJava.METODO;
    yy.VARIABLE = this.filtroTipoDatoJava.VARIABLE;
    yy.CLASE = this.filtroTipoDatoJava.CLASE;
    yy.PARAMETRO = this.filtroTipoDatoJava.PARAMETRO;

    yy.POTENCIA = this.filtroTipoDatoJava.POTENCIA;
    yy.MODULO = this.filtroTipoDatoJava.MODULO;
    yy.DIVISION = this.filtroTipoDatoJava.DIVISION;
    yy.MULTIPLICACION = this.filtroTipoDatoJava.MULTIPLICACION;
    yy.SUMA = this.filtroTipoDatoJava.SUMA;
    yy.RESTA = this.filtroTipoDatoJava.RESTA;
    yy.IGUAL = this.filtroTipoDatoJava.IGUAL;
    yy.NO_IGUAL = this.filtroTipoDatoJava.NO_IGUAL;
    yy.MAYOR = this.filtroTipoDatoJava.MAYOR;
    yy.MENOR = this.filtroTipoDatoJava.MENOR;
    yy.MAYOR_IGUAL = this.filtroTipoDatoJava.MAYOR_IGUAL;
    yy.MENOR_IGUAL = this.filtroTipoDatoJava.MENOR_IGUAL;
    yy.AND = this.filtroTipoDatoJava.AND;
    yy.OR = this.filtroTipoDatoJava.OR;
    yy.XOR = this.filtroTipoDatoJava.XOR;
    yy.PUBLIC = this.filtroTipoDatoJava.PUBLIC;
    yy.PRIVATE = this.filtroTipoDatoJava.PRIVATE;
    yy.DEFAULT = this.filtroTipoDatoJava.DEFAULT;

    yy.filtrarOperacion = this.filtroTipoDatoJava.filtrarOperacion;

    this.agregarMetodos(yy);
  }

  private agregarMetodos(yy: any): void {
    yy.nuevaAsignacion = this.controladorInstrucciones.nuevaAsignacion;
    yy.nuevaOperacion = this.controladorInstrucciones.nuevaOperacion;
    yy.nuevaDeclaracion = this.controladorInstrucciones.nuevaDeclaracion;
    yy.nuevoMetodo = this.controladorInstrucciones.nuevoMetodo;
    yy.nuevoIf = this.controladorInstrucciones.nuevoIf;
    yy.nuevoElseIf = this.controladorInstrucciones.nuevoElseIf;
    yy.nuevoElse = this.controladorInstrucciones.nuevoElse;
    yy.nuevoWhile = this.controladorInstrucciones.nuevoWhile;
    yy.nuevoDoWhile = this.controladorInstrucciones.nuevoDoWhile;
    yy.nuevoFor = this.controladorInstrucciones.nuevoFor;
    yy.nuevoIncDec = this.controladorInstrucciones.nuevoIncDec;
    yy.nuevoSwitch = this.controladorInstrucciones.nuevoSwitch;
    yy.nuevoCase = this.controladorInstrucciones.nuevoCase;
    yy.nuevoDefault = this.controladorInstrucciones.nuevoDefault;
    yy.nuevoBreak = this.controladorInstrucciones.nuevoBreak;
    yy.nuevaClase = this.controladorInstrucciones.nuevaClase;
  }



}
