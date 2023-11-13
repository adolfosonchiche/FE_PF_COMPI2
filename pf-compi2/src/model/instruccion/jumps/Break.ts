import { Instruccion } from "../Instruccion";

export class Break implements Instruccion{

    tipo: string = "Break";
    instrucciones!: Instruccion[];

}
