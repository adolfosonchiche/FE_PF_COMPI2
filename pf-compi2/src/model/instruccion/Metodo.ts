import { Instruccion } from "./Instruccion";

export class Metodo implements Instruccion{

    tipo: string = "Metodo";
    instrucciones!: Array<Instruccion>;

    constructor(
        private nombre:string
    ){
        this.instrucciones = new Array();
    }

}
