import { Application } from "@hotwired/stimulus";
import view_toggle from "controllers/view_toggle";
import character_limit from "controllers/character_limit";
import post_preview from "controllers/post_preview";

declare global {
	interface Window {
		Stimulus: ReturnType<typeof Application.start>;
	}
}

window.Stimulus = Application.start();
window.Stimulus.debug = !window.location.hostname.includes("til");

window.Stimulus.register("view-toggle", view_toggle);
window.Stimulus.register("character-limit", character_limit);
window.Stimulus.register("post-preview", post_preview);
