import { Instruccion } from "../Instruccion";

export class While implements Instruccion{

    tipo: string = "While";
    instrucciones: Array<Instruccion>;

    constructor(
        private condicion:Instruccion
    ){
        this.instrucciones = new Array();
    }

}
