#!/usr/bin/env bash
# Rebuild `integration` from upstream: mirror main and tfproto, then merge the
# topic branches on top of main. Conflicts resolved once are remembered (rerere).
# Run from a clone with `upstream` = nixops4/nixops4 and `origin` = the fork.
set -euo pipefail
TOPICS=(tfproto state-postgres state-s3 plan-preview drift)

git config rerere.enabled true
git fetch upstream '+refs/heads/*:refs/remotes/upstream/*'
git fetch origin
git branch -f main upstream/main
git branch -f tfproto upstream/tfproto

keep=$(mktemp -d)
git show origin/integration:FORK.md >"$keep/FORK.md"
git show origin/integration:fork/update-integration.sh >"$keep/update-integration.sh"

git checkout -B integration upstream/main
for t in "${TOPICS[@]}"; do
  ref=$t; [[ $t == tfproto ]] && ref=upstream/tfproto
  # Skip a topic with nothing beyond main (not started, or merged upstream).
  if [[ -z $(git rev-list "upstream/main..$ref") ]]; then echo "skip $t"; continue; fi
  git merge --no-ff --no-edit -m "integration: merge $t" "$ref"
done

mkdir -p fork
cp "$keep/FORK.md" FORK.md
cp "$keep/update-integration.sh" fork/update-integration.sh
git add FORK.md fork/update-integration.sh
git commit -m "integration: fork policy and tooling"
echo "integration rebuilt; review, then: git push --force-with-lease origin main tfproto integration"
