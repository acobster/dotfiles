#!/usr/bin/env bb
(ns id3
  (:require
    [clojure.core.async :as async]
    [clojure.java.shell :refer [sh]]
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.tools.cli :as cli]))

(defn- quoted [& ss]
  (str "'" (apply str ss) "'"))

(defn- zero-pad [n ct]
  (let [len (- (count (str ct)) (count (str n)))
        zeros (apply str (repeat len "0"))]
    (str zeros n)))

(defn- output-name [in {:keys [ext track-count track-number number-tracks?]}]
  (let [filename (string/join "." (butlast (string/split in #"\.")))
        leftpad (when number-tracks?
                  (str (zero-pad track-number track-count) "-"))]
    (str leftpad (string/replace (string/lower-case (str filename "." ext))
                                 " " "-"))))

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
                        output-format
                        number-tracks?
                        track-number
                        track-count]}]
  (let [metadata-opts
        (reduce (fn [opts [k v]]
                  (if v
                    (concat opts ["-metadata" (quoted (name k) "=" v)])
                    opts))
                [] metadata)
        out (output-name in {:ext (name (or output-format "flac"))
                             :number-tracks? number-tracks?
                             :track-count track-count
                             :track-number track-number})
        command (concat
                  ["ffmpeg" "-y" "-i" in "-map" "0" "-write_id3v2" "1"]
                  metadata-opts
                  [out])]
    command))

(defn- run-commands! [run? cmds]
  (doseq [cmd cmds]
    (println (string/join " " cmd))
    (when run?
      (apply sh cmd)
      ;; TODO
      #_
      (let [{:keys [out err exit]} (apply sh cmd)]
        (when err (.write *err* (str "ERROR: " err)))
        (.write *out* out)))))

(def cli-options
  [["-h" "--help" "Show usage"]
   ["-a" "--artist ARTIST" "Artist"]
   ["-b" "--album ALBUM" "Album"]
   ["-c" "--track-count COUNT" "Track count (for x/COUNT track tag)"]
   [nil "--number-tracks" "Prefix output files with track number"
    :default false]
   [nil "--sort" "Sort by file name"]
   [nil "--dry-run" "Output commands to be run, but do not run them"]
   ["-f" "--output-format FORMAT" "Destination format"
    :default :flac]
   ["-t" "--track-file example.txt" "Description File"
    :validate [(comp boolean io/resource) "File not found"]]])

(defn main [args]
  (let [{:keys [options errors summary]} (cli/parse-opts args cli-options)]
    (cond
      errors
      (println "ERROR\n\n" (string/join "\n" errors))
      (:help options)
      (println summary)
      :default
      (let [lines (string/split (slurp *in*) #"\n")
            track-count (or (:track-count options) (count lines))]
        (->> lines
             (map-indexed
               (fn [idx line]
                 {:in line
                  :output-format (:output-format options)
                  :number-tracks? (:number-tracks options)
                  :track-count track-count
                  :track-number (or (extract-track-number line) (inc idx))
                  :metadata
                  {:artist (:artist options)
                   :album (:album options)
                   :track (str (inc idx) "/" track-count)}}))
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
