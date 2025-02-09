import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";
import raw from "vite-raw-plugin";

export default defineConfig({
  plugins: [
    sveltekit(),
    raw({
      fileRegex: /(\.html|\.glsl)$/,
    }),
  ],
  resolve: {
    extensions: [".svelte", ".ts", ".js", ".json", ".html", ".glsl"],
  },
});
