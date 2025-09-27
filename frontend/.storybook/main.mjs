import type { StorybookConfig } from "@storybook/nextjs";

const config = {
  framework: "@storybook/nextjs",
  stories: ["../**/*.mdx", "../**/*.stories.@(ts|tsx)"],
  addons: [
    "@storybook/addon-essentials",
    "@storybook/addon-links",
    "@storybook/addon-interactions"
  ],
  docs: { autodocs: "tag" },
  staticDirs: ["../public"],
  typescript: {
    check: false,
    reactDocgen: "react-docgen-typescript",
    reactDocgenTypescriptOptions: {
      tsconfigPath: "../tsconfig.storybook.json"
    }
  },
  webpackFinal: async (config) => {
    config.resolve = {
      ...config.resolve,
      extensionAlias: {
        ".js": [".ts", ".tsx", ".js", ".jsx"],
        ".mjs": [".mts", ".mjs"]
      }
    };
    return config;
  }
};

export default config;
