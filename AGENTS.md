# Agent instructions

repo-analyzer is two skill prompts (`skills/`) and two small Python tools
(`bin/`). There is no build step and no package to install.

## Commands

```sh
./install.sh                          # symlink skills and tools; safe to re-run
bin/repo-signals <clone-dir>          # JSON complexity and security signals
bin/verify-packet data/<repo>         # check a packet's anchors, SHA, coverage
```

**Final check** — run once on the exact tree you will commit:

```sh
python3 -m py_compile bin/repo-signals bin/verify-packet && python3 -m pyflakes bin/repo-signals bin/verify-packet && bin/repo-signals . > /dev/null
```

There is no test suite. When you change a tool, also run it on a real clone
or packet under `data/` and read the output. An older local packet can fail
for reasons your change did not cause.

## Conventions

- `bin/` tools are single-file Python 3 using only the standard library. Do
  not add dependencies.
- `bin/repo-signals` must give the same output for the same checkout. It
  reads `git ls-files`; keep every list it emits sorted.
- The skills in `skills/` are the product. Keep each claim in them true to
  what the tools actually do.
- `data/` is each user's local working data and is gitignored. Never commit
  anything under it, and never commit a clone of another repo.

## Never

- Commit secrets, `.env` files, or local agent configuration.
- Add AI attribution to commits or pull requests (no `Co-authored-by`,
  "Generated with", or similar lines).
- Weaken a check to make it pass, or report a check as passed when it was
  not run.
- Expand a change beyond what was asked.
