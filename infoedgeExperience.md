# InfoEdge Interview Experience: Data Scientist

Notes from the video **"Ayush Agarwal Shares Tips & Tricks" (InfoEdge Interview Experience: Data Scientist)**:
https://www.youtube.com/watch?v=nWyBQhGnHaM (about 20 minutes). All credit for the content goes to the speaker and
the channel.

These notes cover everything discussed in the video, paraphrased and organised by topic. They are not a transcript.
They were made from a speech-to-text transcript and checked against the video's captions. Timestamps link to that
point in the video.

**Video chapters:** Introduction ([0:09](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=9s)) ·
Hiring process overview ([0:19](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=19s)) ·
Interview round experience ([1:57](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=117s)) ·
MAS journey ([14:32](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=872s))

**Candidate:** Ayush Agarwal, Electronics Engineering, IIT BHU (2024 batch). Placed at InfoEdge as a Data Scientist
through campus placements (Day 1, Slot 1).

---

## 1. Selection process at a glance ([1:57](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=117s))

| Stage | What happens | Length |
| --- | --- | --- |
| Online test | 40 MCQs covering deep learning, machine learning, statistics, probability and more. His estimate: about 25-26 correct answers gets you to the interviews. | - |
| Round 1 | Technical drilling across all topics | ~45 min |
| Round 2 | Same format as round 1 | ~1 hr |
| Round 3 | ML coding in a Colab notebook | ~1 hr 10 min (he also says about 1.5 hr) |
| Round 4 | Background discussion + case studies (senior data scientist) | ~1 hr |
| Round 5 | HR, mostly informational | 15-20 min |

- Rounds 1 and 2 are broad "drilling" rounds: three or four questions from each of six topics (Python, SQL, machine
  learning, deep learning, statistics, probability), plus linear algebra at times. About 40 students were shortlisted
  for interviews, and these two rounds eliminated the most.
- **Interview day** ([0:19](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=19s)):
  - It started between 8 and 9 AM.
  - He waited 15-30 minutes after round 1. After that the gaps were about 5 minutes, and each new interviewer joined
    the same Meet link.
  - After round 4 he left for another company's interview, then came back for the HR round.
  - It was a long, tiring day.
- **Tips for the day:** stay calm and keep drinking water, because talking for hours dries your mouth. He used the
  5-minute gaps for water and washroom breaks.

---

## 2. Rounds 1 & 2: technical questions ([4:55](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=295s))

These are the questions he remembered. He did not describe the Python and SQL questions.

### Statistics
- What a p-value is and how to define it, what alpha (the significance level) is, and how to compare the two.

### Probability
- Naive Bayes: build up to it from Bayes' theorem, the condition it puts on the events (they must be independent), and
  how it is used in practice. They were checking intuition, not formulas.

### Machine learning ([5:26](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=326s))
Questions followed the projects on his resume, which used PCA and t-SNE:
- **PCA**: how it uses SVD (singular value decomposition), and the scree plot.
- **t-SNE** (t-distributed stochastic neighbour embedding): why it is useful for seeing clusters, and how perplexity
  controls the neighbourhoods it preserves.
- **LDA (Fisher's linear discriminant)**: the formulation and the intuition, which is to push class means apart while
  shrinking the variance within each class.
- A little on decision trees, but not much.

### Deep learning (the heaviest grilling) ([6:12](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=372s))
- Vanishing and exploding gradients: why they happen.
- Weight decay: he saw where the question was heading and answered it correctly.
- How a network learns: values flow forward, the error is computed and sent backward, and gradients are computed
  (backpropagation).
- Ways to prevent overfitting.
- Weight initialisation: Xavier (suited to tanh/sigmoid) and He (suited to ReLU).
- **Time series** ([7:07](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=427s)): which deep learning models to use. He
  covered RNNs and their drawbacks, then LSTMs and GRUs and their internal structure. The interviewers were satisfied.

### Linear algebra (the hardest part) ([7:22](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=442s))
- His view: hardly anyone prepares linear algebra, yet InfoEdge is the only data science company he knows of that asks
  it. It is also the only one that does not care about DSA at all.
- Rank of a matrix, eigenvalues and eigenvectors (he answered these).
- Null space of a matrix (he could not answer this one).
- An "unconventional" question on **Markov chains**: he approached them as a finite state machine and explained how to
  compute transition probabilities.

---

## 3. Round 3: ML coding ([2:39](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=159s))

He got a Colab notebook with the questions already written in it.

**Dataset:** MBA college placement data. It had:
- percentage marks from five exams
- categorical columns: work experience or not, school board, and stream (arts / commerce / science)
- the target: placed or not
- a salary column (salary if placed)

What he did:
1. **Spotted target leakage first:** salary is only filled in for placed students, so checking whether it is null
   gives the answer away. He raised this before anything else. The interviewers were impressed and told him to drop
   the column.
2. Checked for missing values (there were none).
3. Checked for outliers with `describe()`. All percentages were within 0-100, so any extreme values were genuine data,
   not errors. This tested presence of mind: anyone who blindly removed "outliers" with box plots or z-scores would
   have been caught out.
4. Ran value counts on each categorical column and split the columns into numerical and categorical.
5. Built a correlation matrix.
6. Trained a **logistic regression** model.
7. Built a confusion matrix and printed precision, recall, F1 score and accuracy.

---

## 4. Round 4: background + case studies ([8:36](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=516s))

Taken by a senior data scientist.

**Background check:** where he learned ML and what else he had been exposed to: reinforcement learning (through his
robotics club), computer vision and a little NLP. The interviewer wanted an all-round check on whether he had genuinely
been doing ML from the start.

### Case 1: will this user buy a property? (99acres) ([9:07](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=547s))
Given all of a user's browsing data on 99acres, design features that predict whether they will buy a property. The
interviewer kept pushing until he ran out of answers. He came up with roughly 5-10 features. Examples:
- **Price-band concentration:** suppose most listings a user views cost around 30,000, with only a few around 10,000
  or 60,000. The cheap and expensive outliers are much less likely purchases than the 30,000 ones. This one impressed
  the interviewer.
- **Location of recent searches** (last 10-15): someone searching in Noida will not buy in Bangalore, however similar
  the listing, because location matters so much. This can rule properties out.
- He had many more features that the video does not go into.

### Follow-up: linear regression assumptions ([10:25](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=625s))
- What are the assumptions of linear regression?
- What do you do if **homoscedasticity** is violated? He proposed a **GLM (generalised linear model)**: model the
  variance explicitly, keep a linear model on top and fit its weights. The interviewer had expected variable
  transformations and had not thought of the GLM route, but accepted it. He also named a few transformations.

### Case 2: you are the sales head of Naukri.com ([10:58](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=658s))
Name three things you would do to increase revenue. The twist: **no clarifying questions allowed**. In a usual case
round you ask questions and build a structure first. He thinks the interviewer was also testing company knowledge.
- **His framing:** most of the revenue comes from companies paying to post jobs. It works as a cycle: more companies
  bring more job seekers, and more job seekers raise ad revenue and attract more companies. So both sides must grow
  together.
- **One idea:** partner with colleges. Instead of each college building and running its own placement (TPC) portal,
  give colleges a mini-platform on Naukri where companies post openings.
- He gave two or three more ideas that the video does not go into.

---

## 5. Round 5: HR ([12:26](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=746s))

- They checked his **knowledge of the company** and his willingness to work, and told him about the work there.
- **"Do you know about InfoEdge?"** He gave a timeline of the company: founded in 1995, then Jeevansathi.com,
  Naukri.com, 99acres and Shiksha. The interviewer was impressed. The question checks whether you have researched the
  company, and as it was his dream company, he had. (The years he quoted for each site are approximate, so check them
  before you use them.)
- **Work model:** currently 5 days in the office, moving to 4 days in the office and 1 day from home. He said he was
  keen to come in and learn from seniors in person, which went down well.
- **"Why InfoEdge?"** He calls this the most important HR question: your chance to show you are a strong fit, not just
  interested. His answer had three parts:
  - InfoEdge does both business and tech. Its ML models are useful in real life, solving real problems for real
    customers.
  - It is strong technically. He said he had loved the company's pre-placement presentation, which showed deep
    learning models such as transformers in use.
  - The work is varied across several products rather than a single product.

---

## 6. His MAS journey: how he prepared ([14:32](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=872s))

- **Why he joined:** he had expected a pre-placement offer (PPO) from his NVIDIA internship. A hiring freeze meant only
  about 1 in 6 interns got one, and he missed out. He then joined MAS, a placement-preparation programme, about three
  weeks after its first batch (MAS 1.0) started, to work on his interview skills.
- **Aptitude is about speed:** anyone can solve aptitude questions; what counts is how fast you are (the same idea as
  the CAT exam). Practice made him much faster at permutations & combinations and probability, topics few people
  revisit after JEE, and that paid off in the online test.
- **Group discussions:** he took part in 9 of the 10 GDs held. That built his impromptu speaking: given 15-20 seconds
  to think, he can now keep talking fluently.
- **Communication and storytelling:** how well you answer is only part of it; how you communicate matters too,
  including body language (his hand movements now come naturally). He learned to tell engaging stories, and says his
  intro now comes across as very passionate.
- **Knowing the syllabus:** he knew exactly what companies ask, and don't ask, in probability and statistics.
- **Depth in "basic" ML** ([17:06](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=1026s)): before MAS he was into deep
  learning (working on GANs in an ML team) and assumed linear regression could not stump him. Studying the basic
  algorithms in depth showed him the variants most courses skip. For example:
  - Linear regression on count data needs **Poisson regression**, which comes from GLMs.
  - SVMs can do regression too (**support vector regression, SVR**).

  Seeing such options in quizzes made him dig into each algorithm, and he came away understanding ML very differently.

### Would he recommend it? ([18:11](https://www.youtube.com/watch?v=nWyBQhGnHaM&t=1091s))
Yes, especially for data roles. His reasons:
- **Software hiring on campus is shrinking.** Since ChatGPT arrived, investment has slowed and less software work is
  needed, so fewer software companies come to placements and they hire fewer people. He acknowledges many will disagree.
- **Data and analytics roles are growing**, and he expects data science to become an essential skill. Students from
  non-CS branches have moved towards it fastest: he estimates about 200 students sat for analytics roles last year and
  about 400 this year.
- **Mentors:** MAS has mentors for tech and product, and especially strong ones for analytics. They know what companies
  do and don't ask, and help you prepare every line of your intro and interview answers.

---

## Key takeaways

1. **The online test is a speed test.** Practise aptitude, P&C and probability until you are fast. Expect 40 MCQs across
   ML, DL, statistics and probability, and aim for about 25-26 correct.
2. **Prepare linear algebra.** Rank, eigenvalues and eigenvectors, and null space all came up, which is unusual for
   data science interviews. DSA was not asked, but Python and SQL are on the topic list.
3. **Know the fundamentals deeply, not just by name:** p-values, Naive Bayes from Bayes' theorem, PCA via SVD, t-SNE,
   Fisher LDA, backpropagation, vanishing/exploding gradients, weight initialisation, RNNs vs LSTMs/GRUs, linear
   regression assumptions, GLMs. Also know the less common variants, such as Poisson regression and SVR.
4. **Everything on your resume will be drilled.** Be ready to explain any technique you mention.
5. **In the coding round, think like a data scientist before writing code:** check for leakage, missing values and
   outliers (using judgement rather than blindly dropping values), then build a simple baseline (logistic regression)
   and evaluate it properly (confusion matrix, precision, recall, F1, accuracy).
6. **In case studies, engineer features that capture user intent** (price range, location), and expect the interviewer
   to keep pushing for more.
7. **For HR, research the company in depth** (history, products) and prepare a strong, specific "Why InfoEdge?".
   Referring to what you learned from the company's pre-placement talk helps.
8. **Practise speaking.** GDs build impromptu speaking and storytelling, and communication and body language count as
   well as the content of your answer.
9. **Manage your energy on interview day:** the rounds run back to back for hours, so keep water handy.
