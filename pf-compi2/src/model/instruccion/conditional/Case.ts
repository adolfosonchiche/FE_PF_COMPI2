import { Instruccion } from "../Instruccion";

export class Case implements Instruccion{

    tipo: string = "Case";
    instrucciones: Array<Instruccion>;
    contieneBreak:boolean = false;

    constructor(private variable:Instruccion){
        this.instrucciones = new Array();
    }

    public setBreak(){
        this.contieneBreak = true;
    }

}
