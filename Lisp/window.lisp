;;; also consider these projects
;;; https://github.com/andy128k/cl-gobject-introspection
;; https://github.com/kat-co/gir2cl

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cl-cffi-gtk)))

(defpackage #:window
  (:use #:cl
        #:cffi
        #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
(in-package :window)

;;; macros----------------------------------------------------------------------
(defvar *zzz*
  '(TYPECASE EVENT
    (GDK-EVENT-KEY
     (CASE (GDK-EVENT-KEY-TYPE EVENT)
       (:KEY-PRESS FUNC)
       (:KEY-RELEASE FUNC)))
    (GDK-EVENT-EXPOSE
     (CASE (GDK-EVENT-EXPOSE-TYPE EVENT)
       (:EXPOSE FUNC)))
    (GDK-EVENT-VISIBILITY
     (CASE (GDK-EVENT-VISIBILITY-TYPE EVENT)
       (:VISIBILITY-NOTIFY FUNC)))
    (GDK-EVENT-MOTION
     (CASE (GDK-EVENT-MOTION-TYPE EVENT)
       (:MOTION-NOTIFY FUNC)))
    (GDK-EVENT-BUTTON
     (CASE (GDK-EVENT-BUTTON-TYPE EVENT)
       (:BUTTON-PRESS FUNC)
       (:2BUTTON-PRESS FUNC)
       (:DOUBLE-BUTTON-PRESS FUNC)
       (:3BUTTON-PRESS FUNC)
       (:TRIPLE-BUTTON-PRESS FUNC)
       (:BUTTON-RELEASE FUNC)))
    (GDK-EVENT-TOUCH
     (CASE (GDK-EVENT-TOUCH-TYPE EVENT)
       (:TOUCH-BEGIN FUNC)
       (:TOUCH-UPDATE FUNC)
       (:TOUCH-END FUNC)
       (:TOUCH-CANCEL FUNC)))
    (GDK-EVENT-SCROLL
     (CASE (GDK-EVENT-SCROLL-TYPE EVENT)
       (:SCROLL FUNC)))
    (GDK-EVENT-CROSSING
     (CASE (GDK-EVENT-CROSSING-TYPE EVENT)
       (:ENTER-NOTIFY FUNC)
       (:LEAVE-NOTIFY FUNC)))
    (GDK-EVENT-FOCUS
     (CASE (GDK-EVENT-FOCUS-TYPE EVENT)
       (:FOCUS-CHANGE FUNC)))
    (GDK-EVENT-CONFIGURE
     (CASE (GDK-EVENT-CONFIGURE-TYPE EVENT)
       (:CONFIGURE FUNC)))
    (GDK-EVENT-PROPERTY
     (CASE (GDK-EVENT-PROPERTY-TYPE EVENT)
       (:PROPERTY-NOTIFY FUNC)))
    (GDK-EVENT-SELECTION
     (CASE (GDK-EVENT-SELECTION-TYPE EVENT)
       (:SELECTION-CLEAR FUNC)
       (:SELECTION-NOTIFY FUNC)
       (:SELECTION-REQUEST FUNC)))
    (GDK-EVENT-OWNER-CHANGE
     (CASE (GDK-EVENT-OWNER-CHANGE-TYPE EVENT)
       (:OWNER-CHANGE FUNC)))
    (GDK-EVENT-PROXIMITY
     (CASE (GDK-EVENT-PROXIMITY-TYPE EVENT)
       (:PROXIMITY-IN FUNC)
       (:PROXIMITY-OUT FUNC)))
    (GDK-EVENT-DND
     (CASE (GDK-EVENT-DND-TYPE EVENT)
       (:DRAG-ENTER FUNC)
       (:DRAG-LEAVE FUNC)
       (:DRAG-MOTION FUNC)
       (:DRAG-STATUS FUNC)
       (:DROP-START FUNC)
       (:DROP-FINISHED FUNC)))
    (GDK-EVENT-WINDOW-STATE
     (CASE (GDK-EVENT-WINDOW-STATE-TYPE EVENT)
       (:WINDOW-STATE FUNC)))
    (GDK-EVENT-SETTING
     (CASE (GDK-EVENT-SETTING-TYPE EVENT)
       (:SETTING FUNC)))
    (GDK-EVENT-GRAB-BROKEN
     (CASE (GDK-EVENT-GRAB-BROKEN-TYPE EVENT)
       (:GRAB-BROKEN FUNC)))))

;;; event structure=============================================================
;;; usual events
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gdk/gdk.event-structures.lisp::915
;;; all signals
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gtk/gtk.widget.lisp::424

(defvar *event-types* '(((:key-press :key-release) gdk-event-key
                         (time :uint32)
                         (state gdk-modifier-type)
                         (keyval :uint)
                         (length :int)
                         (string (:string :free-from-foreign nil
                                          :free-to-foreign nil))
                         (hardware-keycode :uint16)
                         (group :uint8)
                         (is-modifier :uint))

                        ((:expose) gdk-event-expose
                         (area gdk-rectangle :inline t)
                         (region (:pointer (:struct cairo-region-t)))
                         (count :int))

                        ((:visibility-notify) gdk-event-visibility
                         (state gdk-visibility-state))

                        ((:motion-notify) gdk-event-motion
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (is-hint :int16)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:button-press
                          :2button-press
                          :double-button-press
                          :3button-press
                          :triple-button-press
                          :button-release) gdk-event-button
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (button :uint)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:touch-begin
                          :touch-update
                          :touch-end
                          :touch-cancel) gdk-event-touch
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (sequence (g-boxed-foreign gdk-event-sequence))
                         (emulating-pointer :boolean)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:scroll) gdk-event-scroll
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (state gdk-modifier-type)
                         (direction gdk-scroll-direction)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double)
                         (delta-x :double)
                         (delta-y :double)
                         #+gdk-3-20
                         (is-stop :uint)) ; bitfield

                        ((:enter-notify :leave-notify) gdk-event-crossing
                         (subwindow (g-object gdk-window))
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (x-root :double)
                         (y-root :double)
                         (mode gdk-crossing-mode)
                         (detail gdk-notify-type)
                         (focus :boolean)
                         (state gdk-modifier-type))

                        ((:focus-change) gdk-event-focus
                         (in :int16))

                        ((:configure) gdk-event-configure
                         (x :int)
                         (y :int)
                         (width :int)
                         (height :int))

                        ((:property-notify) gdk-event-property
                         (atom gdk-atom)
                         (time :uint32)
                         (state gdk-property-state))

                        ((:selection-clear
                          :selection-notify
                          :selection-request) gdk-event-selection
                         (selection gdk-atom)
                         (target gdk-atom)
                         (property gdk-atom)
                         (time :uint32)
                         (requestor (g-object gdk-window)))

                        ((:owner-change) gdk-event-owner-change
                         (owner (g-object gdk-window))
                         (reason gdk-owner-change)
                         (selection gdk-atom)
                         (time :uint32)
                         (selection-time :uint32))

                        ((:proximity-in
                          :proximity-out) gdk-event-proximity
                         (time :uint32)
                         (device (g-object gdk-device)))

                        ((:drag-enter
                          :drag-leave
                          :drag-motion
                          :drag-status
                          :drop-start
                          :drop-finished) gdk-event-dnd
                         (context (g-object gdk-drag-context))
                         (time :uint32)
                         (x-root :short)
                         (y-root :short))

                        ((:window-state) gdk-event-window-state
                         (changed-mask gdk-window-state)
                         (new-window-state gdk-window-state))

                        ((:setting) gdk-event-setting
                         (action gdk-setting-action)
                         (name (:string :free-from-foreign nil :free-to-foreign nil)))

                        ((:grab-broken) gdk-event-grab-broken
                         (keyboard :boolean)
                         (implicit :boolean)
                         (grab-window (g-object gdk-window)))))

(defun trying ()
  `(typecase event
     ,@(loop for el in *event-types* collect
                                     (list (cadr el)
                                           `(case
                                                (,(symbol-with-suffix (cadr el) '-type) event)
                                              ,@(loop for vt in (car el)
                                                      collect (list  vt 'func)))))))

;;; TODO still needs more polish to have handlers for different widgets
(defun trying-again ()
  `(typecase event
     ,@(loop for el in *event-types*
             collect
             (list (cadr el)
                   `(,(symbol-with-suffix (cadr el) '-handler)
                     (,(symbol-with-suffix (cadr el) '-type) event)
                     ,@(loop for at in (cddr el) collect (list (symbol-with-suffix
                                                                (cadr el) (format nil "-~A"  (car at)))
                                                               'event))
                     )))))

(defun generate-handling (widget-name)
  `(defun ,(read-from-string (format nil "handling-~A" widget-name)) (widget event)
      , `(typecase event
          ,@(loop for el in *event-types*
                  collect
                  (list (cadr el)
                        `(,(symbol-with-suffix (cadr el)
                                               (format nil "-handler-~A" widget-name))
                          (,(symbol-with-suffix (cadr el) '-type) event)
                          ,@(loop for at in (cddr el) collect (list (symbol-with-suffix
                                                                     (cadr el) (format nil "-~A"  (car at)))
                                                                    'event))))))))
(defun generate-handlers (widget-name)
  `(list
     ,@(loop for el in *event-types*
             collect
             `(defun ,(read-from-string (format nil "~A-handler-~A" (cadr el) widget-name))
                  ,(cons 'type (loop for at in (cddr el) collect (car at)))

                (case type ,@(loop for et in (car el) collect (list et '(error "not implemented"))))))))

(defun symbol-with-suffix (symbol suffix)
  (read-from-string (format nil "~A~A" symbol suffix)))

;;; canvas======================================================================
(defun draw-canvas (model canvas context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (cr (pointer context)))

    (format nil "canvas ~a x ~a~%" w h)
    ;; prevent cr being destroyed improperly
    (cairo-reference cr)

    (draw-canvas-lines cr model)

    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

(defun inner (cr model)
  (let ((a (car model)))

    (when model
      (format t "~A~%" a )

      (progn
        (cairo-move-to cr
                       (* 1 (car a))
                       (* 1 (cdr a)))
        (cairo-line-to cr
                       (* 1 (car a))
                       (* 1 (cdr a))))
      (inner cr (cdr model)))))

(defun draw-canvas-lines (cr model)
  (cairo-set-source-rgb cr 0.6 0.9 0)
  (cairo-set-line-width cr 25)
  (cairo-set-line-cap cr :round)
  (cairo-set-line-join cr :round)

  ;; draw dots
  (cairo-set-source-rgb cr 0.4 0.6 0.1)
  (cairo-set-line-width cr 13)

  (inner cr model)

  (cairo-stroke cr))

;;; TODO play with drawing on canvas
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/demo/cairo-demo/cairo-demo.lisp::1
;; file:~/Programming/Pyrulis/Lisp/cairo-snake/cairo-snake.lisp::282
(defun draw-fun (canvas context)
  (let ((model *model*))
    (format t "model is ~A~%" model)
    (draw-canvas model canvas context)))

;;; event handling==============================================================
(defmacro handled (&rest body)
  `(progn
     (setf handled t)
     ,@body))


(defun canvas-event-fun (widget event)
  (declare (ignore widget))
  (let ((handled))
    ;; (format t "~&================== we have canvas event ~A~%" (gdk-event-type event))

    (typecase event
      (gdk-event-button (case (gdk-event-button-type event)
                          (:button-press (handled (format t "button press event handling~%"))))))

    (unless handled
      ;; (format t "the canvas event is not implemented~%~%")
      ))
  +gdk-event-propagate+)

;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gdk/gdk.event-structures.lisp::920

;;; autocomplete================================================================

(defun butlast-string (str)
  (if (>  (length str) 0)
      (subseq str 0 (1- (length str)))
      ""))

(defun autocomplete-options ()
    (list
"a" "abandon" "ability" "able" "abortion" "about" "above" "abroad" "absence" "absolute" "absolutely" "absorb" "abuse" "academic" "accept" "access" "accident" "accompany" "accomplish" "according" "account" "accurate" "accuse" "achieve" "achievement" "acid" "acknowledge" "acquire" "across" "act" "action" "active" "activist" "activity" "actor" "actress" "actual" "actually" "ad" "adapt" "add" "addition" "additional" "address" "adequate" "adjust" "adjustment" "administration" "administrator" "admire" "admission" "admit" "adolescent" "adopt" "adult" "advance" "advanced" "advantage" "adventure" "advertising" "advice" "advise" "adviser" "advocate" "affair" "affect" "afford" "afraid" "African" "African-American" "after" "afternoon" "again" "against" "age" "agency" "agenda" "agent" "aggressive" "ago" "agree" "agreement" "agricultural" "ah" "ahead" "aid" "aide" "AIDS" "aim" "air" "aircraft" "airline" "airport" "album" "alcohol" "alive" "all" "alliance" "allow" "ally" "almost" "alone" "along" "already" "also" "alter" "alternative" "although" "always" "AM" "amazing" "American" "among" "amount" "analysis" "analyst" "analyze" "ancient" "and" "anger" "angle" "angry" "animal" "anniversary" "announce" "annual" "another" "answer" "anticipate" "anxiety" "any" "anybody" "anymore" "anyone" "anything" "anyway" "anywhere" "apart" "apartment" "apparent" "apparently" "appeal" "appear" "appearance" "apple" "application" "apply" "appoint" "appointment" "appreciate" "approach" "appropriate" "approval" "approve" "approximately" "Arab" "architect" "area" "argue" "argument" "arise" "arm" "armed" "army" "around" "arrange" "arrangement" "arrest" "arrival" "arrive" "art" "article" "artist" "artistic" "as" "Asian" "aside" "ask" "asleep" "aspect" "assault" "assert" "assess" "assessment" "asset" "assign" "assignment" "assist" "assistance" "assistant" "associate" "association" "assume" "assumption" "assure" "at" "athlete" "athletic" "atmosphere" "attach" "attack" "attempt" "attend" "attention" "attitude" "attorney" "attract" "attractive" "attribute" "audience" "author" "authority" "auto" "available" "average" "avoid" "award" "aware" "awareness" "away" "awful" "baby" "back" "background" "bad" "badly" "bag" "bake" "balance" "ball" "ban" "band" "bank" "bar" "barely" "barrel" "barrier" "base" "baseball" "basic" "basically" "basis" "basket" "basketball" "bathroom" "battery" "battle" "be" "beach" "bean" "bear" "beat" "beautiful" "beauty" "because" "become" "bed" "bedroom" "beer" "before" "begin" "beginning" "behavior" "behind" "being" "belief" "believe" "bell" "belong" "below" "belt" "bench" "bend" "beneath" "benefit" "beside" "besides" "best" "bet" "better" "between" "beyond" "Bible" "big" "bike" "bill" "billion" "bind" "biological" "bird" "birth" "birthday" "bit" "bite" "black" "blade" "blame" "blanket" "blind" "block" "blood" "blow" "blue" "board" "boat" "body" "bomb" "bombing" "bond" "bone" "book" "boom" "boot" "border" "born" "borrow" "boss" "both" "bother" "bottle" "bottom" "boundary" "bowl" "box" "boy" "boyfriend" "brain" "branch" "brand" "bread" "break" "breakfast" "breast" "breath" "breathe" "brick" "bridge" "brief" "briefly" "bright" "brilliant" "bring" "British" "broad" "broken" "brother" "brown" "brush" "buck" "budget" "build" "building" "bullet" "bunch" "burden" "burn" "bury" "bus" "business" "busy" "but" "butter" "button" "buy" "buyer" "by" "cabin" "cabinet" "cable" "cake" "calculate" "call" "camera" "camp" "campaign" "campus" "can" "Canadian" "cancer" "candidate" "cap" "capability" "capable" "capacity" "capital" "captain" "capture" "car" "carbon" "card" "care" "career" "careful" "carefully" "carrier" "carry" "case" "cash" "cast" "cat" "catch" "category" "Catholic" "cause" "ceiling" "celebrate" "celebration" "celebrity" "cell" "center" "central" "century" "CEO" "ceremony" "certain" "certainly" "chain" "chair" "chairman" "challenge" "chamber" "champion" "championship" "chance" "change" "changing" "channel" "chapter" "character" "characteristic" "characterize" "charge" "charity" "chart" "chase" "cheap" "check" "cheek" "cheese" "chef" "chemical" "chest" "chicken" "chief" "child" "childhood" "Chinese" "chip" "chocolate" "choice" "cholesterol" "choose" "Christian" "Christmas" "church" "cigarette" "circle" "circumstance" "cite" "citizen" "city" "civil" "civilian" "claim" "class" "classic" "classroom" "clean" "clear" "clearly" "client" "climate" "climb" "clinic" "clinical" "clock" "close" "closely" "closer" "clothes" "clothing" "cloud" "club" "clue" "cluster" "coach" "coal" "coalition" "coast" "coat" "code" "coffee" "cognitive" "cold" "collapse" "colleague" "collect" "collection" "collective" "college" "colonial" "color" "column" "combination" "combine" "come" "comedy" "comfort" "comfortable" "command" "commander" "comment" "commercial" "commission" "commit" "commitment" "committee" "common" "communicate" "communication" "community" "company" "compare" "comparison" "compete" "competition" "competitive" "competitor" "complain" "complaint" "complete" "completely" "complex" "complicated" "component" "compose" "composition" "comprehensive" "computer" "concentrate" "concentration" "concept" "concern" "concerned" "concert" "conclude" "conclusion" "concrete" "condition" "conduct" "conference" "confidence" "confident" "confirm" "conflict" "confront" "confusion" "Congress" "congressional" "connect" "connection" "consciousness" "consensus" "consequence" "conservative" "consider" "considerable" "consideration" "consist" "consistent" "constant" "constantly" "constitute" "constitutional" "construct" "construction" "consultant" "consume" "consumer" "consumption" "contact" "contain" "container" "contemporary" "content" "contest" "context" "continue" "continued" "contract" "contrast" "contribute" "contribution" "control" "controversial" "controversy" "convention" "conventional" "conversation" "convert" "conviction" "convince" "cook" "cookie" "cooking" "cool" "cooperation" "cop" "cope" "copy" "core" "corn" "corner" "corporate" "corporation" "correct" "correspondent" "cost" "cotton" "couch" "could" "council" "counselor" "count" "counter" "country" "county" "couple" "courage" "course" "court" "cousin" "cover" "coverage" "cow" "crack" "craft" "crash" "crazy" "cream" "create" "creation" "creative" "creature" "credit" "crew" "crime" "criminal" "crisis" "criteria" "critic" "critical" "criticism" "criticize" "crop" "cross" "crowd" "crucial" "cry" "cultural" "culture" "cup" "curious" "current" "currently" "curriculum" "custom" "customer" "cut" "cycle" "dad" "daily" "damage" "dance" "danger" "dangerous" "dare" "dark" "darkness" "data" "date" "daughter" "day" "dead" "deal" "dealer" "dear" "death" "debate" "debt" "decade" "decide" "decision" "deck" "declare" "decline" "decrease" "deep" "deeply" "deer" "defeat" "defend" "defendant" "defense" "defensive" "deficit" "define" "definitely" "definition" "degree" "delay" "deliver" "delivery" "demand" "democracy" "Democrat" "democratic" "demonstrate" "demonstration" "deny" "department" "depend" "dependent" "depending" "depict" "depression" "depth" "deputy" "derive" "describe" "description" "desert" "deserve" "design" "designer" "desire" "desk" "desperate" "despite" "destroy" "destruction" "detail" "detailed" "detect" "determine" "develop" "developing" "development" "device" "devote" "dialogue" "die" "diet" "differ" "difference" "different" "differently" "difficult" "difficulty" "dig" "digital" "dimension" "dining" "dinner" "direct" "direction" "directly" "director" "dirt" "dirty" "disability" "disagree" "disappear" "disaster" "discipline" "discourse" "discover" "discovery" "discrimination" "discuss" "discussion" "disease" "dish" "dismiss" "disorder" "display" "dispute" "distance" "distant" "distinct" "distinction" "distinguish" "distribute" "distribution" "district" "diverse" "diversity" "divide" "division" "divorce" "DNA" "do" "doctor" "document" "dog" "domestic" "dominant" "dominate" "door" "double" "doubt" "down" "downtown" "dozen" "draft" "drag" "drama" "dramatic" "dramatically" "draw" "drawing" "dream" "dress" "drink" "drive" "driver" "drop" "drug" "dry" "due" "during" "dust" "duty" "each" "eager" "ear" "early" "earn" "earnings" "earth" "ease" "easily" "east" "eastern" "easy" "eat" "economic" "economics" "economist" "economy" "edge" "edition" "editor" "educate" "education" "educational" "educator" "effect" "effective" "effectively" "efficiency" "efficient" "effort" "egg" "eight" "either" "elderly" "elect" "election" "electric" "electricity" "electronic" "element" "elementary" "eliminate" "elite" "else" "elsewhere" "e-mail" "embrace" "emerge" "emergency" "emission" "emotion" "emotional" "emphasis" "emphasize" "employ" "employee" "employer" "employment" "empty" "enable" "encounter" "encourage" "end" "enemy" "energy" "enforcement" "engage" "engine" "engineer" "engineering" "English" "enhance" "enjoy" "enormous" "enough" "ensure" "enter" "enterprise" "entertainment" "entire" "entirely" "entrance" "entry" "environment" "environmental" "episode" "equal" "equally" "equipment" "era" "error" "escape" "especially" "essay" "essential" "essentially" "establish" "establishment" "estate" "estimate" "etc" "ethics" "ethnic" "European" "evaluate" "evaluation" "even" "evening" "event" "eventually" "ever" "every" "everybody" "everyday" "everyone" "everything" "everywhere" "evidence" "evolution" "evolve" "exact" "exactly" "examination" "examine" "example" "exceed" "excellent" "except" "exception" "exchange" "exciting" "executive" "exercise" "exhibit" "exhibition" "exist" "existence" "existing" "expand" "expansion" "expect" "expectation" "expense" "expensive" "experience" "experiment" "expert" "explain" "explanation" "explode" "explore" "explosion" "expose" "exposure" "express" "expression" "extend" "extension" "extensive" "extent" "external" "extra" "extraordinary" "extreme" "extremely" "eye" "fabric" "face" "facility" "fact" "factor" "factory" "faculty" "fade" "fail" "failure" "fair" "fairly" "faith" "fall" "false" "familiar" "family" "famous" "fan" "fantasy" "far" "farm" "farmer" "fashion" "fast" "fat" "fate" "father" "fault" "favor" "favorite" "fear" "feature" "federal" "fee" "feed" "feel" "feeling" "fellow" "female" "fence" "few" "fewer" "fiber" "fiction" "field" "fifteen" "fifth" "fifty" "fight" "fighter" "fighting" "figure" "file" "fill" "film" "final" "finally" "finance" "financial" "find" "finding" "fine" "finger" "finish" "fire" "firm" "first" "fish" "fishing" "fit" "fitness" "five" "fix" "flag" "flame" "flat" "flavor" "flee" "flesh" "flight" "float" "floor" "flow" "flower" "fly" "focus" "folk" "follow" "following" "food" "foot" "football" "for" "force" "foreign" "forest" "forever" "forget" "form" "formal" "formation" "former" "formula" "forth" "fortune" "forward" "found" "foundation" "founder" "four" "fourth" "frame" "framework" "free" "freedom" "freeze" "French" "frequency" "frequent" "frequently" "fresh" "friend" "friendly" "friendship" "from" "front" "fruit" "frustration" "fuel" "full" "fully" "fun" "function" "fund" "fundamental" "funding" "funeral" "funny" "furniture" "furthermore" "future" "gain" "galaxy" "gallery" "game" "gang" "gap" "garage" "garden" "garlic" "gas" "gate" "gather" "gay" "gaze" "gear" "gender" "gene" "general" "generally" "generate" "generation" "genetic" "gentleman" "gently" "German" "gesture" "get" "ghost" "giant" "gift" "gifted" "girl" "girlfriend" "give" "given" "glad" "glance" "glass" "global" "glove" "go" "goal" "God" "gold" "golden" "golf" "good" "government" "governor" "grab" "grade" "gradually" "graduate" "grain" "grand" "grandfather" "grandmother" "grant" "grass" "grave" "gray" "great" "greatest" "green" "grocery" "ground" "group" "grow" "growing" "growth" "guarantee" "guard" "guess" "guest" "guide" "guideline" "guilty" "gun" "guy" "habit" "habitat" "hair" "half" "hall" "hand" "handful" "handle" "hang" "happen" "happy" "hard" "hardly" "hat" "hate" "have" "he" "head" "headline" "headquarters" "health" "healthy" "hear" "hearing" "heart" "heat" "heaven" "heavily" "heavy" "heel" "height" "helicopter" "hell" "hello" "help" "helpful" "her" "here" "heritage" "hero" "herself" "hey" "hi" "hide" "high" "highlight" "highly" "highway" "hill" "him" "himself" "hip" "hire" "his" "historian" "historic" "historical" "history" "hit" "hold" "hole" "holiday" "holy" "home" "homeless" "honest" "honey" "honor" "hope" "horizon" "horror" "horse" "hospital" "host" "hot" "hotel" "hour" "house" "household" "housing" "how" "however" "huge" "human" "humor" "hundred" "hungry" "hunter" "hunting" "hurt" "husband" "hypothesis" "I" "ice" "idea" "ideal" "identification" "identify" "identity" "ie" "if" "ignore" "ill" "illegal" "illness" "illustrate" "image" "imagination" "imagine" "immediate" "immediately" "immigrant" "immigration" "impact" "implement" "implication" "imply" "importance" "important" "impose" "impossible" "impress" "impression" "impressive" "improve" "improvement" "in" "incentive" "incident" "include" "including" "income" "incorporate" "increase" "increased" "increasing" "increasingly" "incredible" "indeed" "independence" "independent" "index" "Indian" "indicate" "indication" "individual" "industrial" "industry" "infant" "infection" "inflation" "influence" "inform" "information" "ingredient" "initial" "initially" "initiative" "injury" "inner" "innocent" "inquiry" "inside" "insight" "insist" "inspire" "install" "instance" "instead" "institution" "institutional" "instruction" "instructor" "instrument" "insurance" "intellectual" "intelligence" "intend" "intense" "intensity" "intention" "interaction" "interest" "interested" "interesting" "internal" "international" "Internet" "interpret" "interpretation" "intervention" "interview" "into" "introduce" "introduction" "invasion" "invest" "investigate" "investigation" "investigator" "investment" "investor" "invite" "involve" "involved" "involvement" "Iraqi" "Irish" "iron" "Islamic" "island" "Israeli" "issue" "it" "Italian"

"item" "its" "itself" "jacket" "jail" "Japanese" "jet" "Jew" "Jewish" "job" "join" "joint" "joke" "journal" "journalist" "journey" "joy" "judge" "judgment" "juice" "jump" "junior" "jury" "just" "justice" "justify" "keep" "key" "kick" "kid" "kill" "killer" "killing" "kind" "king" "kiss" "kitchen" "knee" "knife" "knock" "know" "knowledge" "lab" "label" "labor" "laboratory" "lack" "lady" "lake" "land" "landscape" "language" "lap" "large" "largely" "last" "late" "later" "Latin" "latter" "laugh" "launch" "law" "lawn" "lawsuit" "lawyer" "lay" "layer" "lead" "leader" "leadership" "leading" "leaf" "league" "lean" "learn" "learning" "least" "leather" "leave" "left" "leg" "legacy" "legal" "legend" "legislation" "legitimate" "lemon" "length" "less" "lesson" "let" "letter" "level" "liberal" "library" "license" "lie" "life" "lifestyle" "lifetime" "lift" "light" "like" "likely" "limit" "limitation" "limited" "line" "link" "lip" "list" "listen" "literally" "literary" "literature"
"little" "live" "living" "load" "loan" "local" "locate" "location" "lock" "long" "long-term" "look" "loose" "lose" "loss" "lost" "lot" "lots" "loud" "love" "lovely" "lover" "low" "lower" "luck" "lucky" "lunch" "lung" "machine" "mad" "magazine" "mail" "main" "mainly" "maintain" "maintenance" "major" "majority" "make" "maker" "makeup" "male" "mall" "man" "manage" "management" "manager" "manner" "manufacturer" "manufacturing" "many" "map" "margin" "mark" "market" "marketing" "marriage" "married" "marry" "mask" "mass" "massive" "master" "match" "material" "math" "matter" "may" "maybe" "mayor" "me" "meal" "mean" "meaning" "meanwhile" "measure" "measurement" "meat" "mechanism" "media" "medical" "medication" "medicine" "medium" "meet" "meeting" "member" "membership" "memory" "mental" "mention" "menu" "mere" "merely" "mess" "message" "metal" "meter" "method" "Mexican" "middle" "might" "military" "milk" "million" "mind" "mine" "minister" "minor" "minority" "minute" "miracle" "mirror" "miss" "missile" "mission" "mistake"
"mix" "mixture" "mm-hmm" "mode" "model" "moderate" "modern" "modest" "mom" "moment" "money" "monitor" "month" "mood" "moon" "moral" "more" "moreover" "morning" "mortgage" "most" "mostly" "mother" "motion" "motivation" "motor" "mount" "mountain" "mouse" "mouth" "move" "movement" "movie" "Mr" "Mrs" "Ms" "much" "multiple" "murder" "muscle" "museum" "music" "musical" "musician" "Muslim" "must" "mutual" "my" "myself" "mystery" "myth" "naked" "name" "narrative" "narrow" "nation" "national" "native" "natural" "naturally" "nature" "near" "nearby" "nearly" "necessarily" "necessary" "neck" "need" "negative" "negotiate" "negotiation" "neighbor" "neighborhood" "neither" "nerve" "nervous" "net" "network" "never" "nevertheless" "new" "newly" "news" "newspaper" "next" "nice" "night" "nine" "no" "nobody" "nod" "noise" "nomination" "none" "nonetheless" "nor" "normal" "normally" "north" "northern" "nose" "not" "note" "nothing" "notice" "notion" "novel" "now" "nowhere" "n't" "nuclear" "number" "numerous" "nurse" "nut" "object" "objective" "obligation" "observation" "observe" "observer" "obtain" "obvious" "obviously" "occasion" "occasionally" "occupation" "occupy" "occur" "ocean" "odd" "odds" "of" "off" "offense" "offensive" "offer" "office" "officer" "official" "often" "oh" "oil" "ok" "okay" "old" "Olympic" "on" "once" "one" "ongoing" "onion" "online" "only" "onto" "open" "opening" "operate" "operating" "operation" "operator" "opinion" "opponent" "opportunity" "oppose" "opposite" "opposition" "option" "or" "orange" "order" "ordinary" "organic" "organization" "organize" "orientation" "origin" "original" "originally" "other" "others" "otherwise" "ought" "our" "ourselves" "out" "outcome" "outside" "oven" "over" "overall" "overcome" "overlook" "owe" "own" "owner" "pace" "pack" "package" "page" "pain" "painful" "paint" "painter" "painting" "pair" "pale" "Palestinian" "palm" "pan" "panel" "pant" "paper" "parent" "park" "parking" "part" "participant" "participate" "participation" "particular" "particularly" "partly" "partner" "partnership" "party" "pass" "passage" "passenger" "passion" "past" "patch" "path" "patient" "pattern" "pause" "pay" "payment" "PC" "peace" "peak" "peer" "penalty" "people" "pepper" "per" "perceive" "percentage" "perception" "perfect" "perfectly" "perform" "performance" "perhaps" "period" "permanent" "permission" "permit" "person" "personal" "personality" "personally" "personnel" "perspective" "persuade" "pet" "phase" "phenomenon" "philosophy" "phone" "photo" "photograph" "photographer" "phrase" "physical" "physically" "physician" "piano" "pick" "picture" "pie" "piece" "pile" "pilot" "pine" "pink" "pipe" "pitch" "place" "plan" "plane" "planet" "planning" "plant" "plastic" "plate" "platform" "play" "player" "please" "pleasure" "plenty" "plot" "plus" "PM" "pocket" "poem" "poet" "poetry" "point" "pole" "police" "policy" "political" "politically" "politician" "politics" "poll" "pollution" "pool" "poor" "pop" "popular" "population" "porch" "port" "portion" "portrait" "portray" "pose" "position" "positive" "possess" "possibility" "possible" "possibly" "post" "pot" "potato" "potential" "potentially" "pound" "pour" "poverty" "powder" "power" "powerful" "practical" "practice" "pray" "prayer" "precisely" "predict" "prefer" "preference" "pregnancy" "pregnant" "preparation" "prepare" "prescription" "presence" "present" "presentation" "preserve" "president" "presidential" "press" "pressure" "pretend" "pretty" "prevent" "previous" "previously" "price" "pride" "priest" "primarily" "primary" "prime" "principal" "principle" "print" "prior" "priority" "prison" "prisoner" "privacy" "private" "probably" "problem" "procedure" "proceed" "process" "produce" "producer" "product" "production" "profession" "professional" "professor" "profile" "profit" "program" "progress" "project" "prominent" "promise" "promote" "prompt" "proof" "proper" "properly" "property" "proportion" "proposal" "propose" "proposed" "prosecutor" "prospect" "protect" "protection" "protein" "protest" "proud" "prove" "provide" "provider" "province" "provision" "psychological" "psychologist" "psychology" "public" "publication" "publicly" "publish" "publisher" "pull" "punishment" "purchase" "pure" "purpose" "pursue" "push" "put" "qualify" "quality" "quarter" "quarterback" "question" "quick" "quickly" "quiet" "quietly" "quit" "quite" "quote" "race" "racial" "radical" "radio" "rail" "rain" "raise" "range" "rank" "rapid" "rapidly" "rare" "rarely" "rate" "rather" "rating" "ratio" "raw" "reach" "react" "reaction" "read" "reader" "reading" "ready" "real" "reality" "realize" "really" "reason" "reasonable" "recall" "receive" "recent" "recently" "recipe" "recognition" "recognize" "recommend" "recommendation" "record" "recording" "recover" "recovery" "recruit" "red" "reduce" "reduction" "refer" "reference" "reflect" "reflection" "reform" "refugee" "refuse" "regard" "regarding" "regardless" "regime" "region" "regional" "register" "regular" "regularly" "regulate" "regulation" "reinforce" "reject" "relate" "relation" "relationship" "relative" "relatively" "relax" "release" "relevant" "relief" "religion" "religious" "rely" "remain" "remaining" "remarkable" "remember" "remind" "remote" "remove" "repeat" "repeatedly" "replace" "reply" "report" "reporter" "represent" "representation" "representative" "Republican" "reputation" "request" "require" "requirement" "research" "researcher" "resemble" "reservation" "resident" "resist" "resistance" "resolution" "resolve" "resort" "resource" "respect" "respond" "respondent" "response" "responsibility" "responsible" "rest" "restaurant" "restore" "restriction" "result" "retain" "retire" "retirement" "return" "reveal" "revenue" "review" "revolution" "rhythm" "rice" "rich" "rid" "ride" "rifle" "right" "ring" "rise" "risk" "river" "road" "rock" "role" "roll" "romantic" "roof" "room" "root" "rope" "rose" "rough" "roughly" "round" "route" "routine" "row" "rub" "rule" "run" "running" "rural" "rush" "Russian" "sacred" "sad" "safe" "safety" "sake" "salad" "salary" "sale" "sales" "salt" "same" "sample" "sanction" "sand" "satellite" "satisfaction" "satisfy" "sauce" "save" "saving" "say" "scale" "scandal" "scared" "scenario" "scene" "schedule" "scheme" "scholar" "scholarship" "school" "science" "scientific" "scientist" "scope" "score" "scream" "screen" "script" "sea" "search" "season" "seat" "second" "secret" "secretary" "section" "sector" "secure" "security" "see" "seed" "seek" "seem" "segment" "seize" "select" "selection" "self" "sell" "Senate" "senator" "send" "senior" "sense" "sensitive" "sentence" "separate" "sequence" "series" "serious" "seriously" "serve" "service" "session" "set" "setting" "settle" "settlement" "seven" "several" "severe" "sex" "sexual" "shade" "shadow" "shake" "shall" "shape" "share" "sharp" "she" "sheet" "shelf" "shell" "shelter" "shift" "shine" "ship" "shirt" "shit" "shock" "shoe" "shoot" "shooting" "shop" "shopping" "shore" "short" "shortly" "shot" "should" "shoulder" "shout" "show" "shower" "shrug" "shut" "sick" "side" "sigh" "sight" "sign" "signal" "significance" "significant" "significantly" "silence" "silent" "silver" "similar" "similarly" "simple" "simply" "sin" "since" "sing" "singer" "single" "sink" "sir" "sister" "sit" "site" "situation" "six" "size" "ski" "skill" "skin" "sky" "slave" "sleep" "slice" "slide" "slight" "slightly" "slip" "slow" "slowly" "small" "smart" "smell" "smile" "smoke" "smooth" "snap" "snow" "so" "so-called" "soccer" "social" "society" "soft" "software" "soil" "solar" "soldier" "solid" "solution" "solve" "some" "somebody" "somehow" "someone" "something" "sometimes" "somewhat" "somewhere" "son" "song" "soon" "sophisticated" "sorry" "sort" "soul" "sound" "soup" "source" "south" "southern" "Soviet" "space" "Spanish" "speak" "speaker" "special" "specialist" "species" "specific" "specifically" "speech" "speed" "spend" "spending" "spin" "spirit" "spiritual" "split" "spokesman" "sport" "spot" "spread" "spring" "square" "squeeze" "stability" "stable" "staff" "stage" "stair" "stake" "stand" "standard" "standing" "star" "stare" "start" "state" "statement" "station" "statistics" "status" "stay" "steady" "steal" "steel" "step" "stick" "still" "stir" "stock" "stomach" "stone" "stop" "storage" "store" "storm" "story" "straight" "strange" "stranger" "strategic" "strategy" "stream" "street" "strength" "strengthen" "stress" "stretch" "strike" "string" "strip" "stroke" "strong" "strongly" "structure" "struggle" "student" "studio" "study" "stuff" "stupid" "style" "subject" "submit" "subsequent" "substance" "substantial" "succeed" "success" "successful" "successfully" "such" "sudden" "suddenly" "sue" "suffer" "sufficient" "sugar" "suggest" "suggestion" "suicide" "suit" "summer" "summit" "sun" "super" "supply" "support" "supporter" "suppose" "supposed" "Supreme" "sure" "surely" "surface" "surgery" "surprise" "surprised" "surprising" "surprisingly" "surround" "survey" "survival" "survive" "survivor" "suspect" "sustain" "swear" "sweep" "sweet" "swim" "swing" "switch" "symbol" "symptom" "system" "table" "tablespoon" "tactic" "tail" "take" "tale" "talent" "talk" "tall" "tank" "tap" "tape" "target" "task" "taste" "tax" "taxpayer" "tea" "teach" "teacher" "teaching" "team" "tear" "teaspoon" "technical" "technique" "technology" "teen" "teenager" "telephone" "telescope" "television" "tell" "temperature" "temporary" "ten" "tend" "tendency" "tennis" "tension" "tent" "term" "terms" "terrible" "territory" "terror" "terrorism" "terrorist" "test" "testify" "testimony" "testing" "text" "than" "thank" "thanks" "that" "the" "theater" "their" "them" "theme" "themselves" "then" "theory" "therapy" "there" "therefore" "these" "they" "thick" "thin" "thing" "think" "thinking" "third" "thirty" "this" "those" "though" "thought" "thousand" "threat" "threaten" "three" "throat" "through" "throughout" "throw" "thus" "ticket" "tie" "tight" "time" "tiny" "tip" "tire" "tired" "tissue" "title" "to" "tobacco" "today" "toe" "together" "tomato" "tomorrow" "tone" "tongue" "tonight" "too" "tool" "tooth" "top" "topic" "toss" "total" "totally" "touch" "tough" "tour" "tourist" "tournament" "toward" "towards" "tower" "town" "toy" "trace" "track" "trade" "tradition" "traditional" "traffic" "tragedy" "trail" "train" "training" "transfer" "transform" "transformation" "transition" "translate" "transportation" "travel" "treat" "treatment" "treaty" "tree" "tremendous" "trend" "trial" "tribe" "trick" "trip" "troop" "trouble" "truck" "true" "truly" "trust" "truth" "try" "tube" "tunnel" "turn" "TV" "twelve" "twenty" "twice" "twin" "two" "type" "typical" "typically" "ugly" "ultimate" "ultimately" "unable" "uncle" "under" "undergo" "understand" "understanding" "unfortunately" "uniform" "union" "unique" "unit" "United" "universal" "universe" "university" "unknown" "unless" "unlike" "unlikely" "until" "unusual" "up" "upon" "upper" "urban" "urge" "us" "use" "used" "useful" "user" "usual" "usually" "utility" "vacation" "valley" "valuable" "value" "variable" "variation" "variety" "various" "vary" "vast" "vegetable" "vehicle" "venture" "version" "versus" "very" "vessel" "veteran" "via" "victim" "victory" "video" "view" "viewer" "village" "violate" "violation" "violence" "violent" "virtually" "virtue" "virus" "visible" "vision" "visit" "visitor" "visual" "vital" "voice" "volume" "volunteer" "vote" "voter" "vs" "vulnerable" "wage" "wait" "wake" "walk" "wall" "wander" "want" "war" "warm" "warn" "warning" "wash" "waste" "watch" "water" "wave" "way" "we" "weak" "wealth" "wealthy" "weapon" "wear" "weather" "wedding" "week" "weekend" "weekly" "weigh" "weight" "welcome" "welfare" "well" "west" "western" "wet" "what" "whatever" "wheel" "when" "whenever" "where" "whereas" "whether" "which" "while" "whisper" "white" "who" "whole" "whom" "whose" "why" "wide" "widely" "widespread" "wife" "wild" "will" "willing" "win" "wind" "window" "wine" "wing" "winner" "winter" "wipe" "wire" "wisdom" "wise" "wish" "with" "withdraw" "within" "without" "witness" "woman" "wonder" "wonderful" "wood" "wooden" "word" "work" "worker" "working" "works" "workshop" "world" "worried" "worry" "worth" "would" "wound" "wrap" "write" "writer" "writing" "wrong" "yard" "yeah" "year" "yell" "yellow" "yes" "yesterday" "yet" "yield" "you" "young" "your" "yours" "yourself" "youth" "zone")

  )

(defun find-common-prefix (match-prefix remaining-candidates)
  "With the MATCH-PREFIX try to see if the REMAINING-CANDIDATES could have
longer prefix and return it or just return MATCH-PREFIX"
  (format t "~&############################ finding prefix ~s candidates ~A~%"  match-prefix remaining-candidates )
  (let ((prefixes (remove-duplicates
                   (loop for rc in remaining-candidates
                         collect (if (> (length rc) (length match-prefix))
                                     (subseq rc 0 (1+ (length match-prefix)))
                                     rc))
                   :test #'equal)))
    (if (or (> (length prefixes) 1)
            (null remaining-candidates))
        match-prefix
        (find-common-prefix (first prefixes) remaining-candidates))))

(let ((match-prefix)
      (remaining-candidates)
      (selected))

  (defun autocomplete-start ()
    (setf
     match-prefix ""
     selected nil))

  (defun autocomplete (str key-name)

    (format t "%%% autocomplete %%%%%%%% ~S %%% ~S %%%%%%%%%%%%%~%" str key-name)

    (cond ((and (null str) key-name)
           (cond
             ((equalp "Escape" key-name)
              (setf match-prefix nil))
             ((equalp "Tab" key-name)
              (format t "~&$$$$$$$$$$$$$$$$$$$$$$$$  remaining ~A~%" remaining-candidates)
              (setf match-prefix
                    (find-common-prefix match-prefix remaining-candidates)))
             ((equalp "BackSpace" key-name)
              (setf match-prefix (butlast-string match-prefix)))
             ((equalp "Return" key-name)
              (setf selected match-prefix)
              (format t "selected >>>>> ~S~%" selected)
              (setf match-prefix nil))

             (t (error "not implemented ~s" key-name))))
          ((and str (null key-name))
           (setf match-prefix (format nil "~A~A" match-prefix str)))

          (t (error "Either str or key-name can be set")))

    (setf remaining-candidates
          (remove-if-not
           (lambda (x) (alexandria:starts-with-subseq match-prefix  x))
           (autocomplete-options)))

    (when (null selected)
      (format t "variables ===== ~S~%" (list 'match-prefix match-prefix
                                             'remaining  remaining-candidates
                                             'initials (remove-duplicates
                                                        (loop for c in remaining-candidates
                                                              collect (handler-case
                                                                          (elt c (length match-prefix))
                                                                        (t (hc)
                                                                          (format t "ERROR=== ~A~%" hc))))
                                                        :test #'equalp)
                                             'selected selected)))))

;;; key event handling1=========================================================
(defun key-event-modifiers (event)
  ;; all masks
  ;; (:SHIFT-MASK :CONTROL-MASK :ALT-MASK :ALTGR-MASK :SUPER-MASK)
  (mapcar
   (lambda (y)                          ;translate alts
     (cond ((eq y :MOD1-MASK) :ALT)
           ((eq y :SHIFT-MASK) :SHIFT)
           ((eq y :CONTROL-MASK) :CONTROL)
           ((eq y :MOD5-MASK) :ALTGR)
           ((eq y :SUPER-MASK) :SUPER)
           (t y)))
   (remove-if
    (lambda (x)
      (member x '(:MOD2-MASK :MOD4-MASK)))
    (gdk-event-key-state event))))

(defun gdk-event-key-key-press (event)
  (format t "----~A~%" event)
  (let ((kn (gdk-keyval-name (gdk-event-key-keyval event)))
        (km (key-event-modifiers event))
        (ks (gdk-event-key-string event)))
    (format t "Pressed ~s ~s - ~s~%" km ks kn)

    ;; send to autocomplete key nil OR nil modifier
    (cond ((and (equal "F1" kn)
                (null km))
           (format t "~&----help----~%" )
           (format t "Ctrl-a - autocomplete ~%"))
          ((and (equal km '(:CONTROL))
                (equal kn "a"))
           (format t "pressed Ctrl-a to autocomplete~%")
           (autocomplete-start))

          ((and (null km)
                (equal kn "Escape"))
           (format t "pressed Escape to cancel~%")
           (autocomplete nil kn))

          ((and (null km)
                (equal kn "Tab"))
           (format t "pressed Tab to complete~%")
           (autocomplete nil kn))
          ((and (null km)
                (equal kn "BackSpace"))
           (format t "pressed Backspace to undo~%")
           (autocomplete nil kn))
          ((and (null km)
                (equal kn "Return"))
           (format t "pressed Return to confirm~%")
           (autocomplete nil kn))
          (t
           (format t "ignored key ~s~%" kn)
           (autocomplete ks nil)))))

;;; key event handling2=========================================================

(defun win-event-fun (widget event)
  (declare (ignore widget))
  (format t "~&================== we have event ~s~%" (gdk-event-type event))
  (let ((handled))

    (typecase event
      (gdk-event-key (case (gdk-event-key-type event)
                       (:key-press  (handled (format t "key event key press~%")
                                             (gdk-event-key-key-press event))))))

    (unless handled
      (format t "=========the above event is not implemented=================~%~%~%"))))

;;; event for graceful closing of the window
(defun win-delete-event-fun (widget event)
  (declare (ignore widget))
  (format t "Delete Event Occured.~A~%" event)
  (if (zerop *do-not-quit*)
      (progn
        (format t "~&QUITTING~%")
        (leave-gtk-main)
        +gdk-event-propagate+)

      (progn
        (decf *do-not-quit*)
        (format t "more on close widget to go~A~% " (+ 1 *do-not-quit*))
        +gdk-event-stop+)))

;;; event handling helpers======================================================

;;; windows ====================================================================
(defun add-new-window (app)
  (let ((window (make-instance 'gtk-application-window
                               :application app
                               :title "New and better window"
                               :default-width 500
                               :default-height 300))
        (box (make-instance 'gtk-box
                            :border-width 1
                            :orientation :vertical
                            :spacing 1))
        (canvas (make-instance 'gtk-drawing-area
                               :width-request 500
                               :height-request 270)))

    ;; packing widgets
    (gtk-container-add window box)
    (gtk-box-pack-start box canvas)

    ;; signals

    ;; canvas events inherited from the widget
    (loop for ev in (list "configure-event"
                          "motion-notify-event"
                          "scroll-event"
                          "button-press-event"
                          "button-release-event")
       do (g-signal-connect canvas ev #'canvas-event-fun))
    ;; canvas events
    (g-signal-connect canvas "draw"
                      (lambda (widget context)
                        (draw-fun widget context)))

    (gtk-widget-add-events canvas '(:all-events-mask))

    ;; window events inherited form the widget
    (loop for ev in (list "key-press-event"
                          "key-release-event"
                          "enter-notify-event"
                          "leave-notify-event")
       do (g-signal-connect window ev #'win-event-fun))

    ;; Signal handler for closing the window and to handle the signal "delete-event".
    (g-signal-connect window "delete-event"  #'win-delete-event-fun)

    ;; finally show all widgets
    (gtk-widget-show-all window)))

(defvar *global-app* nil)
(defvar *do-not-quit* 3)
(defvar *model* nil)
;; https://www.gtk.org/docs/getting-started/hello-world/
(defun main-app ()
  (let ((argc 0)
        (argv (null-pointer)))
    (let ((app (gtk-application-new "try.window" :none)))
      (setf *global-app* app)
      (setf *do-not-quit* 2)
      (setf *model* nil)
      (g-signal-connect app "activate" #'add-new-window)
      (let ((status (g-application-run app argc argv)))
        (g-object-unref (pointer app))
        status))))

(defun debug-app ()
  "This allows me to interact with *model* using REPL"
  (setf *do-not-quit* 2)
  (setf *global-app*  (gtk-application-new "weeee" :none))
  ;; ==== we may not need this one === (g-application-register *global-app* nil)
  (g-application-activate *global-app*)
  (within-main-loop (add-new-window *global-app*)))

;;; after quitting run the following
;;; (g-object-unref (pointer *global-app*))


;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
;; (in-package :window)
;; (main-app)
