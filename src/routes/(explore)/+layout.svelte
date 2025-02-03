<script lang="ts">
  import Header from "$lib/components/Header.svelte";

  const { children } = $props();
</script>

<Header />

<main class="mt-16">
  {@render children()}
</main>
