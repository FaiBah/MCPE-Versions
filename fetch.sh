#!/data/data/com.termux/files/usr/bin/bash

set -e

BASE="https://mcpelife.com/download/"
OUT="versions.json"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

command -v curl >/dev/null || {
    echo "Install: pkg install curl" >&2
    exit 1
}

command -v python >/dev/null || {
    echo "Install: pkg install python" >&2
    exit 1
}

curl -fsSL --compressed -A "Mozilla/5.0" "$BASE" -o "$TMP"

python - "$TMP" "$BASE" "$OUT" <<'PY'
import sys,re,json,html
from urllib.parse import urljoin
from urllib.request import Request,urlopen

FILE,BASE,OUT=sys.argv[1:4]
UA="Mozilla/5.0"
seen=set()
stable=[]
preview=[]

link_re=re.compile(r'<a\b([^>]*)>(.*?)</a>',re.I|re.S)
version_re=re.compile(
    r'\b(Release|Beta)\s+Minecraft\s+'
    r'([0-9]+(?:\.[0-9]+){1,3})\b',
    re.I
)
href_re=re.compile(r'href\s*=\s*["\']([^"\']+)',re.I)
tag_re=re.compile(r'<[^>]+>')
next_re=re.compile(r'\bNext\b',re.I)

def fetch(url):
    req=Request(url,headers={"User-Agent":UA})
    with urlopen(req,timeout=20) as r:
        return r.read().decode("utf-8","ignore")

def clean(s):
    s=html.unescape(s)
    s=re.sub(
        r'<script\b.*?</script>|<style\b.*?</style>',
        ' ',s,flags=re.I|re.S
    )
    return re.sub(r'\s+',' ',tag_re.sub(' ',s)).strip()

def parse(src,url):
    nxt=None

    for attrs,body in link_re.findall(src):
        text=clean(body)
        m=version_re.search(text)

        if m:
            version=m.group(2)
            target=stable if m.group(1).lower()=="release" else preview

            if version not in target:
                target.append(version)

        elif next_re.search(text):
            h=href_re.search(attrs)
            if h:
                nxt=urljoin(url,html.unescape(h.group(1)))

    return nxt

src=open(FILE,encoding="utf-8",errors="ignore").read()
url=BASE

while url and url not in seen:
    seen.add(url)
    url=parse(src,url)

    if url:
        src=fetch(url)

data={
    "stable":stable[0] if stable else None,
    "preview":preview[0] if preview else None,
    "versions":stable,
    "preview_versions":preview
}

with open(OUT,"w",encoding="utf-8") as f:
    json.dump(data,f,indent=2,ensure_ascii=False)
    f.write("\n")

print(
    f"Saved {len(stable)} stable, "
    f"{len(preview)} preview -> {OUT}"
)
PY
