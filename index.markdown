---
title: "Dan Manole"
layout: default
permalink: /
---

<main>
  <section>
    <h1>Build in public. Learn loudly.</h1>
    <p>Cloud, systems, and thinking clearly under pressure.</p>
    <p><a href="/archive.html">Browse all posts</a> • <a href="/about/">About</a></p>
  </section>

  <section>
    <h2>Latest</h2>
    {% for post in site.posts limit:6 %}
      <div>
        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </div>
    {% endfor %}
  </section>
</main>
