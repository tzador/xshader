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
  class="fixed top-0 right-0 left-0 grid h-16 grid-cols-[1fr_auto_1fr] items-center gap-4 bg-black/50 px-4"
>
  <div class="flex">
    <a class="text-xl font-medium" href="/"><h1>xshader.com</h1></a>
  </div>
  <div class="flex items-center gap-4">
    <a href="/">hot</a>
    <a href="/">top</a>
    <a href="/">new</a>
    <a href="/">rnd</a>
    <button class="font-medium text-yellow-600" onclick={() => create()}>create</button>
    <a href="/">faq</a>
    <a href="/">about</a>
  </div>
  <div class="flex justify-end">
    {#if user}
      <div class="flex items-center gap-2">
        <a href="/@{user.username}" class="font-medium">@{user.username}</a>
        <div
          style:background-image={`url(${user.image})`}
          class="h-8 w-8 rounded-full bg-cover bg-center"
        ></div>
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
