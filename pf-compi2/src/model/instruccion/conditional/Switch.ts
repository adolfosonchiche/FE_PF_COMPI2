import { Instruccion } from "../Instruccion";
import { Case } from "./Case";
import { Default } from "./Default";

export class Switch implements Instruccion{

    tipo: string = "Switch";
    instrucciones!: Array<Instruccion>;
    casos:Array<Case>;
    casoDefault!:Default;

    constructor(private variable:Instruccion){
        this.casos = new Array();
    }

    public setDefault(casoDefault:Default){
        this.casoDefault = casoDefault;
    }

}
