(include-lib "clj/include/compose.lfe")

(defmacro -<>* [form x default-position]
  (flet (;; Given a form (list). replace every occurrence of <>
         ;; with the value of `X'.
         (substitute-pos (form*) (replace (map '<> x) form*))
         ;; Given a form (list), return the number of occurrences of <>.
         (count-pos (form*) (length (lists:filter (lambda (y) (=:= '<> y)) form*))))
    (let (;; If `FORM' is a list, bind `(COUNT-POS FROM)` to `C', otherwise 0.
          (c (if (is_list form)
               (count-pos form)
               0)))
      (cond
       ;; If there are more than one occurrence of <> in `FORM`, throw an error.
       ((> c 1)
        (error "No more than one position per form is allowed."))
       ;; If there are no occurrences of <> in `FORM', perform the preferred
       ;; default behavior.
       ((== 0 c)
        ;; If `FORM' is a list, handle `DEFAULT-POSITION'.
        (if (is_list form)
          ;; If the value of `DEFAULT-POSITION` is the atom 'first, return
          ;; `FORM' with the value of `X' inserted at the first position.
          ;; Otherwise, return `FORM' with the value of `X' appended to the end.
          `(case (=:= 'first ,default-position)
             ('true  ,`(,(car form) ,x ,@(cdr form)))
             ('false ,`(,(car form) ,@(cdr form) ,x)))
          ;; Otherwise, return `FORM'.
          form))
       ;; If there is one occurrence of <> in `FORM',
       ;; return a copy of `FORM' with the occurrence of <>
       ;; replaced by the value of `X'.
       ((== 1 c)
        `(,(car form) ,@(substitute-pos (cdr form))))))))

(defmacro -<>
  "the 'diamond wand': top-level insertion of x in place of single
  positional '<>' symbol within the threaded form if present, otherwise
  mostly behave as the thread-first macro. Also works with hash literals
  and vectors."
  (`(,x) x)
  (`(,x ,form) `(-<>* ,form ,x 'first))
  (`(,x ,form . ,forms) `(-<> (-<> ,x ,form) ,@forms)))

(defmacro -<>>
  "the 'diamond spear': top-level insertion of x in place of single
  positional '<>' symbol within the threaded form if present, otherwise
  mostly behave as the thread-last macro. Also works with hash literals
  and vectors."
  (`(,x) x)
  (`(,x ,form) `(-<>* ,form ,x 'last))
  (`(,x ,form . ,forms) `(-<>> (-<>> ,x ,form) ,@forms)))

(defmacro <<- forms
  "the 'back-arrow'"
  `(->> ,@(lists:reverse forms)))

(defmacro furcula*
  "sugar-free basis of public API"
  (`(,operator false ,form ,branches)
   (cons
    'tuple
    (let ((branch-forms (lists:map
                         (lambda (branch)
                           `(,operator ,form ,branch))
                         branches)))
      branch-forms))))

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


;;;; == HELPER FUNCTIONS =======================================================

(defun replace (smap coll) (lists:map (lambda (x) (maps:get x smap x)) coll))

;;; The following allow developers to use (include-lib ...) on this file and
;;; pull in the functions from the passed module, making them available to
;;; call as if they were part of the language.
;; (defmacro generate-pynchon-wrappers ()
;;   `(progn ,@(kla:wrap-mod-funcs 'pynchon)))

;; (generate-pynchon-wrappers)

(defun loaded-pynchon ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).
  This function needs to be the last one in this include."
  'ok)
