import type { PageServerLoad } from "./$types";
import { prisma } from "$lib/prisma.server";

export const load: PageServerLoad = async () => {
  const shaders = await prisma.shader.findMany({
    select: {
      id: true,
      name: true,
      source: true,
      user: {
        select: {
          username: true,
          image: true,
        },
      },
    },
    orderBy: {
      id: "desc",
    },
  });
  return {
    shaders,
  };
};
