(ns count-words.core
  (:use [seesaw.core])
  (:import  org.pushingpixels.substance.api.SubstanceLookAndFeel)
  (:require [clojure.string :as str])
  (:gen-class))

;; http://clojure-doc.org/articles/cookbooks/strings.html

(defn laf-selector []
  (horizontal-panel
    :items ["Substance skin: "
            (combobox
              :model (vals (SubstanceLookAndFeel/getAllSkins))
              :renderer (fn [this {:keys [value]}]
                          (text! this (.getClassName value)))
              :listen [:selection (fn [e]
                                      ; Invoke later because CB doens't like changing L&F while
                                      ; it's doing stuff.
                                      (invoke-later
                                        (-> e
                                          selection
                                          .getClassName
                                          SubstanceLookAndFeel/setSkin)))])]))

(def notes " This example shows the available Substance skins. Substance
is a set of improved look and feels for Swing. To use it in a project,
you'll need to add a dep to your Leiningen project:

[com.github.insubstantial/substance \"7.1\"]

In this example, the full class name of the current skin is shown the
in the combobox above. For your own apps you could either use a
selector like this example, or, more likely, set a default initial
skin in one of the following ways:

Start your VM with -Dswing.defaultlaf=<class-name>

Call (javax.swing.UIManager/setLookAndFeel \"<class-name>\")
do this *after* (seesaw.core/native!) since that sets the L&F.

See http://insubstantial.github.com/insubstantial/substance/docs/getting-started.html
for more info. There you'll also find much more info about the
skins along with much less crappy looking demos.")

(defn play-file [filename & opts]
  (let [fis (java.io.FileInputStream. filename)
        bis (java.io.BufferedInputStream. fis)
        player (javazoom.jl.player.Player. bis)]
    (if-let [synchronously (first opts)]
      (doto player
        (.play)
        (.close))
      (.start (Thread. #(doto player (.play) (.close)))))))

(defn -main [& args]
  (invoke-later
   (->
    (frame
     :title "Seesaw Substance/Insubstantial Example"
     :on-close :exit
     :content (vertical-panel
               :items [(laf-selector)
                       (text :multi-line? true :text notes :border 5)
                       :separator
                       (label :text "A Label")
                       (button :text "A Button"
                               :listen [:mouse-clicked (fn [e]  (alert (-> (java.io.File. ".") .getAbsolutePath)
                                                                       ))])
                       (button :text "Play sound clip"
                               :listen [:mouse-clicked (fn [e]  (play-file "/home/jacek/Audio/februar.mp3"))])
                       (button :text "About the system"
                               :listen [:mouse-clicked (fn [e]
                                                         (alert (str/join
                                                                 ["you are running "
                                                                  (-> (System/getProperties) (.get "os.name"))
                                                                  "\nand your home folder is "
                                                                  (-> (System/getProperties) (.get "user.home"))
                                                                  ])
                                                                ))])

                       (checkbox :text "A checkbox")
                       (combobox :model ["A combobox" "more" "items"])
                       (horizontal-panel
                        :border "Some radio buttons"
                        :items (map (partial radio :text)
                                    ["First" "Second" "Third"]))
                       (scrollable (listbox :model (range 100)))]))
    pack!
    show!)))
