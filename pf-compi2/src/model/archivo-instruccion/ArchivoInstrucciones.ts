import { ListaInstruccion } from "../instruccion/structure/ListaInstruccion";
import { PilaInstruccion } from "../instruccion/structure/PilaInstruccion";

export class ArchivoInstrucciones {

    private pilaInstruccion:PilaInstruccion;
    private listaInstruccion:ListaInstruccion;

    constructor(private id:string){
        this.listaInstruccion = new ListaInstruccion();
        this.pilaInstruccion = new PilaInstruccion(this.listaInstruccion);
    }

    public getId():string{
        return this.id;
    }

    public getPila():PilaInstruccion{
        return this.pilaInstruccion;
    }

    public getInstrucciones():ListaInstruccion{
        return this.listaInstruccion;
    }


}
