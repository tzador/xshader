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
