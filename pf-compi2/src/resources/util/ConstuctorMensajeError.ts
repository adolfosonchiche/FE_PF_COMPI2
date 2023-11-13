export class ConstructorMensajeError{

  public construirMensaje(errores:any, cantidadLinea:Number):String{
      let mensaje:String  = "";
      for(let i=0; i<errores.length; i++){
          mensaje+="    Error en:   ' "+errores[i].lexema+" '\n        Linea: "+(errores[i].linea+cantidadLinea)+"\n        Columna: "+errores[i].columna+"\n        Tipo: "+errores[i].tipo+"\n        "+errores[i].descripcion+"\n";
      }
      return mensaje;
  }

}
