
# Setup



# Brei tasks

## File - brei.toml

```toml
#| file: brei.toml
include = ["docs/weave.toml", "docs/title.toml"]

[[call]]
template = "pandoc"
collect = "html"
[call.args]
basename = ["index", "00-project-workflow"]   # add your pages to this list

[[task]]
name = "copy-before-weave"
description = "Copy notebooks, assets, etc. to docs/"
runner = "bash"
script = """
cp notebooks/*.md docs/
cp -r docs/assets docs/site/
"""

[[task]]
name = "weave"
description = "Deploy site"
requires = ["#copy-before-weave", "#html", "#static"]
```



# Make

## File - Makefile

```make
#| file: Makefile
.PHONY: all preview
all:
	entangled tangle && brei weave
preview:
	firefox docs/site/index.html
```
