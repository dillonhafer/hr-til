import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static classes = ["view"];
	static targets = ["view"];

	declare viewTarget: HTMLElement;
	declare viewClass: string;

	toggle(e: Event) {
		e.preventDefault();
		this.viewTarget.classList.toggle(this.viewClass);
	}
}
