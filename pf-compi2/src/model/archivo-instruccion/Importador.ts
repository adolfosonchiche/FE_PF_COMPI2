import { PilaInstruccion } from "../instruccion/structure/PilaInstruccion";
import { ListaArchivoInstrucciones } from "./ListaArchivoInstrucciones";

export class Importador {

    public importar(idArchivo:string,pila:PilaInstruccion,listaJava:ListaArchivoInstrucciones,listaPython:ListaArchivoInstrucciones,idArchivoActual:string):boolean{
        let id:Array<string> = idArchivo.split(".");
        let tipo = id.shift();
        let archivo = id.pop();
        if(tipo=="JAVA"){
            //importacion del codigo de java
            if(archivo=="*"){
                //incluir todo el codigo en el archivo
                for(let i = 0;i<listaJava.length;i++){
                    if(listaJava[i].getId()==idArchivoActual){
                        pila.apilarGrupoDirecto(listaJava[i].getInstrucciones());
                        return true;
                    }
                }
                return false;
            }
        }
        return false;
    }

}
