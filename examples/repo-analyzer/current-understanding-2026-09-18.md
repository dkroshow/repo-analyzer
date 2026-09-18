# repo-analyzer — current understanding

Pinned commit: `b5ed1cda154ab2b31a272b188e7ee85bfbb072dd` (`b5ed1cd`), branch `main`, read 2026-09-18.
Everything below comes from reading source, unless a line says a check was run.

## What it is

Two prompt files and two single-file Python scripts
([AGENTS.md](../clone/AGENTS.md:3)). There is no build step and no package.
The prompts are the product; the scripts support them
([AGENTS.md](../clone/AGENTS.md:25)).

- `/analyze-repo` answers "what is this, and how does it work?" ([README.md](../clone/README.md:20)).
- `/audit-repo-security` answers "should I install this on my machine?" ([README.md](../clone/README.md:27)).

The README states that nothing else is involved: no API key, no database, no
search index ([README.md](../clone/README.md:11)). The source agrees. Neither
script imports anything outside the Python standard library
([bin/repo-signals](../clone/bin/repo-signals:13),
[bin/verify-packet](../clone/bin/verify-packet:19)), and neither makes a
network call.

## Product model

Each analyzed repo gets one folder, `data/<repo>/`, with a shallow clone and a
packet beside it ([README.md](../clone/README.md:42)). Packet pages link into
the clone with relative file-and-line links, so a reader can check a claim
offline ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:116)).
`data/` is ignored by git, so packets stay local
([.gitignore](../clone/.gitignore:3)).

## How `/analyze-repo` works

The skill is a six-stage prompt
([skills/analyze-repo.md](../clone/skills/analyze-repo.md:32)).

1. **Acquire.** Shallow-clone, and record the commit ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:34)).
2. **Scan.** Run `repo-signals` and read the README, license, and manifests ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:47)).
3. **Route.** Use the script's `suggested_tier` to decide how capable a model the job needs ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:67)). The skill admits this is advice only, because a prompt cannot change the model that runs it ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:78)).
4. **Plan.** Assign every listed subsystem to a page, or waive it with a reason. This is the "coverage contract" ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:91)).
5. **Generate.** Write pages where every non-obvious claim has a link into the clone ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:116)). Reading only; do not run the target's code ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:126)).
6. **Verify and persist.** Run `verify-packet`, and do not keep a failing packet ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:150)).

The skill tells the agent to treat the target repo as untrusted data
([skills/analyze-repo.md](../clone/skills/analyze-repo.md:20)).

## How `/audit-repo-security` works

It is a separate, slower skill that produces one page with a verdict
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:8)).
Its rules are: read only, never run
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:13));
never give a blanket all-clear
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:22));
state the consequence of a feature, not only the mechanism
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:25));
and say whether each risky feature is on by default
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:32)).
It starts from the `security_indicators` block that `repo-signals` emits
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:53)).

`verify-packet` has no check for the audit page beyond the checks it applies
to every page. The audit's own coverage rule
([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:95))
is enforced by the prompt only.

## The two scripts

**`bin/repo-signals`** prints one JSON object
([bin/repo-signals](../clone/bin/repo-signals:215)).

- The file list is `git ls-files`, with a sorted directory walk as the fallback ([bin/repo-signals](../clone/bin/repo-signals:78), [bin/repo-signals](../clone/bin/repo-signals:90)).
- A language counts as a runtime only with 5 or more files of a known extension ([bin/repo-signals](../clone/bin/repo-signals:199)).
- The tier rule is: `low` for doc-heavy repos under 300 files, `high` for 3+ runtimes, 25+ top-level directories, or 1000+ files, else `default` ([bin/repo-signals](../clone/bin/repo-signals:207)).
- Subsystems are the top-level directories. The script descends into any directory that holds 40% or more of the files, to a depth of 3 ([bin/repo-signals](../clone/bin/repo-signals:121), [bin/repo-signals](../clone/bin/repo-signals:37)).
- Editor and CI folders are flagged `auto_waivable` ([bin/repo-signals](../clone/bin/repo-signals:34)).
- The security scan is a set of regular expressions over file content and paths ([bin/repo-signals](../clone/bin/repo-signals:47)). Each category carries a question the audit must answer ([bin/repo-signals](../clone/bin/repo-signals:65)). It caps hits at 20 per category, skips files over 256 KB and binary files, and reports what it skipped ([bin/repo-signals](../clone/bin/repo-signals:74), [bin/repo-signals](../clone/bin/repo-signals:158)).

**`bin/verify-packet`** runs four checks in order and exits 1 on any failure
([bin/verify-packet](../clone/bin/verify-packet:6)).

- Shape: `README.md` plus three dated pages ([bin/verify-packet](../clone/bin/verify-packet:27)).
- Commit: each page contains the full SHA or its first 7 characters ([bin/verify-packet](../clone/bin/verify-packet:72)).
- Anchors: each `../clone/path:line` link names a real file with at least that many lines ([bin/verify-packet](../clone/bin/verify-packet:83)). Hosted `/blob/` URLs are failures ([bin/verify-packet](../clone/bin/verify-packet:30)).
- Coverage: it re-runs `repo-signals` and looks for each subsystem path, in backticks, at the start of a table row under `## Coverage Contract` ([bin/verify-packet](../clone/bin/verify-packet:107)).

## Reusable ideas

1. **List first, then hold the writer to the list.** A cheap deterministic script lists the parts, and a second script checks the finished text against that list. This targets omission, which the skill calls the most common failure ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:16)).
2. **Links that a script can check.** Relative links into a pinned clone make "does this citation exist" a mechanical question.
3. **Ship a question with each grep hit.** The scan attaches a "must answer" question to each category, which pushes the audit from "the code touches X" to a stated consequence ([bin/repo-signals](../clone/bin/repo-signals:61)).
4. **Separate "understand" from "is it safe".** The routine skill ignores the security block ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:55)); the careful skill runs rarely and on the strongest model ([skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:19)).

## Findings and caveats

These are gaps between what the docs say and what the source does.

1. **The `--min-anchor-rate` option does not work.** The value after the flag does not start with `--`, so it stays in the positional list ([bin/verify-packet](../clone/bin/verify-packet:46)). The list then has two entries, and the script prints its usage text and exits 2 ([bin/verify-packet](../clone/bin/verify-packet:50)). Confirmed by running `verify-packet data/repo-analyzer --min-anchor-rate 0.9` on this packet.
2. **The 0.95 anchor threshold never decides the result.** The skill says resolution below 0.95 fails ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:154)). In the script, every single broken anchor is already recorded as a failure ([bin/verify-packet](../clone/bin/verify-packet:88)), and any failure means exit 1 ([bin/verify-packet](../clone/bin/verify-packet:129)). So one broken link fails the packet. The behaviour is stricter than documented.
3. **The script does not see its own language.** Both tools are Python files without a `.py` extension, so they count under the empty extension ([bin/repo-signals](../clone/bin/repo-signals:99)). Run on this repo, the script reports `runtimes: []`. Any repo of extensionless scripts is under-counted for routing.
4. **Root files are outside the contract.** Subsystems are directories only ([bin/repo-signals](../clone/bin/repo-signals:106)). For this repo that leaves 6 of 10 files, including `install.sh`, with no coverage requirement.
5. **Two README sections the skill requires are not checked.** The skill lists seven README sections ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:168)). `verify-packet` checks only for the Coverage Contract heading ([bin/verify-packet](../clone/bin/verify-packet:109)). This packet replaces "Why This Belongs Here" and "Memory Decision" with one "Status" section, and it still passes.
6. **`.gitignore` ignores `examples/`.** The skill names an `examples/` folder as a possible committed home for packets ([skills/analyze-repo.md](../clone/skills/analyze-repo.md:180)), but this repo ignores that folder ([.gitignore](../clone/.gitignore:21)). An example packet placed there needs `git add -f` or a change to the ignore file. The ignore file also names `bin/update-repo-index`, `repos.json`, `evals/`, and `docs/`, which are not in the tracked tree ([.gitignore](../clone/.gitignore:18)).
7. **The README says there is no example packet** ([README.md](../clone/README.md:107)). That line becomes stale when this packet is published.
8. **The scan flags itself.** Most security hits on this repo are the script's own patterns and the audit skill's examples. The README warns that many hits are noise ([README.md](../clone/README.md:100)).
9. **Nothing forces the agent to obey.** The README says so plainly ([README.md](../clone/README.md:84), [README.md](../clone/README.md:97)). There is no test suite ([AGENTS.md](../clone/AGENTS.md:16)) and no CI workflow in the tracked files.
