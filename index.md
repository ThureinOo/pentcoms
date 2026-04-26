---
layout: page
title: Senshu
---

<p class="home-description">
Senshu is an interactive cheat sheet, containing a curated list of offensive security tools and their respective commands for penetration testing. <br>Created by <a href="https://github.com/ThureinOo">Thurein Oo</a>. Inspired by <a href="https://wadcoms.github.io/">WADComs</a>, <a href="https://gtfobins.github.io/">GTFOBins</a>, and <a href="https://lolbas-project.github.io/">LOLBAS</a>.
<br>
If you would like to contribute, check out the <a href="{{ site.baseurl }}/contribute/">contribute</a> page. You can also use the <a href="{{ site.baseurl }}/filters/">filters</a> and <a href="{{ site.baseurl }}/items/">items</a> pages to learn more about the available filter options.
</p>

<p class="page-views">Views: <span id="gc-views">...</span></p>
<script>
  fetch('https://senshu.goatcounter.com/counter/%2F.json')
    .then(r => r.json())
    .then(data => { document.getElementById('gc-views').innerText = data.count; })
    .catch(() => { document.getElementById('gc-views').innerText = '—'; });
</script>

{% include bin_table.html %}
