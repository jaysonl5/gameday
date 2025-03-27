const esbuild = require("esbuild");
const { sassPlugin } = require("esbuild-sass-plugin");
const postcss = require("postcss");
const autoprefixer = require("autoprefixer");
const postcssPresetEnv = require("postcss-preset-env");

esbuild.build({
  entryPoints: ["application.tsx"],
  bundle: true,
  format: "esm",
  target: ["esnext"],
  external: ["react", "react-dom"],
  outdir: "app/assets/builds",
  loader: { ".js": "jsx" },
  plugins: [
    sassPlugin({
      async transform(source, resolveDir) {
        const { css } = await postcss([
          autoprefixer,
          postcssPresetEnv({ stage: 0 }),
        ]).process(source, { from: undefined });
        return css;
      },
    }),
  ],
}).catch(() => process.exit(1));