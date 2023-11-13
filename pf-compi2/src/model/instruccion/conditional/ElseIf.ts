import { Instruccion } from "../Instruccion";

export class ElseIf implements Instruccion{

    tipo: string = "ElseIf";
    instrucciones: Array<Instruccion>;

    constructor(
        private condicion:Instruccion
    ){
        this.instrucciones = new Array();
    }

}
