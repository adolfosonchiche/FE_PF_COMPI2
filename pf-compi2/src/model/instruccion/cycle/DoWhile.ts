import { Instruccion } from "../Instruccion";

export class DoWhile implements Instruccion{

    tipo: string = "DoWhile";
    instrucciones: Array<Instruccion>;

    constructor(private condicion:Instruccion){
        this.instrucciones = new Array();
    }

    public setCondicion(condicion:Instruccion):void{
        this.condicion = condicion;
    }

}
