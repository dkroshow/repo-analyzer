# repo-analyzer

Two skills for coding agents that help you evaluate another
repository.

- `/analyze-repo` reads a repo and writes a research packet on what it is
  and how it works.
- `/audit-repo-security` reads a repo and tells you whether it looks safe to
  install.

The skills run inside your coding agent. There is no separate API key, no
database, and no search index. The agent clones the repo and reads it with
ordinary tools.

For context, this was built for internal purposes and released publicly Sept 2026. One
maintainer, best effort. Issues and pull requests are welcome.

## The two skills

**`/analyze-repo` answers "what is this, and how does it work?"**
It is meant for regular use across many repos. A small script first measures
the repo: how many files, which languages, which major parts. That
measurement decides how capable a model the job needs, so small repos stay
cheap. The agent then lists the repo's major parts and must cover each one,
or say plainly that it skipped it. Nothing gets silently left out.

**`/audit-repo-security` answers "should I install this on my machine?"**
It is meant for occasional, careful use, and it uses the strongest model by
default. It instructs the agent to read the code and never run it. For each risky
feature it
names what the feature can do, what could go wrong, whether it is on by
default, and what limits the damage.

Both skills work from the same local clone and the same measuring script
(`bin/repo-signals`).

## Where the packets go

Each repo you analyze gets its own folder under `data/`. Git ignores `data/`,
so your packets stay on your machine.

```
data/<repo>/
├── analysis/    # the packet: an index, how it works, a source map,
│                #   install and setup, and the security audit if you ran one
└── clone/       # a shallow clone of the repo, kept so links resolve
```

The packet links into the clone beside it, like
`[api/rag.py](../clone/api/rag.py:345)`. Each link names a real file and line
at a recorded commit, so the packet stays checkable offline.

## Install

You need `git` and Python 3.9 or later.

```sh
git clone <this repo> && cd repo-analyzer
./install.sh
```

The installer symlinks the skills into `~/.claude/commands/` (Claude Code) and
`~/.codex/prompts/` (Codex), and the tools into `~/.local/bin/`. Codex reads
its prompt list when it starts, so restart a running Codex session to see
the new skills.

## Tools

- `bin/repo-signals <clone-dir>` measures a repo and prints JSON: file
  counts, languages, major parts, a suggested model size, a list of
  security-relevant spots with questions the audit must answer, and what it
  skipped. It reads the files git tracks, it is deterministic, and it uses
  only the Python standard library.
- `bin/verify-packet data/<repo>` checks a finished packet: every file-and-
  line link resolves at the pinned commit, every page names that commit, and
  every major part of the repo is covered or waived. `/analyze-repo` runs it
  before it keeps a packet.

## What it touches

- `install.sh` only creates symlinks, in `~/.claude/commands/`,
  `~/.codex/prompts/`, and `~/.local/bin/`. It never overwrites an existing
  file. Remove the symlinks to uninstall.
- The skills clone the repo you point them at into `data/` and read it. They
  instruct the agent not to run its code; nothing in this repo enforces
  that, so the agent's own permissions are the real limit.
- `/analyze-repo` adds `data/` to the `.gitignore` of the project you run it
  from, if it is not already there.
- Whatever the agent reads goes to your model provider, as with any agent
  session. Do not point the skills at a repo you cannot share with that
  provider.

## Limitations

Be clear about what this is: two prompts and two small scripts.

- `verify-packet` checks links, the pinned commit, and coverage. It cannot
  check whether a page is correct. The agent must still run it; nothing
  forces that.
- `repo-signals` caps each security category at 20 hits and reports the cap
  and the files it skipped, but its hits are leads, and many are noise.
- The model tiers in `skills/analyze-repo.md` are advice for whoever launches
  the skill. A prompt cannot change the model already running it.
- A prompt cannot make the audit resistant to a repo that tries to talk to
  the agent. Both skills tell the agent to treat repo content as untrusted,
  and that is all a prompt can do.
- The only example packet is of this repo (`examples/repo-analyzer/`).
  Publishing a packet means publishing claims about someone else's code, so
  there are no others.

## Repo map

- `skills/` — the two skills.
- `bin/` — the two tools.
- `examples/` — one example packet: this repo, analyzed by itself.
- `data/` — your local packets and clones, ignored by git.

## License

MIT. See [LICENSE](LICENSE).
