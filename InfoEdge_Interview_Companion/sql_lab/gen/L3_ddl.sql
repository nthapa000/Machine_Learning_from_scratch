CREATE TABLE skills (
  cand_id INTEGER NOT NULL REFERENCES candidates(cand_id),
  skill   VARCHAR(20) NOT NULL,
  level   INTEGER CHECK (level BETWEEN 1 AND 5),
  PRIMARY KEY (cand_id, skill)
);
INSERT INTO skills VALUES (101,'python',4),(101,'sql',3),(102,'sql',5);
SELECT * FROM skills;
