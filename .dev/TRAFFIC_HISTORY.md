# GitHub traffic history

This workflow uses [github-repo-stats](https://github.com/jgehrcke/github-repo-stats) v1.4.2, pinned to a commit, to preserve daily traffic snapshots and generate HTML/PDF reports on the separate `github-repo-stats` branch. After each successful collection, it publishes the latest report to GitHub Pages.

## Activation

1. Create a fine-grained personal access token scoped only to `solid-pixel/uhf-server-docker`.
2. Give it repository **Administration: read** (GitHub's traffic API requirement), **Contents: read and write** (to save snapshots on the data branch), and the automatically included metadata read permission. Set an expiry and plan to renew the secret before expiry.
3. Store the token as the repository Actions secret `GHRS_GITHUB_API_TOKEN`. Do not paste it into an issue, PR, chat, or committed file.
4. In **Settings → Pages → Build and deployment**, set **Source** to **GitHub Actions**. This is a one-time repository setting; the workflow does not enable Pages itself.
5. Merge this workflow into the default branch, then run **Actions → Preserve GitHub traffic history → Run workflow** on the default branch. Runs on other branches are skipped.
6. Verify that the `snapshot` job generated the data branch and reports, and that the `publish` job completed a `github-pages` deployment. Open the deployment URL and check that the charts render and `report.pdf` downloads.
7. The workflow then collects and publishes daily at 23:23 UTC. GitHub may delay scheduled runs.

The action creates the data branch if absent. It does not deploy the application or change its container release workflow. Without the secret, it skips both collection and publication and emits a notice. An invalid or expired token causes the collector to fail.

## Dashboard

After the first successful deployment, the dashboard is available at:

**https://solid-pixel.github.io/uhf-server-docker/**

The PDF is available at **https://solid-pixel.github.io/uhf-server-docker/report.pdf**. If a custom Pages domain is configured, use the URL shown by the deployment instead.

Only the generated `latest-report` directory is uploaded to Pages, with `report.html` also served as `index.html`. Raw snapshots remain on the data branch. The publication job uses GitHub's temporary workflow token with Pages and identity-token permissions; the traffic token does not need additional permissions.

If collection or report preparation fails, publication is skipped and the previous dashboard stays available. If Pages is not configured or deployment fails, the collected history still remains on the data branch. Fix the Pages setting or deployment error, then rerun the workflow. A green run with collection skipped because the secret is missing does not mean a dashboard was published.

## Visibility and interpretation

The snapshots and reports will be public because this repository is public. They contain aggregate traffic and public GitHub activity, not visitor IP addresses or identities. The Pages dashboard is public as well.

The first API run can collect only the latest 14 days. Older traffic cannot be recovered unless a previous service already archived it. Never add daily or rolling unique-visitor/cloner counts to claim lifetime unique users. Clones can include automated activity and do not measure active installations.

Docker pull history is being collected separately; this action is for GitHub traffic.

## Baseline observed on 2026-10-24

The signed-in GitHub traffic dashboard displayed October 10–23:
- 73 clones; 49 unique cloners
- 99 page views; 51 unique visitors

These are dashboard totals, not counts of product users. A separate private snapshot retains the per-day points.

## Validation and limitations

Workflow structure and pinned action inputs were checked against upstream v1.4.2 and GitHub Pages documentation. A live run requires the repository secret, Pages configured to use GitHub Actions, and this workflow on the default branch. Successful collection, chart rendering, PDF download, publication, and scheduled execution must be verified after activation.
