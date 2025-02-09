import { createAuthClient } from "better-auth/svelte";
import { PUBLIC_BETTER_AUTH_URL } from "$env/static/public";
import { goto } from "$app/navigation";

export const authClient = createAuthClient({
  baseURL: PUBLIC_BETTER_AUTH_URL,
});

export const signIn = async (next: string = "/") => {
  await authClient.signIn.social({
    provider: "github",
    callbackURL: next,
  });
};

export const signOut = async () => {
  await authClient.signOut();
  await goto("/");
};
