# Examples

This folder holds example packets written by the `/analyze-repo` skill.

- `repo-analyzer/` is the packet produced by running the skill on this
  repository itself. Its README names the commit it describes.

Packet pages link to source with paths like `../clone/bin/repo-signals:121`.
Those links resolve only in a live `data/<repo>/` folder, where the clone
sits beside the packet. No clone is committed, so the links do not resolve here.
