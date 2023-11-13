export class Archivo {

  public nombre:string;
  public paquete:string;
  public codigo:string;
  public id:string;

  constructor(nombre:string,id:string,paquete:string,codigo:string){
      this.nombre = nombre;
      this.id = id;
      this.paquete = paquete;
      this.codigo = codigo;
  }

}
