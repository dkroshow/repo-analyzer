# repo-analyzer — install and setup

Pinned commit: `b5ed1cda154ab2b31a272b188e7ee85bfbb072dd` (`b5ed1cd`), branch `main`, read 2026-09-18.
This page comes from static reading. `install.sh` was not run; it passed `bash -n` (syntax only).

## Prerequisites

- `git` and Python 3.9 or later, per the README ([README.md](../clone/README.md:55)). No file in the repo enforces the Python version.
- `bash`, for the installer ([install.sh](../clone/install.sh:1)).
- No Python packages. Both tools import only the standard library ([AGENTS.md](../clone/AGENTS.md:21)).
- A coding agent that reads prompt files: Claude Code or Codex ([README.md](../clone/README.md:62)).

## Install

```sh
git clone <this repo> && cd repo-analyzer
./install.sh
```

([README.md](../clone/README.md:57)). The installer creates symlinks and nothing else:

| What | Link location | Source |
|------|---------------|--------|
| both skills | `~/.claude/commands/` | [install.sh](../clone/install.sh:21) |
| both skills | `~/.codex/prompts/` | [install.sh](../clone/install.sh:27) |
| both tools | `~/.local/bin/` | [install.sh](../clone/install.sh:33) |

Behaviour of the `link()` helper ([install.sh](../clone/install.sh:9)):

- a correct link already exists: prints `ok`, changes nothing;
- something else exists at that path: prints `SKIP`, changes nothing;
- otherwise: creates the link.

So a re-run is safe, and the installer never overwrites a file. This matches
the README claim ([README.md](../clone/README.md:81)). It creates the three
folders if they are missing ([install.sh](../clone/install.sh:22)). If
`~/.local/bin` is not on `PATH`, it prints the line to add and does not edit
any shell profile ([install.sh](../clone/install.sh:39)).

The links point at the clone's absolute path ([install.sh](../clone/install.sh:5)).
Moving or deleting the clone breaks them.

**CI cross-check:** there are no CI workflows in the tracked files, so the
documented install path has no automated confirmation.

## First run

- Codex reads its prompt list at start, so restart a running Codex session ([install.sh](../clone/install.sh:46)).
- In the agent, run `/analyze-repo <url or path>`. The skill clones into `data/<repo>/clone` under the project you run it from, and adds `data/` to that project's `.gitignore` if missing ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:42)).
- No config file, environment variable, account, or key is needed. Whatever the agent reads goes to its model provider ([README.md](../clone/README.md:89)).

The tools also run without the installer, straight from `bin/`
([AGENTS.md](../clone/AGENTS.md:10)). `verify-packet` looks for `repo-signals`
in its own folder first ([bin/verify-packet](../clone/bin/verify-packet:99)).

## Update and uninstall

- **Update:** `git pull` in the clone. The links already point at the live files. Re-run `./install.sh` only if a skill or tool was added.
- **Uninstall:** remove the symlinks ([README.md](../clone/README.md:83)). There is no uninstall script. Packets under `data/` are yours and are not touched.

## Developer checks

From [AGENTS.md](../clone/AGENTS.md:12): `python3 -m py_compile bin/repo-signals bin/verify-packet`, and `python3 -m pyflakes bin/*` if installed. Both were run on the clone for this packet and reported no problems. There is no test suite ([AGENTS.md](../clone/AGENTS.md:16)).
