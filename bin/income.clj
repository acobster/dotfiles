#!/usr/bin/env bb
(ns income)


;; 10% 	Up to $9,950
;; 12% 	$9,951 to $40,525
;; 22% 	$40,526 to $86,375
;; 24% 	$86,376 to $164,925
;; 32% 	$164,926 to $209,425
;; 35% 	$209,426 to $523,600
;; 37% 	$523,601 or more

(def brackets-by-year
  {2021
   [[0 9950 0.10]
    [9951 40525 0.12]
    [40526 86375 0.22]
    [86376 164925 0.24]
    [164926 209425 0.32]
    [209426 523600 0.35]
    [523601 Integer/MAX_VALUE 0.37]]})

(defn -main [[salary]]
  (let [salary (Integer. salary)
        brackets (filter #(< (first %) salary)
                         (get brackets-by-year 2021))]
    (->>
      (reduce
        (fn [after-tax [lower upper rate]]
          (let [bracket-before-tax (- (min salary upper) lower)
                bracket-after-tax (* (- 1.0 rate) bracket-before-tax)]
            #_#_
            (prn (min salary upper) '- lower '= bracket-before-tax)
            (prn bracket-before-tax '* (- 1.0 rate) '= bracket-after-tax)
            ;; TODO format output
            (+ after-tax bracket-after-tax)))
        0 brackets)
      (format "%.0f")
      (Integer/parseInt))))


(comment
  (-main "1234")
  (-main 100000)
  (-main 120000)
  (-main 150000)
  (-main 200000)
  )

(-main *command-line-args*)
