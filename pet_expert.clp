; ============================================================
; Expert System: Choosing a Pet (Bangladesh)
; Binary decision tree  -- 4 levels, 15 decision nodes, 16 recommendations
; ------------------------------------------------------------
; Usage:  CLIPS> (load "pet_expert.clp")
;         CLIPS> (reset)
;         CLIPS> (run)
; Input:  yes / y  for YES
;         no  / n  for NO
; ============================================================


; ------------------------------------------------------------
; 3.1  General question function
;      Asks ?question, reads answer, loops until it matches
;      one of $?allowed-values (case-insensitive).
; ------------------------------------------------------------
(deffunction ask-question (?question $?allowed-values)
    (printout t ?question)
    (bind ?answer (read))
    (if (lexemep ?answer)
        then (bind ?answer (lowcase ?answer)))
    (while (not (member$ ?answer ?allowed-values)) do
        (printout t "  Invalid input. Please enter: " ?allowed-values crlf)
        (printout t ?question)
        (bind ?answer (read))
        (if (lexemep ?answer)
            then (bind ?answer (lowcase ?answer))))
    ?answer)


; ------------------------------------------------------------
; 3.2  Yes/No wrapper
;      Calls ask-question with allowed values yes/no/y/n.
;      Returns the symbol  yes  or  no.
; ------------------------------------------------------------
(deffunction yesno (?question)
    (bind ?response (ask-question ?question yes no y n))
    (if (or (eq ?response yes) (eq ?response y))
        then yes
        else no))


; ------------------------------------------------------------
; 3.3  Restart rule
;      Fires when (restart) fact appears.
;      Asks the user whether to run again.
;      If yes  -- starts a new session by asserting n1 answer.
;      If no   -- prints goodbye and halts.
; ------------------------------------------------------------
(defrule restart-system
    ?r <- (restart)
    =>
    (retract ?r)
    (bind ?a (ask-question "Would you like a new recommendation? (yes/no): " yes no y n))
    (if (or (eq ?a yes) (eq ?a y))
        then
            (printout t crlf "=== Expert System: Pet Selection (Bangladesh) ===" crlf crlf)
            (assert (interaction
                (yesno "Is daily close interaction with your pet important to you? (yes/no): ")))
        else
            (printout t crlf "Goodbye!" crlf)
            (halt)))


; ------------------------------------------------------------
; 3.4  Print recommendation
;      Highest salience so it fires before any other rule.
;      Prints the result, retracts it, and triggers restart.
; ------------------------------------------------------------
(defrule print-rec
    (declare (salience 1000))
    ?rec <- (rec ?item)
    =>
    (printout t crlf "Recommended pet: " ?item crlf crlf)
    (retract ?rec)
    (assert (restart)))


; ============================================================
; 3.5  Question rules  (one rule per decision node)
;      Each rule binds its matching fact with ?f and retracts
;      it immediately  -- so working memory is fully clean after
;      every session and restart works without leftover facts.
;      Solid edge  = YES answer
;      Dashed edge = NO  answer
; ============================================================

; --- Entry point  -- Level 1  -- n1 ----------------------------
(defrule first ""
    (not (interaction ?))
    (not (rec ?))
    (not (restart))
    =>
    (printout t "=== Expert System: Pet Selection (Bangladesh) ===" crlf crlf)
    (assert (interaction
        (yesno "Is daily close interaction with your pet important to you? (yes/no): "))))

; --- Level 2  -- n2 / n3 -------------------------------------
(defrule interaction-yes ""
    ?f <- (interaction yes) (not (rec ?)) =>
    (retract ?f)
    (assert (walks
        (yesno "Are you ready to spend 1+ hour per day on walks and training? (yes/no): "))))

(defrule interaction-no ""
    ?f <- (interaction no) (not (rec ?)) =>
    (retract ?f)
    (assert (passive
        (yesno "Do you prefer a pet for passive observation? (yes/no): "))))

; --- Level 3  -- n4 / n5 / n6 / n7 --------------------------
(defrule walks-yes ""
    ?f <- (walks yes) (not (rec ?)) =>
    (retract ?f)
    (assert (space
        (yesno "Do you prefer a pet that needs space for active movement outside a cage? (yes/no): "))))

(defrule walks-no ""
    ?f <- (walks no) (not (rec ?)) =>
    (retract ?f)
    (assert (compact
        (yesno "Do you need a compact pet suitable for apartment living? (yes/no): "))))

(defrule passive-yes ""
    ?f <- (passive yes) (not (rec ?)) =>
    (retract ?f)
    (assert (aquarium
        (yesno "Are you ready to maintain an aquarium and regularly change the water? (yes/no): "))))

(defrule passive-no ""
    ?f <- (passive no) (not (rec ?)) =>
    (retract ?f)
    (assert (playpet
        (yesno "Do you want a pet for interaction and play without active walking? (yes/no): "))))

; --- Level 4  -- n8 / n9 / n10 / n11 / n12 / n13 / n14 / n15
(defrule space-yes ""
    ?f <- (space yes) (not (rec ?)) =>
    (retract ?f)
    (assert (trainable
        (yesno "Do you need a pet with good trainability and obedience? (yes/no): "))))

(defrule space-no ""
    ?f <- (space no) (not (rec ?)) =>
    (retract ?f)
    (assert (independent
        (yesno "Do you prefer a pet with an independent personality? (yes/no): "))))

(defrule compact-yes ""
    ?f <- (compact yes) (not (rec ?)) =>
    (retract ?f)
    (assert (nocturnal
        (yesno "Are you comfortable with a pet being active at night? (yes/no): "))))

(defrule compact-no ""
    ?f <- (compact no) (not (rec ?)) =>
    (retract ?f)
    (assert (quiet
        (yesno "Do you need a very quiet and calm pet? (yes/no): "))))

(defrule aquarium-yes ""
    ?f <- (aquarium yes) (not (rec ?)) =>
    (retract ?f)
    (assert (community
        (yesno "Do you want a community aquarium with several fish? (yes/no): "))))

(defrule aquarium-no ""
    ?f <- (aquarium no) (not (rec ?)) =>
    (retract ?f)
    (assert (slowexotic
        (yesno "Would you like a slow-moving, quiet exotic pet? (yes/no): "))))

(defrule playpet-yes ""
    ?f <- (playpet yes) (not (rec ?)) =>
    (retract ?f)
    (assert (talking
        (yesno "Do you want a bird that can talk or imitate sounds? (yes/no): "))))

(defrule playpet-no ""
    ?f <- (playpet no) (not (rec ?)) =>
    (retract ?f)
    (assert (bright
        (yesno "Do you like a bright or exotic-looking pet? (yes/no): "))))


; ============================================================
; 3.6  Recommendation rules  (one rule per leaf node)
;      Each also retracts its fact so working memory is
;      completely empty when the recommendation is made.
; ============================================================

(defrule trainable-yes   "" ?f <- (trainable yes)   (not (rec ?)) => (retract ?f) (assert (rec "Dog")))
(defrule trainable-no    "" ?f <- (trainable no)     (not (rec ?)) => (retract ?f) (assert (rec "Rabbit")))

(defrule independent-yes "" ?f <- (independent yes)  (not (rec ?)) => (retract ?f) (assert (rec "Cat")))
(defrule independent-no  "" ?f <- (independent no)   (not (rec ?)) => (retract ?f) (assert (rec "Guinea Pig")))

(defrule nocturnal-yes   "" ?f <- (nocturnal yes)    (not (rec ?)) => (retract ?f) (assert (rec "Hamster")))
(defrule nocturnal-no    "" ?f <- (nocturnal no)     (not (rec ?)) => (retract ?f) (assert (rec "Fancy Rat")))

(defrule quiet-yes       "" ?f <- (quiet yes)        (not (rec ?)) => (retract ?f) (assert (rec "Pigeon")))
(defrule quiet-no        "" ?f <- (quiet no)         (not (rec ?)) => (retract ?f) (assert (rec "Myna Bird")))

(defrule community-yes   "" ?f <- (community yes)    (not (rec ?)) => (retract ?f) (assert (rec "Aquarium Fish")))
(defrule community-no    "" ?f <- (community no)     (not (rec ?)) => (retract ?f) (assert (rec "Goldfish")))

(defrule slowexotic-yes  "" ?f <- (slowexotic yes)   (not (rec ?)) => (retract ?f) (assert (rec "Turtle")))
(defrule slowexotic-no   "" ?f <- (slowexotic no)    (not (rec ?)) => (retract ?f) (assert (rec "Cockatiel")))

(defrule talking-yes     "" ?f <- (talking yes)      (not (rec ?)) => (retract ?f) (assert (rec "Parrot")))
(defrule talking-no      "" ?f <- (talking no)       (not (rec ?)) => (retract ?f) (assert (rec "Canary")))

(defrule bright-yes      "" ?f <- (bright yes)       (not (rec ?)) => (retract ?f) (assert (rec "Lovebird")))
(defrule bright-no       "" ?f <- (bright no)        (not (rec ?)) => (retract ?f) (assert (rec "Budgerigar")))
