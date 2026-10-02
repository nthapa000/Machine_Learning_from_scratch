"""Run every query in queries.sql against a fresh copy of schema.sql (SQLite) and write
gen/<id>.sql (the query) and gen/<id>.txt (the printed result) for the LaTeX book."""
import re, sqlite3, pathlib, sys

HERE = pathlib.Path(__file__).parent
SCHEMA = (HERE / "schema.sql").read_text()

def blocks():
    text = (HERE / "queries.sql").read_text()
    for m in re.finditer(r"^-- @(\w+)\n(.*?)(?=^-- @|\Z)", text, re.S | re.M):
        yield m.group(1), m.group(2).strip()

def fmt(cols, rows):
    def s(v):
        if v is None: return "NULL"
        if isinstance(v, float): return f"{v:.10g}"
        return str(v)
    rows = [[s(v) for v in r] for r in rows]
    w = [max([len(c)] + [len(r[i]) for r in rows]) for i, c in enumerate(cols)]
    line = lambda r: " | ".join(x.ljust(w[i]) for i, x in enumerate(r)).rstrip()
    out = [line(cols), "-+-".join("-" * x for x in w)] + [line(r) for r in rows]
    out.append(f"({len(rows)} row{'s' if len(rows) != 1 else ''})")
    return "\n".join(out)

def run(sql):
    con = sqlite3.connect(":memory:")
    con.executescript(SCHEMA)
    stmts = [s.strip() for s in re.split(r";\s*\n", sql.strip().rstrip(";") + ";\n") if s.strip()]
    for s in stmts[:-1]:
        con.execute(s)
    cur = con.execute(stmts[-1])
    if cur.description is None:
        return "(statement executed)"
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    if stmts[-1].upper().startswith("EXPLAIN QUERY PLAN"):
        return "\n".join("QUERY PLAN: " + r[-1] for r in rows)
    return fmt(cols, rows)

if __name__ == "__main__":
    gen = HERE / "gen"; gen.mkdir(exist_ok=True)
    only = sys.argv[1:]
    for qid, sql in blocks():
        if only and qid not in only: continue
        res = run(sql)
        (gen / f"{qid}.sql").write_text(sql + "\n")
        (gen / f"{qid}.txt").write_text(res + "\n")
        print(f"== {qid}\n{res}\n")
