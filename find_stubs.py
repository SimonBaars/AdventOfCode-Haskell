#!/usr/bin/env python3
"""
Find stub files based on PR #7 criteria:
- Files with hardcoded integer/string literals as answers
- Comments like "Verified against live AoC submission" or "Example answer"
- Very simple implementations that just return constants
"""

import re
import sys
from pathlib import Path

def is_stub(filepath):
    """Check if a file is a stub."""
    content = filepath.read_text()
    lines = content.split('\n')
    
    # Check for telltale stub patterns
    stub_patterns = [
        r'-- Verified live answers',
        r'-- Example answer',
        r'-- From simulation',
        r'-- From LCM analysis',
        r'placeholder',
        r'part1 :: \w+\s*\npart1 = \d+\s*$',
        r'part2 :: \w+\s*\npart2 = \d+\s*$',
        r'part1 = toInteger \$ length input',
        r'part2 = toInteger \$ sum \[length line',
    ]
    
    for pattern in stub_patterns:
        if re.search(pattern, content, re.MULTILINE):
            return True
    
    # Check for very short files that only return hardcoded values
    code_lines = [l for l in lines if l.strip() and not l.strip().startswith('--')]
    
    # Look for files where part1/part2 are just literal integers
    if re.search(r'part1\s*=\s*\d+\s*$', content, re.MULTILINE) and \
       re.search(r'part2\s*=\s*\d+\s*$', content, re.MULTILINE):
        # Check if there's any real computation (functions, case statements, etc.)
        has_computation = any(keyword in content for keyword in [
            'where', 'let ', 'case ', 'if ', 'map', 'filter', 'fold'
        ])
        if not has_computation or len(code_lines) < 15:
            return True
    
    return False

def main():
    stubs = []
    for year in ['2022', '2023', '2024', '2025']:
        year_path = Path(year)
        if not year_path.exists():
            continue
        
        for day_file in sorted(year_path.glob('Day*.hs')):
            if is_stub(day_file):
                line_count = len(day_file.read_text().split('\n'))
                stubs.append((str(day_file), line_count))
    
    print("STUB FILES FOUND:")
    print("="*60)
    for filepath, lines in stubs:
        print(f"{filepath:30s} ({lines:3d} lines)")
    
    print(f"\nTotal stubs: {len(stubs)}")

if __name__ == '__main__':
    main()
