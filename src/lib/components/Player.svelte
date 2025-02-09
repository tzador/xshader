<script lang="ts">
  import fragment_ from "$lib/fragment.glsl?raw";
  import prelude_ from "$lib/prelude.glsl?raw";
  import template_ from "$lib/template.html?raw";
  import vertex_ from "$lib/vertex.glsl?raw";

  const { source }: { source: string } = $props();

  const srcdoc = $derived(
    template_
      .replace("/*** VERTEX_SHADER ***/", vertex_)
      .replace("/*** FRAGMENT_SHADER ***/", fragment_)
      .replace("/*** PRELUDE_SOURCE ***/", prelude_)
      .replace("/*** GLSL_SOURCE ***/", source),
  );
</script>

<iframe title="Preview" {srcdoc} class="aspect-square h-full flex-none bg-black"></iframe>
