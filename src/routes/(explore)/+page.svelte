<script lang="ts">
  import Preview from "$lib/components/Preview.svelte";

  export const { data } = $props();
</script>

<div class="flex flex-col gap-4 py-4">
  {#each data.shaders as shader}
    <Preview {shader} />
  {/each}
</div>
