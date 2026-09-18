# repo-analyzer — source map

Pinned commit: `b5ed1cda154ab2b31a272b188e7ee85bfbb072dd` (`b5ed1cd`), branch `main`, read 2026-09-18.
All 10 tracked files are listed. Line counts are from the clone.

## `bin/` — the tools

### [bin/repo-signals](../clone/bin/repo-signals:1) (232 lines, Python 3, standard library only)

| Lines | What |
|-------|------|
| [19](../clone/bin/repo-signals:19) | `IGNORE_DIRS`: folders dropped from the file list |
| [21](../clone/bin/repo-signals:21) | `RUNTIME_BY_EXT`: extension to language table |
| [34](../clone/bin/repo-signals:34) | `AUTO_WAIVABLE_DIRS`: editor and CI folders |
| [36](../clone/bin/repo-signals:36) | thresholds: 5 files per runtime, 40% dominant share, depth 3 |
| [47](../clone/bin/repo-signals:47) | `SECURITY_CONTENT_PATTERNS`: seven content regexes |
| [56](../clone/bin/repo-signals:56) | `SECURITY_PATH_PATTERNS`: three path regexes |
| [65](../clone/bin/repo-signals:65) | `SECURITY_QUESTIONS`: the question attached to each category |
| [74](../clone/bin/repo-signals:74) | caps: 20 hits per category, 262144 bytes per file |
| [78](../clone/bin/repo-signals:78) | `git_files()`: `git ls-files -z`, sorted, existing files only |
| [90](../clone/bin/repo-signals:90) | `walk_files()`: fallback for a folder that is not a git checkout |
| [99](../clone/bin/repo-signals:99) | `ext_of()`: extension, empty for extensionless and dot files |
| [106](../clone/bin/repo-signals:106) | `count_by_dir()`: file counts per directory under a prefix |
| [121](../clone/bin/repo-signals:121) | `enumerate_subsystems()`: the coverage-contract list |
| [140](../clone/bin/repo-signals:140) | `scan_security()`: hits plus the `skipped` report |
| [184](../clone/bin/repo-signals:184) | `main()`: argument check, tier rule at [207](../clone/bin/repo-signals:207), JSON output at [215](../clone/bin/repo-signals:215) |

### [bin/verify-packet](../clone/bin/verify-packet:1) (133 lines, Python 3, standard library only)

| Lines | What |
|-------|------|
| [27](../clone/bin/verify-packet:27) | `REQUIRED_PAGES`: the three dated page patterns |
| [29](../clone/bin/verify-packet:29) | `ANCHOR_RE`: matches relative links into `clone/`; the line number is optional |
| [30](../clone/bin/verify-packet:30) | `GITHUB_RE`: hosted `/blob/` URLs, counted as failures |
| [37](../clone/bin/verify-packet:37) | `line_count()`: counts a last line with no newline |
| [46](../clone/bin/verify-packet:46) | argument parsing (see the `--min-anchor-rate` finding) |
| [57](../clone/bin/verify-packet:57) | check 1, shape; stops early if `clone/` is not a git checkout |
| [68](../clone/bin/verify-packet:68) | check 2, pinned SHA in every `*.md` page |
| [75](../clone/bin/verify-packet:75) | check 3, anchors; blocks paths that leave the clone at [87](../clone/bin/verify-packet:87) |
| [98](../clone/bin/verify-packet:98) | check 4, coverage; finds `repo-signals` beside itself, then on PATH |
| [124](../clone/bin/verify-packet:124) | `report()`: failure lines, the summary line, exit code |

## `skills/` — the prompts

### [skills/analyze-repo.md](../clone/skills/analyze-repo.md:1) (198 lines)

| Lines | What |
|-------|------|
| [3](../clone/skills/analyze-repo.md:3) | purpose, input, output |
| [20](../clone/skills/analyze-repo.md:20) | untrusted-input rule |
| [27](../clone/skills/analyze-repo.md:27) | re-run rule: archive the old packet, then redo from scratch |
| [34](../clone/skills/analyze-repo.md:34) | Stage 1 Acquire |
| [47](../clone/skills/analyze-repo.md:47) | Stage 2 Scan |
| [67](../clone/skills/analyze-repo.md:67) | Stage 3 Route, with the tier table |
| [87](../clone/skills/analyze-repo.md:87) | Stage 4 Plan, with the coverage contract and required pages |
| [110](../clone/skills/analyze-repo.md:110) | Stage 5 Generate, grounding rules, install page rules at [129](../clone/skills/analyze-repo.md:129) |
| [141](../clone/skills/analyze-repo.md:141) | fan-out advice for large repos |
| [148](../clone/skills/analyze-repo.md:148) | Stage 6 Verify, persist, index; README sections at [168](../clone/skills/analyze-repo.md:168) |
| [184](../clone/skills/analyze-repo.md:184) | guidelines |

### [skills/audit-repo-security.md](../clone/skills/audit-repo-security.md:1) (108 lines)

| Lines | What |
|-------|------|
| [11](../clone/skills/audit-repo-security.md:11) | stance: six rules |
| [43](../clone/skills/audit-repo-security.md:43) | step 1, acquire and pin |
| [51](../clone/skills/audit-repo-security.md:51) | step 2, seed list from `repo-signals` |
| [60](../clone/skills/audit-repo-security.md:60) | step 3, six standing dimensions |
| [84](../clone/skills/audit-repo-security.md:84) | step 4, verdict |
| [90](../clone/skills/audit-repo-security.md:90) | step 5, verify and persist |
| [103](../clone/skills/audit-repo-security.md:103) | relationship to `/analyze-repo` |

## Root files

| File | What |
|------|------|
| [install.sh](../clone/install.sh:1) | 47 lines. `link()` helper at [9](../clone/install.sh:9); three link loops at [21](../clone/install.sh:21), [27](../clone/install.sh:27), [33](../clone/install.sh:33); PATH note at [39](../clone/install.sh:39) |
| [README.md](../clone/README.md:1) | 118 lines. Skills at [18](../clone/README.md:18), data layout at [37](../clone/README.md:37), install at [53](../clone/README.md:53), what it touches at [79](../clone/README.md:79), limitations at [93](../clone/README.md:93) |
| [AGENTS.md](../clone/AGENTS.md:1) | 37 lines. Commands at [6](../clone/AGENTS.md:6), conventions at [19](../clone/AGENTS.md:19), prohibitions at [30](../clone/AGENTS.md:30) |
| [CLAUDE.md](../clone/CLAUDE.md:1) | 1 line. Imports `AGENTS.md` |
| [LICENSE](../clone/LICENSE:1) | 21 lines. MIT |
| [.gitignore](../clone/.gitignore:1) | 24 lines. `data/` at [3](../clone/.gitignore:3); other local folders at [18](../clone/.gitignore:18) |

## Absent

No package manifest, no lockfile, no tests, no CI workflow, no version tag in the clone.
