import { defineConfig } from "tinacms";

export default defineConfig({
  branch: "main",
  clientId: "9bfcf669-7231-44be-b3e6-580a99327d51",
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
        label: "Blog Posts",
        path: "_posts",
        format: "md",
        match: {
          include: "**/*"  // This will match both .md and .markdown
        },
        ui: {
          filename: {
            slugify: (values) => {
              const date = values?.date 
                ? new Date(values.date).toISOString().split('T')[0]
                : new Date().toISOString().split('T')[0];
              const slug = values?.title
                ?.toLowerCase()
                .replace(/\s+/g, '-')
                .replace(/[^\w-]+/g, '') || 'untitled';
              return `${date}-${slug}`;
            },
          },
        },
        defaultItem: () => {
          return {
            layout: 'post',
            date: new Date().toISOString(),
          }
        },
        fields: [
          {
            type: "string",
            name: "layout",
            label: "Layout",
            required: true,
            options: ["post"],
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
            required: false,
          },
          {
            type: "image",
            name: "image",
            label: "Featured Image",
            required: false,
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
