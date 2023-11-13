import { Instruccion } from "./Instruccion";

export class Operacion implements Instruccion{

    tipo:string = "Operacion";
    instrucciones!:Array<Instruccion>;

    constructor(
        private opr1:Instruccion,
        private opr2:Instruccion,
        private opr:string,
        private resultado:any
    ){

    }

}
