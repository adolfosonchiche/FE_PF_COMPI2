import { Archivo } from "src/model/file/Archivo";
import { Paquete } from "src/model/file/Paquete";
import { Proyecto } from "src/model/file/Proyecto";

export class GestionadorPaquete{

    public nuevoArchivo(id:string,proyecto:Proyecto,codigo:string){
        let nombres:Array<string> = id.split('.');
        let nombreArchivo = nombres.pop();
        let nombrePaquete = nombres.join('.');

        if(nombreArchivo) {
          if(nombres.length==0){
            console.log(proyecto.paquetePrincipal.nombre);
            proyecto.paquetePrincipal.archivos.push(new Archivo(nombreArchivo,id,proyecto.paquetePrincipal.nombre,codigo));
        }else{
            let paquete = this.crearPaquete(nombrePaquete,proyecto);
            paquete.archivos.push(new Archivo(nombreArchivo,id,paquete.nombre,codigo));
        }
        }
    }

    public guardarCambiosArchivo(nombre:string,proyecto:Proyecto,codigo:string){
        let archivo = this.buscarArchivo(nombre,proyecto);
    }

    public buscarArchivo(id:string,proyecto:Proyecto){
        let nombres:Array<string> = id.split('.');
        let nombreArchivo = nombres.pop();
        let nombrePaquete = nombres.join('.');
        let paquete:Paquete | null
        if(nombrePaquete==""){
            paquete = proyecto.paquetePrincipal;
        }else{
            paquete = this.buscarPaquete(nombrePaquete,proyecto);
        }
        if(paquete==null){
            return null;
        }else{
            for (const i in paquete.archivos) {
                if(paquete.archivos[i].nombre==nombreArchivo){
                    return paquete.archivos[i];
                }
            }
            return null;
        }
    }

    public buscarPaquete(id:string,proyecto:Proyecto):Paquete | null{
        let nombres:Array<string> = id.split('.');
        let paquete:Paquete = proyecto.paquetePrincipal;
        if(nombres) {
          while(nombres.length){
            let paqueteTemp = this.buscarPaqueteEnLista(nombres.shift(),paquete.paquetes);
            if(paqueteTemp==null){
                nombres.unshift('WJAJ');
                break;
            }else{
                paquete = paqueteTemp;
            }
          }
        }

        if(nombres.length){
            return null;
        }else{
            return paquete;
        }
    }

    public crearPaquete(id:string,proyecto:Proyecto):Paquete{
        let nombres:Array<string> = id.split('.');
        let paquete:Paquete = proyecto.paquetePrincipal;
        let nombre:string | undefined;
        let nombreAcumulado:Array<string> = new Array();

        while(nombres.length){
            nombre = nombres.shift();
            let paqueteTemp = this.buscarPaqueteEnLista(nombre,paquete.paquetes);
            if(paqueteTemp==null && nombre){
                nombres.unshift(nombre);
                break;
            }else{
                if(nombre)
                  nombreAcumulado.push(nombre);
                if(paqueteTemp)
                  paquete = paqueteTemp;
            }
        }

        if(nombres.length){
            let nuevoPaquete:Paquete;
            while(nombres.length){
                nombreAcumulado.join('.')
                let nombreshift = nombres.shift();
                if(nombreshift){
                  nombreAcumulado.push(nombreshift);
                  nuevoPaquete = new Paquete(nombreshift,nombreAcumulado.join('.'));
                  paquete.paquetes.push(nuevoPaquete);
                  paquete = nuevoPaquete;
                }
            }
        }
        return paquete;
    }

    private buscarPaqueteEnLista(nombre:string | undefined,paquetes:Array<Paquete>):Paquete | null{
        for (const i in paquetes) {
            if(paquetes[i].nombre==nombre){
                return paquetes[i];
            }
        }
        return null;
    }

}
