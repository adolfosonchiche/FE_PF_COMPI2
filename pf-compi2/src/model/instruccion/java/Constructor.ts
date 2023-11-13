import { Instruccion } from "../Instruccion";

export class Constructor implements Instruccion{

    tipo: string = "Constructor";
    instrucciones!: Instruccion[];

    constructor(private nombre:string){
    }

    public getNombre(){
        return this.nombre;
    }

}
