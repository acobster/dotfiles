#!/usr/bin/env bb

;; an example script written in Babashka
;; https://github.com/borkdude/babashka/

(require '[clojure.test :as t])

(t/deftest test-test
  ;; fix this to get passing tests!
  (t/is (true? true)))

(t/run-tests)
