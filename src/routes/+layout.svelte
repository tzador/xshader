<script lang="ts">
  import { authClient, signIn, signOut } from "$lib/auth.client";
  import "../app.css";

  const { children } = $props();

  const session = authClient.useSession();
  const user:
    | {
        id: string;
        email: string;
        emailVerified: boolean;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        image?: string | null | undefined;
        login: string;
      }
    | undefined = $derived($session.data?.user) as any;
</script>

<header
  class="fixed top-0 right-0 left-0 container mx-auto flex items-center justify-between border-b bg-white px-4 py-2"
>
  {#if user}
    <a class="text-lg font-medium" href="/">XShader</a>
    <div class="flex items-center gap-2">
      <img src={user.image} alt={user.login} class="h-6 w-6 rounded-full" />
      <span>{user.login}</span>
      <button onclick={() => signOut()}>Sign Out</button>
    </div>
  {:else}
    <button onclick={() => signIn()}>Sign In</button>
  {/if}
</header>

<main class="container mx-auto mt-11">
  {@render children()}
</main>
