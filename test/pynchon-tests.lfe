(defmodule pynchon-tests
  "pynchon tests"
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

(deftestgen diamond
  (list
    (tuple #"no forms"
           (is-match* 1 (pynchon:-<> (car (list 1)))))
    (tuple #"multiplication then list insertion"
           (is-match* '(1 2 0 3 4)
                      (pynchon:-<> 0
                                   (* <> 5)
                                   (list 1 2 <> 3 4))))
    (tuple #"contrived nesting"
           (is-equal* (lists:seq -1 12)
                      (pynchon:-<> (list 1 2 3)
                                   (list (list -1 0) <> (list 4 5)
                                         (pynchon:-<> 10
                                                      (list 7 8 9 <> 11 12)
                                                      (cons 6 <>)))
                                   (lists:append))))
    (tuple #"list insertion (match)"
           (is-match* '(1 2 3 10 4 5)
                      (pynchon:-<> 10 (list 1 2 3 <> 4 5))))
    (tuple #"list insertion (is_list)"
           (is* (is_list (pynchon:-<> 10 (list 1 2 3 <> 4 5)))))
    (tuple #"(list <>)"
           (is-match* '(0) (pynchon:-<> 0 (list <>))))
    (tuple #"positional <>"
           (is-match* '((6 7 8 9 10))
                      (pynchon:-<> (+ 2 (* 2 3))
                                   (list 6 7 <> 9 10)
                                   (list <>))))
    (tuple #"positional 'a"
           (is-match* (list 1 2 'a 10 4 5)
                      (pynchon:-<> 10 (list 1 2 'a <> 4 5))))
    (tuple #"-<> default first"
           (is-match* '(0 1 2 3) (pynchon:-<> 0 (list 1 2 3))))
    (tuple #"-<>> default last"
           (is-match* '(1 2 3 0) (pynchon:-<>> 0 (list 1 2 3))))
    ;; TODO: map
    ;; TODO: atom/fun
    (tuple #"two is too many <>"
           (is-error* #(expand_macro
                        (: pynchon -<> 0 (list <> <>))
                        #(too-many-<> 2))
                      (eval '(pynchon:-<> 0 (list <> <>)))))
    (tuple #"-<> default first"
           (is-match* '(0 1 2 3) (pynchon:-<> 0 (list 1 2 3))))
    (tuple #"-<>> default last"
           (is-match* '(1 2 3 0) (pynchon:-<>> 0 (list 1 2 3))))
    (tuple #"-<>> ++"
           (is-match* '(1 2 3 4) (pynchon:-<>> 4 (list) (++ '(1 2 3)))))
    (tuple #"-<> cons"
           (is-match* '(4 1 2 3) (pynchon:-<> 4 (cons '(1 2 3)))))
    (tuple #"contrived -<>>"
           (is-match* '(5 4 3 2)
                      (pynchon:-<>> 4
                                    (list)
                                    (++ '(1 2 3))
                                    (lists:reverse)
                                    (lists:map (lambda (x) (+ x 1)) <>))))
    (tuple #"contrived -<>"
           (is-match* '(4 3 2 5)
                      (pynchon:-<> 4
                                   (cons '(1 2 3))
                                   (lists:reverse)
                                   (lists:map (lambda (x) (+ x 1)) <>))))))

(deftestgen back-arrow
  (list
    (tuple #"is equal to `(->> ,@(lists:reverse forms))"
           (is-equal* (clj:->> (let ((more 'blah)) more)
                               (if (not (is_atom x)) 'foo)
                               (let ((x 'nonsense))))
                      (pynchon:<<- (let ((x 'nonsense)))
                                   (if (not (is_atom x)) 'foo)
                                   (let ((more 'blah)) more))))
    (tuple #"is equal to expected expansion"
           (is-equal* (let ((x 'nonsense))
                        (if (not (is_atom x))
                          'foo
                          (let ((more 'blah))
                            more)))
                      (pynchon:<<- (let ((x 'nonsense)))
                                   (if (not (is_atom x)) 'foo)
                                   (let ((more 'blah)) more))))
    (tuple #"matches expected result"
           (is-match* 'blah
                      (pynchon:<<- (let ((x 'nonsense)))
                                   (if (not (is_atom x)) 'foo)
                                   (let ((more 'blah)) more))))))

(deftestgen furculi
  (list
    (tuple #"simple furcula"
           (is-match* '#((3 2) (3 3) (3 4))
                      (pynchon:-< (+ 1 2)
                                  (list 2)
                                  (list 3)
                                  (list 4))))
    (tuple #"furcula with contrived threading"
           (is-match* '#((#(3) #(3) #(3)) (6) (3 4))
                      (pynchon:-< (+ 1 2)
                                  (clj:->> (tuple) (lists:duplicate 3))
                                  (clj:-> (* 2) (list))
                                  (list 4))))
    (tuple #"trystero furcula"
           (is-match* '#((2 1 3) (5 7 3) (9 4 3))
                      (pynchon:-<< (+ 1 2)
                                   (list 2 1)
                                   (list 5 7)
                                   (list 9 4))))
    (tuple #"diamond fishing rod"
           (is-match* '#((3 2 1) (5 3 7) (9 4 3))
                      (pynchon:-<>< (+ 1 2)
                                    (list <> 2 1)
                                    (list 5 <> 7)
                                    (list 9 4 <>))))
    (tuple #"diamond harpoon"
           (is-match* '#((3 2 1) (5 3 7) (9 4 3) (10 11 3))
                      (pynchon:-<>>< (+ 1 2)
                                     (list <> 2 1)
                                     (list 5 <> 7)
                                     (list 9 4 <>)
                                     (list 10 11))))))
