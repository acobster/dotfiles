#!/usr/bin/env bb
(ns id3
  (:require
    [clojure.core.async :as async]
    [clojure.java.shell :refer [sh]]
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.tools.cli :as cli]))

(defn- zero-pad [n ct]
  (let [len (- (count (str ct)) (count (str n)))
        zeros (apply str (repeat len "0"))]
    (str zeros n)))

(defn- regex [s]
  (java.util.regex.Pattern/compile s))

(defn- output-name [in {:keys [dir
                               ext
                               track-count
                               track-number
                               number-tracks?]}]
  (let [dirpath (when (seq dir)
                  (str dir java.io.File/separator))
        leftpad (when number-tracks?
                  (str (zero-pad track-number track-count) "-"))
        basename (last (string/split in (regex java.io.File/separator)))
        filename (string/join "." (butlast (string/split basename #"\.")))
        renamed (string/replace (string/lower-case (str filename "." ext))
                                " " "-")]
    (str leftpad (string/replace (string/lower-case (str filename "." ext))
                                 " " "-"))
    (str dirpath leftpad renamed)))

(defn- to-int [s]
  (try
    (Integer/parseInt s)
    (catch Throwable _ nil)))

(defn- extract-track-number [s]
  (reduce (fn [_ s]
            (when-let [i (to-int s)]
              (reduced i)))
          (string/split s #"( |-|\.)+")))

(defn- maybe-sort-by-track-number [sort? tracks]
  (if sort? (sort-by :track-number tracks) tracks))

;; ffmpeg -i Track\ 2.wav -map 0 -write_id3v2 1 -metadata 'artist=Mark Isham' -metadata 'album=Tibet' -metadata 'track=2/5' -metadata 'title=Part II' -y 02.flac
(defn- convert [{:keys [in
                        metadata
                        dir
                        output-format
                        number-tracks?
                        track-number
                        track-count
                        track-titles]}]
  (let [metadata-opts
        (reduce (fn [opts [k v]]
                  (if v
                    (concat opts ["-metadata" [(name k) "=" v]])
                    opts))
                [] metadata)
        out (output-name in {:dir dir
                             :ext (name (or output-format "flac"))
                             :number-tracks? number-tracks?
                             :track-count track-count
                             :track-number track-number})
        command (concat
                  ["ffmpeg" "-y" "-i" [in] "-map" "0" "-write_id3v2" "1"]
                  metadata-opts
                  [out])]
    command))

(defn- quoted [ss]
  (str "'" (apply str ss) "'"))

(defn- run-commands! [run? cmds]
  (doseq [cmd cmds]
    (let [human-readable (map #(if (vector? %) (quoted %) %) cmd)
          cmd (map #(if (vector? %) (apply str %) %) cmd)]
      (println (string/join " " human-readable))
      (when run?
        ;; TODO real error handling and such...
        (apply sh cmd)))))

(def cli-options
  [["-h" "--help" "Show usage"]
   ["-a" "--artist ARTIST" "Artist"]
   ["-b" "--album ALBUM" "Album"]
   ["-c" "--track-count COUNT" "Track count (for x/COUNT track tag)"]
   [nil "--number-tracks" "Prefix output files with track number"
    :default false]
   [nil "--sort" "Sort by file name"]
   [nil "--dry-run" "Output commands to be run, but do not run them"]
   ["-f" "--output-format FORMAT" "destination format"
    :default :flac]
   ["-d" "--dir DIR" "destination directory"
    :default "."]
   ["-t" "--tracks-file example.txt" "Tracks file (track titles, in order)"
    :validate [(comp boolean slurp) "File not found"]]])

(defn main [args]
  (let [{:keys [options errors summary]} (cli/parse-opts args cli-options)]
    (cond
      errors
      (println "ERROR\n\n" (string/join "\n" errors))
      (:help options)
      (println summary)
      :default
      (let [lines (string/split (slurp *in*) #"\n")
            track-titles (when (:tracks-file options)
                           (into {} (map-indexed
                                      #(vector %1 %2)
                                      (string/split
                                        (slurp (:tracks-file options))
                                        #"\n"))))
            track-count (or (:track-count options) (count lines))]
        (->> lines
             (map-indexed
               (fn [idx line]
                 (let [track-number (or (extract-track-number line) (inc idx))]
                   {:in line
                    :dir (:dir options)
                    :output-format (:output-format options)
                    :number-tracks? (:number-tracks options)
                    :track-count track-count
                    :track-number track-number
                    :metadata
                    {:artist (:artist options)
                     :album (:album options)
                     :track (str (inc idx) "/" track-count)
                     :title (when track-titles
                              (get track-titles (dec track-number)))}})))
             (maybe-sort-by-track-number (:sort options))
             (map convert)
             (run-commands! (not (:dry-run options))))))))

(comment
  (last (convert {:in "Track 1.wav"
            :metadata {:artist "A Perfect Circle"
                       :album "The Thirteenth Step"
                       :track 1/12}
            :track-number 1
            :track-count 12
            :output-format :flac}))

  (extract-track-number "Track 01.wav")
  (extract-track-number "Track 10.wav")
  (extract-track-number "Track 11.wav")
  (extract-track-number "Track xyz")
  (try
    (Integer/parseInt "Track ")
    (catch Throwable _ nil))
  (Integer/parseInt "01")

  (io/resource "hi.txt")
  (string/join " " ["a" "b" "c"]))

(main *command-line-args*)
