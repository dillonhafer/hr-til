import { post } from "api";

export const preview = (body: string): Promise<string> => {
	return post(
		"/posts/preview",
		{
			body,
		},
		{ Accept: "text/html" }
	).then((r) => r.response.text());
};
