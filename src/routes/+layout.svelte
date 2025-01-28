<script lang="ts">
  import { authClient, signIn, signOut } from "$lib/auth.client";
  import "../app.css";

  const { children } = $props();

  const session = authClient.useSession();
</script>

<header>
  {#if $session.data}
    <pre>{JSON.stringify($session.data.user, null, 2)}</pre>
    <button onclick={() => signOut()}>Sign Out</button>
  {:else}
    <button onclick={() => signIn()}>Sign In</button>
  {/if}
</header>

{@render children()}
