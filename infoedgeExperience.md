# InfoEdge Interview Experience: Data Scientist

Notes from the video **"Ayush Agarwal Shares Tips & Tricks" (InfoEdge Interview Experience: Data Scientist)**:
https://www.youtube.com/watch?v=nWyBQhGnHaM (about 20 minutes).

These are summarised notes made from an automatic speech-to-text transcript of the video, not a word-for-word
transcript. Timestamps are approximate and link to that point in the video. Watch the video for the full account.

**Candidate:** Ayush Agarwal, Electronics Engineering, IIT BHU (2024 batch). Placed at InfoEdge as a Data Scientist
through campus placements (Day 1, Slot 1).

---

## 1. Selection process at a glance ([01:54](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=114s))

| Stage | What happens | Length |
| --- | --- | --- |
| Online test | 40 MCQs across deep learning, machine learning, statistics, probability and more. He estimates you need roughly 25-26 correct to reach the interviews. | - |
| Round 1 | Rapid-fire technical questions across all topics | ~45 min |
| Round 2 | Same format as round 1 | ~1 hr |
| Round 3 | ML coding in a Colab notebook | ~1 hr 10 min |
| Round 4 | Background discussion + case studies (senior data scientist) | ~1 hr |
| Round 5 | HR | 15-20 min |

- Rounds 1 and 2 are broad "drilling" rounds: three or four questions from each core topic. The topics are Python,
  SQL, machine learning, deep learning, statistics, probability and sometimes linear algebra. About 40 students were
  shortlisted for interviews, and these two rounds eliminated the most.
- **Interview day** ([00:21](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=21s)): it started between 8 and 9 AM, with
  waits of 5-30 minutes between rounds on the same Meet link. He was also doing other companies' rounds the same day,
  so it was long and tiring.
- **Practical tip:** keep drinking water. Talking continuously for hours dries your mouth, and the short gaps between
  rounds are your chance to reset.

---

## 2. Rounds 1 & 2: technical questions ([04:55](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=295s))

These are the questions he remembered. He listed Python and SQL among the topics too, but did not describe those
questions.

### Statistics
- What a p-value is, what alpha (significance level) is, and how to compare the two.

### Probability
- Naive Bayes: derive it starting from Bayes' theorem, the independence assumption it needs, and where it is used in
  real life. The focus was on intuition, not formulas.

### Machine learning ([05:21](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=321s))
Questions followed the projects on his resume:
- **PCA**: how it is computed with SVD (singular value decomposition), and using a scree plot.
- **t-SNE**: how it preserves neighbourhoods, the role of perplexity, and its use for visualising clusters.
- **LDA (Fisher's linear discriminant)**: the objective and the intuition, which is to push class means apart while
  shrinking the variance within each class.
- A few questions on decision trees.

### Deep learning (the heaviest grilling) ([06:18](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=378s))
- Vanishing and exploding gradients: why they happen.
- Weight decay.
- How a network trains: forward pass, computing the loss, backpropagation and computing gradients.
- Ways to prevent overfitting.
- Weight initialisation: Xavier/Glorot vs He initialisation, and which activations each suits.
- **Time series** ([07:08](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=428s)): which models to use. He covered ARIMA and
  its drawbacks, then LSTMs and GRUs and their internal structure.

### Linear algebra (the hardest part) ([07:25](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=445s))
- His view: InfoEdge is the only data science company he saw that asks linear algebra, and it did not ask DSA at all.
- Rank of a matrix, eigenvalues and eigenvectors (he answered these).
- Null space of a matrix (he could not answer this one).
- An "unconventional" question on **Markov chains**: he explained them as a state machine and how to compute
  transition probabilities.

---

## 3. Round 3: ML coding ([02:34](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=154s))

He got a Colab notebook with the questions already written in it.

**Dataset:** MBA college placement data. It had percentage marks from several exams, categorical columns (work
experience or not, school board, stream: arts / commerce / science), the target (placed or not) and a salary column
(salary if placed).

What he did:
1. **Spotted target leakage first:** salary is only filled in for placed students, so "salary is null" gives the answer
   away. He pointed this out before training anything, and they told him to drop the column. The interviewers were
   impressed.
2. Checked for missing values (there were none).
3. Checked for outliers using `describe()`. All percentages were within 0-100, so any extreme values were genuine data,
   not errors. This was a test of judgement: blindly removing "outliers" with box plots or z-scores would have been
   the wrong move here.
4. Ran value counts on the categorical columns and split the columns into numerical and categorical.
5. Built a correlation matrix.
6. Trained a **logistic regression** model.
7. Evaluated it with a confusion matrix, precision, recall and F1 score.

---

## 4. Round 4: background + case studies ([08:16](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=496s))

Taken by a senior data scientist.

**Background check:** where he learned ML and what else he had been exposed to: reinforcement learning (through a
robotics club), computer vision and some NLP. The interviewer wanted to see whether he had genuinely been doing ML for
a long time.

### Case 1: will this user buy a property? (99acres) ([09:00](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=540s))
Given a user's browsing data on 99acres, design features that predict whether they will buy a property. The
interviewer kept asking for more until he ran out; he came up with roughly 5-10 features. Examples:
- **Price-band concentration:** if most listings a user views are around one price, the few much cheaper or much
  pricier listings they view are unlikely purchases.
- **Location of recent searches** (last 10-15): someone searching in Noida will not buy in Bangalore, however similar
  the listing. This can rule out candidates.

### Follow-up: linear regression assumptions ([10:25](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=625s))
- What are the assumptions of linear regression?
- What do you do if **homoscedasticity** is violated? He proposed moving to a **GLM (generalised linear model)** that
  models the variance explicitly. The interviewer had expected variable transformations, so he also listed some
  transformations.

### Case 2: you are the sales head of Naukri.com ([10:54](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=654s))
Name three things you would do to increase revenue. The twist: **no clarifying questions allowed**. In most case
rounds you would ask clarifying questions and structure the problem first. He thinks the interviewer was also testing
his knowledge of the company.
- **His framing:** a large part of the revenue comes from companies paying to post jobs. It is a two-sided cycle. More
  companies attract more job seekers (and more ad revenue), and more job seekers attract more companies, so both sides
  must grow together.
- **One idea:** partner with colleges so they can run their placement (TPC) process on the platform instead of
  building their own portal, with companies posting openings there. He gave two or three more ideas that the video
  does not go into.

---

## 5. Round 5: HR ([12:26](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=746s))

- They checked his **knowledge of the company** and his willingness to work, and told him about the role.
- **"Do you know about InfoEdge?"** He walked through the company's history and its portfolio: Naukri.com,
  Jeevansathi.com, 99acres, Shiksha. It was his dream company, so he had researched it thoroughly.
- **Work model:** they told him office attendance was moving to 4 days in office and 1 day from home. He said he was
  keen to be in the office to learn from seniors in person.
- **"Why InfoEdge?"** He calls this the most important HR question, a chance to show you are a strong fit and not just
  interested. His answer had three parts:
  - InfoEdge combines business and tech: its ML models solve real problems for real customers.
  - It is strong technically. He referred to the company's pre-placement presentation and the deep learning work it
    showed, such as transformers.
  - It offers varied work across several products rather than a single one.

---

## 6. How he prepared ([14:33](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=873s))

- He had expected a pre-placement offer (PPO) from an NVIDIA internship. Because of a hiring freeze, very few interns
  got one (he says about 1 in 6), so he started preparing for placements.
- He joined a placement-preparation programme (its name is unclear in the audio) a few weeks after its batch started.
  In his account, it helped with:
  - **Aptitude speed:** anyone can solve aptitude questions; what matters is speed. Practice made him much faster at
    permutations & combinations and probability (topics most people have not revised since JEE), which helped in the
    MCQ test.
  - **Group discussions:** he took part in 9 of the 10 GDs, which built his impromptu speaking. He also learned to tell
    his intro and experiences as engaging stories.
  - **Knowing the syllabus:** what companies do and do not ask in probability and statistics. Mentors across tech,
    product and analytics know what each company asks.
- **Depth over breadth in ML** ([17:11](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=1031s)): he came from deep learning
  (GANs) and was surprised by how much depth "basic" ML has. For example:
  - Linear regression on count data calls for **Poisson regression**, which comes from GLMs.
  - SVMs can do regression too (**SVR**).

  Quiz practice exposed these gaps and pushed him to understand each algorithm properly.

**His view on the market** ([18:14](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=1094s)): campus software hiring has
slowed, while demand for analytics and data roles is growing. He says the number of students sitting for analytics
roles roughly doubled year on year.

---

## Key takeaways

1. **The online test is a speed test.** Practise aptitude, P&C and probability until you are fast. Expect 40 MCQs across
   ML, DL, statistics and probability.
2. **Prepare linear algebra.** Rank, eigenvalues and eigenvectors, and null space all came up, which is unusual for
   data science interviews. DSA was not asked, but Python and SQL are on the topic list.
3. **Know the fundamentals deeply, not just by name:** p-values, Naive Bayes from Bayes' theorem, PCA via SVD, t-SNE,
   Fisher LDA, backpropagation, vanishing/exploding gradients, weight initialisation, ARIMA vs LSTM/GRU, linear
   regression assumptions, GLMs.
4. **Everything on your resume will be drilled.** Be ready to explain any technique you mention.
5. **In the coding round, think like a data scientist before writing code:** check for leakage, missing values and
   outliers (using judgement rather than blindly dropping values), then build a simple baseline (logistic regression)
   and evaluate it properly (confusion matrix, precision, recall, F1).
6. **In case studies, engineer features that capture user intent** (price range, location), and expect the interviewer
   to keep pushing for more.
7. **For HR, research the company in depth** (history, products) and prepare a strong, specific "Why InfoEdge?".
   Referring to what you learned from the company's pre-placement talk helps.
8. **Manage your energy on interview day:** the rounds run back to back for hours, so keep water handy.
