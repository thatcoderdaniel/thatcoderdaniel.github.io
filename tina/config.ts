import { defineConfig } from "tinacms";

export default defineConfig({
  branch: "main",
  clientId: "9bfcf669-7231-44be-b3e6-580a99327d51", // Your client ID from TinaCloud
  token: process.env.TINA_TOKEN,

  build: {
    outputFolder: "admin",
    publicFolder: "/",
  },
  media: {
    tina: {
      mediaRoot: "assets/images/uploads",
      publicFolder: "/assets/images/uploads",
    },
  },
  schema: {
    collections: [
      {
        name: "post",
        label: "Posts",
        path: "_posts",
        fields: [
          {
            type: "string",
            name: "layout",
            label: "Layout",
            required: true,
            ui: {
              component: () => "post",
            },
          },
          {
            type: "string",
            name: "title",
            label: "Title",
            isTitle: true,
            required: true,
          },
          {
            type: "datetime",
            name: "date",
            label: "Date",
            required: true,
          },
          {
            type: "string",
            name: "categories",
            label: "Categories",
          },
          {
            type: "image",
            name: "image",
            label: "Featured Image",
          },
          {
            type: "rich-text",
            name: "body",
            label: "Body",
            isBody: true,
          },
        ],
      },
    ],
  },
});
