<script lang="ts">
  import ace from "ace-builds";
  import "ace-builds/src-noconflict/mode-glsl";
  import "ace-builds/src-noconflict/theme-monokai";
  import colors from "tailwindcss/colors";

  let { source = $bindable(), readonly = false }: { source: string; readonly?: boolean } = $props();
  let editor: ace.Ace.Editor;

  function setup(div: HTMLDivElement) {
    editor = ace.edit(div);
    editor.setTheme("ace/theme/monokai");

    editor.session.setMode("ace/mode/glsl");

    editor.setOptions({
      value: source,
      fontSize: "16px",
      fontFamily: "Comic Mono, monospace",
      showPrintMargin: false,
      showGutter: false,
      highlightActiveLine: false,
      minLines: 11,
      readOnly: readonly,
      tabSize: 2,
    });
    editor.setShowFoldWidgets(false);

    editor.container.style.backgroundColor = colors.stone[900];
    let timeout: NodeJS.Timeout;
    editor.on("change", () => {
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        source = editor.getValue();
      }, 100);
    });

    return {
      destroy() {
        editor.destroy();
      },
    };
  }
</script>

<div class="h-full w-full" use:setup></div>
