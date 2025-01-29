<script lang="ts">
  import { authClient, signIn, signOut } from "$lib/auth.client";
  import { LogOut } from "lucide-svelte";
  import "../app.css";
  import { goto } from "$app/navigation";

  const { children } = $props();

  const session = authClient.useSession();
  const user:
    | {
        image?: string | null | undefined;
        username: string;
      }
    | undefined = $derived($session.data?.user) as any;

  async function create() {
    if (!user) {
      await signIn("/create");
    } else {
      await goto("/create");
    }
  }
</script>

<header
  class="fixed top-0 right-0 left-0 grid grid-cols-[1fr_auto_1fr] items-center gap-4 bg-stone-800 p-4"
>
  <div class="flex items-center justify-start gap-4">
    <a class="text-xl font-medium" href="/"><h1>xshader.org</h1></a>
  </div>
  <div class="flex items-center gap-4">
    <a href="/">hot</a>
    <a href="/">top</a>
    <a href="/">latest</a>
    <a href="/">random</a>
    <button class="font-medium text-purple-500" onclick={() => create()}>create</button>
    <a href="/">faq</a>
    <a href="/">about</a>
  </div>
  <div class="flex justify-end">
    {#if user}
      <div class="flex items-center gap-2">
        <a href="/@{user.username}" class="font-medium">@{user.username}</a>
        <img src={user.image} alt={user.username} class="h-8 w-8 rounded-full" />
        <button onclick={() => signOut()}><LogOut /></button>
      </div>
    {:else}
      <button class="font-medium" onclick={() => signIn()}>Sign In</button>
    {/if}
  </div>
</header>

<main class="container mx-auto mt-16">
  {@render children()}
</main>
