---
layout: page
title: Filters
---

## Filter Descriptions

### Services

| Service | Description |
|---------|-------------|
{% for s in site.data.services %}| **{{ s.label }}** | {{ s.description }} |
{% endfor %}

### Phases

| Phase | Description |
|-------|-------------|
{% for p in site.data.phases %}| **{{ p.label }}** | {{ p.description }} |
{% endfor %}

### Techniques

| Technique | Description |
|-----------|-------------|
{% for t in site.data.techniques %}| **{{ t.label }}** | {{ t.description | default: "" }} |
{% endfor %}

