<script lang="ts">
  import AceEditor from "$lib/components/AceEditor.svelte";
  import Header from "$lib/components/Header.svelte";
  import vertex_ from "$lib/vertex.glsl?raw";
  import fragment_ from "$lib/fragment.glsl?raw";
  import template_ from "$lib/template.html?raw";
  import default_ from "../../lib/default.glsl?raw";

  let name = $state("");
  let source = $state(default_);

  const srcdoc = $derived(
    template_
      .replace("/*** VERTEX_SHADER ***/", vertex_)
      .replace("/*** FRAGMENT_SHADER ***/", fragment_)
      .replace("/*** GLSL_SOURCE ***/", source),
  );
</script>

<Header>
  <button class="text-xl text-green-500">Publish</button>
</Header>

<div class="fixed top-16 right-0 bottom-0 left-0 flex">
  <iframe title="Preview" {srcdoc} class="aspect-square h-full flex-none bg-black"></iframe>
  <div class="flex flex-1 flex-col">
    <input
      type="text"
      bind:value={name}
      placeholder="Shader Name #add #some #hashtags"
      class="w-full text-lg"
    />
    <div class="flex-1 overflow-hidden bg-stone-900">
      <AceEditor bind:source />
    </div>
    <div class="flex h-96 flex-col">
      <div class="flex-none overflow-hidden bg-stone-800 p-2 text-lg text-stone-500">
        List of available built-ins
      </div>
      <div class="flex-1 overflow-hidden bg-stone-700">
        <AceEditor source={fragment_} readonly />
      </div>
    </div>
  </div>
</div>
