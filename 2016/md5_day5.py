#!/usr/bin/env python3
import hashlib, sys
door = open(sys.argv[1]).read().strip()
part = sys.argv[2]
if part == "1":
    out = []
    i = 0
    while len(out) < 8:
        h = hashlib.md5(f"{door}{i}".encode()).hexdigest()
        if h.startswith("00000"):
            out.append(h[5])
        i += 1
    print("".join(out), end="")
else:
    pw = [None]*8
    i = 0
    filled = 0
    while filled < 8:
        h = hashlib.md5(f"{door}{i}".encode()).hexdigest()
        if h.startswith("00000") and h[5] in "01234567":
            pos = int(h[5])
            if pw[pos] is None:
                pw[pos] = h[6]
                filled += 1
        i += 1
    print("".join(pw), end="")
