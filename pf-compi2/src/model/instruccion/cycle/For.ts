import { Instruccion } from "../Instruccion";

export class For implements Instruccion{
    tipo: string = "For";
    instrucciones: Array<Instruccion>;

    constructor(
        private accionInicial:Instruccion,
        private condicion:Instruccion,
        private accionPosterior:Instruccion
    ){
        this.instrucciones = new Array();
    }

}
