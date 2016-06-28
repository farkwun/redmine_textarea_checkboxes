# redmine_textarea_checkboxes
Handles checkboxes for Redmine issue descriptions

# Supported formatting
Individual checkboxes can be created with a line break before and after each checkbox

```
[ ] Checkbox 1

[ ] Checkbox 2

[ ] Checkbox 3
```

In formatters that support these elements, checkboxes can also be used in lists (Textile and Markdown)...

```
* [ ] Checklist Item 1
* [ ] Checklist Item 1
* [ ] Checklist Item 1
```

and in tables (Textile only).
```
|[ ] Cell Checkbox 1|[ ] Cell Checkbox 2|
|[ ] Cell Checkbox 3|[ ] Cell Checkbox 4|
```

