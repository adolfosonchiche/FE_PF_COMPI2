import { PilaInstruccion } from "../instruccion/structure/PilaInstruccion";
import { Clase } from "../instruccion/java/Clase";
import { ArchivoInstrucciones } from "./ArchivoInstrucciones";

export class ListaArchivoInstrucciones extends Array<ArchivoInstrucciones> {

    /*
    public buscarArchivo(id:string):ArchivoInstrucciones{
        for(let i=0;i<this.length;i++){
            if(this[i].getId()==id){
                return this[i];
            }
        }
        return null;
    }

    public buscarClase(idArchivo:string,nombreClase:string):Clase{
        for(let i = 0;i<this.length;i++){
            if(this[i].getId()==idArchivo){
                for(let y = 0;y < this[i].getInstrucciones().length;y++){
                    if(this[i].getInstrucciones()[y] instanceof Clase){
                        if((this[i].getInstrucciones()[y] as Clase).getNombre()==nombreClase){
                            return this[i].getInstrucciones()[y] as Clase;
                        }
                    }
                }
                return null;
            }
        }
        return null;
    }
    */



}
