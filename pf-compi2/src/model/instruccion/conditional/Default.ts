import { Instruccion } from "../Instruccion";

export class Default implements Instruccion{

    tipo: string = "Default";
    instrucciones: Array<Instruccion>;
    contieneBreak:boolean = false;

    constructor(){
        this.instrucciones = new Array();
    }

    public setBreak(){
        this.contieneBreak = true;
    }

}
