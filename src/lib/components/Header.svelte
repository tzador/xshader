<script lang="ts">
  import { authClient, signIn, signOut } from "$lib/auth.client";
  import { LogOut as LogOutIcon } from "lucide-svelte";
  import { goto } from "$app/navigation";
  import type { Snippet } from "svelte";

  const { children }: { children?: Snippet } = $props();

  const session = authClient.useSession();
  const user:
    | {
        image?: string;
        username: string;
      }
    | undefined = $derived($session.data?.user) as any;
</script>

<header
  class="fixed top-0 right-0 left-0 z-10 grid h-16 grid-cols-[1fr_auto_1fr] items-center gap-4 bg-stone-900 px-4"
>
  <div class="flex gap-4">
    <a href="/"><h1 class="text-xl font-medium">xshader.com</h1></a>
  </div>

  {#if children}
    <div class="flex justify-center gap-4">
      {@render children()}
    </div>
  {:else}
    <div class="grid grid-cols-[1fr_auto_1fr] gap-8">
      <div class="flex justify-end gap-4">
        <a href="/">Hot</a>
        <a href="/">Top</a>
        <a href="/">New</a>
        <a href="/">Random</a>
      </div>
      <div>
        <a href="/create" class="font-medium text-yellow-600">Create yours</a>
      </div>
      <div class="flex gap-4">
        <a href="/">FAQ</a>
        <a href="/">About</a>
      </div>
    </div>
  {/if}

  <div class="flex justify-end gap-4">
    {#if user}
      <div class="flex items-center gap-2">
        <a href="/@{user.username}" class="font-medium">@{user.username}</a>
        <div
          style:background-image={`url(${user.image})`}
          class="h-8 w-8 rounded-full bg-cover bg-center"
        ></div>
        <button onclick={() => signOut()}><LogOutIcon /></button>
      </div>
    {:else}
      <button class="font-medium" onclick={() => signIn()}>Sign In</button>
    {/if}
  </div>
</header>
