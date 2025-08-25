import { defineConfig } from "tinacms";

export default defineConfig({
  branch: "main",
  clientId: "9bfcf669-7231-44be-b3e6-580a99327d51",
  token: process.env.TINA_TOKEN,
  
  build: {
    outputFolder: "admin",
    publicFolder: "",
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
          const now = new Date();
          // Format as Jekyll expects: "2025-08-25 10:30:00 -0500"
          const year = now.getFullYear();
          const month = String(now.getMonth() + 1).padStart(2, '0');
          const day = String(now.getDate()).padStart(2, '0');
          const hours = String(now.getHours()).padStart(2, '0');
          const minutes = String(now.getMinutes()).padStart(2, '0');
          const seconds = String(now.getSeconds()).padStart(2, '0');
          const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds} -0500`;
          
          return {
            layout: 'post',
            date: formattedDate,
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
            type: "string",
            name: "date",
            label: "Date",
            required: true,
            description: "Format: YYYY-MM-DD HH:MM:SS -0500",
          },
          {
            type: "string",
            name: "categories",
            label: "Categories",
            required: false,
            description: "Space-separated (e.g., 'devops cloud tutorial')",
          },
          {
            type: "string",
            name: "description",
            label: "Description",
            required: false,
            description: "SEO description for the post",
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
