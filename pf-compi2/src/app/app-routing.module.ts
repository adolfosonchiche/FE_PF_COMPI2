import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppComponent } from './app.component';
import { ProjectComponent } from './view/project/project.component';
import { HomeIdeComponent } from './view/home-ide/home-ide.component';

const routes: Routes = [
  { path:'home', component: HomeIdeComponent },
  { path:'project', component:ProjectComponent},
  //{ path: }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
