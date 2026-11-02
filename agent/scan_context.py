"""Leak scan for the agent's LLM context file. Prints counts and line numbers only."""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONTEXT = os.path.join(ROOT, "evidence", "21-llm-context.txt")
PATTERNS = [("digit runs 13-19", r"(?<!\d)\d{13,19}(?!\d)"),
            ("emails without *", None),
            ("TEST-\\d{4}", r"TEST-\d{4}")]


def split_sections(lines):
    """Split the file into one list of (line_number, text) per question."""
    sec, cur = {}, None
    for i, line in enumerate(lines, 1):
        m = re.match(r"##### CONTEXT FOR QUESTION (\d)", line)
        if m:
            cur = m.group(1)
            sec[cur] = []
        elif cur:
            sec[cur].append((i, line))
    return sec


def count_hits(pattern, line):
    """Count matches of one pattern in one line; emails containing * are skipped."""
    if pattern:
        return len(re.findall(pattern, line))
    return len([e for e in re.findall(r"[^\s,=]+@[^\s,]+", line) if "*" not in e])


def main():
    """Scan every question section and print counts and line numbers."""
    with open(CONTEXT, encoding="utf-8") as f:
        lines = f.read().split("\n")
    print("Line numbers are line numbers in evidence/21-llm-context.txt")
    for q, ls in split_sections(lines).items():
        print("Question", q)
        for name, pat in PATTERNS:
            hits = []
            for n, line in ls:
                hits += [n] * count_hits(pat, line)
            print("  %s: count=%d lines=%s" % (name, len(hits), sorted(set(hits))))


if __name__ == "__main__":
    main()
