import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	connect(): void {
		const bg = window.getCookie("bg-color");
		if (bg.length) {
			document.body.style.backgroundColor = bg;
		}

		let presses: string[] = [];
		document.addEventListener("keydown", function (e: KeyboardEvent) {
			const colorz = "e,a,s,t,e,r";
			presses.push(e.key);
			if (presses.toString().indexOf(colorz) >= 0) {
				presses = [];
				var colors = [
					"#D5E9F5",
					"#F5E0D6",
					"#F5D6D6",
					"#F5EBD6",
					"#F5D6E8",
					"#E8F5D6",
					"#F2D6F5",
					"#D9F5D6",
					"#D6DBF5",
					"#D6F5F5",
					"#D6E3F5",
					"#D6DEF5",
					"#D6D9F5",
					"#D6D6F5",
				];

				const randomColor = colors[Math.floor(Math.random() * colors.length)];
				document.body.style.backgroundColor = randomColor;
				window.setCookie("bg-color", randomColor);
			}
		});
	}
}
