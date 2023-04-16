import { Controller } from "@hotwired/stimulus";
import { preview } from "api/posts";

export default class extends Controller {
	static targets = ["body", "title", "wordCount"];

	declare bodyTarget: HTMLElement;
	declare titleTarget: HTMLElement;
	declare wordCountTarget: HTMLElement;

	renderMarkdown = (e: Event) => {
		const form = e.currentTarget as HTMLFormElement;
		const title =
			form.querySelector<HTMLInputElement>("#post_title")?.value ?? "";
		const body =
			form.querySelector<HTMLInputElement>("#post_body")?.value ?? "";
		const wordCount = String(body.split(/\s+|\n/).filter(Boolean).length);

		preview(body).then((html) => {
			this.bodyTarget.innerHTML = html;
			this.titleTarget.innerText = title;
			this.wordCountTarget.innerText = wordCount;
		});
	};
}
