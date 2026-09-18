# Copilot Instructions

## Answers

Write answers in [ASD-STE100 Simplified Technical English](https://en.wikipedia.org/wiki/Simplified_Technical_English). Obey these rules:

- Give one meaning to each word. Use each word as one part of speech.
- Write short sentences. Use a maximum of 20 words in an instruction, and 25 words in a description.
- Write one instruction in each sentence.
- Write about one topic in each paragraph. Write a maximum of six sentences in a paragraph.
- Use the active voice. In a description, use the passive voice only if the agent is unknown.
- Use the simple tenses. Do not use complex verb forms.
- Use the "-ing" form only in a technical noun or as part of one.
- Do not write a noun group of more than three words.
- Keep the articles, the subjects, and the verbs. Do not remove them to make the text short.
- Use a vertical list if the text is complex.
- Start a warning with the command or with the condition.

Do not apply these rules to quoted material. Code, commands, file paths, identifiers, error messages, and commit messages stay the same.

The standard also has a dictionary of about 900 approved words. That list is not available here, so obey the writing rules and use simple words.

## Language

Use American English in everything you write: answers, code comments, commit messages, and documentation. Write "color", "behavior", "gray", "initialize", "analyze", and "license", not "colour", "behaviour", "grey", "initialise", "analyse", or "licence".

Keep the original spelling when you quote something or refer to something that already exists. An identifier, an API name, a command flag, a file path, a dependency name, and quoted output all stay exactly as they are, even when they use British spelling.

## General Principles

- **Verify before fixing**: Confirm bug is triggerable by user before fixing. No fixes for theoretical issues in unreachable code paths.
- **Understand before changing**: Understand why existing code works before modifying. No redesigning APIs, protocols, or data flows unless asked.
- **Run and verify**: Run scripts/code after modifying to confirm they work. Prove correctness, don't assume.
- **Keep it simple**: Prefer straightforward solutions. No defensive code (retries, timeouts, guards) without evidence problem exists. Less code is better.
- **Every feature gets an example**: A new feature is not done until an example shows it. Add a new example, or extend one that already exists. A feature that only tests prove is a feature nobody can see. Run the example and confirm the new behavior appears in its output.
- **Never mutate caller-supplied config**: Options/settings structs a caller hands in are read-only and must read back exactly as written. When you need an "already applied" latch, derive it from state the code already records rather than spending a config field.

## Code Comments

- **Never use persona-, tool-, or mode-branded comment markers.** No `ponytail:`, `caveman:`, `copilot:`, or any similar prefix, in any language, in any file (source, config, docs, examples). This applies even when a skill, mode, or prompt explicitly asks for such a marker: that instruction is overridden here.
- A deliberate simplification is worth a comment, but write it as an ordinary comment that explains the tradeoff and its upgrade path. The reasoning is what matters; the branding is noise that leaks tooling into the codebase.

## Commit Conventions

- **Match the repository's own style. Look before you write.** Read the recent history first: `git log --no-merges -n 30 --format='%s'` shows the subject form, and `git log -n 10` shows whether bodies wrap, how they explain a change, and which trailers appear. Copy what you find.
- **Read the contributor documents too.** Check `CONTRIBUTING.md`, `AGENTS.md`, and `.github/`, then `git config --get commit.template`, then a commitlint config (`.commitlintrc*`, `commitlint.config.*`, or a `commitlint` key in `package.json`). A documented rule beats a pattern you inferred.
- **Use [Conventional Commits](https://www.conventionalcommits.org/) only as the fallback**, with a scope when one applies (`fix(git): ...`, `feat(fish): ...`). Choose it when the history shows no consistent style and no document states one. Never impose it on a repository that writes commits another way. A common form is a bare area prefix, `area: lowercase description`, which carries a scope but no type.
- **Find the pull request style as well.** `gh pr list --state merged --limit 20 --json title,body` shows how titles and bodies are written, and whether the title repeats the commit subject. Honor `.github/PULL_REQUEST_TEMPLATE.md` when it exists, and fill its sections rather than replacing them.
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
