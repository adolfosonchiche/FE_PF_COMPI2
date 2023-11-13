import { Instruccion } from "../Instruccion";

export class IncDec implements Instruccion {

    tipo: string = "IncDec";
    instrucciones!: Array<Instruccion>;

    constructor(private id:string,private opr:string){}

}
