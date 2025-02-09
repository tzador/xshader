<script lang="ts">
  import { goto } from "$app/navigation";
  import AceEditor from "$lib/components/AceEditor.svelte";
  import Header from "$lib/components/Header.svelte";
  import Player from "$lib/components/Player.svelte";
  import default_ from "$lib/default.glsl?raw";

  let name = $state("");
  let source = $state(default_);

  let busy = $state(false);
  const create = async () => {
    try {
      busy = true;
      const name_ = name.trim();
      if (!name_) {
        alert("Please enter a name for your shader");
        return;
      }

      const source_ = source.trim();
      if (!source_) {
        alert("Please enter a shader source");
        return;
      }

      const r = await fetch("/api/create", {
        method: "POST",
        body: JSON.stringify({ name: name_, source: source_ }),
      });

      if (!r.ok) {
        console.error(r.status, r.statusText);
        alert("Failed to create shader");
        return;
      }

      await goto(`/`);
    } finally {
      busy = false;
    }
  };
</script>

<Header>
  <button class="text-xl text-green-500 disabled:text-gray-500" disabled={busy} onclick={create}>
    Publish
  </button>
</Header>

<div class="fixed top-16 right-0 bottom-0 left-0 flex">
  <Player {source} />
  <div class="flex flex-1 flex-col gap-2 bg-stone-900">
    <input
      type="text"
      bind:value={name}
      placeholder="Shader Name #add #some #hashtags"
      class="w-full text-lg"
    />
    <div class="ml-2 flex-1 overflow-hidden bg-stone-900">
      <AceEditor bind:source />
    </div>
    <div class="flex gap-4 bg-stone-800 p-4">
      <div class="flex-1"></div>
      <a
        href="https://github.com/tzador/xshader/blob/main/src/lib/prelude.glsl"
        class="text-yellow-500"
        target="_blank"
      >
        Help</a
      >
    </div>
  </div>
</div>
