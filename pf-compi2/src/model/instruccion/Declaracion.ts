import { Instruccion } from "./Instruccion";

export class Declaracion implements Instruccion{

    tipo: string = "Declaracion";
    instrucciones!:Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion
    ){
    }


}
