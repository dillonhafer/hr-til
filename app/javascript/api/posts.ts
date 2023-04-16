import { post } from "api";

export const preview = (body: string): Promise<string> => {
	return post(
		"/post_preview",
		{
			body,
		},
		{ Accept: "text/html" }
	).then((r) => r.response.text());
};
