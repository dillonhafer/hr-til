import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	setHeight(e: Event) {
		this.#setHeight(e.currentTarget as HTMLTextAreaElement);
	}

	#setHeight(textArea: HTMLTextAreaElement) {
		const newHeight = Math.max(textArea.scrollHeight, 100);
		textArea.setAttribute("style", "height: 0px");
		textArea.setAttribute("style", "height:" + newHeight + "px;");
	}

	connect() {
		this.#setHeight(this.element as HTMLTextAreaElement);
	}
}
