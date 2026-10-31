"""Puts a robot's report into its Control Room command (so the owner reads it in the Control Room, not on GitHub).

   python3 robots/dispatcher/report.py --id COMMAND_ID --file writer-report.md

Env: SUPABASE_SECRET_KEY. Never fails the robot run: any problem is printed and the script exits 0.
"""
import argparse, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dispatcher as D


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--id', required=True); ap.add_argument('--file', required=True); a = ap.parse_args()
    if not a.id.strip().isdigit(): print('no command id, nothing to do'); return
    try:
        with open(a.file, encoding='utf8') as f: text = f.read()
    except OSError: text = 'रिपोर्ट नहीं बनी (robot रिपोर्ट से पहले रुक गया)।'
    try:
        print(D.rpc('cmd_set', {'p_id': int(a.id), 'p': {'report': text[:20000]}}))
    except Exception as e:
        print('report not saved:', D.hide(e))


if __name__ == '__main__':
    main()
