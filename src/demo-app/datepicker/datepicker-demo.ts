import { Component } from '@angular/core';
import { FormControl } from '@angular/forms';

@Component({
  moduleId: module.id,
  selector: 'datepicker-demo',
  templateUrl: 'datepicker-demo.html',
  styleUrls: ['datepicker-demo.css'],
})
export class DatepickerDemo {
  isRequired = false;
  isDisabled = false;
  currentDrink: string;
  foodControl = new FormControl('');

  foods = [
    { value: 'steak-0', viewValue: 'Steak' },
    { value: 'pizza-1', viewValue: 'Pizza' },
    { value: 'tacos-2', viewValue: 'Tacos' }
  ];

  drinks = [
    { value: 'coke-0', viewValue: 'Coke' },
    { value: 'sprite-1', viewValue: 'Sprite', disabled: true },
    { value: 'water-2', viewValue: 'Water' }
  ];

  toggleDisabled() {
    this.foodControl.enabled ? this.foodControl.disable() : this.foodControl.enable();
  }

}
