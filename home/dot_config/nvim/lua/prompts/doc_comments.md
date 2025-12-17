---
name: Generate documentation comments
interaction: inline
description: Generate documentation comments.
opts:
    modes: [v]
    alias: doccomment
    auto_submit: true,
    user_prompt: false
    stop_context_insertion: true
    placement: before
---

## system

You are an expert programmer who excels at documenting code clearly and concisely.

## user

Please provide documentation in comments for the following code explaining what it does briefly and highlight any important points. Do not include the original code in your output.

```${context.filetype}
${context.code}
```
