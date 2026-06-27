#!/usr/bin/env bb

(require '[cheshire.core :as json]
         '[clojure.string :as string]
         '[clojure.java.shell :as shell])

(defn get-temp [sensor]
  "Get temperature from sensor data, handling different key formats"
  (or (get sensor "temp1_input")
      (get sensor "input")
      0))

(defn get-rpm [sensor]
  "Get fan RPM from sensor data"
  (or (get sensor "fan1_input")
      (get sensor "rpm")
      0))

(comment
  (shell/sh "ls" "-l")
  (as-> (shell/sh "sensors" "-j") $
    (:out $)
    (string/replace $ #"NaN" "null")
    (json/parse-string $ true))
  (-main)
  ,)

(defn -main []
  (try
    (let [data (-> (shell/sh "sensors" "-j")
                   :out
                   (string/replace #"NaN" "null")
                   (json/parse-string true))]
      (doseq [[device-name device] data
              :let [sensors (vals device)
                    temps (filter some? (map get-temp sensors))
                    rpms (filter some? (map get-rpm sensors))
                    coretemps (filter (fn [t] (<= 20 t 100)) temps)
                    current rpms]]
        (when (or coretemps current)
          (println (str device-name ":"))
          (when coretemps
            (doseq [t coretemps]
              (println (format "  Core: %.1f°C" (/ t 1000.0)))))
          (when current
            (doseq [r current]
              (println (format "  Fan: %d RPM" r)))))))
    (catch Exception e
      (println "Error reading sensors:" (.getMessage e))
      (System/exit 1))))

(-main)
