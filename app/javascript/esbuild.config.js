const esbuild = require("esbuild")

esbuild.build({
  entryPoints: ["application.tsx"],
  bundle: true,
  format: "esm",
  target: ["esnext"],
  external: ["react", "react-dom"],
  outdir: "app/assets/builds",
  loader: { ".js": "jsx" },
}).catch(() => process.exit(1))