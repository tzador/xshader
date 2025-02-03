<script lang="ts">
  import AceEditor from "$lib/components/AceEditor.svelte";
  import Header from "$lib/components/Header.svelte";
  import defaultSource from "../../lib/default.glsl";
  import template from "$lib/template.html";

  let name = $state("");
  let source = $state(defaultSource);

  const srcdoc = $derived(template(source));
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
  </div>
</div>
