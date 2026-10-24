#!/usr/bin/env python3
"""Archive Docker Hub's public counter and augment the generated Pages report."""

import argparse
import json
import sys
from datetime import datetime, timezone
from html import escape
from pathlib import Path
from urllib.error import URLError
from urllib.request import Request, urlopen

REPOSITORY = "solidpixel/uhf-server"
API = f"https://hub.docker.com/v2/repositories/{REPOSITORY}/"


def validate_count(count):
    if type(count) is not int or count < 0:
        raise ValueError("Docker pull count must be a non-negative integer")
    return count


def read_history(path):
    if not path.exists():
        return []
    data = json.loads(path.read_text())
    if data["repository"] != REPOSITORY:
        raise ValueError("Unexpected repository in Docker history")
    points = data["snapshots"]
    days = []
    for point in points:
        stamp = datetime.fromisoformat(point["observed_at"])
        if stamp.utcoffset() != timezone.utc.utcoffset(stamp):
            raise ValueError("History timestamps must be UTC")
        days.append(stamp.date())
        validate_count(point["pull_count"])
    if days != sorted(set(days)):
        raise ValueError("History must contain ordered, unique UTC days")
    return points


def record(points, count, now):
    """Keep the latest observation per UTC day, without inventing missing days."""
    validate_count(count)
    if points and now.date().isoformat() < points[-1]["observed_at"][:10]:
        raise ValueError("Refusing to record a snapshot before existing history")
    point = {"observed_at": now.isoformat(timespec="seconds"), "pull_count": count}
    if points and points[-1]["observed_at"][:10] == point["observed_at"][:10]:
        return points[:-1] + [point]
    return points + [point]


def chart(points):
    if len(points) < 2:
        return "<p>The trend will appear after a second day of collection.</p>"
    times = [datetime.fromisoformat(p["observed_at"]).timestamp() for p in points]
    counts = [p["pull_count"] for p in points]
    low, high = min(counts), max(counts)
    coords = [
        (90 + 600 * (t - times[0]) / (times[-1] - times[0]),
         160 - 130 * (count - low) / max(high - low, 1))
        for t, count in zip(times, counts)
    ]
    line = " ".join(f"{x:.1f},{y:.1f}" for x, y in coords)
    return f'''<svg viewBox="0 0 720 210" role="img" aria-labelledby="docker-chart-title"
      style="width:100%;max-width:720px;height:auto">
      <title id="docker-chart-title">Docker Hub cumulative pull counter over time</title>
      <path d="M90 20 V160 H690" fill="none" stroke="currentColor"/>
      <polyline points="{line}" fill="none" stroke="#0969da" stroke-width="3"/>
      <g fill="currentColor" font-size="12">
        <text x="4" y="35">{high:,}</text><text x="4" y="160">{low:,}</text>
        <text x="90" y="190">{points[0]['observed_at'][:10]}</text>
        <text x="690" y="190" text-anchor="end">{points[-1]['observed_at'][:10]}</text>
      </g></svg>'''


def section(points, fresh):
    intro = '''<section id="docker-pulls"><h2>Docker pulls</h2>
    <p>Public counter for <a href="https://hub.docker.com/r/solidpixel/uhf-server">solidpixel/uhf-server</a>.
    Pulls include repeat and automated activity; they do not measure unique users or active installations.</p>'''
    if not points:
        return intro + "<p>Docker Hub is unavailable. No snapshots collected yet.</p></section>"
    latest = points[-1]
    stale = "" if fresh else "<p><strong>Docker Hub could not be refreshed. Showing the last saved observation.</strong></p>"
    rows = []
    for i in range(max(0, len(points) - 30), len(points)):
        point = points[i]
        change = "Baseline"
        if i:
            delta = point["pull_count"] - points[i - 1]["pull_count"]
            elapsed = (datetime.fromisoformat(point["observed_at"]) -
                       datetime.fromisoformat(points[i - 1]["observed_at"])).total_seconds() / 3600
            change = f"+{delta:,} over {elapsed:.1f} hours" if delta >= 0 else "Counter decreased; change unavailable"
        rows.append(f"<tr><td>{escape(point['observed_at'])}</td><td>{point['pull_count']:,}</td><td>{change}</td></tr>")
    return intro + stale + f'''<p><strong>{latest['pull_count']:,} total pulls</strong><br>
    Last observed: {escape(latest['observed_at'])} (UTC)</p>
    {chart(points)}
    <p>History starts {points[0]['observed_at'][:10]}. Changes cover the interval between observations,
    which may span missed days. Past daily counts cannot be recovered from this counter.</p>
    <table><thead><tr><th>Observed at (UTC)</th><th>Total pulls</th><th>Since previous snapshot</th></tr></thead>
    <tbody>{''.join(reversed(rows))}</tbody></table>
    <p>Latest 30 observations shown. <a href="docker-pulls.json">Download all Docker snapshots (JSON)</a>.
    The PDF report covers GitHub statistics only.</p></section>'''


def collect(history, site):
    points = read_history(history)
    fresh = False
    try:
        request = Request(API, headers={"User-Agent": "uhf-server-docker-stats", "Accept": "application/json"})
        with urlopen(request, timeout=30) as response:
            payload = json.load(response)
        count = validate_count(payload["pull_count"])
        if payload["namespace"] != "solidpixel" or payload["name"] != "uhf-server":
            raise ValueError("Unexpected Docker Hub repository")
    except (URLError, TimeoutError, ValueError, KeyError, TypeError, OSError):
        print("::warning::Docker Hub counter unavailable; retaining existing history.", file=sys.stderr)
    else:
        points = record(points, count, datetime.now(timezone.utc))
        fresh = True

    data = json.dumps({"repository": REPOSITORY, "snapshots": points}, indent=2) + "\n"
    if fresh:
        history.parent.mkdir(parents=True, exist_ok=True)
        temporary = history.with_suffix(".tmp")
        temporary.write_text(data)
        temporary.replace(history)
    (site / "docker-pulls.json").write_text(data)
    for filename in ("index.html", "report.html"):
        target = site / filename
        html = target.read_text()
        if html.count("</header>") != 1 or 'id="docker-pulls"' in html:
            raise ValueError("Unexpected report layout; refusing to omit or duplicate Docker section")
        target.write_text(html.replace("</header>", "</header>\n" + section(points, fresh), 1))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--history", type=Path, required=True)
    parser.add_argument("--site", type=Path, required=True)
    args = parser.parse_args()
    collect(args.history, args.site)
