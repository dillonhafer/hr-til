import { Controller } from "@hotwired/stimulus";

const pluralize = (
	amount: number,
	singular: string,
	plural: string
): string => {
	return `${amount} ${amount === 1 ? singular : plural}`;
};

export default class extends Controller {
	static targets = ["characterLimitMessage", "wordLimitMessage"];

	declare characterLimitMessageTarget: HTMLElement;
	declare wordLimitMessageTarget: HTMLElement;

	#updateWords = (el: HTMLElement, word: string, inputLength: number) => {
		const limit = Number(el.dataset.limit);
		const available = limit - inputLength;

		el.innerText = pluralize(available, word, word + "s") + " available";

		if (available < 0) {
			el.classList.add("text-red");
		} else {
			el.classList.remove("text-red");
		}
	};

	updateWordsAvailable = (e: Event) => {
		const input = e.currentTarget as HTMLInputElement;
		this.#updateWords(
			this.wordLimitMessageTarget,
			"word",
			input.value.split(/\s+|\n/).filter(Boolean).length
		);
	};

	updateCharactersAvailable = (e: Event) => {
		const input = e.currentTarget as HTMLInputElement;
		this.#updateWords(
			this.characterLimitMessageTarget,
			"character",
			input.value.length
		);
	};
}
