import type { PageServerLoad } from "./$types";
import { prisma } from "$lib/prisma.server";

export const load: PageServerLoad = async ({ params }) => {
  const shader = await prisma.shader.findUniqueOrThrow({
    where: {
      id: params.id,
    },
    include: {
      user: true,
    },
  });
  return {
    shader,
  };
};
