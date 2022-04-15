from pathlib import Path
from collections import Counter
import sys
from tqdm import tqdm
import json
import magic

# detect file encoding. If ANSI (magic can't identify), specify that its ANSI
def detect_file_encoding(path):
    blob = open(path, 'rb').read()
    m = magic.Magic(mime_encoding=True)
    encoding = m.from_buffer(blob)
    if encoding=='unknown-8bit':
        encoding='ANSI'
    return encoding

corpus = Path(sys.argv[1])
outfile = Path(sys.argv[2])

counts = {}
fs = list(corpus.glob("*.txt"))
print(fs)
for f in fs:
    name = f.stem
    counts[name] = {}
    
    encoding = detect_file_encoding(f)
    with open(f, encoding=encoding) as fp:
        for line in tqdm(fp):
            hist = Counter(line.split())
            for k in hist:
                if k not in counts[name]:
                    counts[name][k] = 0
                counts[name][k] += hist[k]
                
json.dump(counts, open(outfile, 'w'))