import { createAuthClient } from "better-auth/svelte";
import { PUBLIC_BETTER_AUTH_URL } from "$env/static/public";

export const authClient = createAuthClient({
  baseURL: PUBLIC_BETTER_AUTH_URL,
});

export const signIn = async (next: string = "/me") => {
  await authClient.signIn.social({
    provider: "github",
    callbackURL: next,
  });
};

export const signOut = async () => {
  await authClient.signOut();
};
