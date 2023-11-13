import { Instruccion } from "../Instruccion";

export class Return implements Instruccion {

  tipo: string = "Return";
    instrucciones!: Instruccion[];

}
