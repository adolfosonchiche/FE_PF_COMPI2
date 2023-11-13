import { Injectable } from "@angular/core";
import { environment } from "src/environments/environments";
import {HttpClient} from "@angular/common/http";
import { Observable } from "rxjs";

const baseUrl = environment.compi2Url;

@Injectable({
  providedIn: 'root'
})
export class DemoService {

  constructor (
    private http:HttpClient
  ) {
  }

  getDate(): Observable<any>{
    return this.http.get<any>(`${baseUrl}/hello`);
  }


}
