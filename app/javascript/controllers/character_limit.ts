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

	updateWordsAvailable = (e: Event) => {
		const input = e.currentTarget as HTMLInputElement;
		const limit = Number(this.wordLimitMessageTarget.dataset.limit);
		const available =
			limit - input.value.split(/\s+|\n/).filter(Boolean).length;

		this.wordLimitMessageTarget.innerText =
			pluralize(available, "word", "words") + " available";

		if (available < 0) {
			this.wordLimitMessageTarget.classList.add("text-red");
		} else {
			this.wordLimitMessageTarget.classList.remove("text-red");
		}
	};

	updateCharactersAvailable = (e: Event) => {
		const input = e.currentTarget as HTMLInputElement;
		const limit = Number(this.characterLimitMessageTarget.dataset.limit);
		const available = limit - input.value.length;

		this.characterLimitMessageTarget.innerText =
			pluralize(available, "character", "characters") + " available";

		if (available < 0) {
			this.characterLimitMessageTarget.classList.add("text-red");
		} else {
			this.characterLimitMessageTarget.classList.remove("text-red");
		}
	};
}
