import { post as _post, destroy as _destroy } from "@rails/request.js";

export function post(url = "", body = {}, headers = {}) {
	return _post(url, {
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json",
			...headers,
		},
		credentials: "same-origin",
		body: JSON.stringify(body),
	});
}

export function destroy(url = "", body = {}, headers = {}) {
	return _destroy(url, {
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json",
			...headers,
		},
		credentials: "same-origin",
		body: JSON.stringify(body),
		redirect: "manual",
	});
}
