export function formatDate(date: string) {
  return new Date(date).toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}
export function byteLength(str: string) {
  return new TextEncoder().encode(minify(str)).length;
}

export function byteLengthString(str: string) {
  const a = new TextEncoder().encode(str).length;
  str = minify(str);
  const b = new TextEncoder().encode(str).length;
  return `${a} original -> ${b} minified bytes`;
}

// TODO: remove this
export function minify(str: string) {
  str = str.replace(/\/\/.*$/gm, "");
  str = str.replace(/\/[*][^*]+[*]\//gm, "");
  str = str.replace(/\s\s+/g, "");
  str = str.replace(/\s\/\s/g, "/");
  str = str.replace(/\s=\s/g, "=");
  str = str.replace(/\s\*\s/g, "*");
  str = str.replace(/\s\+\s/g, "+");
  str = str.replace(/\s-\s/g, "-");
  str = str.replace(/\s\*\*\s/g, "**");
  str = str.replace(/,\s/g, ",");
  str = str.replace(/\)\s/g, ")");
  str = str.replace(/\s\(/g, "(");
  str = str.replace(/\}\s/g, "}");
  str = str.replace(/\s\{/g, "{");
  return str;
}
