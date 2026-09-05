import hashlib, sys
secret = open(sys.argv[1]).read().strip()
prefix = sys.argv[2]
i = 0
while True:
    if hashlib.md5(f"{secret}{i}".encode()).hexdigest().startswith(prefix):
        print(i)
        break
    i += 1
