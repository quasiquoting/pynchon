;;; ============================================================ [ pynchon.lfe ]

(defmodule pynchon
  "A collection of arrow macros."
  (export-macro
   ;; clj re-exports
   -> ->>
   ;; Diamond macros
   -<> -<>>
   ;; Back arrow macro
   <<-
   ;; Furcula macros
   -< -<< -<>< -<>><
   ;; ok-threading macors
   ok-<> ok-<>>
   ;; Non-updating macros
   -!> -!>> -!<> -!<>>))

;;; ========================================== [ Compile-time helper functions ]

(eval-when-compile
  (defun replace (smap lst)
    (lists:map (lambda (x) (maps:get x smap x)) lst))
  (defun -<>*
    ([(= `(,h . ,t) form) x default-position]
     (funcall
       (match-lambda
         ((0 'first) `(,h ,x ,@t))
         ((0 'last)  `(,h ,@t ,x))
         ((1 _)      `(,h ,@(replace `#m(<> ,x) t))))
       (lists:foldl (lambda (y n) (if (=:= '<> y) (+ n 1) n)) 0 form)
       default-position))
    ([form _ _] form))
  (defun furcula*
    ([operator 'false form branches]
     (cons 'tuple
           (lists:map
             (lambda (branch) `(,operator ,form ,branch))
             branches)))))

;;; ========================================================= [ clj re-exports ]

(defmacro -> args
  "Thread-first macro, re-exported from `clj`."
  `(clj:-> ,@args))

(defmacro ->> args
  "Thread-last macro, re-exported from `clj`."
  `(clj:->> ,@args))

;;; ========================================================= [ Diamond macros ]

(defmacro -<>
  "The *diamond wand*: top-level insertion of `x` in place of single
  positional `<>` symbol within the threaded `form` if present, otherwise
  mostly behave as the thread-first macro, [[->]]."
  (`(,x) x)
  (`(,x ,form) (-<>* form x 'first))
  (`(,x ,form . ,forms) `(-<> (-<> ,x ,form) ,@forms)))

(defmacro -<>>
  "The *diamond spear*: top-level insertion of `x` in place of single
  positional `<>` symbol within the threaded `form` if present, otherwise
  mostly behave as the thread-last macro, [[->>]]."
  (`(,x) x)
  (`(,x ,form) (-<>* form x 'last))
  (`(,x ,form . ,forms) `(-<>> (-<>> ,x ,form) ,@forms)))

;;; ======================================================= [ Back arrow macro ]

(defmacro <<- forms
  "The *back-arrow*.
  Equivalent to `(`[[->>]] `,@(lists:reverse forms))`."
  `(->> ,@(lists:reverse forms)))

;;; ========================================================= [ Furcula macros ]

(defmacro -<
  "*The furcula*: branch one result into multiple flows."
  (`(,form . ,branches)
   (furcula* '-> 'false form branches)))

(defmacro -<<
  "*The trystero furcula*: analog of [[->>]] for furcula."
  (`(,form . ,branches)
   (furcula* '->> 'false form branches)))

(defmacro -<><
  "*The diamond fishing rod*: analog of [[-<>]] for furcula."
  (`(,form . ,branches)
   (furcula* '-<> 'false form branches)))

(defmacro -<>><
  "*The diamond harpoon*: analog of [[-<>>]] for furcula."
  (`(,form . ,branches)
   (furcula* '-<>> 'false form branches)))

;;; ==================================================== [ ok-threading macros ]

(defmacro ok-<>
  "Like the diamond wand version of [`some->`], but Erlangy.
  Thread `val` in ``(= `#(ok ,val) x)``, otherwise return `x`.

  [`some->`]: http://clojuredocs.org/clojure.core/some-%3E"
  (`(,x ,form)
   `(let ((,'y ,x))
      (case ,'y
        (`#(ok ,val) (-<> val ,form))
        (_ ,'y))))
  (`(,x ,form . ,forms) `(ok-<> (ok-<> ,x ,form) ,@forms)))

(defmacro ok-<>>
  "Like the diamond wand version of [`some->>`],  but Erlangy.
  Thread `val` in ``(= `#(ok ,val) x)``, otherwise return `x`.

  [`some->>`]: http://clojuredocs.org/clojure.core/some-%3E%3E"
  (`(,x ,form)
   `(let ((,'y ,x))
      (case ,'y
        (`#(ok ,val) (-<>> val ,form))
        (_ ,'y))))
  (`(,x ,form . ,forms) `(ok-<>> (ok-<>> ,x ,form) ,@forms)))

;;; ==================================================== [ Non-updating macros ]

(defmacro -!>
  "Non-updating [[->]] for unobtrusive side-effects."
  (`(,form . ,forms)
   ;; `(let ((x ,form)) (-> x# ~@forms) x#)
   `(progn (-> ,form ,@forms) ,form)))

(defmacro -!>>
  "Non-updating [[->>]] for unobtrusive side-effects."
  (`(,form . ,forms)
   `(progn (->> ,form ,@forms) ,form)))

(defmacro -!<>
  "Non-updating [[-<>]] for unobtrusive side-effects."
  (`(,form . ,forms)
   `(progn (-<> ,form ,@forms) ,form)))

(defmacro -!<>>
  "Non-updating [[-<>>]] for unobtrusive side-effects."
  (`(,form . ,forms)
   `(progn (-<>> ,form ,@forms) ,form)))

;;; ==================================================================== [ EOF ]
