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

(comment
  (shell/sh "ls" "-l")
  (get-sensor-data)
  (-main)
  ,)

(defn -main []
  (let [sensor-data (get-sensor-data)
        host (hostname)
        profile (get $profiles host)
        _ (when-not profile (do
                              (println "No profile found for" host)
                              (System/exit 1)))
        {:keys [cpu-temp fan1-rpm fan2-rpm]}
        (into {} (map (juxt key #(get-in sensor-data (val %))))
              (get $profiles "clementine"))]
    (println "CPU temp:" cpu-temp "°C")
    (println "Fan 1:" fan1-rpm "RPM")
    (println "Fan 2:" fan2-rpm "RPM")))

(-main)
