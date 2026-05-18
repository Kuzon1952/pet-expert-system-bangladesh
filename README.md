# 🐾 Pet Selection Expert System — Bangladesh

> A CLIPS-based expert system that recommends the most suitable pet for a user based on their lifestyle and preferences. Designed specifically for the context of Bangladesh.

---

## 📌 About

This is a course work project for the subject **Graph Theory** at Peter the Great St. Petersburg Polytechnic University (SPbPU).

The system is implemented in **CLIPS** (C Language Integrated Production System) using the **production model** of knowledge representation. The knowledge base is structured as a **binary decision tree** with 4 levels, 15 decision nodes, and 16 possible recommendations.

The user answers 4 yes/no questions and receives a pet recommendation. All 16 animals were selected based on their real availability and popularity in Bangladesh, confirmed by sources including The Daily Star, ResearchGate, and Bikroy.com.

---

## 🌳 Decision Tree

```
Level 1 ── n1: Is daily close interaction important?
              │
         YES ─┤─ NO
              │        │
Level 2 ──  n2         n3
        walks?       passive observation?
         │                  │
      YES─┤─NO           YES─┤─NO
         │                  │
Level 3 n4  n5           n6    n7
       ...  ...          ...   ...
              │
Level 4 ── n8 ... n15
              │
Leaves  ── Dog, Rabbit, Cat, Guinea Pig, Hamster,
           Fancy Rat, Pigeon, Myna Bird,
           Aquarium Fish, Goldfish, Turtle, Cockatiel,
           Parrot, Canary, Lovebird, Budgerigar
```

**Solid edge = YES &nbsp;&nbsp; Dashed edge = NO**

| Property | Value |
|---|---|
| Levels | 4 |
| Decision nodes | 15 |
| Leaf nodes (recommendations) | 16 |
| Total nodes | 31 |

---

## 🚀 How to Run

### Requirements
- [CLIPS 6.3](https://sourceforge.net/projects/clipsrules/) installed

### Run manually
```
clips
```
Then inside CLIPS:
```clips
(load "pet_expert.clp")
(reset)
(run)
```

### Or use the shell script (Linux/macOS)
```bash
chmod +x run.sh
./run.sh
```

### Input
| Input | Meaning |
|---|---|
| `yes` or `y` | Yes |
| `no` or `n` | No |

Invalid input is rejected with an error message and the question is repeated.

---

## 💬 Example Session

```
=== Expert System: Pet Selection (Bangladesh) ===

Is daily close interaction with your pet important to you? (yes/no): y
Are you ready to spend 1+ hour per day on walks and training? (yes/no): y
Do you prefer a pet that needs space for active movement outside a cage? (yes/no): y
Do you need a pet with good trainability and obedience? (yes/no): y

Recommended pet: Dog

Would you like a new recommendation? (yes/no): n

Goodbye!
```

---

## 📁 Repository Structure

```
├── pet_expert.clp                     # Main CLIPS program
├── bangladesh_pet_selection.drawio    # Decision tree diagram (draw.io)
├── run.sh                             # Shell script to run in one command
│
├── report/
│   ├── engmain.pdf                    # English report (compiled PDF)
│   ├── к_р_Ови_5130201-40001.pdf      # Russian report (compiled PDF)
│   ├── diagram.pdf                    # Decision tree diagram (PDF)
│
└── README.md
```

---

## 🧠 How It Works (CLIPS Production Model)

The system is built on the **production model** of knowledge representation:

```
IF  <condition>  THEN  <action>
```

### Three components:

| Component | In this project |
|---|---|
| **Knowledge Base** | All 31 `defrule` rules in `pet_expert.clp` |
| **Working Memory** | Facts like `(interaction yes)`, `(walks no)` asserted during the session |
| **Inference Engine** | Built into CLIPS — automatically matches facts to rules and fires them |

### Inference engine cycle (A, B, C, D):

| Function | Role | In the code |
|---|---|---|
| **A** — Select | Reads all rules (KB) and all facts (working memory) | All `defrule` blocks + `assert` calls |
| **B** — Match | Checks which rules' conditions match current facts | Left-hand side of every rule (before `=>`) |
| **C** — Resolve | Picks the highest-priority rule when multiple match | `(declare (salience 1000))` in `print-rec` |
| **D** — Act | Executes the chosen rule's action | Right-hand side of every rule (after `=>`) |

### Key rules:

```clips
; Entry point — fires when working memory is empty
(defrule first ""
    (not (interaction ?)) (not (rec ?)) (not (restart))
    =>
    (printout t "=== Expert System: Pet Selection (Bangladesh) ===" crlf crlf)
    (assert (interaction (yesno "Is daily close interaction important? (yes/no): "))))

; Highest priority — always fires first when a recommendation is ready
(defrule print-rec
    (declare (salience 1000))
    ?rec <- (rec ?item)
    =>
    (printout t crlf "Recommended pet: " ?item crlf crlf)
    (retract ?rec)
    (assert (restart)))

; Leaf node example
(defrule trainable-yes ""
    ?f <- (trainable yes) (not (rec ?)) =>
    (retract ?f) (assert (rec "Dog")))
```

---

## 🐶 All 16 Recommendations

| # | Animal | Path |
|---|---|---|
| 1 | Dog | YES → YES → YES → YES |
| 2 | Rabbit | YES → YES → YES → NO |
| 3 | Cat | YES → YES → NO → YES |
| 4 | Guinea Pig | YES → YES → NO → NO |
| 5 | Hamster | YES → NO → YES → YES |
| 6 | Fancy Rat | YES → NO → YES → NO |
| 7 | Pigeon | YES → NO → NO → YES |
| 8 | Myna Bird | YES → NO → NO → NO |
| 9 | Aquarium Fish | NO → YES → YES → YES |
| 10 | Goldfish | NO → YES → YES → NO |
| 11 | Turtle | NO → YES → NO → YES |
| 12 | Cockatiel | NO → YES → NO → NO |
| 13 | Parrot | NO → NO → YES → YES |
| 14 | Canary | NO → NO → YES → NO |
| 15 | Lovebird | NO → NO → NO → YES |
| 16 | Budgerigar | NO → NO → NO → NO |

---

## 📚 References

- The Daily Star Bangladesh — pet market statistics
- ResearchGate — pet ownership study in Bangladesh (2024)
- Bikroy.com — available pets marketplace
- BdFISH — aquarium fish in Bangladesh
- Khabarov S.P. — *CLIPS: a language for building expert systems*, SPb, 2013
- Gavrilova T.A. — *Development of Expert Systems. The CLIPS Environment*, BHV-Petersburg, 2003

---

## 🎓 Course Info

| Field | Value |
|---|---|
| University | Peter the Great St. Petersburg Polytechnic University |
| Subject | Graph Theory (Теория графов) |
| Topic | Production models of expert systems |
| Student | Ovi Md Shamin Yasir |
| Group | 5130201/40001 |
| Year | 2026 |
