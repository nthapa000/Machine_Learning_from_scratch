"""Builds EDA_Lab.ipynb (Colab-ready). Run:  python build_notebook.py
then execute:  jupyter nbconvert --to notebook --execute --inplace EDA_Lab.ipynb"""
import nbformat as nbf

import re
REPLICA = open("make_placement_replica.py").read()
REPLICA = REPLICA[REPLICA.index("def make_placement_replica"):REPLICA.index("if __name__")].rstrip() + "\n\n"
cells = []
def md(s): cells.append(nbf.v4.new_markdown_cell(s.strip("\n")))
def code(s): cells.append(nbf.v4.new_code_cell(s.replace("__REPLICA_SOURCE__\n", REPLICA).strip("\n")))

# =====================================================================
md(r"""
# EDA Lab for the InfoEdge Data Scientist Interviews
**Companion notebook to Part VIII of the InfoEdge Interview Companion PDF.**

Four complete, interview-style exploratory data analyses, each written the way you would narrate it in Round 3:

| # | Dataset | Rows | Why it is here |
|---|---|---|---|
| 1 | MBA campus placement (the dataset reported in InfoEdge Round 3) | 215 | target leakage through *salary*, score–placement patterns, small-data judgement |
| 2 | HR Analytics: job change of data scientists (real, from this repo) | 19,158 | messy categoricals, informative missingness, high-cardinality city, imbalance — very close to Naukri data |
| 3 | Titanic (real, from this repo) | 891 | interactions (sex × class), feature extraction from text (titles), group-wise imputation |
| 4 | Pima Indians diabetes (real, from this repo) | 768 | *disguised* missing values coded as 0 |

**How to use in Google Colab:** File → Upload notebook (or open from GitHub), then *Runtime → Run all*. The real datasets are read
directly from the GitHub repo. For the MBA dataset, download `Placement_Data_Full_Class.csv` from Kaggle
(“Campus Recruitment” / “Factors affecting campus placement”) and upload it to the Colab session; if it is absent, the notebook builds a
**simulated replica with the same columns** so every cell still runs. Numbers in the PDF for case 1 come from that replica.

**The habit to build:** after every output, say one sentence: *“Because I see X, I will do Y.”*
""")

code(r"""
import os, warnings
import numpy as np, pandas as pd
import matplotlib.pyplot as plt, seaborn as sns
from scipy import stats
warnings.filterwarnings("ignore")
pd.set_option("display.width", 120); pd.set_option("display.max_columns", 30)
pd.set_option("display.precision", 3)
sns.set_theme(style="whitegrid", palette="deep", font_scale=0.9)
plt.rcParams["figure.dpi"] = 110

REPO_RAW = "https://raw.githubusercontent.com/nthapa000/Machine_Learning_from_scratch/master/"
FIG_DIR = "figs"                       # figures are saved only when this folder exists (PDF build)

def load_csv(rel_path, **kw):
    # Local repo copy first (when run inside the repo), else read the public GitHub copy (Colab).
    for p in [rel_path, os.path.join("..", "..", rel_path), os.path.basename(rel_path)]:
        if os.path.exists(p):
            return pd.read_csv(p, **kw)
    return pd.read_csv(REPO_RAW + rel_path, **kw)

def save(name):
    if os.path.isdir(FIG_DIR):
        plt.savefig(f"{FIG_DIR}/{name}.png", dpi=130, bbox_inches="tight")
    plt.show()
print("pandas", pd.__version__, "| numpy", np.__version__)
""")

md(r"""
## 0. A reusable EDA toolkit
Write these once, use them on every dataset. Each function answers one interview question.
""")
code(r"""
def overview(df):
    # One row per column: type, missing %, number of unique values, an example value.
    return pd.DataFrame({
        "dtype": df.dtypes.astype(str),
        "missing": df.isna().sum(),
        "missing_%": (df.isna().mean() * 100).round(1),
        "n_unique": df.nunique(),
        "example": df.apply(lambda s: s.dropna().iloc[0] if s.notna().any() else np.nan),
    })

def num_summary(df):
    # describe() plus shape statistics and outlier counts for every numeric column.
    num = df.select_dtypes("number")
    q1, q3 = num.quantile(0.25), num.quantile(0.75)
    iqr = q3 - q1
    out = ((num < q1 - 1.5 * iqr) | (num > q3 + 1.5 * iqr)).sum()
    res = num.describe().T
    res["skew"] = num.skew(); res["kurt"] = num.kurt()
    res["n_iqr_outliers"] = out; res["n_zeros"] = (num == 0).sum()
    return res.round(2)

def rate_by(df, col, target, bins=None, q=None):
    # Target rate and count per category (or per bin of a numeric column).
    key = df[col]
    if bins is not None: key = pd.cut(key, bins)
    elif q is not None:  key = pd.qcut(key, q, duplicates="drop")
    key = key.astype(object).where(key.notna(), "MISSING")
    g = df.groupby(key, observed=True)[target].agg(rate="mean", n="size")
    return g.round(3)

def missing_vs_target(df, target):
    # Does being missing change the target rate? (informative missingness / leakage check)
    rows = []
    for c in df.columns.drop(target):
        m = df[c].isna()
        if 0 < m.sum() < len(df):
            rows.append((c, round(m.mean() * 100, 1), df.loc[m, target].mean(), df.loc[~m, target].mean()))
    return pd.DataFrame(rows, columns=["column", "missing_%", "target_rate_if_missing",
                                       "target_rate_if_present"]).round(3)

def point_biserial(df, num_cols, target):
    # Correlation of each numeric feature with a 0/1 target (Chapter 32), with p-values.
    rows = []
    for c in num_cols:
        d = df[[c, target]].dropna()
        r, p = stats.pointbiserialr(d[target], d[c])
        rows.append((c, r, p))
    return pd.DataFrame(rows, columns=["feature", "r_pb", "p_value"]).sort_values("r_pb", key=abs, ascending=False).round(4)

def cramers_v(x, y):
    # Strength of association between two categorical variables (0..1).
    t = pd.crosstab(x, y)
    chi2 = stats.chi2_contingency(t, correction=False)[0]
    k = min(t.shape) - 1
    return np.sqrt(chi2 / (t.values.sum() * k))

def vif(df_num):
    # Variance inflation factor: regress each column on the others, VIF = 1/(1-R^2).
    X = df_num.dropna().values; out = {}
    for j, c in enumerate(df_num.columns):
        y = X[:, j]; A = np.column_stack([np.ones(len(X)), np.delete(X, j, axis=1)])
        coef, *_ = np.linalg.lstsq(A, y, rcond=None)
        r2 = 1 - ((y - A @ coef) ** 2).sum() / ((y - y.mean()) ** 2).sum()
        out[c] = 1 / (1 - r2)
    return pd.Series(out, name="VIF").round(2)
print("toolkit ready")
""")

# =====================================================================
md(r"""
---
# Case 1 — MBA campus placement
**Business question:** which students get placed, and what drives it? **Target:** `status` (Placed / Not Placed).
Columns: `ssc_p` (10th %), `ssc_b` (10th board), `hsc_p` (12th %), `hsc_b`, `hsc_s` (12th stream), `degree_p`, `degree_t` (degree type),
`workex`, `etest_p` (employability test %), `specialisation` (MBA), `mba_p`, `status`, `salary` (offer, only if placed).
""")
code(r"""
__REPLICA_SOURCE__
if os.path.exists("Placement_Data_Full_Class.csv"):
    pl = pd.read_csv("Placement_Data_Full_Class.csv"); SOURCE = "REAL Kaggle file"
else:
    pl = make_placement_replica(); SOURCE = "SIMULATED replica (same schema)"
print("Data source:", SOURCE)
print(pl.shape)
pl.head()
""")

md(r"""
### 1.1 First look: structure, types, missing values
*Why:* before any statistic we confirm what one row is, which columns are numbers vs categories, and where data are missing.
""")
code(r"""
overview(pl)
""")
code(r"""
print("duplicate rows:", pl.duplicated().sum(), "| duplicate ids:", pl["sl_no"].duplicated().sum())
pct = ["ssc_p", "hsc_p", "degree_p", "etest_p", "mba_p"]
print("all percentages inside [0, 100]:", bool(((pl[pct] >= 0) & (pl[pct] <= 100)).all().all()))
print(pl["status"].value_counts(), "\n", pl["status"].value_counts(normalize=True).round(3))
""")

md(r"""
### 1.2 The salary column: why “if the package is given, we can tell whether the student was placed”
*Why:* a column that is filled only **after** the outcome is a leak. Prove it with numbers, not opinions.
""")
code(r"""
print(pl.groupby("status")["salary"].apply(lambda s: s.isna().mean()).rename("fraction_salary_missing"))
rule = np.where(pl["salary"].notna(), "Placed", "Not Placed")
print("\nAccuracy of the one-line rule 'salary present => Placed':", (rule == pl["status"]).mean())
print(pd.crosstab(pl["salary"].notna().rename("salary_present"), pl["status"]))
""")
md(r"""
**Say aloud:** *salary is missing for 100% of non-placed students and 0% of placed ones, so `salary.notna()` predicts placement perfectly.
At prediction time (before placement) salary does not exist, so it is target leakage: drop it from the placement model.*
Salary is still useful for a **different** question — what package will a placed student get — analysed next on placed students only.
""")
code(r"""
placed = pl[pl["status"] == "Placed"].copy()
s = placed["salary"]
print(s.describe().round(0))
print("skew:", round(s.skew(), 2), "| skew of log(salary):", round(np.log(s).skew(), 2))
q1, q3 = s.quantile([.25, .75]); upper = q3 + 1.5 * (q3 - q1)
print(f"IQR upper fence = {upper:,.0f}; packages above it: {(s > upper).sum()}")
fig, ax = plt.subplots(1, 3, figsize=(13, 3.4))
sns.histplot(s / 1e5, bins=20, ax=ax[0]); ax[0].set(title="Salary (lakh) — right-skewed", xlabel="lakh")
sns.histplot(np.log(s), bins=20, ax=ax[1], color="C2"); ax[1].set(title="log(salary) — closer to symmetric")
sns.boxplot(data=placed, x="workex", y=s / 1e5, ax=ax[2]); ax[2].set(title="Salary by work experience", ylabel="lakh")
plt.tight_layout(); save("pl_salary")
print(placed.groupby("workex")["salary"].median(), placed.groupby("gender")["salary"].median(), sep="\n")
""")

md(r"""
### 1.3 Univariate analysis of the scores
""")
code(r"""
num_summary(pl[pct])
""")
code(r"""
fig, axes = plt.subplots(1, 5, figsize=(15, 3))
for ax, c in zip(axes, pct):
    sns.histplot(pl[c], bins=15, kde=True, ax=ax); ax.set_title(c)
plt.tight_layout(); save("pl_hist")
""")
md(r"""
*Reading:* all five are roughly symmetric (|skew| small), within valid ranges; extreme marks are genuine toppers, not errors → **no outlier removal**.
""")

md(r"""
### 1.4 Which scores separate placed from not placed? (numeric vs binary target)
""")
code(r"""
pl["placed"] = (pl["status"] == "Placed").astype(int)
print(pl.groupby("status")[pct].mean().round(1).T, "\n")
point_biserial(pl, pct, "placed")
""")
code(r"""
fig, axes = plt.subplots(1, 5, figsize=(15, 3.2))
for ax, c in zip(axes, pct):
    sns.boxplot(data=pl, x="status", y=c, ax=ax, order=["Not Placed", "Placed"]); ax.set(title=c, xlabel="")
plt.tight_layout(); save("pl_box_by_status")
for c in pct:
    a, b = pl.loc[pl.placed == 1, c], pl.loc[pl.placed == 0, c]
    t, p = stats.ttest_ind(a, b, equal_var=False)
    print(f"{c:9s} placed mean {a.mean():5.1f} vs {b.mean():5.1f}  Welch t = {t:5.2f}, p = {p:.2g}")
""")
md(r"""
*Reading:* school (`ssc_p`, `hsc_p`) and degree percentages are much higher for placed students (boxes barely overlap);
`etest_p` and `mba_p` hardly differ. Interview insight: *the recruiter filters look at the academic track record, not the MBA score.*
""")

md(r"""
### 1.5 Placement rate by thresholds — turning EDA into a rule a placement cell can use
""")
code(r"""
print(rate_by(pl, "ssc_p", "placed", bins=[0, 55, 60, 65, 70, 75, 100]))
fig, ax = plt.subplots(figsize=(6, 3.2))
r = rate_by(pl, "ssc_p", "placed", bins=[0, 55, 60, 65, 70, 75, 100])
ax.bar(r.index.astype(str), r["rate"]); ax.set(title="Placement rate by 10th-grade %", ylabel="placement rate")
plt.xticks(rotation=30); plt.tight_layout(); save("pl_rate_ssc")
""")

md(r"""
### 1.6 Categorical features vs placement (rates, chi-square, Cramér's V)
""")
code(r"""
cats = ["gender", "ssc_b", "hsc_b", "hsc_s", "degree_t", "workex", "specialisation"]
rows = []
for c in cats:
    t = pd.crosstab(pl[c], pl["placed"])
    chi2, p, *_ = stats.chi2_contingency(t)
    rows.append((c, round(cramers_v(pl[c], pl["placed"]), 3), round(p, 4),
                 rate_by(pl, c, "placed")["rate"].to_dict()))
pd.DataFrame(rows, columns=["feature", "cramers_v", "chi2_p", "placement_rate_by_level"]).sort_values("cramers_v", ascending=False)
""")
code(r"""
fig, ax = plt.subplots(1, 3, figsize=(13, 3.2))
for a, c in zip(ax, ["workex", "specialisation", "degree_t"]):
    rate_by(pl, c, "placed")["rate"].plot(kind="bar", ax=a, rot=0, color="C0"); a.set(title=f"placement rate by {c}", ylim=(0, 1))
plt.tight_layout(); save("pl_cat_rates")
print(pd.crosstab(pl["workex"], pl["specialisation"], values=pl["placed"], aggfunc="mean").round(2))
""")
md(r"""
*Reading:* work experience and Mkt&Fin specialisation raise placement; boards make little difference (Cramér's V near 0, large p);
`degree_t = Others` has very few students, so its rate is unreliable — always show `n` beside a rate.
""")

md(r"""
### 1.7 Correlations among numeric features and multicollinearity
""")
code(r"""
corr = pl[pct + ["placed"]].corr()
plt.figure(figsize=(5.5, 4.2)); sns.heatmap(corr, annot=True, fmt=".2f", cmap="coolwarm", vmin=-1, vmax=1)
plt.title("Pearson correlation (placement data)"); save("pl_corr")
print(vif(pl[pct]))
""")
md(r"""
*Reading:* academic scores correlate moderately with each other (one ‘academic ability’ factor) but VIFs are small (< 5): no serious multicollinearity.
""")

md(r"""
### 1.8 Multivariate view and a sanity-check model
""")
code(r"""
plt.figure(figsize=(5.5, 4))
sns.scatterplot(data=pl, x="ssc_p", y="degree_p", hue="status", style="workex", s=45)
plt.title("Two strongest scores, coloured by status"); save("pl_scatter")
from sklearn.model_selection import cross_val_score, StratifiedKFold
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
X = pd.get_dummies(pl[pct + ["workex", "specialisation", "gender"]], drop_first=True).astype(float)
cv = StratifiedKFold(5, shuffle=True, random_state=0)
auc = cross_val_score(make_pipeline(StandardScaler(), LogisticRegression(max_iter=1000)), X, pl["placed"], cv=cv, scoring="roc_auc")
print("CV ROC AUC using EDA-selected features (no salary):", auc.mean().round(3), "+/-", auc.std().round(3))
""")
md(r"""
### 1.9 Findings, in the order you would say them
1. 215 students, 15 columns, no duplicates, all percentages valid; **salary is missing exactly for non-placed students → leak, drop for placement modelling.**
2. Placement is about 70% (mildly imbalanced): accuracy is usable but report precision/recall too.
3. 10th, 12th and degree percentages are the strongest drivers (point-biserial r ≈ 0.4–0.6); employability test and MBA % barely matter.
4. Work experience and Mkt&Fin specialisation raise placement; school boards do not matter.
5. Among placed students, salary is right-skewed (log it for modelling) with a few genuine high packages; higher with work experience.
6. A simple logistic regression on these features reaches CV AUC ≈ 0.9 — the EDA already told us most of the story.
""")

# =====================================================================
md(r"""
---
# Case 2 — HR Analytics: will a data-science candidate look for a job change? (REAL data)
Very close to Naukri data: candidate profile, experience, company, training hours; **target = 1** if the candidate is looking for a new job.
""")
code(r"""
hr = load_csv("Data_gathering/dataset/aug_train.csv")
print(hr.shape); hr.head()
""")
code(r"""
overview(hr)
""")
code(r"""
print("target balance:\n", hr["target"].value_counts(normalize=True).round(3))
for c in ["experience", "last_new_job", "company_size"]:
    print(f"\n{c}:", hr[c].value_counts(dropna=False).to_dict())
""")
md(r"""
*Reading:* `experience` and `last_new_job` are **numbers stored as text** with special codes (`>20`, `<1`, `never`, `>4`);
`company_size` has a malformed label **`10/49`** (should be `10-49`). 25% positives → imbalanced. Five columns have substantial missing data.
""")

md(r"""
### 2.1 Cleaning types (the bit interviewers watch you do live)
""")
code(r"""
hr["experience_num"] = hr["experience"].replace({">20": "21", "<1": "0"}).astype(float)
hr["last_new_job_num"] = hr["last_new_job"].replace({">4": "5", "never": "0"}).astype(float)
hr["company_size"] = hr["company_size"].replace({"10/49": "10-49"})
size_order = ["<10", "10-49", "50-99", "100-500", "500-999", "1000-4999", "5000-9999", "10000+"]
hr["company_size_ord"] = hr["company_size"].map({s: i for i, s in enumerate(size_order)})
print(hr[["experience_num", "last_new_job_num", "company_size_ord"]].describe().round(2))
print("duplicates ignoring id:", hr.drop(columns="enrollee_id").duplicated().sum())
""")

md(r"""
### 2.2 Missing values: random or informative?
""")
code(r"""
mv = missing_vs_target(hr[["gender", "enrolled_university", "education_level", "major_discipline",
                           "experience", "company_size", "company_type", "last_new_job", "target"]], "target")
mv.sort_values("missing_%", ascending=False)
""")
code(r"""
plt.figure(figsize=(6.5, 3.2))
m = mv.set_index("column")[["target_rate_if_missing", "target_rate_if_present"]].sort_values("target_rate_if_missing")
m.plot(kind="barh", ax=plt.gca()); plt.legend(loc="lower right", fontsize=8); plt.title("Job-change rate when a field is missing vs present"); plt.xlabel("rate")
plt.tight_layout(); save("hr_missing_vs_target")
""")
md(r"""
*Reading:* when `company_size` or `company_type` is blank, the job-change rate is about **40%** vs **~18%** when present.
Blank company fields plausibly mean *currently not employed* → a strong, legitimate signal (not MCAR).
**Decision:** do not drop these rows; encode missingness as its own category (`"Unknown"`) or add a missing indicator; tree models can use NaN directly.
""")

md(r"""
### 2.3 Numeric features: shape and relation to the target
""")
code(r"""
num_summary(hr[["city_development_index", "training_hours", "experience_num", "last_new_job_num"]])
""")
code(r"""
fig, ax = plt.subplots(1, 3, figsize=(14, 3.3))
sns.histplot(hr["training_hours"], bins=40, ax=ax[0]); ax[0].set_title("training_hours: right-skewed")
sns.histplot(hr["city_development_index"], bins=30, ax=ax[1], color="C2"); ax[1].set_title("city_development_index: left-skewed, clumped")
r = rate_by(hr, "city_development_index", "target", q=10)
ax[2].plot(range(len(r)), r["rate"], marker="o"); ax[2].set(title="job-change rate by CDI quantile bin", xlabel="bin (low → high CDI; tied values merge bins)", ylabel="rate")
plt.tight_layout(); save("hr_numeric")
print(rate_by(hr, "city_development_index", "target", q=5))
print(point_biserial(hr, ["city_development_index", "training_hours", "experience_num", "last_new_job_num"], "target"))
""")
md(r"""
*Reading:* **city development index** is the strongest numeric signal and is **non-linear**: candidates in the least developed cities change jobs
at roughly 55% vs about 10% in the most developed. `training_hours` is skewed and nearly unrelated to the target (r ≈ −0.02).
""")

md(r"""
### 2.4 Categorical features vs target
""")
code(r"""
for c in ["relevent_experience", "enrolled_university", "education_level", "company_type", "last_new_job"]:
    print(rate_by(hr, c, "target").sort_values("rate", ascending=False), "\n")
""")
code(r"""
rows = [(c, round(cramers_v(hr[c].fillna("MISSING"), hr["target"]), 3)) for c in
        ["city", "relevent_experience", "enrolled_university", "education_level", "major_discipline",
         "company_size", "company_type", "last_new_job", "gender"]]
cv_tab = pd.DataFrame(rows, columns=["feature", "cramers_v"]).sort_values("cramers_v", ascending=False)
plt.figure(figsize=(6, 3.2)); sns.barplot(data=cv_tab, y="feature", x="cramers_v", color="C0")
plt.title("Association with job change (Cramér's V)"); plt.tight_layout(); save("hr_cramers")
cv_tab
""")

md(r"""
### 2.5 High-cardinality `city`: why one-hot is a poor idea and what to do
""")
code(r"""
cs = hr.groupby("city").agg(n=("target", "size"), rate=("target", "mean"), cdi=("city_development_index", "first"))
print("cities:", len(cs), "| cities with < 20 candidates:", (cs["n"] < 20).sum())
print("Is CDI constant within each city?", (hr.groupby("city")["city_development_index"].nunique() == 1).all())
print("corr(city rate, city CDI) =", round(cs["rate"].corr(cs["cdi"]), 3))
prior, m = hr["target"].mean(), 20
cs["smoothed_rate"] = (cs["n"] * cs["rate"] + m * prior) / (cs["n"] + m)
cs.sort_values("n", ascending=False).head(8)
""")
md(r"""
*Reading:* 123 cities, many with few rows → raw city rates are noisy; and `city_development_index` is a **city-level attribute** (one value per city),
so it already summarises most of the city effect. Options: keep CDI, add **frequency** encoding of city, and an out-of-fold **smoothed target encoding** (shown).
""")

md(r"""
### 2.6 Experience: non-linear, and interacting with relevant experience
""")
code(r"""
e = hr.groupby(pd.cut(hr["experience_num"], [-1, 2, 5, 10, 15, 21]), observed=True)["target"].agg(["mean", "size"]).round(3)
print(e)
plt.figure(figsize=(6, 3.2))
sns.pointplot(data=hr, x=pd.cut(hr["experience_num"], [-1, 2, 5, 10, 15, 21]).astype(str), y="target",
              hue="relevent_experience", errorbar=None)
plt.title("Job-change rate by experience band"); plt.xlabel("years"); plt.tight_layout(); save("hr_experience")
""")
md(r"""
### 2.7 Findings
1. 19,158 rows; 25% positives (imbalanced → PR AUC / F1, stratified splits, class weights).
2. Type fixes needed: `experience`, `last_new_job` (text with codes), malformed `company_size` label `10/49`.
3. **Missingness is informative**: blank company fields ⇒ ~40% job-change rate vs ~18% → keep as a category.
4. **City development index** is the strongest driver and is non-linear (≈55% in least developed cities vs ≈10% in most developed).
5. Juniors, people without relevant experience and full-time students change jobs more; `training_hours` is nearly irrelevant.
6. `city` has 123 levels → frequency/target encoding, not one-hot.
""")

# =====================================================================
md(r"""
---
# Case 3 — Titanic (REAL data): interactions, text features, group-wise imputation
""")
code(r"""
ti = load_csv("understanding_your_data_eda/train.csv")
print(ti.shape); overview(ti)
""")
code(r"""
print("survival rate:", ti["Survived"].mean().round(3))
print(rate_by(ti, "Sex", "Survived")); print(rate_by(ti, "Pclass", "Survived"))
print(pd.crosstab(ti["Pclass"], ti["Sex"], values=ti["Survived"], aggfunc="mean").round(3))
plt.figure(figsize=(5.5, 3.2))
sns.barplot(data=ti, x="Pclass", y="Survived", hue="Sex", errorbar=None); plt.title("Survival by class and sex")
plt.tight_layout(); save("ti_class_sex")
""")
md(r"""
*Reading (interaction):* women in 1st/2nd class survived at >90%, women in 3rd class 50%; men low everywhere. The effect of class
**depends on** sex — a tree captures it automatically; a linear model needs an interaction feature.
""")
code(r"""
ti["Title"] = ti["Name"].str.extract(r",\s*([^\.]+)\.")[0]
ti["Title"] = ti["Title"].replace({"Mlle": "Miss", "Ms": "Miss", "Mme": "Mrs"})
ti.loc[~ti["Title"].isin(["Mr", "Mrs", "Miss", "Master"]), "Title"] = "Rare"
print(ti.groupby("Title").agg(n=("Survived", "size"), survival=("Survived", "mean"), median_age=("Age", "median")).round(2))
ti["Age_filled"] = ti["Age"].fillna(ti.groupby("Title")["Age"].transform("median"))
print("global median age:", ti["Age"].median(), "| ages imputed:", ti["Age"].isna().sum())
""")
md(r"""
*Why title-wise imputation:* `Master` (boys) has median age 3.5 while `Mr` has 30; filling every missing age with the global median (28)
would turn missing boys into adults.
""")
code(r"""
print("Fare skew:", ti["Fare"].skew().round(2), "| log1p skew:", np.log1p(ti["Fare"]).skew().round(2),
      "| zero fares:", (ti["Fare"] == 0).sum())
ti["FamilySize"] = ti["SibSp"] + ti["Parch"] + 1
print(rate_by(ti, "FamilySize", "Survived", bins=[0, 1, 4, 11]))
print("survival if Cabin missing vs present:", ti.groupby(ti["Cabin"].isna())["Survived"].mean().round(3).to_dict())
fig, ax = plt.subplots(1, 2, figsize=(11, 3.2))
sns.histplot(ti["Fare"], bins=40, ax=ax[0]); ax[0].set_title("Fare: skew 4.8")
sns.kdeplot(data=ti, x="Age_filled", hue="Survived", common_norm=False, ax=ax[1]); ax[1].set_title("Age by survival (children survive more)")
plt.tight_layout(); save("ti_fare_age")
""")
md(r"""
### Titanic findings
Sex is the dominant factor, class second, with a strong **interaction**; children (`Master`, age < 12) survived more; medium families (2–4)
survived more than people alone or in big families; missing `Cabin` marks lower classes (informative); `Fare` is very skewed (log it) with 15 zero fares to check.
""")

# =====================================================================
md(r"""
---
# Case 4 — Pima diabetes (REAL data): disguised missing values
""")
code(r"""
pi = load_csv("Module_1_Foundation_of_ML_AI/dataset/diabetes.csv")
print(pi.shape, "| isna().sum() total:", pi.isna().sum().sum())
num_summary(pi)
""")
md(r"""
`isna()` says **no missing values** — but `n_zeros` shows 374 zero Insulin, 227 zero SkinThickness, 35 zero BloodPressure, 11 zero BMI,
5 zero Glucose. A living person cannot have blood pressure 0 or BMI 0: these are **missing values coded as 0**. (Zero Pregnancies is valid.)
""")
code(r"""
impossible_zero = ["Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI"]
pi2 = pi.copy(); pi2[impossible_zero] = pi2[impossible_zero].replace(0, np.nan)
print((pi2.isna().mean() * 100).round(1))
print("\nGlucose mean with zeros:", pi["Glucose"].mean().round(2), "| after fixing:", pi2["Glucose"].mean().round(2))
print("\nmedians by outcome after fixing:\n", pi2.groupby("Outcome").median().round(1).T)
print(point_biserial(pi2, pi2.columns.drop("Outcome"), "Outcome"))
fig, ax = plt.subplots(1, 3, figsize=(13, 3.2))
sns.histplot(pi["BloodPressure"], bins=30, ax=ax[0]); ax[0].set_title("BloodPressure raw: spike at 0")
sns.kdeplot(data=pi2, x="Glucose", hue="Outcome", common_norm=False, ax=ax[1]); ax[1].set_title("Glucose separates outcomes")
sns.heatmap(pi2.corr(), cmap="coolwarm", vmin=-1, vmax=1, ax=ax[2], cbar=False); ax[2].set_title("Correlation (zeros fixed)")
plt.tight_layout(); save("pi_overview")
""")
md(r"""
### Pima findings
Disguised missing values (Insulin 49% missing!) must be recoded before any statistic; imputation should use medians computed **without the
outcome** and inside a pipeline. Glucose is by far the strongest predictor (r ≈ 0.50), then BMI and Insulin (≈ 0.30). Insulin shows a
striking trap: with the zeros left in, the *median* insulin of diabetic patients is 0 (most of them simply were not measured);
after recoding zeros as missing it is 169.5 vs 102.5 for non-diabetic patients.
""")

# =====================================================================
md(r"""
---
# Exercises (do them before the interview)
1. On the HR data, build `missing_count` per row and check the job-change rate by it.
2. On Titanic, compute survival by `Embarked` with counts and explain why `C` looks better (hint: class mix).
3. On Pima, impute with `KNNImputer` vs median and compare the Glucose–Outcome point-biserial correlation.
4. On the placement data, compute Spearman instead of Pearson correlations; do conclusions change?
5. For each dataset, write a 6-line findings summary in “because I see X, I will do Y” form.
""")

nb = nbf.v4.new_notebook(); nb["cells"] = cells
nb["metadata"] = {"kernelspec": {"name": "python3", "display_name": "Python 3", "language": "python"},
                  "language_info": {"name": "python"}, "colab": {"provenance": []}}
nbf.write(nb, "EDA_Lab.ipynb")
print("written", len(cells), "cells")
