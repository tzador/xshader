export function byteLength(str: string) {
  const a = new TextEncoder().encode(str).length;
  str = minify(str);
  const b = new TextEncoder().encode(str).length;
  return `(${a} -> ${b} = ${(b / a).toFixed(2)}x)`;
}

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
