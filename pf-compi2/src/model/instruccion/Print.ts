import { Instruccion } from "./Instruccion";

export class Print implements Instruccion{

    tipo:string = "Print";
    instrucciones!:Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion
    ){ }

}
