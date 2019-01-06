# git-utils

## `git-fetch-ui`

Proxies to `git fetch` parses the results for branch names, then
presents an interactive list of branch names to choose one to `git checkout`.

## `git-checkout-recent`

Presents a list of recently checkout branches to select one to checkout again.
Uses the relevant line in `git reflog` to find your previously visited branches.
