import { ConstructorMensajeError } from 'src/resources/util/ConstuctorMensajeError';
import { FiltroTipoDatoJava } from 'src/resources/util/FiltroTipoDatoJava';
import * as AnalizadorJava from '../../resources/analizador/java/Java';
import * as AnalizadorPrograma from '../../resources/analizador/programa/Programa';
import { FiltroTipoDatoPrograma } from 'src/resources/util/FiltroTipoDatoPrograma';
import { ControladorInstrucciones } from './ControladorInstrucciones';
import { PilaInstruccion } from 'src/model/instruccion/structure/PilaInstruccion';
import { ArchivoInstrucciones } from 'src/model/archivo-instruccion/ArchivoInstrucciones';
import { Importador } from 'src/model/archivo-instruccion/Importador';
//import * as Filtro from '../../resources/util/FiltroTipoDato'

export class ControladorAnalisisGeneral {

  private constructorRespuesta: ConstructorMensajeError;
  private filtroTipoDatoJava: FiltroTipoDatoJava;
  private filtroTipoDatoPrograma: FiltroTipoDatoPrograma;
  private controladorInstrucciones: ControladorInstrucciones;
  private importador: Importador;

  public constructor() {
    this.constructorRespuesta = new ConstructorMensajeError();
    this.filtroTipoDatoJava = new FiltroTipoDatoJava();
    this.filtroTipoDatoPrograma = new FiltroTipoDatoPrograma();
    this.controladorInstrucciones = new ControladorInstrucciones();
    this.importador = new Importador();
    this.inicializarYYJava();
    this.inicializarYYPrograma();
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

    //analizando codigo programa
    if (this.existeCodigo(separador.getCodigoPrograma())) {
      AnalizadorPrograma.reset(AnalizadorPrograma.parser.yy);
      AnalizadorPrograma.parser.yy.PILA_INS = pila;
      AnalizadorPrograma.parse(separador.getCodigoPrograma());
      if (AnalizadorPrograma.getErrores().length > 0) {
        respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPrograma.getErrores(), separador.getInicioPrograma());
      }
    }

    return respuesta;
  }

  public analizarCodigoPrograma(separador: any, pila: PilaInstruccion, archivosJava: Array<ArchivoInstrucciones>, archivosPython: Array<ArchivoInstrucciones>, idArchivoActual: string): string {

    let respuesta: string = "";

    //analizando codigo programa
    if (this.existeCodigo(separador.getCodigoPrograma())) {
      AnalizadorPrograma.reset(AnalizadorPrograma.parser.yy);
      AnalizadorPrograma.parser.yy.PILA_INS = pila;
      AnalizadorPrograma.parser.yy.ARCHIVOS_JAVA = archivosJava;
      AnalizadorPrograma.parser.yy.ARCHIVOS_PYTHON = archivosPython;
      AnalizadorPrograma.parser.yy.arch_actual = idArchivoActual;
      AnalizadorPrograma.parser.yy.importador = this.importador;
      AnalizadorPrograma.parse(separador.getCodigoPrograma());
      if (AnalizadorPrograma.getErrores().length > 0) {
        respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPrograma.getErrores(), separador.getInicioPrograma());
      }
    }

    return respuesta;
  }

  public analizarCodigoJava(separador: any, pila: PilaInstruccion): string {
    console.log('analizando codigo java')
    let respuesta: string = "";

    //analizando codigo java
    if (this.existeCodigo(separador.getCodigoJava())) {
      console.log('iniciando el parser')
      AnalizadorJava.reset();
      AnalizadorJava.parser.yy.PILA_INS = pila;
      console.log('vvvv ffff aaaa ssssss')
      console.log(separador.getCodigoJava());
      AnalizadorJava.parse(separador.getCodigoJava());
      if (AnalizadorJava.getErrores().length > 0) {
        console.log('iniciando enviando elparametro')
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

  private inicializarYYPrograma() {
    let yy = AnalizadorPrograma.parser.yy;
    yy.INT = this.filtroTipoDatoPrograma.INT;
    yy.FLOAT = this.filtroTipoDatoPrograma.FLOAT;
    yy.CHAR = this.filtroTipoDatoPrograma.CHAR;
    yy.BOOLEAN = this.filtroTipoDatoPrograma.BOOLEAN;

    yy.ID = this.filtroTipoDatoPrograma.ID;

    yy.VOID = this.filtroTipoDatoPrograma.VOID;

    yy.GLOBAL = this.filtroTipoDatoPrograma.GLOBAL;

    yy.METODO = this.filtroTipoDatoPrograma.METODO;
    yy.VARIABLE = this.filtroTipoDatoPrograma.VARIABLE;
    yy.CLASE = this.filtroTipoDatoPrograma.CLASE;
    yy.PARAMETRO = this.filtroTipoDatoPrograma.PARAMETRO;
    yy.CONSTANTE = this.filtroTipoDatoPrograma.CONSTANTE;

    yy.ASIGNACION = this.filtroTipoDatoPrograma.ASIGNACION;

    yy.POTENCIA = this.filtroTipoDatoPrograma.POTENCIA;
    yy.MODULO = this.filtroTipoDatoPrograma.MODULO;
    yy.DIVISION = this.filtroTipoDatoPrograma.DIVISION;
    yy.MULTIPLICACION = this.filtroTipoDatoPrograma.MULTIPLICACION;
    yy.SUMA = this.filtroTipoDatoPrograma.SUMA;
    yy.RESTA = this.filtroTipoDatoPrograma.RESTA;
    yy.IGUAL = this.filtroTipoDatoPrograma.IGUAL;
    yy.NO_IGUAL = this.filtroTipoDatoPrograma.NO_IGUAL;
    yy.MAYOR = this.filtroTipoDatoPrograma.MAYOR;
    yy.MENOR = this.filtroTipoDatoPrograma.MENOR;
    yy.MAYOR_IGUAL = this.filtroTipoDatoPrograma.MAYOR_IGUAL;
    yy.MENOR_IGUAL = this.filtroTipoDatoPrograma.MENOR_IGUAL;
    yy.AND = this.filtroTipoDatoPrograma.AND;
    yy.OR = this.filtroTipoDatoPrograma.OR;
    yy.XOR = this.filtroTipoDatoPrograma.XOR;
    yy.PUBLIC = this.filtroTipoDatoPrograma.PUBLIC;
    yy.PRIVATE = this.filtroTipoDatoPrograma.PRIVATE;
    yy.DEFAULT = this.filtroTipoDatoPrograma.DEFAULT;

    yy.filtrarOperacion = this.filtroTipoDatoPrograma.filtrarOperacion;

    this.agregarMetodos(yy);
  }

  public getInstrucciones(): Array<any> {
    return AnalizadorPrograma.getInstrucciones();
  }

}
