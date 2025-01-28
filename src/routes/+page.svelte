<script lang="ts">
  import Preview from "$lib/components/Preview.svelte";

  export const {
    data,
  }: {
    data: {
      shaders: Promise<
        {
          id: string;
          title: string;
          source: string;
          user: {
            name: string;
            image: string | null;
            login: string;
          };
        }[]
      >;
    };
  } = $props();
</script>

<div class="flex flex-col gap-4 py-4">
  {#await data.shaders then shaders}
    {#each shaders as shader}
      <Preview {shader} />
    {/each}
  {/await}
</div>
