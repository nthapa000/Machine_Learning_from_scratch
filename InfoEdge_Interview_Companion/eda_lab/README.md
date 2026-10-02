# EDA Lab (companion to Part VIII of the InfoEdge Interview Companion PDF)

`EDA_Lab.ipynb` is a Colab-ready notebook with four complete exploratory data analyses, already executed (outputs and plots are saved in it):

| Case | Dataset | Source |
|---|---|---|
| 1 | MBA campus placement | Kaggle `Placement_Data_Full_Class.csv` if you upload it; otherwise a simulated replica with the same columns (`make_placement_replica.py`) |
| 2 | HR Analytics: job change of data scientists | real, `Data_gathering/dataset/aug_train.csv` in this repo |
| 3 | Titanic | real, `understanding_your_data_eda/train.csv` |
| 4 | Pima Indians diabetes | real, `Module_1_Foundation_of_ML_AI/dataset/diabetes.csv` |

## Run in Google Colab
1. Open https://colab.research.google.com, choose **File → Upload notebook**, and select `EDA_Lab.ipynb`. (Or use **File → Open notebook → GitHub** and paste this repository's URL.)
2. For case 1 with the real data, download `Placement_Data_Full_Class.csv` from Kaggle ("Campus Recruitment") and upload it with the Files panel.
3. **Runtime → Run all**. The real datasets are read from the public GitHub copy of this repo on the `master` branch.

## Rebuild locally
```
python build_notebook.py
jupyter nbconvert --to notebook --execute --inplace EDA_Lab.ipynb
```
Figures used in the PDF are written to `figs/` when that folder exists.
