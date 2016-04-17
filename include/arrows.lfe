(include-lib "clj/include/compose.lfe")


(eval-when-compile
  (defun replace (smap lst)
    "Given a map of replacement pairs and a list/form, return a list/form with
    any elements = a key in `smap` replaced with the corresponding val in `smap`."
    (lists:map (lambda (x) (maps:get x smap x)) lst)))

(defmacro -<>*
  (`(,(= `(,h . ,t) form) ,x ,default-position) (when (is_list form))
   (funcall
    (match-lambda
      ((0 'first) `(,h ,x ,@t))
      ((0 'last)  `(,h ,@t ,x))
      ((1 _)      `(,h ,@(replace (maps:from_list `(#(<> ,x))) t))))
    (lists:foldl (lambda (y n) (if (=:= '<> y) (+ n 1) n)) 0 form)
    default-position))
  (`(,form ,_ ,_) form))

(defmacro -<>
  "the 'diamond wand': top-level insertion of x in place of single
  positional '<>' symbol within the threaded form if present, otherwise
  mostly behave as the thread-first macro. Also works with hash literals
  and vectors."
  (`(,x) x)
  (`(,x ,form) `(-<>* ,form ,x first))
  (`(,x ,form . ,forms) `(-<> (-<> ,x ,form) ,@forms)))

(defmacro -<>>
  "the 'diamond spear': top-level insertion of x in place of single
  positional '<>' symbol within the threaded form if present, otherwise
  mostly behave as the thread-last macro. Also works with hash literals
  and vectors."
  (`(,x) x)
  (`(,x ,form) `(-<>* ,form ,x last))
  (`(,x ,form . ,forms) `(-<>> (-<>> ,x ,form) ,@forms)))

(defmacro <<- forms
  "the 'back-arrow'"
  `(->> ,@(lists:reverse forms)))

(defmacro furcula*
  "sugar-free basis of public API"
  (`(,operator false ,form ,branches)
   (cons 'tuple (lists:map (lambda (branch) `(,operator ,form ,branch)) branches))))

(defmacro -<
  "'the furcula': branch one result into multiple flows"
  (`(,form . ,branches)
   `(furcula* -> false ,form ,branches)))

(defmacro -<<
  "'the trystero furcula': analog of ->> for furcula"
  (`(,form . ,branches)
   `(furcula* ->> false ,form ,branches)))

(defmacro -<><
  "'the diamond fishing rod': analog of -<> for furcula"
  (`(,form . ,branches)
   `(furcula* -<> false ,form ,branches)))

(defmacro -<>><
  "'the diamond harpoon': analog of -<>> for furcula"
  (`(,form . ,branches)
   `(furcula* -<>> false ,form ,branches)))

;; (defmacro apply->
;;   "applicative ->"
;;   (`(,h . ,t)
;;    `(-> ,@(cons h
;;                 (lists:map
;;                   (lambda (el)
;;                     (if (is_list el)
;;                       `(funcall ,(car el) ,@(cdr el))
;;                       (list `(partial #'apply/2 (lambda (x) ))))
;;                     (if (coll? el#)
;;                       `((partial apply ,(first el#)) ,@(rest el#))
;;                       (list `(partial apply ~el#))))
;;                   t)))))

;; (defmacro apply->>
;;   "applicative ->>"
;;   (`(,h . ,t)
;;    `(->> ,@(cons h (lists:map
;;                      (lambda (x)
;;                        (if (is_list x)
;;                          (cons 'apply x)
;;                          (list 'apply x)))
;;                      t)))))

(defmacro ok-<>
  "Like the diamond wand version of some-> but Erlangy.

  Thread val in (= `#(ok ,val) x), otherwise return x."
  (`(,x ,form)
   `(let ((,'y ,x))
      (case ,'y
        (`#(ok ,val) (-<> val ,form))
        (_ ,'y))))
  (`(,x ,form . ,forms) `(ok-<> (ok-<> ,x ,form) ,@forms)))

(defmacro ok-<>>
  "Like the diamond wand version of some->> but Erlangy.

  Thread val in (= `#(ok ,val) x), otherwise return x."
  (`(,x ,form)
   `(let ((,'y ,x))
      (case ,'y
        (`#(ok ,val) (-<>> val ,form))
        (_ ,'y))))
  (`(,x ,form . ,forms) `(ok-<>> (ok-<>> ,x ,form) ,@forms)))

(defmacro -!>
  "non-updating -> for unobtrusive side-effects"
  (`(,form . ,forms)
   ;; `(let ((x ,form)) (-> x# ~@forms) x#)
   `(progn (-> ,form ,@forms) ,form)))

(defmacro -!>>
  "non-updating ->> for unobtrusive side-effects"
  (`(,form . ,forms)
   `(progn (->> ,form ,@forms) ,form)))

(defmacro -!<>
  "non-updating -<> for unobtrusive side-effects"
  (`(,form . ,forms)
   `(progn (-<> ,form ,@forms) ,form)))

(defmacro -!<>>
  "non-updating -<>> for unobtrusive side-effects"
  (`(,form . ,forms)
   `(progn (-<>> ,form ,@forms) ,form)))

(defun loaded-arrows ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).
  This function needs to be the last one in this include."
  'ok)
