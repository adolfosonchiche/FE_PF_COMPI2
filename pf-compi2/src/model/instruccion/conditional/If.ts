import { Instruccion } from "../Instruccion";
import { Else } from "./Else";
import { ElseIf } from "./ElseIf";

export class If implements Instruccion{

    tipo: string = "If";
    instrucciones:Array<Instruccion>;
    instruccionesElseIf:Array<ElseIf>;
    instruccionElse!:Else;

    constructor(
        private condicion:Instruccion
    ){
        this.instrucciones = new Array();
        this.instruccionesElseIf = new Array();
    }

}
