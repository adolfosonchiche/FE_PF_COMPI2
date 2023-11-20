import { Instruccion } from "../Instruccion";

export class Return implements Instruccion{

    tipo:string = "Return";
    instrucciones!:Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion
    ){ }

}
