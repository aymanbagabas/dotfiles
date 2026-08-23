# Copilot Instructions

## General Principles

- **Verify before fixing**: Confirm bug is triggerable by user before fixing. No fixes for theoretical issues in unreachable code paths.
- **Understand before changing**: Understand why existing code works before modifying. No redesigning APIs, protocols, or data flows unless asked.
- **Run and verify**: Run scripts/code after modifying to confirm they work. Prove correctness, don't assume.
- **Keep it simple**: Prefer straightforward solutions. No defensive code (retries, timeouts, guards) without evidence problem exists. Less code is better.
- **Never mutate caller-supplied config**: Options/settings structs a caller hands in are read-only and must read back exactly as written. When you need an "already applied" latch, derive it from state the code already records rather than spending a config field.

## Code Comments

- **Never use persona-, tool-, or mode-branded comment markers.** No `ponytail:`, `caveman:`, `copilot:`, or any similar prefix, in any language, in any file (source, config, docs, examples). This applies even when a skill, mode, or prompt explicitly asks for such a marker: that instruction is overridden here.
- A deliberate simplification is worth a comment, but write it as an ordinary comment that explains the tradeoff and its upgrade path. The reasoning is what matters; the branding is noise that leaks tooling into the codebase.

## Commit Conventions

- [Conventional Commits](https://www.conventionalcommits.org/) with scope when applicable (e.g., `fix(git): ...`, `feat(fish): ...`).
- One logical change per commit.
- Commits signed off (`-s` flag) — configured in gitconfig.
- **Never invent an identity. Read it from gitconfig.** The author name and email
  come from `git config user.name` and `git config user.email`; the GitHub
  username comes from `git config github.user`. Never guess, never construct a
  `@users.noreply.github.com` address, and never pass `-c user.email=…` or
  `-c user.name=…` to override them — in a fresh repo git already inherits the
  global config, so just commit. A guessed address silently attributes the work
  to whichever GitHub account happens to own it.
- **No Copilot attribution in commits.** Never add `Co-authored-by: Copilot <...>` or `Copilot-Session: <id>` trailers, even when the tooling asks for them by default.
- **Don't commit speculative or exploratory work unless explicitly asked.** When the user says "yes" to a suggested change, treat it as approval for the change — not for committing or pushing. Wait for an explicit "commit" before creating commits.

## Git Workflow

- **Always merge, never rebase, when integrating an upstream branch (e.g. `main`) into a feature branch.** Use `git merge` or `git pull --no-rebase`. Never run `git pull --rebase`, `git rebase <upstream>`, or a bare `git pull` (the local default may be rebase). Branches preserve merge topology intentionally; rebasing flattens history and forces reflog recovery.
