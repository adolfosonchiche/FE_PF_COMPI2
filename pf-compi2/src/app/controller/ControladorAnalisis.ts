import { ArchivoInstrucciones } from 'src/model/archivo-instruccion/ArchivoInstrucciones';
import { ListaArchivoInstrucciones } from 'src/model/archivo-instruccion/ListaArchivoInstrucciones';
import { ListaInstruccion } from 'src/model/instruccion/structure/ListaInstruccion';
import { PilaInstruccion } from 'src/model/instruccion/structure/PilaInstruccion';
import { Archivo } from 'src/model/file/Archivo';
import { Proyecto } from 'src/model/file/Proyecto';
import { RecuperadorArchivos } from 'src/resources/proyecto/RecuperadorArchivos';
import * as Separador from '../../resources/analizador/separador/Separador'
import { ControladorAnalisisGeneral } from './ControladorAnalisisGeneral';

export class ControladorAnalisis{

    private analizadorGeneral:ControladorAnalisisGeneral;
    private recuperadorArchivos:RecuperadorArchivos;

    public constructor(){
        this.analizadorGeneral = new ControladorAnalisisGeneral();
        this.recuperadorArchivos = new RecuperadorArchivos();
    }

    public analizar(codigo:String, pila:PilaInstruccion, pilaJava:PilaInstruccion):String{

        let resultado:String = "codigos:\n";
        Separador.reset();
        Separador.parse(codigo);
        return this.analizadorGeneral.analizar(Separador,pila,pilaJava);

    }

    public nuevoanalizar(proyecto:Proyecto, instruccionesFinales:ListaInstruccion):string{
        let archivosJava:ListaArchivoInstrucciones = new ListaArchivoInstrucciones();

        let resultado:string = "";
        let archivos:Array<Archivo> = this.recuperadorArchivos.recuperar(proyecto);


        for(let i=0;i<archivos.length;i++){
          console.log('tt aa fst ...-->' + i)
            resultado += "";
            const code = '%' + '%'+ 'JAVA \n\n ' + archivos[i].codigo;
            Separador.reset();
            Separador.parse(code);

            //let txt = this.analizadorGeneral.analizar(Separador,pila,pilaJava);
            let archInsJava:ArchivoInstrucciones = new ArchivoInstrucciones(archivos[i].id);
            let txt:string = "";
            txt += this.analizadorGeneral.analizarCodigoJava(Separador,archInsJava.getPila());
            if(archInsJava.getInstrucciones().length){
                archivosJava.push(archInsJava);
            }
            //if(instruccionesFinales.length==0){
              instruccionesFinales.push.apply(instruccionesFinales,archInsJava.getInstrucciones());
            //}

            if(txt!=""){
                resultado += "Archivo: "+archivos[i].id+"\n";
                resultado += txt;
            }
        }


        if(resultado==""){
            return "Compilación exitosa.";
        }else{
            resultado = "Resultado:\n"+resultado;
            return resultado;
        }
    }

}
