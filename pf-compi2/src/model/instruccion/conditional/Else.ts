import { Instruccion } from "../Instruccion";

export class Else implements Instruccion {

    tipo: string = "Else";
    instrucciones: Array<Instruccion>;

    constructor(){
        this.instrucciones = new Array();
    }

}
