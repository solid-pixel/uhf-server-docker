import importlib.util
import json
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path
from unittest.mock import patch
from urllib.error import URLError

spec = importlib.util.spec_from_file_location("pulls", Path(__file__).parents[1] / "docker-pulls.py")
pulls = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pulls)


def date(day, hour=23):
    return datetime(2026, 10, day, hour, tzinfo=timezone.utc)


class DockerPullsTests(unittest.TestCase):
    def test_same_day_replaces_observation_and_missing_days_stay_missing(self):
        points = pulls.record([], 100, date(20))
        points = pulls.record(points, 105, date(20))
        points = pulls.record(points, 120, date(23))
        self.assertEqual([p['pull_count'] for p in points], [105, 120])
        html = pulls.section(points, True)
        self.assertIn('+15 over 72.0 hours', html)
        self.assertIn('Baseline', html)
        self.assertIn('<svg', html)

    def test_counter_decrease_is_not_a_negative_pull_estimate(self):
        points = pulls.record(pulls.record([], 100, date(20)), 20, date(21))
        self.assertIn('Counter decreased; change unavailable', pulls.section(points, True))

    def test_invalid_counts_are_rejected(self):
        for count in (-1, True, '100', None, 1.5):
            with self.subTest(count=count), self.assertRaises(ValueError):
                pulls.record([], count, date(20))

    def test_first_observation_has_no_invented_growth(self):
        html = pulls.section(pulls.record([], 100, date(20)), True)
        self.assertIn('Baseline', html)
        self.assertIn('after a second day', html)
        self.assertNotIn('+100', html)

    def setup_site(self, root):
        site = root / 'site'
        site.mkdir()
        for name in ('index.html', 'report.html'):
            (site / name).write_text('<header>Report</header><p>GitHub charts</p>')
        return site

    def test_hub_outage_preserves_history_and_publishes_stale_notice(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            history = root / 'pulls.json'
            history.write_text(json.dumps({'repository': pulls.REPOSITORY, 'snapshots': pulls.record([], 100, date(20))}))
            original = history.read_bytes()
            site = self.setup_site(root)
            with patch.object(pulls, 'urlopen', side_effect=URLError('offline')):
                pulls.collect(history, site)
            self.assertEqual(history.read_bytes(), original)
            self.assertIn('last saved observation', (site / 'index.html').read_text())
            self.assertIn('GitHub charts', (site / 'report.html').read_text())

    def test_first_run_outage_does_not_archive_zero(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            site = self.setup_site(root)
            history = root / 'pulls.json'
            with patch.object(pulls, 'urlopen', side_effect=URLError('offline')):
                pulls.collect(history, site)
            self.assertFalse(history.exists())
            self.assertIn('No snapshots collected yet', (site / 'index.html').read_text())

    def test_success_archives_valid_counter_and_preserves_report(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            site = self.setup_site(root)
            payload = root / 'response.json'
            payload.write_text(json.dumps({'namespace': 'solidpixel', 'name': 'uhf-server', 'pull_count': 123}))
            with patch.object(pulls, 'urlopen', return_value=payload.open()):
                pulls.collect(root / 'data/pulls.json', site)
            data = json.loads((root / 'data/pulls.json').read_text())
            self.assertEqual(data['snapshots'][0]['pull_count'], 123)
            self.assertEqual(data, json.loads((site / 'docker-pulls.json').read_text()))
            self.assertIn('123 total pulls', (site / 'index.html').read_text())

    def test_corrupt_history_is_not_silently_replaced(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            history = root / 'pulls.json'
            history.write_text('{broken')
            with self.assertRaises(ValueError):
                pulls.collect(history, self.setup_site(root))
            self.assertEqual(history.read_text(), '{broken')


if __name__ == '__main__':
    unittest.main()
