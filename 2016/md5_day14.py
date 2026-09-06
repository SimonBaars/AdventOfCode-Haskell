#!/usr/bin/env python3
import hashlib, sys
from collections import defaultdict
salt = open(sys.argv[1]).read().strip()
stretch = sys.argv[2] == "2"

def md5(s):
    return hashlib.md5(s.encode()).hexdigest()

def hash_at(i):
    h = md5(salt + str(i))
    if stretch:
        for _ in range(2016):
            h = md5(h)
    return h

def triple(h):
    for a,b,c in zip(h, h[1:], h[2:]):
        if a==b==c:
            return a
    return None

# generate hashes on demand with window
cache = {}
def get(i):
    if i not in cache:
        cache[i] = hash_at(i)
        # prune old
        if i > 2000 and (i-2000) in cache:
            del cache[i-2000]
    return cache[i]

keys = []
i = 0
while len(keys) < 64:
    h = get(i)
    t = triple(h)
    if t:
        needle = t*5
        if any(needle in get(j) for j in range(i+1, i+1001)):
            keys.append(i)
    i += 1
print(keys[-1], end="")
