import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { environment } from "src/environments/environments";
import { ListaInstruccion } from "src/model/instruccion/structure/ListaInstruccion";

@Injectable({
  providedIn: 'root'
})
export class Codigo3dService {

  private baseUrl:string = environment.compi2Url + "/parser";

  constructor(
    private httpClient:HttpClient
  ) { }


  public generateThreeAddressCode(instrucciones:ListaInstruccion){
    return this.httpClient.post<any>(`${this.baseUrl}/c3d`, instrucciones);
  }

}
