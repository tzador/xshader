<script lang="ts">
  import { byteLength, minify } from "$lib/helpers";
  import template from "$lib/template.html";

  const {
    shader,
  }: {
    shader: {
      id: string;
      title: string;
      source: string;
      user: {
        name: string;
        image: string | null;
        login: string;
      };
    };
  } = $props();

  const srcdoc = template(minify(shader.source));

  let visible = $state(false);

  function visibility(node: HTMLElement) {
    const observer = new IntersectionObserver(
      (entries) => {
        const [entry] = entries;
        visible = entry.isIntersecting;
      },
      { threshold: 0 },
    );

    observer.observe(node);

    return {
      destroy() {
        observer.disconnect();
      },
    };
  }
</script>

<div class="flex flex-col items-center gap-2">
  <div class="h-[600px] w-[600px] bg-black" use:visibility>
    {#if visible}
      <iframe {srcdoc} title={shader.title} class="h-full w-full"></iframe>
    {/if}
  </div>
  <div class="flex w-[600px] justify-between gap-4">
    <a href={`/s/${shader.id}`}>
      <h3 class="text-lg font-medium text-blue-500">
        {shader.title} ({byteLength(shader.source)} bytes)
      </h3>
    </a>
    <button class="cursor-pointer rounded-md bg-red-700 px-2 py-1 text-white">Delete</button>
  </div>
</div>
