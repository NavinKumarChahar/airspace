export default {
    async fetch(request, env, ctx): Promise<Response> {
        const url = new URL(request.url);

        // Home
        if (url.pathname === "/") {
            return new Response("Hello from AsathesCumIRoofantal! 🚀", {
                status: 200,
                headers: { "Content-Type": "text/plain" },
            });
        }

        // API
        if (url.pathname === "/api") {
            return Response.json({
                app: "AsathesCumIRoofantal",
                version: "1.0.0",
                status: "ok",
            });
        }

        // Health check
        if (url.pathname === "/health") {
            return Response.json({ status: "healthy" });
        }

        // 404
        return new Response("Not Found", { status: 404 });
    },
} satisfies ExportedHandler<Env>;
