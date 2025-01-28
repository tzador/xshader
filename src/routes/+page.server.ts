import type { PageServerLoad } from "./$types";
import { prisma } from "$lib/prisma.server";

export const load: PageServerLoad = async () => {
  const shaders = await prisma.shader.findMany({
    select: {
      id: true,
      title: true,
      source: true,
      user: {
        select: {
          name: true,
          login: true,
          image: true,
        },
      },
    },
    orderBy: {
      size: "asc",
    },
  });
  return {
    shaders,
  };
};
