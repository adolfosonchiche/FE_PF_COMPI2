import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environments';
//import { Confirmacion } from 'src/model/Confirmacion';
import { Proyecto } from 'src/model/file/Proyecto';

@Injectable({
  providedIn: 'root'
})
export class ProyectoService {

  private urlProyecto:string = environment.compi2Url + "/archivo";

  constructor(private httpClient:HttpClient) { }

  public getProyectos(){
    return this.httpClient.get<Array<string>>(`${this.urlProyecto}/proyectos`);
  }

  public getProyecto(nombre:string){
    return this.httpClient.get<Proyecto>(`${this.urlProyecto}/proyecto/${nombre}`);
  }

  public enviarProyecto(proyecto:Proyecto){
    return this.httpClient.post<any>(`${this.urlProyecto}/create`,proyecto);
  }

}
