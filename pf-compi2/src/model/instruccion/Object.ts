import { Instruccion } from "./Instruccion";

export class Object implements Instruccion{

    tipo:string = "Object";
    instrucciones!:Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion
    ){ }

}
