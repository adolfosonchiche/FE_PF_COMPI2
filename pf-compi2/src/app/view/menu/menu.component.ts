import { Component } from '@angular/core';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})
export class MenuComponent {

  selectedOption!: number;

  imgClick(img: number) {

		switch (img) {
			case 0:
        this.selectedOption = 0;
				break;
			case 1:
        this.selectedOption = 1;
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
	}


}
