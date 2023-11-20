import { DoWhile } from "../cycle/DoWhile";
import { Case } from "../conditional/Case";
import { Default } from "../conditional/Default";
import { Else } from "../conditional/Else";
import { ElseIf } from "../conditional/ElseIf";
import { If } from "../conditional/If";
import { Switch } from "../conditional/Switch";
import { Instruccion } from "../Instruccion";
import { ListaInstruccion } from "./ListaInstruccion";

export class PilaInstruccion extends Array<Instruccion>{

    private auxIf:Array<If>;
    private auxSwitch:Array<Switch>;

    constructor(private listaPrincipal:ListaInstruccion){
        super();
        this.auxIf = new Array();
        this.auxSwitch = new Array();
    }

    public apilarDirecto(instruccion:Instruccion){
        this.listaPrincipal.agregar(instruccion);
    }

    public apilarGrupoDirecto(instrucciones:Array<Instruccion>){
        this.listaPrincipal.agregarGrupo(instrucciones);
    }

    public apilar(instruccion:Instruccion){
        try{
            if(this.length){
                if(
                    instruccion.tipo!="ElseIf" &&
                    instruccion.tipo!="Else" &&
                    instruccion.tipo!="Case" &&
                    instruccion.tipo!="Default" &&
                    instruccion.tipo!="Break" &&
                    instruccion.tipo!="Clase"
                ){
                    this.ultimo().instrucciones.push(instruccion);
                }

                if(
                    instruccion.tipo=="Metodo" ||
                    instruccion.tipo=="Clase" ||
                    instruccion.tipo=="If" ||
                    instruccion.tipo=="ElseIf" ||
                    instruccion.tipo=="Else" ||
                    instruccion.tipo=="For" ||
                    instruccion.tipo=="While" ||
                    instruccion.tipo=="DoWhile" ||
                    instruccion.tipo=="Switch" ||
                    instruccion.tipo=="Case" ||
                    instruccion.tipo=="Default" ||
                    instruccion.tipo == "Print"
                ){
                    this.push(instruccion);
                }
                this.filtroIns(instruccion);
            }else{
                if(instruccion.tipo=="Metodo" || instruccion.tipo=="Clase"){
                    this.push(instruccion);
                }
                this.listaPrincipal.agregar(instruccion);
            }
        }catch(e){
            console.log(e);
        }
    }

    public sacar():void{
        try{
            let ins = this.pop();
            if(ins?.tipo=="If"){
                this.auxIf.pop();
            }else if(ins?.tipo=="Switch"){
                this.auxSwitch.pop();
            }
        }catch(e){
            console.log(e);
        }
    }

    public sacarDoWhile(condicion:Instruccion):void{
        try{
            let ins = this.pop() as DoWhile;
            ins.setCondicion(condicion);
        }catch(e){
            console.log(e);
        }
    }

    private filtroIns(instruccion:Instruccion){
        if(instruccion.tipo=="If"){
            this.auxIf.push(instruccion as If);
        }else if(instruccion.tipo=="ElseIf"){
            this.ultimoIf().instruccionesElseIf.push(instruccion as ElseIf);
        }else if(instruccion.tipo=="Else"){
            this.ultimoIf().instruccionElse = instruccion as Else;
        }else if(instruccion.tipo=="Switch"){
            this.auxSwitch.push(instruccion as Switch);
        }else if(instruccion.tipo=="Case"){
            this.ultimoSwitch().casos.push(instruccion as Case);
        }else if(instruccion.tipo=="Default"){
            this.ultimoSwitch().casoDefault = instruccion as Default;
        }else if(instruccion.tipo=="Break"){
            if(this.ultimo().tipo=="Case"){
                (this.ultimo() as Case).setBreak();
            }else if(this.ultimo().tipo=="Case"){
                (this.ultimo() as Default).setBreak();
            }else{
                this.ultimo().instrucciones.push(instruccion);
            }
        }
    }

    private ultimo():Instruccion{
        return this[this.length-1];
    }

    private ultimoIf():If{
        return this.auxIf[this.auxIf.length-1];
    }

    private ultimoSwitch():Switch{
        return this.auxSwitch[this.auxSwitch.length-1];
    }

}
