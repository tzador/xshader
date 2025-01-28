<script lang="ts">
  import { byteLengthString, minify } from "$lib/helpers.js";
  import template from "$lib/template.html";

  const { data } = $props();

  const srcdoc = template(data.shader.source);
</script>

<div class="flex flex-col gap-4 py-4">
  <h2 class="text-2xl font-medium">
    {data.shader.title}
    ~
    {byteLengthString(data.shader.source)}
  </h2>
  <div class="container mx-auto flex items-start gap-4">
    <iframe {srcdoc} title={data.shader.title} class="h-[600px] w-[600px] flex-none"></iframe>
    <pre class="h-[600px] flex-1 overflow-auto text-xs">{data.shader.source}</pre>
  </div>
  <hr />
  <pre class="h-[600px] w-[600px] flex-1 overflow-auto text-xs whitespace-pre-wrap">{minify(
      data.shader.source,
    )}</pre>
</div>
