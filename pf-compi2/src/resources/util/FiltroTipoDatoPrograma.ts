export class FiltroTipoDatoPrograma{

  //tipos de datos
  public INT:string = "int";
  public FLOAT:string = "float";
  public CHAR:string = "char";
  public BOOLEAN:string = "boolean";

  public ID:string = "id";

  //void para complemento de tipo de metodo
  public VOID:string = "void";

  //ambito
  public GLOBAL:string = "global";

  //tipos de roles de simbolos
  public METODO:string = "metodo";
  public VARIABLE:string = "variable";
  public CLASE:string = "clase";
  public PARAMETRO:string = "parametro";
  public CONSTANTE:string = "constante";

  //tipos de instrucciones
  public ASIGNACION:string = "asignacion";

  //tipos de operaciones
  public POTENCIA:string = "^";
  public MODULO:string = "%";
  public DIVISION:string = "/";
  public MULTIPLICACION:string = "*";
  public SUMA:string = "+";
  public RESTA:string = "-";
  public IGUAL:string = "==";
  public NO_IGUAL:string = "!=";
  public MAYOR:string = ">";
  public MENOR:string = "<";
  public MAYOR_IGUAL:string = ">=";
  public MENOR_IGUAL:string = "<=";
  public AND:string = "&&";
  public OR:string = "|";
  public XOR:string = "||";

  public PUBLIC:string = "public";
  public PRIVATE:string = "private";
  public DEFAULT:string = "default";

  public mostrarMensaje(valor:any){
      console.log(valor);
  }

  public filtrarOperacion(tipo1:String, tipo2:String, tipoOperacion:String):string | null{
      if(tipoOperacion==this.POTENCIA){
          if(tipo1 == this.INT){
              if(tipo2 == this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else if(tipo1 == this.FLOAT){
              if(tipo2 == this.INT){
                  return this.FLOAT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.MULTIPLICACION){
          if(tipo1==this.INT){
              if(tipo2==this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else if(tipo1==this.FLOAT){
              if(tipo2==this.INT){
                  return this.FLOAT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else if(tipo1==this.CHAR){
              if(tipo2==this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.DIVISION){
          if(tipo1==this.INT || tipo1 == this.FLOAT || tipo1 == this.CHAR){
              if(tipo2==this.INT || tipo2 == this.FLOAT || tipo2 == this.CHAR){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.MODULO){
          if(tipo1==this.INT){
              if(tipo2==this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else if(tipo1==this.FLOAT){
              if(tipo2==this.INT){
                  return this.FLOAT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else if(tipo1==this.CHAR){
              if(tipo2==this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.SUMA){
          if(tipo1 == this.INT){
              if(tipo2 == this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else if(tipo1 == this.FLOAT){
              if(tipo2 == this.INT){
                  return this.FLOAT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else if(tipo1 == this.CHAR){
              if(tipo2 == this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.RESTA){
          if(tipo1 == this.INT){
              if(tipo2 == this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else if(tipo1 == this.FLOAT){
              if(tipo2 == this.INT){
                  return this.FLOAT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.FLOAT;
              }else{
                  return null;
              }
          }else if(tipo1 == this.CHAR){
              if(tipo2 == this.INT){
                  return this.INT;
              }else if(tipo2 == this.FLOAT){
                  return this.FLOAT;
              }else if(tipo2 == this.CHAR){
                  return this.INT;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.IGUAL || tipoOperacion==this.NO_IGUAL){
          if(tipo1 == this.INT){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else if(tipo1 == this.FLOAT){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else if(tipo1 == this.CHAR){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else if(tipo1 == this.BOOLEAN){
              if(tipo2 == this.BOOLEAN){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion==this.MAYOR || tipoOperacion==this.MENOR || tipoOperacion==this.MAYOR_IGUAL || tipoOperacion==this.MENOR_IGUAL){
          if(tipo1 == this.INT){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else if(tipo1 == this.FLOAT){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else if(tipo1 == this.CHAR){
              if(tipo2 == this.INT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.FLOAT){
                  return this.BOOLEAN;
              }else if(tipo2 == this.CHAR){
                  return this.BOOLEAN;
              }else{
                  return null;
              }
          }else{
              return null;
          }
      }else if(tipoOperacion == this.AND || tipoOperacion == this.OR || tipoOperacion == this.XOR){
          if(tipo1==this.BOOLEAN && tipo2==this.BOOLEAN){
              return this.BOOLEAN;
          }else{
              return null;
          }
      }else{
          return null;
      }
  }

}

