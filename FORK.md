# alexanderjerome/nixops4: a contributing fork

This is a fork of [nixops4/nixops4](https://github.com/nixops4/nixops4) used for
two things at once: contributing changes upstream, and running NixOps4 with
those changes before (or regardless of whether) upstream merges them.

This file and `fork/` exist only on the `integration` branch. They are never
part of a pull request upstream.

## Branches

| Branch | Based on | Purpose | Pull requests go to |
|---|---|---|---|
| `main` | upstream `main`, kept identical | clean base; no commits of our own | — |
| `tfproto` | upstream `tfproto` (PR #150), kept identical | base for small fixes to the Terraform provider adapter | — |
| `tfproto-*` | `tfproto` | one item of PR #150's task list each | upstream `tfproto` |
| `state-postgres`, `state-s3` | `main` | shared state providers | upstream `main` |
| `plan-preview` | `main` | a plan/preview command (design agreed in an issue first) | upstream `main` |
| `drift` | `main` | drift detection (upstream issue #161) | upstream `main` |
| `integration` | `main` + `tfproto` + the topic branches | what we build and run | never upstream |

Rules:

- Never commit to `main` or `tfproto`; they mirror upstream. Upstream force-pushes
  `tfproto`, so `tfproto-*` branches are kept small and rebased after it moves.
- One concern per topic branch, with tests, so each pull request is easy to review.
- Pull requests disclose that the work was done with AI assistance, and every line
  is reviewed and understood by the person submitting it.
- `integration` is rebuilt, not hand-edited: `fork/update-integration.sh`.
  When upstream merges a topic branch, drop it from the script's list.

## Using it

    inputs.nixops4.url = "github:alexanderjerome/nixops4/integration";
