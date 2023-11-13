import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ProyectoService } from 'src/app/services/proyecto.servicio';
import { Proyecto } from 'src/model/file/Proyecto';

@Component({
  selector: 'app-project',
  templateUrl: './project.component.html',
  styleUrls: ['./project.component.scss']
})

export class ProjectComponent implements OnInit {


  proyectos!:Array<string>;

  constructor(
    private servicioProyecto:ProyectoService,
    private router:Router
    ) {  console.log('t a odts') }

  ngOnInit(): void {
    this.actualizarProyectos();
  }

  private actualizarProyectos():void{
    this.servicioProyecto.getProyectos().subscribe( data => {
      this.proyectos = data;
    },
    err => {
      console.log('error', err)
    }
    );
  }

  public abrirProyecto(nombre:string):void{
    console.log(nombre  + '  --> fts')
    localStorage.setItem('proyecto',nombre);
    this.router.navigate(["home"]);
  }

}
