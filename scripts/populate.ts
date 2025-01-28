#!/usr/bin/env pnpm vite-node scripts/populate.ts
import fs from "fs";
import { prisma } from "../src/lib/prisma.server";

await prisma.shader.deleteMany();

const user = await prisma.user.findFirstOrThrow({
  where: {
    login: "tzador",
  },
});

for (const dir of ["chatgpt", "chatgpt2"]) {
  for (const file of fs.readdirSync(`./scripts/generated/${dir}`)) {
    if (!file.endsWith(".glsl")) continue;
    const shader = await prisma.shader.create({
      data: {
        title: dir + "/" + file,
        source: fs.readFileSync(`./scripts/generated/${dir}/${file}`, "utf-8"),
        userId: user.id,
      },
    });
    console.log(shader.id);
  }
}
