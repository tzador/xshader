import { auth } from "$lib/auth.server";
import { prisma } from "$lib/prisma.server";
import { error } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const POST: RequestHandler = async ({ request }) => {
  const session = await auth.api.getSession({ headers: request.headers });
  if (!session) {
    throw error(401, "Unauthorized");
  }

  const body = await request.json();
  const { name, source } = body;
  if (!name || !source) {
    throw error(400, "Invalid request");
  }

  // TODO: throttle creation of shaders per user
  const shader = await prisma.shader.create({
    data: {
      name,
      userId: session.user.id,
      source,
    },
  });

  return Response.json({ id: shader.id });
};
