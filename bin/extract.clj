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
      (.close zip-file)
      nil)))

(defn- extract-all [extractions]
  (doall (map deref (map (fn [{:keys [archive archive-file delete? dest]}]
                           (future
                             (let [extracted (extract-zip archive dest)]
                               (when (and extracted delete?)
                                 (io/delete-file archive-file))
                               extracted)))
                         extractions))))

(def cli-options
  [["-h" "--help" "Show usage"]
   ["-l" "--delimiter DELIM"
    "Delimiter string, to parse 'ARTIST NAME - ALBUM NAME' from archive title"
    :default " - "]
   [nil "--dry-run" "Output commands to be run, but do not run them"]
   ["-s" "--source DIR" "Source directory" :default "."]
   ["-d" "--dest DIR" "Destination directory" :default "."]
   ["-e" "--ext EXT" "File extension to match on" :default ".zip"]
   [nil "--delete" "Delete archives"]])

(defn main [args]
  (let [{:keys [options errors summary]} (cli/parse-opts args cli-options)]
    (cond
      errors
      (println "ERROR\n\n" (string/join "\n" errors))
      (:help options)
      (println summary)
      :default
      (let [{:keys [delimiter delete dest dry-run ext source]} options
            archives (filter #(.endsWith (.getName %) ".zip")
                             (file-seq (io/file source)))
            extractions (map (fn [file]
                               (let [archive-path (.getName file)
                                     extract-dirname (string/replace archive-path ext "")
                                     splits (string/split extract-dirname (re-pattern delimiter))
                                     dest-dir (io/file (string/join "/" (cons dest splits)))]
                                 {:archive (ZipFile. file)
                                  :archive-file file
                                  :dest dest-dir
                                  :delete? delete}))
                             archives)]
        (if dry-run
          (doseq [{:keys [dest]} extractions]
            (println (.getAbsolutePath dest)))
          (doseq [extracted (extract-all extractions)]
            (println extracted)))))))

(comment

  (main ["--source" "/home/tamayo/Downloads" "--dest" "/home/tamayo/Sync/music"])
  (main ["--dry-run" "--source" "/home/tamayo/Downloads" "--dest" "/home/tamayo/Sync/music"])
  (main ["--delete" "--source" "/home/tamayo/Downloads" "--dest" "/home/tamayo/Downloads/test"])

  ,)

(main *command-line-args*)
