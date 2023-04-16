import { Application } from "@hotwired/stimulus";
import view_toggle from "controllers/view_toggle";
import character_limit from "controllers/character_limit";
import post_preview from "controllers/post_preview";
import post_likes from "controllers/post_likes";
import easter from "controllers/easter";

declare global {
	interface Window {
		Stimulus: ReturnType<typeof Application.start>;
		getCookie(name: string): string;
		setCookie(name: string, value: string, date?: Date): void;
	}
}

window.setCookie = (name: string, val: string, date = new Date()) => {
	date.setTime(date.getTime() + 7 * 24 * 60 * 60 * 1000);
	document.cookie =
		name + "=" + val + "; expires=" + date.toUTCString() + "; path=/";
};

window.getCookie = (name: string): string => {
	const nameLenPlus = name.length + 1;
	return (
		document.cookie
			.split(";")
			.map((c) => c.trim())
			.filter((cookie) => {
				return cookie.substring(0, nameLenPlus) === `${name}=`;
			})
			.map((cookie) => {
				return decodeURIComponent(cookie.substring(nameLenPlus));
			})[0] || ""
	);
};

window.Stimulus = Application.start();
window.Stimulus.debug = !window.location.hostname.includes("til");

window.Stimulus.register("view-toggle", view_toggle);
window.Stimulus.register("character-limit", character_limit);
window.Stimulus.register("post-preview", post_preview);
window.Stimulus.register("easter", easter);
window.Stimulus.register("post-likes", post_likes);
