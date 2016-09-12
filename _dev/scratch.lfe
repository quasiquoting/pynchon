(defmacro apply->
  "applicative ->"
  (`(,h . ,t)
   `(clj:-> ,@(cons h
                    (lists:map
                      (lambda (el)
                        (if (is_list el)
                          `(funcall ,(car el) ,@(cdr el))
                          (list `(partial #'apply/2 (lambda (x) ))))
                        (if (coll? el#)
                          `((partial apply ,(first el#)) ,@(rest el#))
                          (list `(partial apply ~el#))))
                      t)))))

(defmacro apply->>
  "applicative ->>"
  (`(,h . ,t)
   `(clj:->> ,@(cons h (lists:map
                         (lambda (x)
                           (if (is_list x)
                             (cons 'apply x)
                             (list 'apply x)))
                         t)))))

(deftest applicative
  (is-equal (apply->> '((1 2) (3 4)) (#'lists:append/2) (#'+/4))
            10)
  (is-equal (apply->> '((1 2) (3 4)) (#'lists:append/2))
            '(1 2 3 4))
  ;; TODO: think on these
  ;; (is (= (apply->> [[1 2] [3 4]] (concat [5 6]))
  ;;        [1 2 3 4]))
  ;; (is (= (apply->> [[1 2] [3 4]] (concat [5 6]) (+))
  ;;        21))
  ;; (is (= (apply-> [[1 2] [3 4]] concat +)
  ;;        10))
  ;; (is (= (apply-> [1 2 3 4] (concat [[5 6]]))
  ;;        [1 2 3 4 5 6]))
  ;; (is (= (apply-> [1 2 3 4] (concat [[5 6]]) (+))
  ;;        21))
  )
