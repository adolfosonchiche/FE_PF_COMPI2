//import { GestionadorPaquete } from "src/resources/utilidades/proyecto/GestionadorPaquete";
import { Paquete } from "./Paquete";

export class Proyecto{

    public nombre:string;
    public paquetePrincipal:Paquete;


    constructor(nombre:string){
        this.nombre = nombre;
        this.paquetePrincipal = new Paquete(this.nombre,this.nombre);
    }

}
