import type { RequestHandler } from "./$types";
import { auth } from "$lib/auth.server";
import { error, redirect } from "@sveltejs/kit";
import { prisma } from "$lib/prisma.server";

export const GET: RequestHandler = async ({ request }) => {
  const session = await auth.api.getSession({
    headers: request.headers,
  });
  if (!session) {
    throw error(401, "Unauthorized");
  }

  // TODO: throttle creation of shaders per user
  const shader = await prisma.shader.create({
    data: {
      name: "",
      userId: session.user.id,
      source: "",
      published: false,
    },
  });

  throw redirect(302, "/" + shader.id);
};
