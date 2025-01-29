import type { PageServerLoad } from "./$types";
import { prisma } from "$lib/prisma.server";
import { error } from "@sveltejs/kit";
import { auth } from "$lib/auth.server";
export const load: PageServerLoad = async ({ params, request }) => {
  const shader = await prisma.shader.findUniqueOrThrow({
    where: {
      id: parseInt(params.id),
    },
    include: {
      user: true,
    },
  });
  if (!shader) {
    throw error(404, "Shader not found");
  }

  const session = await auth.api.getSession({
    headers: request.headers,
  });

  const user = session?.user;
  const mine = user?.id === shader.userId;

  return {
    shader,
    user,
    mine,
  };
};
