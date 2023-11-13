import { HttpClient } from '@angular/common/http';
import { AfterViewInit, ChangeDetectorRef, Component, ElementRef, OnInit, Output, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { DemoService } from 'src/app/services/demo.service';
import { ProyectoService } from 'src/app/services/proyecto.servicio';
import { Archivo } from 'src/model/file/Archivo';
import { Proyecto } from 'src/model/file/Proyecto';
import { GestionadorPaquete } from 'src/resources/proyecto/GestionadorPaquetes';
import * as $ from 'jquery'; import 'jstree';
import * as ace from "ace-builds";
import { ListaInstruccion } from 'src/model/instruccion/structure/ListaInstruccion';
import { ControladorAnalisis } from 'src/app/controller/ControladorAnalisis';
import { Codigo3dService } from 'src/app/services/codigo3d.service';

@Component({
  selector: 'app-home-ide',
  templateUrl: './home-ide.component.html',
  styleUrls: ['./home-ide.component.scss']
})
export class HomeIdeComponent implements OnInit, AfterViewInit {

  title = 'pf-compi2';
  texto: any;
  linea: number = 1;
  columna: number = 1;
  /* editorOptions = { theme: 'vs-dark', language: 'javascript' };*/
  // @ViewChild('codeEditor') codeEditor: ElementRef;
  // @ViewChild('codeEditor', { static: true }) codeEditor!: ElementRef; // Usar '!' para evitar el error


  @ViewChild('editor') private editor!: ElementRef<HTMLElement>;

  selectedOption: number = 0;
  txtConsola: String = "";
  private analizador = new ControladorAnalisis();
  idArchivo: string = "";
  idPaquete: string = "";
  nombreProyecto: string = "";
  textoInfo: string = "";
  gestionadorPaquete!: GestionadorPaquete;
  codigoPrincipal = "";
  archivoActual!: Archivo | null;
  proyecto!: Proyecto | null;
  codigo3d = "";
  listaInstruccion!: ListaInstruccion;
  cod3dDeshabilitado = true;
  compilarDeshabilitado = true;

  constructor(
    private demoService: DemoService,
    private elRef: ElementRef,
    private http: HttpClient,
    private servicioProyecto: ProyectoService,
    private router: Router,
    private cdr: ChangeDetectorRef,
    private codigo3dSerivice: Codigo3dService,
  ) {
    this.selectedOption = 0;
    this.gestionadorPaquete = new GestionadorPaquete();

    //verificar si se ha seleccionado un proyecto
    const proy = localStorage.getItem('proyecto');
    if (proy != null && proy != "null") {
      servicioProyecto.getProyecto(proy).subscribe(data => {
        this.proyecto = data;
        this.compilarDeshabilitado = false;
      });
      localStorage.setItem('proyecto', 'null');
    }
  }

  ngOnInit(): void {
    this.selectedOption = 0;
    /*$(function () {
      $('#jstree').jstree();
      $('#jstree').on("changed.jstree", function (e, data) {
        console.log(data.selected);
      });
    });*/
    this.expandir();
    //this.ngAfterViewInit();
  }

  //editor de codigo
  ngAfterViewInit() {
    ace.config.set("fontSize", "25px");
    ace.config.set('basePath', 'https://unpkg.com/ace-builds@1.4.12/src-noconflict');

    const aceEditor = ace.edit(this.editor.nativeElement);
    aceEditor.session.selection.on('changeCursor', () => {
      this.linea = aceEditor.getCursorPosition().row + 1;
      this.columna = aceEditor.getCursorPosition().column + 1;
    });

    aceEditor.setTheme('ace/theme/xcode');
    aceEditor.session.setMode('ace/mode/java');
    aceEditor.session.setUseSoftTabs(false);
  }

  public getLinea() {
    return this.linea;
  }

  public getColumna() {
    return this.columna;
  }

  public getTxtConsola() {
    return this.txtConsola;
  }


  getData() {
    console.log('TAFST')
    this.demoService.getDate().subscribe(
      result => {
        console.log(result)
      }
    );
  }


  imgClick(img: number) {
    switch (img) {
      case 0:
        this.selectedOption = 0;
        //this.cdr.detectChanges();

        break;
      case 1:
        this.selectedOption = 1;
        //this.cdr.detectChanges();

        break;
      case 2:
        this.selectedOption = 1;
        break;
      case 3:
        this.selectedOption = 1;
        break;
      case 4:
        this.selectedOption = 1;
        break;
      default:
        break;
    }
    //this.guardarProyectoSinAviso();
    //this.ngAfterViewInit();
    //console.log(this.editor)
  }

  //parsear(){}
  public parsear() {
    this.txtConsola = 'compilando';
    this.codigo3d = '';
    this.guardarProyectoSinAviso();
    this.listaInstruccion = new ListaInstruccion();
    console.clear();

    if (this.proyecto) {
      this.txtConsola = this.analizador.nuevoanalizar(this.proyecto, this.listaInstruccion);
      if (this.txtConsola == "Compilación exitosa.") {
        console.log(this.listaInstruccion);
        this.codigo3dSerivice.generateThreeAddressCode(this.listaInstruccion).subscribe(data => {
          this.codigo3d = data.codigo3d.codigo;
          console.log(data)
        },
        err => {
          console.log(err)
        });
        this.cod3dDeshabilitado = false;
      } else {
        this.cod3dDeshabilitado = true;
      }
    }
  }


  //manejo de proyectos
  expandir(): void {
    $('.expand').click(function () {
      $('ul', $(this).parent()).eq(0).toggle();
    });
  }

  public actualizarCodigoEditor(id: string): void {
    console.log('t a fots')
    this.guardarCambios();
    if (this.proyecto) {
      let archivo = this.gestionadorPaquete.buscarArchivo(id, this.proyecto);
      if (archivo != null) {
        const aceEditor = ace.edit(this.editor.nativeElement);
        aceEditor.session.setValue(archivo.codigo);
        this.archivoActual = archivo;
      }
    }

  }

  public guardarCambios(): void {
    if (this.archivoActual != null) {
      const aceEditor = ace.edit(this.editor.nativeElement);
      this.archivoActual.codigo = aceEditor.getValue();
    }
  }

  public crearArchivo(): void {
    if (this.idValido(this.idArchivo) && this.proyecto) {
      console.log('creando archivo dentro del proyecto')
      this.gestionadorPaquete.nuevoArchivo(this.idArchivo, this.proyecto, "");
      this.idArchivo = "";
    } else {
      this.idArchivo = "";
    }
  }

  public crearPaquete(): void {
    if (this.idValido(this.idPaquete) && this.proyecto) {
      this.gestionadorPaquete.crearPaquete(this.idPaquete, this.proyecto);
      this.idPaquete = "";
    } else {
      this.idPaquete = "";
    }
  }

  private idValido(id: string): boolean {
    return /^([a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*)$/.test(id);
  }

  public crearProyecto(): void {
    this.proyecto = new Proyecto(this.nombreProyecto);
    this.nombreProyecto = "";
    this.compilarDeshabilitado = false;
  }

  public guardarProyectoSinAviso(): void {
    this.guardarCambios();
    if (this.proyecto != null) {
      this.servicioProyecto.enviarProyecto(this.proyecto).subscribe(data => { });
    }
  }

  public cerrarProyecto(): void {
    if (this.proyecto != null) {
      this.guardarProyectoSinAviso();
      this.proyecto = null;
      this.compilarDeshabilitado = true;
      const aceEditor = ace.edit(this.editor.nativeElement);
      aceEditor.session.setValue('');
      this.archivoActual = null;
      this.txtConsola = '';
    }
  }

  public guardarProyecto(): void {
    this.guardarCambios();
    if (this.proyecto != null) {
      this.servicioProyecto.enviarProyecto(this.proyecto).subscribe(data => {
        this.textoInfo = data.descripcion;
        //document.getElementById("abrirModalInfo").click();
      },
        err => {
          console.log('error ', err)
        });
    }
  }

  public mostrarProyectos() {
    console.log('fo')
    this.router.navigate(['/project']);
  }

}
