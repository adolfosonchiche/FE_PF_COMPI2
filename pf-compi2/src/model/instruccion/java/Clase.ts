import { Instruccion } from "../Instruccion";

export class Clase implements Instruccion{

    tipo: string = "Clase";
    instrucciones: Array<Instruccion>;

    constructor(private nombre:string){
        this.instrucciones = new Array();
    }

    public getNombre():string{
        return this.nombre;
    }

}
