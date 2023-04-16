declare module "@rails/request.js" {
	interface R extends Response {
		response: {
			json<T>(): Promise<T>;
			text(): Promise<string>;
		};
	}
	declare function post(path: string, init?: RequestInit): Promise<R>;
	declare function put(path: string, init?: RequestInit): Promise<R>;
	declare function destroy(path: string, init?: RequestInit): Promise<R>;
}
