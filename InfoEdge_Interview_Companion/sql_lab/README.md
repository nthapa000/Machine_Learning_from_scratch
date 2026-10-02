# SQL Lab (companion to Part IX of the InfoEdge Interview Companion PDF)

| File | What it is |
|---|---|
| `SQL_Lab.ipynb` | Colab-ready notebook. It builds the MiniNaukri database in Python's built-in SQLite and runs every query from Chapters 45-48 (already executed, outputs saved). It ends with 15 practice exercises and their solutions. |
| `schema.sql` | The 7-table job-portal database. Runs in SQLite, PostgreSQL and MySQL 8. |
| `queries.sql` | Every query printed in the book, each labelled `-- @id` (the id is shown in the book). |
| `run_queries.py` | Runs each query on a fresh copy of the database and writes `gen/<id>.sql` and `gen/<id>.txt`, which the PDF includes verbatim. |
| `build_notebook.py` | Regenerates the notebook from `schema.sql` and `queries.sql`. |

**Open in Colab:** File -> Upload notebook -> choose `SQL_Lab.ipynb` (or File -> Open notebook -> GitHub and paste this repo's URL, branch `claude/admiring-edison-vd2vbx`). Then Runtime -> Run all. No files or installs are needed: the schema is embedded in the notebook.

**Rebuild after editing a query:**
```
python run_queries.py            # refresh outputs used by the PDF
python build_notebook.py
jupyter nbconvert --to notebook --execute --inplace SQL_Lab.ipynb
```
