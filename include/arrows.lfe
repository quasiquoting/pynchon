;;; ============================================================= [ arrows.lfe ]

;;; ========================================================= [ clj re-exports ]

(defmacro ->     args `(clj:->         ,@args))
(defmacro ->>    args `(clj:->>        ,@args))

;;; ========================================================= [ Diamond macros ]

(defmacro -<>    args `(pynchon:-<>    ,@args))
(defmacro -<>>   args `(pynchon:-<>>   ,@args))

;;; ======================================================= [ Back arrow macro ]

(defmacro <<-    args `(pynchon:<<-    ,@args))

;;; ========================================================= [ Furcula macros ]

(defmacro -<     args `(pynchon:-<     ,@args))
(defmacro -<<    args `(pynchon:-<<    ,@args))
(defmacro -<><   args `(pynchon:-<><   ,@args))
(defmacro -<>><  args `(pynchon:-<>><  ,@args))

;;; ==================================================== [ ok-threading macros ]

(defmacro ok-<>  args `(pynchon:ok-<>  ,@args))
(defmacro ok-<>> args `(pynchon:ok-<>> ,@args))

;;; ==================================================== [ Non-updating macros ]

(defmacro -!>    args `(pynchon:-!>    ,@args))
(defmacro -!>>   args `(pynchon:-!>>   ,@args))
(defmacro -!<>   args `(pynchon:-!<>   ,@args))
(defmacro -!<>>  args `(pynchon:-!<>>  ,@args))

;;; ==================================================================== [ EOF ]
