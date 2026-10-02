"""Simulated replica of the MBA campus-placement dataset (Kaggle: 'Campus Recruitment',
file Placement_Data_Full_Class.csv). Same columns and meanings; values are SIMULATED.
Use the real file whenever you have it -- every analysis in the EDA lab runs unchanged."""
import numpy as np, pandas as pd

def make_placement_replica(n=215, seed=42):
    rng = np.random.default_rng(seed)
    gender = rng.choice(["M", "F"], n, p=[0.65, 0.35])
    ssc_p = np.clip(rng.normal(67, 10.8, n), 40, 89.4).round(2)
    ssc_b = rng.choice(["Central", "Others"], n, p=[0.54, 0.46])
    hsc_p = np.clip(0.55 * ssc_p + rng.normal(29.5, 8.5, n), 37, 97.7).round(2)
    hsc_b = rng.choice(["Central", "Others"], n, p=[0.39, 0.61])
    hsc_s = rng.choice(["Commerce", "Science", "Arts"], n, p=[0.53, 0.42, 0.05])
    degree_p = np.clip(0.35 * ssc_p + rng.normal(43, 5.8, n), 50, 91).round(2)
    degree_t = np.where(hsc_s == "Science", rng.choice(["Sci&Tech", "Comm&Mgmt", "Others"], n, p=[0.6, 0.3, 0.1]),
                        rng.choice(["Comm&Mgmt", "Sci&Tech", "Others"], n, p=[0.9, 0.05, 0.05]))
    workex = rng.choice(["No", "Yes"], n, p=[0.655, 0.345])
    etest_p = np.clip(rng.normal(72, 13, n), 50, 98).round(2)
    specialisation = rng.choice(["Mkt&Fin", "Mkt&HR"], n, p=[0.56, 0.44])
    mba_p = np.clip(0.1 * degree_p + rng.normal(55.5, 5.5, n), 51.2, 77.9).round(2)
    z = (-27.1 + 0.20 * ssc_p + 0.09 * hsc_p + 0.10 * degree_p + 3.0 * (workex == "Yes")
         + 2.4 * (specialisation == "Mkt&Fin") + 0.01 * etest_p - 0.06 * (mba_p - 62)
         + rng.normal(0, 0.9, n))
    placed = rng.random(n) < 1 / (1 + np.exp(-z))
    base = (200000 + 4200 * (ssc_p - 60) + 2500 * (degree_p - 65) + 45000 * (workex == "Yes")
            + 25000 * (gender == "M") + 20000 * (specialisation == "Mkt&Fin"))
    salary = base * np.exp(rng.normal(0, 0.18, n))
    salary = np.clip(salary, 200000, None)
    top = rng.random(n) < 0.03                      # a few genuinely high packages
    salary = np.where(top, salary * rng.uniform(1.8, 3.2, n), salary)
    salary = np.where(placed, (salary / 1000).round() * 1000, np.nan)
    return pd.DataFrame(dict(sl_no=np.arange(1, n + 1), gender=gender, ssc_p=ssc_p, ssc_b=ssc_b,
        hsc_p=hsc_p, hsc_b=hsc_b, hsc_s=hsc_s, degree_p=degree_p, degree_t=degree_t, workex=workex,
        etest_p=etest_p, specialisation=specialisation, mba_p=mba_p,
        status=np.where(placed, "Placed", "Not Placed"), salary=salary))

if __name__ == "__main__":
    df = make_placement_replica()
    df.to_csv("data/placement_replica.csv", index=False)
    print(df.shape, df.status.value_counts().to_dict())
    print(df.salary.describe().round(0).to_dict())
    print(df.groupby("workex").status.apply(lambda s: (s == "Placed").mean()).round(3).to_dict())
    print(df.groupby("status")[["ssc_p", "hsc_p", "degree_p", "etest_p", "mba_p"]].mean().round(1))
