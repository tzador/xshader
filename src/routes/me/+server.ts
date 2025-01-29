import { auth } from "$lib/auth.server";
import { redirect } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async ({ request }) => {
  const session = await auth.api.getSession({
    headers: request.headers,
  });
  if (!session) {
    throw redirect(302, "/");
  }

  throw redirect(302, "/@" + session.user.username);
};
