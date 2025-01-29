<script lang="ts">
  import { byteLengthString, minify } from "$lib/helpers.js";
  import template from "$lib/template.html";

  const { data } = $props();

  const srcdoc = template(data.shader.source);
</script>

<div class="fixed top-16 right-0 bottom-0 left-0 flex flex-col gap-4 p-4">
  <div class="flex items-center">
    {#if data.mine}
      <input type="text" value={data.shader.name} />
    {:else}
      <h2>{data.shader.name}</h2>
    {/if}
  </div>
  <div class="flex flex-1 gap-4 overflow-hidden">
    <div class="flex h-full max-w-2xl min-w-2xl flex-col gap-4 overflow-y-auto">
      <div class="aspect-square w-full bg-black"></div>
      <div class="h-96 flex-none bg-green-500"></div>
    </div>
    <div class="h-full flex-1 bg-stone-800"></div>
  </div>
</div>
