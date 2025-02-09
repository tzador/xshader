<script lang="ts">
  import Player from "$lib/components/Player.svelte";
  import { formatDate } from "$lib/helpers";

  const {
    shader,
  }: {
    shader: {
      id: string;
      name: string;
      source: string;
      createdAt: any;
      user: {
        name: string;
        image: string | null;
        login: string;
      };
    };
  } = $props();

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

<div
  class="mx-auto flex w-full max-w-[616px] flex-col items-center gap-2 rounded-xl bg-stone-500 p-4 shadow-lg"
>
  <div
    class="aspect-square w-full max-w-[600px] overflow-hidden rounded-lg bg-black shadow-lg"
    use:visibility
  >
    {#if visible}
      <Player source={shader.source} />
    {/if}
  </div>
  <h3 class="py-4 text-lg font-medium text-stone-50">
    {shader.name}
  </h3>
  <p class="text-sm text-stone-50">
    {formatDate(shader.createdAt)}
  </p>
  <pre
    class="shadow-inner-lg w-full max-w-[600px] overflow-auto rounded-lg bg-stone-600 p-4 text-xs whitespace-pre-wrap text-stone-50">{shader.source}</pre>
</div>
