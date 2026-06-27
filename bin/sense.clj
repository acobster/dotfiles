#!/usr/bin/env bb

(require
  '[cheshire.core :as json]
  '[clojure.string :as string]
  '[clojure.java.shell :as shell])

(defn get-sensor-data []
  (-> (shell/sh "sensors" "-j")
      :out
      (string/replace #"NaN" "null")
      (json/parse-string true)))

(defn hostname []
  (-> (shell/sh "hostname")
      :out
      string/trim))

(def $profiles
  {"clementine"
   {:cpu-temp [:k10temp-pci-00c3 :Tctl :temp1_input]
    :fan1-rpm [:framework_laptop-isa-000f :fan1 :fan1_input]
    :fan2-rpm [:framework_laptop-isa-000f :fan2 :fan2_input]}})

(defn distill [profile data]
  (into {} (map (juxt key #(get-in data (val %)))) profile))

(comment
  (shell/sh "ls" "-l")
  (get-sensor-data)
  (distill (get $profiles "clementine") (get-sensor-data))
  (-main)
  ,)

(defn -main []
  (let [hostname' (hostname)
        profile (get $profiles hostname')
        _ (when-not profile (do
                              (println "No profile found for" hostname')
                              (System/exit 1)))
        {:keys [cpu-temp fan1-rpm fan2-rpm]}
        (distill profile (get-sensor-data))
        critical? (>= cpu-temp 85)
        temp-icon (if critical? "‼️" "✔️")]
    (println (format "%s  CPU temp: %.2f°C" temp-icon cpu-temp))
    (println "   Fan 1:" fan1-rpm "RPM")
    (println "   Fan 2:" fan2-rpm "RPM")))

(-main)
