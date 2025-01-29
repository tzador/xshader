<script lang="ts">
  import { byteLengthString, minify } from "$lib/helpers.js";
  import template from "$lib/template.html";

  const { data } = $props();

  const srcdoc = template(data.shader.source);
</script>

<div class="fixed top-16 right-0 bottom-0 left-0 flex flex-col gap-4 p-4">
  <div class="flex items-center gap-4">
    {#if data.mine}
      <!-- svelte-ignore a11y_autofocus -->
      <input
        autofocus
        type="text"
        value={data.shader.name}
        placeholder="shader name  #tag-one #tag-two #tag-three"
        class="max-w-2xl min-w-2xl rounded-lg text-xl"
      />
      <button
        class="w-38 rounded-lg bg-green-600/90 px-8 py-2 text-lg font-medium hover:bg-green-600"
      >
        publish
      </button>
      <button
        class="w-38 rounded-lg bg-yellow-600/90 px-8 py-2 text-lg font-medium hover:bg-yellow-600"
      >
        fork
      </button>
      <div class="flex-1"></div>
      <button class="w-38 rounded-lg bg-red-600/30 px-8 py-2 text-lg font-medium hover:bg-red-600">
        delete
      </button>
    {:else}
      <h2
        class="max-w-2xl min-w-2xl overflow-hidden text-xl font-medium overflow-ellipsis whitespace-nowrap"
      >
        {data.shader.name}
      </h2>
    {/if}
  </div>
  <div class="flex flex-1 gap-4 overflow-hidden">
    <div class="hide-scrollbar flex h-full max-w-2xl min-w-2xl flex-col gap-4 overflow-y-auto">
      <div class="aspect-square w-full rounded-lg bg-black"></div>
      <div class="h-96 flex-none rounded-lg bg-stone-800 p-4"></div>
    </div>
    <div class="hide-scrollbar flex h-full flex-1 flex-col gap-4 overflow-y-auto">
      <div class="h-44 flex-none rounded-lg bg-stone-800 p-4">Source</div>
      <div class="h-32 flex-none rounded-lg bg-stone-800 p-4">Errors</div>
      <div class="h-24 flex-none rounded-lg bg-stone-800 p-4">Minified</div>
      <div class="min-h-196 flex-1 rounded-lg bg-stone-800 p-4">Env</div>
    </div>
  </div>
</div>
