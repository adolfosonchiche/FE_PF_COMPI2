import { Instruccion } from "../Instruccion";


export class ListaInstruccion extends Array<Instruccion> {

    public agregar(instruccion:Instruccion){
        this.push(instruccion);
    }

    public agregarGrupo(instrucciones:Array<Instruccion>){
        this.push.apply(this,instrucciones);
    }

}
