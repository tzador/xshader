<script lang="ts">
  import ace from "ace-builds";
  import "ace-builds/src-noconflict/mode-glsl";
  import "ace-builds/src-noconflict/theme-monokai";

  let { source = $bindable() }: { source: string } = $props();
  let editor: ace.Ace.Editor;

  function setup(div: HTMLDivElement) {
    editor = ace.edit(div);
    editor.setTheme("ace/theme/monokai");

    editor.session.setMode("ace/mode/glsl");

    editor.setOptions({
      fontSize: "16px",
      fontFamily: "Comic Mono, monospace",
      showPrintMargin: false,
      showGutter: false,
      highlightActiveLine: false,
      minLines: 11,
    });
    editor.setShowFoldWidgets(false);

    editor.container.style.backgroundColor = "#1B1917";
    editor.setValue(source);
    editor.clearSelection();
    editor.on("change", () => {
      source = editor.getValue();
    });

    return {
      destroy() {
        editor.destroy();
      },
    };
  }
</script>

<div class="h-full w-full" use:setup></div>
