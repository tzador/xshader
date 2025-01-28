import { json } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";
import fs from "fs";

export const DELETE: RequestHandler = async ({ request }) => {
  const { path } = await request.json();

  fs.rmSync(`./scripts/generated/${path}`);

  return json({ success: true });
};
