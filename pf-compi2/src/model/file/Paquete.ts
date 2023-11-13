import { Archivo } from "./Archivo";

export class Paquete {

    public nombre:string;
    public id:string;
    public archivos:Array<Archivo>;
    public paquetes:Array<Paquete>;

    constructor(nombre:string,id:string){
        this.nombre = nombre;
        this.id = id;
        this.archivos = new Array();
        this.paquetes = new Array();
    }

}
