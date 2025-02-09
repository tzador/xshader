import { auth } from "$lib/auth.server";
import { redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ request }) => {
  const session = await auth.api.getSession({ headers: request.headers });
  if (!session) {
    const r = await auth.api.signInSocial({
      body: {
        provider: "github",
        callbackURL: "/create",
      },
    });
    throw redirect(302, r.url ?? "/");
  }
};
