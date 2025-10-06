#!/usr/bin/env bb
(ns add
  (:require
    [clojure.core.async :as async]
    [clojure.java.shell :refer [sh]]
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.tools.cli :as cli])
  (:import
    [java.util.zip ZipFile]
    [java.io File]))

(defn- extract-zip [zip-file dest-dir]
  (.mkdirs dest-dir)
  (try
    (doseq [entry (enumeration-seq (.entries zip-file))]
      (let [entry-name (.getName entry)
            output-file (io/file dest-dir entry-name)]
        (with-open [input (.getInputStream zip-file entry)]
          (io/copy input output-file))))
    (.close zip-file)
    (.getAbsolutePath dest-dir)
    (catch Throwable ex
      (.close zip-file))))

(defn- extract-all [extractions]
  (doall (map deref (map (fn [{:keys [archive dest]}]
                           (future (extract-zip archive dest)))
                         extractions))))

(def cli-options
  [["-h" "--help" "Show usage"]
   ["-l" "--delimiter DELIM"
    "Delimiter string, to parse 'ARTIST NAME - ALBUM NAME' from archive title"
    :default " - "]
   [nil "--dry-run" "Output commands to be run, but do not run them"]
   ["-s" "--source DIR" "Source directory" :default "."]
   ["-d" "--dest DIR" "Destination directory" :default "."]
   ["-e" "--ext EXT" "File extension to match on" :default ".zip"]])

(defn main [& args]
  (let [{:keys [options errors summary]} (cli/parse-opts args cli-options)]
    (cond
      errors
      (println "ERROR\n\n" (string/join "\n" errors))
      (:help options)
      (println summary)
      :default
      (let [{:keys [source delimiter dest ext]} options
            archives (filter #(.endsWith (.getName %) ".zip")
                             (file-seq (io/file source)))
            extractions (map (fn [file]
                               (let [archive-path (.getName file)
                                     extract-dirname (string/replace archive-path ext "")
                                     splits (string/split extract-dirname (re-pattern delimiter))
                                     dest-dir (io/file (string/join "/" (cons dest splits)))]
                                 {
                                  :archive (ZipFile. file)
                                  :dest dest-dir}))
                             archives)]
        (extract-all extractions)))))

(comment

  (main "--source" "/home/tamayo/Downloads" "--dest" "/home/tamayo/Sync/music")

  ,)

(main *command-line-args*)
