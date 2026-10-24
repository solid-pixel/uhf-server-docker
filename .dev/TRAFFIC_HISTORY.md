# GitHub traffic history

This workflow uses [github-repo-stats](https://github.com/jgehrcke/github-repo-stats) v1.4.2, pinned to a commit, to preserve daily traffic snapshots and generate HTML/PDF reports on the separate `github-repo-stats` branch.

## Activation

1. Create a fine-grained personal access token scoped only to `solid-pixel/uhf-server-docker`.
2. Give it repository **Administration: read** (GitHub's traffic API requirement), **Contents: read and write** (to save snapshots on the data branch), and the automatically included metadata read permission. Set an expiry and plan to renew the secret before expiry.
3. Store the token as the repository Actions secret `GHRS_GITHUB_API_TOKEN`. Do not paste it into an issue, PR, chat, or committed file.
4. Merge this workflow into the default branch, then run **Preserve GitHub traffic history** manually once and verify that the data branch and reports were generated.
5. The workflow then runs daily at 23:23 UTC. GitHub may delay scheduled runs.

The action creates the data branch if absent. It does not deploy the application or change its container release workflow. Without the secret, it skips collection and emits a notice. An invalid or expired token causes the collector to fail.

## Visibility and interpretation

The snapshots and reports will be public because this repository is public. They contain aggregate traffic and public GitHub activity, not visitor IP addresses or identities. GitHub Pages is not enabled by this workflow.

The first API run can collect only the latest 14 days. Older traffic cannot be recovered unless a previous service already archived it. Never add daily or rolling unique-visitor/cloner counts to claim lifetime unique users. Clones can include automated activity and do not measure active installations.

Docker pull history is being collected separately; this action is for GitHub traffic.

## Baseline observed on 2026-10-24

The signed-in GitHub traffic dashboard displayed October 10–23:
- 73 clones; 49 unique cloners
- 99 page views; 51 unique visitors

These are dashboard totals, not counts of product users. A separate private snapshot retains the per-day points.

## Validation and limitations

Workflow structure and pinned action inputs were checked against upstream v1.4.2. A live run still requires the repository secret. Successful collection, report generation, and scheduled execution must be verified after activation.
