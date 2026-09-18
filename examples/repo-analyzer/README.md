# repo-analyzer — analysis packet

Pinned commit: `b5ed1cda154ab2b31a272b188e7ee85bfbb072dd` (short `b5ed1cd`),
branch `main`, cloned 2026-09-18.

## Start Here

1. [current-understanding-2026-09-18.md](current-understanding-2026-09-18.md) — what the repo is, how it works, what is reusable, and the gaps found.
2. [source-map-2026-09-18.md](source-map-2026-09-18.md) — every tracked file, with line anchors to the parts that matter.
3. [install-and-setup-2026-09-18.md](install-and-setup-2026-09-18.md) — how to install, run, and remove it.

The repo has 10 tracked files, so the three core pages are the whole packet.
No topic pages were needed.

## One Paragraph

repo-analyzer is two prompts for coding agents and two small Python scripts.
`/analyze-repo` makes an agent clone a repository, read it, and write a
markdown research packet. `/audit-repo-security` makes an agent judge whether
a repository looks safe to install. The most reusable idea is the pair of
mechanical checks around the agent's writing. A script lists the repo's major
parts before writing starts
([bin/repo-signals](../clone/bin/repo-signals:121)), and a second script
refuses the packet if a part is missing or a file-and-line link is broken
([bin/verify-packet](../clone/bin/verify-packet:98)). The agent cannot
silently skip a part of the repo.

## Status

This is the example packet for repo-analyzer. It was produced by running the
`/analyze-repo` skill on the repository itself, at commit
`b5ed1cda154ab2b31a272b188e7ee85bfbb072dd`. It shows the packet format. It is
not a review by an outside party.

## Coverage Contract

`repo-signals` reported two subsystems. Root-level files are not subsystems
to the script, but this packet covers them too.

| Subsystem | Files | Disposition |
|-----------|-------|-------------|
| `bin` | 2 | current-understanding, source-map |
| `skills` | 2 | current-understanding, source-map |
| root files (`README.md`, `AGENTS.md`, `CLAUDE.md`, `LICENSE`, `.gitignore`, `install.sh`) | 6 | source-map, install-and-setup |

## Evidence And Caveats

- **Commit:** `b5ed1cda154ab2b31a272b188e7ee85bfbb072dd`, the only commit on `main` in the shallow clone.
- **Versions:** the repo has no version number, no tags in the clone, and no package manifest.
- **License:** MIT ([LICENSE](../clone/LICENSE:1)).
- **Signals:** 10 files, 2 top-level directories, no runtime detected, doc ratio 0.5, suggested tier `default`.
- **Method:** static reading of all 10 tracked files. `install.sh` was not run.
- **Checks run on the clone:** `python3 -m py_compile bin/repo-signals bin/verify-packet` passed. `python3 -m pyflakes bin/*` printed no warnings. `bash -n install.sh` passed. `bin/repo-signals` and `bin/verify-packet` were run as part of the skill.
- **Not checked:** behaviour of `install.sh` on a real home folder, and behaviour on Python 3.9, the oldest version the README names.
- **verify-packet:** `4 pages, anchors 163/163 resolved, 0 failure(s): PASS`

## Staleness Trigger

Redo this packet when any of these change upstream:

- either script in `bin/`, because line anchors and the described checks move;
- the stage list or the required README sections in `skills/analyze-repo.md`;
- `install.sh` link targets;
- the addition of a test suite, a CI workflow, or a package manifest, because this packet states that none exist.
